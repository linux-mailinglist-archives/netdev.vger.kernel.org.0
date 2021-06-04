Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E5439B19B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 06:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFDEth convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 4 Jun 2021 00:49:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60630 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhFDEtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 00:49:36 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lp1kF-0005S6-QJ; Fri, 04 Jun 2021 04:47:44 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2C3695FBC1; Thu,  3 Jun 2021 21:47:42 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 25055A040B;
        Thu,  3 Jun 2021 21:47:42 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     zhudi <zhudi21@huawei.com>
cc:     vfalico@gmail.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, rose.chen@huawei.com
Subject: Re: [PATCH v2] bonding: 3ad: fix a crash in agg_device_up()
In-reply-to: <20210604021420.49972-1-zhudi21@huawei.com>
References: <20210604021420.49972-1-zhudi21@huawei.com>
Comments: In-reply-to zhudi <zhudi21@huawei.com>
   message dated "Fri, 04 Jun 2021 10:14:20 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7666.1622782062.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Thu, 03 Jun 2021 21:47:42 -0700
Message-ID: <7667.1622782062@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhudi <zhudi21@huawei.com> wrote:

>From: Di Zhu <zhudi21@huawei.com>
>
>When doing the test of restarting the network card, the system is
>broken because the port->slave is null pointer in agg_device_up().
>After in-depth investigation, we found the real cause: in
>bond_3ad_unbind_slave()  if there are no active ports in the
>aggregator to be deleted, the ad_clear_agg() will be called to
>set "aggregator->lag_ports = NULL", but the ports originally
>belonging to the aggregator are still linked together.

	Presumably by "no active ports" you refer to the following block
near the end of bond_3ad_unbind_slave() (where a port being deleted is
removed from an aggregator):

				if (prev_port)
					prev_port->next_port_in_aggregator = temp_port->next_port_in_aggregator;
				else
					temp_aggregator->lag_ports = temp_port->next_port_in_aggregator;
				temp_aggregator->num_of_ports--;
				if (__agg_active_ports(temp_aggregator) == 0) {
					select_new_active_agg = temp_aggregator->is_active;
					ad_clear_agg(temp_aggregator);
					if (select_new_active_agg) {
						slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
						/* select new active aggregator */
						ad_agg_selection_logic(__get_first_agg(port),
							               &dummy_slave_update);


	by what mechanism are you causing the ports within a particular
aggregator to all be inactive (port->is_enabled == false)?  Am I correct
in speculating that you're removing carrier from "port1" and "port3"
while simultaneously removing "port2" from the bond?  I believe this
would all need to occur within a single gap between passes of the state
machine logic.

	The logic in bond_3ad_handle_link_change() that sets
port->is_enabled = false happens on link state change, and is
immediately followed (under the same acquisition of bond->mode_lock) by
a call to ad_agg_selection_logic().  So, in principle, when the port is
set to inactive (is_enabled == false), it should be reselected to a
different aggregator (likely as an individual port) on the next run of
the state machine.

>Before bond_3ad_unbind_slave():
>	aggregator4->lag_ports = port1->port2->port3
>After bond_3ad_unbind_slave():
>	aggregator4->lag_ports = NULL
>	port1->port2->port3
>
>After the port2 is deleted, the port is still  remain in the linked
>list: because the port does not belong to any agg, so unbind do
>nothing for this port.
>
>After a while, bond_3ad_state_machine_handler() will run and
>traverse each existing port, trying to bind each port to the
>newly selected agg, such as:
>	if (!found) {
>		if (free_aggregator) {
>			...
>			port->aggregator->lag_ports = port;
>			...
>		}
>	}
>After this operation, the link list looks like this:
>	 aggregator1->lag_ports = port1->port2(has been deleted)->port3
>
>After that, just traverse the linked list of agg1 and access the
>port2->slave, the crash will happen.
>
>The easiest way to fix it is: if a port does not belong to any agg, delete
>it from the list and wait for the state machine to select the agg again.

	As I understand the above, the bug causes a deleted (freed)
object to be left on the linked list (port1 -> port2 -> port3 in the
above).  I'm not quite sure how the code block above allows this to
happen, as the port being deleted is unlinked (at the top of the code
block).

	In any event, assuming that I'm missing something and it does
leave the freed port in the list, this fix may be the easiest, but I
don't believe it's correct, as it leaves opportunity for something else
to traverse the linked list and dereference the freed element.

	The code sample I included above occurs immediately after
removing a port from the aggregator's list of ports, and, in light of
your analysis (and assuming I've got the correct code block above), I
believe that the "__agg_active_ports(temp_aggregator) == 0" test should
really test to determine if there are no ports at all in the aggregator
(i.e., temp_aggregator->num_of_ports == 0), not only test for active
ports.  This way, if any ports remain in the aggregator, then
ad_clear_agg() would not be called, and the linked list would not end up
detached.

	Comments?

	-J

>Fixes: 0622cab0341c ("bonding: fix 802.3ad aggregator reselection")
>Signed-off-by: Di Zhu <zhudi21@huawei.com>
>---
>/* v2 */
>-David Miller <davem@davemloft.net>
> -add Fixes: tag
>---
> drivers/net/bonding/bond_3ad.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
>index 6908822d9773..1d6ff4e1ed28 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -1793,6 +1793,8 @@ static void ad_agg_selection_logic(struct aggregator *agg,
> static void ad_clear_agg(struct aggregator *aggregator)
> {
> 	if (aggregator) {
>+		struct port *port, *next;
>+
> 		aggregator->is_individual = false;
> 		aggregator->actor_admin_aggregator_key = 0;
> 		aggregator->actor_oper_aggregator_key = 0;
>@@ -1801,6 +1803,11 @@ static void ad_clear_agg(struct aggregator *aggregator)
> 		aggregator->partner_oper_aggregator_key = 0;
> 		aggregator->receive_state = 0;
> 		aggregator->transmit_state = 0;
>+		for (port = aggregator->lag_ports; port; port = next) {
>+			next = port->next_port_in_aggregator;
>+			if (port->aggregator == aggregator)
>+				port->next_port_in_aggregator = NULL;
>+		}
> 		aggregator->lag_ports = NULL;
> 		aggregator->is_active = 0;
> 		aggregator->num_of_ports = 0;
>-- 
>2.23.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

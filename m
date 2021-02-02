Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6682930CCA9
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 21:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240351AbhBBUDI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Feb 2021 15:03:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34043 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240185AbhBBUDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 15:03:01 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1l71sJ-0004r9-Mo; Tue, 02 Feb 2021 20:02:11 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id CC9F95FEE8; Tue,  2 Feb 2021 12:02:09 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id C72DFA0411;
        Tue,  2 Feb 2021 12:02:09 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Aichun Li <liaichun@huawei.com>
cc:     davem@davemloft.net, kuba@kernel.org, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org, rose.chen@huawei.com,
        moyufeng <moyufeng@huawei.com>
Subject: Re: [PATCH net v2]bonding: check port and aggregator when select
In-reply-to: <20210128082034.866-1-liaichun@huawei.com>
References: <20210128082034.866-1-liaichun@huawei.com>
Comments: In-reply-to Aichun Li <liaichun@huawei.com>
   message dated "Thu, 28 Jan 2021 16:20:34 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19741.1612296129.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 02 Feb 2021 12:02:09 -0800
Message-ID: <19742.1612296129@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aichun Li <liaichun@huawei.com> wrote:

>When the network service is repeatedly restarted in 802.3ad, there is a low
> probability that oops occurs.
>Test commands:systemctl restart network
>
>1.crash: __enable_port():port->slave is NULL
[...]
>     PC: ffff000000e2fcd0  [ad_agg_selection_logic+328]
[...]
>2.I also have another call stack, same as in another person's post:
>https://lore.kernel.org/netdev/52630cba-cc60-a024-8dd0-8319e5245044@huawei.com/

	What hardware platform are you using here?

	moyufeng <moyufeng@huawei.com> appears to be using the same
platform, and I've not had any success so far with the provided script
to reproduce the issue.  I'm using an x86_64 system, however, so I
wonder if perhaps this platform needs a barrier somewhere that x86 does
not, or there's something different in the timing of the device driver
close logic.

>Signed-off-by: Aichun Li <liaichun@huawei.com>
>---
> drivers/net/bonding/bond_3ad.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
>index aa001b16765a..9c8894631bdd 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -183,7 +183,7 @@ static inline void __enable_port(struct port *port)
> {
> 	struct slave *slave = port->slave;
> 
>-	if ((slave->link == BOND_LINK_UP) && bond_slave_is_up(slave))
>+	if (slave && (slave->link == BOND_LINK_UP) && bond_slave_is_up(slave))
> 		bond_set_slave_active_flags(slave, BOND_SLAVE_NOTIFY_LATER);
> }

	This change seems like a band aid to cover the real problem.
The caller of __enable_port is ad_agg_selection_logic, and it shouldn't
be possible for port->slave to be NULL when assigned to an aggregator.

>@@ -1516,6 +1516,7 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
> 				  port->actor_port_number,
> 				  port->aggregator->aggregator_identifier);
> 		} else {
>+			port->aggregator = &(SLAVE_AD_INFO(slave)->aggregator);
> 			slave_err(bond->dev, port->slave->dev,
> 				  "Port %d did not find a suitable aggregator\n",
> 				  port->actor_port_number);

	This change isn't correct; it's assigning the port to a more or
less random aggregator.  This would eliminate the panic, but isn't doing
the right thing.  At this point in the code, the selection logic has
failed to find an aggregator that matches, and also failed to find a
free aggregator.

	I do need to fix up the failure handling here when it hits the
"did not find a suitable agg" case; the code here is simply wrong, and
has been wrong since the beginning.  I'll hack the driver to induce this
situation rather than reproducing whatever problem is making it unable
to find a suitable aggregator.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878663305E8
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 03:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhCHCcz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 7 Mar 2021 21:32:55 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3039 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhCHCca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 21:32:30 -0500
Received: from nkgeml707-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Dv2Py6NXPzRMfq;
        Mon,  8 Mar 2021 10:30:46 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 nkgeml707-chm.china.huawei.com (10.98.57.157) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 8 Mar 2021 10:32:22 +0800
Received: from dggpemm500021.china.huawei.com ([7.185.36.109]) by
 dggpemm500021.china.huawei.com ([7.185.36.109]) with mapi id 15.01.2106.013;
 Mon, 8 Mar 2021 10:32:22 +0800
From:   "zhudi (J)" <zhudi21@huawei.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Subject: Re: [PATCH] bonding: 3ad: fix a use-after-free in
 bond_3ad_state_machine_handle
Thread-Topic: [PATCH] bonding: 3ad: fix a use-after-free in
 bond_3ad_state_machine_handle
Thread-Index: AdcTt7PfxpAZE/IOSYC467Jxkow//g==
Date:   Mon, 8 Mar 2021 02:32:22 +0000
Message-ID: <70169de1827347468003465cd12cdc6c@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.114.155]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >From: Di Zhu <zhudi21@huawei.com>
> >
> >I use the similar test method described in link below with KASAN enabled:
> >https://lore.kernel.org/netdev/4c5e467e07fb410ab4135b391d663ec1@hua
> wei.
> >com/
> >soon after, KASAN reports:
> >[ 9041.977110]
> >=========================================================
> =========
> >[ 9041.977151] BUG: KASAN: use-after-free in
> >bond_3ad_state_machine_handler+0x1c34/0x20b0 [bonding]
> 
> 	What line of code is this?

Around  line 1022 in current net-next , bond_3ad_state_machine_handler()->ad_mux_machine():
	} else {
				/* if port state hasn't changed make
				 * sure that a collecting distributing
				 * port in an active aggregator is enabled
				 */
				if (port->aggregator &&
-------------------->		port->aggregator->is_active &&
				    !__port_is_enabled(port)) {

					__enable_port(port);
				}
			}

the aggregator pointed by port->aggregator has released

> 
> >[ 9041.977156] Read of size 2 at addr ffff80394b8d70b0 by task
> >kworker/u192:2/78492
> >
> >[ 9041.977187] Workqueue: bond0 bond_3ad_state_machine_handler
> >[bonding] [ 9041.977190] Call trace:
> >[ 9041.977197]  dump_backtrace+0x0/0x310 [ 9041.977201]
> >show_stack+0x28/0x38 [ 9041.977207]  dump_stack+0xec/0x15c [
> >9041.977213]  print_address_description+0x68/0x2d0
> >[ 9041.977217]  kasan_report+0x130/0x2f0 [ 9041.977221]
> >__asan_load2+0x80/0xa8 [ 9041.977238]
> >bond_3ad_state_machine_handler+0x1c34/0x20b0 [bonding]
> >
> >[ 9041.977261] Allocated by task 138336:
> >[ 9041.977266]  kasan_kmalloc+0xe0/0x190 [ 9041.977271]
> >kmem_cache_alloc_trace+0x1d8/0x468
> >[ 9041.977288]  bond_enslave+0x514/0x2160 [bonding] [ 9041.977305]
> >bond_option_slaves_set+0x188/0x2c8 [bonding] [ 9041.977323]
> >__bond_opt_set+0x1b0/0x740 [bonding]
> >
> >[ 9041.977420] Freed by task 105873:
> >[ 9041.977425]  __kasan_slab_free+0x120/0x228 [ 9041.977429]
> >kasan_slab_free+0x10/0x18 [ 9041.977432]  kfree+0x90/0x468 [
> >9041.977448]  slave_kobj_release+0x7c/0x98 [bonding] [ 9041.977452]
> >kobject_put+0x118/0x328 [ 9041.977468]
> __bond_release_one+0x688/0xa08
> >[bonding] [ 9041.977660]  pci_device_remove+0x80/0x198
> >
> >The root cause is that in bond_3ad_unbind_slave() the last step is
> >detach the port from aggregator including it. if find this aggregator
> >and it has not any active ports, it will call ad_clear_agg() to do
> >clear things, especially set aggregator->lag_ports = NULL.
> 
> 	By "last step," are you referring to the following logic near the end of
> bond_3ad_unbind_slave(), around line 2229 in the current net-next?
> 
> 				temp_aggregator->num_of_ports--;
> 				if (__agg_active_ports(temp_aggregator) ==
> 0) {
> 					select_new_active_agg =
> temp_aggregator->is_active;
> 					ad_clear_agg(temp_aggregator);
> 					if (select_new_active_agg) {
> 

	Yes,  it is right
> 
> >But ports in aggregator->lag_ports list which is set to NULL previously
> >still has pointer to this aggregator through  port->aggregator, event
> >after this aggregator has released.
> 
> 	This, I think, is the real problem.  If aggregator->num_of_ports is zero,
> then there should not be any port->aggregator pointing to it.
> 
> >The use-after-free problem will cause some puzzling situactions, i am
> >not sure whether fix this problem can solve all the problems mentioned
> >by the link described earlier, but it did solve all problems i encountered.
> 
> 	I'm not sure, either, although the issues may be related somehow.
> I've been testing with the following, but in light of this patch, I'm not sure
> that mine is an actual fix, either, since I'm not able to reproduce the actual
> issue and have forced it.  Or maybe there are multiple issues here.
> 
	Maybe the issue your patch want to fix is likely another one from the point 
of view of code logic. we are still testing with the patch I submitted to see whether
all the problems have been dealt with. The recurrence probability is relatively low, 
so need a long time...

> diff --git a/drivers/net/bonding/bond_3ad.c
> b/drivers/net/bonding/bond_3ad.c index 6908822d9773..546adda42715
> 100644
> --- a/drivers/net/bonding/bond_3ad.c
> +++ b/drivers/net/bonding/bond_3ad.c
> @@ -1537,6 +1537,12 @@ static void ad_port_selection_logic(struct port
> *port, bool *update_slave_arr)
>  			slave_err(bond->dev, port->slave->dev,
>  				  "Port %d did not find a suitable
> aggregator\n",
>  				  port->actor_port_number);
> +
> +			port->sm_vars |= AD_PORT_BEGIN;
> +			aggregator = __get_first_agg(port);
> +			ad_agg_selection_logic(aggregator,
> update_slave_arr);
> +
> +			return;
>  		}
>  	}
>  	/* if all aggregator's ports are READY_N == TRUE, set ready=TRUE
> --
> 2.17.1
> 
> 	-J
> 
> >Signed-off-by: Di Zhu <zhudi21@huawei.com>
> >---
> > drivers/net/bonding/bond_3ad.c | 6 ++++++
> > 1 file changed, 6 insertions(+)
> >
> >diff --git a/drivers/net/bonding/bond_3ad.c
> >b/drivers/net/bonding/bond_3ad.c index 6908822d9773..5d5a903e899c
> >100644
> >--- a/drivers/net/bonding/bond_3ad.c
> >+++ b/drivers/net/bonding/bond_3ad.c
> >@@ -1793,6 +1793,8 @@ static void ad_agg_selection_logic(struct
> >aggregator *agg,  static void ad_clear_agg(struct aggregator
> >*aggregator)  {
> > 	if (aggregator) {
> >+		struct port *port;
> >+
> > 		aggregator->is_individual = false;
> > 		aggregator->actor_admin_aggregator_key = 0;
> > 		aggregator->actor_oper_aggregator_key = 0; @@ -1801,6
> +1803,10 @@
> >static void ad_clear_agg(struct aggregator *aggregator)
> > 		aggregator->partner_oper_aggregator_key = 0;
> > 		aggregator->receive_state = 0;
> > 		aggregator->transmit_state = 0;
> >+		for (port = aggregator->lag_ports; port;
> >+				port = port->next_port_in_aggregator)
> >+			if (port->aggregator == aggregator)
> >+				port->aggregator = NULL;
> > 		aggregator->lag_ports = NULL;
> > 		aggregator->is_active = 0;
> > 		aggregator->num_of_ports = 0;
> >--
> >2.23.0
> >
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com

Thanks

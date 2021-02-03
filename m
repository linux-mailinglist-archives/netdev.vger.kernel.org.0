Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126FD30D119
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 02:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhBCBzf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Feb 2021 20:55:35 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3414 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhBCBzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 20:55:35 -0500
Received: from nkgeml707-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4DVl8F3jWrz5NsS;
        Wed,  3 Feb 2021 09:53:33 +0800 (CST)
Received: from dggeme752-chm.china.huawei.com (10.3.19.98) by
 nkgeml707-chm.china.huawei.com (10.98.57.157) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 09:54:51 +0800
Received: from dggeme752-chm.china.huawei.com ([10.6.80.76]) by
 dggeme752-chm.china.huawei.com ([10.6.80.76]) with mapi id 15.01.2106.006;
 Wed, 3 Feb 2021 09:54:51 +0800
From:   liaichun <liaichun@huawei.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>,
        moyufeng <moyufeng@huawei.com>
Subject: Re: [PATCH net v2]bonding: check port and aggregator when select
Thread-Topic: [PATCH net v2]bonding: check port and aggregator when select
Thread-Index: Adb5zAua4g+nQQYWRZWIIJvVf3Uhmw==
Date:   Wed, 3 Feb 2021 01:54:50 +0000
Message-ID: <4c5e467e07fb410ab4135b391d663ec1@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.112.224]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Aichun Li <liaichun@huawei.com> wrote:
> 
> >When the network service is repeatedly restarted in 802.3ad, there is a
> >low  probability that oops occurs.
> >Test commands:systemctl restart network
> >
> >1.crash: __enable_port():port->slave is NULL
> [...]
> >     PC: ffff000000e2fcd0  [ad_agg_selection_logic+328]
> [...]
> >2.I also have another call stack, same as in another person's post:
> >https://lore.kernel.org/netdev/52630cba-cc60-a024-8dd0-8319e5245044@hu
> a
> >wei.com/
> 
> 	What hardware platform are you using here?
> 
> 	moyufeng <moyufeng@huawei.com> appears to be using the same
> platform, and I've not had any success so far with the provided script to
> reproduce the issue.  I'm using an x86_64 system, however, so I wonder if
> perhaps this platform needs a barrier somewhere that x86 does not, or there's
> something different in the timing of the device driver close logic.
	Yes, I'm using an arm64 system.
    And i'm different from moyufeng. I'm a physical machine, and he's a virtual
 machine.
> 
> >Signed-off-by: Aichun Li <liaichun@huawei.com>
> >---
> > drivers/net/bonding/bond_3ad.c | 3 ++-
> > 1 file changed, 2 insertions(+), 1 deletion(-)
> >
> >diff --git a/drivers/net/bonding/bond_3ad.c
> >b/drivers/net/bonding/bond_3ad.c index aa001b16765a..9c8894631bdd
> >100644
> >--- a/drivers/net/bonding/bond_3ad.c
> >+++ b/drivers/net/bonding/bond_3ad.c
> >@@ -183,7 +183,7 @@ static inline void __enable_port(struct port *port)
> >{
> > 	struct slave *slave = port->slave;
> >
> >-	if ((slave->link == BOND_LINK_UP) && bond_slave_is_up(slave))
> >+	if (slave && (slave->link == BOND_LINK_UP) &&
> >+bond_slave_is_up(slave))
> > 		bond_set_slave_active_flags(slave, BOND_SLAVE_NOTIFY_LATER); }
> 
> 	This change seems like a band aid to cover the real problem.
> The caller of __enable_port is ad_agg_selection_logic, and it shouldn't be
> possible for port->slave to be NULL when assigned to an aggregator.
> 
> >@@ -1516,6 +1516,7 @@ static void ad_port_selection_logic(struct port
> *port, bool *update_slave_arr)
> > 				  port->actor_port_number,
> > 				  port->aggregator->aggregator_identifier);
> > 		} else {
> >+			port->aggregator = &(SLAVE_AD_INFO(slave)->aggregator);
> > 			slave_err(bond->dev, port->slave->dev,
> > 				  "Port %d did not find a suitable aggregator\n",
> > 				  port->actor_port_number);
> 
> 	This change isn't correct; it's assigning the port to a more or less random
> aggregator.  This would eliminate the panic, but isn't doing the right thing.
> At this point in the code, the selection logic has failed to find an aggregator
> that matches, and also failed to find a free aggregator.
> 
> 	I do need to fix up the failure handling here when it hits the "did not find a
> suitable agg" case; the code here is simply wrong, and has been wrong since
> the beginning.  I'll hack the driver to induce this situation rather than
> reproducing whatever problem is making it unable to find a suitable
> aggregator.
	
    Thank you for your reply and look forward to your solution.
> 
> 	-J
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com

---
	-Aichun Li <liaichun@huawei.com>


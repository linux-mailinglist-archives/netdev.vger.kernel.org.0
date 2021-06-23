Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58C13B1193
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 04:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhFWCNy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Jun 2021 22:13:54 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:8310 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhFWCNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 22:13:54 -0400
Received: from nkgeml705-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G8mqj3L02z7179;
        Wed, 23 Jun 2021 10:07:29 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 nkgeml705-chm.china.huawei.com (10.98.57.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 10:11:35 +0800
Received: from dggpemm500021.china.huawei.com ([7.185.36.109]) by
 dggpemm500021.china.huawei.com ([7.185.36.109]) with mapi id 15.01.2176.012;
 Wed, 23 Jun 2021 10:11:34 +0800
From:   "zhudi (J)" <zhudi21@huawei.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     "vfalico@gmail.com" <vfalico@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Subject: Re: [PATCH] bonding: avoid adding slave device with IFF_MASTER flag
Thread-Topic: [PATCH] bonding: avoid adding slave device with IFF_MASTER flag
Thread-Index: Addn09ZA/E4WbBHCRzmFDVcPTfcbog==
Date:   Wed, 23 Jun 2021 02:11:34 +0000
Message-ID: <fad7ab99d95645698717df1d79b247f3@huawei.com>
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

> 
> >From: Di Zhu <zhudi21@huawei.com>
> >
> >The following steps will definitely cause the kernel to crash:
> >	ip link add vrf1 type vrf table 1
> >	modprobe bonding.ko max_bonds=1
> >	echo "+vrf1" >/sys/class/net/bond0/bonding/slaves
> >	rmmod bonding
> >
> >The root cause is that: When the VRF is added to the slave device,
> >it will fail, and some cleaning work will be done. because VRF device
> >has IFF_MASTER flag, cleanup process  will not clear the IFF_BONDING flag.
> >Then, when we unload the bonding module,
> unregister_netdevice_notifier()
> >will treat the VRF device as a bond master device and treat netdev_priv()
> >as struct bonding{} which actually is struct net_vrf{}.
> >
> >By analyzing the processing logic of bond_enslave(), it seems that
> >it is not allowed to add the slave device with the IFF_MASTER flag, so
> >we need to add a code check for this situation.
> 
> 	I don't believe the statement just above is correct; nesting
> bonds has historically been permitted, even if it is of questionable
> value these days.  I've not tested nesting in a while, but last I recall
> it did function.
> 
> 	Leaving aside the question of whether it's really useful to nest
> bonds or not, my concern with disabling this is that it will break
> existing configurations that currently work fine.
> 
> 	However, it should be possible to use netif_is_bonding_master
> (which tests dev->flags & IFF_MASTER and dev->priv_flags & IFF_BONDING)
> to exclude IFF_MASTER devices that are not bonds (which seem to be vrf
> and eql), e.g.,
> 
> 	if ((slave_dev->flags & IFF_MASTER) &&
> 		!netif_is_bond_master(slave_dev))
> 	
> 	Or we can just go with this patch and see if anything breaks.
> 
> 	-J

	Thank you for your advice, as Eric dumazet described: since there is a usage scenario
about nesting bonding, we should not break it.

> 
> >Signed-off-by: Di Zhu <zhudi21@huawei.com>
> >---
> > drivers/net/bonding/bond_main.c | 6 ++++++
> > 1 file changed, 6 insertions(+)
> >
> >diff --git a/drivers/net/bonding/bond_main.c
> b/drivers/net/bonding/bond_main.c
> >index c5a646d06102..16840c9bc00d 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -1601,6 +1601,12 @@ int bond_enslave(struct net_device *bond_dev,
> struct net_device *slave_dev,
> > 	int link_reporting;
> > 	int res = 0, i;
> >
> >+	if (slave_dev->flags & IFF_MASTER) {
> >+		netdev_err(bond_dev,
> >+			   "Error: Device with IFF_MASTER cannot be
> enslaved\n");
> >+		return -EPERM;
> >+	}
> >+
> > 	if (!bond->params.use_carrier &&
> > 	    slave_dev->ethtool_ops->get_link == NULL &&
> > 	    slave_ops->ndo_do_ioctl == NULL) {
> >--
> >2.23.0
> >
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com

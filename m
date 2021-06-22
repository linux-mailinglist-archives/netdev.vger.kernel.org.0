Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4213B0CB1
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhFVSTI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Jun 2021 14:19:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34604 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhFVSTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:19:06 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lvkx1-0007np-EH; Tue, 22 Jun 2021 18:16:43 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id BFBA05FBC1; Tue, 22 Jun 2021 11:16:41 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id B9947A0409;
        Tue, 22 Jun 2021 11:16:41 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     zhudi <zhudi21@huawei.com>
cc:     vfalico@gmail.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, rose.chen@huawei.com
Subject: Re: [PATCH] bonding: avoid adding slave device with IFF_MASTER flag
In-reply-to: <20210622030929.51295-1-zhudi21@huawei.com>
References: <20210622030929.51295-1-zhudi21@huawei.com>
Comments: In-reply-to zhudi <zhudi21@huawei.com>
   message dated "Tue, 22 Jun 2021 11:09:29 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21983.1624385801.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 22 Jun 2021 11:16:41 -0700
Message-ID: <21984.1624385801@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhudi <zhudi21@huawei.com> wrote:

>From: Di Zhu <zhudi21@huawei.com>
>
>The following steps will definitely cause the kernel to crash:
>	ip link add vrf1 type vrf table 1
>	modprobe bonding.ko max_bonds=1
>	echo "+vrf1" >/sys/class/net/bond0/bonding/slaves
>	rmmod bonding
>
>The root cause is that: When the VRF is added to the slave device,
>it will fail, and some cleaning work will be done. because VRF device
>has IFF_MASTER flag, cleanup process  will not clear the IFF_BONDING flag.
>Then, when we unload the bonding module, unregister_netdevice_notifier()
>will treat the VRF device as a bond master device and treat netdev_priv()
>as struct bonding{} which actually is struct net_vrf{}.
>
>By analyzing the processing logic of bond_enslave(), it seems that
>it is not allowed to add the slave device with the IFF_MASTER flag, so
>we need to add a code check for this situation.

	I don't believe the statement just above is correct; nesting
bonds has historically been permitted, even if it is of questionable
value these days.  I've not tested nesting in a while, but last I recall
it did function.

	Leaving aside the question of whether it's really useful to nest
bonds or not, my concern with disabling this is that it will break
existing configurations that currently work fine.

	However, it should be possible to use netif_is_bonding_master
(which tests dev->flags & IFF_MASTER and dev->priv_flags & IFF_BONDING)
to exclude IFF_MASTER devices that are not bonds (which seem to be vrf
and eql), e.g.,

	if ((slave_dev->flags & IFF_MASTER) &&
		!netif_is_bond_master(slave_dev))

	Or we can just go with this patch and see if anything breaks.

	-J

>Signed-off-by: Di Zhu <zhudi21@huawei.com>
>---
> drivers/net/bonding/bond_main.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index c5a646d06102..16840c9bc00d 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1601,6 +1601,12 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> 	int link_reporting;
> 	int res = 0, i;
> 
>+	if (slave_dev->flags & IFF_MASTER) {
>+		netdev_err(bond_dev,
>+			   "Error: Device with IFF_MASTER cannot be enslaved\n");
>+		return -EPERM;
>+	}
>+
> 	if (!bond->params.use_carrier &&
> 	    slave_dev->ethtool_ops->get_link == NULL &&
> 	    slave_ops->ndo_do_ioctl == NULL) {
>-- 
>2.23.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

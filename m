Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02033D8843
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 08:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhG1GwA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Jul 2021 02:52:00 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16012 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbhG1Gv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 02:51:59 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GZPPm3nWbzZtMS;
        Wed, 28 Jul 2021 14:48:28 +0800 (CST)
Received: from kwepeml500002.china.huawei.com (7.221.188.128) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 14:51:56 +0800
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 kwepeml500002.china.huawei.com (7.221.188.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 14:51:55 +0800
Received: from dggpemm500021.china.huawei.com ([7.185.36.109]) by
 dggpemm500021.china.huawei.com ([7.185.36.109]) with mapi id 15.01.2176.012;
 Wed, 28 Jul 2021 14:51:55 +0800
From:   "zhudi (J)" <zhudi21@huawei.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     "vfalico@gmail.com" <vfalico@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Subject: Re: [PATCH] bonding: Avoid adding slave devices to inactive bonding
Thread-Topic: [PATCH] bonding: Avoid adding slave devices to inactive bonding
Thread-Index: AdeDdfFp1okcsZKySZCuQDqO7jmjiQ==
Date:   Wed, 28 Jul 2021 06:51:55 +0000
Message-ID: <a457335cb9a04023808f5b34cd8c1d30@huawei.com>
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

> zhudi <zhudi21@huawei.com> wrote:
> 
> >We need to refuse to add slave devices to the bonding which does
> >not set IFF_UP flag, otherwise some problems will be caused(such as
> >bond_set_carrier() will not sync carrier state to upper net device).
> >The ifenslave command can prevent such use case, but through the sysfs
> >interface, slave devices can still be added regardless of whether
> >the bonding is set with IFF_UP flag or not.
> 
> 	What specifically happens in the carrier state issue you
> mention?  Are there other specific issues?

yes, The following steps can cause problems:
	1)bond0 is down
	2) ip link add link bond0 name ipvlan type ipvlan mode l2
	3) echo +enp2s7 >/sys/class/net/bond0/bonding/slaves
	4) ip link set bond0 up

	After these steps, use ip link command, we found ipvlan has NO-CARRIER:
		ipvlan@bond0: <NO-CARRIER, BROADCAST,MULTICAST,UP,M-DOWN> mtu 1500 qdisc noqueue state>

	This is because,  bond_enslave()->bond_set_carrier()->netif_carrier_on()...->netdev_state_change() 
will not sync carrier state to ipvlan because the IFF_UP  flag is not set.

> 	As far as I can recall, adding interfaces to the bond while the
> bond is down has worked for a very long time, so I'm concerned that
> disabling that functionality will have impact on existing
> configurations.
> 
> 	Also, to the best of my knowledge, the currently packaged
> ifenslave programs are scripts that utilize the sysfs interface.  I'm
> unaware of current usage of the old C ifenslave program (removed from
> the kernel source in 2013), although the kernel code should still
> support it.

	We still use old ifenslave command and it  does only allow to add slave to bonding with up state, code is as follows:

	/* check if master is up; if not then fail any operation */
	if (!(master_flags.ifr_flags & IFF_UP)) {
		fprintf(stderr,
			"Illegal operation; the specified master interface "
			"'%s' is not up.\n",
			master_ifname);
		res = 1;
		goto out;
	}

	If so, the behavior of the new tool is inconsistent with that of the old tool.

> 
> 	-J
> 
> >So we introduce a new BOND_OPTFLAG_IFUP flag to avoid adding slave
> >devices to inactive bonding.
> >
> >Signed-off-by: zhudi <zhudi21@huawei.com>
> >---
> > drivers/net/bonding/bond_options.c | 4 +++-
> > include/net/bond_options.h         | 4 +++-
> > 2 files changed, 6 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/net/bonding/bond_options.c
> b/drivers/net/bonding/bond_options.c
> >index 0cf25de6f46d..6d2f44b3528d 100644
> >--- a/drivers/net/bonding/bond_options.c
> >+++ b/drivers/net/bonding/bond_options.c
> >@@ -387,7 +387,7 @@ static const struct bond_option
> bond_opts[BOND_OPT_LAST] = {
> > 		.id = BOND_OPT_SLAVES,
> > 		.name = "slaves",
> > 		.desc = "Slave membership management",
> >-		.flags = BOND_OPTFLAG_RAWVAL,
> >+		.flags = BOND_OPTFLAG_RAWVAL | BOND_OPTFLAG_IFUP,
> > 		.set = bond_option_slaves_set
> > 	},
> > 	[BOND_OPT_TLB_DYNAMIC_LB] = {
> >@@ -583,6 +583,8 @@ static int bond_opt_check_deps(struct bonding
> *bond,
> > 		return -ENOTEMPTY;
> > 	if ((opt->flags & BOND_OPTFLAG_IFDOWN) && (bond->dev->flags &
> IFF_UP))
> > 		return -EBUSY;
> >+	if ((opt->flags & BOND_OPTFLAG_IFUP) && !(bond->dev->flags &
> IFF_UP))
> >+		return -EPERM;
> >
> > 	return 0;
> > }
> >diff --git a/include/net/bond_options.h b/include/net/bond_options.h
> >index 9d382f2f0bc5..742f5cc81adf 100644
> >--- a/include/net/bond_options.h
> >+++ b/include/net/bond_options.h
> >@@ -15,11 +15,13 @@
> >  * BOND_OPTFLAG_NOSLAVES - check if the bond device is empty before
> setting
> >  * BOND_OPTFLAG_IFDOWN - check if the bond device is down before
> setting
> >  * BOND_OPTFLAG_RAWVAL - the option parses the value itself
> >+ * BOND_OPTFLAG_IFUP - check if the bond device is up before setting
> >  */
> > enum {
> > 	BOND_OPTFLAG_NOSLAVES	= BIT(0),
> > 	BOND_OPTFLAG_IFDOWN	= BIT(1),
> >-	BOND_OPTFLAG_RAWVAL	= BIT(2)
> >+	BOND_OPTFLAG_RAWVAL	= BIT(2),
> >+	BOND_OPTFLAG_IFUP	= BIT(3)
> > };
> >
> > /* Value type flags:
> >--
> >2.27.0
> >
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com

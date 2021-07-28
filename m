Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5B53D861B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 05:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhG1Df1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 23:35:27 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7881 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbhG1Df0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 23:35:26 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GZK2f6XkJz818G;
        Wed, 28 Jul 2021 11:31:38 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 11:35:11 +0800
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 11:35:10 +0800
From:   zhudi <zhudi21@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <kuba@kernel.org>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <zhudi21@huawei.com>,
        <rose.chen@huawei.com>
Subject: [PATCH] bonding: Avoid adding slave devices to inactive bonding
Date:   Wed, 28 Jul 2021 11:35:05 +0800
Message-ID: <20210728033505.1627-1-zhudi21@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.114.155]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500021.china.huawei.com (7.185.36.109)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to refuse to add slave devices to the bonding which does
not set IFF_UP flag, otherwise some problems will be caused(such as
bond_set_carrier() will not sync carrier state to upper net device).
The ifenslave command can prevent such use case, but through the sysfs
interface, slave devices can still be added regardless of whether
the bonding is set with IFF_UP flag or not.

So we introduce a new BOND_OPTFLAG_IFUP flag to avoid adding slave
devices to inactive bonding.

Signed-off-by: zhudi <zhudi21@huawei.com>
---
 drivers/net/bonding/bond_options.c | 4 +++-
 include/net/bond_options.h         | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 0cf25de6f46d..6d2f44b3528d 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -387,7 +387,7 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.id = BOND_OPT_SLAVES,
 		.name = "slaves",
 		.desc = "Slave membership management",
-		.flags = BOND_OPTFLAG_RAWVAL,
+		.flags = BOND_OPTFLAG_RAWVAL | BOND_OPTFLAG_IFUP,
 		.set = bond_option_slaves_set
 	},
 	[BOND_OPT_TLB_DYNAMIC_LB] = {
@@ -583,6 +583,8 @@ static int bond_opt_check_deps(struct bonding *bond,
 		return -ENOTEMPTY;
 	if ((opt->flags & BOND_OPTFLAG_IFDOWN) && (bond->dev->flags & IFF_UP))
 		return -EBUSY;
+	if ((opt->flags & BOND_OPTFLAG_IFUP) && !(bond->dev->flags & IFF_UP))
+		return -EPERM;
 
 	return 0;
 }
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 9d382f2f0bc5..742f5cc81adf 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -15,11 +15,13 @@
  * BOND_OPTFLAG_NOSLAVES - check if the bond device is empty before setting
  * BOND_OPTFLAG_IFDOWN - check if the bond device is down before setting
  * BOND_OPTFLAG_RAWVAL - the option parses the value itself
+ * BOND_OPTFLAG_IFUP - check if the bond device is up before setting
  */
 enum {
 	BOND_OPTFLAG_NOSLAVES	= BIT(0),
 	BOND_OPTFLAG_IFDOWN	= BIT(1),
-	BOND_OPTFLAG_RAWVAL	= BIT(2)
+	BOND_OPTFLAG_RAWVAL	= BIT(2),
+	BOND_OPTFLAG_IFUP	= BIT(3)
 };
 
 /* Value type flags:
-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E89E27D364
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 18:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgI2QN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 12:13:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61492 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730051AbgI2QN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 12:13:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TG4cX8003378;
        Tue, 29 Sep 2020 09:13:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=3gsNUcjBfiR7ha7I7fAkfXFHw92HqGsR9ucKx2usUtM=;
 b=G+48h17zZSyC6SkRwSRV6XOaX34A16bmeHhZuFPhFiVCF1OgaHkA0LM3Av+ZnNgi1kqX
 F3Pg7PIMgkfsqKgFCZSvAKJ72HPUHMj1mOkmr76Y/fFGQMlXYM6aNZlm8lVyJzcGABeP
 Cu/i9u2NVoTKNVSpKNeqR/vrDo4q2J1w9C7hLML4NT0nhZB/bR9Z/9SBFVMslb2eRC+7
 oYRu0bco0fKifSx/veTyeT16ij6NA9ay/Bnhjpphbke6DlRNLGJ7hAVEfFCVMzADwNqi
 Rn2mlRSQz/f+f7wnRbHuqaaolTEHe2VUdQq044OGDkD0t4GdXAz7ffxw5CqA8Ulqg9W8 Ng== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemcr9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 09:13:18 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 09:13:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 09:13:17 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id 34B1A3F7050;
        Tue, 29 Sep 2020 09:13:15 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 1/3] ethtool: allow netdev driver to define phy tunables
Date:   Tue, 29 Sep 2020 19:13:05 +0300
Message-ID: <20200929161307.542-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929161307.542-1-irusskikh@marvell.com>
References: <20200929161307.542-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_10:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define get/set phy tunable callbacks in ethtool ops.
This will allow MAC drivers with integrated PHY still to implement
these tunables.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 include/linux/ethtool.h |  4 ++++
 net/ethtool/ioctl.c     | 37 ++++++++++++++++++++++++-------------
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 060b20f0b20f..6408b446051f 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -505,6 +505,10 @@ struct ethtool_ops {
 				      struct ethtool_fecparam *);
 	void	(*get_ethtool_phy_stats)(struct net_device *,
 					 struct ethtool_stats *, u64 *);
+	int	(*get_phy_tunable)(struct net_device *,
+				   const struct ethtool_tunable *, void *);
+	int	(*set_phy_tunable)(struct net_device *,
+				   const struct ethtool_tunable *, const void *);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 328d15cd4006..ec2cd7aab5ad 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2459,14 +2459,15 @@ static int ethtool_phy_tunable_valid(const struct ethtool_tunable *tuna)
 
 static int get_phy_tunable(struct net_device *dev, void __user *useraddr)
 {
-	int ret;
-	struct ethtool_tunable tuna;
 	struct phy_device *phydev = dev->phydev;
+	struct ethtool_tunable tuna;
+	bool phy_drv_tunable;
 	void *data;
+	int ret;
 
-	if (!(phydev && phydev->drv && phydev->drv->get_tunable))
+	phy_drv_tunable = phydev && phydev->drv && phydev->drv->get_tunable;
+	if (!phy_drv_tunable && !dev->ethtool_ops->get_phy_tunable)
 		return -EOPNOTSUPP;
-
 	if (copy_from_user(&tuna, useraddr, sizeof(tuna)))
 		return -EFAULT;
 	ret = ethtool_phy_tunable_valid(&tuna);
@@ -2475,9 +2476,13 @@ static int get_phy_tunable(struct net_device *dev, void __user *useraddr)
 	data = kmalloc(tuna.len, GFP_USER);
 	if (!data)
 		return -ENOMEM;
-	mutex_lock(&phydev->lock);
-	ret = phydev->drv->get_tunable(phydev, &tuna, data);
-	mutex_unlock(&phydev->lock);
+	if (phy_drv_tunable) {
+		mutex_lock(&phydev->lock);
+		ret = phydev->drv->get_tunable(phydev, &tuna, data);
+		mutex_unlock(&phydev->lock);
+	} else {
+		ret = dev->ethtool_ops->get_phy_tunable(dev, &tuna, data);
+	}
 	if (ret)
 		goto out;
 	useraddr += sizeof(tuna);
@@ -2493,12 +2498,14 @@ static int get_phy_tunable(struct net_device *dev, void __user *useraddr)
 
 static int set_phy_tunable(struct net_device *dev, void __user *useraddr)
 {
-	int ret;
-	struct ethtool_tunable tuna;
 	struct phy_device *phydev = dev->phydev;
+	struct ethtool_tunable tuna;
+	bool phy_drv_tunable;
 	void *data;
+	int ret;
 
-	if (!(phydev && phydev->drv && phydev->drv->set_tunable))
+	phy_drv_tunable = phydev && phydev->drv && phydev->drv->get_tunable;
+	if (!phy_drv_tunable && !dev->ethtool_ops->set_phy_tunable)
 		return -EOPNOTSUPP;
 	if (copy_from_user(&tuna, useraddr, sizeof(tuna)))
 		return -EFAULT;
@@ -2509,9 +2516,13 @@ static int set_phy_tunable(struct net_device *dev, void __user *useraddr)
 	data = memdup_user(useraddr, tuna.len);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
-	mutex_lock(&phydev->lock);
-	ret = phydev->drv->set_tunable(phydev, &tuna, data);
-	mutex_unlock(&phydev->lock);
+	if (phy_drv_tunable) {
+		mutex_lock(&phydev->lock);
+		ret = phydev->drv->set_tunable(phydev, &tuna, data);
+		mutex_unlock(&phydev->lock);
+	} else {
+		ret = dev->ethtool_ops->set_phy_tunable(dev, &tuna, data);
+	}
 
 	kfree(data);
 	return ret;
-- 
2.17.1


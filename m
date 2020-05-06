Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA3F1C6F6B
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgEFLeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:34:16 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19998 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727844AbgEFLeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:34:14 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046BXXaO030271;
        Wed, 6 May 2020 04:34:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=YBe/+akkRVSXcqg3zibhFlDfG42BscAYCsU0vwynV9s=;
 b=iKsGT294j5LPB2q9hGzxlj+GVOjGHa1U73r/71XBmdOvsCpUH4/W3lXGrFvuTH0200IP
 FUTq2plNARlvDeOIL4hcb22m+s7iAlK5lBAOdk9u+dKfy/2mpX3xfhdf9Cdt/qYFu60u
 VdORAcAOSQ37Wamg8Swwaj4oOJPnNqZ5G3Kx9yVB7zk0nl/9TAb7hqD/6R8EZLQADfGi
 2mwSl/qwBPs9uFUXiynvgSc9CYO7oGbAZkwgvKbHlc9ZSGElV1tpYSHnNPKdbhfvumAf
 x8r+xSNu2E+Uxv4XkBoaPMbcPg3a4N3k+Dkttox2E+M3dibT4WKGB9G/znkNXzBu09Oj Zw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30urytrs4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:34:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 May
 2020 04:34:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 May 2020 04:34:10 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 7A0833F703F;
        Wed,  6 May 2020 04:34:08 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 08/12] net: qede: optional hw recovery procedure
Date:   Wed, 6 May 2020 14:33:10 +0300
Message-ID: <a3c9dcafa3715e95ae26c28560e40e2c8ae29a1f.1588758463.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588758463.git.irusskikh@marvell.com>
References: <cover.1588758463.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_05:2020-05-05,2020-05-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver has an ability to initiate a recovery process as a reaction to
detected errors. But the codepath (recovery_process) was disabled and
never active.

Here we add ethtool private flag to allow user have the recovery
procedure activated.

We still do not enable this by default though, since in some configurations
this is not desirable. E.g. this may impact other PFs/VFs.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 812c7766e096..24cc68391ac4 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -190,12 +190,14 @@ static const struct {
 enum {
 	QEDE_PRI_FLAG_CMT,
 	QEDE_PRI_FLAG_SMART_AN_SUPPORT, /* MFW supports SmartAN */
+	QEDE_PRI_FLAG_RECOVER_ON_ERROR,
 	QEDE_PRI_FLAG_LEN,
 };
 
 static const char qede_private_arr[QEDE_PRI_FLAG_LEN][ETH_GSTRING_LEN] = {
 	"Coupled-Function",
 	"SmartAN capable",
+	"Recover on error",
 };
 
 enum qede_ethtool_tests {
@@ -417,9 +419,30 @@ static u32 qede_get_priv_flags(struct net_device *dev)
 	if (edev->dev_info.common.smart_an)
 		flags |= BIT(QEDE_PRI_FLAG_SMART_AN_SUPPORT);
 
+	if (edev->err_flags & BIT(QEDE_ERR_IS_RECOVERABLE))
+		flags |= BIT(QEDE_PRI_FLAG_RECOVER_ON_ERROR);
+
 	return flags;
 }
 
+static int qede_set_priv_flags(struct net_device *dev, u32 flags)
+{
+	struct qede_dev *edev = netdev_priv(dev);
+	u32 cflags = qede_get_priv_flags(dev);
+	u32 dflags = flags ^ cflags;
+
+	/* can only change RECOVER_ON_ERROR flag */
+	if (dflags & ~BIT(QEDE_PRI_FLAG_RECOVER_ON_ERROR))
+		return -EINVAL;
+
+	if (flags & BIT(QEDE_PRI_FLAG_RECOVER_ON_ERROR))
+		set_bit(QEDE_ERR_IS_RECOVERABLE, &edev->err_flags);
+	else
+		clear_bit(QEDE_ERR_IS_RECOVERABLE, &edev->err_flags);
+
+	return 0;
+}
+
 struct qede_link_mode_mapping {
 	u32 qed_link_mode;
 	u32 ethtool_link_mode;
@@ -2098,6 +2121,7 @@ static const struct ethtool_ops qede_ethtool_ops = {
 	.set_phys_id = qede_set_phys_id,
 	.get_ethtool_stats = qede_get_ethtool_stats,
 	.get_priv_flags = qede_get_priv_flags,
+	.set_priv_flags = qede_set_priv_flags,
 	.get_sset_count = qede_get_sset_count,
 	.get_rxnfc = qede_get_rxnfc,
 	.set_rxnfc = qede_set_rxnfc,
-- 
2.25.1


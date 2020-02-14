Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9860515DB50
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgBNPpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:45:22 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22234 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728859AbgBNPpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:45:21 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EFg3gq015426;
        Fri, 14 Feb 2020 07:45:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Ztt87rI7A/szi3UEFGKXOwpnxLWXpkS0R+ADQok6MwA=;
 b=BQvn2udcNpXTZY27VW2GAFSIEJqgBadA3R/xub7D882o9JGOV79BiXyCPmicKEhGLsqY
 vw9W35nCq4Sv1F4TQ6WsnDxOeX3QfAvdu7HHKwK7uhWuGEKovNUbkz4PcCYGz80rr2AV
 2AmxBMBvvIxqWq3iRRFBG/NQtwWS3bBsRceA7os/jyS6Vs/BXKYaM1Hk95jSeOQGRS9D
 LKUIJEcXUJUNagsViFC9lHruqEB+Sz3K41HsyGznk9iqGc0FZtpk9T6po3MyTF2LaRFy
 3KohBUsJFqaUWyXX5mkl2kFumexAzSEiPl40/d//AcfvHWKBofZI7ii28ARM15q55RRE gA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2naqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:45:19 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:45:18 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:45:17 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:45:17 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 8D2DA3F703F;
        Fri, 14 Feb 2020 07:45:15 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <dbogdanov@marvell.com>, <pbelous@marvell.com>,
        <ndanilov@marvell.com>, <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net 4/8] net: atlantic: better loopback mode handling
Date:   Fri, 14 Feb 2020 18:44:54 +0300
Message-ID: <c844705db2161b239a779e0ca58507a9043920f6.1580299250.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1580299250.git.irusskikh@marvell.com>
References: <cover.1580299250.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

Add checks to not enable multiple loopback modes simultaneously,
It was also discovered that for dma loopback to function correctly
promisc mode should be enabled on device.

Fixes: ea4b4d7fc106 ("net: atlantic: loopback tests via private flags")
Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c |  5 +++++
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c   | 13 ++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index a1f99bef4a68..7b55633d2cb9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -722,6 +722,11 @@ static int aq_ethtool_set_priv_flags(struct net_device *ndev, u32 flags)
 	if (flags & ~AQ_PRIV_FLAGS_MASK)
 		return -EOPNOTSUPP;
 
+	if (hweight32((flags | priv_flags) & AQ_HW_LOOPBACK_MASK) > 1) {
+		netdev_info(ndev, "Can't enable more than one loopback simultaneously\n");
+		return -EINVAL;
+	}
+
 	cfg->priv_flags = flags;
 
 	if ((priv_flags ^ flags) & BIT(AQ_HW_LOOPBACK_DMA_NET)) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 9acdb3fbb750..d20d91cdece8 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -885,13 +885,16 @@ static int hw_atl_b0_hw_packet_filter_set(struct aq_hw_s *self,
 {
 	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
 	unsigned int i = 0U;
+	u32 vlan_promisc;
+	u32 l2_promisc;
 
-	hw_atl_rpfl2promiscuous_mode_en_set(self,
-					    IS_FILTER_ENABLED(IFF_PROMISC));
+	l2_promisc = IS_FILTER_ENABLED(IFF_PROMISC) ||
+		     !!(cfg->priv_flags & BIT(AQ_HW_LOOPBACK_DMA_NET));
+	vlan_promisc = l2_promisc || cfg->is_vlan_force_promisc;
 
-	hw_atl_rpf_vlan_prom_mode_en_set(self,
-				     IS_FILTER_ENABLED(IFF_PROMISC) ||
-				     cfg->is_vlan_force_promisc);
+	hw_atl_rpfl2promiscuous_mode_en_set(self, l2_promisc);
+
+	hw_atl_rpf_vlan_prom_mode_en_set(self, vlan_promisc);
 
 	hw_atl_rpfl2multicast_flr_en_set(self,
 					 IS_FILTER_ENABLED(IFF_ALLMULTI) &&
-- 
2.17.1


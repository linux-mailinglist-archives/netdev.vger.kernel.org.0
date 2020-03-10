Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1534180100
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgCJPEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:04:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30346 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726295AbgCJPEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:04:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AEtw7L011804;
        Tue, 10 Mar 2020 08:03:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=VQ/+GVF/PtRQoBvYgA7OQQOmpzLhcumWjCG1WdXx2Hc=;
 b=tOpSq+HCBZME8ToF+c/szJTGlF26sPkADEq6hva8+EIoVCGeGuZfG+MvZcy2tRWwhKLk
 qVn01z0hfX8+7dTRfAgzDdkhyjOI41MXkraU3zLA4NN2aty02lNxGgITp11HBB2yxoA2
 P5wG9hd8kCiAgjElAoGGNru9HZHXSVoFqRbecQ0X0O3BG/GHbmSklBRW/1lNCVDaPAL3
 e/k9TRvUvcFkyTClbfAGogRT7I3HDh4499WexjyYF7B5RbWuyqrcgbUs/1b8pDDkxdwm
 nCbucn0wEDz7KbjyJigy/4+Y0JrtVlfPZf9DoXAl3+YYFIwqsjSjRuc/d1lkshEg7y1c FQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yp04fm0ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 08:03:59 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:03:57 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Mar 2020 08:03:57 -0700
Received: from NN-LT0019.rdc.aquantia.com (nn-lt0019.marvell.com [10.9.16.69])
        by maili.marvell.com (Postfix) with ESMTP id 2367A3F7040;
        Tue, 10 Mar 2020 08:03:55 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [RFC v2 01/16] net: introduce the MACSEC netdev feature
Date:   Tue, 10 Mar 2020 18:03:27 +0300
Message-ID: <20200310150342.1701-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200310150342.1701-1-irusskikh@marvell.com>
References: <20200310150342.1701-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_08:2020-03-10,2020-03-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

This patch introduce a new netdev feature, which will be used by drivers
to state they can perform MACsec transformations in hardware.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 include/linux/netdev_features.h | 3 +++
 net/ethtool/common.c            | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 34d050bb1ae6..9d53c5ad272c 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -83,6 +83,8 @@ enum {
 	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
 	NETIF_F_GRO_FRAGLIST_BIT,	/* Fraglist GRO */
 
+	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
+
 	/*
 	 * Add your fresh new feature above and remember to update
 	 * netdev_features_strings[] in net/core/ethtool.c and maybe
@@ -154,6 +156,7 @@ enum {
 #define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
 #define NETIF_F_GRO_FRAGLIST	__NETIF_F(GRO_FRAGLIST)
 #define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
+#define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 7b6969af5ae7..686d3c7dce83 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -60,6 +60,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_HW_TLS_TX_BIT] =	 "tls-hw-tx-offload",
 	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
 	[NETIF_F_GRO_FRAGLIST_BIT] =	 "rx-gro-list",
+	[NETIF_F_HW_MACSEC_BIT] =	 "macsec-hw-offload",
 };
 
 const char
-- 
2.17.1


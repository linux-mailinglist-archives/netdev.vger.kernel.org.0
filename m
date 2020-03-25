Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C18F1928EA
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgCYMxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:53:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62806 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726998AbgCYMxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 08:53:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PCp3N1009882;
        Wed, 25 Mar 2020 05:52:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=t5vrkRw/fdywPmFJSOrX6sLRwgIbcLpCgrIYoV8gIDM=;
 b=oKtI4dy0XUh5vee5VoXxErhiWmKnsTZnNlR9CuqVS9+rrUkTO6ImB+N0Nz7+OK6AXgiB
 MxA3RetP25e6jnoIWRRd6bRZXkhsKu+qaHC4i0WtyvGMZ/NXizrtOu37B3F+wIHIeZ2k
 2BYJ73UEz69FOfIfOZLN3XzOUpsZKNnXL8hWXlMBvsCw1uAD1Em2ePJ3YZnviGLMW+Fb
 hRcDcG+s/rCfR91/FuaI4QCi0ilE+RdC8e3MTu00d0YVkJHpEzcDR67cTX7FY7/2Irdy
 tV3AMExJNURi5OXgbLyJIzhdraVu3y62w/pC+xVKhrJIkcBTXsDzA/8R+ZENZIpaA2mR TQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nrgfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 05:52:56 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:52:54 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 05:52:55 -0700
Received: from localhost.localdomain (unknown [10.9.16.55])
        by maili.marvell.com (Postfix) with ESMTP id D25983F7043;
        Wed, 25 Mar 2020 05:52:53 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 01/17] net: introduce the MACSEC netdev feature
Date:   Wed, 25 Mar 2020 15:52:30 +0300
Message-ID: <20200325125246.987-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325125246.987-1-irusskikh@marvell.com>
References: <20200325125246.987-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

This patch introduce a new netdev feature, which will be used by drivers
to state they can perform MACsec transformations in hardware.

The patchset was gathered by Mark, macsec functinality itself
was implemented by Dmitry, Mark and Pavel Belous.

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
index dab047eec943..51a0941fc62f 100644
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


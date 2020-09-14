Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D8A269285
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgINRHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:07:06 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:38002 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgINRGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:06:52 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08EH6iPd083926;
        Mon, 14 Sep 2020 12:06:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600103204;
        bh=OI3rXEytyA6cQx9GiVIdGTXwSm9ptrA7LUk5jvSk3Ac=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=QqbboWGCcFLaJiAKe1oW4eUUwuSy2JIO17ZwiqyIEVpmPciLQ0H1ync6evWtgnyRD
         nYnCNy2ij1w5utFuh5gbK1HMSv1/QvgPqo/qtxYoEZQSe08tgFWwU0d9QB1Ry6cs8B
         6oudcR1eAXjAZlqfqA1ledC3JqT/Re0NFusvqClE=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08EH6ihM091304
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Sep 2020 12:06:44 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 14
 Sep 2020 12:06:44 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 14 Sep 2020 12:06:44 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08EH6ihS003092;
        Mon, 14 Sep 2020 12:06:44 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH 1/1] ethtool: Add 100BaseFX half and full duplex link modes
Date:   Mon, 14 Sep 2020 12:06:38 -0500
Message-ID: <20200914170638.22451-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200914170638.22451-1-dmurphy@ti.com>
References: <20200914170638.22451-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel can now indicate if the PHY supports operating over a
fiber cable at 100Mbps either Full or Half duplex.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 ethtool.c            | 6 ++++++
 netlink/settings.c   | 2 ++
 uapi/linux/ethtool.h | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 606af3e6b48f..84ad21467206 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -443,6 +443,8 @@ static void init_global_link_mode_masks(void)
 		ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT,
 		ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
 		ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
+		ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
+		ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
 	};
 	static const enum ethtool_link_mode_bit_indices
 		additional_advertised_flags_bits[] = {
@@ -639,6 +641,10 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
 		  "200000baseDR4/Full" },
 		{ 0, ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT,
 		  "200000baseCR4/Full" },
+		{ 0, ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
+		  "100baseFx/Half" },
+		{ 1, ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
+		  "100baseFx/Full" },
 	};
 	int indent;
 	int did1, new_line_pend;
diff --git a/netlink/settings.c b/netlink/settings.c
index 935724e799da..a11c85756ca6 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -147,6 +147,8 @@ static const struct link_mode_info link_modes[] = {
 	[ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT]	= __REAL(400000),
 	[ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT]	= __REAL(400000),
 	[ETHTOOL_LINK_MODE_FEC_LLRS_BIT]		= __SPECIAL(FEC),
+	[ETHTOOL_LINK_MODE_100baseFX_Half_BIT]		= __HALF_DUPLEX(100),
+	[ETHTOOL_LINK_MODE_100baseFX_Full_BIT]		= __REAL(100),
 };
 const unsigned int link_modes_count = ARRAY_SIZE(link_modes);
 
diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index a1cfbe2ef40f..5c58555fecb4 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -1598,6 +1598,8 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
 	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
 	ETHTOOL_LINK_MODE_FEC_LLRS_BIT			 = 74,
+	ETHTOOL_LINK_MODE_100baseFX_Half_BIT		 = 90,
+	ETHTOOL_LINK_MODE_100baseFX_Full_BIT		 = 91,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
-- 
2.28.0


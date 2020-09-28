Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D206F27B030
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 16:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgI1Oox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 10:44:53 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:42798 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgI1Oox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 10:44:53 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08SEipPW051876;
        Mon, 28 Sep 2020 09:44:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601304291;
        bh=i9MRAaLfrkF6uRE/AWA4zwFpA6EWftu/edCSpykGDzs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=sKjX55KCNaExsBKWx7QVCKPH5V/ONESb3bWZzQYmc0u6oo6FsSyVoRfCoRG2hxqXW
         SrulOsElm/KXqO5/1vuN3e+aQXidKJgUCcXrOmL3xWRJWfIOMKpcm5NtpNe+/my42N
         SLX95stE5GYpVl0rCgK/WqlgTdsxXDKt4bt4Q1RI=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08SEipZL003178;
        Mon, 28 Sep 2020 09:44:51 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 28
 Sep 2020 09:44:51 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 28 Sep 2020 09:44:51 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08SEipnb097520;
        Mon, 28 Sep 2020 09:44:51 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH ethtool v3 3/3] Update link mode tables for fiber
Date:   Mon, 28 Sep 2020 09:44:03 -0500
Message-ID: <20200928144403.19484-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200928144403.19484-1-dmurphy@ti.com>
References: <20200928144403.19484-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the link mode tables to include 100base Fx Full and Half duplex
modes.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 ethtool.8.in       | 2 ++
 ethtool.c          | 6 ++++++
 netlink/settings.c | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index d0921949b37e..7c6e23e28ffa 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -794,6 +794,8 @@ lB	l	lB.
 0x8000000000000000000000	400000baseLR4_ER4_FR4 Full
 0x10000000000000000000000	400000baseDR4 Full
 0x20000000000000000000000	400000baseCR4 Full
+0x40000000000000000000000	100baseFX Half
+0x80000000000000000000000	100baseFX Full
 .TE
 .TP
 .BI phyad \ N
diff --git a/ethtool.c b/ethtool.c
index 974b14063de2..39a1862a72a4 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -463,6 +463,8 @@ static void init_global_link_mode_masks(void)
 		ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT,
 		ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT,
 		ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT,
+		ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
+		ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
 	};
 	static const enum ethtool_link_mode_bit_indices
 		additional_advertised_flags_bits[] = {
@@ -669,6 +671,10 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
 		  "400000baseDR4/Full" },
 		{ 0, ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT,
 		  "400000baseCR4/Full" },
+		{ 0, ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
+		  "100baseFx/Half" },
+		{ 1, ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
+		  "100baseFx/Full" },
 	};
 	int indent;
 	int did1, new_line_pend;
diff --git a/netlink/settings.c b/netlink/settings.c
index 3059d4d0d0b7..41a2e5af1945 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -162,6 +162,8 @@ static const struct link_mode_info link_modes[] = {
 	[ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT] = __REAL(400000),
 	[ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT]	= __REAL(400000),
 	[ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT]	= __REAL(400000),
+	[ETHTOOL_LINK_MODE_100baseFX_Half_BIT]		= __HALF_DUPLEX(100),
+	[ETHTOOL_LINK_MODE_100baseFX_Full_BIT]		= __REAL(100),
 };
 const unsigned int link_modes_count = ARRAY_SIZE(link_modes);
 
-- 
2.28.0.585.ge1cfff676549


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D98191257
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgCXOBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:01:54 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52042 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726802AbgCXOBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:01:54 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 24 Mar 2020 16:01:52 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.134.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02OE1qMe023785;
        Tue, 24 Mar 2020 16:01:52 +0200
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH V2 ethtool] ethtool: Add support for Low Latency Reed Solomon
Date:   Tue, 24 Mar 2020 16:01:41 +0200
Message-Id: <20200324140141.20979-1-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Introduce a new FEC mode LL-RS: Low Latency Reed Solomon, update print
and initialization functions accordingly. In addition, update related
man page.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 ethtool.8.in         |  5 +++--
 ethtool.c            | 12 +++++++++++-
 netlink/settings.c   |  2 ++
 uapi/linux/ethtool.h |  3 +++
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/ethtool.8.in b/ethtool.8.in
index ba85cfe4f413..0b470fc63dd1 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -420,7 +420,7 @@ ethtool \- query or control network driver and hardware settings
 .B ethtool \-\-set\-fec
 .I devname
 .B encoding
-.BR auto | off | rs | baser \ [...]
+.BR auto | off | rs | baser | ll-rs \ [...]
 .HP
 .B ethtool \-Q|\-\-per\-queue
 .I devname
@@ -1228,7 +1228,7 @@ current FEC mode, the driver or firmware must take the link down
 administratively and report the problem in the system logs for users to correct.
 .RS 4
 .TP
-.BR encoding\ auto | off | rs | baser \ [...]
+.BR encoding\ auto | off | rs | baser | ll-rs \ [...]
 
 Sets the FEC encoding for the device.  Combinations of options are specified as
 e.g.
@@ -1241,6 +1241,7 @@ auto	Use the driver's default encoding
 off	Turn off FEC
 RS	Force RS-FEC encoding
 BaseR	Force BaseR encoding
+LL-RS	Force LL-RS-FEC encoding
 .TE
 .RE
 .TP
diff --git a/ethtool.c b/ethtool.c
index 1b4e08b6e60f..da69bbc7f42f 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -502,6 +502,7 @@ static void init_global_link_mode_masks(void)
 		ETHTOOL_LINK_MODE_FEC_NONE_BIT,
 		ETHTOOL_LINK_MODE_FEC_RS_BIT,
 		ETHTOOL_LINK_MODE_FEC_BASER_BIT,
+		ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
 	};
 	unsigned int i;
 
@@ -754,6 +755,12 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
 			fprintf(stdout, " RS");
 			fecreported = 1;
 		}
+		if (ethtool_link_mode_test_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
+					       mask)) {
+			fprintf(stdout, " LL-RS");
+			fecreported = 1;
+		}
+
 		if (!fecreported)
 			fprintf(stdout, " Not reported");
 		fprintf(stdout, "\n");
@@ -1562,6 +1569,8 @@ static void dump_fec(u32 fec)
 		fprintf(stdout, " BaseR");
 	if (fec & ETHTOOL_FEC_RS)
 		fprintf(stdout, " RS");
+	if (fec & ETHTOOL_FEC_LLRS)
+		fprintf(stdout, " LL-RS");
 }
 
 #define N_SOTS 7
@@ -5074,7 +5083,8 @@ static int fecmode_str_to_type(const char *str)
 		return ETHTOOL_FEC_RS;
 	if (!strcasecmp(str, "baser"))
 		return ETHTOOL_FEC_BASER;
-
+	if (!strcasecmp(str, "ll-rs"))
+		return ETHTOOL_FEC_LLRS;
 	return 0;
 }
 
diff --git a/netlink/settings.c b/netlink/settings.c
index c8a911d718b9..da821726e1b0 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -207,6 +207,8 @@ static const struct link_mode_info link_modes[] = {
 		{ LM_CLASS_REAL,	400000,	DUPLEX_FULL },
 	[ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT] =
 		{ LM_CLASS_REAL,	400000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_FEC_LLRS_BIT] =
+		{ LM_CLASS_FEC },
 };
 const unsigned int link_modes_count = ARRAY_SIZE(link_modes);
 
diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index 16198061d723..d3dcb459195c 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -1328,6 +1328,7 @@ enum ethtool_fec_config_bits {
 	ETHTOOL_FEC_OFF_BIT,
 	ETHTOOL_FEC_RS_BIT,
 	ETHTOOL_FEC_BASER_BIT,
+	ETHTOOL_FEC_LLRS_BIT,
 };
 
 #define ETHTOOL_FEC_NONE		(1 << ETHTOOL_FEC_NONE_BIT)
@@ -1335,6 +1336,7 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_FEC_OFF			(1 << ETHTOOL_FEC_OFF_BIT)
 #define ETHTOOL_FEC_RS			(1 << ETHTOOL_FEC_RS_BIT)
 #define ETHTOOL_FEC_BASER		(1 << ETHTOOL_FEC_BASER_BIT)
+#define ETHTOOL_FEC_LLRS		(1 << ETHTOOL_FEC_LLRS_BIT)
 
 /* CMDs currently supported */
 #define ETHTOOL_GSET		0x00000001 /* DEPRECATED, Get settings.
@@ -1519,6 +1521,7 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT = 71,
 	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
 	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
+	ETHTOOL_LINK_MODE_FEC_LLRS_BIT                   = 74,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
-- 
2.19.1


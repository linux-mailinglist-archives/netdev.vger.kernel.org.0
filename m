Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B57CF18342B
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 16:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgCLPMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 11:12:16 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59710 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727505AbgCLPMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 11:12:15 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Mar 2020 17:12:13 +0200
Received: from dev-l-vrt-207-005.mtl.labs.mlnx (dev-l-vrt-207-005.mtl.labs.mlnx [10.134.207.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02CFCDWt006145;
        Thu, 12 Mar 2020 17:12:13 +0200
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "John W. Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH ethtool] ethtool: Add support for Low Latency Reed Solomon
Date:   Thu, 12 Mar 2020 17:12:03 +0200
Message-Id: <1584025923-5385-1-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Introduce a new FEC mode LL-RS: Low Latency Reed Solomon, update print
and initialization functions accordingly. In addition, update related
man page.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 ethtool-copy.h |  3 +++
 ethtool.8.in   |  5 +++--
 ethtool.c      | 12 +++++++++++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/ethtool-copy.h b/ethtool-copy.h
index 9afd2e6c5eea..a5482a91b429 100644
--- a/ethtool-copy.h
+++ b/ethtool-copy.h
@@ -1319,6 +1319,7 @@ enum ethtool_fec_config_bits {
 	ETHTOOL_FEC_OFF_BIT,
 	ETHTOOL_FEC_RS_BIT,
 	ETHTOOL_FEC_BASER_BIT,
+	ETHTOOL_FEC_LLRS_BIT,
 };
 
 #define ETHTOOL_FEC_NONE		(1 << ETHTOOL_FEC_NONE_BIT)
@@ -1326,6 +1327,7 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_FEC_OFF			(1 << ETHTOOL_FEC_OFF_BIT)
 #define ETHTOOL_FEC_RS			(1 << ETHTOOL_FEC_RS_BIT)
 #define ETHTOOL_FEC_BASER		(1 << ETHTOOL_FEC_BASER_BIT)
+#define ETHTOOL_FEC_LLRS		(1 << ETHTOOL_FEC_LLRS_BIT)
 
 /* CMDs currently supported */
 #define ETHTOOL_GSET		0x00000001 /* DEPRECATED, Get settings.
@@ -1505,6 +1507,7 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 = 66,
 	ETHTOOL_LINK_MODE_100baseT1_Full_BIT		 = 67,
 	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT		 = 68,
+	ETHTOOL_LINK_MODE_FEC_LLRS_BIT                   = 74,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
diff --git a/ethtool.8.in b/ethtool.8.in
index 94364c626330..5d16aa27dab1 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -404,7 +404,7 @@ ethtool \- query or control network driver and hardware settings
 .B ethtool \-\-set\-fec
 .I devname
 .B encoding
-.BR auto | off | rs | baser \ [...]
+.BR auto | off | rs | baser | ll-rs \ [...]
 .HP
 .B ethtool \-Q|\-\-per\-queue
 .I devname
@@ -1204,7 +1204,7 @@ current FEC mode, the driver or firmware must take the link down
 administratively and report the problem in the system logs for users to correct.
 .RS 4
 .TP
-.BR encoding\ auto | off | rs | baser \ [...]
+.BR encoding\ auto | off | rs | baser | ll-rs \ [...]
 
 Sets the FEC encoding for the device.  Combinations of options are specified as
 e.g.
@@ -1217,6 +1217,7 @@ auto	Use the driver's default encoding
 off	Turn off FEC
 RS	Force RS-FEC encoding
 BaseR	Force BaseR encoding
+LL-RS	Force LL-RS-FEC encoding
 .TE
 .RE
 .TP
diff --git a/ethtool.c b/ethtool.c
index acf183dc5586..7110b269f306 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -562,6 +562,7 @@ static void init_global_link_mode_masks(void)
 		ETHTOOL_LINK_MODE_FEC_NONE_BIT,
 		ETHTOOL_LINK_MODE_FEC_RS_BIT,
 		ETHTOOL_LINK_MODE_FEC_BASER_BIT,
+		ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
 	};
 	unsigned int i;
 
@@ -814,6 +815,12 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
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
@@ -1696,6 +1703,8 @@ static void dump_fec(u32 fec)
 		fprintf(stdout, " BaseR");
 	if (fec & ETHTOOL_FEC_RS)
 		fprintf(stdout, " RS");
+	if (fec & ETHTOOL_FEC_LLRS)
+		fprintf(stdout, " LL-RS");
 }
 
 #define N_SOTS 7
@@ -5209,7 +5218,8 @@ static int fecmode_str_to_type(const char *str)
 		return ETHTOOL_FEC_RS;
 	if (!strcasecmp(str, "baser"))
 		return ETHTOOL_FEC_BASER;
-
+	if (!strcasecmp(str, "ll-rs"))
+		return ETHTOOL_FEC_LLRS;
 	return 0;
 }
 
-- 
1.8.3.1


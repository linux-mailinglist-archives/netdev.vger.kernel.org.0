Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247B624EF82
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 21:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgHWTk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 15:40:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:50652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgHWTkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 15:40:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B7F07AEC4;
        Sun, 23 Aug 2020 19:40:50 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 224F06030D; Sun, 23 Aug 2020 21:40:21 +0200 (CEST)
Message-Id: <2a1370f2ffe49011dbfe8c32ef455d3514a6cdd0.1598210544.git.mkubecek@suse.cz>
In-Reply-To: <cover.1598210544.git.mkubecek@suse.cz>
References: <cover.1598210544.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 2/9] ioctl: check presence of eeprom length
 argument properly
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Date:   Sun, 23 Aug 2020 21:40:21 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In do_geeprom(), do_seprom() and do_getmodule(), check if user used
"length" command line argument is done by setting the value to -1 before
parsing and checking if it changed. This is quite ugly and also causes
compiler warnings as the variable is u32.

Use proper "seen" flag to let parser tell us if the argument was used.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 ethtool.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index c4ad186cd390..4fa7a2c1716f 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -3184,10 +3184,12 @@ static int do_geeprom(struct cmd_context *ctx)
 	int geeprom_changed = 0;
 	int geeprom_dump_raw = 0;
 	u32 geeprom_offset = 0;
-	u32 geeprom_length = -1;
+	u32 geeprom_length = 0;
+	int geeprom_length_seen = 0;
 	struct cmdline_info cmdline_geeprom[] = {
 		{ "offset", CMDL_U32, &geeprom_offset, NULL },
-		{ "length", CMDL_U32, &geeprom_length, NULL },
+		{ "length", CMDL_U32, &geeprom_length, NULL,
+		  0, &geeprom_length_seen },
 		{ "raw", CMDL_BOOL, &geeprom_dump_raw, NULL },
 	};
 	int err;
@@ -3204,7 +3206,7 @@ static int do_geeprom(struct cmd_context *ctx)
 		return 74;
 	}
 
-	if (geeprom_length == -1)
+	if (!geeprom_length_seen)
 		geeprom_length = drvinfo.eedump_len;
 
 	if (drvinfo.eedump_len < geeprom_offset + geeprom_length)
@@ -3234,14 +3236,16 @@ static int do_seeprom(struct cmd_context *ctx)
 {
 	int seeprom_changed = 0;
 	u32 seeprom_magic = 0;
-	u32 seeprom_length = -1;
+	u32 seeprom_length = 0;
 	u32 seeprom_offset = 0;
 	u8 seeprom_value = 0;
+	int seeprom_length_seen = 0;
 	int seeprom_value_seen = 0;
 	struct cmdline_info cmdline_seeprom[] = {
 		{ "magic", CMDL_U32, &seeprom_magic, NULL },
 		{ "offset", CMDL_U32, &seeprom_offset, NULL },
-		{ "length", CMDL_U32, &seeprom_length, NULL },
+		{ "length", CMDL_U32, &seeprom_length, NULL,
+		  0, &seeprom_length_seen },
 		{ "value", CMDL_U8, &seeprom_value, NULL,
 		  0, &seeprom_value_seen },
 	};
@@ -3262,7 +3266,7 @@ static int do_seeprom(struct cmd_context *ctx)
 	if (seeprom_value_seen)
 		seeprom_length = 1;
 
-	if (seeprom_length == -1)
+	if (!seeprom_length_seen)
 		seeprom_length = drvinfo.eedump_len;
 
 	if (drvinfo.eedump_len < seeprom_offset + seeprom_length) {
@@ -4538,15 +4542,17 @@ static int do_getmodule(struct cmd_context *ctx)
 	struct ethtool_modinfo modinfo;
 	struct ethtool_eeprom *eeprom;
 	u32 geeprom_offset = 0;
-	u32 geeprom_length = -1;
+	u32 geeprom_length = 0;
 	int geeprom_changed = 0;
 	int geeprom_dump_raw = 0;
 	int geeprom_dump_hex = 0;
+	int geeprom_length_seen = 0;
 	int err;
 
 	struct cmdline_info cmdline_geeprom[] = {
 		{ "offset", CMDL_U32, &geeprom_offset, NULL },
-		{ "length", CMDL_U32, &geeprom_length, NULL },
+		{ "length", CMDL_U32, &geeprom_length, NULL,
+		  0, &geeprom_length_seen },
 		{ "raw", CMDL_BOOL, &geeprom_dump_raw, NULL },
 		{ "hex", CMDL_BOOL, &geeprom_dump_hex, NULL },
 	};
@@ -4566,7 +4572,7 @@ static int do_getmodule(struct cmd_context *ctx)
 		return 1;
 	}
 
-	if (geeprom_length == -1)
+	if (!geeprom_length_seen)
 		geeprom_length = modinfo.eeprom_len;
 
 	if (modinfo.eeprom_len < geeprom_offset + geeprom_length)
-- 
2.28.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223D624EF86
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 21:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgHWTkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 15:40:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:50794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbgHWTkf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 15:40:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CAC3CAEB1;
        Sun, 23 Aug 2020 19:41:02 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3885C6030D; Sun, 23 Aug 2020 21:40:33 +0200 (CEST)
Message-Id: <8617d049782bee13868d83b2915a3d39895bb60a.1598210544.git.mkubecek@suse.cz>
In-Reply-To: <cover.1598210544.git.mkubecek@suse.cz>
References: <cover.1598210544.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 6/9] get rid of signed/unsigned comparison warnings
 in register dump parsers
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Date:   Sun, 23 Aug 2020 21:40:33 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All of these are avoided by declaring a variable (mostly loop iterators)
holding only unsigned values as unsigned.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 dsa.c      | 2 +-
 fec.c      | 2 +-
 ibm_emac.c | 2 +-
 marvell.c  | 2 +-
 natsemi.c  | 2 +-
 rxclass.c  | 8 +++++---
 sfpdiag.c  | 2 +-
 tg3.c      | 4 ++--
 8 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/dsa.c b/dsa.c
index 65502a899194..33c1d39d6605 100644
--- a/dsa.c
+++ b/dsa.c
@@ -824,8 +824,8 @@ static int dsa_mv88e6xxx_dump_regs(struct ethtool_regs *regs)
 {
 	const struct dsa_mv88e6xxx_switch *sw = NULL;
 	const u16 *data = (u16 *)regs->data;
+	unsigned int i;
 	u16 id;
-	int i;
 
 	/* Marvell chips have 32 per-port 16-bit registers */
 	if (regs->len < 32 * sizeof(u16))
diff --git a/fec.c b/fec.c
index 9cb4f8b1d4e1..d2373d6124c0 100644
--- a/fec.c
+++ b/fec.c
@@ -198,7 +198,7 @@ int fec_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		  struct ethtool_regs *regs)
 {
 	const u32 *data = (u32 *)regs->data;
-	int offset;
+	unsigned int offset;
 	u32 val;
 
 	for (offset = 0; offset < regs->len; offset += 4) {
diff --git a/ibm_emac.c b/ibm_emac.c
index ea01d56f609c..9f7cae605482 100644
--- a/ibm_emac.c
+++ b/ibm_emac.c
@@ -238,7 +238,7 @@ static void *print_mal_regs(void *buf)
 {
 	struct emac_ethtool_regs_subhdr *hdr = buf;
 	struct mal_regs *p = (struct mal_regs *)(hdr + 1);
-	int i;
+	unsigned int i;
 
 	printf("MAL%d Registers\n", hdr->index);
 	printf("-----------------\n");
diff --git a/marvell.c b/marvell.c
index 8afb150327a3..d3d570e4d4ad 100644
--- a/marvell.c
+++ b/marvell.c
@@ -130,7 +130,7 @@ static void dump_fifo(const char *name, const void *p)
 static void dump_gmac_fifo(const char *name, const void *p)
 {
 	const u32 *r = p;
-	int i;
+	unsigned int i;
 	static const char *regs[] = {
 		"End Address",
 		"Almost Full Thresh",
diff --git a/natsemi.c b/natsemi.c
index 0af465959cbc..4d9fc092b623 100644
--- a/natsemi.c
+++ b/natsemi.c
@@ -967,8 +967,8 @@ int
 natsemi_dump_eeprom(struct ethtool_drvinfo *info __maybe_unused,
 		    struct ethtool_eeprom *ee)
 {
-	int i;
 	u16 *eebuf = (u16 *)ee->data;
+	unsigned int i;
 
 	if (ee->magic != NATSEMI_MAGIC) {
 		fprintf(stderr, "Magic number 0x%08x does not match 0x%08x\n",
diff --git a/rxclass.c b/rxclass.c
index 79972651e706..6cf81fdafc85 100644
--- a/rxclass.c
+++ b/rxclass.c
@@ -348,8 +348,9 @@ int rxclass_rule_getall(struct cmd_context *ctx)
 {
 	struct ethtool_rxnfc *nfccmd;
 	__u32 *rule_locs;
-	int err, i;
+	unsigned int i;
 	__u32 count;
+	int err;
 
 	/* determine rule count */
 	err = rxclass_get_dev_info(ctx, &count, NULL);
@@ -481,8 +482,9 @@ static int rmgr_find_empty_slot(struct rmgr_ctrl *rmgr,
 static int rmgr_init(struct cmd_context *ctx, struct rmgr_ctrl *rmgr)
 {
 	struct ethtool_rxnfc *nfccmd;
-	int err, i;
 	__u32 *rule_locs;
+	unsigned int i;
+	int err;
 
 	/* clear rule manager settings */
 	memset(rmgr, 0, sizeof(*rmgr));
@@ -941,7 +943,7 @@ static int rxclass_get_long(char *str, long long *val, int size)
 
 static int rxclass_get_ulong(char *str, unsigned long long *val, int size)
 {
-	long long max = ~0ULL >> (64 - size);
+	unsigned long long max = ~0ULL >> (64 - size);
 	char *endp;
 
 	errno = 0;
diff --git a/sfpdiag.c b/sfpdiag.c
index fa41651422ea..1fa8b7ba8fec 100644
--- a/sfpdiag.c
+++ b/sfpdiag.c
@@ -190,8 +190,8 @@ static float befloattoh(const __u32 *source)
 
 static void sff8472_calibration(const __u8 *id, struct sff_diags *sd)
 {
-	int i;
 	__u16 rx_reading;
+	unsigned int i;
 
 	/* Calibration should occur for all values (threshold and current) */
 	for (i = 0; i < ARRAY_SIZE(sd->bias_cur); ++i) {
diff --git a/tg3.c b/tg3.c
index ac73b33ae4e3..ebdef2d60e6b 100644
--- a/tg3.c
+++ b/tg3.c
@@ -7,7 +7,7 @@
 int tg3_dump_eeprom(struct ethtool_drvinfo *info __maybe_unused,
 		    struct ethtool_eeprom *ee)
 {
-	int i;
+	unsigned int i;
 
 	if (ee->magic != TG3_MAGIC) {
 		fprintf(stderr, "Magic number 0x%08x does not match 0x%08x\n",
@@ -26,7 +26,7 @@ int tg3_dump_eeprom(struct ethtool_drvinfo *info __maybe_unused,
 int tg3_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
 		  struct ethtool_regs *regs)
 {
-	int i;
+	unsigned int i;
 	u32 reg;
 
 	fprintf(stdout, "Offset\tValue\n");
-- 
2.28.0


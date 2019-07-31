Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26E247BB90
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfGaI0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:26:00 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55575 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbfGaIZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:25:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so59786993wmj.5;
        Wed, 31 Jul 2019 01:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ivGcJv42u9xsKXcWxc1pwTe15jdiFq07eZU/Ce/ZJDg=;
        b=TTVQalGPI/gXVk9TBMwBE7O7E07KJdxhVNfqiZUNQvkVAJrEua5Dk0oadr3RlwiqOg
         Nm6OMlbF9cV7HJhjSDwFt++12poRJEjTgOgBSiVkrH78sdE082zopKmnAMAEAnxJBzr6
         48PboFTVeQAJsgl8pYpKMiuYY/FGIkMu3Vqaqhdi8oC3vR6ZLIfLW/uWId9XNAvFVQ6c
         fYzOQ42jmO3i1uhpB1niVJFJvJa0xlk9ZbJ3bWwrk8xC4ZJfOXEwpc2/gMYAr/0N/Fau
         zmiZ/x6uzz8WJH1UvwwiocCvrwPGC+mNwDdaX5WcBGQfN5fsJpK5d2oVf5Gv+8MZH6+f
         BXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ivGcJv42u9xsKXcWxc1pwTe15jdiFq07eZU/Ce/ZJDg=;
        b=dhPkiPdevULyPQ7uswQjr8hMjzoJklXJ0AxDET1hiyDU4gqINWJSebRtIdRjUyycZo
         7/MWMMrXiFiou/MVtxi1RmcHdkc5WTEvTPS/T25qMXyDma4/2vdjy3jIf2BnSAgUyC2x
         hQFmgtyVzZh7JFC2bQ6QYDRaibjLsetNaDFm/rsumKT2tcoTkVfcRd8EBbjv7lmFq5H3
         SHmck6jNRPY8DeVXFImuZnNdraxZ3iEciwrh0jnN8iRfGgHCndNva8O6IQBWjlxXxWsp
         OB9phagjaoc6UKjqCDItAODvsEPNcgJGu6REkLTjWmy3ujnsK9Plnn3WqFkROoo215C7
         kZ5A==
X-Gm-Message-State: APjAAAV6OKCxP9mN4JTEtfnqiJzgBDKv8AOAB3BsMmENvhF9c+ZUbWDR
        Ff52l/TuuffaKvt32X1VXlA9hEnpJoU=
X-Google-Smtp-Source: APXvYqwz+yc8zkVNN/feyEHRqL/AEMz13uLWrgyHp+IJT1Xc7OxDf7XKEhueMoWf61mpNG6w9dIfAA==
X-Received: by 2002:a05:600c:214c:: with SMTP id v12mr109623683wml.28.1564561550263;
        Wed, 31 Jul 2019 01:25:50 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id c78sm93223959wmd.16.2019.07.31.01.25.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 01:25:49 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 6/6] net: dsa: mv88e6xxx: add PTP support for MV88E6250 family
Date:   Wed, 31 Jul 2019 10:23:51 +0200
Message-Id: <20190731082351.3157-7-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190731082351.3157-1-h.feurstein@gmail.com>
References: <20190731082351.3157-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds PTP support for the MV88E6250 family.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  4 ++
 drivers/net/dsa/mv88e6xxx/chip.h |  4 ++
 drivers/net/dsa/mv88e6xxx/ptp.c  | 79 +++++++++++++++++++++++++++-----
 drivers/net/dsa/mv88e6xxx/ptp.h  |  2 +
 4 files changed, 78 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 75cfa1f2060b..4a79e389eb8b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3522,6 +3522,8 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.reset = mv88e6250_g1_reset,
 	.vtu_getnext = mv88e6250_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6250_g1_vtu_loadpurge,
+	.avb_ops = &mv88e6352_avb_ops,
+	.ptp_ops = &mv88e6250_ptp_ops,
 	.phylink_validate = mv88e6065_phylink_validate,
 };
 
@@ -4318,6 +4320,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.dual_chip = true,
 		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.ptp_support = true,
 		.ops = &mv88e6250_ops,
 	},
 
@@ -4363,6 +4366,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.dual_chip = true,
 		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.ptp_support = true,
 		.ops = &mv88e6250_ops,
 	},
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e7b88e9643b9..8c6d3c906197 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -539,6 +539,10 @@ struct mv88e6xxx_ptp_ops {
 	int arr1_sts_reg;
 	int dep_sts_reg;
 	u32 rx_filters;
+	u32 cc_shift;
+	u32 cc_mult;
+	u32 cc_mult_num;
+	u32 cc_mult_dem;
 };
 
 #define STATS_TYPE_PORT		BIT(0)
diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index a1ff182c8737..073cbd0bb91b 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -15,11 +15,31 @@
 #include "hwtstamp.h"
 #include "ptp.h"
 
-/* Raw timestamps are in units of 8-ns clock periods. */
-#define CC_SHIFT	28
-#define CC_MULT		(8 << CC_SHIFT)
-#define CC_MULT_NUM	(1 << 9)
-#define CC_MULT_DEM	15625ULL
+#define MV88E6XXX_MAX_ADJ_PPB	1000000
+
+/* Family MV88E6250:
+ * Raw timestamps are in units of 10-ns clock periods.
+ *
+ * clkadj = scaled_ppm * 10*2^28 / (10^6 * 2^16)
+ * simplifies to
+ * clkadj = scaled_ppm * 2^7 / 5^5
+ */
+#define MV88E6250_CC_SHIFT	28
+#define MV88E6250_CC_MULT	(10 << MV88E6250_CC_SHIFT)
+#define MV88E6250_CC_MULT_NUM	(1 << 7)
+#define MV88E6250_CC_MULT_DEM	3125ULL
+
+/* Other families:
+ * Raw timestamps are in units of 8-ns clock periods.
+ *
+ * clkadj = scaled_ppm * 8*2^28 / (10^6 * 2^16)
+ * simplifies to
+ * clkadj = scaled_ppm * 2^9 / 5^6
+ */
+#define MV88E6XXX_CC_SHIFT	28
+#define MV88E6XXX_CC_MULT	(8 << MV88E6XXX_CC_SHIFT)
+#define MV88E6XXX_CC_MULT_NUM	(1 << 9)
+#define MV88E6XXX_CC_MULT_DEM	15625ULL
 
 #define TAI_EVENT_WORK_INTERVAL msecs_to_jiffies(100)
 
@@ -179,6 +199,7 @@ static void mv88e6352_tai_event_work(struct work_struct *ugly)
 static int mv88e6xxx_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct mv88e6xxx_chip *chip = ptp_to_chip(ptp);
+	const struct mv88e6xxx_ptp_ops *ptp_ops = chip->info->ops->ptp_ops;
 	int neg_adj = 0;
 	u32 diff, mult;
 	u64 adj;
@@ -187,10 +208,11 @@ static int mv88e6xxx_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 		neg_adj = 1;
 		scaled_ppm = -scaled_ppm;
 	}
-	mult = CC_MULT;
-	adj = CC_MULT_NUM;
+
+	mult = ptp_ops->cc_mult;
+	adj = ptp_ops->cc_mult_num;
 	adj *= scaled_ppm;
-	diff = div_u64(adj, CC_MULT_DEM);
+	diff = div_u64(adj, ptp_ops->cc_mult_dem);
 
 	mv88e6xxx_reg_lock(chip);
 
@@ -324,6 +346,37 @@ const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops = {
 		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ),
+	.cc_shift = MV88E6XXX_CC_SHIFT,
+	.cc_mult = MV88E6XXX_CC_MULT,
+	.cc_mult_num = MV88E6XXX_CC_MULT_NUM,
+	.cc_mult_dem = MV88E6XXX_CC_MULT_DEM,
+};
+
+const struct mv88e6xxx_ptp_ops mv88e6250_ptp_ops = {
+	.clock_read = mv88e6352_ptp_clock_read,
+	.ptp_enable = mv88e6352_ptp_enable,
+	.ptp_verify = mv88e6352_ptp_verify,
+	.event_work = mv88e6352_tai_event_work,
+	.port_enable = mv88e6352_hwtstamp_port_enable,
+	.port_disable = mv88e6352_hwtstamp_port_disable,
+	.n_ext_ts = 1,
+	.arr0_sts_reg = MV88E6XXX_PORT_PTP_ARR0_STS,
+	.arr1_sts_reg = MV88E6XXX_PORT_PTP_ARR1_STS,
+	.dep_sts_reg = MV88E6XXX_PORT_PTP_DEP_STS,
+	.rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L4_SYNC) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_SYNC) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ),
+	.cc_shift = MV88E6250_CC_SHIFT,
+	.cc_mult = MV88E6250_CC_MULT,
+	.cc_mult_num = MV88E6250_CC_MULT_NUM,
+	.cc_mult_dem = MV88E6250_CC_MULT_DEM,
 };
 
 const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {
@@ -347,6 +400,10 @@ const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {
 		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ),
+	.cc_shift = MV88E6XXX_CC_SHIFT,
+	.cc_mult = MV88E6XXX_CC_MULT,
+	.cc_mult_num = MV88E6XXX_CC_MULT_NUM,
+	.cc_mult_dem = MV88E6XXX_CC_MULT_DEM,
 };
 
 static u64 mv88e6xxx_ptp_clock_read(const struct cyclecounter *cc)
@@ -384,8 +441,8 @@ int mv88e6xxx_ptp_setup(struct mv88e6xxx_chip *chip)
 	memset(&chip->tstamp_cc, 0, sizeof(chip->tstamp_cc));
 	chip->tstamp_cc.read	= mv88e6xxx_ptp_clock_read;
 	chip->tstamp_cc.mask	= CYCLECOUNTER_MASK(32);
-	chip->tstamp_cc.mult	= CC_MULT;
-	chip->tstamp_cc.shift	= CC_SHIFT;
+	chip->tstamp_cc.mult	= ptp_ops->cc_mult;
+	chip->tstamp_cc.shift	= ptp_ops->cc_shift;
 
 	timecounter_init(&chip->tstamp_tc, &chip->tstamp_cc,
 			 ktime_to_ns(ktime_get_real()));
@@ -397,7 +454,6 @@ int mv88e6xxx_ptp_setup(struct mv88e6xxx_chip *chip)
 	chip->ptp_clock_info.owner = THIS_MODULE;
 	snprintf(chip->ptp_clock_info.name, sizeof(chip->ptp_clock_info.name),
 		 "%s", dev_name(chip->dev));
-	chip->ptp_clock_info.max_adj	= 1000000;
 
 	chip->ptp_clock_info.n_ext_ts	= ptp_ops->n_ext_ts;
 	chip->ptp_clock_info.n_per_out	= 0;
@@ -413,6 +469,7 @@ int mv88e6xxx_ptp_setup(struct mv88e6xxx_chip *chip)
 	}
 	chip->ptp_clock_info.pin_config = chip->pin_config;
 
+	chip->ptp_clock_info.max_adj    = MV88E6XXX_MAX_ADJ_PPB;
 	chip->ptp_clock_info.adjfine	= mv88e6xxx_ptp_adjfine;
 	chip->ptp_clock_info.adjtime	= mv88e6xxx_ptp_adjtime;
 	chip->ptp_clock_info.gettime64	= mv88e6xxx_ptp_gettime;
diff --git a/drivers/net/dsa/mv88e6xxx/ptp.h b/drivers/net/dsa/mv88e6xxx/ptp.h
index 58cbd21d58f6..269d5d16a466 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.h
+++ b/drivers/net/dsa/mv88e6xxx/ptp.h
@@ -149,6 +149,7 @@ void mv88e6xxx_ptp_free(struct mv88e6xxx_chip *chip);
 				      ptp_clock_info)
 
 extern const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops;
+extern const struct mv88e6xxx_ptp_ops mv88e6250_ptp_ops;
 extern const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops;
 
 #else /* !CONFIG_NET_DSA_MV88E6XXX_PTP */
@@ -168,6 +169,7 @@ static inline void mv88e6xxx_ptp_free(struct mv88e6xxx_chip *chip)
 }
 
 static const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops = {};
+static const struct mv88e6xxx_ptp_ops mv88e6250_ptp_ops = {};
 static const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {};
 
 #endif /* CONFIG_NET_DSA_MV88E6XXX_PTP */
-- 
2.22.0


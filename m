Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF79B7A595
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732427AbfG3KGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:06:07 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36375 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732400AbfG3KGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 06:06:05 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so51968982wme.1;
        Tue, 30 Jul 2019 03:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eQ5m96viicp/uKrw4YilGeqaBwgd5Q/OqI86QnY1rs4=;
        b=Z8MRMFxUTTwFRGe+phpPHZeoMYIMDq7Ro5dHn4cnIbdyUCLAcICzL0+nEjo8ACdtDx
         ZZDVuvjmQ2e/Wa10fDt227TewV1XWhlimf6vttBhmgmjTB/YDm0QVKWeMzMKKQo9fLrC
         yuYYvakuC8xfVy7lnD94q1hzKkyVJebu20T6eF/vqGjmJaqzGk9TREs/4KTh3XTdon7s
         vvD6oyT7Yd+yHbWYwCuFlmdJcH6Ua2L2MdzOhevuIF33XSQvPF8+EUUg51jdXjYcq8ek
         QaVC4ieTntcZg1PwMLdWmVSfm2XFV7jUgruBg9cKMkZQQhMtR7hdid5AWgDrwUrNe6Rb
         zniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eQ5m96viicp/uKrw4YilGeqaBwgd5Q/OqI86QnY1rs4=;
        b=bDWziGXpwV+qIo7eGaAXRZuY9D+qOWufzD/JYqHrgmznwXwMMjUJOGw6emV0dc323p
         RjcHptsXlv6irczwx4JY34lvwkXtza/MF9cP4X6uf/+x11wXOM+likM6NThYD0uH4pfa
         Ss4DkktwOeUKNSGyKUmFOtzJ/Fa4rU/IgwnIKmzCVaJ7yL4TLHXdLgLAP3T78b0vulNY
         fO43O0wSvFQUDx/UjG1pxwglj9BmQsvRyFmllqzWDHcp6vDKe4KxBYQXCxLZlyJVb8k+
         vcSAXoCy2/Gj342+eKyXWVZGjcfAa2vSyoTR5fKO7oBoEJ3OoqU+gtxZ5a0T05AZK9nm
         OiIg==
X-Gm-Message-State: APjAAAXTGRGfRe0Eit2hgD8BGhxPZ97QqnpIimmn2c+3qRDS/z2W2AY1
        uAsOMom+lWKHeipLtk1xtQ73OqfTjT4=
X-Google-Smtp-Source: APXvYqzC4rjnsH22kDsr4du5VTvV6rIbK5bv/67ooBr2VVThufKjgsjLtOsX+goHrgA51OkaF3fDRg==
X-Received: by 2002:a1c:cc0d:: with SMTP id h13mr102055747wmb.119.1564481162555;
        Tue, 30 Jul 2019 03:06:02 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id n9sm108236322wrp.54.2019.07.30.03.06.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 03:06:01 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH 4/4] net: dsa: mv88e6xxx: add PTP support for MV88E6250 family
Date:   Tue, 30 Jul 2019 12:04:29 +0200
Message-Id: <20190730100429.32479-5-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190730100429.32479-1-h.feurstein@gmail.com>
References: <20190730100429.32479-1-h.feurstein@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/ptp.c  | 73 ++++++++++++++++++++++----------
 3 files changed, 59 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c2fb4ea66434..58e298cc90e0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3514,6 +3514,8 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.reset = mv88e6250_g1_reset,
 	.vtu_getnext = mv88e6250_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6250_g1_vtu_loadpurge,
+	.avb_ops = &mv88e6352_avb_ops,
+	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_validate = mv88e6065_phylink_validate,
 };
 
@@ -4333,6 +4335,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.dual_chip = true,
 		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.ptp_support = true,
 		.ops = &mv88e6250_ops,
 	},
 
@@ -4354,6 +4357,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.dual_chip = true,
 		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.ptp_support = true,
 		.ops = &mv88e6250_ops,
 	},
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 720cace3db4e..64872251e479 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -273,6 +273,10 @@ struct mv88e6xxx_chip {
 	u16 trig_config;
 	u16 evcap_config;
 	u16 enable_count;
+	u32 ptp_cc_shift;
+	u32 ptp_cc_mult;
+	u32 ptp_cc_mult_num;
+	u32 ptp_cc_mult_dem;
 
 	/* Per-port timestamping resources. */
 	struct mv88e6xxx_port_hwtstamp port_hwtstamp[DSA_MAX_PORTS];
diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index 768d256f7c9f..51cdf4712517 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -15,11 +15,38 @@
 #include "hwtstamp.h"
 #include "ptp.h"
 
-/* Raw timestamps are in units of 8-ns clock periods. */
-#define CC_SHIFT	28
-#define CC_MULT		(8 << CC_SHIFT)
-#define CC_MULT_NUM	(1 << 9)
-#define CC_MULT_DEM	15625ULL
+/* The adjfine API clamps ppb between [-32,768,000, 32,768,000], and
+ * therefore scaled_ppm between [-2,147,483,648, 2,147,483,647].
+ * Set the maximum supported ppb to a round value smaller than the maximum.
+ *
+ * Percentually speaking, this is a +/- 0.032x adjustment of the
+ * free-running counter (0.968x to 1.032x).
+ */
+#define MV88E6XXX_MAX_ADJ_PPB	32000000
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
 
@@ -179,24 +206,14 @@ static void mv88e6352_tai_event_work(struct work_struct *ugly)
 static int mv88e6xxx_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct mv88e6xxx_chip *chip = ptp_to_chip(ptp);
-	int neg_adj = 0;
-	u32 diff, mult;
-	u64 adj;
+	s64 adj;
 
-	if (scaled_ppm < 0) {
-		neg_adj = 1;
-		scaled_ppm = -scaled_ppm;
-	}
-	mult = CC_MULT;
-	adj = CC_MULT_NUM;
-	adj *= scaled_ppm;
-	diff = div_u64(adj, CC_MULT_DEM);
+	adj = (s64)scaled_ppm * chip->ptp_cc_mult_num;
+	adj = div_s64(adj, chip->ptp_cc_mult_dem);
 
 	mv88e6xxx_reg_lock(chip);
-
 	timecounter_read(&chip->tstamp_tc);
-	chip->tstamp_cc.mult = neg_adj ? mult - diff : mult + diff;
-
+	chip->tstamp_cc.mult = chip->ptp_cc_mult + adj;
 	mv88e6xxx_reg_unlock(chip);
 
 	return 0;
@@ -380,12 +397,24 @@ int mv88e6xxx_ptp_setup(struct mv88e6xxx_chip *chip)
 	const struct mv88e6xxx_ptp_ops *ptp_ops = chip->info->ops->ptp_ops;
 	int i;
 
+	if (chip->info->family == MV88E6XXX_FAMILY_6250) {
+		chip->ptp_cc_shift	= MV88E6250_CC_SHIFT;
+		chip->ptp_cc_mult	= MV88E6250_CC_MULT;
+		chip->ptp_cc_mult_num	= MV88E6250_CC_MULT_NUM;
+		chip->ptp_cc_mult_dem	= MV88E6250_CC_MULT_DEM;
+	} else {
+		chip->ptp_cc_shift	= MV88E6XXX_CC_SHIFT;
+		chip->ptp_cc_mult	= MV88E6XXX_CC_MULT;
+		chip->ptp_cc_mult_num	= MV88E6XXX_CC_MULT_NUM;
+		chip->ptp_cc_mult_dem	= MV88E6XXX_CC_MULT_DEM;
+	}
+
 	/* Set up the cycle counter */
 	memset(&chip->tstamp_cc, 0, sizeof(chip->tstamp_cc));
 	chip->tstamp_cc.read	= mv88e6xxx_ptp_clock_read;
 	chip->tstamp_cc.mask	= CYCLECOUNTER_MASK(32);
-	chip->tstamp_cc.mult	= CC_MULT;
-	chip->tstamp_cc.shift	= CC_SHIFT;
+	chip->tstamp_cc.mult	= chip->ptp_cc_mult;
+	chip->tstamp_cc.shift	= chip->ptp_cc_shift;
 
 	timecounter_init(&chip->tstamp_tc, &chip->tstamp_cc,
 			 ktime_to_ns(ktime_get_real()));
@@ -397,7 +426,6 @@ int mv88e6xxx_ptp_setup(struct mv88e6xxx_chip *chip)
 	chip->ptp_clock_info.owner = THIS_MODULE;
 	snprintf(chip->ptp_clock_info.name, sizeof(chip->ptp_clock_info.name),
 		 "%s", dev_name(chip->dev));
-	chip->ptp_clock_info.max_adj	= 1000000;
 
 	chip->ptp_clock_info.n_ext_ts	= ptp_ops->n_ext_ts;
 	chip->ptp_clock_info.n_per_out	= 0;
@@ -413,6 +441,7 @@ int mv88e6xxx_ptp_setup(struct mv88e6xxx_chip *chip)
 	}
 	chip->ptp_clock_info.pin_config = chip->pin_config;
 
+	chip->ptp_clock_info.max_adj    = MV88E6XXX_MAX_ADJ_PPB;
 	chip->ptp_clock_info.adjfine	= mv88e6xxx_ptp_adjfine;
 	chip->ptp_clock_info.adjtime	= mv88e6xxx_ptp_adjtime;
 	chip->ptp_clock_info.gettime64	= mv88e6xxx_ptp_gettime;
-- 
2.22.0


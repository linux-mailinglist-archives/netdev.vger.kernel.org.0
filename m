Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933D6692691
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbjBJTha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbjBJThS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:37:18 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8375963582
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:05 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id n2so2625002ili.11
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HVYVyNTkUa3iGKfuLHzuBXmuy7vkfW4Nl2UJ0t6eQqU=;
        b=co7rtb0LadAJvSmsz890Kjp+qHs2QfPeTXJ9t98gtx7hnlakxdic27dCc6Co9AIxgs
         kVn4susiIt9H2ph3nt0obv4ZY88GZUmeNDe6KFucXiLecboALVkzeP9/1AFi01Ha8kPU
         JhmzebnZiQYvqR/OstZ2Rbe2xac71XOmbxDSsN5C3vvTRhvJaKYtLgeKQlE/bYqXAc+V
         84VXd5KbJVPkSWcek3rBdaN2b0UjVFnBWekeXboiZwZ/G1UmchdnVXGViqGEQFmkm9qM
         siSGaamj89Riflr0cGIF6u9tH99zjXSLvX7pNTt+ZmTGgU1BvH5Gvgu2fVtkA20yVyVx
         bOaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HVYVyNTkUa3iGKfuLHzuBXmuy7vkfW4Nl2UJ0t6eQqU=;
        b=J+gpdnHRdGiyXshVQuZTBZZmr+BZEHRCvmaLJ3GTTMHfn/dIHtht5BGAA3c4gbCZY5
         0NZPaYfK2h/JIwdYn0QsWXSJLAYog3+S9oznLMYNLLAqTQJx3Rob0eH5tfHQr3yp9opR
         kxIUzhsfUQMfwJzILyiuwirLA2DrtNvpqMr+zsyuznIS8kX9PwhFTIwev06vOl8g5DUE
         ZM5Juvyi57jwq0Uh3kvN6GUbaRZgb9AObRf3Rba1AQ9AqMpsWp+nCohXdedE1p3vQnLN
         BZHs5MO9/sPMpH2wwL3a7yQNZzzQhLvjcVuTMUPihsAzXGpSRsVJyOhgqXBBUiINYTxn
         DiVg==
X-Gm-Message-State: AO0yUKUERPrh3Daq7pCWwElGNrORlIJl/oFEQvhygWDMSP9hmeOtxZHs
        3dJn8TKuoO8bh1O/JKAGlrpOVg==
X-Google-Smtp-Source: AK7set9chwDoefHK85f06fQ2Mt2QZPRuKySQhMCYGupdY+mzqLsgpoX3T4YF2KcvxrpZKmWY5hP62A==
X-Received: by 2002:a05:6e02:1a82:b0:311:453:2fe3 with SMTP id k2-20020a056e021a8200b0031104532fe3mr17607392ilv.5.1676057824809;
        Fri, 10 Feb 2023 11:37:04 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id 14-20020a056e020cae00b00304ae88ebebsm1530692ilg.88.2023.02.10.11.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:37:04 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/8] net: ipa: start creating GSI register definitions
Date:   Fri, 10 Feb 2023 13:36:50 -0600
Message-Id: <20230210193655.460225-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230210193655.460225-1-elder@linaro.org>
References: <20230210193655.460225-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new register definition file in the "reg" subdirectory,
and begin populating it with GSI register definitions based on IPA
version.  The GSI registers haven't changed much, so several IPA
versions can share the same GSI register definitions.

As with IPA registers, an array of pointers indexed by GSI register ID
refers to these register definitions, and a new "regs" field in the
GSI structure is initialized in gsi_reg_init() to refer to register
information based on the IPA version (though for now there's only
one).  The new function gsi_reg() returns register information for
a given GSI register, and the result can be used to look up that
register's offset.

This patch is meant only to put the infrastructure in place, so only
eon register (CH_C_QOS) is defined for each version, and only the
offset and stride are defined for that register.  Use new function
gsi_reg() to look up that register's information to get its offset,
This makes the GSI_CH_C_QOS_OFFSET() unnecessary, so get rid of it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile           |  5 +++++
 drivers/net/ipa/gsi.c              |  6 +++++-
 drivers/net/ipa/gsi.h              |  4 +++-
 drivers/net/ipa/gsi_reg.c          | 34 ++++++++++++++++++++++++++++--
 drivers/net/ipa/gsi_reg.h          | 12 +++++++++--
 drivers/net/ipa/reg/gsi_reg-v3.1.c | 20 ++++++++++++++++++
 6 files changed, 75 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v3.1.c

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 166ef86f7ad3f..d87f2cfe08c61 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -4,6 +4,9 @@
 
 IPA_VERSIONS		:=	3.1 3.5.1 4.2 4.5 4.7 4.9 4.11
 
+# Some IPA versions can reuse another set of GSI register definitions.
+GSI_IPA_VERSIONS	:=	3.1
+
 obj-$(CONFIG_QCOM_IPA)	+=	ipa.o
 
 ipa-y			:=	ipa_main.o ipa_power.o ipa_reg.o ipa_mem.o \
@@ -13,6 +16,8 @@ ipa-y			:=	ipa_main.o ipa_power.o ipa_reg.o ipa_mem.o \
 				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o \
 				ipa_sysfs.o
 
+ipa-y			+=	$(GSI_IPA_VERSIONS:%=reg/gsi_reg-v%.o)
+
 ipa-y			+=	$(IPA_VERSIONS:%=reg/ipa_reg-v%.o)
 
 ipa-y			+=	$(IPA_VERSIONS:%=data/ipa_data-v%.o)
diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index a000bef49f8e5..f07b7554d21fd 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -16,6 +16,7 @@
 #include <linux/netdevice.h>
 
 #include "gsi.h"
+#include "reg.h"
 #include "gsi_reg.h"
 #include "gsi_private.h"
 #include "gsi_trans.h"
@@ -796,6 +797,7 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	union gsi_channel_scratch scr = { };
 	struct gsi_channel_scratch_gpi *gpi;
 	struct gsi *gsi = channel->gsi;
+	const struct reg *reg;
 	u32 wrr_weight = 0;
 	u32 val;
 
@@ -819,6 +821,8 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	val = upper_32_bits(channel->tre_ring.addr);
 	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_3_OFFSET(channel_id));
 
+	reg = gsi_reg(gsi, CH_C_QOS);
+
 	/* Command channel gets low weighted round-robin priority */
 	if (channel->command)
 		wrr_weight = field_max(WRR_WEIGHT_FMASK);
@@ -845,7 +849,7 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	if (gsi->version >= IPA_VERSION_4_9)
 		val |= DB_IN_BYTES;
 
-	iowrite32(val, gsi->virt + GSI_CH_C_QOS_OFFSET(channel_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, channel_id));
 
 	/* Now update the scratch registers for GPI protocol */
 	gpi = &scr.gpi;
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 49dcadba4e0b9..bc5ff617341a7 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2022 Linaro Ltd.
+ * Copyright (C) 2018-2023 Linaro Ltd.
  */
 #ifndef _GSI_H_
 #define _GSI_H_
@@ -142,6 +142,8 @@ struct gsi {
 	enum ipa_version version;
 	void __iomem *virt_raw;		/* I/O mapped address range */
 	void __iomem *virt;		/* Adjusted for most registers */
+	const struct regs *regs;
+
 	u32 irq;
 	u32 channel_count;
 	u32 evt_ring_count;
diff --git a/drivers/net/ipa/gsi_reg.c b/drivers/net/ipa/gsi_reg.c
index c20b3bcdd4151..2334244d40da0 100644
--- a/drivers/net/ipa/gsi_reg.c
+++ b/drivers/net/ipa/gsi_reg.c
@@ -6,6 +6,7 @@
 #include <linux/io.h>
 
 #include "gsi.h"
+#include "reg.h"
 #include "gsi_reg.h"
 
 /* GSI EE registers as a group are shifted downward by a fixed constant amount
@@ -85,6 +86,31 @@ static bool gsi_reg_id_valid(struct gsi *gsi, enum gsi_reg_id reg_id)
 	}
 }
 
+const struct reg *gsi_reg(struct gsi *gsi, enum gsi_reg_id reg_id)
+{
+	if (WARN(!gsi_reg_id_valid(gsi, reg_id), "invalid reg %u\n", reg_id))
+		return NULL;
+
+	return reg(gsi->regs, reg_id);
+}
+
+static const struct regs *gsi_regs(struct gsi *gsi)
+{
+	switch (gsi->version) {
+	case IPA_VERSION_3_1:
+	case IPA_VERSION_3_5_1:
+	case IPA_VERSION_4_2:
+	case IPA_VERSION_4_5:
+	case IPA_VERSION_4_7:
+	case IPA_VERSION_4_9:
+	case IPA_VERSION_4_11:
+		return &gsi_regs_v3_1;
+
+	default:
+		return NULL;
+	}
+}
+
 /* Sets gsi->virt_raw and gsi->virt, and I/O maps the "gsi" memory range */
 int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
 {
@@ -93,8 +119,6 @@ int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
 	resource_size_t size;
 	u32 adjust;
 
-	(void)gsi_reg_id_valid;	/* Avoid a warning */
-
 	/* Get GSI memory range and map it */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gsi");
 	if (!res) {
@@ -116,6 +140,12 @@ int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	gsi->regs = gsi_regs(gsi);
+	if (!gsi->regs) {
+		dev_err(dev, "unsupported IPA version %u (?)\n", gsi->version);
+		return -EINVAL;
+	}
+
 	gsi->virt_raw = ioremap(res->start, size);
 	if (!gsi->virt_raw) {
 		dev_err(dev, "unable to remap \"gsi\" memory\n");
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 1f613cd677b01..398546fbfd697 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -140,8 +140,7 @@ enum gsi_channel_type {
 #define GSI_CH_C_CNTXT_3_OFFSET(ch) \
 			(0x0001c00c + 0x4000 * GSI_EE_AP + 0x80 * (ch))
 
-#define GSI_CH_C_QOS_OFFSET(ch) \
-			(0x0001c05c + 0x4000 * GSI_EE_AP + 0x80 * (ch))
+/* CH_C_QOS register */
 #define WRR_WEIGHT_FMASK		GENMASK(3, 0)
 #define MAX_PREFETCH_FMASK		GENMASK(8, 8)
 #define USE_DB_ENG_FMASK		GENMASK(9, 9)
@@ -443,6 +442,15 @@ enum gsi_generic_ee_result {
 	GENERIC_EE_NO_RESOURCES			= 0x7,
 };
 
+extern const struct regs gsi_regs_v3_1;
+
+/**
+ * gsi_reg() - Return the structure describing a GSI register
+ * @gsi:	GSI pointer
+ * @reg_id:	GSI register ID
+ */
+const struct reg *gsi_reg(struct gsi *gsi, enum gsi_reg_id reg_id);
+
 /**
  * gsi_reg_init() - Perform GSI register initialization
  * @gsi:	GSI pointer
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
new file mode 100644
index 0000000000000..c4d4beb7738f3
--- /dev/null
+++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2023 Linaro Ltd. */
+
+#include <linux/types.h>
+
+#include "../gsi.h"
+#include "../reg.h"
+#include "../gsi_reg.h"
+
+REG_STRIDE(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
+
+static const struct reg *reg_array[] = {
+	[CH_C_QOS]			= &reg_ch_c_qos,
+};
+
+const struct regs gsi_regs_v3_1 = {
+	.reg_count	= ARRAY_SIZE(reg_array),
+	.reg		= reg_array,
+};
-- 
2.34.1


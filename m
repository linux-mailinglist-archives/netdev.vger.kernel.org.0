Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF24692DB1
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjBKDTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBKDTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:19:01 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC08880D6;
        Fri, 10 Feb 2023 19:18:45 -0800 (PST)
Received: from localhost (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 1719D6602112;
        Sat, 11 Feb 2023 03:18:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676085524;
        bh=dWT0RanDNiM3R2DCgFc/XbzaC63mZATcL9ooscBLbYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEECfIzkegZFxQGlNbEk0xpVXMYbfsjuxNV0jzVV+mhag3vfoFisKqwcwAejSdADU
         c2tk68Yksshis0/Wo96/mdHLwprlFo1d7gT4NWnVZo4FhmuA3vb8qRWnxx5jPtgXWv
         b/pV/VG5UGPafKrQc9OH4xX5/PaK4lgE+77yMgpU1Bz0QdUXAVG4RG5L9OgAoYqk8P
         iQzRVEev8TgYOSWRcZ+nLYNmv7Ycrz7LIMBI0fVjR8NpLZy9o8IZDtO3Y2KKPhWK6X
         asyOruKtVqPgbh/86k8oWarMwscItXxCD4n4rBW0WRhCtDtEcFkJUN2o7DMhhM26VZ
         Q2BNo4v2uF72Q==
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
To:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: [PATCH 04/12] soc: sifive: ccache: Add non-coherent DMA handling
Date:   Sat, 11 Feb 2023 05:18:13 +0200
Message-Id: <20230211031821.976408-5-cristian.ciocaltea@collabora.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emil Renner Berthing <kernel@esmil.dk>

Add functions to flush the caches and handle non-coherent DMA.

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
[replace <asm/cacheflush.h> with <linux/cacheflush.h>]
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
---
 drivers/soc/sifive/sifive_ccache.c | 60 +++++++++++++++++++++++++++++-
 include/soc/sifive/sifive_ccache.h | 21 +++++++++++
 2 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/sifive/sifive_ccache.c b/drivers/soc/sifive/sifive_ccache.c
index 676468c35859..0062635d845f 100644
--- a/drivers/soc/sifive/sifive_ccache.c
+++ b/drivers/soc/sifive/sifive_ccache.c
@@ -8,13 +8,16 @@
 
 #define pr_fmt(fmt) "CCACHE: " fmt
 
+#include <linux/align.h>
 #include <linux/debugfs.h>
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <linux/device.h>
 #include <linux/bitfield.h>
+#include <linux/cacheflush.h>
 #include <asm/cacheinfo.h>
+#include <asm/page.h>
 #include <soc/sifive/sifive_ccache.h>
 
 #define SIFIVE_CCACHE_DIRECCFIX_LOW 0x100
@@ -39,10 +42,14 @@
 #define SIFIVE_CCACHE_CONFIG_SETS_MASK GENMASK_ULL(23, 16)
 #define SIFIVE_CCACHE_CONFIG_BLKS_MASK GENMASK_ULL(31, 24)
 
+#define SIFIVE_CCACHE_FLUSH64 0x200
+#define SIFIVE_CCACHE_FLUSH32 0x240
+
 #define SIFIVE_CCACHE_WAYENABLE 0x08
 #define SIFIVE_CCACHE_ECCINJECTERR 0x40
 
 #define SIFIVE_CCACHE_MAX_ECCINTR 4
+#define SIFIVE_CCACHE_LINE_SIZE 64
 
 static void __iomem *ccache_base;
 static int g_irq[SIFIVE_CCACHE_MAX_ECCINTR];
@@ -125,6 +132,47 @@ int unregister_sifive_ccache_error_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(unregister_sifive_ccache_error_notifier);
 
+#ifdef CONFIG_RISCV_DMA_NONCOHERENT
+static phys_addr_t uncached_offset;
+DEFINE_STATIC_KEY_FALSE(sifive_ccache_handle_noncoherent_key);
+
+void sifive_ccache_flush_range(phys_addr_t start, size_t len)
+{
+	phys_addr_t end = start + len;
+	phys_addr_t line;
+
+	if (!len)
+		return;
+
+	mb();
+	for (line = ALIGN_DOWN(start, SIFIVE_CCACHE_LINE_SIZE); line < end;
+			line += SIFIVE_CCACHE_LINE_SIZE) {
+#ifdef CONFIG_32BIT
+		writel(line >> 4, ccache_base + SIFIVE_CCACHE_FLUSH32);
+#else
+		writeq(line, ccache_base + SIFIVE_CCACHE_FLUSH64);
+#endif
+		mb();
+	}
+}
+EXPORT_SYMBOL_GPL(sifive_ccache_flush_range);
+
+void *sifive_ccache_set_uncached(void *addr, size_t size)
+{
+	phys_addr_t phys_addr = __pa(addr) + uncached_offset;
+	void *mem_base;
+
+	mem_base = memremap(phys_addr, size, MEMREMAP_WT);
+	if (!mem_base) {
+		pr_err("%s memremap failed for addr %p\n", __func__, addr);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return mem_base;
+}
+EXPORT_SYMBOL_GPL(sifive_ccache_set_uncached);
+#endif /* CONFIG_RISCV_DMA_NONCOHERENT */
+
 static int ccache_largest_wayenabled(void)
 {
 	return readl(ccache_base + SIFIVE_CCACHE_WAYENABLE) & 0xFF;
@@ -213,6 +261,7 @@ static int __init sifive_ccache_init(void)
 	int i, rc, intr_num;
 	const struct of_device_id *match;
 	unsigned long broken_irqs;
+	u64 __maybe_unused offset;
 
 	np = of_find_matching_node_and_match(NULL, sifive_ccache_ids, &match);
 	if (!np)
@@ -258,6 +307,15 @@ static int __init sifive_ccache_init(void)
 	}
 	of_node_put(np);
 
+#ifdef CONFIG_RISCV_DMA_NONCOHERENT
+	if (!of_property_read_u64(np, "uncached-offset", &offset)) {
+		uncached_offset = offset;
+		static_branch_enable(&sifive_ccache_handle_noncoherent_key);
+		riscv_cbom_block_size = SIFIVE_CCACHE_LINE_SIZE;
+		riscv_noncoherent_supported();
+	}
+#endif
+
 	ccache_config_read();
 
 	ccache_cache_ops.get_priv_group = ccache_get_priv_group;
@@ -278,4 +336,4 @@ static int __init sifive_ccache_init(void)
 	return rc;
 }
 
-device_initcall(sifive_ccache_init);
+arch_initcall(sifive_ccache_init);
diff --git a/include/soc/sifive/sifive_ccache.h b/include/soc/sifive/sifive_ccache.h
index 4d4ed49388a0..d349ccb3969b 100644
--- a/include/soc/sifive/sifive_ccache.h
+++ b/include/soc/sifive/sifive_ccache.h
@@ -7,10 +7,31 @@
 #ifndef __SOC_SIFIVE_CCACHE_H
 #define __SOC_SIFIVE_CCACHE_H
 
+#include <linux/io.h>
+#include <linux/jump_label.h>
+
 extern int register_sifive_ccache_error_notifier(struct notifier_block *nb);
 extern int unregister_sifive_ccache_error_notifier(struct notifier_block *nb);
 
 #define SIFIVE_CCACHE_ERR_TYPE_CE 0
 #define SIFIVE_CCACHE_ERR_TYPE_UE 1
 
+DECLARE_STATIC_KEY_FALSE(sifive_ccache_handle_noncoherent_key);
+
+static inline bool sifive_ccache_handle_noncoherent(void)
+{
+#ifdef CONFIG_SIFIVE_CCACHE
+	return static_branch_unlikely(&sifive_ccache_handle_noncoherent_key);
+#else
+	return false;
+#endif
+}
+
+void sifive_ccache_flush_range(phys_addr_t start, size_t len);
+void *sifive_ccache_set_uncached(void *addr, size_t size);
+static inline void sifive_ccache_clear_uncached(void *addr, size_t size)
+{
+	memunmap(addr);
+}
+
 #endif /* __SOC_SIFIVE_CCACHE_H */
-- 
2.39.1


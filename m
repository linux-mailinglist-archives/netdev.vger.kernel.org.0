Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31512692DB4
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjBKDTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjBKDTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:19:02 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5A03D927;
        Fri, 10 Feb 2023 19:18:47 -0800 (PST)
Received: from localhost (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 8B4A56602125;
        Sat, 11 Feb 2023 03:18:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676085526;
        bh=9SuKyW5m2s3LuV67I9467kX5ZI8GexmXrVSVNnkz2OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMTt6dPu/18IXFr94zL95Pql9lUdJQIC8cRbs4VqMuTNSx9GF2XloISZKM+sBOr4u
         CsboPdGCB0WK1VYgN2LIAMbtwzKUrSMRGelHNbGahZm9MERYVOPB8944+pwz+OX5QY
         EBjcqKPDg+yy/WacrnF+ow+01z55aOeOlOsdd3WISdMKgdS09bvoU5aZLZej5AIrf1
         NmctoUae4i0AnT+Vj5b0hIxO2usmUimXWT4H/GLzMlUr+AVnEtuV2SxrbkvvUT7Zjl
         U/NN9R5hqCyffo4/qvcZlfZbXKDt+Gj2/DfVtf8HPNuY0Wj2mBlmNQdJzIFbBHH9RC
         rhRwKeCL0yLKg==
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
Subject: [PATCH 05/12] riscv: Implement non-coherent DMA support via SiFive cache flushing
Date:   Sat, 11 Feb 2023 05:18:14 +0200
Message-Id: <20230211031821.976408-6-cristian.ciocaltea@collabora.com>
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

This variant is used on the StarFive JH7100 SoC.

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
---
 arch/riscv/Kconfig              |  6 ++++--
 arch/riscv/mm/dma-noncoherent.c | 37 +++++++++++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 9c687da7756d..05f6c77faf6f 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -232,12 +232,14 @@ config LOCKDEP_SUPPORT
 	def_bool y
 
 config RISCV_DMA_NONCOHERENT
-	bool
+	bool "Support non-coherent DMA"
+	default SOC_STARFIVE
 	select ARCH_HAS_DMA_PREP_COHERENT
+	select ARCH_HAS_DMA_SET_UNCACHED
+	select ARCH_HAS_DMA_CLEAR_UNCACHED
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SETUP_DMA_OPS
-	select DMA_DIRECT_REMAP
 
 config AS_HAS_INSN
 	def_bool $(as-instr,.insn r 51$(comma) 0$(comma) 0$(comma) t0$(comma) t0$(comma) zero)
diff --git a/arch/riscv/mm/dma-noncoherent.c b/arch/riscv/mm/dma-noncoherent.c
index d919efab6eba..e07e53aea537 100644
--- a/arch/riscv/mm/dma-noncoherent.c
+++ b/arch/riscv/mm/dma-noncoherent.c
@@ -9,14 +9,21 @@
 #include <linux/dma-map-ops.h>
 #include <linux/mm.h>
 #include <asm/cacheflush.h>
+#include <soc/sifive/sifive_ccache.h>
 
 static bool noncoherent_supported;
 
 void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
 			      enum dma_data_direction dir)
 {
-	void *vaddr = phys_to_virt(paddr);
+	void *vaddr;
 
+	if (sifive_ccache_handle_noncoherent()) {
+		sifive_ccache_flush_range(paddr, size);
+		return;
+	}
+
+	vaddr = phys_to_virt(paddr);
 	switch (dir) {
 	case DMA_TO_DEVICE:
 		ALT_CMO_OP(clean, vaddr, size, riscv_cbom_block_size);
@@ -35,8 +42,14 @@ void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
 void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
 			   enum dma_data_direction dir)
 {
-	void *vaddr = phys_to_virt(paddr);
+	void *vaddr;
+
+	if (sifive_ccache_handle_noncoherent()) {
+		sifive_ccache_flush_range(paddr, size);
+		return;
+	}
 
+	vaddr = phys_to_virt(paddr);
 	switch (dir) {
 	case DMA_TO_DEVICE:
 		break;
@@ -49,10 +62,30 @@ void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
 	}
 }
 
+void *arch_dma_set_uncached(void *addr, size_t size)
+{
+	if (sifive_ccache_handle_noncoherent())
+		return sifive_ccache_set_uncached(addr, size);
+
+	return addr;
+}
+
+void arch_dma_clear_uncached(void *addr, size_t size)
+{
+	if (sifive_ccache_handle_noncoherent())
+		sifive_ccache_clear_uncached(addr, size);
+}
+
 void arch_dma_prep_coherent(struct page *page, size_t size)
 {
 	void *flush_addr = page_address(page);
 
+	if (sifive_ccache_handle_noncoherent()) {
+		memset(flush_addr, 0, size);
+		sifive_ccache_flush_range(__pa(flush_addr), size);
+		return;
+	}
+
 	ALT_CMO_OP(flush, flush_addr, size, riscv_cbom_block_size);
 }
 
-- 
2.39.1


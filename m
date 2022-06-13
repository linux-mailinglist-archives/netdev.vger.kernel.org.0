Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978C2547E39
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 05:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbiFMDpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 23:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiFMDph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 23:45:37 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8929E12626
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:45:36 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id o6so4060435plg.2
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hwoUcC4N3eJpcdnFiKCSHbinMlN/WVBskoSA8QPFN8U=;
        b=jFu8+5pSwIxgSFYBA2w9Ny5fjOaJxEl/fSvstKix40CJ0YPfidBqp78DMhoDb4lPNp
         0Pd7TsXBwD8XKlWFvAYG7UGGDoPPGFgOHHpr/KG6laY+VrA/VebX5XDxE9FasueGSflW
         VJGTGkBtN5Uw5HkPcRN3fQbgOnx2lkS4RVSKEsU1YK/qkIPSJh7wT1QRJdBrUOjZYsmw
         KZyuXIauCjz81SsmFv3XfrfTX9QwGQclZT2nfHzkDnUstWkYxqUq4xNx3/ordv2zMI48
         zPOdGtoJ0LmAw+xDkWfFeaPoink3psGZQS6+32NPQ4UWQdOXDnEN1x0u8mvEbgiO32Y/
         KMug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hwoUcC4N3eJpcdnFiKCSHbinMlN/WVBskoSA8QPFN8U=;
        b=5koF7Ngd5YIV2E1Plk719bW9kq3vjTFNYZGdIavErlvZI7nxGmupR5/VO2vs6i/uE3
         uLRgBHfARtLkosIdpXnFHEILGOLn9++z+P39CaBgikQyXJwFN0fihrefFaGaz1AeiZmh
         KOQHPVLEhiYG4mSVG7SyjhC47VfyFrMWCFIOf5Dr2VFMxhI9m4kWGg0Lj893YLKV4mXQ
         QcTNslWA04hAKeYfEq76ryNDM/nj9fjWEOR2HIcC9t3A71Kj8L3bkzx27ZYR0QY6IadK
         XdXnZazjjEF7LUb4avzeis+pmW9p43LmjdmeaakkLqRv6lO3CCt2AmzdfA+wnvdv1t0R
         qIOw==
X-Gm-Message-State: AOAM531E7m1y3yUwmCBUWDUz3FASUZf4oZnnMX/aPeXAFrohMgkHizN6
        wqRDwp+uYbkz3VwCrWGTj2GIdA==
X-Google-Smtp-Source: ABdhPJxXp7DLawbfykwgg8qXeI7AF9qXxXFCxX/eKCEcMWo4few1r1Qx1LSevlp9wohMvhmogd5h1A==
X-Received: by 2002:a17:90b:4c44:b0:1e8:6ed8:db56 with SMTP id np4-20020a17090b4c4400b001e86ed8db56mr13441345pjb.202.1655091936056;
        Sun, 12 Jun 2022 20:45:36 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902714d00b0015e8d4eb1dfsm3810769plm.41.2022.06.12.20.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 20:45:35 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Andy Chiu <andy.chiu@sifive.com>, Max Hsu <max.hsu@sifive.com>
Subject: [PATCH net-next 2/2] net: axienet: Use iowrite64 to write all 64b descriptor pointers
Date:   Mon, 13 Jun 2022 11:42:02 +0800
Message-Id: <20220613034202.3777248-3-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220613034202.3777248-1-andy.chiu@sifive.com>
References: <20220613034202.3777248-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to commit f735c40ed93c ("net: axienet: Autodetect 64-bit DMA
capability") and AXI-DMA spec (pg021), on 64-bit capable dma, only
writing MSB part of tail descriptor pointer causes DMA engine to start
fetching descriptors. However, we found that it is true only if dma is in
idle state. In other words, dma would use a tailp even if it only has LSB
updated, when the dma is running.

The non-atomicity of this behavior could be problematic if enough
delay were introduced in between the 2 writes. For example, if an
interrupt comes right after the LSB write and the cpu spends long
enough time in the handler for the dma to get back into idle state by
completing descriptors, then the seconcd write to MSB would treat dma
to start fetching descriptors again. Since the descriptor next to the
one pointed by current tail pointer is not filled by the kernel yet,
fetching a null descriptor here causes a dma internal error and halt
the dma engine down.

We suggest that the dma engine should start process a 64-bit MMIO write
to the descriptor pointer only if ONE 32-bit part of it is written on all
states. Or we should restrict the use of 64-bit addressable dma on 32-bit
platforms, since those devices have no instruction to guarantee the write
to LSB and MSB part of tail pointer occurs atomically to the dma.

initial condition:
curp =  x-3;
tailp = x-2;
LSB = x;
MSB = 0;

cpu:                       |dma:
 iowrite32(LSB, tailp)     |  completes #(x-3) desc, curp = x-3
 ...                       |  tailp updated
 => irq                    |  completes #(x-2) desc, curp = x-2
    ...                    |  completes #(x-1) desc, curp = x-1
    ...                    |  ...
    ...                    |  completes #x desc, curp = tailp = x
 <= irqreturn              |  reaches tailp == curp = x, idle
 iowrite32(MSB, tailp + 4) |  ...
                           |  tailp updated, starts fetching...
                           |  fetches #(x + 1) desc, sees cntrl = 0
                           |  post Tx error, halt

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reported-by: Max Hsu <max.hsu@sifive.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h | 21 +++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 6c95676ba172..97ddc0273b8a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -564,13 +564,28 @@ static inline void axienet_dma_out32(struct axienet_local *lp,
 }
 
 #ifdef CONFIG_64BIT
+/**
+ * axienet_dma_out64 - Memory mapped Axi DMA register write.
+ * @lp:		Pointer to axienet local structure
+ * @reg:	Address offset from the base address of the Axi DMA core
+ * @value:	Value to be written into the Axi DMA register
+ *
+ * This function writes the desired value into the corresponding Axi DMA
+ * register.
+ */
+static inline void axienet_dma_out64(struct axienet_local *lp,
+				     off_t reg, u64 value)
+{
+	iowrite64(value, lp->dma_regs + reg);
+}
+
 static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
 				 dma_addr_t addr)
 {
-	axienet_dma_out32(lp, reg, lower_32_bits(addr));
-
 	if (lp->features & XAE_FEATURE_DMA_64BIT)
-		axienet_dma_out32(lp, reg + 4, upper_32_bits(addr));
+		axienet_dma_out64(lp, reg, addr);
+	else
+		axienet_dma_out32(lp, reg, lower_32_bits(addr));
 }
 
 #else /* CONFIG_64BIT */
-- 
2.36.0


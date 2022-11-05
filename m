Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E03061DF23
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 23:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiKEWhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 18:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiKEWhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 18:37:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C18D13E2F;
        Sat,  5 Nov 2022 15:37:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D272460B9A;
        Sat,  5 Nov 2022 22:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD30C433D6;
        Sat,  5 Nov 2022 22:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667687819;
        bh=/rWXPCaXYKqDtuzw5QKoWJBsLCAYOuMK0PuW5Rz4gFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvCRLPrtP/8yYv1+Qp6VioiZG2zdX7UKrR1gFZQjayH8ZqQUQOM+t+pZfVOc/vIqO
         C/W/mHgO2O1hN3BCo+ZPB+sCfSwVx9MyqEWpRfcuY4S3/uk0+6+wRAGPkevBoN7v8F
         D4DVh+3386nm9xVEyL7Fov5hsG6/T08b5lcu12y7+5s4e+LDq6S6xa3yg9K7OahlPn
         M74x4c4qWtY1a0J1AyaYVwYHzehp7/AMt3aa/CqySF1TfCt4Rc4GatG7nTNyKDmFMp
         8XxjR96BOkjn5sRk4B0lX47y8XAi1gGBQ8MFPwl5RpUh3lamCrCfsjEmE/ff2jzXkL
         pJ1eKIf3CtyVw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com
Subject: [PATCH v4 net-next 7/8] net: ethernet: mtk_wed: add rx mib counters
Date:   Sat,  5 Nov 2022 23:36:22 +0100
Message-Id: <3ba5ababadc1cd2200fa80b8a310380bdc6c0958.1667687249.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1667687249.git.lorenzo@kernel.org>
References: <cover.1667687249.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce WED RX MIB counters support available on MT7986a SoC.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/ethernet/mediatek/mtk_wed_debugfs.c   | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
index f420f187e837..56f663439721 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2021 Felix Fietkau <nbd@nbd.name> */
 
 #include <linux/seq_file.h>
+#include <linux/soc/mediatek/mtk_wed.h>
 #include "mtk_wed.h"
 #include "mtk_wed_regs.h"
 
@@ -18,6 +19,8 @@ enum {
 	DUMP_TYPE_WDMA,
 	DUMP_TYPE_WPDMA_TX,
 	DUMP_TYPE_WPDMA_TXFREE,
+	DUMP_TYPE_WPDMA_RX,
+	DUMP_TYPE_WED_RRO,
 };
 
 #define DUMP_STR(_str) { _str, 0, DUMP_TYPE_STRING }
@@ -36,6 +39,9 @@ enum {
 
 #define DUMP_WPDMA_TX_RING(_n) DUMP_RING("WPDMA_TX" #_n, 0, DUMP_TYPE_WPDMA_TX, _n)
 #define DUMP_WPDMA_TXFREE_RING DUMP_RING("WPDMA_RX1", 0, DUMP_TYPE_WPDMA_TXFREE)
+#define DUMP_WPDMA_RX_RING(_n)	DUMP_RING("WPDMA_RX" #_n, 0, DUMP_TYPE_WPDMA_RX, _n)
+#define DUMP_WED_RRO_RING(_base)DUMP_RING("WED_RRO_MIOD", MTK_##_base, DUMP_TYPE_WED_RRO)
+#define DUMP_WED_RRO_FDBK(_base)DUMP_RING("WED_RRO_FDBK", MTK_##_base, DUMP_TYPE_WED_RRO)
 
 static void
 print_reg_val(struct seq_file *s, const char *name, u32 val)
@@ -57,6 +63,7 @@ dump_wed_regs(struct seq_file *s, struct mtk_wed_device *dev,
 				   cur > regs ? "\n" : "",
 				   cur->name);
 			continue;
+		case DUMP_TYPE_WED_RRO:
 		case DUMP_TYPE_WED:
 			val = wed_r32(dev, cur->offset);
 			break;
@@ -69,6 +76,9 @@ dump_wed_regs(struct seq_file *s, struct mtk_wed_device *dev,
 		case DUMP_TYPE_WPDMA_TXFREE:
 			val = wpdma_txfree_r32(dev, cur->offset);
 			break;
+		case DUMP_TYPE_WPDMA_RX:
+			val = wpdma_rx_r32(dev, cur->base, cur->offset);
+			break;
 		}
 		print_reg_val(s, cur->name, val);
 	}
@@ -132,6 +142,80 @@ wed_txinfo_show(struct seq_file *s, void *data)
 }
 DEFINE_SHOW_ATTRIBUTE(wed_txinfo);
 
+static int
+wed_rxinfo_show(struct seq_file *s, void *data)
+{
+	static const struct reg_dump regs[] = {
+		DUMP_STR("WPDMA RX"),
+		DUMP_WPDMA_RX_RING(0),
+		DUMP_WPDMA_RX_RING(1),
+
+		DUMP_STR("WPDMA RX"),
+		DUMP_WED(WED_WPDMA_RX_D_MIB(0)),
+		DUMP_WED_RING(WED_WPDMA_RING_RX_DATA(0)),
+		DUMP_WED(WED_WPDMA_RX_D_PROCESSED_MIB(0)),
+		DUMP_WED(WED_WPDMA_RX_D_MIB(1)),
+		DUMP_WED_RING(WED_WPDMA_RING_RX_DATA(1)),
+		DUMP_WED(WED_WPDMA_RX_D_PROCESSED_MIB(1)),
+		DUMP_WED(WED_WPDMA_RX_D_COHERENT_MIB),
+
+		DUMP_STR("WED RX"),
+		DUMP_WED_RING(WED_RING_RX_DATA(0)),
+		DUMP_WED_RING(WED_RING_RX_DATA(1)),
+
+		DUMP_STR("WED RRO"),
+		DUMP_WED_RRO_RING(WED_RROQM_MIOD_CTRL0),
+		DUMP_WED(WED_RROQM_MID_MIB),
+		DUMP_WED(WED_RROQM_MOD_MIB),
+		DUMP_WED(WED_RROQM_MOD_COHERENT_MIB),
+		DUMP_WED_RRO_FDBK(WED_RROQM_FDBK_CTRL0),
+		DUMP_WED(WED_RROQM_FDBK_IND_MIB),
+		DUMP_WED(WED_RROQM_FDBK_ENQ_MIB),
+		DUMP_WED(WED_RROQM_FDBK_ANC_MIB),
+		DUMP_WED(WED_RROQM_FDBK_ANC2H_MIB),
+
+		DUMP_STR("WED Route QM"),
+		DUMP_WED(WED_RTQM_R2H_MIB(0)),
+		DUMP_WED(WED_RTQM_R2Q_MIB(0)),
+		DUMP_WED(WED_RTQM_Q2H_MIB(0)),
+		DUMP_WED(WED_RTQM_R2H_MIB(1)),
+		DUMP_WED(WED_RTQM_R2Q_MIB(1)),
+		DUMP_WED(WED_RTQM_Q2H_MIB(1)),
+		DUMP_WED(WED_RTQM_Q2N_MIB),
+		DUMP_WED(WED_RTQM_Q2B_MIB),
+		DUMP_WED(WED_RTQM_PFDBK_MIB),
+
+		DUMP_STR("WED WDMA TX"),
+		DUMP_WED(WED_WDMA_TX_MIB),
+		DUMP_WED_RING(WED_WDMA_RING_TX),
+
+		DUMP_STR("WDMA TX"),
+		DUMP_WDMA(WDMA_GLO_CFG),
+		DUMP_WDMA_RING(WDMA_RING_TX(0)),
+		DUMP_WDMA_RING(WDMA_RING_TX(1)),
+
+		DUMP_STR("WED RX BM"),
+		DUMP_WED(WED_RX_BM_BASE),
+		DUMP_WED(WED_RX_BM_RX_DMAD),
+		DUMP_WED(WED_RX_BM_PTR),
+		DUMP_WED(WED_RX_BM_TKID_MIB),
+		DUMP_WED(WED_RX_BM_BLEN),
+		DUMP_WED(WED_RX_BM_STS),
+		DUMP_WED(WED_RX_BM_INTF2),
+		DUMP_WED(WED_RX_BM_INTF),
+		DUMP_WED(WED_RX_BM_ERR_STS),
+	};
+	struct mtk_wed_hw *hw = s->private;
+	struct mtk_wed_device *dev = hw->wed_dev;
+
+	if (!dev)
+		return 0;
+
+	dump_wed_regs(s, dev, regs, ARRAY_SIZE(regs));
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(wed_rxinfo);
 
 static int
 mtk_wed_reg_set(void *data, u64 val)
@@ -175,4 +259,7 @@ void mtk_wed_hw_add_debugfs(struct mtk_wed_hw *hw)
 	debugfs_create_u32("regidx", 0600, dir, &hw->debugfs_reg);
 	debugfs_create_file_unsafe("regval", 0600, dir, hw, &fops_regval);
 	debugfs_create_file_unsafe("txinfo", 0400, dir, hw, &wed_txinfo_fops);
+	if (hw->version != 1)
+		debugfs_create_file_unsafe("rxinfo", 0400, dir, hw,
+					   &wed_rxinfo_fops);
 }
-- 
2.38.1


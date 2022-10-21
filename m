Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF10607C03
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiJUQTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiJUQTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:19:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A70260D;
        Fri, 21 Oct 2022 09:19:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73DA061EF0;
        Fri, 21 Oct 2022 16:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870C2C433D6;
        Fri, 21 Oct 2022 16:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666369160;
        bh=72igWJwcF0ePTnW6WI4m55sGzV00wEG+1zXzkuHijMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZ74TvxBxKgWqw0kjtyNgnHRoIMxDO9N652ab4/D/kmzsIEAjNVJI244XopQiZi74
         CcsaOqYSgaO18IroaP1dGHi+gp1Rfm6dFMqp6hKjp82EsX37d3auMVqWW+SNYFc+CG
         s87IuoV1SGU5ifrgQQr+VxqC8xJDGBv1TikFrN9a4u4rt1qyWd0/6ilcu1HWZDGD78
         16TMap0p7XWn+kpp4NdZLAmRyyucV5xv0YJa1JnMGhwk/AyVyCfW8GAu12cznFNOFI
         jALyFJK/gDhk3kNUss9f15qcOuwg4OyUmqrvEeEW1BLhov1kmCyukiTHjV5kdk6tfR
         Zs0z3qsZ9BTVg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH net-next 3/6] net: ethernet: mtk_wed: introduce wed mcu support
Date:   Fri, 21 Oct 2022 18:18:33 +0200
Message-Id: <9aeb73670ec404e8e973ee65d7ff1dffb52086d6.1666368566.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666368566.git.lorenzo@kernel.org>
References: <cover.1666368566.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce WED mcu support used to configure WED WO chip.
This is a preliminary patch in order to add RX Wireless
Ethernet Dispatch available on MT7986 SoC.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/Makefile       |   2 +-
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c  | 347 +++++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_wed_regs.h |   1 +
 drivers/net/ethernet/mediatek/mtk_wed_wo.h   | 152 ++++++++
 include/linux/soc/mediatek/mtk_wed.h         |  29 ++
 5 files changed, 530 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_mcu.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_wo.h

diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ethernet/mediatek/Makefile
index 45ba0970504a..d4bdefa77159 100644
--- a/drivers/net/ethernet/mediatek/Makefile
+++ b/drivers/net/ethernet/mediatek/Makefile
@@ -5,7 +5,7 @@
 
 obj-$(CONFIG_NET_MEDIATEK_SOC) += mtk_eth.o
 mtk_eth-y := mtk_eth_soc.o mtk_sgmii.o mtk_eth_path.o mtk_ppe.o mtk_ppe_debugfs.o mtk_ppe_offload.o
-mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed.o
+mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed.o mtk_wed_mcu.o
 ifdef CONFIG_DEBUG_FS
 mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_debugfs.o
 endif
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
new file mode 100644
index 000000000000..4100258b0ec1
--- /dev/null
+++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
@@ -0,0 +1,347 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2022 Lorenzo Bianconi <lorenzo@kernel.org>  */
+
+#include <linux/firmware.h>
+#include <linux/of_address.h>
+#include <linux/mfd/syscon.h>
+#include <linux/soc/mediatek/mtk_wed.h>
+
+#include "mtk_wed_regs.h"
+#include "mtk_wed_wo.h"
+#include "mtk_wed.h"
+
+static u32 wo_r32(struct mtk_wed_wo *wo, u32 reg)
+{
+	u32 val;
+
+	if (regmap_read(wo->boot, reg, &val))
+		val = ~0;
+
+	return val;
+}
+
+static void wo_w32(struct mtk_wed_wo *wo, u32 reg, u32 val)
+{
+	regmap_write(wo->boot, reg, val);
+}
+
+static struct sk_buff *
+mtk_wed_mcu_msg_alloc(const void *data, int data_len)
+{
+	int length = sizeof(struct mtk_wed_mcu_hdr) + data_len;
+	struct sk_buff *skb;
+
+	skb = alloc_skb(length, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	memset(skb->head, 0, length);
+	skb_reserve(skb, sizeof(struct mtk_wed_mcu_hdr));
+	if (data && data_len)
+		skb_put_data(skb, data, data_len);
+
+	return skb;
+}
+
+static struct sk_buff *
+mtk_wed_mcu_get_response(struct mtk_wed_wo *wo, unsigned long expires)
+{
+	if (!time_is_after_jiffies(expires))
+		return NULL;
+
+	wait_event_timeout(wo->mcu.wait, !skb_queue_empty(&wo->mcu.res_q),
+			   expires - jiffies);
+	return skb_dequeue(&wo->mcu.res_q);
+}
+
+void mtk_wed_mcu_rx_event(struct mtk_wed_wo *wo, struct sk_buff *skb)
+{
+	skb_queue_tail(&wo->mcu.res_q, skb);
+	wake_up(&wo->mcu.wait);
+}
+
+void mtk_wed_mcu_rx_unsolicited_event(struct mtk_wed_wo *wo,
+				      struct sk_buff *skb)
+{
+	struct mtk_wed_mcu_hdr *hdr = (struct mtk_wed_mcu_hdr *)skb->data;
+
+	switch (hdr->cmd) {
+	case MTK_WED_WO_EVT_LOG_DUMP: {
+		const char *msg = (const char *)(skb->data + sizeof(*hdr));
+
+		dev_notice(wo->hw->dev, "%s\n", msg);
+		break;
+	}
+	case MTK_WED_WO_EVT_PROFILING: {
+		struct mtk_wed_wo_log_info *info;
+		u32 count = (skb->len - sizeof(*hdr)) / sizeof(*info);
+		int i;
+
+		info = (struct mtk_wed_wo_log_info *)(skb->data + sizeof(*hdr));
+		for (i = 0 ; i < count ; i++)
+			dev_notice(wo->hw->dev,
+				   "SN:%u latency: total=%u, rro:%u, mod:%u\n",
+				   le32_to_cpu(info[i].sn),
+				   le32_to_cpu(info[i].total),
+				   le32_to_cpu(info[i].rro),
+				   le32_to_cpu(info[i].mod));
+		break;
+	}
+	case MTK_WED_WO_EVT_RXCNT_INFO:
+		break;
+	default:
+		break;
+	}
+
+	dev_kfree_skb(skb);
+}
+
+static int
+mtk_wed_mcu_skb_send_msg(struct mtk_wed_wo *wo, struct sk_buff *skb,
+			 int id, int cmd, u16 *wait_seq, bool wait_resp)
+{
+	struct mtk_wed_mcu_hdr *hdr;
+
+	/* TODO: make it dynamic based on cmd */
+	wo->mcu.timeout = 20 * HZ;
+
+	hdr = (struct mtk_wed_mcu_hdr *)skb_push(skb, sizeof(*hdr));
+	hdr->cmd = cmd;
+	hdr->length = cpu_to_le16(skb->len);
+
+	if (wait_resp && wait_seq) {
+		u16 seq = ++wo->mcu.seq;
+
+		if (!seq)
+			seq = ++wo->mcu.seq;
+		*wait_seq = seq;
+
+		hdr->flag |= cpu_to_le16(MTK_WED_WARP_CMD_FLAG_NEED_RSP);
+		hdr->seq = cpu_to_le16(seq);
+	}
+	if (id == MTK_WED_MODULE_ID_WO)
+		hdr->flag |= cpu_to_le16(MTK_WED_WARP_CMD_FLAG_FROM_TO_WO);
+
+	dev_kfree_skb(skb);
+	return 0;
+}
+
+static int
+mtk_wed_mcu_parse_response(struct mtk_wed_wo *wo, struct sk_buff *skb,
+			   int cmd, int seq)
+{
+	struct mtk_wed_mcu_hdr *hdr;
+
+	if (!skb) {
+		dev_err(wo->hw->dev, "Message %08x (seq %d) timeout\n",
+			cmd, seq);
+		return -ETIMEDOUT;
+	}
+
+	hdr = (struct mtk_wed_mcu_hdr *)skb->data;
+	if (le16_to_cpu(hdr->seq) != seq)
+		return -EAGAIN;
+
+	skb_pull(skb, sizeof(*hdr));
+	switch (cmd) {
+	case MTK_WED_WO_CMD_RXCNT_INFO:
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+int mtk_wed_mcu_send_msg(struct mtk_wed_wo *wo, int id, int cmd,
+			 const void *data, int len, bool wait_resp)
+{
+	unsigned long expires;
+	struct sk_buff *skb;
+	u16 seq;
+	int ret;
+
+	skb = mtk_wed_mcu_msg_alloc(data, len);
+	if (!skb)
+		return -ENOMEM;
+
+	mutex_lock(&wo->mcu.mutex);
+
+	ret = mtk_wed_mcu_skb_send_msg(wo, skb, id, cmd, &seq, wait_resp);
+	if (ret || !wait_resp)
+		goto unlock;
+
+	expires = jiffies + wo->mcu.timeout;
+	do {
+		skb = mtk_wed_mcu_get_response(wo, expires);
+		ret = mtk_wed_mcu_parse_response(wo, skb, cmd, seq);
+		dev_kfree_skb(skb);
+	} while (ret == -EAGAIN);
+
+unlock:
+	mutex_unlock(&wo->mcu.mutex);
+
+	return ret;
+}
+
+static int
+mtk_wed_get_firmware_metadata(struct mtk_wed_wo *wo,
+			      struct mtk_wed_fw_region_meta *meta)
+{
+	struct device_node *np;
+	struct resource res;
+	int ret;
+
+	np = of_parse_phandle(wo->hw->node, meta->name, 0);
+	if (!np)
+		return -ENODEV;
+
+	ret = of_address_to_resource(np, 0, &res);
+	if (ret)
+		goto out;
+
+	meta->phy_addr = res.start;
+	meta->size = resource_size(&res);
+	meta->addr = devm_ioremap(wo->hw->dev, res.start, meta->size);
+	if (!meta->addr)
+		ret = -ENOMEM;
+out:
+	of_node_put(np);
+
+	return ret;
+}
+
+static int
+mtk_wed_mcu_load_firmware(struct mtk_wed_wo *wo)
+{
+	static struct mtk_wed_fw_region_meta fw_region[] = {
+		[MTK_WED_WO_FW_EMI] = {
+			.name = "mediatek,wocpu_emi",
+		},
+		[MTK_WED_WO_FW_ILM] = {
+			.name = "mediatek,wocpu_ilm",
+		},
+		[MTK_WED_WO_FW_DATA] = {
+			.name = "mediatek,wocpu_data",
+			.shared = true,
+		},
+	};
+	const struct mtk_wed_fw_trailer *trailer;
+	const struct mtk_wed_fw_region *region;
+	const u8 *region_ptr, *trailer_ptr;
+	u32 val, offset = 0, boot_cr;
+	const struct firmware *fw;
+	int ret, i, count = 0;
+	const char *fw_name;
+
+	/* load firmware region metadata */
+	for (i = 0; i < ARRAY_SIZE(fw_region); i++) {
+		ret = mtk_wed_get_firmware_metadata(wo, &fw_region[i]);
+		if (ret)
+			return ret;
+	}
+
+	wo->boot = syscon_regmap_lookup_by_phandle(wo->hw->node,
+						   "mediatek,wocpu_boot");
+	if (IS_ERR_OR_NULL(wo->boot))
+		return PTR_ERR(wo->boot);
+
+	/* set dummy cr */
+	wed_w32(wo->hw->wed_dev, MTK_WED_SCR0 + 4 * MTK_WED_DUMMY_CR_FWDL,
+		wo->hw->index + 1);
+
+	/* load firmware */
+	fw_name = wo->hw->index ? MT7986_FIRMWARE_WO1 : MT7986_FIRMWARE_WO0;
+	ret = request_firmware(&fw, fw_name, wo->hw->dev);
+	if (ret)
+		return ret;
+
+	trailer_ptr = fw->data + fw->size - sizeof(*trailer);
+	trailer = (const struct mtk_wed_fw_trailer *)trailer_ptr;
+	dev_info(wo->hw->dev,
+		 "MTK WED WO Firmware Version: %.10s, Build Time: %.15s\n",
+		 trailer->fw_ver, trailer->build_date);
+	dev_info(wo->hw->dev, "MTK WED WO Chid ID %02x Region %d\n",
+		 trailer->chip_id, trailer->num_region);
+
+	if (fw->size - sizeof(*trailer) < trailer->num_region * sizeof(*region)) {
+		dev_err(wo->hw->dev, "Invalid fw num_region %d\n",
+			trailer->num_region);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	region_ptr = trailer_ptr - trailer->num_region * sizeof(*region);
+	while (region_ptr < trailer_ptr) {
+		int j;
+
+		region = (const struct mtk_wed_fw_region *)region_ptr;
+		for (j = 0; j < ARRAY_SIZE(fw_region); j++) {
+			if (fw_region[j].phy_addr != region->addr)
+				continue;
+
+			if (fw_region[j].size < region->len)
+				continue;
+
+			if (trailer_ptr < fw->data + offset + region->len)
+				continue;
+
+			if (!fw_region[j].shared || !fw_region[j].consumed) {
+				memcpy(fw_region[j].addr, fw->data + offset,
+				       region->len);
+				fw_region[j].consumed = true;
+				count++;
+			} else if (fw_region[j].shared) {
+				count++;
+			}
+		}
+		region_ptr += sizeof(*region);
+		offset += region->len;
+	}
+
+	if (count != ARRAY_SIZE(fw_region)) {
+		dev_err(wo->hw->dev, "Failed to load firmware\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* set the start address */
+	boot_cr = wo->hw->index ? MTK_WO_MCU_CFG_LS_WA_BOOT_ADDR_ADDR
+				: MTK_WO_MCU_CFG_LS_WM_BOOT_ADDR_ADDR;
+	wo_w32(wo, boot_cr, fw_region[MTK_WED_WO_FW_EMI].phy_addr >> 16);
+	/* wo firmware reset */
+	wo_w32(wo, MTK_WO_MCU_CFG_LS_WF_MCCR_CLR_ADDR, 0xc00);
+
+	val = wo_r32(wo, MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR);
+	val |= wo->hw->index ? MTK_WO_MCU_CFG_LS_WF_WM_WA_WA_CPU_RSTB_MASK
+			     : MTK_WO_MCU_CFG_LS_WF_WM_WA_WM_CPU_RSTB_MASK;
+	wo_w32(wo, MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR, val);
+out:
+	release_firmware(fw);
+
+	return ret;
+}
+
+int mtk_wed_mcu_init(struct mtk_wed_wo *wo)
+{
+	u32 val;
+	int ret;
+
+	skb_queue_head_init(&wo->mcu.res_q);
+	init_waitqueue_head(&wo->mcu.wait);
+	mutex_init(&wo->mcu.mutex);
+
+	ret = mtk_wed_mcu_load_firmware(wo);
+	if (ret)
+		return ret;
+
+	do {
+		/* get dummy cr */
+		val = wed_r32(wo->hw->wed_dev,
+			      MTK_WED_SCR0 + 4 * MTK_WED_DUMMY_CR_FWDL);
+	} while (val && !time_after(jiffies, jiffies + MTK_FW_DL_TIMEOUT));
+
+	return val ? -EBUSY : 0;
+}
+
+MODULE_FIRMWARE(MT7986_FIRMWARE_WO0);
+MODULE_FIRMWARE(MT7986_FIRMWARE_WO1);
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
index e270fb336143..c940b3bb215b 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
@@ -152,6 +152,7 @@ struct mtk_wdma_desc {
 
 #define MTK_WED_RING_RX(_n)				(0x400 + (_n) * 0x10)
 
+#define MTK_WED_SCR0					0x3c0
 #define MTK_WED_WPDMA_INT_TRIGGER			0x504
 #define MTK_WED_WPDMA_INT_TRIGGER_RX_DONE		BIT(1)
 #define MTK_WED_WPDMA_INT_TRIGGER_TX_DONE		GENMASK(5, 4)
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.h b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
new file mode 100644
index 000000000000..bf33adcb7320
--- /dev/null
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
@@ -0,0 +1,152 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2022 Lorenzo Bianconi <lorenzo@kernel.org>  */
+
+#ifndef __MTK_WED_WO_H
+#define __MTK_WED_WO_H
+
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+
+struct mtk_wed_hw;
+
+struct mtk_wed_mcu_hdr {
+	/* DW0 */
+	u8 version;
+	u8 cmd;
+	__le16 length;
+
+	/* DW1 */
+	__le16 seq;
+	__le16 flag;
+
+	/* DW2 */
+	__le32 status;
+
+	/* DW3 */
+	u8 rsv[20];
+};
+
+struct mtk_wed_wo_log_info {
+	__le32 sn;
+	__le32 total;
+	__le32 rro;
+	__le32 mod;
+};
+
+enum mtk_wed_wo_event {
+	MTK_WED_WO_EVT_LOG_DUMP		= 0x1,
+	MTK_WED_WO_EVT_PROFILING	= 0x2,
+	MTK_WED_WO_EVT_RXCNT_INFO	= 0x3,
+};
+
+#define MTK_WED_MODULE_ID_WO		1
+#define MTK_FW_DL_TIMEOUT		(4 * HZ)
+#define MTK_WOCPU_TIMEOUT		(2 * HZ)
+
+enum {
+	MTK_WED_WARP_CMD_FLAG_RSP		= BIT(0),
+	MTK_WED_WARP_CMD_FLAG_NEED_RSP		= BIT(1),
+	MTK_WED_WARP_CMD_FLAG_FROM_TO_WO	= BIT(2),
+};
+
+enum {
+	MTK_WED_WO_FW_EMI,
+	MTK_WED_WO_FW_ILM,
+	MTK_WED_WO_FW_DATA,
+	MTK_WED_WO_FW_BOOT,
+};
+
+enum mtk_wed_dummy_cr_idx {
+	MTK_WED_DUMMY_CR_FWDL,
+	MTK_WED_DUMMY_CR_WO_STATUS,
+};
+
+#define MT7986_FIRMWARE_WO0	"mediatek/mt7986_wo_0.bin"
+#define MT7986_FIRMWARE_WO1	"mediatek/mt7986_wo_1.bin"
+
+#define MTK_WO_MCU_CFG_LS_BASE				0 /* XXX: 0x15194000 */
+#define MTK_WO_MCU_CFG_LS_HW_VER_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x000)
+#define MTK_WO_MCU_CFG_LS_FW_VER_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x004)
+#define MTK_WO_MCU_CFG_LS_CFG_DBG1_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x00c)
+#define MTK_WO_MCU_CFG_LS_CFG_DBG2_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x010)
+#define MTK_WO_MCU_CFG_LS_WF_MCCR_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x014)
+#define MTK_WO_MCU_CFG_LS_WF_MCCR_SET_ADDR		(MTK_WO_MCU_CFG_LS_BASE + 0x018)
+#define MTK_WO_MCU_CFG_LS_WF_MCCR_CLR_ADDR		(MTK_WO_MCU_CFG_LS_BASE + 0x01c)
+#define MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR		(MTK_WO_MCU_CFG_LS_BASE + 0x050)
+#define MTK_WO_MCU_CFG_LS_WM_BOOT_ADDR_ADDR		(MTK_WO_MCU_CFG_LS_BASE + 0x060)
+#define MTK_WO_MCU_CFG_LS_WA_BOOT_ADDR_ADDR		(MTK_WO_MCU_CFG_LS_BASE + 0x064)
+
+#define MTK_WO_MCU_CFG_LS_WF_WM_WA_WM_CPU_RSTB_MASK	BIT(5)
+#define MTK_WO_MCU_CFG_LS_WF_WM_WA_WA_CPU_RSTB_MASK	BIT(0)
+
+struct mtk_wed_fw_region_meta {
+	const char *name;
+	void __iomem *addr;
+	phys_addr_t phy_addr;
+	u32 size;
+	bool shared:1;
+	bool consumed:1;
+};
+
+struct mtk_wed_fw_region {
+	__le32 decomp_crc;
+	__le32 decomp_len;
+	__le32 decomp_blk_sz;
+	u8 rsv0[4];
+	__le32 addr;
+	__le32 len;
+	u8 feature_set;
+	u8 rsv1[15];
+} __packed;
+
+struct mtk_wed_fw_trailer {
+	u8 chip_id;
+	u8 eco_code;
+	u8 num_region;
+	u8 format_ver;
+	u8 format_flag;
+	u8 rsv[2];
+	char fw_ver[10];
+	char build_date[15];
+	u32 crc;
+};
+
+struct mtk_wed_wo {
+	struct mtk_wed_hw *hw;
+	struct regmap *boot;
+
+	struct {
+		struct mutex mutex;
+		int timeout;
+		u16 seq;
+
+		struct sk_buff_head res_q;
+		wait_queue_head_t wait;
+	} mcu;
+};
+
+static inline int
+mtk_wed_mcu_check_msg(struct mtk_wed_wo *wo, struct sk_buff *skb)
+{
+	struct mtk_wed_mcu_hdr *hdr = (struct mtk_wed_mcu_hdr *)skb->data;
+
+	if (hdr->version)
+		return -EINVAL;
+
+	if (skb->len < sizeof(*hdr))
+		return -EINVAL;
+
+	if (skb->len != le16_to_cpu(hdr->length))
+		return -EINVAL;
+
+	return 0;
+}
+
+void mtk_wed_mcu_rx_event(struct mtk_wed_wo *wo, struct sk_buff *skb);
+void mtk_wed_mcu_rx_unsolicited_event(struct mtk_wed_wo *wo,
+				      struct sk_buff *skb);
+int mtk_wed_mcu_send_msg(struct mtk_wed_wo *wo, int id, int cmd,
+			 const void *data, int len, bool wait_resp);
+int mtk_wed_mcu_init(struct mtk_wed_wo *wo);
+
+#endif /* __MTK_WED_WO_H */
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index 4450c8b7a1cb..2cc2f1e43ba9 100644
--- a/include/linux/soc/mediatek/mtk_wed.h
+++ b/include/linux/soc/mediatek/mtk_wed.h
@@ -11,6 +11,35 @@
 struct mtk_wed_hw;
 struct mtk_wdma_desc;
 
+enum mtk_wed_wo_cmd {
+	MTK_WED_WO_CMD_WED_CFG,
+	MTK_WED_WO_CMD_WED_RX_STAT,
+	MTK_WED_WO_CMD_RRO_SER,
+	MTK_WED_WO_CMD_DBG_INFO,
+	MTK_WED_WO_CMD_DEV_INFO,
+	MTK_WED_WO_CMD_BSS_INFO,
+	MTK_WED_WO_CMD_STA_REC,
+	MTK_WED_WO_CMD_DEV_INFO_DUMP,
+	MTK_WED_WO_CMD_BSS_INFO_DUMP,
+	MTK_WED_WO_CMD_STA_REC_DUMP,
+	MTK_WED_WO_CMD_BA_INFO_DUMP,
+	MTK_WED_WO_CMD_FBCMD_Q_DUMP,
+	MTK_WED_WO_CMD_FW_LOG_CTRL,
+	MTK_WED_WO_CMD_LOG_FLUSH,
+	MTK_WED_WO_CMD_CHANGE_STATE,
+	MTK_WED_WO_CMD_CPU_STATS_ENABLE,
+	MTK_WED_WO_CMD_CPU_STATS_DUMP,
+	MTK_WED_WO_CMD_EXCEPTION_INIT,
+	MTK_WED_WO_CMD_PROF_CTRL,
+	MTK_WED_WO_CMD_STA_BA_DUMP,
+	MTK_WED_WO_CMD_BA_CTRL_DUMP,
+	MTK_WED_WO_CMD_RXCNT_CTRL,
+	MTK_WED_WO_CMD_RXCNT_INFO,
+	MTK_WED_WO_CMD_SET_CAP,
+	MTK_WED_WO_CMD_CCIF_RING_DUMP,
+	MTK_WED_WO_CMD_WED_END
+};
+
 enum mtk_wed_bus_tye {
 	MTK_WED_BUS_PCIE,
 	MTK_WED_BUS_AXI,
-- 
2.37.3


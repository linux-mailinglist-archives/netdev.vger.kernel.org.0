Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4299B667D22
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 18:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbjALR6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 12:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbjALR6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 12:58:17 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA9A7D1F3;
        Thu, 12 Jan 2023 09:17:18 -0800 (PST)
Received: from IcarusMOD.eternityproject.eu (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id CFC776602D59;
        Thu, 12 Jan 2023 17:17:15 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1673543836;
        bh=Ju29I8xxTwaCSSaxCoJjs4WpH/sWHGWNYC2IjKsuXAM=;
        h=From:To:Cc:Subject:Date:From;
        b=BFL6oRMvx51BsGrLnLpE2ZR/2CITfYMpUcxKF/nL3LdXDp2+lKio7p/hHJelTHl3Z
         5rYCaxtMOx+bBRgg9WYHKsoWQC39fhUfIPAXxlSA7M1w4/G2YnVfWXs5C3xPi+JHxf
         9NxtiNLPEmtJPafOpTJvEJmrVXM7uu2SU3ZciVAj/N7iFTQ/V8Ml+MQQ9OOMpH5F16
         n70kUcCUk6vxBQz2ldIkeopsy+Aq1yzXDWeYinqTnpOzka5U7lwvR5WBG0wvnekpd/
         zim9LIDfFwWnlW1nGQNYql61Qc6IotpIA1gzDiOmrmL81Bz499ESJhgZK/3P8Lv0Gc
         K3TPNKhjOLPHA==
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
To:     nbd@nbd.name
Cc:     lorenzo@kernel.org, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        sujuan.chen@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com, nfraprado@collabora.com, wenst@chromium.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Subject: [PATCH] wifi: mt76: Stop unmapping all buffers when WED not present
Date:   Thu, 12 Jan 2023 18:17:06 +0100
Message-Id: <20230112171706.294550-1-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.39.0
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

Before the introduction of WED RX support, this driver was resetting
buf0 and the TXWI pointer only on the head of the passed queue but
now it's doing that on all buffers: while this is fine on systems
that are not relying on IOMMU, such as the MT8192 Asurada Spherion
Chromebook (MT7921E), it causes a crash on others using IOMMUs, such
as the MT8195 Cherry Tomato Chromebook (MT7921E again!).

Reverting to the described behavior solves the following kernel panic:

[   20.357772] Unable to handle kernel paging request at virtual address ffff170fc0000000
[   20.365943] Mem abort info:
[   20.368989]   ESR = 0x0000000096000145
[   20.372988]   EC = 0x25: DABT (current EL), IL = 32 bits
[   20.378551]   SET = 0, FnV = 0
[   20.381857]   EA = 0, S1PTW = 0
[   20.385248]   FSC = 0x05: level 1 translation fault
[   20.390376] Data abort info:
[   20.393507]   ISV = 0, ISS = 0x00000145
[   20.397593]   CM = 1, WnR = 1
[   20.400811] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000041fb3000
[   20.407763] [ffff170fc0000000] pgd=180000023fff7003, p4d=180000023fff7003, pud=0000000000000000
[   20.416714] Internal error: Oops: 0000000096000145 [#1] SMP
[   20.422535] Modules linked in: af_alg qrtr mt7921e mt7921_common mt76_connac_lib mt76 mac80211 btusb btrtl btintel btmtk btbcm 8021q cfg80211 bluetooth uvcvideo garp mrp snd_sof_ipc_msg_injector snd_sof_ipc_flood_test stp snd_sof_mt8195 videobuf2_vmalloc llc panfrost cros_ec_sensors cros_ec_lid_angle crct10dif_ce mtk_adsp_common ecdh_generic cros_ec_sensors_core ecc snd_sof_xtensa_dsp gpu_sched rfkill snd_sof_of sbs_battery hid_multitouch cros_usbpd_logger snd_sof snd_sof_utils fuse ipv6
[   20.465969] CPU: 6 PID: 9 Comm: kworker/u16:0 Tainted: G        W          6.2.0-rc3-next-20230111+ #237
[   20.475695] Hardware name: Acer Tomato (rev2) board (DT)
[   20.481254] Workqueue: phy0 ieee80211_iface_work [mac80211]
[   20.487119] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   20.494328] pc : dcache_clean_poc+0x20/0x38
[   20.498764] lr : arch_sync_dma_for_device+0x2c/0x40
[   20.503893] sp : ffff8000080cb430
[   20.507457] x29: ffff8000080cb430 x28: 0000000000000000 x27: ffff1710c740e0d0
[   20.514842] x26: ffff1710d8c03b38 x25: ffff1710d75e4fb0 x24: ffff1710c619e280
[   20.522225] x23: ffff8000080cb578 x22: 0000000000000001 x21: 0000000000000040
[   20.529608] x20: 0000000000000000 x19: ffff1710c740e0d0 x18: 0000000000000030
[   20.536991] x17: 000000040044ffff x16: ffffc06d4c37d200 x15: ffffffffffffffff
[   20.544373] x14: 0000000000000000 x13: 0000000000007800 x12: 0000000000000000
[   20.551755] x11: 0000000000007961 x10: 0000000000007961 x9 : ffffc06d4cbe0ff8
[   20.559137] x8 : 0000000000000001 x7 : 0000000000008000 x6 : 0000000000000000
[   20.566518] x5 : 000000000000801e x4 : 0000000054765809 x3 : 000000000000003f
[   20.573899] x2 : 0000000000000040 x1 : ffff170fc0000040 x0 : ffff170fc0000000
[   20.581282] Call trace:
[   20.583976]  dcache_clean_poc+0x20/0x38
[   20.588061]  iommu_dma_sync_single_for_device+0xc4/0xdc
[   20.593534]  dma_sync_single_for_device+0x38/0x120
[   20.598574]  mt76_dma_tx_queue_skb+0x4f4/0x5b0 [mt76]
[   20.603880]  __mt76_tx_queue_skb+0x5c/0xe0 [mt76]
[   20.608836]  mt76_tx+0xbc/0x164 [mt76]
[   20.612838]  mt7921_tx+0x9c/0x170 [mt7921_common]
[   20.617795]  ieee80211_tx_frags+0x22c/0x2a0 [mac80211]
[   20.623215]  __ieee80211_tx+0x90/0x1c0 [mac80211]
[   20.628195]  ieee80211_tx+0x114/0x160 [mac80211]
[   20.633088]  ieee80211_xmit+0xa0/0xd4 [mac80211]
[   20.637980]  __ieee80211_tx_skb_tid_band+0xa8/0x2e0 [mac80211]
[   20.644087]  ieee80211_tx_skb_tid+0xac/0x270 [mac80211]
[   20.649585]  ieee80211_send_auth+0x1ac/0x250 [mac80211]
[   20.655080]  ieee80211_auth+0x16c/0x2dc [mac80211]
[   20.660145]  ieee80211_sta_work+0x3a0/0xab4 [mac80211]
[   20.665557]  ieee80211_iface_work+0x394/0x400 [mac80211]
[   20.671144]  process_one_work+0x294/0x674
[   20.675406]  worker_thread+0x7c/0x45c
[   20.679316]  kthread+0x104/0x110
[   20.682793]  ret_from_fork+0x10/0x20
[   20.686621] Code: d2800082 9ac32042 d1000443 8a230000 (d50b7a20)
[   20.692962] ---[ end trace 0000000000000000 ]---

Fixes: cd372b8c99c5 ("wifi: mt76: add WED RX support to mt76_dma_{add,get}_buf")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 420302ff0328..a0fe3ab0126d 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -215,6 +215,12 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
 	u32 ctrl;
 	int i, idx = -1;
 
+	if (txwi && !(q->flags & MT_QFLAG_WED) &&
+	    !FIELD_GET(MT_QFLAG_WED_TYPE, q->flags)) {
+		q->entry[q->head].txwi = DMA_DUMMY_DATA;
+		q->entry[q->head].skip_buf0 = true;
+	}
+
 	for (i = 0; i < nbufs; i += 2, buf += 2) {
 		u32 buf0 = buf[0].addr, buf1 = 0;
 
@@ -238,11 +244,6 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
 			ctrl = FIELD_PREP(MT_DMA_CTL_SD_LEN0, buf[0].len) |
 			       MT_DMA_CTL_TO_HOST;
 		} else {
-			if (txwi) {
-				q->entry[q->head].txwi = DMA_DUMMY_DATA;
-				q->entry[q->head].skip_buf0 = true;
-			}
-
 			if (buf[0].skip_unmap)
 				entry->skip_buf0 = true;
 			entry->skip_buf1 = i == nbufs - 1;
-- 
2.39.0


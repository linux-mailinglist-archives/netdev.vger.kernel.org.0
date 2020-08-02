Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E959235626
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 11:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgHBJe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 05:34:28 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:41246
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1726376AbgHBJe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 05:34:28 -0400
Received: from oslab.tsinghua.edu.cn (unknown [166.111.139.112])
        by app-3 (Coremail) with SMTP id EQQGZQBHj8x1iCZfvYLYAw--.49978S2;
        Sun, 02 Aug 2020 17:33:53 +0800 (CST)
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Subject: [PATCH] atm: idt77252: avoid accessing the data mapped to streaming DMA
Date:   Sun,  2 Aug 2020 17:33:40 +0800
Message-Id: <20200802093340.3475-1-baijiaju@tsinghua.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EQQGZQBHj8x1iCZfvYLYAw--.49978S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WF48JFW7Kr1UJFW5Gr45ZFb_yoW8tFW3pF
        W7Gw1DWFs5t34rGFWDur45urW3Ga4FyF9xKFW7A3WfCFs0yF1kGF18GFW8XF1Yyrs5ursI
        kF4rWrsYq34DKw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkv14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_GFWl
        42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
        WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAK
        I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r
        4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
        42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUIhFcUUUUU=
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In queue_skb(), skb->data is mapped to streaming DMA on line 850:
  dma_map_single(..., skb->data, ...);

Then skb->data is accessed on lines 862 and 863:
  tbd->word_4 = (skb->data[0] << 24) | (skb->data[1] << 16) |
           (skb->data[2] <<  8) | (skb->data[3] <<  0);
and on lines 893 and 894:
  tbd->word_4 = (skb->data[0] << 24) | (skb->data[1] << 16) |
           (skb->data[2] <<  8) | (skb->data[3] <<  0);

These accesses may cause data inconsistency between CPU cache and
hardware.

To fix this problem, the calculation result of skb->data is stored in a
local variable before DMA mapping, and then the driver accesses this
local variable instead of skb->data.

Signed-off-by: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
---
 drivers/atm/idt77252.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index df51680e8931..65a3886f68c9 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -835,6 +835,7 @@ queue_skb(struct idt77252_dev *card, struct vc_map *vc,
 	unsigned long flags;
 	int error;
 	int aal;
+	u32 word4;
 
 	if (skb->len == 0) {
 		printk("%s: invalid skb->len (%d)\n", card->name, skb->len);
@@ -846,6 +847,8 @@ queue_skb(struct idt77252_dev *card, struct vc_map *vc,
 
 	tbd = &IDT77252_PRV_TBD(skb);
 	vcc = ATM_SKB(skb)->vcc;
+	word4 = (skb->data[0] << 24) | (skb->data[1] << 16) |
+			(skb->data[2] <<  8) | (skb->data[3] <<  0);
 
 	IDT77252_PRV_PADDR(skb) = dma_map_single(&card->pcidev->dev, skb->data,
 						 skb->len, DMA_TO_DEVICE);
@@ -859,8 +862,7 @@ queue_skb(struct idt77252_dev *card, struct vc_map *vc,
 		tbd->word_1 = SAR_TBD_OAM | ATM_CELL_PAYLOAD | SAR_TBD_EPDU;
 		tbd->word_2 = IDT77252_PRV_PADDR(skb) + 4;
 		tbd->word_3 = 0x00000000;
-		tbd->word_4 = (skb->data[0] << 24) | (skb->data[1] << 16) |
-			      (skb->data[2] <<  8) | (skb->data[3] <<  0);
+		tbd->word_4 = word4;
 
 		if (test_bit(VCF_RSV, &vc->flags))
 			vc = card->vcs[0];
@@ -890,8 +892,7 @@ queue_skb(struct idt77252_dev *card, struct vc_map *vc,
 
 		tbd->word_2 = IDT77252_PRV_PADDR(skb) + 4;
 		tbd->word_3 = 0x00000000;
-		tbd->word_4 = (skb->data[0] << 24) | (skb->data[1] << 16) |
-			      (skb->data[2] <<  8) | (skb->data[3] <<  0);
+		tbd->word_4 = word4;
 		break;
 
 	case ATM_AAL5:
-- 
2.17.1


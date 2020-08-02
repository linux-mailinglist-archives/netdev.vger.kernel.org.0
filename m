Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E076723571E
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 15:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgHBNaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 09:30:22 -0400
Received: from zg8tmtm5lju5ljm3lje2naaa.icoremail.net ([139.59.37.164]:38745
        "HELO zg8tmtm5lju5ljm3lje2naaa.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1726578AbgHBNaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 09:30:22 -0400
X-Greylist: delayed 1139 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2020 09:30:19 EDT
Received: from oslab.tsinghua.edu.cn (unknown [166.111.139.112])
        by app-1 (Coremail) with SMTP id DwQGZQDn7MjOvyZfkEDqAw--.5190S2;
        Sun, 02 Aug 2020 21:29:57 +0800 (CST)
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
To:     chunkeey@googlemail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Subject: [PATCH] p54: avoid accessing the data mapped to streaming DMA
Date:   Sun,  2 Aug 2020 21:29:49 +0800
Message-Id: <20200802132949.26788-1-baijiaju@tsinghua.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DwQGZQDn7MjOvyZfkEDqAw--.5190S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WF48JFWrZFW8Ww15Cw4fGrg_yoW8ArW5pF
        Z8Aa47Kr4YvF45W3W0kF4UuF1YyayrA3sF9F4Ykwnakr4kXr1SqFyruFWIkwn0yrs8A3y3
        Ar1jqr47W3Z0y3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_Xr4l
        42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
        WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
        I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F
        4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
        42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUnpnQUUUUU
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In p54p_tx(), skb->data is mapped to streaming DMA on line 337:
  mapping = pci_map_single(..., skb->data, ...);

Then skb->data is accessed on line 349:
  desc->device_addr = ((struct p54_hdr *)skb->data)->req_id;

This access may cause data inconsistency between CPU cache and hardware.

To fix this problem, ((struct p54_hdr *)skb->data)->req_id is stored in
a local variable before DMA mapping, and then the driver accesses this
local variable instead of skb->data.

Signed-off-by: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
---
 drivers/net/wireless/intersil/p54/p54pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/p54pci.c b/drivers/net/wireless/intersil/p54/p54pci.c
index 80ad0b7eaef4..f8c6027cab6b 100644
--- a/drivers/net/wireless/intersil/p54/p54pci.c
+++ b/drivers/net/wireless/intersil/p54/p54pci.c
@@ -329,10 +329,12 @@ static void p54p_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct p54p_desc *desc;
 	dma_addr_t mapping;
 	u32 idx, i;
+	__le32 device_addr;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	idx = le32_to_cpu(ring_control->host_idx[1]);
 	i = idx % ARRAY_SIZE(ring_control->tx_data);
+	device_addr = ((struct p54_hdr *)skb->data)->req_id;
 
 	mapping = pci_map_single(priv->pdev, skb->data, skb->len,
 				 PCI_DMA_TODEVICE);
@@ -346,7 +348,7 @@ static void p54p_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 
 	desc = &ring_control->tx_data[i];
 	desc->host_addr = cpu_to_le32(mapping);
-	desc->device_addr = ((struct p54_hdr *)skb->data)->req_id;
+	desc->device_addr = device_addr;
 	desc->len = cpu_to_le16(skb->len);
 	desc->flags = 0;
 
-- 
2.17.1


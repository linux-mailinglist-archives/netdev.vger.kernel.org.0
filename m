Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4141434CCA2
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhC2JEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 05:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236850AbhC2JDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 05:03:09 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 227CBC061574;
        Mon, 29 Mar 2021 02:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=qSS/WkNQGe
        NrT3wV0F5Er/mkWnofMqnDNBZ4bVTPcJg=; b=g+69YvXzeRVO+2M1Ya3CAlkYYl
        OkD6WmO6Axyh2tcRlI4ouXz/LZHcnf9HWBIPpFsGseNlZ/EgU56Yo/k2PLTadOrF
        QZv3VAUXh9oMl1k5lQg5CFc8RefvOG+mE57JCr/pBiCbrxDLsf4Hu2tZ/5MoAu12
        YtQcJGXxZWqwyFvFc=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygCXnHzAl2Fg1ctlAA--.248S4;
        Mon, 29 Mar 2021 17:02:56 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] ethernet/realtek/r8169: Fix a double free in rtl8169_start_xmit
Date:   Mon, 29 Mar 2021 02:02:48 -0700
Message-Id: <20210329090248.4209-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygCXnHzAl2Fg1ctlAA--.248S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ur15Jr45ur4fuFWUGr1kAFb_yoW8ArykpF
        45Was3CF4vgw12q3W8GrWDWFn5A395trn5WFWfC3yFvrW5urs09F40gay0qr45JFWSka1x
        ZFs0yw1ak3ZxJ37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lc2xSY4AK67AK6r4fMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvj
        DU0xZFpf9x0JUS0P-UUUUU=
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rtl8169_start_xmit, it calls rtl8169_tso_csum_v2(tp, skb, opts) and
rtl8169_tso_csum_v2() calls __skb_put_padto(skb, padto, false). If
__skb_put_padto() failed, it will free the skb in the first time and
return error. Then rtl8169_start_xmit will goto err_dma_0.

But in err_dma_0 label, the skb is freed by dev_kfree_skb_any(skb) in
the second time.

My patch adds a new label inside the old err_dma_0 label to avoid the
double free and renames the error labels to keep the origin function
unchanged.

Fixes: b8447abc4c8fb ("r8169: factor out rtl8169_tx_map")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index f704da3f214c..91c43399712b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4217,13 +4217,13 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	if (unlikely(rtl8169_tx_map(tp, opts, skb_headlen(skb), skb->data,
 				    entry, false)))
-		goto err_dma_0;
+		goto err_dma_1;
 
 	txd_first = tp->TxDescArray + entry;
 
 	if (frags) {
 		if (rtl8169_xmit_frags(tp, skb, opts, entry))
-			goto err_dma_1;
+			goto err_dma_2;
 		entry = (entry + frags) % NUM_TX_DESC;
 	}
 
@@ -4270,10 +4270,11 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	return NETDEV_TX_OK;
 
-err_dma_1:
+err_dma_2:
 	rtl8169_unmap_tx_skb(tp, entry);
-err_dma_0:
+err_dma_1:
 	dev_kfree_skb_any(skb);
+err_dma_0:
 	dev->stats.tx_dropped++;
 	return NETDEV_TX_OK;
 
-- 
2.25.1



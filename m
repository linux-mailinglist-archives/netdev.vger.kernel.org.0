Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75C7352F2C
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 20:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbhDBS0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 14:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBS0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 14:26:41 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F1A3C0613E6;
        Fri,  2 Apr 2021 11:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=ro6FMNoOrO
        0XEPRabqokeCXCn1zTlPGE+6MinH0yRww=; b=eB82CVb8uwTCIDRspd1HcTthSl
        osXDtrCD6DEFM00shiDoHPv6P+N3QWfJaL2sGe6tduPKz3WpnonVkLYphWrcxMdx
        M8kUe5p4hplnCO3iKIu+cF7qnxen22UjRljnOUIugwi0oAWwpMZQ+zE42+Djdwpk
        aSiHubZifDOng5YA4=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygCXoqzVYWdgHZqMAA--.553S4;
        Sat, 03 Apr 2021 02:26:30 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     buytenh@wantstofly.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, gustavoars@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] wireless: marvell: mwl8k: Fix a double Free in mwl8k_probe_hw
Date:   Fri,  2 Apr 2021 11:26:27 -0700
Message-Id: <20210402182627.4256-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygCXoqzVYWdgHZqMAA--.553S4
X-Coremail-Antispam: 1UD129KBjvdXoW7GrW7Aw1kur4rCF15CF4rZrb_yoWDKwbE93
        W8WFnrWry7GrnFga1Uua1jv34S9Fy0gay8Wry7trWxWFWxAa9FqFWSkF13Ja43Cay3ZF9x
        Xrs3Jr1UAa47XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
        W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
        0VAGYxC7MxkIecxEwVAFwVW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUUX_-DUUUUU==
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mwl8k_probe_hw, hw->priv->txq is freed at the first time by
dma_free_coherent() in the call chain:
if(!priv->ap_fw)->mwl8k_init_txqs(hw)->mwl8k_txq_init(hw, i).

Then in err_free_queues of mwl8k_probe_hw, hw->priv->txq is freed
at the second time by mwl8k_txq_deinit(hw, i)->dma_free_coherent().

My patch set txq->txd to NULL after the first free to avoid the
double free.

Fixes: a66098daacee2 ("mwl8k: Marvell TOPDOG wireless driver")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/net/wireless/marvell/mwl8k.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index c9f8c056aa51..84b32a5f01ee 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -1473,6 +1473,7 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 	if (txq->skb == NULL) {
 		dma_free_coherent(&priv->pdev->dev, size, txq->txd,
 				  txq->txd_dma);
+		txq->txd = NULL;
 		return -ENOMEM;
 	}
 
-- 
2.25.1



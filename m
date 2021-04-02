Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03F1352E95
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 19:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhDBRkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 13:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbhDBRka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 13:40:30 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58236C061788;
        Fri,  2 Apr 2021 10:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=T7GJS3a/Td
        +A1NfNY/x47Fp7WerJVUZTyDo0c21nDF8=; b=rXyRBfZrvBwVcybV/2xqZzfwIX
        qrhU8CC7O2c/81x97E3GbttOujqOVsPO5J75rTta5ewUw2d4//ymsuKsNdf5Ddph
        G9KgWha1vEHtzHMegOEsY+4sdrbkXTXfFCfCjCNMguDF4weZ1HBIk1U4EDoE43le
        iV7BbU46sclr4vga8=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAXHUkFV2dg_WeMAA--.252S4;
        Sat, 03 Apr 2021 01:40:21 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] net: broadcom: bcm4908enet: Fix a double free in bcm4908_enet_dma_alloc
Date:   Fri,  2 Apr 2021 10:40:19 -0700
Message-Id: <20210402174019.3679-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygAXHUkFV2dg_WeMAA--.252S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKFy8tF48GF48Cw4UKr4kZwb_yoWkCrb_Ga
        45X3s7ur4DJryYka1IkrsrJryI9ayjvry8uFy09rWSqFy7ur1xXw4xAFn0qw17WrWktFy3
        Ga43tFWDA348GjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
        W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
        0VAGYxC7MxkIecxEwVAFwVW8MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUj1E_JUUUUU==
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bcm4908_enet_dma_alloc, if callee bcm4908_dma_alloc_buf_descs() failed,
it will free the ring->cpu_addr by dma_free_coherent() and return error.
Then bcm4908_enet_dma_free() will be called, and free the same cpu_addr
by dma_free_coherent() again.

My patch set ring->cpu_addr to NULL after it is freed in
bcm4908_dma_alloc_buf_descs() to avoid the double free.

Fixes: 4feffeadbcb2e ("net: broadcom: bcm4908enet: add BCM4908 controller driver")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 0b70e9e0ddad..32058386e74b 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -172,6 +172,7 @@ static int bcm4908_dma_alloc_buf_descs(struct bcm4908_enet *enet,
 
 err_free_buf_descs:
 	dma_free_coherent(dev, size, ring->cpu_addr, ring->dma_addr);
+	ring->cpu_addr = NULL;
 	return -ENOMEM;
 }
 
-- 
2.25.1



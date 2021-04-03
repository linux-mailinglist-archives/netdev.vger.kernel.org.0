Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AD93532C4
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 07:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhDCFsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 01:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbhDCFsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 01:48:12 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07DD1C0613E6;
        Fri,  2 Apr 2021 22:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=U6U25Q7oy9
        Cp9XMB8iKbrDhc9wIxlBHGI4NY2S+Os98=; b=U8CrhRfyTFuI/N2i210hz7LFRp
        EBcK228pAUWoawWMEA8f10AQ8nguQS+uaSUPwQqGbp0/61GolkNHUruCibz0CTe5
        fKFKXDG2wzlec0qRT7ds6vkxet5MBFmdrbPmHHFQkBY3Hnu3t/+2/9z5P83OrNCG
        hT6mXCxXL8yEJ7KRM=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAXHKSNAWhgflqPAA--.209S4;
        Sat, 03 Apr 2021 13:47:57 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     luciano.coelho@intel.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        mordechay.goodstein@intel.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] wireless: iwlwifi: Fix a double free in iwl_txq_dyn_alloc_dma
Date:   Fri,  2 Apr 2021 22:47:55 -0700
Message-Id: <20210403054755.4781-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygAXHKSNAWhgflqPAA--.209S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Gry7Zw43uw4UJF17ZF48Crg_yoW8Jr4rpF
        4DCr12kFZ8Xa1DZ34kAF4SgFnxJa1Uua93Ka4jyw1fu343Ars5K3WkuFyjqry8JF4rZr1S
        9F1YkF45GF98XFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUB014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
        0_GcWlnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK67AK6r4rMxAIw28IcxkI7VAKI4
        8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
        wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
        v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
        Y4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYkucDUUUU
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In iwl_txq_dyn_alloc_dma, txq->tfds is freed at first time by:
iwl_txq_alloc()->goto err_free_tfds->dma_free_coherent(). But
it forgot to set txq->tfds to NULL.

Then the txq->tfds is freed again in iwl_txq_dyn_alloc_dma by:
goto error->iwl_txq_gen2_free_memory()->dma_free_coherent().

My patch sets txq->tfds to NULL after the first free to avoid the
double free.

Fixes: 0cd1ad2d7fd41 ("iwlwifi: move all bus-independent TX functions to common code")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/net/wireless/intel/iwlwifi/queue/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.c b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
index 833f43d1ca7a..99c8e473031a 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
@@ -1101,6 +1101,7 @@ int iwl_txq_alloc(struct iwl_trans *trans, struct iwl_txq *txq, int slots_num,
 	return 0;
 err_free_tfds:
 	dma_free_coherent(trans->dev, tfd_sz, txq->tfds, txq->dma_addr);
+	txq->tfds = NULL;
 error:
 	if (txq->entries && cmd_queue)
 		for (i = 0; i < slots_num; i++)
-- 
2.25.1



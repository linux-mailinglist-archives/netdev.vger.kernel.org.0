Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A38234CFA6
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhC2MC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhC2MCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:02:09 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37546C061574;
        Mon, 29 Mar 2021 05:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=R34OrgAceM
        eMrFV+JCpxaSd85NskDzH5U6NaA8ZXVAg=; b=VcCyTLrornF+2maYRIkk5dSBH1
        Hp8v9Ry05h93kBjiD4M1tSZSAYGGK9IEM6drQVX05EMqiPb1MPcDRhz/T04h8xn9
        n5l6oXxLPLJ1cVjS+Z2Oje297UXoOf5+qmOYWTWQ3m27+UW6ccLpOT7UqhwxVwmr
        Dx9LH6E6MShVH7Q9Y=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygA3Pkq1wWFg7mVnAA--.201S4;
        Mon, 29 Mar 2021 20:01:57 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] wireless: ath10k: Fix a use after free in ath10k_htc_send_bundle
Date:   Mon, 29 Mar 2021 05:01:54 -0700
Message-Id: <20210329120154.8963-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygA3Pkq1wWFg7mVnAA--.201S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtw4xGr1ktw13KFW5Xry7Jrb_yoWDKwcEga
        1kZF1fZ3ykJw17AFy2yF4ftrWIyFyIqFZ5u3sxKrW8XrW3JFZrCrWY93s8Gr9rGrWrZF9x
        CrnxWryDA3sYgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbV8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7MxkIecxEwVAFwVW5JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
        DU0xZFpf9x0JUPl1kUUUUU=
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ath10k_htc_send_bundle, the bundle_skb could be freed by
dev_kfree_skb_any(bundle_skb). But the bundle_skb is used later
by bundle_skb->len.

As skb_len = bundle_skb->len, my patch replaces bundle_skb->len to
skb_len after the bundle_skb was freed.

Fixes: c8334512f3dd1 ("ath10k: add htt TX bundle for sdio")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/net/wireless/ath/ath10k/htc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 0a37be6a7d33..fab398046a3f 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -669,7 +669,7 @@ static int ath10k_htc_send_bundle(struct ath10k_htc_ep *ep,
 
 	ath10k_dbg(ar, ATH10K_DBG_HTC,
 		   "bundle tx status %d eid %d req count %d count %d len %d\n",
-		   ret, ep->eid, skb_queue_len(&ep->tx_req_head), cn, bundle_skb->len);
+		   ret, ep->eid, skb_queue_len(&ep->tx_req_head), cn, skb_len);
 	return ret;
 }
 
-- 
2.25.1



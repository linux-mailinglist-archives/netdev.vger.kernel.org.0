Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B79A3707BC
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 17:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhEAPcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 11:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhEAPcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 11:32:52 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7458DC06174A;
        Sat,  1 May 2021 08:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=81fpXB51S0
        gdXeEFhP62/B/NjYzMHee3NPblG1W9CdM=; b=eTlddhhxr7MmiwKYaojnfY/W+G
        8ab56aiZQ2WLJoTVC6dYZ46NRFrmcZfwvsfyxuQ1qYDT9UlLl9ui9eFH8McjsDvE
        evqjHN1/q6GGDIPLG2g0basdjGFVfNW26bMM3U1AWHfpEKrRnSxa3X2R668RkrVZ
        9iZzUpJbR1IWE/xaY=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBnbJhfdI1gX111AA--.448S4;
        Sat, 01 May 2021 23:31:43 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     benve@cisco.com, _govind@gmx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] ethernet:enic: Fix a use after free bug in enic_hard_start_xmit
Date:   Sat,  1 May 2021 08:31:40 -0700
Message-Id: <20210501153140.5885-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygBnbJhfdI1gX111AA--.448S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww4xXr13tr43Jr1UZw13Jwb_yoW8Zw1Dpa
        ykA3s5GF4rKw4DXayDA348Gw1av3W0kF9xKryxAwsYqFs8trWDXFykKw42kry5JrWrGa43
        Jr10yrnxKwnxArJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7MxkIecxEwVAFwVW5WwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73Uj
        IFyTuYvjfU0GQ6UUUUU
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In enic_hard_start_xmit, it calls enic_queue_wq_skb(). Inside
enic_queue_wq_skb, if some error happens, the skb will be freed
by dev_kfree_skb(skb). But the freed skb is still used in
skb_tx_timestamp(skb).

My patch makes enic_queue_wq_skb() return error and goto spin_unlock()
incase of error. The solution is provided by Govind.
See https://lkml.org/lkml/2021/4/30/961.

Fixes: fb7516d42478e ("enic: add sw timestamp support")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index f04ec53544ae..40abc3fdeba6 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -768,7 +768,7 @@ static inline int enic_queue_wq_skb_encap(struct enic *enic, struct vnic_wq *wq,
 	return err;
 }
 
-static inline void enic_queue_wq_skb(struct enic *enic,
+static inline int enic_queue_wq_skb(struct enic *enic,
 	struct vnic_wq *wq, struct sk_buff *skb)
 {
 	unsigned int mss = skb_shinfo(skb)->gso_size;
@@ -813,7 +813,9 @@ static inline void enic_queue_wq_skb(struct enic *enic,
 		}
 		wq->to_use = buf->next;
 		dev_kfree_skb(skb);
+		return err;
 	}
+	return err;
 }
 
 /* netif_tx_lock held, process context with BHs disabled, or BH */
@@ -857,7 +859,8 @@ static netdev_tx_t enic_hard_start_xmit(struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
-	enic_queue_wq_skb(enic, wq, skb);
+	if (enic_queue_wq_skb(enic, wq, skb) < 0)
+		goto error;
 
 	if (vnic_wq_desc_avail(wq) < MAX_SKB_FRAGS + ENIC_DESC_MAX_SPLITS)
 		netif_tx_stop_queue(txq);
@@ -865,6 +868,7 @@ static netdev_tx_t enic_hard_start_xmit(struct sk_buff *skb,
 	if (!netdev_xmit_more() || netif_xmit_stopped(txq))
 		vnic_wq_doorbell(wq);
 
+error:
 	spin_unlock(&enic->wq_lock[txq_map]);
 
 	return NETDEV_TX_OK;
-- 
2.25.1



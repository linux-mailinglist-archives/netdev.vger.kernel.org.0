Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595F434D032
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhC2MhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhC2MhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:37:03 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E0BFC061574;
        Mon, 29 Mar 2021 05:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=r3ftkNVKou
        Clz+5vYE829wdX1OpZPqS5NNTe9okZl04=; b=fLxC7n7upYVRhR65q2gOayKjiR
        qwHBPgL9zw4Mz+Nygog5jjRzxnXD1O14RvNlH1qVoXKEO9zwr3jLdty5lNcQWeop
        vt8bPlrxZ2EYRD1wB1B+KXHxoGJZrN5KBsRb6f/CqJHZyXsA+rMyD4hCKNVVnSiM
        V/FlINfsR5AAmif/U=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAXHkLjyWFgzqVnAA--.619S4;
        Mon, 29 Mar 2021 20:36:51 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     christopher.lee@cspi.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] ethernet: myri10ge: Fix a use after free in myri10ge_sw_tso
Date:   Mon, 29 Mar 2021 05:36:48 -0700
Message-Id: <20210329123648.9474-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygAXHkLjyWFgzqVnAA--.619S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtw4xKr4UKry7CrWUZF1kZrb_yoWkArX_GF
        nYqa1ftw4UGF45Ary5tr15Jr9Y9Fs8Z34furWxKas3JrZrXa13Jrn8JrZxu347Gr4DGFy7
        Arsrtr9xC3s0qjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCY02Avz4vE14v_Xr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUepB-DUUUU
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In myri10ge_sw_tso, the skb_list_walk_safe macro will set
(curr) = (segs) and (next) = (curr)->next. If status!=0 is true,
the memory pointed by curr and segs will be free by dev_kfree_skb_any(curr).
But later, the segs is used by segs = segs->next and causes a uaf.

As (next) = (curr)->next, my patch replaces seg->next to next.

Fixes: 536577f36ff7a ("net: myri10ge: use skb_list_walk_safe helper for gso segments")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 1634ca6d4a8f..c84c8bf2bc20 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2897,7 +2897,7 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 			dev_kfree_skb_any(curr);
 			if (segs != NULL) {
 				curr = segs;
-				segs = segs->next;
+				segs = next;
 				curr->next = NULL;
 				dev_kfree_skb_any(segs);
 			}
-- 
2.25.1



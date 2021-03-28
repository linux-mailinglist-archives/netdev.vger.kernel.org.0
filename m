Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464E334BB99
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 09:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhC1Hun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 03:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhC1HuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 03:50:19 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0FD8C061762;
        Sun, 28 Mar 2021 00:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=opXlKr1Le0
        DyEohzhyA9nRDoPFWP03/6sChBMUspOCQ=; b=Cnktk34WDWZx02DAJFasm1L6o9
        kq0SgmYsQ6TeMVIknJTB3E/1adOwCGpgEffVPEFf3okR8kqkMC7KmZHS6WIESNEL
        KDX5iDpaU5UL4xCZhdTxc59ei05VLrUUx/UieWnElpcpnP+WyoKpDZw8FsZGdYez
        03W5DGvF7dAotsShY=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBHT0syNWBgtaxcAA--.3415S4;
        Sun, 28 Mar 2021 15:50:10 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     khc@pm.waw.pl, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit
Date:   Sun, 28 Mar 2021 00:50:08 -0700
Message-Id: <20210328075008.4770-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygBHT0syNWBgtaxcAA--.3415S4
X-Coremail-Antispam: 1UD129KBjvdXoW7JrW5Ar4kWr1kAr13uw4kWFg_yoWkKFbEkr
        ZYv3WxC3y8Kw1qqr4kWF13Aryaka1kXFWkZFWfKr9xJ347ur97CwsavF97GryUG3ySkFW7
        JrWkZFykCrWrWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbsAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
        1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v
        4I1lc2xSY4AK67AK6r4xMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI
        8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
        xVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI
        8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUbVHq5UUUUU==
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In pvc_xmit, if __skb_pad(skb, pad, false) failed, it will free
the skb in the first time and goto drop. But the same skb is freed
by kfree_skb(skb) in the second time in drop.

Maintaining the original function unchanged, my patch adds a new
label out to avoid the double free if __skb_pad() failed.

Fixes: f5083d0cee08a ("drivers/net/wan/hdlc_fr: Improvements to the code of pvc_xmit")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/net/wan/hdlc_fr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 0720f5f92caa..4d9dc7d15908 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -415,7 +415,7 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		if (pad > 0) { /* Pad the frame with zeros */
 			if (__skb_pad(skb, pad, false))
-				goto drop;
+				goto out;
 			skb_put(skb, pad);
 		}
 	}
@@ -448,8 +448,9 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 drop:
-	dev->stats.tx_dropped++;
 	kfree_skb(skb);
+out:
+	dev->stats.tx_dropped++;
 	return NETDEV_TX_OK;
 }
 
-- 
2.25.1



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D374C29B2
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 11:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbiBXKkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 05:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiBXKkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 05:40:14 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E39F28AD8B;
        Thu, 24 Feb 2022 02:39:45 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 195so1378795pgc.6;
        Thu, 24 Feb 2022 02:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Vh5cP09KPpUBAiHzIJdfbvku1bTkEPxJPZgY/cAC6g=;
        b=n1De8gS0CLlFYpKENSHsqTOWS+rniNCEhj7lh0xhcPZq7fUWd2DjB5YwXkjb64d+tJ
         jJnc6aav14lN/jwq/0LLT4j2sAnYXi3SknpAP7hBow4mx5jwvR0g5Jnl4pb3QNDy4N7o
         U7kvWYSIdIXRgfCvcB4Z4lhPpOf7MEV0wG+yuYxcK8/GA34xVC+yzDsqodAhBa2BM08e
         Uv9/ixkD9q3l7GLW6D9b/qIs+JMUZ55l4crhFwcwS0CCxFmEuK1ycVmsdrJLnIwBZdoq
         qjfASEq/ymAiU/MPTQyNEbpWEBpc3CSUh+S3Du+iDYqqP7uiBO346zVKcjG2MbrH4Gtb
         rFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Vh5cP09KPpUBAiHzIJdfbvku1bTkEPxJPZgY/cAC6g=;
        b=C84+C+iPb2SXyKs9llTZwdFgFKfB0G7A6+Ca6BABcsT2yCqT0NHSYxiSf1qEkUpjQJ
         N6ER5qbPXWzIKnshnLvHRta5yxyHGD1VAOfOJjGa0YaGuFsas5Rd5mMgxm0xdfuxHWua
         fUICiZoVt8PGle7L9GV9ySp2nil5QXAwgLi1eIAZYo/dKkK55Gs73fBG3dg0ocC+4EyG
         KGAfsvuBaFnDmAIvblHUGNqrVdqgtNGt0tYi+uBggVUYPtrjrlXu7zHR0eu9/OcBJeH0
         2YojUEaEeJzmXFZebAvnZnkpyXXXRqPsWZIurQ5NEClCyIzyoqB2dUI2KstPjIh3Jylj
         8Sww==
X-Gm-Message-State: AOAM531gNaYM+UsTp/p2pEbayHRvWQybMNpp65KDFclqZvxjUgpJVmU3
        SE5xn6fMupvuTm1fE1/Rc5d+rKuiPCHnQ/rc
X-Google-Smtp-Source: ABdhPJyKDl17e3IrZ6PDMsRujoK/pWk4njV+gyUOCkB+5cRcl/CAaY2OVgqBQXC/x7gKlf/HNWWYyw==
X-Received: by 2002:a63:e249:0:b0:36c:4f1f:95e0 with SMTP id y9-20020a63e249000000b0036c4f1f95e0mr1786299pgj.381.1645699184682;
        Thu, 24 Feb 2022 02:39:44 -0800 (PST)
Received: from localhost.localdomain ([157.255.44.219])
        by smtp.gmail.com with ESMTPSA id t2sm2984555pfj.211.2022.02.24.02.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 02:39:44 -0800 (PST)
From:   Harold Huang <baymaxhuang@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jasowang@redhat.com, Harold Huang <baymaxhuang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] tun: support NAPI to accelerate packet processing
Date:   Thu, 24 Feb 2022 18:38:51 +0800
Message-Id: <20220224103852.311369-1-baymaxhuang@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tun, NAPI is supported and we can also use NAPI in the path of
batched XDP buffs to accelerate packet processing. What is more, after
we use NPAI, GRO is also supported. The iperf shows that the throughput
could be improved from 4.5Gbsp to 9.2Gbps per stream.

Reported-at: https://lore.kernel.org/netdev/CAHJXk3Y9_Fh04sakMMbcAkef7kOTEc-kf84Ne3DtWD7EAp13cg@mail.gmail.com/T/#t
Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
---
 drivers/net/tun.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fed85447701a..4e1cea659b42 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2388,6 +2388,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 	struct virtio_net_hdr *gso = &hdr->gso;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb = NULL;
+	struct sk_buff_head *queue;
 	u32 rxhash = 0, act;
 	int buflen = hdr->buflen;
 	int err = 0;
@@ -2464,7 +2465,14 @@ static int tun_xdp_one(struct tun_struct *tun,
 	    !tfile->detached)
 		rxhash = __skb_get_hash_symmetric(skb);
 
-	netif_receive_skb(skb);
+	if (tfile->napi_enabled) {
+		queue = &tfile->sk.sk_write_queue;
+		spin_lock(&queue->lock);
+		__skb_queue_tail(queue, skb);
+		spin_unlock(&queue->lock);
+	} else {
+		netif_receive_skb(skb);
+	}
 
 	/* No need to disable preemption here since this function is
 	 * always called with bh disabled
@@ -2507,6 +2515,9 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 		if (flush)
 			xdp_do_flush();
 
+		if (tfile->napi_enabled)
+			napi_schedule(&tfile->napi);
+
 		rcu_read_unlock();
 		local_bh_enable();
 
-- 
2.27.0


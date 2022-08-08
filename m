Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374FE58C216
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 05:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbiHHDbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 23:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiHHDb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 23:31:28 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD61C7679;
        Sun,  7 Aug 2022 20:31:26 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id l188so9119420oia.4;
        Sun, 07 Aug 2022 20:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=35M7EF9cm7n0WEKaRv5TpsC1BmIbhtj1TadCQq+kcAo=;
        b=DV4tgmu8pX32Tk3pPXYUdCDBPVNjR87FysPeojplJ1GcP0/JU6d39Qf31mCBxrvjUi
         6z504nYrlfgxNsVJ5RwZRqjZ9MuC5ruLxogjej4OFjBDKipkpqYuTUR+p5c++TbEvDYQ
         3B0XdpYJf5yRjHbsBNekjmAOf1N8rSB6Ficc0UFuhv4/Edgv+uh7YeTBzbfjjGWZjrMc
         L+jkiCYc6dJ6w+uz3p7KYP/PYL75ILmMQcrqatBIFxKV27GzFft5lmy8ZfJ/vawODbZ+
         I7iBJr7axsSquUoWLZKBh36VqHpuXOwxoM/cx5Ha+qBVh/cDbZnJsFtL8xTbynnsSw/4
         w42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=35M7EF9cm7n0WEKaRv5TpsC1BmIbhtj1TadCQq+kcAo=;
        b=8LpDLgziF0VtJcZ5NjOIh9s1BrwLu6C8QvT0BBR+ifX1pqYhG0P+NiviaptHRlO4tB
         9Y3qLuHgz7S6/ISUGLwPfHn0+M6xJoo7XEFgk5rvtVJHcm+fLcz9c38lePPgUZS/59mI
         sTg5agOpRzDPqMTPJbHBIyldJBa6SNdZLBEdKEAYTEPJ55abS/q4uAzegSn9DkSi8E3n
         7doCLvlSDZC+RL7SHEG1xn10vdqaEa20Par3flaxIGmyPgSBYI2GraJgpZYsfyLraLCf
         CclsMhlbKfCZMPDVCRAFhTdHO5dEyquMuMIwhBzIS4IGWVzOLBM6FVUO4Thjht3Zfmuu
         RerQ==
X-Gm-Message-State: ACgBeo1tFUVKajz5ZJeHHVCu3icjO7xS0LQqvWxzw2Zx4y8ff5KMqAXW
        kkW5Fyo7lL1ZXFSp7A+R0UN4KKs32Io=
X-Google-Smtp-Source: AA6agR7ZNlixfc3zEZ/Dug+7X8ntFs5VU/g5PyZj6MTJVmquExHwq07p5vbFoQ8Li8FX9wZQRh9Qmg==
X-Received: by 2002:a05:6808:1390:b0:33a:d77b:fddb with SMTP id c16-20020a056808139000b0033ad77bfddbmr6941439oiw.151.1659929485845;
        Sun, 07 Aug 2022 20:31:25 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:ad03:d88f:99fe:9487])
        by smtp.gmail.com with ESMTPSA id k39-20020a4a94aa000000b00425806a20f5sm1945138ooi.3.2022.08.07.20.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 20:31:25 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch net v2 3/4] tcp: refactor tcp_read_skb() a bit
Date:   Sun,  7 Aug 2022 20:31:05 -0700
Message-Id: <20220808033106.130263-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220808033106.130263-1-xiyou.wangcong@gmail.com>
References: <20220808033106.130263-1-xiyou.wangcong@gmail.com>
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

From: Cong Wang <cong.wang@bytedance.com>

As tcp_read_skb() only reads one skb at a time, the while loop is
unnecessary, we can turn it into an if. This also simplifies the
code logic.

Cc: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/tcp.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 181a0d350123..5212a7512269 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1761,27 +1761,18 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 	if (sk->sk_state == TCP_LISTEN)
 		return -ENOTCONN;
 
-	while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
-		int used;
-
+	skb = tcp_recv_skb(sk, seq, &offset);
+	if (skb) {
 		__skb_unlink(skb, &sk->sk_receive_queue);
 		WARN_ON(!skb_set_owner_sk_safe(skb, sk));
-		used = recv_actor(sk, skb);
-		if (used <= 0) {
-			if (!copied)
-				copied = used;
-			break;
-		}
-		seq += used;
-		copied += used;
-
-		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
-			++seq;
-			break;
+		copied = recv_actor(sk, skb);
+		if (copied > 0) {
+			seq += copied;
+			if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
+				++seq;
 		}
-		break;
+		consume_skb(skb);
 	}
-	consume_skb(skb);
 	WRITE_ONCE(tp->copied_seq, seq);
 
 	tcp_rcv_space_adjust(sk);
-- 
2.34.1


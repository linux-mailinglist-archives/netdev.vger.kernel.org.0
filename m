Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3582A503445
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiDPAOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 20:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245694AbiDPANx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 20:13:53 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D722E3FDBD
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:22 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id k29so9016513pgm.12
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/7G1zqgFMYnJTf2aCFq6rD8OeLxfrar8r80T2W3ZAYQ=;
        b=eaEbwoKsDc6V9mKSxYrPqwjC9sUQzcLXMZJDN+fgugsrmy+000CVQD5xov4I3KpMXz
         zOd6AtXGrM4zRBsdtrYaMnGn0ApNZ5ma6pHr2Qaoqo7WOyhn6JXAGasp29Typz1WHp9w
         FH0LB7NTcz3311cL6ZQLRsIo0tBb+3KM9EVTHomg/Cg8Eqy9hxAmXHhLymuRKXTl599P
         RnlgiS1KM5pR1qCmSPZPp5eEpTrgNNiFooXUYQkk5cRQR6uI8T1qsIulZXpYMCoTK9zl
         xcV2R1iZWjQZD4iTf3UiBk5drYX4fa1gQvgdacH/JrKQwanCUt3ljc6xmkzbwFSGRTbK
         PzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/7G1zqgFMYnJTf2aCFq6rD8OeLxfrar8r80T2W3ZAYQ=;
        b=RiisMERYcktK9bORTzkefTBw11vFzFDvVoGWVbaXqi+uSuKPPHY6BgC6YTWgy4U5Qi
         DHxFOddKWMVCXQoSjk4NMJD5YIYW0DqdeA59eO3SxIdcBKS+s1shZ6LT16tSBNDJlhgQ
         qUANrNYL8wVdPC+/WsmrQFMWl4+U6fX3cz1+Prjx2L5jIwobxbUd8fJVwOK7//sVsnfK
         VWMLdb2wF8CcMU42QbxBwCh+C2f8urGd9fntKPWF/vvzcMgeJciZ+ojGGurlUcMxyeTu
         HNk4z8NZSX3ci7mCfJ8DuGyXc/4JlCaKxCFHNul64BQrEUubcwqQOHbySBqSsT8+JV63
         FsNQ==
X-Gm-Message-State: AOAM533nKl2gIvfVJYGeTY20WPnWv+VFUBccKr+DhHksxdMIwKt2VtsC
        WEL/3I9i08AO/FaCakUs0yc=
X-Google-Smtp-Source: ABdhPJyKVrpqTw2Q5YKWQJhP3AmXLiUPMGTfJh33YWN3aEZ5W5pd6uwV9lU+Itjghwp9fVfJSHmd3w==
X-Received: by 2002:aa7:82d9:0:b0:4fa:2c7f:41e with SMTP id f25-20020aa782d9000000b004fa2c7f041emr1285650pfn.1.1650067882193;
        Fri, 15 Apr 2022 17:11:22 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:147b:581d:7b9d:b092])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm5729514pjf.23.2022.04.15.17.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:11:21 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 07/10] tcp: add drop reason support to tcp_prune_ofo_queue()
Date:   Fri, 15 Apr 2022 17:10:45 -0700
Message-Id: <20220416001048.2218911-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220416001048.2218911-1-eric.dumazet@gmail.com>
References: <20220416001048.2218911-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Add one reason for packets dropped from OFO queue because
of memory pressure.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 2 ++
 net/ipv4/tcp_input.c       | 3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9ff5557b190905f716a25f67113c1db822707959..ad15ad208b5612357546f23dfe4feaa1535f4982 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -392,6 +392,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_OLD_ACK,	/* TCP ACK is old, but in window */
 	SKB_DROP_REASON_TCP_TOO_OLD_ACK, /* TCP ACK is too old */
 	SKB_DROP_REASON_TCP_ACK_UNSENT_DATA, /* TCP ACK for data we haven't sent yet */
+	SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE, /* pruned from TCP OFO queue */
 	SKB_DROP_REASON_IP_OUTNOROUTES,	/* route lookup failed */
 	SKB_DROP_REASON_BPF_CGROUP_EGRESS,	/* dropped by
 						 * BPF_PROG_TYPE_CGROUP_SKB
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index eab0b09223f3c66255f930d44be61d45e83ca6e8..73d7a6e594cbc6884148afa473bc08d12d783079 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -48,6 +48,8 @@
 	EM(SKB_DROP_REASON_TCP_TOO_OLD_ACK, TCP_TOO_OLD_ACK)	\
 	EM(SKB_DROP_REASON_TCP_ACK_UNSENT_DATA,			\
 	   TCP_ACK_UNSENT_DATA)					\
+	EM(SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE,			\
+	  TCP_OFO_QUEUE_PRUNE)					\
 	EM(SKB_DROP_REASON_IP_OUTNOROUTES, IP_OUTNOROUTES)	\
 	EM(SKB_DROP_REASON_BPF_CGROUP_EGRESS,			\
 	   BPF_CGROUP_EGRESS)					\
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8a68785b04053b8e622404035284920e51cd953c..a1077adeb1b62d74b5f1c9a6fc34def44ae07790 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5334,7 +5334,8 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
 		prev = rb_prev(node);
 		rb_erase(node, &tp->out_of_order_queue);
 		goal -= rb_to_skb(node)->truesize;
-		tcp_drop(sk, rb_to_skb(node));
+		tcp_drop_reason(sk, rb_to_skb(node),
+				SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE);
 		if (!prev || goal <= 0) {
 			sk_mem_reclaim(sk);
 			if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
-- 
2.36.0.rc0.470.gd361397f0d-goog


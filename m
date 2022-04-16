Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1BC503392
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbiDPAOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 20:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbiDPAN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 20:13:59 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6256E48E77
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:29 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id bx5so8661708pjb.3
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZIDCzIQbVqISNHr7nFXqJpdxyPN74kyCes1OzRawTFw=;
        b=Kr3lwbr7sc5z/5oTAodMArZvUtvE1ecQRWF6u7gx+rajpt3rBm2NVQ9RLzoOGtMCax
         f0Gu0vKhNdPoLV3AZHOTJhS758TurmURXYKNo3CQs6pThMUUPdnYJ7bf+NMV4sLL8t2/
         DoE2qA0k4uxmChpOvxD8A93ca44TFNpF+Qk8j50CrGrahwXtyIyK9ruNzAIkpLuiFeGk
         4RoA1TbVVSZEPc3yVD8KrZR8UTjUW8kcSU9roGZDI97akIgQ/TDhSQWDsLOlG1NLvlgb
         LFsKhL1l/jr8vSMzIAevXYda2NFy8+ZfqQCQNZMbUZGT8zHnqyx6yl/n4FK3Kwtkrxuk
         e7QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZIDCzIQbVqISNHr7nFXqJpdxyPN74kyCes1OzRawTFw=;
        b=r2EzHSffq6cObnYWnC44c9Z+GnkQNNdcztpCmAhddtMsZaiv2VWgTjXi/emyNE5CRv
         MMzRUm4Ahc6sdZi89Ty57AbJuX/UTnX83dUeiwnluHOMNV4yJ46f3XA8SNVds4KZio6+
         LWBgDlUSLnULP1eNBTsf7WVLp2GNukj6Sl+EfgzRXHa24wAi9Sx0gwAHvEeRMLvYjRHN
         ZthDrn1/rZ4xpWXmlFpkolnTusZyTdn3BwJKx4YZNlvz68Jo4UBHkfCovTEvHiLwlTvS
         4hUOE01yVywPAK05Z/cZODL/O4hepN2io/FnUeo9/whXqpi+cccFLbuiGeSxW8GnOKkX
         UTrA==
X-Gm-Message-State: AOAM533A7GtWIsZCkbtjOcg2czj13uUkdImbxHdPoh6231f8xWGWDl6+
        w/ucB0Y9ZsudujzOA9fhHInpLRO4SbQ=
X-Google-Smtp-Source: ABdhPJyXYymKi010dhKwZe3Yj6rgD9dAzM+D1d09EjVosmo3G08o+TyTtd4dfoCbI37D5ZnOnVxxAA==
X-Received: by 2002:a17:90a:3e48:b0:1cd:34ec:c72f with SMTP id t8-20020a17090a3e4800b001cd34ecc72fmr6754237pjm.65.1650067888791;
        Fri, 15 Apr 2022 17:11:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:147b:581d:7b9d:b092])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm5729514pjf.23.2022.04.15.17.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:11:28 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 10/10] tcp: add drop reason support to tcp_ofo_queue()
Date:   Fri, 15 Apr 2022 17:10:48 -0700
Message-Id: <20220416001048.2218911-11-eric.dumazet@gmail.com>
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

packets in OFO queue might be redundant, and dropped.

tcp_drop() is no longer needed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 1 +
 net/ipv4/tcp_input.c       | 9 ++-------
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ad15ad208b5612357546f23dfe4feaa1535f4982..84d78df60453955a8eaf05847f6e2145176a727a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -393,6 +393,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_TOO_OLD_ACK, /* TCP ACK is too old */
 	SKB_DROP_REASON_TCP_ACK_UNSENT_DATA, /* TCP ACK for data we haven't sent yet */
 	SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE, /* pruned from TCP OFO queue */
+	SKB_DROP_REASON_TCP_OFO_DROP,	/* data already in receive queue */
 	SKB_DROP_REASON_IP_OUTNOROUTES,	/* route lookup failed */
 	SKB_DROP_REASON_BPF_CGROUP_EGRESS,	/* dropped by
 						 * BPF_PROG_TYPE_CGROUP_SKB
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 73d7a6e594cbc6884148afa473bc08d12d783079..a477bf9074982cde8d1025ed18086fecafae8807 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -37,6 +37,7 @@
 	EM(SKB_DROP_REASON_TCP_OLD_DATA, TCP_OLD_DATA)		\
 	EM(SKB_DROP_REASON_TCP_OVERWINDOW, TCP_OVERWINDOW)	\
 	EM(SKB_DROP_REASON_TCP_OFOMERGE, TCP_OFOMERGE)		\
+	EM(SKB_DROP_REASON_TCP_OFO_DROP, TCP_OFO_DROP)		\
 	EM(SKB_DROP_REASON_TCP_RFC7323_PAWS, TCP_RFC7323_PAWS)	\
 	EM(SKB_DROP_REASON_TCP_INVALID_SEQUENCE,		\
 	   TCP_INVALID_SEQUENCE)				\
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 339cc3d40745a0ea2a9f66b03dfda5aa6800d4a2..cf2dc19bb8c766c1d33406053fd61c0873f15489 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4674,7 +4674,7 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
 {
 	bool res = tcp_try_coalesce(sk, to, from, fragstolen);
 
-	/* In case tcp_drop() is called later, update to->gso_segs */
+	/* In case tcp_drop_reason() is called later, update to->gso_segs */
 	if (res) {
 		u32 gso_segs = max_t(u16, 1, skb_shinfo(to)->gso_segs) +
 			       max_t(u16, 1, skb_shinfo(from)->gso_segs);
@@ -4691,11 +4691,6 @@ static void tcp_drop_reason(struct sock *sk, struct sk_buff *skb,
 	kfree_skb_reason(skb, reason);
 }
 
-static void tcp_drop(struct sock *sk, struct sk_buff *skb)
-{
-	tcp_drop_reason(sk, skb, SKB_DROP_REASON_NOT_SPECIFIED);
-}
-
 /* This one checks to see if we can put data from the
  * out_of_order queue into the receive_queue.
  */
@@ -4723,7 +4718,7 @@ static void tcp_ofo_queue(struct sock *sk)
 		rb_erase(&skb->rbnode, &tp->out_of_order_queue);
 
 		if (unlikely(!after(TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt))) {
-			tcp_drop(sk, skb);
+			tcp_drop_reason(sk, skb, SKB_DROP_REASON_TCP_OFO_DROP);
 			continue;
 		}
 
-- 
2.36.0.rc0.470.gd361397f0d-goog


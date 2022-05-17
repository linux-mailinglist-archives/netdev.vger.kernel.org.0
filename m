Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0951529BEE
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242675AbiEQIMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235674AbiEQIML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:12:11 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F383CA68;
        Tue, 17 May 2022 01:12:05 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x12so16295438pgj.7;
        Tue, 17 May 2022 01:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cAONMTMOUj5WPs7ieoNpxag94xyVtxhJLyFyNTFOxKY=;
        b=M/BrsATgBTdCYpAy7daDdTXN49Q/sx1f6R0MGwiPohmKTnhJQwXSXyMsHmai36EqgV
         whR70D5vwMgziEAeldS/gFy2FkXJpq3lGAk7vGE21LsRxvynsTT5VO/EJS8HAU2v0+W0
         CuDiMLQmaPBzmoX/epWeonDo3FOk0oIRuSsdPBbsKJMR5w6QvNL+wnW1UHV1AL1hRUZ+
         klmRsf77JLf72YaOoecE8A4Pk9DNErTwXVGC6ZFKe0uNhM3uGoeq4AcBf5xqoMS92XTq
         yqt+XryMMwbm+LqcGHFvW/ORj+stJiRPYJuajcrVsBM+dRFAlXXnn9lUYqZH3eQZeZcv
         UU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cAONMTMOUj5WPs7ieoNpxag94xyVtxhJLyFyNTFOxKY=;
        b=T5Kp26U0HopHSD9u6m7iNrbquhgvlQTrkDP0/JembETUIa6kZuw4yfc0MAPjPruIFw
         tlxMdwHNZjxByiGSn0yA0lq+X9V96pLia2i4O55RYX8HvzH8q/wy5gDj042ayqRHo7Nw
         hoUbi75+kQrtCJk8q1qaAbXXQSetxIhoERLBkn+/PMypfQLxP9y3B6GjloUnKYO5kEfv
         HLFHseOSv71hxd1igC/ZPwgnrZivLsHQCip967wB3cNXUmmk+kwiPn+WP9tOQLD+u612
         /1wVfb9jt+r2zl1zmrv9i4Eh4ngQqzAaoiFwutwztRQlw30PzzoIkdU9O//f7RC4kiuL
         O7cw==
X-Gm-Message-State: AOAM532GQ+iM+tLXUPcos7n7RslHcjRWL6ZpGVwLS4lTJkP0oDMfz+Xr
        a8CquvGp52Q9r68QHO8zNvc=
X-Google-Smtp-Source: ABdhPJy9iOhN19TCrxP5LWKoA45SRGJdKYwhu7lIl1WZJb3UWPILCGwLAYzmgg4k95fDIZq33NX9qg==
X-Received: by 2002:a63:ee50:0:b0:3f4:e63c:3f08 with SMTP id n16-20020a63ee50000000b003f4e63c3f08mr1492938pgk.271.1652775124796;
        Tue, 17 May 2022 01:12:04 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id c14-20020a170902c2ce00b0015e8d4eb2easm8336306pla.308.2022.05.17.01.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:12:04 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next v2 4/9] net: inet: add skb drop reason to inet_csk_destroy_sock()
Date:   Tue, 17 May 2022 16:10:03 +0800
Message-Id: <20220517081008.294325-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220517081008.294325-1-imagedong@tencent.com>
References: <20220517081008.294325-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

skb dropping in inet_csk_destroy_sock() seems to be a common case. Add
the new drop reason 'SKB_DROP_REASON_SOCKET_DESTROIED' and apply it to
inet_csk_destroy_sock() to stop confusing users with 'NOT_SPECIFIED'.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h          | 5 +++++
 net/ipv4/inet_connection_sock.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e9659a63961a..3c7b1e9aabbb 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -548,6 +548,10 @@ struct sk_buff;
  *
  * SKB_DROP_REASON_PKT_TOO_BIG
  *	packet size is too big (maybe exceed the MTU)
+ *
+ * SKB_DROP_REASON_SOCKET_DESTROYED
+ *	socket is destroyed and the skb in its receive or send queue
+ *	are all dropped
  */
 #define __DEFINE_SKB_DROP_REASON(FN)	\
 	FN(NOT_SPECIFIED)		\
@@ -614,6 +618,7 @@ struct sk_buff;
 	FN(IP_INADDRERRORS)		\
 	FN(IP_INNOROUTES)		\
 	FN(PKT_TOO_BIG)			\
+	FN(SOCKET_DESTROYED)		\
 	FN(MAX)
 
 /* The reason of skb drop, which is used in kfree_skb_reason().
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1e5b53c2bb26..6775cc8c42e1 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1006,7 +1006,7 @@ void inet_csk_destroy_sock(struct sock *sk)
 
 	sk->sk_prot->destroy(sk);
 
-	sk_stream_kill_queues(sk);
+	sk_stream_kill_queues_reason(sk, SKB_DROP_REASON_SOCKET_DESTROYED);
 
 	xfrm_sk_free_policy(sk);
 
-- 
2.36.1


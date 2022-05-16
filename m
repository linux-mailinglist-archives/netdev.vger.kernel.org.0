Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B020E527C7F
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiEPDqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239769AbiEPDp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:45:59 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986CA35AA4;
        Sun, 15 May 2022 20:45:55 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so13133297pjq.2;
        Sun, 15 May 2022 20:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U7T9ABi/lyv33O2wKAV10AuAP6ZlcwjeiLt7GF6NrYk=;
        b=FoI82rDuePUnrn6bwxpTOv/bPed6Z/cRB2m0EY3b9tDvfIhjSxvvhausJoDd+Wyrep
         BlUvBUE3GLhd0U6uDp2VOS4Cxs4a8iMF9WejSn0tSuUBA+1AnNMYrxbVILXmwI7kunKW
         0+HL6nHdVnAwO6bwQIyL84myXKAy40WIrzyTKpOlUnLwDl+Jgruz1jER+4M8Qd/rBK63
         EvgUqStwKWGbsJ5jMl3NoxAWjIPFn5Q2uGbACOkOZy0c47j0OwNzpkRvqn/FYVf9zt2T
         c7qWvKlgC49+Sq3sopp0ATB5kG3dfHmEQ/JcX7gxahBHO2OqfhdvpnU5CCqdfvw7YfJg
         48MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U7T9ABi/lyv33O2wKAV10AuAP6ZlcwjeiLt7GF6NrYk=;
        b=ucE5R/BBk1UfK6iyAVUkQtSzfhEdR3oESVCIWCq8hLFfAYHz2QoerLoDjW42NykQrt
         gfKGclYxz9cGPgYw24jfuyK2DGs/J4doNZc9HpBdtLT2fwPtUkbiFefR5S0Pc5fIuDYR
         rBMN/MWuNzcw/N0lP6Eaj4vS/5P8gBBfJY7mNYKUpnI5Z9+8YSAg2Fft9RYueTD2AgFQ
         Jd6aUIHuoi99mgvyjKJ9Uhecb/rImTNRTVzJNOeblR4AU12V/KrErtIL4u1CuM31ZSy6
         AdPwr6B94A34uJGCS3l6yD5eitICRE+7kxOVdAUE6640zKhJIuBEdxDkFUIT09coAZ5x
         0lPA==
X-Gm-Message-State: AOAM53327AahgGJD6vLxdHd9b4gdnkNuK5kF0xXovJgWg3SeeSfMlkYb
        1JNF2SF/CIAnlGYsgf20Nho=
X-Google-Smtp-Source: ABdhPJyYty0+X3J2vB0+0Kdy8mmLAStYqkjrhp1zBu1m21gpclyZ9KtBNcQMg99DTspRlG9tld6vgA==
X-Received: by 2002:a17:90a:4417:b0:1ca:a861:3fbf with SMTP id s23-20020a17090a441700b001caa8613fbfmr28686346pjg.80.1652672755125;
        Sun, 15 May 2022 20:45:55 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id x184-20020a6286c1000000b0050dc762819bsm5636854pfd.117.2022.05.15.20.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 20:45:54 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 4/9] net: inet: add skb drop reason to inet_csk_destroy_sock()
Date:   Mon, 16 May 2022 11:45:14 +0800
Message-Id: <20220516034519.184876-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516034519.184876-1-imagedong@tencent.com>
References: <20220516034519.184876-1-imagedong@tencent.com>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD9D53B138
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbiFBBVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiFBBVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:21:20 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE39140424;
        Wed,  1 Jun 2022 18:21:19 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id cv1so2677321qvb.5;
        Wed, 01 Jun 2022 18:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/YIsaXDf0Vla/CpgZ3fY3VVxEFB+BQX409ICdnuhF6U=;
        b=ZihXGbuxNpN6AzRAhkc0kafpiANTkruYdINgdmq/davY/ys00ajR6bejApb036Jvkv
         xGhUaY7LKRYnZAtmucaHCYdATEjgx/ITfPDrDkf19+JHI+6JQ/kLucRgGL8gaKzNFxEr
         2n0IaOJATOt8+OLnAQv1jpQGVGfBUBS3UuEn3Jo8FEVSUSw5gwGh7MYiPfnaiv7cqion
         AZb6bNR5z3Q40jXULjq/pd+5jM06zEWZY6murrjb2LCWAvht+gfeEa9iAkbKl/BQMp+f
         pE5r9SmxLn+3tKPM87f9cEgajCALh0+AEXG9aDom739az0e22Y67lYQIz1lKX7g1gZKt
         rFiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/YIsaXDf0Vla/CpgZ3fY3VVxEFB+BQX409ICdnuhF6U=;
        b=sAaWt/35ePqx58tpxQJAVxijoDclbCgg9YWZElZ0LFybSEs6xJvGwC0gO46l24Tbdz
         wWnJcI4JDFs9+1GIHceT9ysAwrv4Eg4QaF+03B7guBUseg/dDp0P/nG0egE+WNb5jPf1
         YzkLgKBIsTOgSc0Q5LUzzoR1vgFDIA86z4deoHHQfBWKYjBBXHfsNpWHkBo+2iU0B8Iz
         mMLAN4KDi03ujbqDDorDKiWiNZOx+dvnwFgK2nKUefBpM7sN3fQVxCCPDZS5xjBFRzBX
         6tk4MrL9nZ8fveEIqi0abXW8GTNloCYblaCsDhVLuQ6tnev0AHsf1xftb7UIwloy5jy4
         6Cow==
X-Gm-Message-State: AOAM53123rzNZjJ0jE5TTrPLDEJpnj07+vO82AbYFgsMdrbpl3xxGffZ
        X35MUQz4zTw7wAth3CKXc8DdPA7rURg=
X-Google-Smtp-Source: ABdhPJxzuq16EgE98GmaGvX5cKqdqj7tIfPsgQISU8VJRgsM3qhGzAAINd8setCBDJtzw8mYTLxGbw==
X-Received: by 2002:a05:6214:dc3:b0:464:5efe:3d63 with SMTP id 3-20020a0562140dc300b004645efe3d63mr9854639qvt.92.1654132878489;
        Wed, 01 Jun 2022 18:21:18 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:a168:6dba:43b7:3240])
        by smtp.gmail.com with ESMTPSA id x4-20020ac87304000000b002f39b99f670sm2077654qto.10.2022.06.01.18.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 18:21:17 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v3 4/4] skmsg: get rid of unncessary memset()
Date:   Wed,  1 Jun 2022 18:21:05 -0700
Message-Id: <20220602012105.58853-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
References: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
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

We always allocate skmsg with kzalloc(), so there is no need
to call memset(0) on it, the only thing we need from
sk_msg_init() is sg_init_marker(). So introduce a new helper
which is just kzalloc()+sg_init_marker(), this saves an
unncessary memset(0) for skmsg on fast path.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 8b248d289c11..4b297d67edb7 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -497,23 +497,27 @@ bool sk_msg_is_readable(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(sk_msg_is_readable);
 
-static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
-						  struct sk_buff *skb)
+static struct sk_msg *alloc_sk_msg(void)
 {
 	struct sk_msg *msg;
 
-	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
+	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_KERNEL);
+	if (unlikely(!msg))
 		return NULL;
+	sg_init_marker(msg->sg.data, NR_MSG_FRAG_IDS);
+	return msg;
+}
 
-	if (!sk_rmem_schedule(sk, skb, skb->truesize))
+static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
+						  struct sk_buff *skb)
+{
+	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
 		return NULL;
 
-	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_KERNEL);
-	if (unlikely(!msg))
+	if (!sk_rmem_schedule(sk, skb, skb->truesize))
 		return NULL;
 
-	sk_msg_init(msg);
-	return msg;
+	return alloc_sk_msg();
 }
 
 static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
@@ -590,13 +594,12 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb,
 static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb,
 				     u32 off, u32 len)
 {
-	struct sk_msg *msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
+	struct sk_msg *msg = alloc_sk_msg();
 	struct sock *sk = psock->sk;
 	int err;
 
 	if (unlikely(!msg))
 		return -EAGAIN;
-	sk_msg_init(msg);
 	skb_set_owner_r(skb, sk);
 	err = sk_psock_skb_ingress_enqueue(skb, off, len, psock, sk, msg);
 	if (err < 0)
-- 
2.34.1


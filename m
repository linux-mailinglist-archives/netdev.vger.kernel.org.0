Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8EE4FAEC9
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 18:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243540AbiDJQNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 12:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243476AbiDJQNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 12:13:05 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3214831C
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 09:10:54 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-e2afb80550so2887452fac.1
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 09:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xK3D8ISXCcFBiXoJXWBOc3gprGb/nCQ0EaK1U8YPw3Y=;
        b=p3nfMx250sVmKpQD+UFbrUg4qHnQukWo/OzpkqXFRuCwa69pG/1aMboPWquPRYRoMk
         vUY8Zg58gPz5BK7i/krMA6eisxJlT2mjx4Rx9PgZRACkUC2ex3q+I0s4BnlcDrO9ruoU
         fWr9AlGFPESvOlzyfDXg5LVn0jas1WTpSyESY+5m8uuVR0g6JeyAQNkYqZAhR3kxNsQD
         TQLTrSzaGgpJUG5fSWcB95QfeX5cBg5opFMrY9fLEyyHzZBWSmt7jXfCXy9Rbd2Yqotm
         lNGrbV5/0Lzeh1NikQol3YYDhki7qGVaNwkHkf6bPkzJ1668nR5bti11dd4khxIf91ZB
         X4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xK3D8ISXCcFBiXoJXWBOc3gprGb/nCQ0EaK1U8YPw3Y=;
        b=CIdv50gYgJ+xbSQl9ZIK5MMPehMRTUPkBmOQz8kPSvYnVtQSS7CNNLMcO3GmwHhT47
         Uc+zCOmKjB6ktuIHyMy3pH1OwaeFC/ZLq6AdUnvTUyVAABYRZqFy9iFcZi4/3V/Wymrl
         eMOXEgz+lsMGCj7eY3iEr84Kzl8EAUHq1GI7isthjFb8xiXXlLu/juVzwyqsboffOAIP
         Y8QZFoCKenPz29hcKIZKD0xLd+FmpAJG9AWxj1Ld+9xlHMEVrqvU0IUCu5XPKsREcXI5
         zGMqBqcX80RsoyqQwjD+AZ3+nQd1QzYdUdWuO6NGwR4xSToUQZafC2zOQL1fX8DREsu7
         ltsA==
X-Gm-Message-State: AOAM533ECPCWTpHfhlpmDwpE/XbsgKM8QSvmlc15o/i+yiygOlC2eNAx
        kDstDFW73cHDTB9aJZC85AkGaFs/Ht4=
X-Google-Smtp-Source: ABdhPJySFAvPI1aIQ+iTfXvG8vm1NecCuoMPSpA9y6yKJUBPBcYnqcW6kVnpSIMIAS8QTzQhgH4a0g==
X-Received: by 2002:a05:6871:793:b0:db:360c:7f5e with SMTP id o19-20020a056871079300b000db360c7f5emr12239275oap.218.1649607053874;
        Sun, 10 Apr 2022 09:10:53 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:9a32:f478:4bc0:f027])
        by smtp.gmail.com with ESMTPSA id v21-20020a4ade95000000b00320f814c73bsm10550200oou.47.2022.04.10.09.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 09:10:53 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v1 4/4] skmsg: get rid of unncessary memset()
Date:   Sun, 10 Apr 2022 09:10:42 -0700
Message-Id: <20220410161042.183540-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
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
index 7aa37b6287e1..d165d81c1e4a 100644
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
@@ -586,13 +590,12 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb,
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
2.32.0


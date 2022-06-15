Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCAA54CE87
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355005AbiFOQUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbiFOQU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:20:28 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D497DB9F;
        Wed, 15 Jun 2022 09:20:27 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 89so9201359qvc.0;
        Wed, 15 Jun 2022 09:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/YIsaXDf0Vla/CpgZ3fY3VVxEFB+BQX409ICdnuhF6U=;
        b=VWbaQ9TNHrSILW/Tu+SKzxXjIOWED+dR5EueVKPZTQ30IBefsNMY40tGO5VNSIO477
         57QGs/mi21GcgH8t5BzjeCwqdwbhfMcY6QkKsvNKg7EUgXVjliI0bPg2LHkQaaP2J0Ci
         fDN/4M0/m1RA2NbDv1+qgU1ex9QYKCNqv0VmZp5bUPYKVIjNJDg4iOrwwz1JMnhmONM6
         9Sh4i0Vo6eC2YqyrzIGjoaS0duTNg3DHsM7SJ0YYVa4agf3XLaFuZHFlavWC82K2sYS0
         onJJtOH0nqVGKHMVAzamy5YHWCBq8zIhpexyPIhoF6HW2Z1o3ShioxC6OUH4AOL8NhDL
         Qssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/YIsaXDf0Vla/CpgZ3fY3VVxEFB+BQX409ICdnuhF6U=;
        b=8Ob1fvdwW/m3drOoLcSaWUyW7xXB8rNzdo0l0hlGgo8naJCP2uvHgPAgSM95UmGYWZ
         ZZDsIjbiVEp8hUwwSPCX8rAjrL6lcnwsIN8IrPDneueb0IkGCIA9mOYyo7G+aoljLzEE
         Hi6ouCL6LJAdssE2ftRpd5yf3mScvYUwjx6GeRKGjqUFxe5VciXoKF9kDekoRCN6IN9V
         ZchONTZJ0EBrtj7eD3oQZjMFiNVHT3GuU5NsyUKV6t9vIhM8gqmlY3kiv7rENNhdOLFX
         cw5CC5N6BGqhBQE4GYEbHsYAxnE24a5jLpRxd+3dSm6biTY+8ltk1TZOZM/h0QLKPdc/
         rmBA==
X-Gm-Message-State: AJIora8lUWyMvrjV7Hscmas2jqHqmPbRhYQzBl9LUZ9ywRQHycKnwUq5
        g3Z4nYTY2DxZ3Q4Clz7qtY+q0b6Oe84=
X-Google-Smtp-Source: AGRyM1v1bcONI72MGMSCwAE1ONnvO0gHfpciAlt2Y/i7YRF3X9aqNHQq/eYUL8ICwnyxn4UXF1QLJQ==
X-Received: by 2002:a05:6214:509c:b0:467:d42b:3b43 with SMTP id kk28-20020a056214509c00b00467d42b3b43mr492473qvb.19.1655310026654;
        Wed, 15 Jun 2022 09:20:26 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:a62b:b216:9d84:9f87])
        by smtp.gmail.com with ESMTPSA id az7-20020a05620a170700b006a69ee117b6sm11893918qkb.97.2022.06.15.09.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:20:26 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v4 4/4] skmsg: get rid of unncessary memset()
Date:   Wed, 15 Jun 2022 09:20:14 -0700
Message-Id: <20220615162014.89193-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220615162014.89193-1-xiyou.wangcong@gmail.com>
References: <20220615162014.89193-1-xiyou.wangcong@gmail.com>
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


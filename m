Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DE951767D
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386864AbiEBS1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 14:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386860AbiEBS1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:27:36 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0C0A182;
        Mon,  2 May 2022 11:24:04 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-ed9a75c453so4519349fac.11;
        Mon, 02 May 2022 11:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PkoIJtcmp4WksNV5PxPejhCDc2tsgOUS55s91uI+wrs=;
        b=qvKz5DCZZjNBfiE7zHNuuFyXsA2A5a7u6kYw/l+tQiFYjv+LkU3DTOwB+c3dtdXsjC
         Dso3PjHFa+JNtMuUtKNm59DbEu0MBa/2pmgzOliadPsQOiAP6+XYBeXisJ894IKJIz+9
         Ak8AZeX+kxMXWDHKPyE2Cip+uG6t42eEaq04vcu4s47d7xJ10YQbnVECwOQP3UsKV4fw
         N/eY6pvrFR5wy9Zn3Nmdj3kyTsae0i6HbmNYMKw+sJRZsd/vJbV3GMqGPlENK6r8S3ul
         fVT0ElDnvzjhpQ541JZtUgoCCidgC1dGyiJVLo21V4hHd67Rl9X0ak3u3HbpcNvpVJgU
         P1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PkoIJtcmp4WksNV5PxPejhCDc2tsgOUS55s91uI+wrs=;
        b=xM51Yd4nzU0xKgxXVA2dp5WlKEdkhu30JcD/LnXEUEcVjGLFQGcMMwL9K0l5h7H6Sx
         ab6zjYvZzykWfXBml9I+ejpCq07zL0YxXDbSQDbTbGAQG/KRmh2g0DSEjp1uga6+Z/QR
         5u3N1CBT5rheOISVOlgtO4Oj2kBE8C6mjDS4xiSfZnHtEHfie55VJ12dlNSFShTfZqo6
         TpS7f88rH1ZURfMpzemqUHDLFoZ6/v8m8l5qTmqCeUNXaCXztroZYlkEqdfrfAmcDW0C
         J7AfTh0lpz19j4febdsPpJc5KWzU5HHztId3a5AMQ86D4zjW6NXYQ3dl0P5XO84hK7sr
         K9jg==
X-Gm-Message-State: AOAM533LtyXk6x6qMz2+keiCYG4Jec6Az6KuIQpFDfOVeL0MT8omhuge
        9+SlCUMk19ap8OSs1azckX7FYfYaP6I=
X-Google-Smtp-Source: ABdhPJzAbmuiua45HkZfqaHsfVlc8bhY08cu7p8BwEzp2U7+OsUJ4ry725CJXtT2bbc0MiWB6SITJA==
X-Received: by 2002:a05:6870:2103:b0:e9:6d65:4abb with SMTP id f3-20020a056870210300b000e96d654abbmr195411oae.261.1651515843366;
        Mon, 02 May 2022 11:24:03 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:7340:5d9f:8575:d25d])
        by smtp.gmail.com with ESMTPSA id t13-20020a05683014cd00b0060603221245sm3129915otq.21.2022.05.02.11.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 11:24:03 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v2 4/4] skmsg: get rid of unncessary memset()
Date:   Mon,  2 May 2022 11:23:45 -0700
Message-Id: <20220502182345.306970-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220502182345.306970-1-xiyou.wangcong@gmail.com>
References: <20220502182345.306970-1-xiyou.wangcong@gmail.com>
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
index 3ff86d73672c..6dbb735ec94d 100644
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
2.32.0


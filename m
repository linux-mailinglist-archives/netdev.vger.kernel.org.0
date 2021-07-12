Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A0C3C6459
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 21:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbhGLT7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 15:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236686AbhGLT7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 15:59:01 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D457C0613DD;
        Mon, 12 Jul 2021 12:56:09 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id y16so1118339iol.12;
        Mon, 12 Jul 2021 12:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0cpcyWJ2zEX/TjiKs0DRqIAiPNZkNue7/VjGo7bfHvk=;
        b=ZGthQaNgVzHKU1vcY/aTWjuMr/8v44yT549mfft30wXJYAmgX0p3Gqn13SP9IEb+HT
         3FnkFZNEAL7yG1VI/QzKOW83rPWmgZcSwnV8otewq6BO7RfgGOvdMy8QTzAZPDll1NM+
         RFFYZo6hWR1itbeORncCnzoXbwq77VvmYAufj1PmKND1DrZauj5xW6XXdBdn7Lm3mLNa
         5iR3L1qJ55V4Ssm8MNcha/5Wb6+AS7uzhNzDUMhL4xJZ/ydUZKokoYE+nJfisr+L6kWq
         GfwFzGVCDERMk4sgz3oWNUfKOjShCeFY8HEnkKFq7xcKOi0Iw0wqAfHs8F3+QytPlNeh
         mWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0cpcyWJ2zEX/TjiKs0DRqIAiPNZkNue7/VjGo7bfHvk=;
        b=NJsZivW1qlSH9nHwUxMXCm++aTF3KotvskRE5livSA9/cg0QW4L2giO6vybT2LsrLE
         /he3OBAexSdfE0HAUqUeG1p157vBIgzioJ4LLqwyQ0Azhbss2EO9r2FaDBrc/UyaAvnO
         s6vqT5w/zbl6gj/hLHv3rxrJ40qWGOMSYKPfAIVQq+AgTm6u0cK4HNBaEKYvOsRTS7yT
         HtxJEyobVRnh7DLX1KzaawCZkQgsKHs+vKUY1bulwUSQkSR+7bDeINuxwQQ4l7+O+yuC
         hSsgCLmU0/n6lilCrrCE563xcOUQFuJbSKa7Y8LLqYBRJqFNGD9VGcruPa+7FUC33wAM
         ZUgA==
X-Gm-Message-State: AOAM531pHhyUpmFfj5K8JOZRdMKMfkG2p2M6MXM3SFrpr4BcsjMMPZTi
        SbadwCgoG7KVolTzCK8StQw=
X-Google-Smtp-Source: ABdhPJyQ74iNCOb74ZeV7ltve5c3BH1maZHaaaNCE/2y7Nmu41zbs83V9w/wI6TIlmmsyJL7HmMPDQ==
X-Received: by 2002:a02:c95a:: with SMTP id u26mr603377jao.49.1626119768895;
        Mon, 12 Jul 2021 12:56:08 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id l5sm8389210ion.44.2021.07.12.12.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 12:56:08 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, jakub@cloudflare.com, daniel@iogearbox.net,
        andriin@fb.com, xiyou.wangcong@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH bpf v4 1/2] bpf, sockmap: fix potential memory leak on unlikely error case
Date:   Mon, 12 Jul 2021 12:55:45 -0700
Message-Id: <20210712195546.423990-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712195546.423990-1-john.fastabend@gmail.com>
References: <20210712195546.423990-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If skb_linearize is needed and fails we could leak a msg on the error
handling. To fix ensure we kfree the msg block before returning error.
Found during code review.

Fixes: 4363023d2668e ("bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9b6160a191f8..15d71288e741 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -508,10 +508,8 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 	if (skb_linearize(skb))
 		return -EAGAIN;
 	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
-	if (unlikely(num_sge < 0)) {
-		kfree(msg);
+	if (unlikely(num_sge < 0))
 		return num_sge;
-	}
 
 	copied = skb->len;
 	msg->sg.start = 0;
@@ -530,6 +528,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 {
 	struct sock *sk = psock->sk;
 	struct sk_msg *msg;
+	int err;
 
 	/* If we are receiving on the same sock skb->sk is already assigned,
 	 * skip memory accounting and owner transition seeing it already set
@@ -548,7 +547,10 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	 * into user buffers.
 	 */
 	skb_set_owner_r(skb, sk);
-	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	err = sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	if (err < 0)
+		kfree(msg);
+	return err;
 }
 
 /* Puts an skb on the ingress queue of the socket already assigned to the
@@ -559,12 +561,16 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
 {
 	struct sk_msg *msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
 	struct sock *sk = psock->sk;
+	int err;
 
 	if (unlikely(!msg))
 		return -EAGAIN;
 	sk_msg_init(msg);
 	skb_set_owner_r(skb, sk);
-	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	err = sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	if (err < 0)
+		kfree(msg);
+	return err;
 }
 
 static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
-- 
2.25.1


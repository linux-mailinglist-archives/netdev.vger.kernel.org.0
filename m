Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3894A348354
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbhCXVAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238179AbhCXVAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:00:03 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C812C06174A;
        Wed, 24 Mar 2021 14:00:03 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id k8so22987042iop.12;
        Wed, 24 Mar 2021 14:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=JSLvLQ4vIB1tCT7F95RR9CNrrqHl227D5CnKMLZjSuI=;
        b=oQUzeBJCqcqQT26IiwrWHKW9lbKqjMli2q2q40CPOKt5L87bCDvjEP6JvBSt9U9zIz
         +sa9T8y35bSt1pqyj70aZDMDh7loe/wU8/6y6pDMRtcp0yMkn2F+RCKNSJMA+wrjucvq
         FwbAKFrOkwnNg+te85B5xo91VnPTD4pqTGHez6X4fs70pm0IC04ca+jyeRMe2cLSRTP2
         KxhB1EJlsv8W4WNEFlNJAoV45pjESlyIEObNt9xdlTWQ9T2qzBqp6yuFzg7bflzArNQw
         ET+Ts317ry0RX9BBNQXSHkIFje0SKdkqnQDVIhuqrb/v5x42LAU/Z2p4wRKfqw5TBqlB
         D84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JSLvLQ4vIB1tCT7F95RR9CNrrqHl227D5CnKMLZjSuI=;
        b=ZL3Tgs//pN9S/RubIUSMLK1izCS6IauyHqFN8T4IgYQqpFGqFozGpBemGZNeEjJC4y
         PlqeNTQK6X9gMUMUgOFJFfV8slCxVj/qTN8ms1WzLtTIi7E2UQ/ITjmBcnHNBf95bgCN
         iapNzpvWs+3m7jKdLiEQScemulgyi5YCWRgtuQ4sMpcQdw+tamhFoGZmnsMzElPlWsOZ
         5REX0ZPscOQSgGz6dUxa23Lhq+lcJGzOdMy0VQh1JVpYIuf9I2SFrTj1J/GJ0UJJC3Qa
         R1SoWcT/VJjx/LKApQRUww4VLSA95G/GU2qzhCbYDrNAQwcnuIodSHnSSYteWq3zuq5C
         7tqA==
X-Gm-Message-State: AOAM5309ezQ8JrhwshAxjzIIHH3e+zq3cVVdpANyHUq9uya8NKJxWOBq
        AGB551mWMDlQ6yK1BUaOR9g=
X-Google-Smtp-Source: ABdhPJwY62GyJ44fG+G5cOGCvOeIjMrdESV97r1+qL2CIeVnHNd928D1M4iXnUFdTK9K9D5Hlnd9RQ==
X-Received: by 2002:a05:6638:1614:: with SMTP id x20mr4622190jas.19.1616619602834;
        Wed, 24 Mar 2021 14:00:02 -0700 (PDT)
Received: from [127.0.1.1] ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id h12sm1683822ilj.41.2021.03.24.13.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 14:00:02 -0700 (PDT)
Subject: [bpf PATCH 2/2] bpf, sockmap: fix incorrect fwd_alloc accounting
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, andrii@kernel.org, daniel@iogearbox.net,
        ast@fb.com
Cc:     xiyou.wangcong@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lmb@cloudflare.com
Date:   Wed, 24 Mar 2021 13:59:49 -0700
Message-ID: <161661958954.28508.16923012330549206770.stgit@john-Precision-5820-Tower>
In-Reply-To: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
References: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Incorrect accounting fwd_alloc can result in a warning when the socket
is torn down,

 [18455.319240] WARNING: CPU: 0 PID: 24075 at net/core/stream.c:208 sk_stream_kill_queues+0x21f/0x230
 [...]
 [18455.319543] Call Trace:
 [18455.319556]  inet_csk_destroy_sock+0xba/0x1f0
 [18455.319577]  tcp_rcv_state_process+0x1b4e/0x2380
 [18455.319593]  ? lock_downgrade+0x3a0/0x3a0
 [18455.319617]  ? tcp_finish_connect+0x1e0/0x1e0
 [18455.319631]  ? sk_reset_timer+0x15/0x70
 [18455.319646]  ? tcp_schedule_loss_probe+0x1b2/0x240
 [18455.319663]  ? lock_release+0xb2/0x3f0
 [18455.319676]  ? __release_sock+0x8a/0x1b0
 [18455.319690]  ? lock_downgrade+0x3a0/0x3a0
 [18455.319704]  ? lock_release+0x3f0/0x3f0
 [18455.319717]  ? __tcp_close+0x2c6/0x790
 [18455.319736]  ? tcp_v4_do_rcv+0x168/0x370
 [18455.319750]  tcp_v4_do_rcv+0x168/0x370
 [18455.319767]  __release_sock+0xbc/0x1b0
 [18455.319785]  __tcp_close+0x2ee/0x790
 [18455.319805]  tcp_close+0x20/0x80

This currently happens because on redirect case we do skb_set_owner_r()
with the original sock. This increments the fwd_alloc memory accounting
on the original sock. Then on redirect we may push this into the queue
of the psock we are redirecting to. When the skb is flushed from the
queue we give the memory back to the original sock. The problem is if
the original sock is destroyed/closed with skbs on another psocks queue
then the original sock will not have a way to reclaim the memory before
being destroyed. Then above warning will be thrown

  sockA                          sockB

  sk_psock_strp_read()
   sk_psock_verdict_apply()
     -- SK_REDIRECT --
     sk_psock_skb_redirect()
                                skb_queue_tail(psock_other->ingress_skb..)

  sk_close()
   sock_map_unref()
     sk_psock_put()
       sk_psock_drop()
         sk_psock_zap_ingress()

At this point we have torn down our own psock, but have the outstanding
skb in psock_other. Note that SK_PASS doesn't have this problem because
the sk_psock_drop() logic releases the skb, its still associated with
our psock.

To resolve lets only account for sockets on the ingress queue that are
still associated with the current socket. On the redirect case we will
check memory limits per 6fa9201a89898, but will omit fwd_alloc accounting
until skb is actually enqueued. When the skb is sent via skb_send_sock_locked
or received with sk_psock_skb_ingress memory will be claimed on psock_other.

Reported-by: Andrii Nakryiko <andrii@kernel.org>
Fixes: 6fa9201a89898 ("bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 1261512d6807..f150b5b63561 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -488,6 +488,7 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
 	if (unlikely(!msg))
 		return -EAGAIN;
 	sk_msg_init(msg);
+	skb_set_owner_r(skb, sk);
 	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
 }
 
@@ -790,7 +791,6 @@ static void sk_psock_tls_verdict_apply(struct sk_buff *skb, struct sock *sk, int
 {
 	switch (verdict) {
 	case __SK_REDIRECT:
-		skb_set_owner_r(skb, sk);
 		sk_psock_skb_redirect(skb);
 		break;
 	case __SK_PASS:
@@ -808,10 +808,6 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 	rcu_read_lock();
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		/* We skip full set_owner_r here because if we do a SK_PASS
-		 * or SK_DROP we can skip skb memory accounting and use the
-		 * TLS context.
-		 */
 		skb->sk = psock->sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
@@ -880,12 +876,13 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		kfree_skb(skb);
 		goto out;
 	}
-	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
+		skb->sk = psock->sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		skb->sk = NULL;
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
 out:
@@ -956,12 +953,14 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 		kfree_skb(skb);
 		goto out;
 	}
-	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
+		skb_orphan(skb);
+		skb->sk = sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		skb->sk = NULL;
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
 out:


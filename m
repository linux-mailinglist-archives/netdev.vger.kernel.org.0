Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAE32B5457
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbgKPW3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbgKPW3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 17:29:03 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04916C0613CF;
        Mon, 16 Nov 2020 14:29:03 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id i18so17627906ots.0;
        Mon, 16 Nov 2020 14:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=F0jSSl8oQ71zl5T0n2RCWV64rAXKAMsxWQ0W0YaMN9Q=;
        b=s5zV5qH0sGhUupnBT2aeOiheB+gYq0OFhVdvz/2YEXUjpmaTcyn9w+ysN2URDXcSuP
         E2JSOYoVe8XmrA1EKPA/hVi9hB38junKbqT3lW1Up0+AUS780txh7i4tTM2c/edbI6JL
         9A6u+4OXHT2OUw1QY5n5ijqx2uuUKjSVl0hdciraNJV45838OOGto/3RaxNX+BDzXKWQ
         E8QL977OXw3NG0OTs0LoaDRz4TBE3nBo7/43aXqhnS/A99waV1pwE4tNVL0dr64SwBVy
         KpLbraJRYL1sBUVzo4q3Nv/I1OCUgUpZ/aM/AW/ivQZT4khHbt4FPUYgJZUse2GnR91X
         TGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=F0jSSl8oQ71zl5T0n2RCWV64rAXKAMsxWQ0W0YaMN9Q=;
        b=oPCJWUbXXvSQIZB/ZPcZHY5nMNwY0J2AVy7ccjIjKysSryySf1PwSyGSlw77uPgBPk
         ZLG3yZwG+HkGEo3FsbggAImBxvbreaP3pxPi4n8OSrQC3NRX98h3fpg7bR06Hm/knYwF
         LudNZW0+SGqIWBj07AdfqTRGcMC3FXgKiSfD8FlZbait72LZBAfFXu281WATHn5LH5eK
         GkR45aD1kbgrm3oXxXlI4+N3v9Q2KKjQzs9ze4h4erHV3lcWInN7bUjUcYI38dESJa/z
         pdjZ+oV1nQSgh8uTmnL4joAyh898PsjV6nNUSGMBL9Kdt92Il8LAtwKIM6a3wBPSOhJd
         HWRQ==
X-Gm-Message-State: AOAM532+ul9c+m1I/UETDUoXUJ4vGrwbJ3hPHI5BEGQRlMvML4NmG7t5
        5heS0kLJIl7ORqzNiHFUavFoFKZ7Gnxyog==
X-Google-Smtp-Source: ABdhPJxlJJI3ZNd24VcOVpPC+g61OVOPDE3AAaoCHMSO/t7UMssRgRfc2RaTcEICG0g2+hi2NJeuAQ==
X-Received: by 2002:a05:6830:22c9:: with SMTP id q9mr1178422otc.48.1605565742118;
        Mon, 16 Nov 2020 14:29:02 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j6sm5125463ots.32.2020.11.16.14.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 14:29:01 -0800 (PST)
Subject: [bpf PATCH v3 4/6] bpf,
 sockmap: Avoid returning unneeded EAGAIN when redirecting to self
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, ast@kernel.org, daniel@iogearbox.net
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 16 Nov 2020 14:28:46 -0800
Message-ID: <160556572660.73229.12566203819812939627.stgit@john-XPS-13-9370>
In-Reply-To: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
References: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-36-gc01b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a socket redirects to itself and it is under memory pressure it is
possible to get a socket stuck so that recv() returns EAGAIN and the
socket can not advance for some time. This happens because when
redirecting a skb to the same socket we received the skb on we first
check if it is OK to enqueue the skb on the receiving socket by checking
memory limits. But, if the skb is itself the object holding the memory
needed to enqueue the skb we will keep retrying from kernel side
and always fail with EAGAIN. Then userspace will get a recv() EAGAIN
error if there are no skbs in the psock ingress queue. This will continue
until either some skbs get kfree'd causing the memory pressure to
reduce far enough that we can enqueue the pending packet or the
socket is destroyed. In some cases its possible to get a socket
stuck for a noticable amount of time if the socket is only receiving
skbs from sk_skb verdict programs. To reproduce I make the socket
memory limits ridiculously low so sockets are always under memory
pressure. More often though if under memory pressure it looks like
a spurious EAGAIN error on user space side causing userspace to retry
and typically enough has moved on the memory side that it works.

To fix skip memory checks and skb_orphan if receiving on the same
sock as already assigned.

For SK_PASS cases this is easy, its always the same socket so we
can just omit the orphan/set_owner pair.

For backlog cases we need to check skb->sk and decide if the orphan
and set_owner pair are needed.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   72 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 53 insertions(+), 19 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index d09426ce4af3..9aed5a2c7c5b 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -399,38 +399,38 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 }
 EXPORT_SYMBOL_GPL(sk_msg_memcopy_from_iter);
 
-static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
+static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
+						  struct sk_buff *skb)
 {
-	struct sock *sk = psock->sk;
-	int copied = 0, num_sge;
 	struct sk_msg *msg;
 
 	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
-		return -EAGAIN;
+		return NULL;
+
+	if (!sk_rmem_schedule(sk, skb, skb->truesize))
+		return NULL;
 
 	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
 	if (unlikely(!msg))
-		return -EAGAIN;
-	if (!sk_rmem_schedule(sk, skb, skb->truesize)) {
-		kfree(msg);
-		return -EAGAIN;
-	}
+		return NULL;
 
 	sk_msg_init(msg);
-	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
+	return msg;
+}
+
+static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
+					struct sk_psock *psock,
+					struct sock *sk,
+					struct sk_msg *msg)
+{
+	int num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
+	int copied;
+
 	if (unlikely(num_sge < 0)) {
 		kfree(msg);
 		return num_sge;
 	}
 
-	/* This will transition ownership of the data from the socket where
-	 * the BPF program was run initiating the redirect to the socket
-	 * we will eventually receive this data on. The data will be released
-	 * from skb_consume found in __tcp_bpf_recvmsg() after its been copied
-	 * into user buffers.
-	 */
-	skb_set_owner_r(skb, sk);
-
 	copied = skb->len;
 	msg->sg.start = 0;
 	msg->sg.size = copied;
@@ -442,6 +442,40 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	return copied;
 }
 
+static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
+{
+	struct sock *sk = psock->sk;
+	struct sk_msg *msg;
+
+	msg = sk_psock_create_ingress_msg(sk, skb);
+	if (!msg)
+		return -EAGAIN;
+
+	/* This will transition ownership of the data from the socket where
+	 * the BPF program was run initiating the redirect to the socket
+	 * we will eventually receive this data on. The data will be released
+	 * from skb_consume found in __tcp_bpf_recvmsg() after its been copied
+	 * into user buffers.
+	 */
+	skb_set_owner_r(skb, sk);
+	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+}
+
+/* Puts an skb on the ingress queue of the socket already assigned to the
+ * skb. In this case we do not need to check memory limits or skb_set_owner_r
+ * because the skb is already accounted for here.
+ */
+static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb)
+{
+	struct sk_msg *msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
+	struct sock *sk = psock->sk;
+
+	if (unlikely(!msg))
+		return -EAGAIN;
+	sk_msg_init(msg);
+	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+}
+
 static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 			       u32 off, u32 len, bool ingress)
 {
@@ -801,7 +835,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 		 * retrying later from workqueue.
 		 */
 		if (skb_queue_empty(&psock->ingress_skb)) {
-			err = sk_psock_skb_ingress(psock, skb);
+			err = sk_psock_skb_ingress_self(psock, skb);
 		}
 		if (err < 0) {
 			skb_queue_tail(&psock->ingress_skb, skb);



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AB4333559
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhCJFdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhCJFcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 00:32:47 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D8CC061761;
        Tue,  9 Mar 2021 21:32:35 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id 130so15672061qkh.11;
        Tue, 09 Mar 2021 21:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CPLlyzobmDibvol8ZTJ80tV8ELbFVTyX9eFQXacFyC0=;
        b=CRRQgm54vzgKwUeWrPsWyMyxMmrKoaCtwV+H7VIafn7HsryMvxq5t1WNfuUSNC96ch
         wyO8nZYQWai+SFoE/NppSbkHZaLKdF2X+QcSZQ94kA3lh7nzhRtbBicFZQpzqpczlW8g
         CQ4fCjuhaDz23XfKFnu5FJ+dQvfxTBYwcC6CjVpC0d5Z9Bu+lDsGSCnlTXon0nqlw+mY
         lrsoAsJIl4dlucMXfrYosbUvQfULd3Oh/sqipLVr5MAj2bfssGLlsQuX5sfWoz1dl7wb
         G8lpJa3H4MjAEbSFh9FVNUsbqy0G2VqRyQi0SKKO92nmgLQ6+44qP/kBqEJprpVy5erQ
         RDjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CPLlyzobmDibvol8ZTJ80tV8ELbFVTyX9eFQXacFyC0=;
        b=WK4Dhin/+9KOPP5rxO/Zd3EPF0PvW6tbv+DF1ZK/wQZSYqRWXD9ZebbZ35ukLp7qIH
         tVCX1Ia2tDz39Tm13zaC0Owe7NZxIG7zOMzWsFe7QTG3PASdDWrtNNoCHWrQuWQjWNJV
         cvs1JhaZAO77nUAEj59JUriuhRLtQj0bsiPjuVsmXT42yE21es9CFRjtei69xLcfKXmP
         VpZXPxw08lx2ZLTGm3mZgUcjjo98gTTpA1Guoltq4hoDYlCTgOltBWT5FFvqbdRSqLV+
         Qkzx1kFORZtE/1Z7tc5MPAoiB1wMFtM1XoxZZefSNfHBqXkBMdri7hhmaafj+1hZg8Fp
         93wA==
X-Gm-Message-State: AOAM532uuDZ2S9zRb7qj3wW7mWIcg6B75AgU1ISJhZmroYnLcZHyVTNl
        e2DOpimtul8+QR2gY9p810oG/y0qDuWq5g==
X-Google-Smtp-Source: ABdhPJwwcWj+WT6fz349sZQg49UJ3VoyyrI7WF0nwSOXYej+BY6csCohT4UJ2P4QDZSc2/7bOmaiVg==
X-Received: by 2002:a37:5b43:: with SMTP id p64mr1130955qkb.131.1615354354078;
        Tue, 09 Mar 2021 21:32:34 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:91f3:e7ef:7f61:a131])
        by smtp.gmail.com with ESMTPSA id g21sm12118739qkk.72.2021.03.09.21.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 21:32:33 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 03/11] skmsg: introduce skb_send_sock() for sock_map
Date:   Tue,  9 Mar 2021 21:32:14 -0800
Message-Id: <20210310053222.41371-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

We only have skb_send_sock_locked() which requires callers
to use lock_sock(). Introduce a variant skb_send_sock()
which locks on its own, callers do not need to lock it
any more. This will save us from adding a ->sendmsg_locked
for each protocol.

To reuse the code, pass function pointers to __skb_send_sock()
and build skb_send_sock() and skb_send_sock_locked() on top.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skbuff.h |  1 +
 net/core/skbuff.c      | 52 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0503c917d773..2fc8c3657c53 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3626,6 +3626,7 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		    unsigned int flags);
 int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 			 int len);
+int skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset, int len);
 void skb_copy_and_csum_dev(const struct sk_buff *skb, u8 *to);
 unsigned int skb_zerocopy_headlen(const struct sk_buff *from);
 int skb_zerocopy(struct sk_buff *to, struct sk_buff *from,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 545a472273a5..396586bd6ae3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2500,9 +2500,12 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 }
 EXPORT_SYMBOL_GPL(skb_splice_bits);
 
-/* Send skb data on a socket. Socket must be locked. */
-int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
-			 int len)
+typedef int (*sendmsg_func)(struct sock *sk, struct msghdr *msg,
+			    struct kvec *vec, size_t num, size_t size);
+typedef int (*sendpage_func)(struct sock *sk, struct page *page, int offset,
+			   size_t size, int flags);
+static int __skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset,
+			   int len, sendmsg_func sendmsg, sendpage_func sendpage)
 {
 	unsigned int orig_len = len;
 	struct sk_buff *head = skb;
@@ -2522,7 +2525,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 		memset(&msg, 0, sizeof(msg));
 		msg.msg_flags = MSG_DONTWAIT;
 
-		ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
+		ret = sendmsg(sk, &msg, &kv, 1, slen);
 		if (ret <= 0)
 			goto error;
 
@@ -2553,9 +2556,9 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 		slen = min_t(size_t, len, skb_frag_size(frag) - offset);
 
 		while (slen) {
-			ret = kernel_sendpage_locked(sk, skb_frag_page(frag),
-						     skb_frag_off(frag) + offset,
-						     slen, MSG_DONTWAIT);
+			ret = sendpage(sk, skb_frag_page(frag),
+				       skb_frag_off(frag) + offset,
+				       slen, MSG_DONTWAIT);
 			if (ret <= 0)
 				goto error;
 
@@ -2587,8 +2590,43 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 error:
 	return orig_len == len ? ret : orig_len - len;
 }
+
+/* Send skb data on a socket. Socket must be locked. */
+int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
+			 int len)
+{
+	return __skb_send_sock(sk, skb, offset, len, kernel_sendmsg_locked,
+			       kernel_sendpage_locked);
+}
 EXPORT_SYMBOL_GPL(skb_send_sock_locked);
 
+static int sendmsg_unlocked(struct sock *sk, struct msghdr *msg, struct kvec *vec,
+			    size_t num, size_t size)
+{
+	struct socket *sock = sk->sk_socket;
+
+	if (!sock)
+		return -EINVAL;
+	return kernel_sendmsg(sock, msg, vec, num, size);
+}
+
+static int sendpage_unlocked(struct sock *sk, struct page *page, int offset,
+			     size_t size, int flags)
+{
+	struct socket *sock = sk->sk_socket;
+
+	if (!sock)
+		return -EINVAL;
+	return kernel_sendpage(sock, page, offset, size, flags);
+}
+
+/* Send skb data on a socket. Socket must be unlocked. */
+int skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset, int len)
+{
+	return __skb_send_sock(sk, skb, offset, len, sendmsg_unlocked,
+			       sendpage_unlocked);
+}
+
 /**
  *	skb_store_bits - store bits from kernel buffer to skb
  *	@skb: destination buffer
-- 
2.25.1


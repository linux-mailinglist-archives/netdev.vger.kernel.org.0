Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF96345401
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhCWAjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhCWAiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 20:38:21 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B0AC061574;
        Mon, 22 Mar 2021 17:38:21 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id o5so12692633qkb.0;
        Mon, 22 Mar 2021 17:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4vwBCDi/Trp5W1pFSVwRRUUYgEK05t0TKOcvxMF4nzg=;
        b=kvPfZuvbqa7Aywzuh7NmfKMccdrANYB2ikD54sNAqZyN8AamKirn26lvi8CDYZwxfm
         +xFaJfMCI08L7MT8UsFjFMpiKhQuWCJu3xFGxY5qCg11Gns0P/3asBD4IncwrL+xpqps
         Q1P4q8ZHpk0sku/AMpSXiLAQAUDFpvXTpsKVS7MphGWYLO14+b9+ghirLY6NCBxzyW5E
         uhotAZGKI0+Sb8vPpO/BrvC3x8LpTotl0wd5TVJrjDTMNo7/7jLwzua4uIZtzw5VCzDG
         DApxuJEuZmKx8pzksUn4EJFFnkezDq6QrkMUGeyOGG0nobYna3CO4vy4ijhnv15N3b3w
         Iomg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4vwBCDi/Trp5W1pFSVwRRUUYgEK05t0TKOcvxMF4nzg=;
        b=fRdTKNMSKHf+eZPvDkZDNon+0y8LbsGUwtThCSJAFe4TIgLtjkTmS2CRIFJm+yZzKO
         FzIu5Xm5+dBLT64DjJ0ptifPFSng9RR1Qy0plsHt7+otUMCywvlfl5SpYdCEWW2vvQ95
         lx9tvyND2U7Pw+pKf4UGwP61BOcKwe0AcdS9Dcm9peoUkd9dz/bUOkV8MpT3OD1BzDk7
         9CVpv30+YsLjb08wG5O07GIH9AskZuVEo2Bd4AebNzGqEjJ3Yr/2cli+T5UFQbzZOD5J
         w5CTkXJ7WeR51xKkyhYAiUK1GnVpysx2uW+IXbodUvhePSCr+cIVZ46glt9bQhcCPZBD
         GmeQ==
X-Gm-Message-State: AOAM532qwMLz1w/ZAOIr0hjca/8t6AOpeqNytCnsjG6L4bB6hSk6aOwN
        6Z3SjoVXUYvq8AzdUoCiUUkA5qOSIlIBXg==
X-Google-Smtp-Source: ABdhPJxdObfW73HnZZ25yBTUmv0bIE/mIqw3eBWOWgvSftPihUOQ6bW4xRFCejep0v7ubfvzPsSiAw==
X-Received: by 2002:a05:620a:40d:: with SMTP id 13mr2929553qkp.369.1616459900242;
        Mon, 22 Mar 2021 17:38:20 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:fda6:6522:f108:7bd8])
        by smtp.gmail.com with ESMTPSA id 184sm12356403qki.97.2021.03.22.17.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 17:38:19 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v6 03/12] skmsg: introduce skb_send_sock() for sock_map
Date:   Mon, 22 Mar 2021 17:37:59 -0700
Message-Id: <20210323003808.16074-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
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
 net/core/skbuff.c      | 55 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 49 insertions(+), 7 deletions(-)

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
index c421c8f80925..14010c0eec48 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2500,9 +2500,32 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 }
 EXPORT_SYMBOL_GPL(skb_splice_bits);
 
-/* Send skb data on a socket. Socket must be locked. */
-int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
-			 int len)
+static int sendmsg_unlocked(struct sock *sk, struct msghdr *msg,
+			    struct kvec *vec, size_t num, size_t size)
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
+typedef int (*sendmsg_func)(struct sock *sk, struct msghdr *msg,
+			    struct kvec *vec, size_t num, size_t size);
+typedef int (*sendpage_func)(struct sock *sk, struct page *page, int offset,
+			     size_t size, int flags);
+static int __skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset,
+			   int len, sendmsg_func sendmsg, sendpage_func sendpage)
 {
 	unsigned int orig_len = len;
 	struct sk_buff *head = skb;
@@ -2522,7 +2545,8 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 		memset(&msg, 0, sizeof(msg));
 		msg.msg_flags = MSG_DONTWAIT;
 
-		ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
+		ret = INDIRECT_CALL_2(sendmsg, kernel_sendmsg_locked,
+				      sendmsg_unlocked, sk, &msg, &kv, 1, slen);
 		if (ret <= 0)
 			goto error;
 
@@ -2553,9 +2577,11 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 		slen = min_t(size_t, len, skb_frag_size(frag) - offset);
 
 		while (slen) {
-			ret = kernel_sendpage_locked(sk, skb_frag_page(frag),
-						     skb_frag_off(frag) + offset,
-						     slen, MSG_DONTWAIT);
+			ret = INDIRECT_CALL_2(sendpage, kernel_sendpage_locked,
+					      sendpage_unlocked, sk,
+					      skb_frag_page(frag),
+					      skb_frag_off(frag) + offset,
+					      slen, MSG_DONTWAIT);
 			if (ret <= 0)
 				goto error;
 
@@ -2587,8 +2613,23 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
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


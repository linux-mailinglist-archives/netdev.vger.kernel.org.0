Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CA334F6BF
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbhCaCdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbhCaCcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:32:51 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CA2C061574;
        Tue, 30 Mar 2021 19:32:51 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so17606541otn.1;
        Tue, 30 Mar 2021 19:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Wh0mzicKWG1utRZNIevS3oRZH+mXn5JWIkzgtioLig=;
        b=H0z0T66CbU6G1Qbor/GIxdSbaX9Bt+5B9VSgkpdr9sjv3u6Hc7T5Ib6yoBOfSKfVy2
         HuJAfkl1P5I9z+b+NRkUIBcKzHmhLcOZ7lBXCGt1vhHb25wO81nhP+WstT97sd+y9cTt
         JTQfZsxfFHebRk9Y82JyafDLxPizdOIIJnc+6316v8MeN1R9Z5ntNYaaN9KwCGL9JCZr
         XdWGz6EIJv7liJEXdV5tbr2aKpZI3jVXByJnTKwjaVCpIQJJDStPoD14lZAa8zA7KVNJ
         phKCb72UeIjv+KaHl7Kv9oXoMXETvskOy+A1cDJMIxpnItGbipfuL+V2W3S+cceNklUl
         7ksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Wh0mzicKWG1utRZNIevS3oRZH+mXn5JWIkzgtioLig=;
        b=eIL1/FG7snACLfGxptEhYCz8XrHx9sYFwvPyYJhk6qIXyfWDZ2OYqGj8KEzn8UGQjp
         /QCilcBh+XRsz7ve8jFL1iZ5MmNqTi2rQh+cXafFHLIuFWPBySnfw9ATOO8QPr0s4TpJ
         LN+KodpTH81gnj3HUFR+Io6QewGYYkzDimrAzNKrizKC94fktmY6ndqncapHM6O8RvNi
         bKRWezHvPlVEaXosVhxiJrvbXRBfHlwj4xbNMfxEI7R9MbVtD0mFLgpPt1LKqIKkf8Qt
         WjVKu2kXglKnUmFl0BORHRoL0fm3orQa4ROnzhDBQKNw2yvWySH4j6SQHASsnu0Imwey
         /+Ew==
X-Gm-Message-State: AOAM530wo7n/isf7fzbuV9UrZFIsSfRc+kgHtuHOcEyaGiKz+msx357k
        aBAp10p5frYZH5feeRsnmzq1UOu9D0663w==
X-Google-Smtp-Source: ABdhPJzmIdkEvbn6PuxGYdemkk2WpgNtEt8XDmIMlmpgEwJzbLi5u6gL7yWmZQ/HbCnjft12zMJWKg==
X-Received: by 2002:a9d:6296:: with SMTP id x22mr771545otk.196.1617157970720;
        Tue, 30 Mar 2021 19:32:50 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a099:767b:2b62:48df])
        by smtp.gmail.com with ESMTPSA id 7sm188125ois.20.2021.03.30.19.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:32:50 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v8 03/16] net: introduce skb_send_sock() for sock_map
Date:   Tue, 30 Mar 2021 19:32:24 -0700
Message-Id: <20210331023237.41094-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
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
index c8def85fcc22..dbf820a50a39 100644
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
index e8320b5d651a..3ad9e8425ab2 100644
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


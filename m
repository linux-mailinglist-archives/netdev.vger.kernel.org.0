Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA7447C2EA
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbhLUPgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239410AbhLUPf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:35:56 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A7FC061401;
        Tue, 21 Dec 2021 07:35:56 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id e5so27695561wrc.5;
        Tue, 21 Dec 2021 07:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LPkWHJSnV5nNM7itLbmwC1bFPV13/RJSG50oK6FXZpk=;
        b=aP99VNZHpGh/sW7pp/qKJsclA1Fn5ykT6uWK+h4+RjpoU2C5Qdk2J8LD660Y+bzBhN
         LBhqGRyfX20Zur2HNee0txnRfNBFNd7u11PN9t95MuiaqZXvRP/2gjZEL9Qix7+DG7Xw
         dYDo+O8B3XqMQbZpfY565K/0mZzfV9A/93O2VVfGMjYFQDHAkidzMEJYn+pnhfbZmcz4
         lmU8g8fzPrTABKZIT31H/IxBDLXmSyj2UNKLxvr46Oel9Q/kCL+8r3DeVt9eyWW9Nrlx
         JKb/Tx0DCYRReZhM6eNipu4HzKiLRE7lbno6Z54bLe2YNZ4hbjZl7M5C0rLHDCkINbNk
         qL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LPkWHJSnV5nNM7itLbmwC1bFPV13/RJSG50oK6FXZpk=;
        b=3VKfIPsKov8cP1Ex+5jASbNq0am0TBc1L4Z25AZcxjSaoRy522Q/jXb1XKV0I8hdxT
         YJQTJ6LU7vBtyZaFnCf51rtuTzD3Of3m8kKgGpP50MX3OIMiEgP2eDHRFgCTmBtjNoxS
         2zlUu9Cix52Ykm+MB7xInF+3oV7dR0zpR22E2PHr7J6xrvdO03PpbO9biiql+RRu2ty4
         4zBwWOAgIlRrhUwr6Sdhhe3CbdBJU40n5lJpmu+NNQXdI0O1Yje5WhLpdyLwGokw42gP
         MOfLpYW/KKCBMn5BixYtbvrvZenVe5IAbt+yom9RNtfU9y+iI74wiNHr/rLaG2/G5hEm
         TSLw==
X-Gm-Message-State: AOAM533AgRRZzobHrf0r+Zy9ls01lBB51fKvFSyl73PzcUEG3YfkjLuq
        3y7mLvP3IBlz71Lu/SXVrmYK0AMnhxw=
X-Google-Smtp-Source: ABdhPJzhh+SYfefwdTfRXydLxmvAmvewcVnrFwXXe1Aq14C06o7daYcskdkAbxXrxd46+cNI/mJkxg==
X-Received: by 2002:adf:e109:: with SMTP id t9mr2985003wrz.387.1640100955072;
        Tue, 21 Dec 2021 07:35:55 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:35:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 03/19] net: add zerocopy_sg_from_iter for bvec
Date:   Tue, 21 Dec 2021 15:35:25 +0000
Message-Id: <162b7096c1a8e31743b692a229bac0c06a64c75c.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a separate path for bvec iterators in __zerocopy_sg_from_iter, first
it's quite faster but also will be needed to optimise out
get/put_page()

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/datagram.c | 50 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index ee290776c661..cb1e34fbcd44 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -616,11 +616,61 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter);
 
+static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
+				   struct iov_iter *from, size_t length)
+{
+	int ret, frag = skb_shinfo(skb)->nr_frags;
+	struct bvec_iter bi;
+	struct bio_vec v;
+	ssize_t copied = 0;
+	unsigned long truesize = 0;
+
+	bi.bi_size = min(from->count, length);
+	bi.bi_bvec_done = from->iov_offset;
+	bi.bi_idx = 0;
+
+	while (bi.bi_size) {
+		if (frag == MAX_SKB_FRAGS) {
+			ret = -EMSGSIZE;
+			goto out;
+		}
+
+		v = mp_bvec_iter_bvec(from->bvec, bi);
+		copied += v.bv_len;
+		truesize += PAGE_ALIGN(v.bv_len + v.bv_offset);
+		get_page(v.bv_page);
+		skb_fill_page_desc(skb, frag++, v.bv_page, v.bv_offset, v.bv_len);
+		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
+	}
+	ret = 0;
+out:
+	skb->data_len += copied;
+	skb->len += copied;
+	skb->truesize += truesize;
+
+	if (sk && sk->sk_type == SOCK_STREAM) {
+		sk_wmem_queued_add(sk, truesize);
+		if (!skb_zcopy_pure(skb))
+			sk_mem_charge(sk, truesize);
+	} else {
+		refcount_add(truesize, &skb->sk->sk_wmem_alloc);
+	}
+
+	from->bvec += bi.bi_idx;
+	from->nr_segs -= bi.bi_idx;
+	from->count = bi.bi_size;
+	from->iov_offset = bi.bi_bvec_done;
+	return ret;
+}
+
 int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 			    struct iov_iter *from, size_t length)
 {
 	int frag = skb_shinfo(skb)->nr_frags;
 
+	if (iov_iter_is_bvec(from))
+		return __zerocopy_sg_from_bvec(sk, skb, from, length);
+
 	while (length && iov_iter_count(from)) {
 		struct page *pages[MAX_SKB_FRAGS];
 		struct page *last_head = NULL;
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456C64639DC
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239833AbhK3PYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245059AbhK3PX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:27 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C0BC061D61;
        Tue, 30 Nov 2021 07:19:24 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id q3so22359671wru.5;
        Tue, 30 Nov 2021 07:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KlfYKZb+aTjR+IvKXHG7A3YYESuyoklkNiqKi29OkWI=;
        b=d0/AODVs6cUzGRT1t8Q3h7Xa2a+47zb8OdK0dcA1Mws+SXOGZDIK0ebm3/xgilxnBV
         mFQ6JZzgtE+XDVSmtuQ5XpfIOulAQxFaVtoOJBlwkWiwkXy9NUQuccBeZhjfJDiDetyx
         xk0qN3J1aG/svh3a8zcrfJNpzyl4RYOYKduueOAl2TQuBhUAtgBICpF/ml7th7cXCg8i
         qSiGQN1hp+sI98yLA2Ejgo2ObJqFB9UIs/hxRXtnNQOWM+oojiR0NC+GDsMKoZnX72is
         gwcDC7gkmXqkYP9FQM0KA47n9zV7ZbHe413iR1zn4avaSfVmii94aiJxb3nbSRqUi2Wp
         jR9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KlfYKZb+aTjR+IvKXHG7A3YYESuyoklkNiqKi29OkWI=;
        b=MZnzqXjIbDhFQiCCbf5Zbif2FCPcBdeE8QGbJz6RR++qMJlOAhZ4fO93mJrjLe0pxv
         PHZ4+oIualFU5cZMfeFXZJtsV5Ox/E8LOCoK79H1irJPZHGGvnWbt/iTkw2xmFhwhyYk
         fmEsfylyCvgISIopyT2/s6EJShgyEAm/SJBbEicUhlmjlmDXjQcGiXckvaku4nLexGTH
         oNHRV1XmywIphAtcpXPS/OnrEpzcK8zxM9nWl2tuoThXs/iZ1bt90hpXl9p6eaWF36WO
         M0e+i1reGgm11y0wH9e7N/4SRIYVIJxYKgzpd1yXlP1yPL3H8pDYvSaJz5It2+PcpwJu
         HLXg==
X-Gm-Message-State: AOAM533vkItpv8vA+ECaBEuMf1jumw2NhdaxNeyjXt6w3JpKvIYxIkke
        RUZ6CPVO6kq+4Eaai8cCk6vVZSgXaPE=
X-Google-Smtp-Source: ABdhPJytKzsIB1cEIGdNWP9XvNUCtEViQC2jWYiNHm3OYAad0bwR+utoDfjzsCKwzyVgFDTyKzp1rQ==
X-Received: by 2002:adf:fb86:: with SMTP id a6mr41532863wrr.35.1638285562830;
        Tue, 30 Nov 2021 07:19:22 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC 04/12] net: add zerocopy_sg_from_iter for bvec
Date:   Tue, 30 Nov 2021 15:18:52 +0000
Message-Id: <0ee5fc538d3badecb15d7e33fd8e204328d54776.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
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
 net/core/datagram.c | 54 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index ee290776c661..e00f7e0a7a0a 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -616,11 +616,65 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
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
+		/*
+		 * TODO: ignore compound pages for now, all bvec from io_uring
+		 * are within boundaries of a single page.
+		 */
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
2.34.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5B755ED36
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbiF1TAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbiF1TAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:23 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E65BDF5B;
        Tue, 28 Jun 2022 11:59:59 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id e40so18931024eda.2;
        Tue, 28 Jun 2022 11:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mNAl7aHtaBa/r+OrmETRXcPT/IbWKen65cbhqfyTMuk=;
        b=XzGizqos91CZ9HG5E3teB1nM0p5c7P2MErQhLJ8zGkP2eOQmvAmUunoTYuOetkQ62u
         w924Z+ChBUqErhBkJR1TBK3i2PhiqeDLtnN3ynk7AJxNPWIo84QYgUROay5gWXjlNGit
         DLBDrNJj29XtDocUxRtEY9+LLBzdfxfs0Pxx89KSjGfjjPiKNpq8EiaVQV+r/MvxGMxx
         d5mIybokNy+uat9yBdbYYIhPz0QrCUb8cyJDW1FqMHbQ/51egrIUL25WMTTtb1CLB3/o
         w7x6a/+sgSZSu0Fwx2qU5Z26j6AshHGYiRWxrBMm+Rf2zBDaxc3JB3RNQ9g/20jVQbsm
         sQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mNAl7aHtaBa/r+OrmETRXcPT/IbWKen65cbhqfyTMuk=;
        b=nvv30mqo6HepTc/8Uj4KCWnS9+ZCRfhz79n2UztOIQGKgk/FEX/XrOk+2oTMbeKhPP
         F9aMTnHEq0+dZ4xDlugyRyiXqZ6ok6jsjbFRN0MRw8AxQvwvCQpWa/uzExZNq44luxb0
         8YPcM7OeLtZivtqOhOEhcwDnRorCoiukaYtfNV12WujkpogCO+cGfqck9wWFJOUcj3x0
         8EdcUQndVjADYtm2CSvHoj2Ki5vmFC6Zd5tOYB6d7drnP87UI9Wy5ptW2a0U4/Rzm9Uu
         QPpEWmrHGjcK/GDR3z3+oHK3TTgzsH8glzO36MzjSsiZRV1LUlIdPM7HSNd+1UnlzoBc
         EXIA==
X-Gm-Message-State: AJIora+gCiAO1diPGvoEdj3CfC2T+ary6Mnnc/EvNNuCvKOW/r67UbVU
        p7D0vI2Y2EXf/TcLnexK0xLM7gaJKlIqGQ==
X-Google-Smtp-Source: AGRyM1ur8kgCpV+3tyFwUj7TgowpM1DSKOSUF/XBNgpKQ89Sb0McR6iQywly0THS8KpazclC+9QQWw==
X-Received: by 2002:a05:6402:448c:b0:435:9dcc:b8a5 with SMTP id er12-20020a056402448c00b004359dccb8a5mr24677698edb.287.1656442798496;
        Tue, 28 Jun 2022 11:59:58 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.11.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:59:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 05/29] net: bvec specific path in zerocopy_sg_from_iter
Date:   Tue, 28 Jun 2022 19:56:27 +0100
Message-Id: <5143111391e771dc97237e2a5e6a74223ef8f15f.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
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

Add an bvec specialised and optimised path in zerocopy_sg_from_iter.
It'll be used later for {get,put}_page() optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/datagram.c | 47 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 50f4faeea76c..5237cb533bb4 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -613,11 +613,58 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter);
 
+static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
+				   struct iov_iter *from, size_t length)
+{
+	int frag = skb_shinfo(skb)->nr_frags;
+	int ret = 0;
+	struct bvec_iter bi;
+	ssize_t copied = 0;
+	unsigned long truesize = 0;
+
+	bi.bi_size = min(from->count, length);
+	bi.bi_bvec_done = from->iov_offset;
+	bi.bi_idx = 0;
+
+	while (bi.bi_size && frag < MAX_SKB_FRAGS) {
+		struct bio_vec v = mp_bvec_iter_bvec(from->bvec, bi);
+
+		copied += v.bv_len;
+		truesize += PAGE_ALIGN(v.bv_len + v.bv_offset);
+		get_page(v.bv_page);
+		skb_fill_page_desc(skb, frag++, v.bv_page, v.bv_offset, v.bv_len);
+		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
+	}
+	if (bi.bi_size)
+		ret = -EMSGSIZE;
+
+	from->bvec += bi.bi_idx;
+	from->nr_segs -= bi.bi_idx;
+	from->count = bi.bi_size;
+	from->iov_offset = bi.bi_bvec_done;
+
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
2.36.1


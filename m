Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674724A8B1E
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353074AbiBCSCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351171AbiBCSCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:02:35 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF23C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 10:02:35 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id e6so2862695pfc.7
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 10:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eL+8oISp3UUovVG0G0fFzQhSpOOQI5O7U5239Fla59g=;
        b=Dpgz7xWgldSnJ4usZ0xE9RNxb/E+YTXVMgOxQUzjB0mDQXTFcWo3N5GAqW/jJkLuhj
         8AAtCtJ5oo2tMBL0iNCWyeEZwXmstOpgkF60kodqlbAWqw/AkFiZrEweEmVzKb57zdNw
         gJmGfwNx636iiGCc+pRkMquwxMD3YhWymoR7UGtnakNYSG1pGrgOgdxCkBFlgTNeMi0P
         y52Ct2zX52LtNYW6mWmUlPmf8e2i1dSTGeuTh/kjR0mQ1VnpIPFZU6SJWxXFJlZDuldR
         ZphJHondAMwpxFqLMh+MJ/u4lfVtfWtJKwtGpgR3OO7vcZRF95VlGp2+7PrTtWr1I0xs
         cEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eL+8oISp3UUovVG0G0fFzQhSpOOQI5O7U5239Fla59g=;
        b=M4ytov+fDvRzjIzSgnykz3fHtRsum+hKrsGefQ1vSGrEFeNuhSOORUVgJ677xFku+X
         J8lNLfQg4laoRNp/YtXcDb78/0AXifMvJWI1/Gs8MtMfJ9jUREsVMxzWyXEu3vfOK6zm
         Onk2U/I2yFrKS7FjB+u20W/7G3sZggPFbQt5zeSMTuXgxxLxnbRKQeFhTt4TlVArg1rA
         2VI1i4A35Dxw/+fIBFrGgQSW9BoyV3iOzI+tQOxeIRk6d12aF53CLGqBF8pmVETJzN4m
         K4itBRqP9N9kFmXBc/3n/voimh0Jg5W/7vJJ0xsDWeUoDEHi/u2sbDiFFCPR3JgKwvYC
         D5zA==
X-Gm-Message-State: AOAM533UadKua3cV3x0KH2Kqhd1g27crWN6z+eXTNMdAxtqqfKSRuHKF
        5Nny44puW+Mje0On1LIT7XA=
X-Google-Smtp-Source: ABdhPJxA370cTulfvwEizvh4APL10GqI928qF6Nf4vwRlBpJK3vVsADzRSzE+XwNwk4Pgh8BwFApEw==
X-Received: by 2002:a62:5383:: with SMTP id h125mr34952010pfb.30.1643911354789;
        Thu, 03 Feb 2022 10:02:34 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b3be:296f:182e:18d5])
        by smtp.gmail.com with ESMTPSA id ms14sm10702487pjb.15.2022.02.03.10.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 10:02:34 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/2] skmsg: convert struct sk_msg_sg::copy to a bitmap
Date:   Thu,  3 Feb 2022 10:02:27 -0800
Message-Id: <20220203180227.3751784-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220203180227.3751784-1-eric.dumazet@gmail.com>
References: <20220203180227.3751784-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We have plans for increasing MAX_SKB_FRAGS, but sk_msg_sg::copy
is currently an unsigned long, limiting MAX_SKB_FRAGS to 30 on 32bit arches.

Convert it to a bitmap, as Jakub suggested.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skmsg.h | 11 +++++------
 net/core/filter.c     |  4 ++--
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 18a717fe62eb049758bc1502da97365cf7587ffd..1ff68a88c58de0dc30a50fd030b49ea55a6c2cb9 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -29,7 +29,7 @@ struct sk_msg_sg {
 	u32				end;
 	u32				size;
 	u32				copybreak;
-	unsigned long			copy;
+	DECLARE_BITMAP(copy, MAX_MSG_FRAGS + 2);
 	/* The extra two elements:
 	 * 1) used for chaining the front and sections when the list becomes
 	 *    partitioned (e.g. end < start). The crypto APIs require the
@@ -38,7 +38,6 @@ struct sk_msg_sg {
 	 */
 	struct scatterlist		data[MAX_MSG_FRAGS + 2];
 };
-static_assert(BITS_PER_LONG >= NR_MSG_FRAG_IDS);
 
 /* UAPI in filter.c depends on struct sk_msg_sg being first element. */
 struct sk_msg {
@@ -234,7 +233,7 @@ static inline void sk_msg_compute_data_pointers(struct sk_msg *msg)
 {
 	struct scatterlist *sge = sk_msg_elem(msg, msg->sg.start);
 
-	if (test_bit(msg->sg.start, &msg->sg.copy)) {
+	if (test_bit(msg->sg.start, msg->sg.copy)) {
 		msg->data = NULL;
 		msg->data_end = NULL;
 	} else {
@@ -253,7 +252,7 @@ static inline void sk_msg_page_add(struct sk_msg *msg, struct page *page,
 	sg_set_page(sge, page, len, offset);
 	sg_unmark_end(sge);
 
-	__set_bit(msg->sg.end, &msg->sg.copy);
+	__set_bit(msg->sg.end, msg->sg.copy);
 	msg->sg.size += len;
 	sk_msg_iter_next(msg, end);
 }
@@ -262,9 +261,9 @@ static inline void sk_msg_sg_copy(struct sk_msg *msg, u32 i, bool copy_state)
 {
 	do {
 		if (copy_state)
-			__set_bit(i, &msg->sg.copy);
+			__set_bit(i, msg->sg.copy);
 		else
-			__clear_bit(i, &msg->sg.copy);
+			__clear_bit(i, msg->sg.copy);
 		sk_msg_iter_var_next(i);
 		if (i == msg->sg.end)
 			break;
diff --git a/net/core/filter.c b/net/core/filter.c
index 9615ae1ab530a9735e3d862b1ddf12b1b1f55060..f497ca7a16d223855004876e3a868d5de8cea879 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2603,7 +2603,7 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_msg *, msg, u32, start,
 	 * account for the headroom.
 	 */
 	bytes_sg_total = start - offset + bytes;
-	if (!test_bit(i, &msg->sg.copy) && bytes_sg_total <= len)
+	if (!test_bit(i, msg->sg.copy) && bytes_sg_total <= len)
 		goto out;
 
 	/* At this point we need to linearize multiple scatterlist
@@ -2809,7 +2809,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 	/* Place newly allocated data buffer */
 	sk_mem_charge(msg->sk, len);
 	msg->sg.size += len;
-	__clear_bit(new, &msg->sg.copy);
+	__clear_bit(new, msg->sg.copy);
 	sg_set_page(&msg->sg.data[new], page, len + copy, 0);
 	if (rsge.length) {
 		get_page(sg_page(&rsge));
-- 
2.35.0.263.gb82422642f-goog


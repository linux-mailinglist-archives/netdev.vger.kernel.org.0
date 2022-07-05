Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635ED5671C6
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiGEPB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiGEPBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:01:52 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF2E14D09;
        Tue,  5 Jul 2022 08:01:51 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d16so11643847wrv.10;
        Tue, 05 Jul 2022 08:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dYMbDXosaDJGTx1SMZg80SJyMd9PTOfSaObug9b0vzk=;
        b=VWeBvDFkh8D1weqwYdfH5YUawupmI1QffjEzGgjikGvcZsNdfamf0C+moIPPct2Zub
         Wu+3Xx1SAcx0YIabChzSZwiufgpVm6Cz4VaEQ8fPbZGhQc7kxZLRVDvygy6+5mVc2Hil
         yJSR4Fss2zO+bG7+2inBPr+dfDedhNJuzdXa7wnC9C6OudDyZe+BcK5Zw3e/7ME/c0Ko
         qcJ4S6d/YJxLhGZhk0W00Jp0ZlYZJ1WJgimHFRxNPoynDJSv8PfrKPlN9WmlD4P+G/8R
         KDgDbWgzPoox+AWJCtYkgMNAKVnD7tD2IS9FeIIYHNqCAmPtSWZljWXSzO4B7nbLuk5s
         bh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dYMbDXosaDJGTx1SMZg80SJyMd9PTOfSaObug9b0vzk=;
        b=zA7msRd5iqkqp9OUDVseodN+4GOSBNxcIN+Ll0beURgPUgnIxyMquNKmvfjDr6e6ZP
         C+jaPlkjTSACGMJCWiRqoi/oxDCwx1Ik7jFuiXoNqnrRaXlmuH3ZF1q6o8xDfi6w/Rq6
         QZ5JK1X/1CkwZ3+m2wVSPfBsik9uwMaOU7b5g1VROLE5QgxjygGn12wNHmP1Et4BcW9h
         FWFtb9hocTl7amJu+2ziJTcCuaVNL/sNdDE2LD3VfrgdF+QCcOnkAnLs9r4JSg9vLamf
         5SPse0yfpJdR2qzszIXR87gtMGxzs4A06lPdLmm42tjUJQx2p0yjiv1sFB2otKgHSjDk
         Z9Xw==
X-Gm-Message-State: AJIora8vuLgxsFHiMUN3omgctvW2A00vboAAvw27merXQFmDZp3sW7pj
        96SF73MBIkWx0V5P4YIVIyns2y7m4VF+4w==
X-Google-Smtp-Source: AGRyM1u7XTJA2ZWJMYR5RZUMlys8inmCplPmx8n7EZMFT7CpQGQ9PzI/WJ9d8GEc4zwiNwuLWR6beA==
X-Received: by 2002:adf:e691:0:b0:21d:416f:8d16 with SMTP id r17-20020adfe691000000b0021d416f8d16mr25643433wrm.338.1657033309417;
        Tue, 05 Jul 2022 08:01:49 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:01:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 02/25] ipv6: avoid partial copy for zc
Date:   Tue,  5 Jul 2022 16:01:02 +0100
Message-Id: <23994117821e178dd0835d19016bea14b4296f40.1656318994.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656318994.git.asml.silence@gmail.com>
References: <cover.1656318994.git.asml.silence@gmail.com>
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

Even when zerocopy transmission is requested and possible,
__ip_append_data() will still copy a small chunk of data just because it
allocated some extra linear space (e.g. 128 bytes). It wastes CPU cycles
on copy and iter manipulations and also misalignes potentially aligned
data. Avoid such coies. And as a bonus we can allocate smaller skb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 77e3f5970ce4..fc74ce3ed8cc 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1464,6 +1464,7 @@ static int __ip6_append_data(struct sock *sk,
 	int copy;
 	int err;
 	int offset = 0;
+	bool zc = false;
 	u32 tskey = 0;
 	struct rt6_info *rt = (struct rt6_info *)cork->dst;
 	struct ipv6_txoptions *opt = v6_cork->opt;
@@ -1549,6 +1550,7 @@ static int __ip6_append_data(struct sock *sk,
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
+			zc = true;
 		} else {
 			uarg->zerocopy = 0;
 			skb_zcopy_set(skb, uarg, &extra_uref);
@@ -1630,9 +1632,12 @@ static int __ip6_append_data(struct sock *sk,
 				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
 				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
-			else {
+			else if (!zc) {
 				alloclen = min_t(int, fraglen, MAX_HEADER);
 				pagedlen = fraglen - alloclen;
+			} else {
+				alloclen = fragheaderlen + transhdrlen;
+				pagedlen = datalen - transhdrlen;
 			}
 			alloclen += alloc_extra;
 
-- 
2.36.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F335131FA
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiD1LCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345130AbiD1LBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:01:48 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B0297BAE;
        Thu, 28 Apr 2022 03:58:20 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id e2so6233917wrh.7;
        Thu, 28 Apr 2022 03:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fa5CdWViNrG/NjYoLUNxCAqmUWuGkC4f1gVdrOT2E9U=;
        b=XqghPo0bq+NQDMVeKYC7+bEpFnjXtq0XdJfAUWlpji2R6OLKU4zV1XXMkw1InubOoP
         tBOXhI4/hmaqk5VX+EMgNJT5mXqzxT7YLcovwRrI7OJLqFEyMMLYqe1eZLVMwx5R9QiR
         f1xhD47AbD//c2DZJ7P64+0Q/Xv2UB4RonOX8VAJwM41GbogMZZw0pnzpI2j12NS9IGH
         veaOplXIr5eM/lnbBw3xaG4UrBJjvczUr5Ab0F/axGEszLbZK7TVAo1DDm00bMSONb2Z
         4vDLCYk8RSX8k8geeopyk5auajhu7GXBEinIY4VCezF2zrW/LV15ZPcIRFELgI/FNdrZ
         dQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fa5CdWViNrG/NjYoLUNxCAqmUWuGkC4f1gVdrOT2E9U=;
        b=2FlT7Nm1vsfmqRo6CAJ0nMdthDaBYERMS9UEEJkA2h9rP8NpCQkj9WvcVXleDqub5b
         fXO4ryGCM7I7RfScE36pZx8bQKZltUSwcISRhWjPqke8NWP5GU/7Ju5xOMMO9spIpxJZ
         OGXzDsdTSYLUg0LqzwMbk4YoSkdr5PP4QcKoxWc1h9oThAnQ8iLsYb70Sd3FVT4LLyDp
         1n52506OboMZMF4rqFyS5XmPCY4N8IncJGncblFYmNG7J0Fu4QzboYySzgv6jKOdcLKJ
         FIXklXghDc9hC8X5hwdi9/f9tNcHuzv4DkrGHMe+MdBFpyF4suUGE8n34gLoDzNLisKl
         rQVQ==
X-Gm-Message-State: AOAM531exYlCp2NxZGMmPATiEphR2X2deLUwMOEtf0aivHlF+4mNdM/2
        lc+FyulAL94tz6yT2DbiHIgdPMsGZqg=
X-Google-Smtp-Source: ABdhPJxBaDUDJPVYqAVvTWOhzLh/1XCzMSyHV4cbJXze/SUe21/NorNGmow7sAPP/jaqmaRrfkl/iQ==
X-Received: by 2002:a5d:5966:0:b0:20a:e810:5e9d with SMTP id e38-20020a5d5966000000b0020ae8105e9dmr9401074wri.240.1651143499234;
        Thu, 28 Apr 2022 03:58:19 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id u19-20020a05600c19d300b00393f081d49fsm4017426wmq.2.2022.04.28.03.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:58:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 1/1] tcp: optimise skb_zerocopy_iter_stream()
Date:   Thu, 28 Apr 2022 11:57:46 +0100
Message-Id: <a7e1690c00c5dfe700c30eb9a8a81ec59f6545dd.1650884401.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's expensive to make a copy of 40B struct iov_iter to the point it
was taking 0.2-0.5% of all cycles in my tests. iov_iter_revert() should
be fine as it's a simple case without nested reverts/truncates.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

split from a larger patchset, see
https://lore.kernel.org/netdev/cover.1648981570.git.asml.silence@gmail.com/

 net/core/skbuff.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 30b523fa4ad2..e51e53f8c200 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1350,7 +1350,6 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct ubuf_info *uarg)
 {
 	struct ubuf_info *orig_uarg = skb_zcopy(skb);
-	struct iov_iter orig_iter = msg->msg_iter;
 	int err, orig_len = skb->len;
 
 	/* An skb can only point to one uarg. This edge case happens when
@@ -1364,7 +1363,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 		struct sock *save_sk = skb->sk;
 
 		/* Streams do not free skb on error. Reset to prev state. */
-		msg->msg_iter = orig_iter;
+		iov_iter_revert(&msg->msg_iter, skb->len - orig_len);
 		skb->sk = sk;
 		___pskb_trim(skb, orig_len);
 		skb->sk = save_sk;
-- 
2.36.0


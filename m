Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568504F099C
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358517AbiDCNKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358720AbiDCNK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:29 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB8B20187
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:31 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d29so4585029wra.10
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1AwOsomC8j1IsP+7LcAos7c47K6Vxss+ztTv0W2ukEs=;
        b=LEJfInosH44bRW+Psi+gmdL8Kuypuqiv7y9sjofNwnTfwUD43P3DB5PAHgA2iTYVtY
         9kmsMSYhwY3bV9XQDyT5HAi4sw1cdPUnMoAx9O51h5+x9e39ILSpZXo81mPfWQfTB/no
         rBxgVU4EdPqYtoGGcJzC3w51EEO6z86vFZ+7ARWw2i7001uhv4yz1NG2/t9qXX5+oxeE
         m2n3AO1z6uNe7HvROj57sLTeEIFxK2THnLxxgQIESRbQEz5J08qR9WeZkBK6UL35rDf6
         rN/NmAWAhHUuePMY7MyOgbtvIXEfAFENmR8cyAyB6aQoax7bh/7R9vARn1ewLVWYt75I
         b9EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1AwOsomC8j1IsP+7LcAos7c47K6Vxss+ztTv0W2ukEs=;
        b=yXUswIy6arzEQxoC7suN+yxaUzYXjx74hjBLUke4PnSzw3+7dNjAGJQgdu29MOTTY4
         ZkGxQd2H9pnHz0Wq1Kw+KuDuLeQ2XQvlmpNPM88FiXZfUdjIaDW1BP5cF+Fc845B2+PB
         BxIUWhbHqNW7CAmk43tmiDCrI77ho+B+kFv9mXAV8L27AgOFGQRh37h2xSaa88uwegYn
         xGJOXsZwsC2rb8AVzjjMM0CwpA88Z+IES44jByiB9np3EagY6u/PaAh1aRI+s60DlTj1
         zPaZL3GV65VvR2F3legkJwzVusz0GHVjihdtf6+OCZNvkrw4uMG44ggPNlmX2xiEYsnH
         VvTA==
X-Gm-Message-State: AOAM533MHCp8csChHoG1eEq1VLbHET0yekX/yd95osmfmYd0U5BbuxtT
        OZzT+fr+mCuOZ5LcmOXM9WelnIFXCIQ=
X-Google-Smtp-Source: ABdhPJxRX29YlrO0ForaTa48S5g6oGm4F6yQuWQCjytBMPZ4UXlX7Go980LuDFk78v79L2CQu/WUeA==
X-Received: by 2002:a5d:6c66:0:b0:204:1175:691c with SMTP id r6-20020a5d6c66000000b002041175691cmr14213620wrz.328.1648991310427;
        Sun, 03 Apr 2022 06:08:30 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 17/27] tcp: optimise skb_zerocopy_iter_stream()
Date:   Sun,  3 Apr 2022 14:06:29 +0100
Message-Id: <0c14446e83b09759c08d9ab12b747e80508de74b.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
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

It's expensive to make a copy of 40B struct iov_iter to the point it
was taking 0.2-0.5% of all cycles in my tests. iov_iter_revert() should
be fine as it's a simple case without nested reverts/truncates.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/skbuff.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 65ac779eb5cd..77cbdb02e885 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1343,7 +1343,6 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct msghdr *msg, int len,
 			     struct ubuf_info *uarg)
 {
-	struct iov_iter orig_iter = msg->msg_iter;
 	int err, orig_len = skb->len;
 
 	/* An skb can only point to one uarg. This edge case happens when
@@ -1357,7 +1356,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 		struct sock *save_sk = skb->sk;
 
 		/* Streams do not free skb on error. Reset to prev state. */
-		msg->msg_iter = orig_iter;
+		iov_iter_revert(&msg->msg_iter, skb->len - orig_len);
 		skb->sk = sk;
 		___pskb_trim(skb, orig_len);
 		skb->sk = save_sk;
-- 
2.35.1


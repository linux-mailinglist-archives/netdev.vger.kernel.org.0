Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64AF754F4DA
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbiFQKGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381515AbiFQKGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:06:00 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE3569B55;
        Fri, 17 Jun 2022 03:06:00 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y196so3771722pfb.6;
        Fri, 17 Jun 2022 03:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OJ5yUeHxRXLRRzyu6F8edZ4SeRLkQ7Rllpb1jK/oYWI=;
        b=UrF55YHxLMU6QHm6J8TLYPtEfIkqwfe0O8uamlTEz5NszzYX682VTp/aQpuQ5d+kKF
         RQblj0WjdLLLK1i/wk6dN/VBp9s5zimfIEggJIxUCu1ltlMpIGqeCXzrdrO+m5GmOa95
         sqY8dlQBxn1Chgv6O42Kws6H0+Q41OpO84GP/E+ssxsxD3QnkIX9r7yBpiD7iBC3LhY9
         sLI+rhrXY2+zvIIiJzQn09YCxe4HcuGkpytKAUIXW4UO1z76+yOypv72pLg7VswUkVFe
         nhm91kGCHHvMuuxdj/TLyHrixdIQ1lPVCsa8An97nDHD24T01lbmTnFBUwD+3DUC6y8B
         UHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OJ5yUeHxRXLRRzyu6F8edZ4SeRLkQ7Rllpb1jK/oYWI=;
        b=aDMVFXb+zuk9rO9lUwaTJxvLSmlXU4uFYoLssfX6wJeVdj1YsKIh+CWWCwlRHfrclX
         /KarWw8G2XbleoDqgutPARO81xGvjrGdXmuOTWdBDHu3nTd/meJoGHZT73spSabTDx8N
         3t5lTQZJ8kbaiELjuIBWGnxLp3KEEMFKMkOXCFCwrEMe2ZskD9VW5YjdqnQn38k676/r
         rKf5bG1D74n0WuWUdy9uXaiMgfQESsA8Z1fuFgg5/SmOedxWQDeY/jLHiCI+TJMJfIMR
         VOzbgcu3XTgP6zaCOlhieZNnoSDnVDBPHm1/+RF1IZFUdAg0Wcl2PIvVUvliiGZsV1Uz
         PXiA==
X-Gm-Message-State: AJIora+PeLu1R11qujYjatQgVvtJl3f9nRzzRJprsNBtxgopcYNXBjXu
        2UxcgsutI9O4Yk8KA7ql3A8=
X-Google-Smtp-Source: AGRyM1tSIKhlmAce4fjeM+Fqrme9x3Y81iFgvbv4cpKUyD1VLVf+kDX7l32ibcOcMmod7cwLTyUpvQ==
X-Received: by 2002:a05:6a00:23c2:b0:51b:c431:65bf with SMTP id g2-20020a056a0023c200b0051bc43165bfmr9371074pfc.20.1655460359870;
        Fri, 17 Jun 2022 03:05:59 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.10])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f7ca00b001621ce92196sm3126210plw.86.2022.06.17.03.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:05:59 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v4 1/8] net: skb: use SKB_NOT_DROPPED in kfree_skb_reason() as consume_skb()
Date:   Fri, 17 Jun 2022 18:05:07 +0800
Message-Id: <20220617100514.7230-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220617100514.7230-1-imagedong@tencent.com>
References: <20220617100514.7230-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

Inorder to simply the code, allow SKB_NOT_DROPPED to be passed to
kfree_skb_reason(), suggested by Eric. Therefore, consume_skb(skb) can
be replaced with kfree_skb_reason(skb, SKB_NOT_DROPPED).

Not sure if it is suitable to make consume_skb() a simple call to
kfree_skb_reason(skb, SKB_NOT_DROPPED), as this can increase the
function call chain.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/core/skbuff.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b661040c100e..92f01b59ae40 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -769,15 +769,22 @@ EXPORT_SYMBOL(__kfree_skb);
  *	Drop a reference to the buffer and free it if the usage count has
  *	hit zero. Meanwhile, pass the drop reason to 'kfree_skb'
  *	tracepoint.
+ *
+ *	When the reason is SKB_NOT_DROPPED, it means that the packet is
+ *	freed normally, and the event 'consume_skb' will be triggered.
  */
 void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 {
 	if (!skb_unref(skb))
 		return;
 
-	DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
+	DEBUG_NET_WARN_ON_ONCE(reason < 0 || reason >= SKB_DROP_REASON_MAX);
+
+	if (reason)
+		trace_kfree_skb(skb, __builtin_return_address(0), reason);
+	else
+		trace_consume_skb(skb);
 
-	trace_kfree_skb(skb, __builtin_return_address(0), reason);
 	__kfree_skb(skb);
 }
 EXPORT_SYMBOL(kfree_skb_reason);
-- 
2.36.1


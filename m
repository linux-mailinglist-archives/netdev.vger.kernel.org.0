Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E1F53BC52
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbiFBQTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236929AbiFBQTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:19:11 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A91286818
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 09:19:07 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id bo5so5153866pfb.4
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 09:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lMvhSjta3uPc3bafTOd2m+dUMTCYus4sC7njlmQr8LI=;
        b=Ni9tcgecPjxQYf0WKWRMA0r4Aq3MiEOHhTUqLp0nfMPfm8lSyp7IgLacqHJxnMWPaS
         Y3gpR7wzvV7CEhMIvf6i/2peeDYj7I5Q2kURzzRs5tOPrMmCtHQ1OBVNkEEwI/+D2bpr
         ZpZb1PhGkQwLwkJdQSwL4uBVS3xZAUZPEpEdTiMndrN1+k4/6tyy/eta1oBkpYWT9LL6
         9l5uroFj+LBT/laL6Nue9t1ClxpzPOzlZqmRFxR4UOTbqiVkZjIwLJGJkTETBR26VZmQ
         4OYJdZpDS8/onD2Z8mxXx7BXrH7MZmEm4r+CQjAPCJB5qh7VfhiWwebReUwaUgOcrbK9
         NYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lMvhSjta3uPc3bafTOd2m+dUMTCYus4sC7njlmQr8LI=;
        b=wnUn5JasPEsMyWzXRA+eSkqd4NkpabZg/9H0xyUZIKChFOgYksPkPEyF2QRpnDq/zr
         yZev5laMoxN0Yj9TMhsQdo+AFMx9UYXNyhi2H0XZe1p17cHo1BrAeBjKfz4x0copJvuV
         jQ0wrJIn80ylJSoPjnKEXD4xa3nvYDV/eQ4l++SDe+Ma86bgf/B2grERz3Pi9d8N93o7
         1KaN5lztN/6D1/zfn1vYyKAnY29Gy/tuTMD1qVYbhD8l3JTpcNe/cGIAoLgh22UQhmTC
         Jak4nfo9xXI9HtcsYLDitycQwtSZQylG3y2SpSs9T1Q+Nx9OHXH3+QcpZcB+eHukceRr
         QlQQ==
X-Gm-Message-State: AOAM531ty9ynB18LFY6xyposgO5eVQ7mZo4rZ+HbWUxIyz7Zp8PFm7HY
        L8oVtdyFkZFCk0/16qVtby9QigjuA4M=
X-Google-Smtp-Source: ABdhPJxQo4tG2qHOOm3soNY57m6uk3ZtHdCHP9buwlLc/HRWhX3jsh219AqGs2PYJ8QqjNFMe6xlow==
X-Received: by 2002:a62:7b94:0:b0:51b:c723:5724 with SMTP id w142-20020a627b94000000b0051bc7235724mr4344713pfc.8.1654186746642;
        Thu, 02 Jun 2022 09:19:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:1ff3:6bf6:224:48f2])
        by smtp.gmail.com with ESMTPSA id u25-20020a62ed19000000b00518895f0dabsm3751072pfh.59.2022.06.02.09.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 09:19:06 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net 2/3] net: add debug info to __skb_pull()
Date:   Thu,  2 Jun 2022 09:18:58 -0700
Message-Id: <20220602161859.2546399-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220602161859.2546399-1-eric.dumazet@gmail.com>
References: <20220602161859.2546399-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

While analyzing yet another syzbot report, I found the following
patch very useful. It allows to better understand what went wrong.

This debug info is only enabled if CONFIG_DEBUG_NET=y,
which is the case for syzbot builds.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/skbuff.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index da96f0d3e753fb7996631bc9350c0c8e0ec5966e..d3d10556f0faea8c8c1deed5715716d4916011d1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2696,7 +2696,14 @@ void *skb_pull(struct sk_buff *skb, unsigned int len);
 static inline void *__skb_pull(struct sk_buff *skb, unsigned int len)
 {
 	skb->len -= len;
-	BUG_ON(skb->len < skb->data_len);
+	if (unlikely(skb->len < skb->data_len)) {
+#if defined(CONFIG_DEBUG_NET)
+		skb->len += len;
+		pr_err("__skb_pull(len=%u)\n", len);
+		skb_dump(KERN_ERR, skb, false);
+#endif
+		BUG();
+	}
 	return skb->data += len;
 }
 
-- 
2.36.1.255.ge46751e96f-goog


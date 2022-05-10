Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD96E520C7E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbiEJEB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 00:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235766AbiEJEBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 00:01:49 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4FC2AACC8
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:57:52 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l11so8060649pgt.13
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F23hvNdZVN0CdwC6BDdwdQ1zcLt+U3y9nLMorclWjn4=;
        b=e+h+1AdoaW6x4sMIP6jh3B1gwLjq2OIaKGCNJg7A2bq1lEoI0alrTV3FyilvQV4EmZ
         FAhmHf0GXIZAetAMMT6/BZm/cG8g7rhIZHbr49Q55Avvb5GlkdZh+d2TBIsw5uACkLmR
         4RLsAdHgkrrz/sGbyP3BuAeBRhPSodRC9Wy712FOEm7v7mhq6x0GOo0YdIn46UcdVJcQ
         rU4COrA5j8fBhb1NVtm44iRxCobqgOeG5QHRyg7L2dMUJ1Y/Ci2qXQVZcRqPzAQkCjWi
         oszZnZdIy4Poa2R+BcTZkKILPEPIuu4hyvw5yEWt8OBX79QNhhcdZ1UlFSWQ/NuVntkG
         /DTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F23hvNdZVN0CdwC6BDdwdQ1zcLt+U3y9nLMorclWjn4=;
        b=vGHgy4vC6DWYeA4wHKIGAtSlHV3rxzj6W/RuBVHCJP7n+g6ih2dc7mXmeHTtdGajfL
         UlByGYB4oxnL/L74tyBLkHMSQ/juFuZJ5LpzufQ8cilktvx0QJd1tEXpM0BbsqSgVl4n
         wY8/+pc1r5UFPQC8L11s0VFMtA4WcV3ZLHVqymWLQujT+r7rcnHC1lXE2tuB4F+D/RvY
         o+DS086ySWW3FSatmorQO+GX3sv+ZkG/YWFNZT5y/3PB70HR/vJN6ywZjy0Z1NjhGDCK
         zSdmmJdw8q4FcksoQOUjgsA1QLExqt/sUFZD8DhK+Tvwm8VWWIoKjDJaeIpcVhRZ0XYK
         6U5Q==
X-Gm-Message-State: AOAM5338axhJRi1OTxUIn3KQY8mAoQSNM7hVNaqbDCuldh749kiiCRGv
        K3a3MewQLZ0HzCsp4Iqshe4=
X-Google-Smtp-Source: ABdhPJzSKUVdheO3C3Mtx8Mcr37FnUkc5REcaf4FhxHVSfqcRfcF0+mNdCVRsZJbutHERGd7nlfUUQ==
X-Received: by 2002:a05:6a00:238f:b0:4f7:78b1:2f6b with SMTP id f15-20020a056a00238f00b004f778b12f6bmr18767003pfc.17.1652155072536;
        Mon, 09 May 2022 20:57:52 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id d12-20020a17090ad3cc00b001d81a30c437sm568193pjw.50.2022.05.09.20.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:57:52 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 4/5] net: remove two BUG() from skb_checksum_help()
Date:   Mon,  9 May 2022 20:57:40 -0700
Message-Id: <20220510035741.2807829-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510035741.2807829-1-eric.dumazet@gmail.com>
References: <20220510035741.2807829-1-eric.dumazet@gmail.com>
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

I have a syzbot report that managed to get a crash in skb_checksum_help()

If syzbot can trigger these BUG(), it makes sense to replace
them with more friendly WARN_ON_ONCE() since skb_checksum_help()
can instead return an error code.

Note that syzbot will still crash there, until real bug is fixed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f036ccb61da4da3ffc52c4f2402427054b831e8a..e12f8310dd86b312092c5d8fd50fa2ab60fce310 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3265,11 +3265,15 @@ int skb_checksum_help(struct sk_buff *skb)
 	}
 
 	offset = skb_checksum_start_offset(skb);
-	BUG_ON(offset >= skb_headlen(skb));
+	ret = -EINVAL;
+	if (WARN_ON_ONCE(offset >= skb_headlen(skb)))
+		goto out;
+
 	csum = skb_checksum(skb, offset, skb->len - offset, 0);
 
 	offset += skb->csum_offset;
-	BUG_ON(offset + sizeof(__sum16) > skb_headlen(skb));
+	if (WARN_ON_ONCE(offset + sizeof(__sum16) > skb_headlen(skb)))
+		goto out;
 
 	ret = skb_ensure_writable(skb, offset + sizeof(__sum16));
 	if (ret)
-- 
2.36.0.512.ge40c2bad7a-goog


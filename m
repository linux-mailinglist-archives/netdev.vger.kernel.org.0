Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36055396A3
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 20:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347209AbiEaS7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 14:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236089AbiEaS7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 14:59:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41E756C13
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 11:59:39 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o6-20020a17090a0a0600b001e2c6566046so3772209pjo.0
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 11:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EPjRtCzpcwhsp0aa03Ct4d3QKHS7Y4VNiM26sMhWi4U=;
        b=QqfqHg8wheuian0etd6tXWyZ95h2vdLJiIAdCNS2RdIuT313AKIbqjbE1GqcYCWCG7
         xGlqWsutkOel+bDaPwziTy4Hjs/GbTBxtHeybbJ8XOEAOwykHuicFOVtso22Lf3XTCxc
         wf7G69XSSgKgsuSb8PCY1Kxx5dt17ZZkYd6SZKXSdLI3CxbeyFq15D/3J5h6G/1qwY4d
         4fpuJDY39PxXA6BT1P7U6T0v0oeZe8y3YPO1V7oVSLVMlBhs/ZhQSfaGEUx2DM1q3+pL
         4jNz+KCOqchy3y4ziAJSVl/PDMbAWD7ELnwHUtZdcUW+j7ExBGUC6OyQb49ynB0WKDef
         A4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EPjRtCzpcwhsp0aa03Ct4d3QKHS7Y4VNiM26sMhWi4U=;
        b=O1Ut+AHDTN9PgSoQL5O1XROPKVTrBlKTMxUlH0WZy5/7wdN9eLAZDrLHgxRGz9JSUh
         nO97kdswIXqQKRC7utSj/35sokEjytTCShG2c4lj49ngBdEdJq0A9Om1UvPFFPFkkJSu
         lt9IPyP8qkcKGnuYgeoWzVC0C4J74KJGNPIGUpEsBW04ccztbpCfcKW5b335hMyvNfvu
         pY10HG7RshQqcttI/2wt+hGL6Eu2qnoXri9cEktGrzg9Leks3J1JZPEdzTXYmcAKMrKr
         cvuBWJzkGq3aefFeW87URJ+o+p7B+1cBAjtfgA3QjtWYvgYvCHoSpmdLD5m6mqxCJ2ud
         D6rw==
X-Gm-Message-State: AOAM533gIqwuiJXwIODfKDzg8qym26vm6khVG2JKXeSVackut3uviUjD
        6TIjs1q+siuRSZ1izGF2ys/0fV/3pkY=
X-Google-Smtp-Source: ABdhPJwExUNTG/8IdDeERo9ED5rwYwC6WY57Phap0Bwajm4dRrl5OpzvNXmDlxCmgyl/Q7OveUHq6A==
X-Received: by 2002:a17:90a:778c:b0:1df:56a5:8474 with SMTP id v12-20020a17090a778c00b001df56a58474mr30263294pjk.63.1654023579108;
        Tue, 31 May 2022 11:59:39 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:74f8:d874:7d9d:dabb])
        by smtp.gmail.com with ESMTPSA id y30-20020a056a001c9e00b0050dc762814dsm10941628pfw.39.2022.05.31.11.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 11:59:38 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 1/2] net: add debug info to __skb_pull()
Date:   Tue, 31 May 2022 11:59:32 -0700
Message-Id: <20220531185933.1086667-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220531185933.1086667-1-eric.dumazet@gmail.com>
References: <20220531185933.1086667-1-eric.dumazet@gmail.com>
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


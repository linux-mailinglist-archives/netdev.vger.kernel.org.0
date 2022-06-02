Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D53353B268
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 06:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiFBEK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 00:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiFBEK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 00:10:58 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9CD208B2A;
        Wed,  1 Jun 2022 21:10:56 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id v1so2666568qtx.5;
        Wed, 01 Jun 2022 21:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eDYIyMHCgFtYaLiwBC6u244sczCv8jasM7WvhfZObJE=;
        b=pBmX55OoeAzCRYc/nILwQVUOYIfpTJSwiENOWQXIRJpsTYopjOURHTCoRQ289cIjkW
         tz0y8/Iyz43nhQQMjtJLHkRTSrZg4QMWYsoOPlTsrKg4OiIp11fE5DkHbIoi55bA2+D7
         3N9dm3Wh8inGo1B+UxWPpsXyhXo8Iaa49K4zkuvjL+qhqHDizuKn7USV6A3cgW2lU4zi
         Doe92y+7Ao5MoPvUZZ6y/jh/qVGjeUYd/ueL+dyH1/eSsBxuPsPlEaNLeecM/viNV0qA
         SJYu6lNjjJlGSRm6JvRhI0iepvOND8QtOVYPYN1Lz/zB+b56nMrl5ssFKbOxoRuNqh7l
         6Y2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eDYIyMHCgFtYaLiwBC6u244sczCv8jasM7WvhfZObJE=;
        b=rFiUZ39aaY/D1jXEDL6aEKcBqLsQ7T1j4Q08xy33BdLqCbR2flEZ4UhOklgEPnx7gc
         L/dNeO1Xk//uV2np/F1PpJh0JTYA8WX38HN5QB/FaWM4QOP0ZQyhrORVE7IOQq67gjG6
         UaBNzcNsb4idUrCT6Bk6OlQFcV1DIDrMHG0ZWHdnIMPf0QdyKH58chYaY6nYd0cHMByE
         5s6FZfb5njK/FMbt0RLKbDSmLXV8swnVC0oUqXUR7CCbBieHyHvoxYvAalZeZQKlqbuv
         C4Vbx/q2aNItQ7M95vwNJgGyfqGv7edb0VR1fielVouoRI7K8EXC+yz79mzqsjWB3xJB
         wRfA==
X-Gm-Message-State: AOAM530y5XZls/6jNSZI2Qh0HtajLojWxXbhzn4vVHUah2IZBdqhcnDW
        75fVpf/9V5pqXWvzZJyFuezHAFpLPzE=
X-Google-Smtp-Source: ABdhPJzkQEQwQHqxrpCRbOqimu9e2MH1jceyRPB6cPwCNiX6WxFb8DnKlc891gD0sHKLqHuSlhZRzQ==
X-Received: by 2002:a05:622a:50a:b0:2f9:2af9:7dbc with SMTP id l10-20020a05622a050a00b002f92af97dbcmr2280818qtx.279.1654143055487;
        Wed, 01 Jun 2022 21:10:55 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:d7c6:fc22:5340:d891])
        by smtp.gmail.com with ESMTPSA id i187-20020a3786c4000000b0069fc13ce1fesm2396654qkd.47.2022.06.01.21.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 21:10:55 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [RFC Patch v5 1/5] net: introduce skb_rbtree_walk_safe()
Date:   Wed,  1 Jun 2022 21:10:24 -0700
Message-Id: <20220602041028.95124-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
References: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
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

From: Cong Wang <cong.wang@bytedance.com>

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skbuff.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index da96f0d3e753..857fd813c1bc 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3929,6 +3929,11 @@ static inline int __skb_grow_rcsum(struct sk_buff *skb, unsigned int len)
 		for (skb = skb_rb_first(root); skb != NULL;			\
 		     skb = skb_rb_next(skb))
 
+#define skb_rbtree_walk_safe(skb, tmp, root)					\
+		for (skb = skb_rb_first(root);					\
+		     tmp = skb ? skb_rb_next(skb) : NULL, (skb != NULL);	\
+		     skb = tmp)
+
 #define skb_rbtree_walk_from(skb)						\
 		for (; skb != NULL;						\
 		     skb = skb_rb_next(skb))
-- 
2.34.1


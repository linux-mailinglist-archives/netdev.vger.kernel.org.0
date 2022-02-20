Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF5F4BCF7F
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 16:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244261AbiBTPlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 10:41:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238371AbiBTPlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 10:41:19 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF82424A8
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 07:40:56 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gi6so3213125pjb.1
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 07:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PIzRuDncM7qIvcl9VXEevfZ7OAYcfquc64I7YyP34m0=;
        b=A5MeebKQ4yiQ5XRbDnAdoNW0QW/mMP8p/jvPOM5JWKeXlOrBupiH+z2jFNKrUJ5Rje
         bb7uPSZQpulrBnnP/gBVF0B2mbZ88ut59OvZ/mL8cq6w5L2+ZnAp9Co1g3d6hLskdOVM
         7mYi6Xt7WmkA5x+Cs6AyYgBpPoWixKCc7WTn5l2CRPqvK6dV+aVAIJ+gqhkyoiq4nF64
         x6SUX1orf87rrrXjSVbLrtYR/AAh2XXje5IBPV22mN8O5wNa+yqCJwMHQJf010iZ2Y65
         hZxeP5zsTf3X5TdNwU25m0xQCMGG4mFe8EMIjwI05OePLsbS4o+jYrrabT64pBJMFrRN
         hDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PIzRuDncM7qIvcl9VXEevfZ7OAYcfquc64I7YyP34m0=;
        b=0DtfgBLkKr2I09HjeO4kzzw+IJYBBWmenVyBHNBLXhPZ7KDGYNbN2LVzkLCnCW1UAb
         wQGLjWg2vKRkOVhV6GLZVLM8yBmYa3LCpwo8mzKiXnrcDI6UktK7ZSw3Aq2RxaW1wfHt
         NdfEdKKDjQUH8/Z3X6V2vjj9NwXk5fwMs7QcgzzFy6L4AFvVhRq6ZkHa9uqkhi9ae2JQ
         fULvjt9TT6hTuw7K91lTsA897br6PFfisMUhLEq8o1rVD2x5jfSSrL+253kjFTO+m8D4
         bQqV1RhtNMMnzL3hwvf9eUf7IxpWwYK4wjxG2UqIpQCO6z5Djd+MebDbGGKf5hpRaFjn
         pv5Q==
X-Gm-Message-State: AOAM530zKfwQWwEJAA/HH2raHWzewEpTBoCMMjVk6O8XigZhicJHVV3R
        GT0eUKt1rOZX+OmF8tK/TwI=
X-Google-Smtp-Source: ABdhPJydP9Hkiv1lgJWxsXHxVjaQxmhJ9VOPsEyVm0gTxIIvYcxebEkKuY2XtM1lfDfKf2/U4FrIvw==
X-Received: by 2002:a17:902:e8c2:b0:14d:7447:1002 with SMTP id v2-20020a170902e8c200b0014d74471002mr15821384plg.134.1645371656208;
        Sun, 20 Feb 2022 07:40:56 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3c33:9150:a86a:6874])
        by smtp.gmail.com with ESMTPSA id mn9-20020a17090b188900b001b964d87048sm4840979pjb.39.2022.02.20.07.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 07:40:55 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] net: __pskb_pull_tail() & pskb_carve_frag_list() drop_monitor friends
Date:   Sun, 20 Feb 2022 07:40:52 -0800
Message-Id: <20220220154052.1308469-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
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

Whenever one of these functions pull all data from an skb in a frag_list,
use consume_skb() instead of kfree_skb() to avoid polluting drop
monitoring.

Fixes: 6fa01ccd8830 ("skbuff: Add pskb_extract() helper function")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/skbuff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6a15ce3eb1d338616d6ab52d6c5c21baa9db993b..b8138c372535b214aa96ccba7cb991855edf7931 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2276,7 +2276,7 @@ void *__pskb_pull_tail(struct sk_buff *skb, int delta)
 		/* Free pulled out fragments. */
 		while ((list = skb_shinfo(skb)->frag_list) != insp) {
 			skb_shinfo(skb)->frag_list = list->next;
-			kfree_skb(list);
+			consume_skb(list);
 		}
 		/* And insert new clone at head. */
 		if (clone) {
@@ -6105,7 +6105,7 @@ static int pskb_carve_frag_list(struct sk_buff *skb,
 	/* Free pulled out fragments. */
 	while ((list = shinfo->frag_list) != insp) {
 		shinfo->frag_list = list->next;
-		kfree_skb(list);
+		consume_skb(list);
 	}
 	/* And insert new clone at head. */
 	if (clone) {
-- 
2.35.1.473.g83b2b277ed-goog


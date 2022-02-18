Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78BC4BB2B9
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 07:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiBRGyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 01:54:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiBRGyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 01:54:50 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E3C7671
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:54:34 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id c4so1618310pfl.7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IdpKNZXJYCUBYzdfMtB/vViA/LTM//0O7ErBj/fkfT0=;
        b=BzJnIaKwkyLNekqXsPsDnJitKBQdWFJi6dxwGF/4fo3i0lpgp+aAqfMRJgVsfRge3e
         nhx+r5X7yghN0Us4Hnr/qbp/l6ZoNb2Cfoo/lJXIhImds3MOUBQN6CctNbcJ+PRXywiX
         vEXVeEhJnvj/scDgX9Xgr18CzXRiybEvA3OCq4gBtBclEHIiktXKlBN6q0YFwAuylexZ
         kUudGliaIjnxVG1wfAU189OLtRPZjK4fQ1+LdPbTORBUUH3/eSOTRdsjzzTM0OCww0uj
         Ijyg4c3EscsckcJofhiaEeU/XUxy7FuD3ipWJwqOSt+8WYGdoa22XjFyrwLfU5OUW1fm
         hShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IdpKNZXJYCUBYzdfMtB/vViA/LTM//0O7ErBj/fkfT0=;
        b=LGhUhtDJZ9h8Ij7ZnKKQ0CTUdqv2L2lQ9WBOoGNKKb1ro8KWzQyKDR6RuVAC2ZgDzx
         a7vX/X2ugQXNmJD4ltlBYwxJMgk/fVz3tfwFZoQ7S3fLCHIyEXoBRTDFuxgQwgMxX3HQ
         PvaSfrWMHu0MpxA9SSer+bn/pJNXpM/ZGkBg40kgiTlRtHe75ranGnLqPEUbO6UW0rfE
         ltBbwD5L4R2irO/g124ioarUkGtIzbHruw6igr9JRF3NQiAmragjT2zm5+zS3kvTLNye
         j4Dr7iiLCkCormFbpu1QRr/aqr3/4FbuQ3VMl4BehA2BuSUsaKKrnkewqi0bXPyP6LIy
         +cWA==
X-Gm-Message-State: AOAM533ONo5fMQKBWW+i+aSgWYB/Zs1n0GG9YP8jWW7NfsgiJVWNn27m
        xpgqaK/zfVsbnOAODM395OqzIeyHutY=
X-Google-Smtp-Source: ABdhPJzF8bloHPxoZ3/qLLMqKXm4unaIusWAe8dFutqHJ7BIm67LJKDVh/qdKNBi++M+kNQ6LSMHmw==
X-Received: by 2002:a63:31ce:0:b0:34e:4052:1bce with SMTP id x197-20020a6331ce000000b0034e40521bcemr5243461pgx.459.1645167274046;
        Thu, 17 Feb 2022 22:54:34 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5c60:79a8:8f41:618f])
        by smtp.gmail.com with ESMTPSA id e13sm1584991pfv.190.2022.02.17.22.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 22:54:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: avoid quadratic behavior in netdev_wait_allrefs_any()
Date:   Thu, 17 Feb 2022 22:54:30 -0800
Message-Id: <20220218065430.2613262-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

If the list of devices has N elements, netdev_wait_allrefs_any()
is called N times, and linkwatch_forget_dev() is called N*(N-1)/2 times.

Fix this by calling linkwatch_forget_dev() only once per device.

Fixes: faab39f63c1f ("net: allow out-of-order netdev unregistration")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 05fa867f18787e709dcaccfea1df350c424eff80..acd884910e12a040841e1e0525e0d4bc5e3ee799 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9828,9 +9828,6 @@ static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
 	struct net_device *dev;
 	int wait = 0;
 
-	list_for_each_entry(dev, list, todo_list)
-		linkwatch_forget_dev(dev);
-
 	rebroadcast_time = warning_time = jiffies;
 
 	list_for_each_entry(dev, list, todo_list)
@@ -9951,6 +9948,7 @@ void netdev_run_todo(void)
 		}
 
 		dev->reg_state = NETREG_UNREGISTERED;
+		linkwatch_forget_dev(dev);
 	}
 
 	while (!list_empty(&list)) {
-- 
2.35.1.265.g69c8d7142f-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768AB59C1A7
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbiHVOc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235262AbiHVOcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:32:54 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D47530F60;
        Mon, 22 Aug 2022 07:32:53 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id j21so16206792ejs.0;
        Mon, 22 Aug 2022 07:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=shbfVsWu96uc3080vFE02rFSUQok5BcsheCh1Y/h5IY=;
        b=CWAvfwi4L3uQJGgH8M2BW35LvL4Z/PzSav9V7qvdya6tOgncfobWxyAxkbWap9ej4D
         ieK4eYgdwHXGS1QpGLOVoJ0Ujr+/IWDv/0naLjuxJlxF8h4Fld8mwTSMHy4gJK+SEuU9
         5ojg6OSwrxjpxyUBJ5hWMClzK1Jn8gXjSyYgC1vmXyOK4t7Obl78Dh0p4wcZRxUHGCns
         FHrfWEvUS5Nmbw1MPh2TN1+AzRF5yiA7omwXHpjCib53iiKCQrSZdQxC7uOZ7HV3k59Q
         Naz93WNf1g6z36ZfVf2wvMPBFT2k0lIzmTtiZtIgYLSKHKCGg/IN0NQ01cGvQO+XyrdM
         pmDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=shbfVsWu96uc3080vFE02rFSUQok5BcsheCh1Y/h5IY=;
        b=Kvwfjd8R8LOMRUCf9Ofll7vAyRuBu26zskJLjQ0zTYd2U3BxEQPdSyO0mNJRUAp0am
         8PB1El2Gc4SLZIkwxG9Aq1XZiX6Ip+SraTndsuTMNkJdYlGurhi7tjsKtac4yJSL3TMW
         uBs9ML8yKeJShzxH5qu57sLXiEW+e1PXZC3NoBDnJrF6jERFxIpSzkqQyzNx2KH9ysO4
         +DMseduzX6+V3Je2rhHMoBoi8Sxm91rHAfDXWk0tLDR91jJAIDa65aRSmqoRPWdmu88O
         3oj9NUiuF8FGCtgir+LioaIBSu+vmAh+Jp09fKXJey+QE2WhT+mwAHFKfu9J6VTVgnY7
         nNxA==
X-Gm-Message-State: ACgBeo0rfN4p7yxQMC85bGV7anT+RoG6AHnGfl6tJjUnN0b7EII3Qqa2
        h9T8kUEm3o8GcFTNS8b+PA3HW6rO8Kew+A==
X-Google-Smtp-Source: AA6agR7XqJGJGgE6RCokWyBjsKzaDtQt6UV/EJCJitbWRbahLyE+ZzOnSwby3M4IsTIkUEN3GFvpOw==
X-Received: by 2002:a17:907:6e18:b0:73d:63d9:945f with SMTP id sd24-20020a1709076e1800b0073d63d9945fmr7513576ejc.12.1661178771870;
        Mon, 22 Aug 2022 07:32:51 -0700 (PDT)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id n3-20020a170906b30300b007081282cbd8sm6225115ejz.76.2022.08.22.07.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 07:32:51 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] netdev: Use try_cmpxchg in napi_if_scheduled_mark_missed
Date:   Mon, 22 Aug 2022 16:32:43 +0200
Message-Id: <20220822143243.2798-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.37.1
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

Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
napi_if_scheduled_mark_missed. x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg
(and related move instruction in front of cmpxchg).

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when cmpxchg
fails, enabling further code simplifications.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 include/linux/netdevice.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1a3cb93c3dcc..51c916894661 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -546,8 +546,8 @@ static inline bool napi_if_scheduled_mark_missed(struct napi_struct *n)
 {
 	unsigned long val, new;
 
+	val = READ_ONCE(n->state);
 	do {
-		val = READ_ONCE(n->state);
 		if (val & NAPIF_STATE_DISABLE)
 			return true;
 
@@ -555,7 +555,7 @@ static inline bool napi_if_scheduled_mark_missed(struct napi_struct *n)
 			return false;
 
 		new = val | NAPIF_STATE_MISSED;
-	} while (cmpxchg(&n->state, val, new) != val);
+	} while (!try_cmpxchg(&n->state, &val, new));
 
 	return true;
 }
-- 
2.37.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859FB5804FE
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbiGYUGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236247AbiGYUGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:06:00 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C715C2124F
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:05:58 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id u20-20020a17090adb5400b001f2ef45d6f3so49362pjx.0
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CxP5g2gg+talP8YIuvEHN7uNACNiguN46gqXq5U9MgM=;
        b=HMexTUtN/OAzwvfjIZHbU+jnDZ4/FTGeYqK7S8x3SLI2qpYne/ccFvDXPzvb207R26
         pwBRW/P+Q7HKb6mW9nXh+8ovMzOshevmXJOyPlJeJW9SGNBLBMUoZ7ZFznA2pkv24oPv
         4o7nWnWSBFHG3x1qgpqyOmR6LapAcuVozS6xUZZeb54pu7bTdkiLbtjK9EaVin21eHPv
         R87oc2KbFoXjnYULjjmGLk+SST58Szt179EzGATP6eqBS1ZKzeY3z03qI+QT1xTsdvEi
         FdgBt8qbZD3cTHk0pEowtDk9dklNEfaLMEYV8W+6tvsLKDZNkderIBdzaaaT+6ogCDJL
         fCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CxP5g2gg+talP8YIuvEHN7uNACNiguN46gqXq5U9MgM=;
        b=Y48YGCqxlAwdNwzOzUDC+tCDvpvOtzBIbU5E8UsI25DWyPKpLun/q0HQaRp3OvpRUa
         tSpbvxUQiSdBwtUaFqOuWHJUJBtUZEWunQySO8guMv124iNXKFmJhLPHVL018nx6sQ6u
         TCR5f92x7Kdd1VxgC4WSh1h/ySChy8y1Iezn5gUL2O2mN3QumTtsrQzCbIhtNVXY/zIL
         6TRHhGU6ZwC9VNTdDw508JCUslWrxt1FxX5gvPq0rASQXxwVHamc3WiEyBnKagz3Z/Dn
         gsYG2JwWtqZ1t88YrWwO1tHgh24cTATQxYUufgx/eAVh0c6Y3dSy2/6kEwJo0NS1MvYt
         KRgw==
X-Gm-Message-State: AJIora9rMRxeEGHJ5IPsux3pm+Igo0x/RjE+GW8sev7k5o3GotxGX6Ml
        +R4bnMCBsxdJfmAMUfPc6VLruICO0kI=
X-Google-Smtp-Source: AGRyM1sI4bzvQowwd1o8KP6loYMGhWGptiykbfumh6c6XUpDq4KXwBvh0RNWTBBqfoApiMI+eALMbA==
X-Received: by 2002:a17:902:6902:b0:16d:810c:1381 with SMTP id j2-20020a170902690200b0016d810c1381mr4563183plk.162.1658779558074;
        Mon, 25 Jul 2022 13:05:58 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:35ca:bd3f:5c92:1630])
        by smtp.gmail.com with ESMTPSA id k62-20020a17090a14c400b001f218ddd5e2sm11449590pja.32.2022.07.25.13.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 13:05:57 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] ip6mr: remove stray rcu_read_unlock() from ip6_mr_forward()
Date:   Mon, 25 Jul 2022 13:05:54 -0700
Message-Id: <20220725200554.2563581-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
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

From: Eric Dumazet <edumazet@google.com>

One rcu_read_unlock() should have been removed in blamed commit.

Fixes: 9b1c21d898fd ("ip6mr: do not acquire mrt_lock while calling ip6_mr_forward()")
Reported-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index d546fc09d80310f20488a6627bf782c067a80fa6..a9ba41648e36854fe1702a3397a36a366be4c682 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2133,10 +2133,8 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 		 */
 		cache_proxy = mr_mfc_find_any_parent(mrt, vif);
 		if (cache_proxy &&
-		    cache_proxy->_c.mfc_un.res.ttls[true_vifi] < 255) {
-			rcu_read_unlock();
+		    cache_proxy->_c.mfc_un.res.ttls[true_vifi] < 255)
 			goto forward;
-		}
 	}
 
 	/*
-- 
2.37.1.359.gd136c6c3e2-goog


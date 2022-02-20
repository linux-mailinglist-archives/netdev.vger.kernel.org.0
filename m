Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C354BCC21
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 05:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbiBTEMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 23:12:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiBTEMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 23:12:19 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C610E37A83
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 20:11:59 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u12so10229839plf.13
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 20:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZI4iDVy0yscb5iKnvpMkrer9uJHyCPzcfYbYlczhttI=;
        b=egtrhZQr33JfSmKm/rjeMx2v4LMS4bdfIGPA3BCqtS4tu8NwJjwtKn+V9faOPZaETd
         VC60i/BCswcp0lRtiDJuBlg7Z4CwtMJCJdGT+6se7pO4bYIcLlwLnyFJ5+A6PWekgM87
         ruXAVV5qL2IuxDNaJ9T1aBiuc1zgimEBWKL/8Y2+lkFCOc58nyhbQFBpkv7YoiSTFBId
         slv+aQQe9JupV2KwNAxVb1nAKc9rLU7bU5HKEBmeCW47oG6d1Ix1q5QitlMNWD3EcH7q
         HaOvBYJbwzF+JRkUB0VU9eSQ+/UoMkKKJ/j4HXkzNskJtr3KGCQxgDT/Sr+/TQI9gvHT
         qb+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZI4iDVy0yscb5iKnvpMkrer9uJHyCPzcfYbYlczhttI=;
        b=gBd9XqR5SSQ1O47HWphQtskR0j0bmYchL/0Uq+IFz6AL4ZiWNfghY4OM7aBN6ChRQt
         d+c/+I6UFO9R5MkLMORVxXcgnuJIK9WVv6Lvw9WHW9d3ezY4sM+eGW7Se1PjAfNOxmiU
         1EhZyioXERFlEyKU+LavY9R9qgK8MWQ7QmRhOrs/UpmrXpgYNJc3D65wUD0Fy9HieDQi
         FmSfXWghKvMlkjRaLhP8cytx8E++gbB+6onu73e+itbno7Q7bZNWqe8nULueFsMep9HK
         Cm5dT6hZVXLGAevxo1U+111UDpi7wSQWTFZScoazRLpySJtTLcpYCMnPM6eK+SoJEo7Z
         L8HQ==
X-Gm-Message-State: AOAM5320XFYje7gU2ZMgA52uiq9dcaFYrvgC7x5b4LTj3PKSHOT8NOou
        Yekkc0rMQDNXrnkcYef2ch7MOtnTNqQ=
X-Google-Smtp-Source: ABdhPJwo44Owdf3s79yBIlsAivYgwzxshyjdNsqeIp7Z+QdaVjr5uH/ySIKmlJmcAxwvlKnAPYFwmw==
X-Received: by 2002:a17:90a:7803:b0:1bb:9945:d68c with SMTP id w3-20020a17090a780300b001bb9945d68cmr19043205pjk.100.1645330319315;
        Sat, 19 Feb 2022 20:11:59 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3c33:9150:a86a:6874])
        by smtp.gmail.com with ESMTPSA id x126sm7444579pfb.117.2022.02.19.20.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 20:11:58 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next] gro_cells: avoid using synchronize_rcu() in gro_cells_destroy()
Date:   Sat, 19 Feb 2022 20:11:55 -0800
Message-Id: <20220220041155.607637-1-eric.dumazet@gmail.com>
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

Another thing making netns dismantles potentially very slow is located
in gro_cells_destroy(),
whenever cleanup_net() has to remove a device using gro_cells framework.

RTNL is not held at this stage, so synchronize_net()
is calling synchronize_rcu():

netdev_run_todo()
 ip_tunnel_dev_free()
  gro_cells_destroy()
   synchronize_net()
    synchronize_rcu() // Ouch.

This patch uses call_rcu(), and gave me a 25x performance improvement
in my tests.

cleanup_net() is no longer blocked ~10 ms per synchronize_rcu()
call.

In the case we could not allocate the memory needed to queue the
deferred free, use synchronize_rcu_expedited()

v2: made percpu_free_defer_callback() static

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/gro_cells.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
index 6eb2e5ec2c5068e1d798557e55d084b785187a9b..8462f926ab457322a12510a4d294ecca617948f0 100644
--- a/net/core/gro_cells.c
+++ b/net/core/gro_cells.c
@@ -89,8 +89,23 @@ int gro_cells_init(struct gro_cells *gcells, struct net_device *dev)
 }
 EXPORT_SYMBOL(gro_cells_init);
 
+struct percpu_free_defer {
+	struct rcu_head rcu;
+	void __percpu	*ptr;
+};
+
+static void percpu_free_defer_callback(struct rcu_head *head)
+{
+	struct percpu_free_defer *defer;
+
+	defer = container_of(head, struct percpu_free_defer, rcu);
+	free_percpu(defer->ptr);
+	kfree(defer);
+}
+
 void gro_cells_destroy(struct gro_cells *gcells)
 {
+	struct percpu_free_defer *defer;
 	int i;
 
 	if (!gcells->cells)
@@ -102,12 +117,23 @@ void gro_cells_destroy(struct gro_cells *gcells)
 		__netif_napi_del(&cell->napi);
 		__skb_queue_purge(&cell->napi_skbs);
 	}
-	/* This barrier is needed because netpoll could access dev->napi_list
-	 * under rcu protection.
+	/* We need to observe an rcu grace period before freeing ->cells,
+	 * because netpoll could access dev->napi_list under rcu protection.
+	 * Try hard using call_rcu() instead of synchronize_rcu(),
+	 * because we might be called from cleanup_net(), and we
+	 * definitely do not want to block this critical task.
 	 */
-	synchronize_net();
-
-	free_percpu(gcells->cells);
+	defer = kmalloc(sizeof(*defer), GFP_KERNEL | __GFP_NOWARN);
+	if (likely(defer)) {
+		defer->ptr = gcells->cells;
+		call_rcu(&defer->rcu, percpu_free_defer_callback);
+	} else {
+		/* We do not hold RTNL at this point, synchronize_net()
+		 * would not be able to expedite this sync.
+		 */
+		synchronize_rcu_expedited();
+		free_percpu(gcells->cells);
+	}
 	gcells->cells = NULL;
 }
 EXPORT_SYMBOL(gro_cells_destroy);
-- 
2.35.1.473.g83b2b277ed-goog


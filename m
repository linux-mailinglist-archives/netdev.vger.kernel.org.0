Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E644BCC13
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 05:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243445AbiBTD6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 22:58:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243555AbiBTD6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 22:58:14 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BCF56201
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 19:57:44 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id r64-20020a17090a43c600b001b8854e682eso12187911pjg.0
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 19:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zjYRnMzAHnmq1c5GcSOMXeelVaIqj2NYRaepaDngDGo=;
        b=RNztJbY7PcN9RlTWUSxkFJKbs2fpwz8C+ymWdVyLFzTnlPPscrPjo/TOe1VQfbS5Ca
         AXiDh4+wiY9SeqNlFwHv3FodTFUhmYTvoCrivOAG6Vi3RZJ7cs5J3BdJdB87i6HHa997
         XLIOPmlhZQ85nnfbvjiYLH+E9HZbvTHqwyRlNa6dBaSL9HXzYd4aYz1r4v+Ni8N5F/4X
         vgT2QabeLWBelQq/ZwLPbztzUYDD2gz91nion7N2cytwM71FBj03vT1UG3ElzfKg4E4s
         rFYIX8zlFQkp65Zu2Hamvwuc8S7ypOLcgXtB5ixOjrKwa6IL2nvStAOOa7/EQuwjDVCp
         WTjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zjYRnMzAHnmq1c5GcSOMXeelVaIqj2NYRaepaDngDGo=;
        b=JPukwSVN1LdTXBETCWtL2YS7eeQXztEkAFXdCWPF7FmlmNRxEte6WeVJ+lsGa3WeS2
         ub0aJtv21KvctKunx6n5E60fOCxWL7dDF1rxR2tbWcs5L7JD4OdbrpeWMcbIf+hJrYj/
         nB20WGvyGEWatsKuOAoUiDd/3PKBU2eyNdkoj/dCFCVAPabh2RpQmzkcUrsILeAlGtO5
         9f1AuJMCTXPuoLF0zTv1BLG2gADRiWlJFV3p3Z3P2tHDMxLO2ugRxtHdLkicnDuwM2X3
         8ibT6ETjhzNYFhlj8N8LAXp6amsNkgcc61FGW+1F+87eHDKKmYehj1UoKeTjcb4KjlLn
         mN6A==
X-Gm-Message-State: AOAM531jVHJt52V5csaDuziZgR0fMCqCEql3kNY/expBuF/Ne4BGuzW5
        DLtf9MHjaA9gDrB6e0Uh4Jc=
X-Google-Smtp-Source: ABdhPJxbruWt3HixZxNHD8YRCqLzo8gIXBYknX+f3qpwbIgy2VHAYrTMucdCu++/Yc9ZkoUJ7485ig==
X-Received: by 2002:a17:902:d64f:b0:148:bdd6:d752 with SMTP id y15-20020a170902d64f00b00148bdd6d752mr13829694plh.20.1645329463923;
        Sat, 19 Feb 2022 19:57:43 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3c33:9150:a86a:6874])
        by smtp.gmail.com with ESMTPSA id z6sm6798845pfh.77.2022.02.19.19.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 19:57:43 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] gro_cells: avoid using synchronize_rcu() in gro_cells_destroy()
Date:   Sat, 19 Feb 2022 19:57:39 -0800
Message-Id: <20220220035739.577181-1-eric.dumazet@gmail.com>
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

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/gro_cells.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
index 6eb2e5ec2c5068e1d798557e55d084b785187a9b..46fa7d93fd9696755efd56b72731f08e821042e1 100644
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
+void percpu_free_defer_callback(struct rcu_head *head)
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
+		*/
+		synchronize_rcu_expedited();
+		free_percpu(gcells->cells);
+	}
 	gcells->cells = NULL;
 }
 EXPORT_SYMBOL(gro_cells_destroy);
-- 
2.35.1.473.g83b2b277ed-goog


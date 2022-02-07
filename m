Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01B94AC76A
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377697AbiBGR12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384349AbiBGRS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:18:29 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A67C0401D5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:18:28 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso2998374pjh.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zzYXbAI9QAjG7qz27KZbmKUJU0Aol5TgzItO93+yuUo=;
        b=mjD1du4AN4UoL4Oi6U9VhAs1IMq8gIMjLDgJ7rXHTzjCODxYmUqYHhz/p+ME9lXuVy
         RJVZbB6G1rGca2pvDR3P2GDRl9EwqeW2Np7KdWu12NaT90gahjFbrTQh3Y9it+XWAWlD
         SHB8RSsywC1XkqzQL+0cGr//qoonbMifsKnbvjeX1eQFqClFFCZ2aSbimY52aUY9yURe
         T32PbXdjeD984LxZ1JxfOge0E6qkV4pUxUqoW/rMkQnewjvHIZvbRMEBGZJBSuxuvu8Y
         zQzOZd+8jiyGgfmds7pOpCwc7sp4t3OlZLI8E22vYxAUem0UdCzE/9NzJJIUYxgbeJ/1
         7/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zzYXbAI9QAjG7qz27KZbmKUJU0Aol5TgzItO93+yuUo=;
        b=zqGKFyBtE9Rhz5q4o0mv7aj4WH42w6KSNtCS88WxXL4ENY495BTfi/TsPKQM3QYgkW
         t1YP0lKSTL5sZuuNUhIbyjyrZfx+AzToAGTJ6mW02XzushwL/jWq5m/doCvuRrKahAOl
         bNziCkKmqsndWLk/ab0rxXZ7Mt2xaEJN+aUtK3MEnQ2bU8rDxYU6hdXZHdSrkxj1uYm/
         Lnl6xvtx0kpJtPt4PML43M8fiDy902THwD6tRmMRuviudWx7yJHPmjNnwCX0JhZjfZnB
         3e5Y3yRmVFbwHsqcw9ZK5/kHxwhA73P+Fj3D23pur1an6kkmyq/YcflQycaiR1fl3BNm
         mdgg==
X-Gm-Message-State: AOAM531m2fj7DG6KI5GydvzoiUgRUKy/872mScDDHBzZEmo1o6NcHKYB
        y6SRtarx/9AnGM/sMaXF3D0=
X-Google-Smtp-Source: ABdhPJxFTpEb1fldfwS6NeV4yIaLtZqkcGsJOLyAUBiw71WQULXdR2a1kc4/wLfzae8/0+R23mvDGg==
X-Received: by 2002:a17:902:d487:: with SMTP id c7mr735888plg.0.1644254308272;
        Mon, 07 Feb 2022 09:18:28 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id lr8sm24415156pjb.11.2022.02.07.09.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:18:27 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 09/11] can: gw: switch cangw_pernet_exit() to batch mode
Date:   Mon,  7 Feb 2022 09:17:54 -0800
Message-Id: <20220207171756.1304544-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220207171756.1304544-1-eric.dumazet@gmail.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
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

cleanup_net() is competing with other rtnl users.

Avoiding to acquire rtnl for each netns before calling
cgw_remove_all_jobs() gives chance for cleanup_net()
to progress much faster, holding rtnl a bit longer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/gw.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/can/gw.c b/net/can/gw.c
index d8861e862f157aec36c417b71eb7e8f59bd064b9..24221352e059be9fb9aca3819be6a7ac4cdef144 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -1239,16 +1239,19 @@ static int __net_init cangw_pernet_init(struct net *net)
 	return 0;
 }
 
-static void __net_exit cangw_pernet_exit(struct net *net)
+static void __net_exit cangw_pernet_exit_batch(struct list_head *net_list)
 {
+	struct net *net;
+
 	rtnl_lock();
-	cgw_remove_all_jobs(net);
+	list_for_each_entry(net, net_list, exit_list)
+		cgw_remove_all_jobs(net);
 	rtnl_unlock();
 }
 
 static struct pernet_operations cangw_pernet_ops = {
 	.init = cangw_pernet_init,
-	.exit = cangw_pernet_exit,
+	.exit_batch = cangw_pernet_exit_batch,
 };
 
 static __init int cgw_module_init(void)
-- 
2.35.0.263.gb82422642f-goog


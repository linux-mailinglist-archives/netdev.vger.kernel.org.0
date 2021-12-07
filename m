Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B500946AF71
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378798AbhLGAzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378794AbhLGAzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:37 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D8CC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:52:08 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u17so8233379plg.9
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Zc2YOENyna59s9F+jXNxajOLswRmrXDrTODOS7cUfE=;
        b=P8MZuJVO4rgFZLeJz2kmRBL29o8HFpajTyIcNWdSz5tT8EX7PSpVKUJ1YA97gDJclK
         bl8KKpLpakx5mokYsS8TBCy3EYkuHxXBDzp2dloJ0fJOOpmoayqPcrpYNiogEUsPu+Fi
         0IJCAN2ICB5drGJayXHu2K4RxR1qM3M0JAvij0vMFTYqcBx2o1UdEcO7qLZ2uZAEqqOK
         Zn+QepwwYOnaGAsqjCcGcIS2876oG8ctov8Bdd4+jfsHvFnvHAXWEoTRGtc5BRz+03Mt
         87OZPFM7AyDaqVnc2zzon4psUWARIkwJ8agCG59DrkUzLb2Ks4Qmli6cQ2va6XWHmGQJ
         8lNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Zc2YOENyna59s9F+jXNxajOLswRmrXDrTODOS7cUfE=;
        b=KvzpTZjNZk9ZuwoSH2XPbjzANKTuPe/Xli7oCMGoLcXlIvw9xldjxbrAP4qj5ijXyk
         7F9nxUFPhzanm0OWXdX1qcGoru1yOxi4wnXcMVWw78sy1iGzVqKRnQ+pf81VAVE4yeCD
         v4jqDuGEzo3vrMw4rh1OJqlFCH8BIBDTRhi+y/dxss4VIEhVsBtfOv+OxWMXP1jnPHTo
         +LBDcc9O89Hv5/IHHxJoMhFKpJscLGmM+54iOZWSt9BxK9UgNJqblHHLlkeElOidpoU6
         NoZIOXwcV0HWhCD0nvyEjDB2GKm9as8GZsEIAPKpwJxi5KmQ3cT8OfWApZElhIUHIr2m
         ILYQ==
X-Gm-Message-State: AOAM531UaIoRX2s9IPeauYJFw8l7YLc0dAIRuZ2qPeaKqqv8VY4igTb9
        VT4bb+BJB/9Q8ND9ZQaZTD6r64/yt7c=
X-Google-Smtp-Source: ABdhPJz8BtyLc6SJOrpjBNjoEele2FLkWs4wRACd1noydawaX2bc92Cgzyqbs8475nExh8JJfcwLEA==
X-Received: by 2002:a17:90a:df14:: with SMTP id gp20mr2540093pjb.186.1638838328189;
        Mon, 06 Dec 2021 16:52:08 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:52:07 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 11/17] SUNRPC: add netns refcount tracker to struct rpc_xprt
Date:   Mon,  6 Dec 2021 16:51:36 -0800
Message-Id: <20211207005142.1688204-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207005142.1688204-1-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/sunrpc/xprt.h | 1 +
 net/sunrpc/xprt.c           | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index 955ea4d7af0b2fea1300a46fad963df35f25810c..3cdc8d878d81122e3318447df4770100500403e4 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -284,6 +284,7 @@ struct rpc_xprt {
 	} stat;
 
 	struct net		*xprt_net;
+	netns_tracker		ns_tracker;
 	const char		*servername;
 	const char		*address_strings[RPC_DISPLAY_MAX];
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index a02de2bddb28b48bb6798327c0814e769314621b..5af484d6ba5e8bfb871768122009ee330c708c04 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1835,7 +1835,7 @@ EXPORT_SYMBOL_GPL(xprt_alloc);
 
 void xprt_free(struct rpc_xprt *xprt)
 {
-	put_net(xprt->xprt_net);
+	put_net_track(xprt->xprt_net, &xprt->ns_tracker);
 	xprt_free_all_slots(xprt);
 	xprt_free_id(xprt);
 	rpc_sysfs_xprt_destroy(xprt);
@@ -2027,7 +2027,7 @@ static void xprt_init(struct rpc_xprt *xprt, struct net *net)
 
 	xprt_init_xid(xprt);
 
-	xprt->xprt_net = get_net(net);
+	xprt->xprt_net = get_net_track(net, &xprt->ns_tracker, GFP_KERNEL);
 }
 
 /**
-- 
2.34.1.400.ga245620fadb-goog


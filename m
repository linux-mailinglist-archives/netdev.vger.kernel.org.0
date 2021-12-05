Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C21468923
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhLEE2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbhLEE2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:28:01 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44C3C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:24:34 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id m15so7092066pgu.11
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ueK711Sqj023gTBd/tQUmqv75JSIuZMHZ4ezZabzok=;
        b=SBT6l/3tFHmolDc3o0BxpXtBEsiB9t42vAt4dFEqVZsef3peqQ8KtKRPhjyP0oKvvK
         2mFCQ2fvggCEpPUaglHRWS5X8t7FvtgMkF0XDeKsh93/V8ann2jeFL8AaWDZ+nc2Ciu0
         wQzSBMbYfUE62q6aggFLsOt7j9uKSMwFobIasWHIFcZNOdz+eVd6QwF5je340RaNQfz1
         T/he6f3EifOxVQHtRMxoWLvI3oPod5YOp0NLbe84hWWndCL8LOmdOm+WnPNUE0JqNY7M
         Ir8p+MaoCDUCaVgn/mRBjB27UuJFUQJnNcxLAIRMbOaZiQTfbeAsqwREJaG+lVNuzLFk
         DWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ueK711Sqj023gTBd/tQUmqv75JSIuZMHZ4ezZabzok=;
        b=17hisdRiCkbB1PUyaGoXQ0GIt1QQrB9ZjDrzzpgtQjKv6RQ3LlgAjU5ihzL8f1+En6
         eS/6u+Nq/okcZTtlcmCW5wIFYPDPUNnVVGHu7zX9Io9buWiMLLJcslLtQBMHZ6eyG555
         aVTbUPp6KHjt68UUZ75ZiSb5DbmGbNTfThaON62fW/y17WZ6ZvLO01Whs9McGnb6QkjO
         ZiTs267FW645Oz7ZUTTHowxhqAZZIQrgnZQEZSxiTy32SqlSLeHqcRNenLY736q619rQ
         DxjRtud1hfN3CE5/BiwwJP8w1j40tsinOVEJ0dxKcA9R6QXCJz+gW5QcIYBfucue3x0B
         27TA==
X-Gm-Message-State: AOAM5308nJJ+u9x4J4MNp+godEm0xVB7cPkyBe4mX6DktyOlDHBp0LBP
        eKvU72DiMZgd0M7A+/Gnv0xrycn4Z5Q=
X-Google-Smtp-Source: ABdhPJzXadZKP4/0NAuzx7oYvY0Wcx7k0oDFxR9NoHS6zI0cEg84KoSkRYeMI7IFOttZk1c0M57jhA==
X-Received: by 2002:a62:d44f:0:b0:4ad:999d:2306 with SMTP id u15-20020a62d44f000000b004ad999d2306mr176869pfl.19.1638678274288;
        Sat, 04 Dec 2021 20:24:34 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:24:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 23/23] netpoll: add net device refcount tracker to struct netpoll
Date:   Sat,  4 Dec 2021 20:22:17 -0800
Message-Id: <20211205042217.982127-24-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/netconsole.c | 2 +-
 include/linux/netpoll.h  | 1 +
 net/core/netpoll.c       | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index ccecba908ded61370f8fc408ea53aa1ff305aca3..ab8cd555102083c2f0179898681489b987afe5b0 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -721,7 +721,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
 				__netpoll_cleanup(&nt->np);
 
 				spin_lock_irqsave(&target_list_lock, flags);
-				dev_put(nt->np.dev);
+				dev_put_track(nt->np.dev, &nt->np.dev_tracker);
 				nt->np.dev = NULL;
 				nt->enabled = false;
 				stopped = true;
diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index e6a2d72e0dc7a6929d32a2e994f24719e073121e..bd19c4b91e31204e85d30884720b761116d5c036 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -24,6 +24,7 @@ union inet_addr {
 
 struct netpoll {
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 	char dev_name[IFNAMSIZ];
 	const char *name;
 
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index edfc0f8011f88a7d46d69e94c6343489369fa78c..db724463e7cd5089d85d8f75a77ad83bbece82dc 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -776,7 +776,7 @@ int netpoll_setup(struct netpoll *np)
 	err = __netpoll_setup(np, ndev);
 	if (err)
 		goto put;
-
+	netdev_tracker_alloc(ndev, &np->dev_tracker, GFP_KERNEL);
 	rtnl_unlock();
 	return 0;
 
@@ -853,7 +853,7 @@ void netpoll_cleanup(struct netpoll *np)
 	if (!np->dev)
 		goto out;
 	__netpoll_cleanup(np);
-	dev_put(np->dev);
+	dev_put_track(np->dev, &np->dev_tracker);
 	np->dev = NULL;
 out:
 	rtnl_unlock();
-- 
2.34.1.400.ga245620fadb-goog


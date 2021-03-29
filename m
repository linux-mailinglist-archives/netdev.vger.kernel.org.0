Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7BA34D810
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 21:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhC2TZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 15:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhC2TZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 15:25:26 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716CDC061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 12:25:26 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f17so4887879plr.0
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 12:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tO8m3MHXqx64GGnYKe37wp1RmF5biVoA87KhNwuEcpI=;
        b=cHEPmwA8YsF6jxftS+4ZVTTZpH8GLFm7T3TTowc2jIkg1cVxgB6pA2PdZwbtRm5mTd
         xF8BKv4mPDy1V6SpoOaPPrjRuSliw6esd40G7Fu+rKWblumwviHZ7v0xAcZigOUJ1hG8
         jd3znYl1lORcn/D3QJxVp5x/cGZUBQHA1pEBzAT3puoljoN0Bwuz1RtXa/a5QPq9nYhg
         Vyq9trYYJEWCoAd+zOYhk8HMZ1hUQd62BoHqpt3+J+R4mTj9Hu2jN5ziit2Gco2mbyn6
         hRWnmBxPXnfqxHrh8bWWf/ghJH46HqNbhhGUjaHP2vEJU2wc2ymelHcLEpCRvoDthUxB
         jCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tO8m3MHXqx64GGnYKe37wp1RmF5biVoA87KhNwuEcpI=;
        b=W5P4pi4JBJf+ujvP/1ryGU7L1sTVYXj4tqsN0JrK3O4pTPooJ79QUK4A6ztJF8yYYs
         5WYMojkCgFn2vdF+8LMHZtNqQbd2z7/lIlN/64ogeBpHa9EEb7kxXBwHFPoiAPsrfc6S
         JroeBJkKvGc5eka6EMUWo+KLONRG5Mp9ro1bYeWHXs1jLI2oL92PfVAg5eY/4Fw6F99X
         esk2fjUFFc+qN+sBAbLAdeDADLrhc11M2TKjkpYUsL+jPBKMBV4gc6MHhAByEp59gQ0B
         HxJ3mORqYMfu9fxyvKptjyEEQY0/bBjFM0oTAbWqRjsvKxElGIsBR9MzGpElag1izdec
         7T2Q==
X-Gm-Message-State: AOAM533u2kKmx4iupW7/P2PrHBfpkhv/rGclPpCgoLyDtyxvlBa+VsnU
        VHJBwxlOvMHF0swpQQUZAAG0aHVQcKA=
X-Google-Smtp-Source: ABdhPJwlDiLqdvlFAewZk7AXlht6RTNwRElenB/TnUrtKzLWYewNyWA1jJfsQal0mDItxWdvQEEY2g==
X-Received: by 2002:a17:902:7888:b029:e6:b94d:c72 with SMTP id q8-20020a1709027888b02900e6b94d0c72mr31276242pll.8.1617045925981;
        Mon, 29 Mar 2021 12:25:25 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:78a0:7565:129d:828c])
        by smtp.gmail.com with ESMTPSA id w23sm10825464pgi.63.2021.03.29.12.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 12:25:25 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] sit: proper dev_{hold|put} in ndo_[un]init methods
Date:   Mon, 29 Mar 2021 12:25:22 -0700
Message-Id: <20210329192522.155336-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

After adopting CONFIG_PCPU_DEV_REFCNT=n option, syzbot was able to trigger
a warning [1]

Issue here is that:

- all dev_put() should be paired with a corresponding prior dev_hold().

- A driver doing a dev_put() in its ndo_uninit() MUST also
  do a dev_hold() in its ndo_init(), only when ndo_init()
  is returning 0.

Otherwise, register_netdevice() would call ndo_uninit()
in its error path and release a refcount too soon.

Fixes: 919067cc845f ("net: add CONFIG_PCPU_DEV_REFCNT")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/sit.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index b9bd2723f89a314d15c8c4ea785e84530c8acb95..488d3181aec3a5558dbefb6145400627535df761 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -218,8 +218,6 @@ static int ipip6_tunnel_create(struct net_device *dev)
 
 	ipip6_tunnel_clone_6rd(dev, sitn);
 
-	dev_hold(dev);
-
 	ipip6_tunnel_link(sitn, t);
 	return 0;
 
@@ -1456,7 +1454,7 @@ static int ipip6_tunnel_init(struct net_device *dev)
 		dev->tstats = NULL;
 		return err;
 	}
-
+	dev_hold(dev);
 	return 0;
 }
 
-- 
2.31.0.291.g576ba9dcdaf-goog


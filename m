Return-Path: <netdev+bounces-10254-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D961372D382
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D1BC280A71
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E6723437;
	Mon, 12 Jun 2023 21:49:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA6D23419
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8A7C433A1;
	Mon, 12 Jun 2023 21:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686606591;
	bh=szMwgfL0+algHJS4Avj5hiPA55zq4BSE+JA/s7KEm84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNGVq5MwVpznpSdg8m12C3if6wKO22TaQe1XR8Hg6tztf1doEP9G5q/wOa1h/D3C9
	 Ql5UXN4fBkx7yQe1ORlL4xCG6Tzw4y+EA+81SDGF8xQGi0WVXDDxGnHvidiJuFBxc0
	 GN2EmNd9GzSKHZCXX+6Dc++1k6THaW7+GgjUq2KCJlM5rsHqtGpQpGKbDhaAajlUIh
	 JY4kEuOjezZc+hc6rI34bDQBuR+2hbG6dhwnk/RhqziqgVx57mx+SE8ra1CHFI/xvE
	 e0k4NegvynMGP3x+yHINqOMj+LK7PagfufZSwTB3alPHqEHDqkHyzFMYejHoioPPs/
	 wVLp8p9JI4tpQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	dsahern@gmail.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 2/2] netpoll: allocate netdev tracker right away
Date: Mon, 12 Jun 2023 14:49:44 -0700
Message-Id: <20230612214944.1837648-3-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612214944.1837648-1-kuba@kernel.org>
References: <20230612214944.1837648-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 5fa5ae605821 ("netpoll: add net device refcount tracker to struct netpoll")
was part of one of the initial netdev tracker introduction patches.
It added an explicit netdev_tracker_alloc() for netpoll, presumably
because the flow of the function is somewhat odd.
After most of the core networking stack was converted to use
the tracking hold() variants, netpoll's call to old dev_hold()
stands out a bit.

np is allocated by the caller and ready to use, we can use
netdev_hold() here, even tho np->ndev will only be set to
ndev inside __netpoll_setup().

Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/netpoll.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index e6a739b1afa9..543007f159f9 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -690,7 +690,7 @@ int netpoll_setup(struct netpoll *np)
 		err = -ENODEV;
 		goto unlock;
 	}
-	dev_hold(ndev);
+	netdev_hold(ndev, &np->dev_tracker, GFP_KERNEL);
 
 	if (netdev_master_upper_dev_get(ndev)) {
 		np_err(np, "%s is a slave device, aborting\n", np->dev_name);
@@ -783,12 +783,11 @@ int netpoll_setup(struct netpoll *np)
 	err = __netpoll_setup(np, ndev);
 	if (err)
 		goto put;
-	netdev_tracker_alloc(ndev, &np->dev_tracker, GFP_KERNEL);
 	rtnl_unlock();
 	return 0;
 
 put:
-	dev_put(ndev);
+	netdev_put(ndev, &np->dev_tracker);
 unlock:
 	rtnl_unlock();
 	return err;
-- 
2.40.1



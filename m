Return-Path: <netdev+bounces-9663-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A223172A250
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1C4E1C2118E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B360E1C756;
	Fri,  9 Jun 2023 18:32:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B397121CED
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EC9C433EF;
	Fri,  9 Jun 2023 18:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686335532;
	bh=Pz/uKyMd1yCPOMCJBcImYEWkA1hmpBM66VbKWgJFh6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxHYoc6zFE2xaxN+u/28VNgHjaZ5kv9kUqjavZtF1SjAGYrpVlepekFuNJF8nkJkF
	 T4WiI1meHJtMCFFBxEtuj899B//Cm/Wu2BGNX22JpN+WQYlC/6fyLXb6zQyenpBVrT
	 gnSoPoF2HHcMZwKUvizKqJOUMxd+Fm6/sg7Ks39FAdiYDUNYWddY3EOnhWMTXLPNhv
	 ub06ugdj2CfPgOxrEjanNkar0MJKevu2dStBMyvvFbWJt9u2NflOfqdhsvcc/LyVjk
	 7FYGVXJJNDBfzP5putexXxaeYAAkytuhZ7QfJ33yIRt3b1hBOcQu4TFZHvSy+aDk1r
	 XICNW7R+QDUGw==
From: Jakub Kicinski <kuba@kernel.org>
To: edumazet@google.com
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	dsahern@gmail.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/2] netpoll: allocate netdev tracker right away
Date: Fri,  9 Jun 2023 11:32:07 -0700
Message-Id: <20230609183207.1466075-3-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609183207.1466075-1-kuba@kernel.org>
References: <20230609183207.1466075-1-kuba@kernel.org>
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



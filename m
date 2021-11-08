Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A1E449A7C
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241443AbhKHRJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241435AbhKHRJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:09:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5159E6120A;
        Mon,  8 Nov 2021 17:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391191;
        bh=vrkWS8dSoKj7+JKqr8tyoShQuRQcy6UOFt1Z4PjeZg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDgPaE+ePTNmz7w4OmcW/ZkXiS8AhVNedCkWfqxnVYvwVkGQGkf9sx6KeNvWLYYKn
         s5gbvoib3V9wS6V5FQvJjXsX3c03Mw3PlX+b9jLKLPZ4ho648JbE4LzL6Ff3rd0UZE
         /TUUKlUjNUjlizfKIEbHsv96xWYWPinRWbYGIgY56RlX3NkuYqobuUbWv7/MYN1QJj
         EVIBwpHY8XS9oD4N/aEK89YPuHoKGaz8z65u3py/Cgp7qCdHA2/WkTqAPF+bvCQJI9
         bJ5WkrLj9zPPMd8Tbb+OOAq8azrjisEfW9sTgq7wF87c3n8puDFdP0LbQXrCR339rL
         DBuz1m818Yjsg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 14/16] devlink: Require devlink lock during device reload
Date:   Mon,  8 Nov 2021 19:05:36 +0200
Message-Id: <ad7f5f275bcda1ee058d7bd3020b7d85cd44b9f6.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devlink reload was implemented as a special command which does _SET_
operation, but doesn't take devlink->lock, while recursive devlink
calls that were part of .reload_up()/.reload_down() sequence took it.

This fragile flow was possible due to holding a big devlink lock
(devlink_mutex), which effectively stopped all devlink activities,
even unrelated to reloaded devlink.

So let's make sure that devlink reload behaves as other commands.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 60af6a3fc130..32d274bfd049 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8771,7 +8771,6 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_reload,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PARAM_GET,
@@ -11462,6 +11461,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 		if (!net_eq(devlink_net(devlink), net))
 			goto retry;
 
+		mutex_lock(&devlink->lock);
 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
 		err = devlink_reload(devlink, &init_net,
 				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
@@ -11469,6 +11469,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 				     &actions_performed, NULL);
 		if (err && err != -EOPNOTSUPP)
 			pr_warn("Failed to reload devlink instance into init_net\n");
+		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
 	}
-- 
2.33.1


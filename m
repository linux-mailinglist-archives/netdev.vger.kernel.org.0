Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF71B468A18
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 09:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhLEIZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 03:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbhLEIZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 03:25:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129CAC0613F8;
        Sun,  5 Dec 2021 00:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A807160F91;
        Sun,  5 Dec 2021 08:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4687DC341C1;
        Sun,  5 Dec 2021 08:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638692546;
        bh=NW0OQuz1qc4Rr/SVLbzVXNHnayMO+eO5mqj/mSQG5uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnGVX9/ACRE1eFgYi0IPwx3vQFNgf9cdJFT2Uq2y2rqdLpwdVpz5WmPuDo9+phYxd
         PpfzAa04wqJiprs3YnvetWzDeY1zRNeOK/lSKqqvsBdsPHfkocTfKxsebJaDP6WnQa
         JWKNjqVrPFji2lACCq90H0+yn9JOHa/8sSaCTN6TcartQezPiO5HnyyMcQQyE9RMAn
         AXiuGYPu42SK/e12c2uF1cmMpE1tWhmiqH8Z0bJpPkbzNfCAb2EJ84YAglkgissOYQ
         0UH87V/jG5GEkpzULXXcA3epopdkax3s8GLibakgpgpzVmOGNL1GNVOboXH9/+KQ8u
         x8opRN3RL/y1Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 4/6] devlink: Require devlink lock during device reload
Date:   Sun,  5 Dec 2021 10:22:04 +0200
Message-Id: <d9bc1d4d54a647020fe853abe5f93bcfd30b6bc1.1638690564.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1638690564.git.leonro@nvidia.com>
References: <cover.1638690564.git.leonro@nvidia.com>
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

Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7dd6091b97af..cbffafc1776f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8810,7 +8810,6 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_reload,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PARAM_GET,
@@ -11448,10 +11447,15 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 			goto retry;
 
 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
+
+		mutex_lock(&devlink->lock);
+		xa_set_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK);
 		err = devlink_reload(devlink, &init_net,
 				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
 				     DEVLINK_RELOAD_LIMIT_UNSPEC,
 				     &actions_performed, NULL);
+		xa_clear_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK);
+		mutex_unlock(&devlink->lock);
 		if (err && err != -EOPNOTSUPP)
 			pr_warn("Failed to reload devlink instance into init_net\n");
 retry:
-- 
2.33.1


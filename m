Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC04445BB62
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 13:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242370AbhKXMTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 07:19:22 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37767 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243066AbhKXMRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 07:17:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2EA1C5C009F;
        Wed, 24 Nov 2021 07:14:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 24 Nov 2021 07:14:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Vk1NIusawVeGtXkYl
        1sbngtRrfsptzyA6ZVWDvbEnqo=; b=CkBGLrbx9VdOGNqnjJmTMTg/EWT07Re9O
        k6XZEcyFyrB6v5lFrYXCtH8pNiB8622FK+GAME5fVNtm6eKi5/EOmxxg86kCSQbs
        ikQhHp9G2Nv/wyfKxJtuFsX/oegPERq0iDAWuc/6V/S3R96TTv9y3YS9x5mUL58k
        xIajUNgue6XpYJ45qoCbtZNLwD2gJTxg6/ICBZMAuJ/OaPcCgWgLqmY3uJqegDm8
        f+ZpLh+xz0bz/0XlPHFAfbgU6yq3aA6Y0ZcBmtUQWti/3j1wZJv30B5E9tYLhm0L
        9PVmMmod93Yh+/WXu/SAQiJFFrmxDLzVJku5sX7rN05OYhw/lbQjw==
X-ME-Sender: <xms:nSyeYdYxTi1OBZPXInS3qeuoJRW2mrLTaAj0ufrtuvLlJkHz9RC1VQ>
    <xme:nSyeYUaYT1hBhbJiWsZ0eavz20zUV8ncMaSrBxcphsJVNCG3lcyR3mwQH1Wo9hfY0
    R3kmOkbY9EudcM>
X-ME-Received: <xmr:nSyeYf8RmygaktJQIgZSZyZNcmUSgIy7xL_WB3LvlFN0b0JBlTU-Y-WOtngijnOIfiAWORAqh37Y005fJ7rUFsbdBoVSm00ngBKS1gFSv3V5Xg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeekgdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:nSyeYbovKZq4E78Ew_8_Va8Jvw1ZqIyBFFowSuVnXy-wKHhwMa0tlg>
    <xmx:nSyeYYoyJiwNhCD1OWgA2nnCkP7eS1aU2ZBvvgome6itmQquudOK9A>
    <xmx:nSyeYRQdyuESwEUz7P0cOdxrhLJr7FZrd0bYZpRs2grQy3vRuLpXXA>
    <xmx:niyeYf1GDStcyKIkeG75jUiwG4nSBb7XQwj4Tp8tz1Jv3m-6Xd_a4A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Nov 2021 07:14:20 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool] cable-test: Fix premature process termination
Date:   Wed, 24 Nov 2021 14:14:06 +0200
Message-Id: <20211124121406.3330950-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Unlike other ethtool operations, cable testing is asynchronous which
allows several cables to be tested simultaneously. This is done by
ethtool instructing the kernel to start the cable testing and listening
to multicast notifications regarding its progress. The ethtool process
terminates after receiving a notification about the completion of the
test.

Currently, ethtool processes all the cable test notifications,
regardless of the reported device. This means that an ethtool process
started for one device can terminate prematurely if completion was
reported for a different device.

Fix by ignoring notifications for devices other than the device for
which the test was started.

Fixes: 55f5e9aa3281 ("Add cable test support")
Fixes: 9561db9b76f4 ("Add cable test TDR support")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 netlink/cable_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/netlink/cable_test.c b/netlink/cable_test.c
index 17139f7d297d..9305a4763c5b 100644
--- a/netlink/cable_test.c
+++ b/netlink/cable_test.c
@@ -225,6 +225,7 @@ static int nl_cable_test_process_results(struct cmd_context *ctx)
 	nlctx->is_monitor = true;
 	nlsk->port = 0;
 	nlsk->seq = 0;
+	nlctx->filter_devname = ctx->devname;
 
 	ctctx.breakout = false;
 	nlctx->cmd_private = &ctctx;
@@ -496,6 +497,7 @@ static int nl_cable_test_tdr_process_results(struct cmd_context *ctx)
 	nlctx->is_monitor = true;
 	nlsk->port = 0;
 	nlsk->seq = 0;
+	nlctx->filter_devname = ctx->devname;
 
 	ctctx.breakout = false;
 	nlctx->cmd_private = &ctctx;
-- 
2.31.1


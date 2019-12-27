Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C425212B896
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfL0R4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbfL0Rl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DE38222C2;
        Fri, 27 Dec 2019 17:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468517;
        bh=gmBAUI7uG/uiwVFr+rL5G03OOUX3wJAo+A3ELNJus/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aS4bQzOmSDIPh4YwUuIJQPQhJlOe66hAuc6rs+S83A+IynYVQaLn2NOO90HibGPIO
         p8SCMeE8Ak125PDB6d+5Ftz29wmq8fYR3HSrs+m+KSYUcfFkKIUJ4B3gB/TAlpShMI
         DLuhm4zMDrL3BO/xOgOQmfnZCtT2JvwKQ6r6SCbI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 049/187] mlxsw: spectrum_router: Remove unlikely user-triggerable warning
Date:   Fri, 27 Dec 2019 12:38:37 -0500
Message-Id: <20191227174055.4923-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 62201c00c4679ad8f0730d6d925a5d23651dfad2 ]

In case the driver vetoes the addition of an IPv6 multipath route, the
IPv6 stack will emit delete notifications for the sibling routes that
were already added to the FIB trie. Since these siblings are not present
in hardware, a warning will be generated.

Have the driver ignore notifications for routes it does not have.

Fixes: ebee3cad835f ("ipv6: Add IPv6 multipath notifications for add / replace")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 39d600c8b92d..210ebc91d3d6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5637,8 +5637,13 @@ static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
 	if (mlxsw_sp_fib6_rt_should_ignore(rt))
 		return;
 
+	/* Multipath routes are first added to the FIB trie and only then
+	 * notified. If we vetoed the addition, we will get a delete
+	 * notification for a route we do not have. Therefore, do not warn if
+	 * route was not found.
+	 */
 	fib6_entry = mlxsw_sp_fib6_entry_lookup(mlxsw_sp, rt);
-	if (WARN_ON(!fib6_entry))
+	if (!fib6_entry)
 		return;
 
 	/* If not all the nexthops are deleted, then only reduce the nexthop
-- 
2.20.1


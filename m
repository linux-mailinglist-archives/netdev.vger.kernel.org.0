Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED14116737
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 07:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfLIG4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 01:56:17 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58407 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726927AbfLIG4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 01:56:16 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 10801229DC;
        Mon,  9 Dec 2019 01:56:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 09 Dec 2019 01:56:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=h0l8AN5u6Jpu/Fpss
        yMYxRGh10mpV6vi68Gza9wsFJ0=; b=prsknA7kSCueFwXJFQpZrwTBsHKWb22Do
        OrM8k3GcwBZQn8+IFPnd9ggc9hXeiTEnoAbu8twLdgia+mvweCNyRlDw5V9wW9df
        JjJHtiU2AfTErDiz0RhoS+UD5njcBN1nnu3k5/OwH0/OMZoR+hvnXpzfOcx6FxhL
        1bRhUEab9xZvI5UutAuVs8ztcVQveSmeeCZB5emnoW8g9gNu+NGJ3v8xwKLXGpnn
        jOH64YO6GHFVvTcbKiSUr9uhHau4GW7VYnNqdl+4Bm4HNBYNiuNxe+v8RWXvmfhh
        uh6/hcber3vfy/5YW/Gniq1IZw/uuhmwHyU2K5b42w2pnrOLtYovA==
X-ME-Sender: <xms:D_DtXcw1n2aPwkKEO4qWU1PUdZ1OOw2J8l3J67LfiLFlwzf_kx1FSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekledgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:D_DtXTuOEHFQeWkxNVmRx4RdxTDF2liH6-ghDq3VEOCO_WIWQCHsOQ>
    <xmx:D_DtXaltDOrGjY50aIg1SBcA0DPXFhxh-4DS1SSxaCV8dMFG0V7SYg>
    <xmx:D_DtXTg26lyeGCJ3PHkAevKPDYEDL0ytvW8S5psC1P_16pqFJiM0GA>
    <xmx:EPDtXdrHxIvLtxWlYlWa1UUo56fO0uynMddvNirOU4s_L44Y1UpgWg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C360230600AB;
        Mon,  9 Dec 2019 01:56:14 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: spectrum_router: Remove unlikely user-triggerable warning
Date:   Mon,  9 Dec 2019 08:55:20 +0200
Message-Id: <20191209065520.337136-1-idosch@idosch.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In case the driver vetoes the addition of an IPv6 multipath route, the
IPv6 stack will emit delete notifications for the sibling routes that
were already added to the FIB trie. Since these siblings are not present
in hardware, a warning will be generated.

Have the driver ignore notifications for routes it does not have.

Fixes: ebee3cad835f ("ipv6: Add IPv6 multipath notifications for add / replace")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 30bfe3880faf..08b7e9f964da 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5742,8 +5742,13 @@ static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
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
2.23.0


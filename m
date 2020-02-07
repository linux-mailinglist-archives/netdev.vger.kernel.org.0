Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF25D155CCC
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgBGR1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:27:20 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43351 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727047AbgBGR1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:27:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8CDB021ACF;
        Fri,  7 Feb 2020 12:27:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 07 Feb 2020 12:27:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=rQsmgsWnUCmau8gPbwjnTUcwQXYyz4FylIRPAtD/aQQ=; b=rLhBve2y
        FUlSB84RLQeMk/ePWzqL8UG2Q4hVCnGmhJZUOAiQ+97G2qCA+Kx+Q1+sOh3Dcu8X
        6pbQeoURToOX7981WQhwoFHKZUNzMLbCjrahTzgmBVPUq/TfRSXmJ7Zd/YBgQt9h
        Kb+BukYarGBVG8WX9F+bQaTaVF7hzg5YjO86d1+bq0wuKkdMW5fO/Oswsgm5x4KA
        ZQ+Pm+QiTJd9w+Lt3uhGodLSvuJrPFCIg4Nb29LVMsEaJ4jOLcpNy8LAUsxdOMyx
        Ky/xz31pJwmjV+YAQ2GrD4qvFSwgLMF61HwjGVehfEKV/Lh0TAa77ZFgUTSV6Bk0
        OeROzh8/Sa31hw==
X-ME-Sender: <xms:9509Xn87iB6faVlxI_lwG19PQDcbM0mT9N4X-79MVBHuZBycGtVFeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedruddtjedruddvtdenucevlhhushhtvg
    hrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:9509Xn9krgHru2bi1TKK9wgLGNGgclZLXu76zDEaLDwWqjNqY0vRJA>
    <xmx:9509XgDRSe7tMnCwYfsTrvJdHxe8FMFXxGek33dVXx2Ouf8R_FdBhg>
    <xmx:9509XnwGM4LIwGrrgqtHyYJC_sDvo-uwL2qyS0l4Ue3eqdNQlv9fug>
    <xmx:9509Xrsi-0xWWmaTgV785kxIa5HyRLcouG942O-RWwm0hbfdZY47Qg>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DD8430607B0;
        Fri,  7 Feb 2020 12:27:17 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 5/5] mlxsw: spectrum_dpipe: Add missing error path
Date:   Fri,  7 Feb 2020 19:26:28 +0200
Message-Id: <20200207172628.128763-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207172628.128763-1-idosch@idosch.org>
References: <20200207172628.128763-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In case devlink_dpipe_entry_ctx_prepare() failed, release RTNL that was
previously taken and free the memory allocated by
mlxsw_sp_erif_entry_prepare().

Fixes: 2ba5999f009d ("mlxsw: spectrum: Add Support for erif table entries access")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index 49933818c6f5..2dc0978428e6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -215,7 +215,7 @@ mlxsw_sp_dpipe_table_erif_entries_dump(void *priv, bool counters_enabled,
 start_again:
 	err = devlink_dpipe_entry_ctx_prepare(dump_ctx);
 	if (err)
-		return err;
+		goto err_ctx_prepare;
 	j = 0;
 	for (; i < rif_count; i++) {
 		struct mlxsw_sp_rif *rif = mlxsw_sp_rif_by_index(mlxsw_sp, i);
@@ -247,6 +247,7 @@ mlxsw_sp_dpipe_table_erif_entries_dump(void *priv, bool counters_enabled,
 	return 0;
 err_entry_append:
 err_entry_get:
+err_ctx_prepare:
 	rtnl_unlock();
 	devlink_dpipe_entry_clear(&entry);
 	return err;
-- 
2.24.1


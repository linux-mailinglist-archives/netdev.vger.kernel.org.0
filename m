Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90CDA15E844
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404380AbgBNQRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404370AbgBNQRE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98A312468E;
        Fri, 14 Feb 2020 16:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697024;
        bh=smrU8bTa66F+naWfmVva/DjmuBGo4kVOAHEGAmdFYWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KT1rKIbeCJJjsVZZkzmyZUFDMuisedfQAZygoKKmpIBpVGXLNnedcNGqJvldi2APm
         72wT6prEcDZidKyfyrzeQveOUdB4bhP5Ugq5o/3Wt/y4rK5z4xGpdVcU1Y6UATUQJA
         kCCPAwjk4nJG4HwTNbCqQ96S1Jj3jBH9AAZ7cXtE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 252/252] mlxsw: spectrum_dpipe: Add missing error path
Date:   Fri, 14 Feb 2020 11:11:47 -0500
Message-Id: <20200214161147.15842-252-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 3a99cbb6fa7bca1995586ec2dc21b0368aad4937 ]

In case devlink_dpipe_entry_ctx_prepare() failed, release RTNL that was
previously taken and free the memory allocated by
mlxsw_sp_erif_entry_prepare().

Fixes: 2ba5999f009d ("mlxsw: spectrum: Add Support for erif table entries access")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index 41e607a14846d..4fe193c4fa55d 100644
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
2.20.1


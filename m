Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256CC15E632
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405345AbgBNQVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:21:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405340AbgBNQVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:21:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A16272469F;
        Fri, 14 Feb 2020 16:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697273;
        bh=P7PcwhEQKc9dJYLWA5Sy97y0Q0hHiop6lLN4kdBC4fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLjd52hxrLCKxIrJ+0kKyfM1QSI4Mz1G4FziT7HLgRbTu+TyiDFrE0co9cVvAr0hC
         Hj6MDxkfdoKBiahU1oHWY+zM6bt89hzxLa+wW3jdfCm9LvZgd3NG/L6pC3x+Pj3uAO
         Kvu0Sl7Tm3sC26Z4EFHfNsU/lgMZ+Nmq2jNsDGw0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 186/186] mlxsw: spectrum_dpipe: Add missing error path
Date:   Fri, 14 Feb 2020 11:17:15 -0500
Message-Id: <20200214161715.18113-186-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
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
index 51e6846da72bc..3c04f3d5de2dc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -225,7 +225,7 @@ mlxsw_sp_dpipe_table_erif_entries_dump(void *priv, bool counters_enabled,
 start_again:
 	err = devlink_dpipe_entry_ctx_prepare(dump_ctx);
 	if (err)
-		return err;
+		goto err_ctx_prepare;
 	j = 0;
 	for (; i < rif_count; i++) {
 		struct mlxsw_sp_rif *rif = mlxsw_sp_rif_by_index(mlxsw_sp, i);
@@ -257,6 +257,7 @@ mlxsw_sp_dpipe_table_erif_entries_dump(void *priv, bool counters_enabled,
 	return 0;
 err_entry_append:
 err_entry_get:
+err_ctx_prepare:
 	rtnl_unlock();
 	devlink_dpipe_entry_clear(&entry);
 	return err;
-- 
2.20.1


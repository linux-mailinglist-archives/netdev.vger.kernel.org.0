Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D895165836
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgBTHIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:41 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45187 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbgBTHIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:38 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A3792108A;
        Thu, 20 Feb 2020 02:08:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=nE6/V0Wcq+Ik8Kzq/MlARTZTCl9Zknr6HVkkHTnMqS8=; b=s1Xltd43
        myduUkFHWIMVVnJcRjMaRLPesGXlHTrH7fm3Vv7XroTyu0Mul9UxU9/WLo4MO/Hb
        Yyb6psCyg5orGYY3QW6G88b38iv6/a9lFw171nAqlsORJRulUJFeH0RIM+I8S0ef
        v53njQYkJ4jmW3ql3DLByw509wAsfDO27qCXkG5qktg+tyQ61CS1gMEdF/gUsWgq
        /CnTqHghYN0DdX9zOMyW9DpuQ1dDqzervAOFyXaqo317pvU1SZb5TE5k1DWo2goQ
        4M0csAcFjGNfH608Ok24gE60jPaix7MWMRu04MDP/3nZnegrB5LVaZM++s+WyUrd
        14Q+c7+cr2g0Qg==
X-ME-Sender: <xms:dTBOXrF3TjQHAEYpAiQQu2JBM4AZC2rpbqlJnZPAcFmruK0Y-vILXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpedugeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:dTBOXuFBRIULDAi0PzmccTUIoMcjOP6gUULNWna24ENU22G9-LH9wg>
    <xmx:dTBOXj_U2l-6xYuqHdypcdrh98JQUEdrk8iYyZseIZVVudgQ67Bw8w>
    <xmx:dTBOXgSQgXKP6kuyVTxQZfu_nG-nGc11TPLALraM4Xcd4Sjpk_Smgg>
    <xmx:djBOXjppLVBRzGRtkNl5su5bPuMi6ipGr4lzUN2qk_gpWpW1zB0YHg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB3573060D1A;
        Thu, 20 Feb 2020 02:08:36 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 15/15] mlxsw: spectrum_nve: Make tunnel initialization symmetric
Date:   Thu, 20 Feb 2020 09:08:00 +0200
Message-Id: <20200220070800.364235-16-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220070800.364235-1-idosch@idosch.org>
References: <20200220070800.364235-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The device supports a single VTEP whose configuration is shared between
all VXLAN tunnels.

While the shared configuration is cleared upon the destruction of the
last tunnel - in mlxsw_sp_nve_tunnel_fini() - it is set in
mlxsw_sp_nve_fid_enable(), after calling mlxsw_sp_nve_tunnel_init().

Make tunnel initialization and destruction symmetric and set the
configuration in mlxsw_sp_nve_tunnel_init().

This will later allow us to protect the shared configuration with a
lock.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index 16a130c2f21c..eced553fd4ef 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -744,6 +744,8 @@ static int mlxsw_sp_nve_tunnel_init(struct mlxsw_sp *mlxsw_sp,
 	if (nve->num_nve_tunnels++ != 0)
 		return 0;
 
+	nve->config = *config;
+
 	err = mlxsw_sp_kvdl_alloc(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
 				  &nve->tunnel_index);
 	if (err)
@@ -760,6 +762,7 @@ static int mlxsw_sp_nve_tunnel_init(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
 			   nve->tunnel_index);
 err_kvdl_alloc:
+	memset(&nve->config, 0, sizeof(nve->config));
 	nve->num_nve_tunnels--;
 	return err;
 }
@@ -840,8 +843,6 @@ int mlxsw_sp_nve_fid_enable(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_fid *fid,
 		goto err_fid_vni_set;
 	}
 
-	nve->config = config;
-
 	err = ops->fdb_replay(params->dev, params->vni, extack);
 	if (err)
 		goto err_fdb_replay;
-- 
2.24.1


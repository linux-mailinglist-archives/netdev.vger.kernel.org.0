Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E18B77AC6
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 19:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387974AbfG0Rdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 13:33:52 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56999 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725262AbfG0Rdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 13:33:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 49732210D8;
        Sat, 27 Jul 2019 13:33:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 27 Jul 2019 13:33:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=mUA4HhTXU4QqyX0DdE6d58Wy+ePADDkd2PKVwmyQrvA=; b=tVvON68w
        iNF7+5pIXK8oPYW/JB0hdjv8yCCW1VSf06ysbtGxZEvMjTMJJRoULNMzj8BeSyhL
        Ghjv+5tMsCAEObqkP4zKYLw0Xd+GOELpxHIfHuvgHCToLr1anKkH+Fd5tltEk5xG
        +uSWzrkQJNUOrQhtIROtvFI+8GRoI9iiuqp0ar1/4hME6OEiJnWt+O7Mw927yxgE
        1odYuCn0fD5i/KG5Yy4rowL/6WKUqfYMZiZzHA0lr8ebPZZoghnUMDNZbhB910rH
        m9+YYylixO879aWDKsWyeODspvEvKt+mW69D9omaJ6BCK/tmVVriXVrzr7bDiUj3
        YJzqvbYqFVwvYA==
X-ME-Sender: <xms:_oo8XaahhG_4Vzb6ITSxo9Rt-qPrS2Ohgo7hgyL1875b2QqsrC5m5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeigdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejjedrudefkedrvdegledrvddtleenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:_oo8XYHsnXJO7ILqM778QNqibiuqwwbhY9IXeG4XJfRcpQMGhPt3fQ>
    <xmx:_oo8XY8bcDaix8eSyQWEwC6eubvfVvXfLZon17QWID87LYvSfLoBzg>
    <xmx:_oo8XdWB7oxX6evyyWjRZoXgy5X5bgDiGy_2amwz4evyqcsbOaKBuA>
    <xmx:_oo8XfVhbQHyZFNN-E9Tz8Re4phLMbPy_MneP4KXJyYNO0I3j2D3kg>
Received: from splinter.mtl.com (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B9B4380084;
        Sat, 27 Jul 2019 13:33:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/3] mlxsw: spectrum_flower: Forbid to offload mirred redirect on egress
Date:   Sat, 27 Jul 2019 20:32:55 +0300
Message-Id: <20190727173257.6848-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190727173257.6848-1-idosch@idosch.org>
References: <20190727173257.6848-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Spectrum ASIC does not support redirection on egress, so refuse to
insert such flows:

$ tc qdisc add dev ens16np1 clsact
$ tc filter add dev ens16np1 egress protocol all pref 1 handle 101 flower skip_sw action mirred egress redirect dev ens16np2
Error: mlxsw_spectrum: Redirect action is not supported on egress.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 202e9a246019..1eeac8a36ead 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -78,6 +78,11 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 			struct mlxsw_sp_fid *fid;
 			u16 fid_index;
 
+			if (mlxsw_sp_acl_block_is_egress_bound(block)) {
+				NL_SET_ERR_MSG_MOD(extack, "Redirect action is not supported on egress");
+				return -EOPNOTSUPP;
+			}
+
 			fid = mlxsw_sp_acl_dummy_fid(mlxsw_sp);
 			fid_index = mlxsw_sp_fid_index(fid);
 			err = mlxsw_sp_acl_rulei_act_fid_set(mlxsw_sp, rulei,
-- 
2.21.0


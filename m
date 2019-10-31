Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69333EACB6
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfJaJmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:42:53 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58537 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727235AbfJaJmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:42:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 657C721FE5;
        Thu, 31 Oct 2019 05:42:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=SN1wd1SkqO0eZUAhDmdsCaX8bPit1vCGOkRvegEyzz4=; b=lS5vqsqq
        wwuXlSQhZ22rzpO2MXCaTO27DtSXGjHpjMWtfnxsTLpLf3rfx5K+lmDA3wn+6vWv
        NXGMsv45dq1ZYuDqh0lUeN1JcFhAAynpY8+opeOWBQs013/mHz0Vlg/3etPGxmno
        MJ1wOO+7go4WfG2IcLEmuTEHU7YT/jMoFFcqeCZ8PnTnA51mCktwERivi2T7szfA
        jlN7id20waOSElhJeSy24jgQgE9zoyZe9Yq6RDcJQ2XHRPrSXuWXtCWfKyTeUWaJ
        IMWK91XSkueq2Ed55S15YJpmQM0Bc0sPuqrDtIVF81KXQNWXM1MgPeyHXsrKfkoq
        pzEhfoBzNTlrcA==
X-ME-Sender: <xms:mqy6XcERA3zIcJjtoQXp7nA7I_GW4lNgkbzx-X7BI_TH6BbFmgm4hA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:mqy6XcT2wERkDgXM7ZVJcH29dxqqFnyP5b0lWKyH0wcFrOnumdRqgQ>
    <xmx:mqy6XcnUTaT-YI2r5yLQgk_8iBT9Gm7pJ5pr6NdCWuBSyTbBbEEzuA>
    <xmx:mqy6Xck4D5v56jfWY4_-tnRyKVvlwg-OliYcndC0VF-82hxE3RVfWg>
    <xmx:m6y6XXF0SlfIu3rh2imWxbnOR50SjuAiIOVy1cGP13VNgFToLAHgVg>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5155D80064;
        Thu, 31 Oct 2019 05:42:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/16] mlxsw: spectrum: Distinguish between unsplittable and split port
Date:   Thu, 31 Oct 2019 11:42:10 +0200
Message-Id: <20191031094221.17526-6-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031094221.17526-1-idosch@idosch.org>
References: <20191031094221.17526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently when user does split, he is not able to distinguish if the
port cannot be split because it is already split, or because it cannot
be split at all. Add another check for split flag to distinguish this.
Also add check forbidding split when maximal width is 1.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index e0111e0a1a35..3644fca096ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4118,6 +4118,13 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return -EINVAL;
 	}
 
+	/* Split ports cannot be split. */
+	if (mlxsw_sp_port->split) {
+		netdev_err(mlxsw_sp_port->dev, "Port cannot be split further\n");
+		NL_SET_ERR_MSG_MOD(extack, "Port cannot be split further");
+		return -EINVAL;
+	}
+
 	module = mlxsw_sp_port->mapping.module;
 
 	max_width = mlxsw_core_module_max_width(mlxsw_core,
@@ -4128,10 +4135,10 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return max_width;
 	}
 
-	/* Split port with non-max module width cannot be split. */
-	if (mlxsw_sp_port->mapping.width != max_width) {
-		netdev_err(mlxsw_sp_port->dev, "Port cannot be split further\n");
-		NL_SET_ERR_MSG_MOD(extack, "Port cannot be split further");
+	/* Split port with non-max and 1 module width cannot be split. */
+	if (mlxsw_sp_port->mapping.width != max_width || max_width == 1) {
+		netdev_err(mlxsw_sp_port->dev, "Port cannot be split\n");
+		NL_SET_ERR_MSG_MOD(extack, "Port cannot be split");
 		return -EINVAL;
 	}
 
-- 
2.21.0


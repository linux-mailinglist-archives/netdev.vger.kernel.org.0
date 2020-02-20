Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D921165832
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgBTHIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:34 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45405 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726856AbgBTHIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 40EA221ACE;
        Thu, 20 Feb 2020 02:08:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=C+CN+mii/6+Ixf7I/k9EsbrmltvlaDD2duFR75TACVE=; b=aCBpArhp
        QWcL0H8/287t8wF/OA+EmYCZAor/YvYsKzkZ5a+BZGxMM0OqlotooJvibfRgaxz4
        25owxnpp8USZ+a9gn+WiSfsAZbF/v7HUeP1uy4QBt+KkLzjeZKlFEG3cRyK/PZ6L
        R1gKlrdUHWvgJ6B96LvWxJQEt4FQ4eQy8vBgHfgHNvgLjRZMXKe+sdKzVcWd+hMs
        //uQT9P505SjiOczeLdxo3GKS4qrx9W2SO8e4OAW9YyvSpkFfn287NBP4OlLCFgw
        x38fJdZ/lfPm3x/FtXOpYv+YOdMpYwSJGhyOuxwQIBRhX9JSOinmI3gtTz6p06k8
        GjzvBc1fKI+EZw==
X-ME-Sender: <xms:cTBOXmvr8Lry6_OvON7mUtp4YFFMRfmTEhiSQizOQO1FJRtb5bBBVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:cTBOXrp6D5qxaiZUvnQp9kNL26duCliQ0ud1muwMPhbdG4pNIlgH7Q>
    <xmx:cTBOXkbCNUSOyikePZxEh4uCcJjD7HL2JTE-skm3R5ZP0DuA0Pussg>
    <xmx:cTBOXsySdnpKBaaMwN0FaJTXw98liL76dSABgcdcE_acPig9JynENg>
    <xmx:cTBOXnvAk_QtCld4lQkp0wZHxkNC6G-ExKV-G6YLjCS3n-9xBs1dHw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 283743060C21;
        Thu, 20 Feb 2020 02:08:32 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/15] mlxsw: spectrum_router: Prepare function for router lock introduction
Date:   Thu, 20 Feb 2020 09:07:56 +0200
Message-Id: <20200220070800.364235-12-idosch@idosch.org>
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

The function removes the FDB entry that directs the macvlan's MAC to the
router port. It is called from both the netdev notifier block and the
inetaddr notifier block that will soon hold the router lock.

Make sure that only the netdev notifier calls the exported version, so
that is will take the router lock, which will already be held by the
inetaddr notifier.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c    | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 000aa68e7e31..e18d54ad6d87 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6873,8 +6873,8 @@ static int mlxsw_sp_rif_macvlan_add(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-void mlxsw_sp_rif_macvlan_del(struct mlxsw_sp *mlxsw_sp,
-			      const struct net_device *macvlan_dev)
+static void __mlxsw_sp_rif_macvlan_del(struct mlxsw_sp *mlxsw_sp,
+				       const struct net_device *macvlan_dev)
 {
 	struct macvlan_dev *vlan = netdev_priv(macvlan_dev);
 	struct mlxsw_sp_rif *rif;
@@ -6891,6 +6891,12 @@ void mlxsw_sp_rif_macvlan_del(struct mlxsw_sp *mlxsw_sp,
 			    mlxsw_sp_fid_index(rif->fid), false);
 }
 
+void mlxsw_sp_rif_macvlan_del(struct mlxsw_sp *mlxsw_sp,
+			      const struct net_device *macvlan_dev)
+{
+	__mlxsw_sp_rif_macvlan_del(mlxsw_sp, macvlan_dev);
+}
+
 static int mlxsw_sp_inetaddr_macvlan_event(struct mlxsw_sp *mlxsw_sp,
 					   struct net_device *macvlan_dev,
 					   unsigned long event,
@@ -6900,7 +6906,7 @@ static int mlxsw_sp_inetaddr_macvlan_event(struct mlxsw_sp *mlxsw_sp,
 	case NETDEV_UP:
 		return mlxsw_sp_rif_macvlan_add(mlxsw_sp, macvlan_dev, extack);
 	case NETDEV_DOWN:
-		mlxsw_sp_rif_macvlan_del(mlxsw_sp, macvlan_dev);
+		__mlxsw_sp_rif_macvlan_del(mlxsw_sp, macvlan_dev);
 		break;
 	}
 
-- 
2.24.1


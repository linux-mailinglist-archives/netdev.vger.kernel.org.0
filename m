Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4CC41685B1
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgBURzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:55:09 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36079 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729379AbgBURzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:55:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 52E3C2209B;
        Fri, 21 Feb 2020 12:54:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:54:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=3ykx6ge/mce4LRIjp6GhBOIszDHVn4jsdklIt2ysvqM=; b=A4NZ8ZR5
        hOXNWGddrDntjPS3WKa4wbHTr8tSPKoUu/KFTuH6/g5uw+bUA/mH4+KnQ/A1rmJp
        oxWROV3upj1IWBkSHlkCCOUxXzFvK6PzRKlUDGQKYCrlE0nV3Bj3NArEFHsOgHbH
        O6VPbo40NyfAVqT0QX57E36LWQcnqZxgfgpg+ReODY9+ALXSa5d2YNZOso0bMWKb
        52wKiAH7tWCOEmefKz4lgLVcH1eTJmvH3HIgW20mHYIkHaLd/9B9YrtTdXJAd6af
        EL8PtCLcbKS//oQf5orC2tFMbSbG0Rc+odHbfSHhUP9G1stLIfJKyd2pWcIJMIcY
        Xe7NgGs+5ZcKsw==
X-ME-Sender: <xms:cxlQXh5jYHPFhYZ8leAYgvCuP2Sb10D6tbnBw1m1Ih7VBMkbA6OoHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghruf
    hiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:cxlQXqYul3PYNQ4DKS4ctEGIucJ2KMAyhwQ9MQJsO0Y0qdiVn64WDg>
    <xmx:cxlQXue3AOgsFMPbUIu7LAk8zjxxSXXJ_BRhjaZu5OrP7wYUBbmhfg>
    <xmx:cxlQXn6sA39gk5um1bVEh3K2UMvbA9iD0wq5fa0TnAp9I5Cjuki42w>
    <xmx:cxlQXuF70i8TwolaboApByv-JOnGJxAUYojI3B2xy7v0jyoYBII3iA>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id B1EED3060BD1;
        Fri, 21 Feb 2020 12:54:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/12] mlxsw: spectrum_router: Take router lock from inetaddr listeners
Date:   Fri, 21 Feb 2020 19:54:13 +0200
Message-Id: <20200221175415.390884-11-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221175415.390884-1-idosch@idosch.org>
References: <20200221175415.390884-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Another entry point into the routing code is from inetaddr listeners.
The driver registers listeners to IPv4 and IPv6 inetaddr notification
chains in order to understand when a RIF needs to be created or
destroyed.

Serialize access to shared router structures from these listeners by
taking the router lock when processing inetaddr events.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c    | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 7ad5cb5c2d3e..61d323d8b91d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7029,15 +7029,17 @@ static int mlxsw_sp_inetaddr_event(struct notifier_block *nb,
 
 	/* NETDEV_UP event is handled by mlxsw_sp_inetaddr_valid_event */
 	if (event == NETDEV_UP)
-		goto out;
+		return NOTIFY_DONE;
 
 	router = container_of(nb, struct mlxsw_sp_router, inetaddr_nb);
+	mutex_lock(&router->lock);
 	rif = mlxsw_sp_rif_find_by_dev(router->mlxsw_sp, dev);
 	if (!mlxsw_sp_rif_should_config(rif, dev, event))
 		goto out;
 
 	err = __mlxsw_sp_inetaddr_event(router->mlxsw_sp, dev, event, NULL);
 out:
+	mutex_unlock(&router->lock);
 	return notifier_from_errno(err);
 }
 
@@ -7052,8 +7054,9 @@ int mlxsw_sp_inetaddr_valid_event(struct notifier_block *unused,
 
 	mlxsw_sp = mlxsw_sp_lower_get(dev);
 	if (!mlxsw_sp)
-		goto out;
+		return NOTIFY_DONE;
 
+	mutex_lock(&mlxsw_sp->router->lock);
 	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
 	if (!mlxsw_sp_rif_should_config(rif, dev, event))
 		goto out;
@@ -7065,6 +7068,7 @@ int mlxsw_sp_inetaddr_valid_event(struct notifier_block *unused,
 
 	err = __mlxsw_sp_inetaddr_event(mlxsw_sp, dev, event, ivi->extack);
 out:
+	mutex_unlock(&mlxsw_sp->router->lock);
 	return notifier_from_errno(err);
 }
 
@@ -7138,8 +7142,9 @@ int mlxsw_sp_inet6addr_valid_event(struct notifier_block *unused,
 
 	mlxsw_sp = mlxsw_sp_lower_get(dev);
 	if (!mlxsw_sp)
-		goto out;
+		return NOTIFY_DONE;
 
+	mutex_lock(&mlxsw_sp->router->lock);
 	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
 	if (!mlxsw_sp_rif_should_config(rif, dev, event))
 		goto out;
@@ -7151,6 +7156,7 @@ int mlxsw_sp_inet6addr_valid_event(struct notifier_block *unused,
 
 	err = __mlxsw_sp_inetaddr_event(mlxsw_sp, dev, event, i6vi->extack);
 out:
+	mutex_unlock(&mlxsw_sp->router->lock);
 	return notifier_from_errno(err);
 }
 
-- 
2.24.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9C5B165831
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgBTHId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:33 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52375 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726813AbgBTHIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:31 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D863D21E6A;
        Thu, 20 Feb 2020 02:08:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=qQKcQhuKEmGEKzCdkOO2/hCttwTnv8VIy5dyBGSVZiE=; b=PuxHCl40
        jm4OsmL4m/7fTn3EUZCPVqXx51mS666kjZ28ddzKP7USsvo4R8tSRZOG9aiQxkvr
        lTLLh10maX2hetIONlQTMDiDNbRw1yaYfb8NIEEUn37InItZFz83MklMJ8If+Cmy
        AdmrQIAlo3nl/Ce+mfompe/jxorhTsPvcpkOprfEw83uq8/JeRGOvBv0DC0kivYf
        KqPbrNOHAvKAsz3KB2eUO8iQw1y3AAftV9aeUPSTcWeQOCnavLg75lbu1xkAoqVH
        kyTYZ2cPCUHwS+OPYA8/DhfXOUCBfv9YyPxLgNPBExIgJqShcif2zx0/y/uh7OGa
        t3Fqpt74GkxKcA==
X-ME-Sender: <xms:bjBOXuODmAqVVMCTdEVOofI6-ZIVxMjiVboAAZXvlUeFgC1Ps_2tfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:bjBOXi-5RdHQTXrxJk7EI3CNQzxQ_z2nlMQlKqfVyzDjamPHEsOJkA>
    <xmx:bjBOXi4JrWzCR_wfkTnU9LyCMTa0mfE6akHKal9rykJ2qTwnYmhK1w>
    <xmx:bjBOXp2FLj6MHUs5O3OF4T0JbpEj_HFUHGObPo3YR57b_PDB4uYaDg>
    <xmx:bjBOXnze7CgK_267ABzZQWlZG0RX0SXb3BnP9cq42UzKvO_RM18KYg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B9FFB3060D1A;
        Thu, 20 Feb 2020 02:08:29 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/15] mlxsw: spectrum_router: Do not assume RTNL is taken during RIF teardown
Date:   Thu, 20 Feb 2020 09:07:54 +0200
Message-Id: <20200220070800.364235-10-idosch@idosch.org>
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

IPv6 addresses are deleted in an atomic context, so the driver defers
the potential teardown of the associated router interface (RIF) to a
work item that takes RTNL.

The RIF is only destroyed if the associated netdev does not have any IP
addresses (both IPv4 and IPv6). The IPv4 device ('struct in_device') is
currently fetched via __in_dev_get_rtnl() which assumes RTNL is taken.

Since RTNL is going to be removed, convert it to use __in_dev_get_rcu()
from an RCU read-side critical section.

Note that the IPv6 device ('struct inet6_dev') is fetched via
__in6_dev_get(), which does not require RTNL.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 28dca7aa4ce0..21e8539727be 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6285,7 +6285,8 @@ mlxsw_sp_rif_should_config(struct mlxsw_sp_rif *rif, struct net_device *dev,
 	case NETDEV_UP:
 		return rif == NULL;
 	case NETDEV_DOWN:
-		idev = __in_dev_get_rtnl(dev);
+		rcu_read_lock();
+		idev = __in_dev_get_rcu(dev);
 		if (idev && idev->ifa_list)
 			addr_list_empty = false;
 
@@ -6293,6 +6294,7 @@ mlxsw_sp_rif_should_config(struct mlxsw_sp_rif *rif, struct net_device *dev,
 		if (addr_list_empty && inet6_dev &&
 		    !list_empty(&inet6_dev->addr_list))
 			addr_list_empty = false;
+		rcu_read_unlock();
 
 		/* macvlans do not have a RIF, but rather piggy back on the
 		 * RIF of their lower device.
-- 
2.24.1


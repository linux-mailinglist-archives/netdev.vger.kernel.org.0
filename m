Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D949E16583A
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgBTHIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:47 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52001 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726799AbgBTHIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:30 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A364C21EA0;
        Thu, 20 Feb 2020 02:08:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=hC95dsvgWCbzL1HHCXIaaGUGqJIpu6YgRXTjyPyilvI=; b=1Nlbs4o5
        mQ2/bey2thsVOSPeepbAAIddnT8cHhmDxLkEVgr7tL+VB0qRdj5+a21ijkREYj5x
        gRmNU4WD6ZHxLYYzCaumO1mohFR3A6Ld0toR2+YPKYLHXFQ81gy41E4rZmxD+xCd
        MDn6pkX9ixR0vwnIBzrna8/6zv1aYGb0yN7S7he2O8vznqaPx0WCKjkaYUyFfU/F
        1w1U8r5Tn/ZBEhW5LL2u9JaJu2nIXcLP/CyuwQkccVqnMx3H45mSMkrITuC0l5f5
        Xgy33c8np08uT878TM1cQvZ225CUz92BWPmgZDGfikj2x7BrkB57kcXHso5RGiXr
        uhhfLUX2ngZB/A==
X-ME-Sender: <xms:bTBOXmvyfL2t4dLBnOJuQDTu-NXR8cf_FZ0UlKyytZJMH20J56XoYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:bTBOXtFgbErrF89id4kmOatVEd75CeXsz0SeHBihi1P08WKcLC7nFQ>
    <xmx:bTBOXl3kjvRA5gpCZiPJqbO3pYwIHlG2SkL9j0FOfIVKTSnlf_NmLA>
    <xmx:bTBOXnpw0HNImcTE6O7wRXTD2MJ8we7TyA14FlxoU6DQ6wJUD87aRA>
    <xmx:bTBOXuUq9eW2lQa9ljaSqZl9IN5MV5dee2hI60COQ56nCvrqrZr-Zg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8871E3060C21;
        Thu, 20 Feb 2020 02:08:28 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/15] mlxsw: spectrum_router: Do not assume RTNL is taken during nexthop init
Date:   Thu, 20 Feb 2020 09:07:53 +0200
Message-Id: <20200220070800.364235-9-idosch@idosch.org>
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

RTNL is going to be removed from route insertion path, so use
__in_dev_get_rcu() from an RCU read-side critical section instead of
__in_dev_get_rtnl() which assumes RTNL is taken.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index def75d7fcd06..28dca7aa4ce0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3840,10 +3840,14 @@ static int mlxsw_sp_nexthop4_init(struct mlxsw_sp *mlxsw_sp,
 	if (!dev)
 		return 0;
 
-	in_dev = __in_dev_get_rtnl(dev);
+	rcu_read_lock();
+	in_dev = __in_dev_get_rcu(dev);
 	if (in_dev && IN_DEV_IGNORE_ROUTES_WITH_LINKDOWN(in_dev) &&
-	    fib_nh->fib_nh_flags & RTNH_F_LINKDOWN)
+	    fib_nh->fib_nh_flags & RTNH_F_LINKDOWN) {
+		rcu_read_unlock();
 		return 0;
+	}
+	rcu_read_unlock();
 
 	err = mlxsw_sp_nexthop4_type_init(mlxsw_sp, nh, fib_nh);
 	if (err)
-- 
2.24.1


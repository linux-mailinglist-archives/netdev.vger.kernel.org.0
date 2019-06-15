Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557CC47053
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfFOOJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:40 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47089 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A6E421EBC;
        Sat, 15 Jun 2019 10:09:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=XuIdTTZwKkww4wxr7/hQeWEtpcPplTyRPV6EgBjeRis=; b=FkXRmjik
        ELdrXOzchDf+Bfl4YUI/o8ZyHYGk59QShEbTvPsZ38RR/jG9xbkIUrHoCXb9SZ9f
        xmY9dbhOSCf7sbp61nLQxwHCu42c+Gkd8JVGqFhLtaXyk6R5d2s0TjAU4tyNRAGD
        nwP+A6FP1ef3Gr6tpEn3H1OQnuVHa08TNM2lEaCjsy9kaEfA6jCp67/8mzez7MPq
        4bJ/i2I1PbC3hpCki50dFtZ8Ww4my9j/xPUm0uYK72HoAzxXFETvfSPIgf4hjRxt
        xJzrivMF8g/RFyRzdiX/9Y4FQwZRVS0tEQIMmzdFkNZVn22FjpJClcs7EA7sb5AE
        mTm81Ox1wZietA==
X-ME-Sender: <xms:IvwEXTD0ybBTvpOenSWwhz26U_mh_JAyeAV3nHbAGUOYqZsWmEddmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeple
X-ME-Proxy: <xmx:IvwEXdwNxRR-BMfy5qnpW7UzIprGTJ7lpwPTqMaRwRUhW-aquLHdMg>
    <xmx:IvwEXZl71TL1LtZoXLecRSCGI3ph4j07sYj2hdqJ8dovS09wmscNKA>
    <xmx:IvwEXaEf_B_-4AGWP4kQgH9DxIy9i9v3_7w2T9wowvWXZkbDaQ_CxQ>
    <xmx:I_wEXWRxn2JS79pqRXCEuHi06-sPqzfkEbFkmO6OmpqJEG4LK_2ZHA>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id 049DD380085;
        Sat, 15 Jun 2019 10:09:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/17] mlxsw: spectrum_router: Prepare function to return errors
Date:   Sat, 15 Jun 2019 17:07:44 +0300
Message-Id: <20190615140751.17661-11-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The function mlxsw_sp_router_fib6_event() takes care of preparing the
needed information for the work item that actually inserts the route
into the device.

When processing an IPv6 multipath route, the function will need to
allocate an array to store pointers to all the sibling routes.

Change the function's signature to return an error code and adjust the
single call site.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index b7e839a88449..0fdd516b027a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5997,8 +5997,8 @@ static void mlxsw_sp_router_fib4_event(struct mlxsw_sp_fib_event_work *fib_work,
 	}
 }
 
-static void mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
-				       struct fib_notifier_info *info)
+static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
+				      struct fib_notifier_info *info)
 {
 	struct fib6_entry_notifier_info *fen6_info;
 
@@ -6012,6 +6012,8 @@ static void mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
 		fib6_info_hold(fib_work->fen6_info.rt);
 		break;
 	}
+
+	return 0;
 }
 
 static void
@@ -6154,7 +6156,9 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 		break;
 	case AF_INET6:
 		INIT_WORK(&fib_work->work, mlxsw_sp_router_fib6_event_work);
-		mlxsw_sp_router_fib6_event(fib_work, info);
+		err = mlxsw_sp_router_fib6_event(fib_work, info);
+		if (err)
+			goto err_fib_event;
 		break;
 	case RTNL_FAMILY_IP6MR:
 	case RTNL_FAMILY_IPMR:
@@ -6166,6 +6170,10 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 	mlxsw_core_schedule_work(&fib_work->work);
 
 	return NOTIFY_DONE;
+
+err_fib_event:
+	kfree(fib_work);
+	return NOTIFY_BAD;
 }
 
 struct mlxsw_sp_rif *
-- 
2.20.1


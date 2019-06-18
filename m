Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200EF4A4E7
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbfFRPNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:45 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51253 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729627AbfFRPNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9110522468;
        Tue, 18 Jun 2019 11:13:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0C7ypZ7bO/puBU0SGcuEqYH97zvBI+A/fhyak5ubKmU=; b=uMSB73km
        x3+Bd3B8Q9BUyvSCmyi9EboVhNhWKFXwQu+YFUEwhJ9tfmUOdw+7YL+yjyhd9LP1
        lSWAhchim7+Y2akIr7K+isS9gtkYTHH7Oo5Mq2ctR1iGZz3SLSVBDRTIHi2qC1Oc
        V5fIJJfvPI+g+V9og2jj+d4EY9rC7jF9zuV+yUI5QeoDMZKmDazgchN+wg6dy0Lh
        xCGGM3cnNS78KxOhlWCy50RJ3F1z1Sqf6EvFEiyrh/pEC11ZGuMgOh2+ddI9ZSKG
        PRg9+kDHuk0vdLCE9ksr6kOltADFHtzu4IrQofMGrTSXXV4Rd8WQUs6VSwEDjatp
        A/G0c4ukxirg6Q==
X-ME-Sender: <xms:pf8IXesrnWkwNEXK3EOa0AMIB0Lt_Y9WAe1Ig3CC_s2DZ1BqfXgzjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepie
X-ME-Proxy: <xmx:pf8IXZMdUadPJiijeFTzCdrsFl5-k45u3_2R58mQrEdzAaQGyQKwFA>
    <xmx:pf8IXX34ordzrMYR4STLdVhIgokwqRCBe1IuTAcwbKtd2s6mtwtfPA>
    <xmx:pf8IXTwC9B3iCYdrw8h2Z997_hg0yCni_dKsbWTMMVRQ2FP1Xp0ZDg>
    <xmx:pf8IXWvqKcoyhh42-fVb6nrTbUtK4evNGO9hJJWA7A1f8vZ_INBuNA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00B45380083;
        Tue, 18 Jun 2019 11:13:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 09/16] mlxsw: spectrum_router: Prepare function to return errors
Date:   Tue, 18 Jun 2019 18:12:51 +0300
Message-Id: <20190618151258.23023-10-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618151258.23023-1-idosch@idosch.org>
References: <20190618151258.23023-1-idosch@idosch.org>
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
index 8bfd53a1497b..3e2e8be753a4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6064,8 +6064,8 @@ static void mlxsw_sp_router_fib4_event(struct mlxsw_sp_fib_event_work *fib_work,
 	}
 }
 
-static void mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
-				       struct fib_notifier_info *info)
+static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
+				      struct fib_notifier_info *info)
 {
 	struct fib6_entry_notifier_info *fen6_info;
 
@@ -6079,6 +6079,8 @@ static void mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
 		fib6_info_hold(fib_work->fen6_info.rt);
 		break;
 	}
+
+	return 0;
 }
 
 static void
@@ -6221,7 +6223,9 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
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
@@ -6233,6 +6237,10 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
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


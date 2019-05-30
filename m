Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828F82EAF8
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 05:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfE3DIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 23:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbfE3DIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 23:08:04 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A300624462;
        Thu, 30 May 2019 03:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185683;
        bh=sqtKto++oS82tXi2vkb5mqrhSz9lZktqEnvGVJ0Lsgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pfZer6l/mdi5IDpATeUzzhbCwCeUjxjmyI2Rw3x3vntm5IsSUW9NSS/aMOKmCQoQT
         goMDMD+FuR+aNphImhHBbJno0IfEeEC85bb02U3SOYQSIM+mpbk43Y7yO9B0wwk7d9
         YhvGkNM3rIOZCq7k9KXW3B0Cx9Q+3nW9+ZfJoDJc=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 5/7] mlxsw: Fail attempts to use routes with nexthop objects
Date:   Wed, 29 May 2019 20:07:58 -0700
Message-Id: <20190530030800.1683-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530030800.1683-1-dsahern@kernel.org>
References: <20190530030800.1683-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Fail attempts to use nexthop objects with routes until support can be
properly added.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 4f781358aef1..23f17ea52061 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6122,6 +6122,20 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 				NL_SET_ERR_MSG_MOD(info->extack, "IPv6 gateway with IPv4 route is not supported");
 				return notifier_from_errno(-EINVAL);
 			}
+			if (fen_info->fi->nh) {
+				NL_SET_ERR_MSG_MOD(info->extack, "IPv4 route with nexthop objects is not supported");
+				return notifier_from_errno(-EINVAL);
+			}
+		} else if (info->family == AF_INET6) {
+			struct fib6_entry_notifier_info *fen6_info;
+
+			fen6_info = container_of(info,
+						 struct fib6_entry_notifier_info,
+						 info);
+			if (fen6_info->rt->nh) {
+				NL_SET_ERR_MSG_MOD(info->extack, "IPv6 route with nexthop objects is not supported");
+				return notifier_from_errno(-EINVAL);
+			}
 		}
 		break;
 	}
-- 
2.11.0


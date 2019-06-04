Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B0033D76
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 05:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfFDDUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 23:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbfFDDT6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 23:19:58 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4273325E9F;
        Tue,  4 Jun 2019 03:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559618398;
        bh=rSJQ+a4lL9tyYbDNBiCkB0cFlicvus8dyGOwdCSSW7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tE3XAaDMVmMo+sUhXu5F6DZGbzN92l8Z7Zh5XJS7qu07HKOCIdRtU/UyUUvcL663N
         uHfucr9NBz2cbCMyAFpFmzwa5XBqfx6DhfrAaFKJVOT9taE5IAqIkJ3OWMq2BrBbfn
         Bi7I2SvFV0o6NwxGyCSiwmrig9b1FzjBIED9SX4Q=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 net-next 5/7] mlxsw: Fail attempts to use routes with nexthop objects
Date:   Mon,  3 Jun 2019 20:19:53 -0700
Message-Id: <20190604031955.26949-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190604031955.26949-1-dsahern@kernel.org>
References: <20190604031955.26949-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Fail attempts to use nexthop objects with routes until support can be
properly added.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
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


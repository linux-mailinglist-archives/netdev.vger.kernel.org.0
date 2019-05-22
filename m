Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116DB26EB9
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731934AbfEVT0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:26:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731923AbfEVT0R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:26:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EAA7217D7;
        Wed, 22 May 2019 19:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553176;
        bh=Buqndm3cxnXvPQ8zzQzt0Zoz3x/wpACFG1jlQ2chfdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HY+nEmXV0OP05yfvN+cBnyGu+lDjDNZGbWkHumTgk19zVWtMLh8usvbCuBKDKdmy/
         gVAk01UXK0ZuJQaUHRHC1jCeBpm8FlqfwGqvyBi0fMHHq45MpaccuSQzFU0v9cRcUA
         eM1i8jcNf6z3Xrn4PY0bVCJz4PTPyHFrnW8eNtA4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 095/317] mlxsw: spectrum_router: Prevent ipv6 gateway with v4 route via replace and append
Date:   Wed, 22 May 2019 15:19:56 -0400
Message-Id: <20190522192338.23715-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 7973d9e76727aa42f0824f5569e96248a572d50b ]

mlxsw currently does not support v6 gateways with v4 routes. Commit
19a9d136f198 ("ipv4: Flag fib_info with a fib_nh using IPv6 gateway")
prevents a route from being added, but nothing stops the replace or
append. Add a catch for them too.
    $ ip  ro add 172.16.2.0/24 via 10.99.1.2
    $ ip  ro replace 172.16.2.0/24 via inet6 fe80::202:ff:fe00:b dev swp1s0
    Error: mlxsw_spectrum: IPv6 gateway with IPv4 route is not supported.
    $ ip  ro append 172.16.2.0/24 via inet6 fe80::202:ff:fe00:b dev swp1s0
    Error: mlxsw_spectrum: IPv6 gateway with IPv4 route is not supported.

Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 2f6afbfd689fd..3827f6288271a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6065,6 +6065,8 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 			return notifier_from_errno(err);
 		break;
 	case FIB_EVENT_ENTRY_ADD:
+	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
+	case FIB_EVENT_ENTRY_APPEND:  /* fall through */
 		if (router->aborted) {
 			NL_SET_ERR_MSG_MOD(info->extack, "FIB offload was aborted. Not configuring route");
 			return notifier_from_errno(-EINVAL);
-- 
2.20.1


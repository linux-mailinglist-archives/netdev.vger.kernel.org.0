Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E956D26D94
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732732AbfEVTm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732573AbfEVT2c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:28:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E4F5217D9;
        Wed, 22 May 2019 19:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553311;
        bh=t0ELyZcHCkTHsnKm5byRNb6pPqbCrwMCLRiZIvw3gTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gubNOFB/5632QJrziOLMgu9uWGylICgJgcjxEyc0sY233d+s5Go6Wn3B8927zNegX
         a8coUBte5RaUGSluSfMf6YAGeX100BDiXO0owWR0kL4AAkZYinUNVrBFO52APg6qKh
         Yr/DlEp5VRxfRT1TtfW4IMsh67bUKXbxQN2db8gI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 077/244] mlxsw: spectrum_router: Prevent ipv6 gateway with v4 route via replace and append
Date:   Wed, 22 May 2019 15:23:43 -0400
Message-Id: <20190522192630.24917-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
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
index 2ab9cf25a08ae..6d214db2ec22e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5927,6 +5927,8 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
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


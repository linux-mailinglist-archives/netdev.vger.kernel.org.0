Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE2D39E1B
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfFHLqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbfFHLm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:42:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F62521537;
        Sat,  8 Jun 2019 11:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994146;
        bh=o+G1kTnpQBVpPmVxZ/vKRLrP5Vyd2+cAirqJA/FEwlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKX5VgNMfOXLQlNPWWj/bN9CiRWaYzalxbj+BBOnejeFHb2XygINRzubgzHwRQH2r
         sdEwtqVhh8lFMJeAREQAO9QXYyzgml5rx7bGE4IoQ6u0zQMXXUsQnQudnG0Xnazeb6
         0S2WYOYtioZEvgr3v9mlU8ZIbw+smIaFZ0PzX9Qg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Cohen <amitc@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 69/70] mlxsw: spectrum: Prevent force of 56G
Date:   Sat,  8 Jun 2019 07:39:48 -0400
Message-Id: <20190608113950.8033-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

[ Upstream commit 275e928f19117d22f6d26dee94548baf4041b773 ]

Force of 56G is not supported by hardware in Ethernet devices. This
configuration fails with a bad parameter error from firmware.

Add check of this case. Instead of trying to set 56G with autoneg off,
return a meaningful error.

Fixes: 56ade8fe3fe1 ("mlxsw: spectrum: Add initial support for Spectrum ASIC")
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 6b8aa3761899..f4acb38569e1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3110,6 +3110,10 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
 	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, &eth_proto_cap, NULL, NULL);
 
 	autoneg = cmd->base.autoneg == AUTONEG_ENABLE;
+	if (!autoneg && cmd->base.speed == SPEED_56000) {
+		netdev_err(dev, "56G not supported with autoneg off\n");
+		return -EINVAL;
+	}
 	eth_proto_new = autoneg ?
 		ops->to_ptys_advert_link(mlxsw_sp, cmd) :
 		ops->to_ptys_speed(mlxsw_sp, cmd->base.speed);
-- 
2.20.1


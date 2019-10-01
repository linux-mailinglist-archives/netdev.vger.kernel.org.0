Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36477C3CD0
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbfJAQyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:54:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732239AbfJAQmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:42:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79E9E2168B;
        Tue,  1 Oct 2019 16:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948173;
        bh=/9/aMWttHsVjoz7AtQoEnuhw9IY82C4nqkSpLrTWbSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ir/I0k69WobuEjqX4ukG5B9A3HV/BYz91VHmGBoWXpV0tgmZm2Nw/ftqFdx0iTxz5
         2FkPzx15FY4UxjJppG1LTr7TJfudS0POwkB/dtRd5RRr8fgqDPJm+wXHj09Xga37lm
         NjdXQGeOwQc9nk4BEY/Hn4tri7Tz2fKRFwD6S5zQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Danielle Ratson <danieller@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 55/63] mlxsw: spectrum_flower: Fail in case user specifies multiple mirror actions
Date:   Tue,  1 Oct 2019 12:41:17 -0400
Message-Id: <20191001164125.15398-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164125.15398-1-sashal@kernel.org>
References: <20191001164125.15398-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

[ Upstream commit 52feb8b588f6d23673dd7cc2b44b203493b627f6 ]

The ASIC can only mirror a packet to one port, but when user is trying
to set more than one mirror action, it doesn't fail.

Add a check if more than one mirror action was specified per rule and if so,
fail for not being supported.

Fixes: d0d13c1858a11 ("mlxsw: spectrum_acl: Add support for mirror action")
Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 96b23c856f4de..ca31c26e98c1e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -21,6 +21,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 					 struct netlink_ext_ack *extack)
 {
 	const struct flow_action_entry *act;
+	int mirror_act_count = 0;
 	int err, i;
 
 	if (!flow_action_has_entries(flow_action))
@@ -95,6 +96,11 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		case FLOW_ACTION_MIRRED: {
 			struct net_device *out_dev = act->dev;
 
+			if (mirror_act_count++) {
+				NL_SET_ERR_MSG_MOD(extack, "Multiple mirror actions per rule are not supported");
+				return -EOPNOTSUPP;
+			}
+
 			err = mlxsw_sp_acl_rulei_act_mirror(mlxsw_sp, rulei,
 							    block, out_dev,
 							    extack);
-- 
2.20.1


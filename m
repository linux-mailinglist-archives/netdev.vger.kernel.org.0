Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055A01A5623
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbgDKXOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729842AbgDKXOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:14:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D431D21655;
        Sat, 11 Apr 2020 23:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646864;
        bh=lSmQayDoVMVup4dmxFPwTiYjUQ0Jl6gpilEkXCX/ldE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPgP0iB4+EGOlvENzGcmwLpNphqBbNNPRGMC/QulT3QBc+QQdzTqaqeUUW8t2f9aC
         psByYdXKCDrZtZT7HPy/GFKaehzKACIOqHmfz/ZbDBut1PbYVjBNFcFBWJT4BF6Qxf
         3Sk4YIjhUAgbIKBeplMITXohLAE5jxTokSypPYGo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vlad Buslov <vladbu@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for representors
Date:   Sat, 11 Apr 2020 19:13:56 -0400
Message-Id: <20200411231413.26911-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231413.26911-1-sashal@kernel.org>
References: <20200411231413.26911-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit 6783e8b29f636383af293a55336f036bc7ad5619 ]

During transition to uplink representors the code responsible for
initializing ethtool steering functionality wasn't added to representor
init rx routine. This causes NULL pointer dereference during configuration
of network flow classification rule with ethtool (only possible to
reproduce with next commit in this series which registers necessary ethtool
callbacks).

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index b210c171a3806..37702e4e1871a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -358,6 +358,8 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_del_flow_rule;
 
+	mlx5e_ethtool_init_steering(priv);
+
 	return 0;
 
 err_del_flow_rule:
-- 
2.20.1


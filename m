Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62232D8856
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 17:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407655AbgLLQh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 11:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439380AbgLLQJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 11:09:36 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 14/23] vxlan: Copy needed_tailroom from lowerdev
Date:   Sat, 12 Dec 2020 11:07:55 -0500
Message-Id: <20201212160804.2334982-14-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160804.2334982-1-sashal@kernel.org>
References: <20201212160804.2334982-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit a5e74021e84bb5eadf760aaf2c583304f02269be ]

While vxlan doesn't need any extra tailroom, the lowerdev might need it. In
that case, copy it over to reduce the chance for additional (re)allocations
in the transmit path.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Link: https://lore.kernel.org/r/20201126125247.1047977-2-sven@narfation.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 85c4a6bfc7c06..94e14238fb8a1 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3804,6 +3804,8 @@ static void vxlan_config_apply(struct net_device *dev,
 		needed_headroom = lowerdev->hard_header_len;
 		needed_headroom += lowerdev->needed_headroom;
 
+		dev->needed_tailroom = lowerdev->needed_tailroom;
+
 		max_mtu = lowerdev->mtu - (use_ipv6 ? VXLAN6_HEADROOM :
 					   VXLAN_HEADROOM);
 		if (max_mtu < ETH_MIN_MTU)
-- 
2.27.0


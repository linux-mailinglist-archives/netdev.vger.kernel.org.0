Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91302D881D
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 17:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406137AbgLLQYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 11:24:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439460AbgLLQKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 11:10:34 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Annika Wickert <annika.wickert@exaring.de>,
        Annika Wickert <aw@awlnx.space>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 5/9] vxlan: Add needed_headroom for lower device
Date:   Sat, 12 Dec 2020 11:08:44 -0500
Message-Id: <20201212160848.2335307-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160848.2335307-1-sashal@kernel.org>
References: <20201212160848.2335307-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 0a35dc41fea67ac4495ce7584406bf9557a6e7d0 ]

It was observed that sending data via batadv over vxlan (on top of
wireguard) reduced the performance massively compared to raw ethernet or
batadv on raw ethernet. A check of perf data showed that the
vxlan_build_skb was calling all the time pskb_expand_head to allocate
enough headroom for:

  min_headroom = LL_RESERVED_SPACE(dst->dev) + dst->header_len
  		+ VXLAN_HLEN + iphdr_len;

But the vxlan_config_apply only requested needed headroom for:

  lowerdev->hard_header_len + VXLAN6_HEADROOM or VXLAN_HEADROOM

So it completely ignored the needed_headroom of the lower device. The first
caller of net_dev_xmit could therefore never make sure that enough headroom
was allocated for the rest of the transmit path.

Cc: Annika Wickert <annika.wickert@exaring.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Tested-by: Annika Wickert <aw@awlnx.space>
Link: https://lore.kernel.org/r/20201126125247.1047977-1-sven@narfation.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index abf85f0ab72fc..8481a21fe7afb 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3180,6 +3180,7 @@ static void vxlan_config_apply(struct net_device *dev,
 		dev->gso_max_segs = lowerdev->gso_max_segs;
 
 		needed_headroom = lowerdev->hard_header_len;
+		needed_headroom += lowerdev->needed_headroom;
 
 		max_mtu = lowerdev->mtu - (use_ipv6 ? VXLAN6_HEADROOM :
 					   VXLAN_HEADROOM);
-- 
2.27.0


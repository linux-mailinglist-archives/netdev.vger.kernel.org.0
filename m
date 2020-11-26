Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A232C543C
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 13:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389643AbgKZMxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 07:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389266AbgKZMxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 07:53:19 -0500
X-Greylist: delayed 16271 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 Nov 2020 04:53:19 PST
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD91C0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 04:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1606395197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u9brxP8N0Zad68RDWJ6eU6Uvj+b8EOgYlFMeuq6xuxs=;
        b=P8W/YmhcdPLxb73c6tYExpaaeX0D3QinuxJz9eVJOdwWiECUgQI4YSQGS1zE0Fha1CiIMZ
        fTIu8AYvOnPYsbK6ULiGhmT3WE76Or/i/X40vq40v2+Wy+ZRQ11mWFs1MYcIrP+vb/gowU
        Xlg8GATDkz+tutA7cotNBETv8pL+nbU=
From:   Sven Eckelmann <sven@narfation.org>
To:     netdev@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org, linux-kernel@vger.kernel.org,
        Sven Eckelmann <sven@narfation.org>,
        Annika Wickert <annika.wickert@exaring.de>
Subject: [PATCH 1/2] vxlan: Add needed_headroom for lower device
Date:   Thu, 26 Nov 2020 13:52:46 +0100
Message-Id: <20201126125247.1047977-1-sven@narfation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/vxlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 236fcc55a5fd..25b5b5a2dfea 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3799,6 +3799,7 @@ static void vxlan_config_apply(struct net_device *dev,
 		dev->gso_max_segs = lowerdev->gso_max_segs;
 
 		needed_headroom = lowerdev->hard_header_len;
+		needed_headroom += lowerdev->needed_headroom;
 
 		max_mtu = lowerdev->mtu - (use_ipv6 ? VXLAN6_HEADROOM :
 					   VXLAN_HEADROOM);
-- 
2.29.2


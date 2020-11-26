Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5881D2C5440
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 13:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389742AbgKZMxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 07:53:23 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:39320 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389703AbgKZMxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 07:53:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1606395200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zV9ZqDHzPB9d6PtOImamgvuZOteIZ+VW/oQO+TRb7O4=;
        b=sq37VNJcpPUyveuutj+PATo+Uq9ER3tH2NTmSO/Ymq+2rWJByIjSZsbSO3D8KnbeAYSOWD
        h+vj9d0RVPDjKVJ0uhAJRD+YuvDCUJqL4ZjMfwgPbGnW+nKoBe6bm1Bgi/U0Mair7BtMBH
        yj656QvWwdBxWj/6VXVP6WZpcZmAl9A=
From:   Sven Eckelmann <sven@narfation.org>
To:     netdev@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org, linux-kernel@vger.kernel.org,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 2/2] vxlan: Copy needed_tailroom from lowerdev
Date:   Thu, 26 Nov 2020 13:52:47 +0100
Message-Id: <20201126125247.1047977-2-sven@narfation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126125247.1047977-1-sven@narfation.org>
References: <20201126125247.1047977-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While vxlan doesn't need any extra tailroom, the lowerdev might need it. In
that case, copy it over to reduce the chance for additional (re)allocations
in the transmit path.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 drivers/net/vxlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 25b5b5a2dfea..44bb02122526 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3801,6 +3801,8 @@ static void vxlan_config_apply(struct net_device *dev,
 		needed_headroom = lowerdev->hard_header_len;
 		needed_headroom += lowerdev->needed_headroom;
 
+		dev->needed_tailroom = lowerdev->needed_tailroom;
+
 		max_mtu = lowerdev->mtu - (use_ipv6 ? VXLAN6_HEADROOM :
 					   VXLAN_HEADROOM);
 		if (max_mtu < ETH_MIN_MTU)
-- 
2.29.2


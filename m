Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC573BCD3A
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhGFLU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232700AbhGFLTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F30161C9B;
        Tue,  6 Jul 2021 11:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570203;
        bh=F8SCln3H5NJmbHRZxsNE5Xd1u4tOGt+zaQc9RTcTxI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G47/aUjtAIV82j0Ypztl1AOQMMCu34/FeqrqKu0KbhMm/jfP2RatG6qyhZrXJoRuH
         /4Q2hdlHhfphfEChoSK+yw8b4EYYAeq0CsO/GeKf6PvBrBoY73yxGfgAdda8lVZiaf
         bfKU8LSm3gB2kyH0nAdivjMMQi9xCqPnojGdVi7fdl798I569HKjQrfxh53vWwpaah
         nKUzeoTia1atfRpXPVdy5ZD3hh4SR/3r9AHEbYzwGWo9V4p/0CdmmWgD4j8FLpdo0N
         x3iRtl2hjbCyJT3PpUDU0uXnC7xzEXwRabKFXeR3TiBwan1blWuJRlcnsUR2PDGNIz
         RUJ00fLKJ6Jpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George McCollister <george.mccollister@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 115/189] net: hsr: don't check sequence number if tag removal is offloaded
Date:   Tue,  6 Jul 2021 07:12:55 -0400
Message-Id: <20210706111409.2058071-115-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George McCollister <george.mccollister@gmail.com>

[ Upstream commit c2ae34a7deaff463ecafb7db627b77faaca8e159 ]

Don't check the sequence number when deciding when to update time_in in
the node table if tag removal is offloaded since the sequence number is
part of the tag. This fixes a problem where the times in the node table
wouldn't update when 0 appeared to be before or equal to seq_out when
tag removal was offloaded.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_framereg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index bb1351c38397..e31949479305 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -397,7 +397,8 @@ void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
 	 * ensures entries of restarted nodes gets pruned so that they can
 	 * re-register and resume communications.
 	 */
-	if (seq_nr_before(sequence_nr, node->seq_out[port->type]))
+	if (!(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
+	    seq_nr_before(sequence_nr, node->seq_out[port->type]))
 		return;
 
 	node->time_in[port->type] = jiffies;
-- 
2.30.2


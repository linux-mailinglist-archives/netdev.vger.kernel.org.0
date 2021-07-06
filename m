Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ADF3BD02E
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbhGFLcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:32:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235088AbhGFL3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F5B961CEE;
        Tue,  6 Jul 2021 11:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570436;
        bh=F8SCln3H5NJmbHRZxsNE5Xd1u4tOGt+zaQc9RTcTxI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1kzm1NXpMQ6ceSDW6y4zZIGs3KM7sArWs+M4Dz/Lc7xgoA9Hg5iW6khVFrvnza60
         +yhajXlrPFsDiFU9fvj9FfE0tiX53uhWIBPFX0KOW78lU/Ekd/D9sE6DM1iV3RbpSr
         Bm2cAgLP7Zrx+tSvO3hZeVjlmvytQFc9sr8XbDDxn4G91z6M4ikUCRTmXKU9/2wvCE
         VOVkLf7MxBHC5Cbzy7Bcl77lBrsncQx/GOqbDKBHNrmlW0lHB8dI8p7AktaY+U2oBR
         SIeKrSMnHXGKuwjqYfX4W+stoWZnoOoe9y/FNz6RPHU+TNqZbyxQwh3mwCnF6CgRQg
         i3TNI7NA0NTyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George McCollister <george.mccollister@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 097/160] net: hsr: don't check sequence number if tag removal is offloaded
Date:   Tue,  6 Jul 2021 07:17:23 -0400
Message-Id: <20210706111827.2060499-97-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171F33BD1DF
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbhGFLkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236267AbhGFLe7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A235E61E25;
        Tue,  6 Jul 2021 11:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570597;
        bh=sODFjQzU3USHLt6BrmHeBwUgk5c78OeFL3+f/Hi8QAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5QjQqUIjaQhtLaNk5xlvhT8acnk6yRwbTRyA1WaxhT7rpKIEM8gW49rGbhQEpaKG
         EIcNTcMXrFSHevJsYVkdn2wRc1SUs5975wYN5c0YFz1ze6M6zPqcJcrUpC0vhZunTi
         8PErsBbaGf2OLjJ017EFey1F+5M2O2y8YUF4k2wJMHzS/fFOsQIcaPjtShmQCnYSaR
         k1ZE5mxo/6KUIQJ261/ut/971fWFxCMiuBrl6kKiU0ftKdFUOACA8B2B+qlWCGsyfD
         IhPn+ZJHgoYy7yEJbKAt3r7Q5udH0e0rt1FDLaXOhufrQ17T9BMuktgwUBL0WuLXJ3
         ikqN0611fbNuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 057/137] net: bridge: mrp: Update ring transitions.
Date:   Tue,  6 Jul 2021 07:20:43 -0400
Message-Id: <20210706112203.2062605-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit fcb34635854a5a5814227628867ea914a9805384 ]

According to the standard IEC 62439-2, the number of transitions needs
to be counted for each transition 'between' ring state open and ring
state closed and not from open state to closed state.

Therefore fix this for both ring and interconnect ring.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mrp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index d1336a7ad7ff..3259f5480127 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -607,8 +607,7 @@ int br_mrp_set_ring_state(struct net_bridge *br,
 	if (!mrp)
 		return -EINVAL;
 
-	if (mrp->ring_state == BR_MRP_RING_STATE_CLOSED &&
-	    state->ring_state != BR_MRP_RING_STATE_CLOSED)
+	if (mrp->ring_state != state->ring_state)
 		mrp->ring_transitions++;
 
 	mrp->ring_state = state->ring_state;
@@ -690,8 +689,7 @@ int br_mrp_set_in_state(struct net_bridge *br, struct br_mrp_in_state *state)
 	if (!mrp)
 		return -EINVAL;
 
-	if (mrp->in_state == BR_MRP_IN_STATE_CLOSED &&
-	    state->in_state != BR_MRP_IN_STATE_CLOSED)
+	if (mrp->in_state != state->in_state)
 		mrp->in_transitions++;
 
 	mrp->in_state = state->in_state;
-- 
2.30.2


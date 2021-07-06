Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3213B3BCF6A
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhGFL2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233941AbhGFL0e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:26:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30B7261D55;
        Tue,  6 Jul 2021 11:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570394;
        bh=6BREJ0k9L9mE1E4tZx8e9Dg/2tIQvEdSjFwZmz7JpRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXHI01WHz051k/f6U7ZP7D2LgcIdbkrK3E4+3K7uVD8YEo/KtLT/Zj4SSGowYkGXP
         Kj4t/hE/6ht1KFmW58a/TYLFR20ba1OJLHBjv01p6WhBeWHGadt9ADZQmJ98yqROcF
         jatArWup4S7eIX1AWewvvp5w0pN6bUdG2DDqDK2zMvJKDrdfp+buuROCMDLFK9wsID
         RI1dsKLRoIKOwYJrzpHv9jBm2gFTGVjrSjY/wmacbnd/gQnFknduvgRgBJ0Wl9104J
         WtYKYcPHIa358/OyjK9ptS3UmPT4G8eeAVprDZOInMdCnqAyNQ7j1if3OTdAOBr807
         dyxh3BMkvNagA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 065/160] net: bridge: mrp: Update ring transitions.
Date:   Tue,  6 Jul 2021 07:16:51 -0400
Message-Id: <20210706111827.2060499-65-sashal@kernel.org>
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
index 12487f6fe9b4..58254fbfda85 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -620,8 +620,7 @@ int br_mrp_set_ring_state(struct net_bridge *br,
 	if (!mrp)
 		return -EINVAL;
 
-	if (mrp->ring_state == BR_MRP_RING_STATE_CLOSED &&
-	    state->ring_state != BR_MRP_RING_STATE_CLOSED)
+	if (mrp->ring_state != state->ring_state)
 		mrp->ring_transitions++;
 
 	mrp->ring_state = state->ring_state;
@@ -708,8 +707,7 @@ int br_mrp_set_in_state(struct net_bridge *br, struct br_mrp_in_state *state)
 	if (!mrp)
 		return -EINVAL;
 
-	if (mrp->in_state == BR_MRP_IN_STATE_CLOSED &&
-	    state->in_state != BR_MRP_IN_STATE_CLOSED)
+	if (mrp->in_state != state->in_state)
 		mrp->in_transitions++;
 
 	mrp->in_state = state->in_state;
-- 
2.30.2


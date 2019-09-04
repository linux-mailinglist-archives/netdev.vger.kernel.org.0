Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01CB4A8A76
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732394AbfIDP73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731634AbfIDP71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5057E20820;
        Wed,  4 Sep 2019 15:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612766;
        bh=BvbLYBycoaBZwSCz1J1OhvVyGPOAwRk9sZnNSfbTWlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEs54ryfdq4ENtpV/qL0glDgzYWMfGYr7Y2Kg/mpkgaDuErlujbsYmllWegBWa4xq
         ZJcEKhG0SgHdX4frve18q34H4HJB/GgUU8lLx0Oxmvg5kT77VC+DMRoUvvrV4MurlP
         CoUguOjk1vuIbccp7iZR+MM6a4m1Ne+BLyA43nZE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, oss-drivers@netronome.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 68/94] nfp: flower: handle neighbour events on internal ports
Date:   Wed,  4 Sep 2019 11:57:13 -0400
Message-Id: <20190904155739.2816-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>

[ Upstream commit e8024cb483abb2b0290b3ef5e34c736e9de2492f ]

Recent code changes to NFP allowed the offload of neighbour entries to FW
when the next hop device was an internal port. This allows for offload of
tunnel encap when the end-point IP address is applied to such a port.

Unfortunately, the neighbour event handler still rejects events that are
not associated with a repr dev and so the firmware neighbour table may get
out of sync for internal ports.

Fix this by allowing internal port neighbour events to be correctly
processed.

Fixes: 45756dfedab5 ("nfp: flower: allow tunnels to output to internal port")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 8c67505865a46..43faad1893f7f 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -329,13 +329,13 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 
 	flow.daddr = *(__be32 *)n->primary_key;
 
-	/* Only concerned with route changes for representors. */
-	if (!nfp_netdev_is_nfp_repr(n->dev))
-		return NOTIFY_DONE;
-
 	app_priv = container_of(nb, struct nfp_flower_priv, tun.neigh_nb);
 	app = app_priv->app;
 
+	if (!nfp_netdev_is_nfp_repr(n->dev) &&
+	    !nfp_flower_internal_port_can_offload(app, n->dev))
+		return NOTIFY_DONE;
+
 	/* Only concerned with changes to routes already added to NFP. */
 	if (!nfp_tun_has_route(app, flow.daddr))
 		return NOTIFY_DONE;
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032A11AA05A
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369224AbgDOMZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409176AbgDOLpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 604F92166E;
        Wed, 15 Apr 2020 11:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951129;
        bh=Fb5r/XOVrXihGT7UJi2/W3a1v9RW/SP/vpu9XGfwCTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1DikP5+DhMxh++QP4lTk/zOFZN28GzPDGlV28VB2OZT1vjVjPV4CxoDY0hnc/EmE
         xcRehmXpP0eiyClwn7xB9uImHKOQBKdgwTyUOKQt44MN2v3Psq4XDhJvpoI4qvejT8
         AJOoHYnSozUzJ0uWFuKv6DIDcAOV1jpuvJgeQT38=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Alex Elder <elder@linaro.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 41/84] net: qualcomm: rmnet: Allow configuration updates to existing devices
Date:   Wed, 15 Apr 2020 07:43:58 -0400
Message-Id: <20200415114442.14166-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

[ Upstream commit 2abb5792387eb188b12051337d5dcd2cba615cb0 ]

This allows the changelink operation to succeed if the mux_id was
specified as an argument. Note that the mux_id must match the
existing mux_id of the rmnet device or should be an unused mux_id.

Fixes: 1dc49e9d164c ("net: rmnet: do not allow to change mux id if mux id is duplicated")
Reported-and-tested-by: Alex Elder <elder@linaro.org>
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 31 ++++++++++++-------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index fbf4cbcf1a654..02cdbb22d3355 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -279,7 +279,6 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
 	struct net_device *real_dev;
-	struct rmnet_endpoint *ep;
 	struct rmnet_port *port;
 	u16 mux_id;
 
@@ -294,19 +293,27 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	if (data[IFLA_RMNET_MUX_ID]) {
 		mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
-		if (rmnet_get_endpoint(port, mux_id)) {
-			NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
-			return -EINVAL;
-		}
-		ep = rmnet_get_endpoint(port, priv->mux_id);
-		if (!ep)
-			return -ENODEV;
 
-		hlist_del_init_rcu(&ep->hlnode);
-		hlist_add_head_rcu(&ep->hlnode, &port->muxed_ep[mux_id]);
+		if (mux_id != priv->mux_id) {
+			struct rmnet_endpoint *ep;
+
+			ep = rmnet_get_endpoint(port, priv->mux_id);
+			if (!ep)
+				return -ENODEV;
 
-		ep->mux_id = mux_id;
-		priv->mux_id = mux_id;
+			if (rmnet_get_endpoint(port, mux_id)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "MUX ID already exists");
+				return -EINVAL;
+			}
+
+			hlist_del_init_rcu(&ep->hlnode);
+			hlist_add_head_rcu(&ep->hlnode,
+					   &port->muxed_ep[mux_id]);
+
+			ep->mux_id = mux_id;
+			priv->mux_id = mux_id;
+		}
 	}
 
 	if (data[IFLA_RMNET_FLAGS]) {
-- 
2.20.1


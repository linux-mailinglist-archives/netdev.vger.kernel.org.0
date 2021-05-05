Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E37D374062
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbhEEQel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:34:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234226AbhEEQdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:33:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69F9B613EB;
        Wed,  5 May 2021 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232333;
        bh=DOfZvo4CKUnUhyiFQqb2bJV2N7uJhWIYyvNwVyHWo/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvpL//05kkJIBJBPzzzccuxGxidp8I1JiF/6AkqfWfABfjHP7Z6oigk9zswCjXwUY
         39TMX5HE4YsvStQZQvkO7pDhOVAGZ5+Pr1lNsM9EdEJPkPdnFU4OBUiV+QnhzVhewf
         Bfvgz5fuEOQ5oAZtkCxcetWRwyaVIPV1m2fH0oV/etzwTuAcTdoUwes68i46xyLP5q
         4+uTMv+pufsb0/PAHAHyDaiUKU0kGjCWcbumP+FxaApT03rW3AJxCMyrvziuu2adyi
         XClBM2vJwSLkeVkZfs9hBFhoZzTCdrNrGU7RmchUkUuuqF7Pf33Q/wvBRAapBk0+Sw
         39y2UP3hrm5FA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 035/116] can: dev: can_free_echo_skb(): don't crash the kernel if can_priv::echo_skb is accessed out of bounds
Date:   Wed,  5 May 2021 12:30:03 -0400
Message-Id: <20210505163125.3460440-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 4168d079aa41498639b2c64b4583375bcdf360d9 ]

A out of bounds access to "struct can_priv::echo_skb" leads to a
kernel crash. Better print a sensible warning message instead and try
to recover.

This patch is similar to:

| e7a6994d043a ("can: dev: __can_get_echo_skb(): Don't crash the kernel
|               if can_priv::echo_skb is accessed out of bounds")

Link: https://lore.kernel.org/r/20210319142700.305648-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 6a64fe410987..c3508109263e 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -151,7 +151,11 @@ void can_free_echo_skb(struct net_device *dev, unsigned int idx)
 {
 	struct can_priv *priv = netdev_priv(dev);
 
-	BUG_ON(idx >= priv->echo_skb_max);
+	if (idx >= priv->echo_skb_max) {
+		netdev_err(dev, "%s: BUG! Trying to access can_priv::echo_skb out of bounds (%u/max %u)\n",
+			   __func__, idx, priv->echo_skb_max);
+		return;
+	}
 
 	if (priv->echo_skb[idx]) {
 		dev_kfree_skb_any(priv->echo_skb[idx]);
-- 
2.30.2


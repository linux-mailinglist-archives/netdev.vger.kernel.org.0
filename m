Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF25BD5CA
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 02:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391429AbfIYArT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 20:47:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390893AbfIYArT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 20:47:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1rsrrNE9XCV3DL8/JQim/q9d2lgKdoRfDdaIhy3EGeY=; b=5c4sjSu848NMEP1m7hr9ngPvyf
        yJRkPKA816R02olnBUyITXWlBlNpI9+BSaVF78zAqHikGRJFmlz+pp+9BcqOkkDLfzPPjQAKUNpk5
        ArZ6X5GVcrecxO8WT1KdJkD1ktjdTG28xME43yFgiKEemklP9R3stzbbnKMNGq4pvBeA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iCvSd-0000Tg-S0; Wed, 25 Sep 2019 02:47:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        michal.vokac@ysoft.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net] net: dsa: qca8k: Fix port enable for CPU port
Date:   Wed, 25 Sep 2019 02:47:07 +0200
Message-Id: <20190925004707.1799-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CPU port does not have a PHY connected to it. So calling
phy_support_asym_pause() results in an Opps. As with other DSA
drivers, add a guard that the port is a user port.

Reported-by: Michal Vokáč <michal.vokac@ysoft.com>
Fixes: 0394a63acfe2 ("net: dsa: enable and disable all ports")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 16f15c93a102..684aa51684db 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -936,6 +936,9 @@ qca8k_port_enable(struct dsa_switch *ds, int port,
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
 	qca8k_port_set_status(priv, port, 1);
 	priv->port_sts[port].enabled = 1;
 
-- 
2.23.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF7B294117
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 19:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395158AbgJTRJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 13:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395149AbgJTRJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 13:09:19 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F27522242;
        Tue, 20 Oct 2020 17:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603213759;
        bh=SP0Mbz601Yq19gdYfEP9kXaHCQ3N6PiVRAavBzOw51w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMevUqQKa8aYTyzSt5M7sfRvfsHP26z8accv24lKCe1jqToPIIpq3L0HE5JmcSdZe
         YwMGd/+lutOQpp/pT9HyV9pRtiXp8NfH/VLrM+htuu/1kAErnxarpvcyxOqggr6dSE
         dn1pQcuAx9QjuARgo/F+Yps5cZFAUgJXDHXvGhlY=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH russell-kings-net-queue 1/2] net: dsa: fill phylink's config supported_interfaces member
Date:   Tue, 20 Oct 2020 19:09:11 +0200
Message-Id: <20201020170912.25959-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020170912.25959-1-kabel@kernel.org>
References: <20201020170912.25959-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new DSA switch operation, phylink_get_interfaces, which should
fill in which PHY_INTERFACE_MODE_* are supported by given port.

Use this before phylink_create to fill phylink's config
supported_interfaces member.

This allows for phylink to determine which PHY_INTERFACE_MODE to use
with SFP modules.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 include/net/dsa.h | 2 ++
 net/dsa/slave.c   | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 75c8fac82017..710900b6019b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -438,6 +438,8 @@ struct dsa_switch_ops {
 	/*
 	 * PHYLINK integration
 	 */
+	void	(*phylink_get_interfaces)(struct dsa_switch *ds, int port,
+					  unsigned long *supported_interfaces);
 	void	(*phylink_validate)(struct dsa_switch *ds, int port,
 				    unsigned long *supported,
 				    struct phylink_link_state *state);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 16e5f98d4882..0f24d2f28737 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1639,6 +1639,10 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		dp->pl_config.poll_fixed_state = true;
 	}
 
+	if (ds->ops->phylink_get_interfaces)
+		ds->ops->phylink_get_interfaces(ds, dp->index,
+			dp->pl_config.supported_interfaces);
+
 	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(port_dn), mode,
 				&dsa_port_phylink_mac_ops);
 	if (IS_ERR(dp->pl)) {
-- 
2.26.2


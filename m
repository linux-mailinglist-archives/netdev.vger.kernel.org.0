Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B25D0AEEB5
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393117AbfIJPnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:43:15 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43742 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfIJPnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 11:43:15 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 9FFAA28D91B
From:   Robert Beckett <bob.beckett@collabora.com>
To:     netdev@vger.kernel.org
Cc:     Robert Beckett <bob.beckett@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/7] net/dsa: configure autoneg for CPU port
Date:   Tue, 10 Sep 2019 16:41:47 +0100
Message-Id: <20190910154238.9155-2-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190910154238.9155-1-bob.beckett@collabora.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure autoneg for phy connected CPU ports.
This allows us to use autoneg between the CPU port's phy and the link
partner's phy.
This enables us to negoatiate pause frame transmission to prioritise
packet delivery over throughput.

Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
---
 net/dsa/port.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index f071acf2842b..1b6832eac2c5 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -538,10 +538,20 @@ static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 		return PTR_ERR(phydev);
 
 	if (enable) {
+		phydev->supported = PHY_GBIT_FEATURES | SUPPORTED_MII |
+				    SUPPORTED_AUI | SUPPORTED_FIBRE |
+				    SUPPORTED_BNC | SUPPORTED_Pause |
+				    SUPPORTED_Asym_Pause;
+		phydev->advertising = phydev->supported;
+
 		err = genphy_config_init(phydev);
 		if (err < 0)
 			goto err_put_dev;
 
+		err = genphy_config_aneg(phydev);
+		if (err < 0)
+			goto err_put_dev;
+
 		err = genphy_resume(phydev);
 		if (err < 0)
 			goto err_put_dev;
-- 
2.18.0


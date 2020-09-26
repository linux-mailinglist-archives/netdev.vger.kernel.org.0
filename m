Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBA4279C88
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 23:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgIZVHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 17:07:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57266 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgIZVHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 17:07:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMHPT-00GJh1-TZ; Sat, 26 Sep 2020 23:07:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 2/7] net: dsa: Make use of devlink port flavour unused
Date:   Sat, 26 Sep 2020 23:06:27 +0200
Message-Id: <20200926210632.3888886-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200926210632.3888886-1-andrew@lunn.ch>
References: <20200926210632.3888886-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a port is unused, still create a devlink port for it, but set the
flavour to unused. This allows us to attach devlink regions to the
port, etc.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/dsa2.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3cf67f5fe54a..2c149fb36928 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -272,6 +272,15 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
+		memset(dlp, 0, sizeof(*dlp));
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
+		devlink_port_attrs_set(dlp, &attrs);
+		err = devlink_port_register(dl, dlp, dp->index);
+		if (err)
+			break;
+
+		devlink_port_registered = true;
+
 		dsa_port_disable(dp);
 		break;
 	case DSA_PORT_TYPE_CPU:
@@ -355,6 +364,7 @@ static void dsa_port_teardown(struct dsa_port *dp)
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
+		devlink_port_unregister(dlp);
 		break;
 	case DSA_PORT_TYPE_CPU:
 		dsa_port_disable(dp);
-- 
2.28.0


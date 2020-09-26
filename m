Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8573E279C8A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 23:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgIZVHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 17:07:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbgIZVHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 17:07:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMHPT-00GJgy-Rs; Sat, 26 Sep 2020 23:07:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Date:   Sat, 26 Sep 2020 23:06:26 +0200
Message-Id: <20200926210632.3888886-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200926210632.3888886-1-andrew@lunn.ch>
References: <20200926210632.3888886-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not all ports of a switch need to be used, particularly in embedded
systems. Add a port flavour for ports which physically exist in the
switch, but are not connected to the front panel etc, and so are
unused.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/uapi/linux/devlink.h | 3 +++
 net/core/devlink.c           | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index a2ecc8b00611..e1f209feac74 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -195,6 +195,9 @@ enum devlink_port_flavour {
 				      * port that faces the PCI VF.
 				      */
 	DEVLINK_PORT_FLAVOUR_VIRTUAL, /* Any virtual port facing the user. */
+	DEVLINK_PORT_FLAVOUR_UNUSED, /* Port which exists in the switch, but
+				      *	is not used in any way.
+				      */
 };
 
 enum devlink_param_cmode {
diff --git a/net/core/devlink.c b/net/core/devlink.c
index ac32b672a04b..fc9589eb4115 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7569,7 +7569,8 @@ static bool devlink_port_type_should_warn(struct devlink_port *devlink_port)
 {
 	/* Ignore CPU and DSA flavours. */
 	return devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_CPU &&
-	       devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_DSA;
+	       devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_DSA &&
+	       devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_UNUSED;
 }
 
 #define DEVLINK_PORT_TYPE_WARN_TIMEOUT (HZ * 3600)
@@ -7854,6 +7855,7 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 		break;
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
+	case DEVLINK_PORT_FLAVOUR_UNUSED:
 		/* As CPU and DSA ports do not have a netdevice associated
 		 * case should not ever happen.
 		 */
-- 
2.28.0


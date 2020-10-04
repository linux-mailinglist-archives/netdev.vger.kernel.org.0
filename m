Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5739C282BB3
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 18:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgJDQN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 12:13:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42556 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgJDQNN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 12:13:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kP6dJ-0003eM-60; Sun, 04 Oct 2020 18:13:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 1/7] net: devlink: Add unused port flavour
Date:   Sun,  4 Oct 2020 18:12:51 +0200
Message-Id: <20201004161257.13945-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201004161257.13945-1-andrew@lunn.ch>
References: <20201004161257.13945-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not all ports of a switch need to be used, particularly in embedded
systems. Add a port flavour for ports which physically exist in the
switch, but are not connected to the front panel etc, and so are
unused. By having unused ports present in devlink, it gives a more
accurate representation of the hardware. It also allows regions to be
associated to such ports, so allowing, for example, to determine
unused ports are correctly powered off, or to compare probable reset
defaults of unused ports to used ports experiences issues.

Actually registering unused ports and setting the flavour to unused is
optional. The DSA core will register all such switch ports, but such
ports are expected to be limited in number. Bigger ASICs may decide
not to list unused ports.

v2:
Expand the description about why it is useful

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/uapi/linux/devlink.h | 3 +++
 net/core/devlink.c           | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index ba467dc07852..5f1d6c327670 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -197,6 +197,9 @@ enum devlink_port_flavour {
 				      * port that faces the PCI VF.
 				      */
 	DEVLINK_PORT_FLAVOUR_VIRTUAL, /* Any virtual port facing the user. */
+	DEVLINK_PORT_FLAVOUR_UNUSED, /* Port which exists in the switch, but
+				      * is not used in any way.
+				      */
 };
 
 enum devlink_param_cmode {
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0f3c8b2ec056..20224fd1ebaf 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7612,7 +7612,8 @@ static bool devlink_port_type_should_warn(struct devlink_port *devlink_port)
 {
 	/* Ignore CPU and DSA flavours. */
 	return devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_CPU &&
-	       devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_DSA;
+	       devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_DSA &&
+	       devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_UNUSED;
 }
 
 #define DEVLINK_PORT_TYPE_WARN_TIMEOUT (HZ * 3600)
@@ -7897,6 +7898,7 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 		break;
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
+	case DEVLINK_PORT_FLAVOUR_UNUSED:
 		/* As CPU and DSA ports do not have a netdevice associated
 		 * case should not ever happen.
 		 */
-- 
2.28.0


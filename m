Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697162353B6
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 19:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgHARGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 13:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgHARGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 13:06:07 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFAFC06174A;
        Sat,  1 Aug 2020 10:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=l7n3N/xd8cqylKwJ3mj18/IUyO+Bl2axCb31+YW7eLw=; b=BICu8/jeR64ZaNuproFAvKTpfD
        IW+KNRTZKsaxK0wTrzAmHZ/bPnaShFaG3fDirWFu2GPRZ3+NSjdzxh41B+E14C3gcaYfPvh9xdors
        QplVxxcmScIqhn/tFGhOch8Qe4inUfHlbxZMUi+5Ou7oICPqhqUH5pEglU2TeJOYYJckWch0gtUF2
        K59BoyLvNpQ9o6AkXxSxm6eC34IIXKmh9icl3rcHpCnSoczncyMgznpE3OVVzMGKWsZGJ+F3y2f4E
        r7A6kMaZcZ5pVCB0s+dkh9fmZFqq+7UgQRlvjnbGR45iZdWENqfzbNjwaGCvKLmbp7CCcOq795yYm
        G2Jo721A==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1k1uxG-0006n0-MM; Sat, 01 Aug 2020 18:05:54 +0100
Date:   Sat, 1 Aug 2020 18:05:54 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/2] net: dsa: qca8k: Add define for port VID
Message-ID: <08fd70c48668544408bdb7932ef23e13d1080ad1.1596301468.git.noodles@earth.li>
References: <20200721171624.GK23489@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721171624.GK23489@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than using a magic value of 1 when configuring the port VIDs add
a QCA8K_PORT_VID_DEF define and use that instead. Also fix up the
bitmask in the process; the top 4 bits are reserved so this wasn't a
problem, but only masking 12 bits is the correct approach.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 drivers/net/dsa/qca8k.c | 11 ++++++-----
 drivers/net/dsa/qca8k.h |  2 ++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a5566de82853..3ebc4da63074 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -663,10 +663,11 @@ qca8k_setup(struct dsa_switch *ds)
 			 * default egress vid
 			 */
 			qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
-				  0xffff << shift, 1 << shift);
+				  0xfff << shift,
+				  QCA8K_PORT_VID_DEF << shift);
 			qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
-				    QCA8K_PORT_VLAN_CVID(1) |
-				    QCA8K_PORT_VLAN_SVID(1));
+				    QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
+				    QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
 		}
 	}
 
@@ -1133,7 +1134,7 @@ qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 {
 	/* Set the vid to the port vlan id if no vid is set */
 	if (!vid)
-		vid = 1;
+		vid = QCA8K_PORT_VID_DEF;
 
 	return qca8k_fdb_add(priv, addr, port_mask, vid,
 			     QCA8K_ATU_STATUS_STATIC);
@@ -1157,7 +1158,7 @@ qca8k_port_fdb_del(struct dsa_switch *ds, int port,
 	u16 port_mask = BIT(port);
 
 	if (!vid)
-		vid = 1;
+		vid = QCA8K_PORT_VID_DEF;
 
 	return qca8k_fdb_del(priv, addr, port_mask, vid);
 }
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 31439396401c..92216a52daa5 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -22,6 +22,8 @@
 
 #define QCA8K_CPU_PORT					0
 
+#define QCA8K_PORT_VID_DEF				1
+
 /* Global control registers */
 #define QCA8K_REG_MASK_CTRL				0x000
 #define   QCA8K_MASK_CTRL_ID_M				0xff
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18911E4A8C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391330AbgE0Qlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390106AbgE0Qls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:41:48 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E420C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:41:48 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gl26so522658ejb.11
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bmsjCqRk9kzw/sqSRwUSj1ioDCgqMrj1TXMrcQm8e+U=;
        b=t797qCTvL8JvWtae39Z2058AtOpDAaHiCyE+mzyFbDV4MEF4KH8/Q7XqbEqogsz+Jj
         yKAw/N9xo/AyP/cFKWWz7svV2zdviB1vibbg8SUliYnSwE9aTl2cPPWVI/dS8S9kLp/C
         lBdF3HklVJrpVAQ9YK5OlqEuthPusQhsEC52mIHfnbokRCILYg3Lx9+H08Wd4VIwnZ11
         xf6XBoNLvqNoO47+PN0RsKYkNMOwMQYXvca4ZMWYz+QWpPoXbTXF7hT4bByK4vXECLqR
         6orUewD5jYel/xC+DXT4LrWCSBYYud/fld0V4HHNOT+7o2xOn4MFUpZLG3lc4s+2T9Gn
         dPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bmsjCqRk9kzw/sqSRwUSj1ioDCgqMrj1TXMrcQm8e+U=;
        b=D4lXPUu2s2jvPJXG+wOKVkae2DxtqCT8qLph+oerIfeM1AYY3q06m11E7l/mgy2Q2p
         XIODwa5YqKo5IbZK98GXLi/mW15Lw+mp1oiWt30eeeho2faK5nKK9UUGjx+nCU87izMM
         QT5SkwAAA+Skod7r3/1hmJE+5e1f6CtONm+LW9QVpw65kZbY/3wyOFKDchCR0TLB0xSR
         8O2vO3I71CIaAKrtTOd2bnkKaBCdQWeFxJFzIGIr6qervMcUkMkUAekCrEQ3JMqhn2yY
         LkzmAC3/0pZArglZSIwfG8bhrUY0flUvwmg5a3CO+0lTEh993kdhR8ESI85kTrZcmiey
         tsXg==
X-Gm-Message-State: AOAM533uuq2eqkcMkkUs1dv7BxluMU1Z7IeWs9OnRiINh91xDaX1WXyy
        wHbqSrSmyBXzAu8nBZVA29OaMDgv
X-Google-Smtp-Source: ABdhPJwB+iyKuG79gFxvZ4Aarcm/0fij9mVRqZY6jMzsVjhBZ0ZYcY6MgmXHi2vTVcUEBhumAFFTPw==
X-Received: by 2002:a17:906:f53:: with SMTP id h19mr6710382ejj.343.1590597706831;
        Wed, 27 May 2020 09:41:46 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id n15sm3134292ejs.10.2020.05.27.09.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 09:41:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: tag_8021q: stop restoring VLANs from bridge
Date:   Wed, 27 May 2020 19:41:34 +0300
Message-Id: <20200527164134.1081548-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Right now, our only tag_8021q user, sja1105, has the ability to restore
bridge VLANs on its own, so this logic is unnecessary.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_8021q.c | 61 +--------------------------------------------
 1 file changed, 1 insertion(+), 60 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 3052da668156..780b2a15ac9b 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -140,34 +140,6 @@ bool vid_is_dsa_8021q(u16 vid)
 }
 EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
 
-static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
-{
-	struct bridge_vlan_info vinfo;
-	struct net_device *slave;
-	u16 pvid;
-	int err;
-
-	if (!dsa_is_user_port(ds, port))
-		return 0;
-
-	slave = dsa_to_port(ds, port)->slave;
-
-	err = br_vlan_get_pvid(slave, &pvid);
-	if (!pvid || err < 0)
-		/* There is no pvid on the bridge for this port, which is
-		 * perfectly valid. Nothing to restore, bye-bye!
-		 */
-		return 0;
-
-	err = br_vlan_get_info(slave, pvid, &vinfo);
-	if (err < 0) {
-		dev_err(ds->dev, "Couldn't determine PVID attributes\n");
-		return err;
-	}
-
-	return dsa_port_vid_add(dsa_to_port(ds, port), pvid, vinfo.flags);
-}
-
 /* If @enabled is true, installs @vid with @flags into the switch port's HW
  * filter.
  * If @enabled is false, deletes @vid (ignores @flags) from the port. Had the
@@ -178,39 +150,11 @@ static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
 			       u16 flags, bool enabled)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct bridge_vlan_info vinfo;
-	int err;
 
 	if (enabled)
 		return dsa_port_vid_add(dp, vid, flags);
 
-	err = dsa_port_vid_del(dp, vid);
-	if (err < 0)
-		return err;
-
-	/* Nothing to restore from the bridge for a non-user port.
-	 * The CPU port VLANs are restored implicitly with the user ports,
-	 * similar to how the bridge does in dsa_slave_vlan_add and
-	 * dsa_slave_vlan_del.
-	 */
-	if (!dsa_is_user_port(ds, port))
-		return 0;
-
-	err = br_vlan_get_info(dp->slave, vid, &vinfo);
-	/* Couldn't determine bridge attributes for this vid,
-	 * it means the bridge had not configured it.
-	 */
-	if (err < 0)
-		return 0;
-
-	/* Restore the VID from the bridge */
-	err = dsa_port_vid_add(dp, vid, vinfo.flags);
-	if (err < 0)
-		return err;
-
-	vinfo.flags &= ~BRIDGE_VLAN_INFO_PVID;
-
-	return dsa_port_vid_add(dp->cpu_dp, vid, vinfo.flags);
+	return dsa_port_vid_del(dp, vid);
 }
 
 /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
@@ -329,9 +273,6 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 		return err;
 	}
 
-	if (!enabled)
-		err = dsa_8021q_restore_pvid(ds, port);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
-- 
2.25.1


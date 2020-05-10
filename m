Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81AB1CCC51
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgEJQnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbgEJQnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:31 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE61BC05BD09;
        Sun, 10 May 2020 09:43:30 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g13so7907074wrb.8;
        Sun, 10 May 2020 09:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8HLKUBcP0NCqjxNIy/DVSzX+QRhK/w5m5uqDn4NFARI=;
        b=BKveuE6dYDcmvMaG8MCuoloyFU8yj+8glwVkXKt1EzYOTCcAwpW+PiulvbCMAf6PpD
         SxVfnFRvrv4zYzBdiq3mWZb5/gEkZ/uboGvKx97skPkEdpwRTlXpsNyghpcRuybnSFsT
         W3mBXQo3UGQTgSgFkuGqAIfCfYmh28IHVXYwSj1O/FzesZQZrod6RasM/mmKW8dhxyyL
         nE5424AVNLtmuTmgNcAx6kb+FcMKOM+CGdFCkPUP0R4+9nqhyEFqydGWU+qBNdIShzJ9
         7zIxt6u4lLHAAnOCruFrR1YGgU9D2os/R8ztn4HKIi7Rsb5nEwkYw2Ulr4ByF7xh2CC3
         8USg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8HLKUBcP0NCqjxNIy/DVSzX+QRhK/w5m5uqDn4NFARI=;
        b=nY3Pf9P6l4bJ31dittWhrT+e4w4R85ve+feGPdosNwMrvFBE+89uTEaWqWUVOX1buX
         UMCSscWT9Nz+PErJqoDF8GtvN1lapxPQk8XSWq1G+ginwgfsc6Jx2Kn4sPrgmZ1+4dc0
         tQeUK99BiZPrM61vuhNMycvf+9n9udvKF4HHFk2nhk7xsGW3baYzOH8XowLuCUlZG6GK
         RNdp5FcKf8lXtBs6i0dAfwxMttNO1OQukmI3MwhZkPYXUK6g0cB4Yfq6z23zxZhNwb60
         ffGXzjOyBtxFQUR1nhKeUSEXRresbfS6bsgGSXy+ayY8RPIhXY0EFEkaxUvF/dMnVbmr
         XaHA==
X-Gm-Message-State: AGi0PuZuH90w/sr3HY00mnkcGru6lb4wGMPoshf12gEvJ2x6x5Va4Zd5
        0KXD5hQk+Tq0lFf8m/RriSk=
X-Google-Smtp-Source: APiQypLgm8tXTf7mvlxHdNb3P+qljM+sqcbZQU4a0N8/C1+4iBAD4af7aWXhdOPFMNu2Mlx+GhV1bA==
X-Received: by 2002:a5d:4dc9:: with SMTP id f9mr4718771wru.407.1589129009598;
        Sun, 10 May 2020 09:43:29 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/15] net: dsa: provide an option for drivers to always receive bridge VLANs
Date:   Sun, 10 May 2020 19:42:41 +0300
Message-Id: <20200510164255.19322-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
References: <20200510164255.19322-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

DSA assumes that a bridge which has vlan filtering disabled is not
vlan aware, and ignores all vlan configuration. However, the kernel
software bridge code allows configuration in this state.

This causes the kernel's idea of the bridge vlan state and the
hardware state to disagree, so "bridge vlan show" indicates a correct
configuration but the hardware lacks all configuration. Even worse,
enabling vlan filtering on a DSA bridge immediately blocks all traffic
which, given the output of "bridge vlan show", is very confusing.

Provide an option that drivers can set to indicate they want to receive
vlan configuration even when vlan filtering is disabled. At the very
least, this is safe for Marvell DSA bridges, which do not look up
ingress traffic in the VTU if the port is in 8021Q disabled state. It is
also safe for the Ocelot switch family. Whether this change is suitable
for all DSA bridges is not known.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  1 +
 net/dsa/slave.c   | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 312c2f067e65..c69cee85923e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -281,6 +281,7 @@ struct dsa_switch {
 	 * settings on ports if not hardware-supported
 	 */
 	bool			vlan_filtering_is_global;
+	bool			vlan_bridge_vtu;
 
 	/* In case vlan_filtering_is_global is set, the VLAN awareness state
 	 * should be retrieved from here and not from the per-port settings.
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 61b0de52040a..e72ebff86a1f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -314,7 +314,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+	if (dp->bridge_dev && !dp->ds->vlan_bridge_vtu &&
+	    !br_vlan_enabled(dp->bridge_dev))
 		return 0;
 
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -381,7 +382,8 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+	if (dp->bridge_dev && !dp->ds->vlan_bridge_vtu &&
+	    !br_vlan_enabled(dp->bridge_dev))
 		return 0;
 
 	/* Do not deprogram the CPU port as it may be shared with other user
@@ -1240,7 +1242,8 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
-		if (!br_vlan_enabled(dp->bridge_dev))
+		if (!dp->ds->vlan_bridge_vtu &&
+		    !br_vlan_enabled(dp->bridge_dev))
 			return 0;
 
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
@@ -1274,7 +1277,8 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
-		if (!br_vlan_enabled(dp->bridge_dev))
+		if (!dp->ds->vlan_bridge_vtu &&
+		    !br_vlan_enabled(dp->bridge_dev))
 			return 0;
 
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-- 
2.17.1


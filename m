Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6171F1CDC29
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbgEKNxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730304AbgEKNxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:53:47 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C8FC061A0C;
        Mon, 11 May 2020 06:53:47 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id h4so18130092wmb.4;
        Mon, 11 May 2020 06:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=w7sHFzJhr2tK8ydSlUjLjM+S66Oe6IzTGv2PezfyhBo=;
        b=FCrxx2bJZzMes6ueRtHeYV1yQaeeqfaUrCy7wT1/kLp9kVfhqcl85HZcdOCoJO0lXR
         G5SzhF+0kWqvkw0nEySZiQetW6ReXevxs3k7Dwm1zOfwhkRO4DJhCuUP2FDVSE2Xb/Iv
         CrkCZShxAzM21YPZafbP281MBodyNKm4pliclRMb3TP16Tdy183nOFh8eQ0nRBGiyHIl
         U/clu5QGSJd8QEp/Kv9J64hky87X3qqOI1zJZGuNYOI8dFL4MYMyCiawPxZHCeFYUAma
         RGbfSS22RdiSGkioEKhLsnKwD6ZfyHJCb5NnjL46wOk65oBU9FFImMU1Xh7xoZV2bPHh
         QycA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=w7sHFzJhr2tK8ydSlUjLjM+S66Oe6IzTGv2PezfyhBo=;
        b=Ixw4GPKVjVUexkEk19RyJ/tch6+0HG7O0TA2Vp/h5+Ajd45cl0Z9JBjxH5EuoWiVzf
         VGACrqN3g86N1lRo29wwV5SJ1lQehcBu5mKK1+ycMwNO43ECeE1BfHH0C2oIcuqL8udH
         64fjejkpVb03FeNWBpHIrSAKShONIzvLWSfWvhXn968lRoBc9NYTrOW/z3BfPbDDzfWx
         UzRLmKVUAS41NaCOV76GmYVnLWVETydO9iFrEe8FXHSZPCs6c2fmZNLgCVZwNAFHXieo
         70BIItKuHCHT1k/mop3QAYQUuHOndUTyyQFzntG+lNLvlGz6ioLfNZ7Lz1KWfVFoWsQf
         M0mw==
X-Gm-Message-State: AGi0Publ9ntH+AF8aLcd9uhC8bXCaS1AnYiWkrDDvgT7C+b/KouGK8/Z
        Sd7Me41QUYl0L5mnXM1bk/4=
X-Google-Smtp-Source: APiQypISezmnWzUAR/l6E9PnGoeC4DoSA89UZOIyUsFxY7iZJW6aSeqciqE5WTvr+Bl7L7aL55gG3A==
X-Received: by 2002:a1c:f012:: with SMTP id a18mr30127503wmb.116.1589205226004;
        Mon, 11 May 2020 06:53:46 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 2sm17596413wre.25.2020.05.11.06.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 06:53:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 01/15] net: dsa: provide an option for drivers to always receive bridge VLANs
Date:   Mon, 11 May 2020 16:53:24 +0300
Message-Id: <20200511135338.20263-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511135338.20263-1-olteanv@gmail.com>
References: <20200511135338.20263-1-olteanv@gmail.com>
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
Changes in v2:
Rename variable from vlan_bridge_vtu to configure_vlans_while_disabled.

 include/net/dsa.h |  7 +++++++
 net/dsa/slave.c   | 12 ++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 312c2f067e65..e794c15d27de 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -282,6 +282,13 @@ struct dsa_switch {
 	 */
 	bool			vlan_filtering_is_global;
 
+	/* Pass .port_vlan_add and .port_vlan_del to drivers even for bridges
+	 * that have vlan_filtering=0. All drivers should ideally set this (and
+	 * then the option would get removed), but it is unknown whether this
+	 * would break things or not.
+	 */
+	bool			configure_vlans_while_disabled;
+
 	/* In case vlan_filtering_is_global is set, the VLAN awareness state
 	 * should be retrieved from here and not from the per-port settings.
 	 */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 61b0de52040a..06ac7641438e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -314,7 +314,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev) &&
+	    !dp->ds->configure_vlans_while_disabled)
 		return 0;
 
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -381,7 +382,8 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
-	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev) &&
+	    !dp->ds->configure_vlans_while_disabled)
 		return 0;
 
 	/* Do not deprogram the CPU port as it may be shared with other user
@@ -1240,7 +1242,8 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
-		if (!br_vlan_enabled(dp->bridge_dev))
+		if (!dp->ds->configure_vlans_while_disabled &&
+		    !br_vlan_enabled(dp->bridge_dev))
 			return 0;
 
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
@@ -1274,7 +1277,8 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
-		if (!br_vlan_enabled(dp->bridge_dev))
+		if (!dp->ds->configure_vlans_while_disabled &&
+		    !br_vlan_enabled(dp->bridge_dev))
 			return 0;
 
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-- 
2.17.1


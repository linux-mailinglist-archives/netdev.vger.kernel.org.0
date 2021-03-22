Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766DB34514C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhCVVAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhCVU73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:59:29 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD7FC061762
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:28 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ce10so23556047ejb.6
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UI6QUETnwQ0x6h1xBD+ow6sFO/yryKz1p1XoSX3FONM=;
        b=uuq3wbNBlHo8BMcXwk+rZdM/htSTdymK24jBXfgaR3XnB0tdZ7dGrVdgGtz0OUA21R
         /ag7G6io3Skdc+6rEqya/Mr0KhlI1oDPkXFHf05hCjVbJaoiBAQKPoFUOC132M/+VneD
         3wMMWcSlgHE9ulaBxMKZe449Su8r6XT8aQrTXnVA6e+YsmAa0cek2fy0qF0GnQPEkXGO
         74DNu+tlSpE7Q3AZGWus4TgevYepZDu0SQ2a2hBHeD48N84GXdoKm7Q9XpRJ+D0fBeN5
         b2t/AHgb58/qhUeA61swhZrkWyhbAkUqMhfYxFVrDgl6oT2Rs0twQB90O4reZcCv27jJ
         aB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UI6QUETnwQ0x6h1xBD+ow6sFO/yryKz1p1XoSX3FONM=;
        b=OVGcC9hHXOs4fL6xwmiZVG0cJ3k/z7o6GmWcGg8oTPeEyrA2yMaQlwQC9zr6KThe/o
         PuZkgFzTmKtovlbRZ084ZW7aw2crIF2OzUt4AURZnz6DfjSVD2VwuZfYw+2xGmsEI2J9
         OGBTHiKX2UdpXeK09D2/bfaKNhTQgT7RkGshMfOceqFfU2/gHhLHk+s7zEoE6ZMWIYqm
         QBcbssPm9hUClM+DSWYscBykNaw3QuYFQVSzqjdST6jkhGxknXXIFB2llhdZl5uThspL
         eIzm6ZR8A+eVM+/6VCbBo/64BeDesVPF/aZ+xWswD9v0XIefAuDpydKK0A7D8qGLjbvZ
         tS4Q==
X-Gm-Message-State: AOAM530R4JUwuWiVWRGy/qL2En5h7xY5HltoRCRMf4WhHHFzUpHhEkg2
        /rVJkkS7N4g48TLhTqlomVDg9lTGTOcqmg==
X-Google-Smtp-Source: ABdhPJxTwR0JKFqYTIKq/hoHHJFGdEQSe0Lzgt99gmm0jiQT+Ep1j8RwExfw1ofecvnYTHua433x6A==
X-Received: by 2002:a17:907:6289:: with SMTP id nd9mr1639930ejc.384.1616446767596;
        Mon, 22 Mar 2021 13:59:27 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id v25sm11621074edr.18.2021.03.22.13.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:59:27 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 5/6] dpaa2-switch: add support for configuring per port unknown flooding
Date:   Mon, 22 Mar 2021 22:58:58 +0200
Message-Id: <20210322205859.606704-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210322205859.606704-1-ciorneiioana@gmail.com>
References: <20210322205859.606704-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Add support for configuring per port unknown flooding by accepting both
BR_FLOOD and BR_MCAST_FLOOD as offloadable bridge port flags.

The DPAA2 switch does not support at the moment configuration of unknown
multicast flooding independently of unknown unicast flooding, therefore
check that both BR_FLOOD and BR_MCAST_FLOOD have the same state.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 23 ++++++++++++++++---
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  1 +
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 2ae4faf81b1f..9f1a59219435 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -129,7 +129,7 @@ static void dpaa2_switch_fdb_get_flood_cfg(struct ethsw_core *ethsw, u16 fdb_id,
 
 		if (type == DPSW_BROADCAST && ethsw->ports[j]->bcast_flood)
 			cfg->if_id[i++] = ethsw->ports[j]->idx;
-		else if (type == DPSW_FLOODING)
+		else if (type == DPSW_FLOODING && ethsw->ports[j]->ucast_flood)
 			cfg->if_id[i++] = ethsw->ports[j]->idx;
 	}
 
@@ -1271,6 +1271,9 @@ static int dpaa2_switch_port_flood(struct ethsw_port_priv *port_priv,
 	if (flags.mask & BR_BCAST_FLOOD)
 		port_priv->bcast_flood = !!(flags.val & BR_BCAST_FLOOD);
 
+	if (flags.mask & BR_FLOOD)
+		port_priv->ucast_flood = !!(flags.val & BR_FLOOD);
+
 	return dpaa2_switch_fdb_set_egress_flood(ethsw, port_priv->fdb->fdb_id);
 }
 
@@ -1278,9 +1281,21 @@ static int dpaa2_switch_port_pre_bridge_flags(struct net_device *netdev,
 					      struct switchdev_brport_flags flags,
 					      struct netlink_ext_ack *extack)
 {
-	if (flags.mask & ~(BR_LEARNING | BR_BCAST_FLOOD))
+	if (flags.mask & ~(BR_LEARNING | BR_BCAST_FLOOD | BR_FLOOD |
+			   BR_MCAST_FLOOD))
 		return -EINVAL;
 
+	if (flags.mask & (BR_FLOOD | BR_MCAST_FLOOD)) {
+		bool multicast = !!(flags.val & BR_MCAST_FLOOD);
+		bool unicast = !!(flags.val & BR_FLOOD);
+
+		if (unicast != multicast) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Cannot configure multicast flooding independently of unicast");
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
@@ -1299,7 +1314,7 @@ static int dpaa2_switch_port_bridge_flags(struct net_device *netdev,
 			return err;
 	}
 
-	if (flags.mask & BR_BCAST_FLOOD) {
+	if (flags.mask & (BR_BCAST_FLOOD | BR_FLOOD | BR_MCAST_FLOOD)) {
 		err = dpaa2_switch_port_flood(port_priv, flags);
 		if (err)
 			return err;
@@ -1668,6 +1683,7 @@ static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
 	 * later bridge join will have the flooding flag on.
 	 */
 	port_priv->bcast_flood = true;
+	port_priv->ucast_flood = true;
 
 	/* Setup the egress flood policy (broadcast, unknown unicast).
 	 * When the port is not under a bridge, only the CTRL interface is part
@@ -2755,6 +2771,7 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	port_netdev->needed_headroom = DPAA2_SWITCH_NEEDED_HEADROOM;
 
 	port_priv->bcast_flood = true;
+	port_priv->ucast_flood = true;
 
 	/* Set MTU limits */
 	port_netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 65ede6036870..549218994243 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -112,6 +112,7 @@ struct ethsw_port_priv {
 
 	struct dpaa2_switch_fdb	*fdb;
 	bool			bcast_flood;
+	bool			ucast_flood;
 };
 
 /* Switch data */
-- 
2.30.0


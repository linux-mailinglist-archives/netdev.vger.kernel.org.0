Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0766234EB34
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhC3OzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhC3Oye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:54:34 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447F2C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:54:33 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id w3so25306384ejc.4
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U2AUzilAhWUP3ZSQBbbdZm0/ruUFRqRel/zZoFBwC60=;
        b=H7FTKkKwDa/q9lHts/QyvVdzUGfm6ityTfG2RIi+UO6NKxDPE76378iu817oKBfD75
         +DPozn1qzx/uVs19KPitGupxeIBBuCgG6SZ48MkFutkeTixWgtojrHnVH3youYwWvbyS
         B/NFdoYsKbxyEFYlCXD9kmFqWRhAOmKehLsm7mSwaIKEsUGWwtNLcpdypqWFXOhNjVQw
         HiaG1cshDAa2YvSIDHfWGRYZn8JPo3sl5J/JYN0ENWm4GNqQYol/XHHIQsK0OfgF/Dhb
         sD7YG8vWWKwEWTT1ubfhhY7MHZcoUdnjOfeoCrkPajWZZdeqOH2ciXIaT9psGx2nTSAp
         Lk4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U2AUzilAhWUP3ZSQBbbdZm0/ruUFRqRel/zZoFBwC60=;
        b=fXBjD9MU+uOyJYP6irhtMIb7BLw1FOXprvcPOcYCUqjOkCb4Zmwiq2aA/qCR55XayD
         L1hv+mhK6LpOVGulPcrig8nNfl3EiHZB7KA4hp9TtuI7NLQk6gtEUH5EmRBHQOW53TEY
         pPTOEIHliEvmMFaJYcau9eo7OIb/9NxnagV9ISxy7c9hAYE/m0BcE9BbVWD86BGoqwDC
         91mkrYWFHJuhNVLK/0blsbHkyW6pDW3nk4JlPGFieGgOnrFxjPsLPHU2B1ZdRSXBFiKW
         QXLgvD9QUCEotIYd/mggC2pt08VgQoRr4n34joGPxQsryO6ZoWlHnxtNG4IE749TtlL1
         Cljw==
X-Gm-Message-State: AOAM5330bo1mqCC3Xuy1REwhp2wve73GWVHG7ki65A2UjmcSMHl5Exz1
        s7EqPghqGsgG2zkpdvrFUzo=
X-Google-Smtp-Source: ABdhPJxaW72m1T4ddC2+ZOW2pRU71YiocEZjkU4WKsxP2H4QD6ZG2H7SxTBYDIspw1geI+LN5w5Ipg==
X-Received: by 2002:a17:906:3b99:: with SMTP id u25mr33865893ejf.277.1617116071939;
        Tue, 30 Mar 2021 07:54:31 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id la15sm10284625ejb.46.2021.03.30.07.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 07:54:31 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/5] dpaa2-switch: keep track of the current learning state per port
Date:   Tue, 30 Mar 2021 17:54:17 +0300
Message-Id: <20210330145419.381355-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210330145419.381355-1-ciorneiioana@gmail.com>
References: <20210330145419.381355-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Keep track of the current learning state per port so that we can
reference it in the next patches when setting up a STP state.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 4 ++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 0683aa34f49c..45090d003b3d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1329,6 +1329,7 @@ static int dpaa2_switch_port_bridge_flags(struct net_device *netdev,
 		err = dpaa2_switch_port_set_learning(port_priv, learn_ena);
 		if (err)
 			return err;
+		port_priv->learn_ena = learn_ena;
 	}
 
 	if (flags.mask & (BR_BCAST_FLOOD | BR_FLOOD | BR_MCAST_FLOOD)) {
@@ -1637,6 +1638,7 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 	/* Inherit the initial bridge port learning state */
 	learn_ena = br_port_flag_is_set(netdev, BR_LEARNING);
 	err = dpaa2_switch_port_set_learning(port_priv, learn_ena);
+	port_priv->learn_ena = learn_ena;
 
 	/* Setup the egress flood policy (broadcast, unknown unicast) */
 	err = dpaa2_switch_fdb_set_egress_flood(ethsw, port_priv->fdb->fdb_id);
@@ -1719,6 +1721,7 @@ static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
 	err = dpaa2_switch_port_set_learning(port_priv, false);
 	if (err)
 		return err;
+	port_priv->learn_ena = false;
 
 	/* Add the VLAN 1 as PVID when not under a bridge. We need this since
 	 * the dpaa2 switch interfaces are not capable to be VLAN unaware
@@ -2839,6 +2842,7 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	err = dpaa2_switch_port_set_learning(port_priv, false);
 	if (err)
 		goto err_port_probe;
+	port_priv->learn_ena = false;
 
 	return 0;
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 655937887960..35990761ce8f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -115,6 +115,7 @@ struct ethsw_port_priv {
 	struct dpaa2_switch_fdb	*fdb;
 	bool			bcast_flood;
 	bool			ucast_flood;
+	bool			learn_ena;
 
 	u16			acl_tbl;
 };
-- 
2.30.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C0A9185F
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 19:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfHRRgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 13:36:14 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46307 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRRgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 13:36:14 -0400
Received: by mail-qk1-f196.google.com with SMTP id p13so8738884qkg.13
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 10:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=niSW7iIXVcLdsvzJzwpRywzI+Ylz40m6NYatkfatDgs=;
        b=KFsgZpCGSpMtKnyY1z/5FCCVZrozn8jh2bc0BUMoc8wyWRz7RwSHrIIKBaIAxHJtYu
         Ps9WJZlLkO7YJ+vk2oRJLcllnoJXM+FW87K/4z9Y1No+jv+Gwd9EaXxWmNWaAUo/QWIl
         B1Wq9DQITpFImkXyHfgo6ZrsKKELyilHqdn05cqb9gHVAy9ZNiwqC4W1luS/ur30+roG
         PzkjxxvUODE2mQwS+2oTyG5x7pUaEUIgmimHNOM2dcVKHEuhZXJMXJRrDtMLEJ8LkT6+
         S7smnLT3torQGRDZ0O7CCkeX3JOwBJ3l3WiPSSzZ5O0NS5h8aiKSMBR801778MzO0gL+
         WLEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=niSW7iIXVcLdsvzJzwpRywzI+Ylz40m6NYatkfatDgs=;
        b=tGSI+k3qLooHnMfT7+n4+/mmwY1VziczBuC3XD3qx+F5JUVdn3sUtvkA18fvKhlHds
         A6fE2ZCwAVBneEgYP9M2Sq1SG+mULJ+d9PVCJO9d4D1Tv3WSvGF1s4KQxjK91p/FzmEM
         8l7Rh96hyFAzgsJ3Xn4SWNc/A5skYdRvmBxRVtDun/4qn+DLtVIedBrmMDNAvxUXzYZI
         LPLbReOoZzVOwIJSYdt2kBJwsG8034D3SHk2LytjrtlHKD8bCSQVqkcBseNdeJ4MTaSF
         hKLaZRFMv2OFVlHy1347R3bu58ILl6IzDR9OPvYrpPBtgNDCb0hkpQjWS9O8/6E/VnRv
         MX4Q==
X-Gm-Message-State: APjAAAUYXMhjLwaGpsaye2gVkRI5hsG2EP5K5egpxXTc+Yvm+5LWNNjP
        2hmjysPsaC3waU5jEJaEytbVfmNS
X-Google-Smtp-Source: APXvYqyrp5CyhHBQY+k/n1Hogj6ZnQYwGCRexyUvhlA+UurTifqIOg+8Lp0yCVfwgWQLXTfmuSwi5Q==
X-Received: by 2002:ae9:f015:: with SMTP id l21mr16760740qkg.35.1566149772340;
        Sun, 18 Aug 2019 10:36:12 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 125sm6088259qkl.36.2019.08.18.10.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 10:36:11 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 1/6] net: dsa: use a single switch statement for port setup
Date:   Sun, 18 Aug 2019 13:35:43 -0400
Message-Id: <20190818173548.19631-2-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190818173548.19631-1-vivien.didelot@gmail.com>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is currently difficult to read the different steps involved in the
setup and teardown of ports in the DSA code. Keep it simple with a
single switch statement for each port type: UNUSED, CPU, DSA, or USER.

Also no need to call devlink_port_unregister from within dsa_port_setup
as this step is inconditionally handled by dsa_port_teardown on error.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa2.c | 87 ++++++++++++++++++++++----------------------------
 1 file changed, 39 insertions(+), 48 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3abd173ebacb..405552ac4c08 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -254,88 +254,79 @@ static void dsa_tree_teardown_default_cpu(struct dsa_switch_tree *dst)
 
 static int dsa_port_setup(struct dsa_port *dp)
 {
-	enum devlink_port_flavour flavour;
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_switch_tree *dst = ds->dst;
-	int err = 0;
-
-	if (dp->type == DSA_PORT_TYPE_UNUSED)
-		return 0;
-
-	memset(&dp->devlink_port, 0, sizeof(dp->devlink_port));
-	dp->mac = of_get_mac_address(dp->dn);
-
-	switch (dp->type) {
-	case DSA_PORT_TYPE_CPU:
-		flavour = DEVLINK_PORT_FLAVOUR_CPU;
-		break;
-	case DSA_PORT_TYPE_DSA:
-		flavour = DEVLINK_PORT_FLAVOUR_DSA;
-		break;
-	case DSA_PORT_TYPE_USER: /* fall-through */
-	default:
-		flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-		break;
-	}
-
-	/* dp->index is used now as port_number. However
-	 * CPU and DSA ports should have separate numbering
-	 * independent from front panel port numbers.
-	 */
-	devlink_port_attrs_set(&dp->devlink_port, flavour,
-			       dp->index, false, 0,
-			       (const char *) &dst->index, sizeof(dst->index));
-	err = devlink_port_register(ds->devlink, &dp->devlink_port,
-				    dp->index);
-	if (err)
-		return err;
+	const unsigned char *id = (const unsigned char *)&dst->index;
+	const unsigned char len = sizeof(dst->index);
+	struct devlink_port *dlp = &dp->devlink_port;
+	struct devlink *dl = ds->devlink;
+	int err;
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		break;
 	case DSA_PORT_TYPE_CPU:
+		memset(dlp, 0, sizeof(*dlp));
+		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_CPU,
+				       dp->index, false, 0, id, len);
+		err = devlink_port_register(dl, dlp, dp->index);
+		if (err)
+			return err;
+
 		err = dsa_port_link_register_of(dp);
 		if (err)
-			dev_err(ds->dev, "failed to setup link for port %d.%d\n",
-				ds->index, dp->index);
+			return err;
 		break;
 	case DSA_PORT_TYPE_DSA:
+		memset(dlp, 0, sizeof(*dlp));
+		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_DSA,
+				       dp->index, false, 0, id, len);
+		err = devlink_port_register(dl, dlp, dp->index);
+		if (err)
+			return err;
+
 		err = dsa_port_link_register_of(dp);
 		if (err)
-			dev_err(ds->dev, "failed to setup link for port %d.%d\n",
-				ds->index, dp->index);
+			return err;
 		break;
 	case DSA_PORT_TYPE_USER:
+		memset(dlp, 0, sizeof(*dlp));
+		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_PHYSICAL,
+				       dp->index, false, 0, id, len);
+		err = devlink_port_register(dl, dlp, dp->index);
+		if (err)
+			return err;
+
+		dp->mac = of_get_mac_address(dp->dn);
 		err = dsa_slave_create(dp);
 		if (err)
-			dev_err(ds->dev, "failed to create slave for port %d.%d\n",
-				ds->index, dp->index);
-		else
-			devlink_port_type_eth_set(&dp->devlink_port, dp->slave);
+			return err;
+
+		devlink_port_type_eth_set(dlp, dp->slave);
 		break;
 	}
 
-	if (err)
-		devlink_port_unregister(&dp->devlink_port);
-
-	return err;
+	return 0;
 }
 
 static void dsa_port_teardown(struct dsa_port *dp)
 {
-	if (dp->type != DSA_PORT_TYPE_UNUSED)
-		devlink_port_unregister(&dp->devlink_port);
+	struct devlink_port *dlp = &dp->devlink_port;
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		break;
 	case DSA_PORT_TYPE_CPU:
 		dsa_tag_driver_put(dp->tag_ops);
-		/* fall-through */
+		devlink_port_unregister(dlp);
+		dsa_port_link_unregister_of(dp);
+		break;
 	case DSA_PORT_TYPE_DSA:
+		devlink_port_unregister(dlp);
 		dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_USER:
+		devlink_port_unregister(dlp);
 		if (dp->slave) {
 			dsa_slave_destroy(dp->slave);
 			dp->slave = NULL;
-- 
2.22.0


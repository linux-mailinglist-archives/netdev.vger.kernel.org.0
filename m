Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDC694EA1
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfHSUBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:01:10 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42271 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbfHSUBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:01:09 -0400
Received: by mail-qk1-f195.google.com with SMTP id 201so2510630qkm.9
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=niSW7iIXVcLdsvzJzwpRywzI+Ylz40m6NYatkfatDgs=;
        b=WM7oz7uKxCqDiN1LRMHy45caOgj4xXDo6VJxOIoDT/ENxt7OR+jFBLd8rIwfU9pdZ3
         Ub79ejy0c+vX0VSeF3w9nvmQF8+0CP0dMrcowSyc+K4dtILJiu1i9W3ZYoBpDSUHrOpf
         SauzBEpsF4jdpfXbWccp9fpAXV256nGwIU0O9WM9GpEx/m+HeiuQ4Bpf0sSzKwOmvB9/
         1PlhTh8rIo+mE83y11CJCwL0z3AZ90vLjMH+EGHDQ1reYJ7egEyXdBGwDZ5PiTE9l/VO
         EhYfSbdpOdBYBHKuL/7WaLibaqxauAlx89IfYUrilNhxzM+1h5Fnx4DAwcWNZWAJemF6
         XirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=niSW7iIXVcLdsvzJzwpRywzI+Ylz40m6NYatkfatDgs=;
        b=WZf0GKPD+8n7N2VM5hWtv3pZTChckC8WFjG6UlRRVsnvPOCTSvOgp5FNPfEhdaIUV6
         i7vw7mZQCOdnPVs4KGa31kBkXF+zp+yAXdYVfl+wqCJylEzfKBKD1cV1mBzh8daKVoPc
         MzGq8P+u2jjVgqWkawf4u4RJAS7OKKKZ60eEEZNClUKrmmW58P1VhhHXHRq9sKjWpOVh
         i9N7TiktZ3cTGQcX1oD9r+BzIRckHDLBAxstsYgqa/SzhXVcTpwTo64oqHOgB4LSNC+l
         F4H4hhONuY4dsdG1PPlZ6u4aDZSfjE3bq/KEb2kqDn19901m4MbohO2cnnT5qCeNFJmq
         CNwg==
X-Gm-Message-State: APjAAAWGdOat50yum9xvA2X2xp1cXzz+Dt5fP03jwqtcRI6D7rt82bP9
        +wNCBvjfkowu9OyoPksmjoZsG6+nyjA=
X-Google-Smtp-Source: APXvYqwuJGPIUdyVfknaSmRFWi16sA/6QdQMhi8LCzwf0X3pUzSskV7s5/gp2CANlLpK0RoQd8NBLw==
X-Received: by 2002:a37:c81:: with SMTP id 123mr22577296qkm.300.1566244868197;
        Mon, 19 Aug 2019 13:01:08 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id r5sm7600160qkc.42.2019.08.19.13.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 13:01:07 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 1/6] net: dsa: use a single switch statement for port setup
Date:   Mon, 19 Aug 2019 16:00:48 -0400
Message-Id: <20190819200053.21637-2-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190819200053.21637-1-vivien.didelot@gmail.com>
References: <20190819200053.21637-1-vivien.didelot@gmail.com>
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


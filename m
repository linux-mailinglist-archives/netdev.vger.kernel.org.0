Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9CE3AD22E
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhFRSdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbhFRScs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 14:32:48 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291E4C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:38 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id ho18so17247258ejc.8
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oDUgR9pnsaWBDFSwkrbZ0JZ9Qg981RAkrXovwQDOhgQ=;
        b=pxbY3LYWKE/yaOMQj2SXrlTCm7Ksg/sctj0LRwj+LV557IddBJeCNrl+4PJAju3F+r
         cxZYoKfHQ1evQrCfJcIMWq/tYdjDypFmwYL2nlBu6o0lS7/oWVd4KvJ349iZbJX0ncOu
         AkmvcdHyhEaxEPNcxd4z3+Z9XB2gWW3L2UyQyFTUj2z66aewbLphYKb0i4DLy9OkHBRC
         969NTYqjGFkjd11EW7MM2L07AjNjPk90hPZWSlCnThOj0wzai9O8yYbOU2KfV4Xn+nrP
         oCoojP5Ei8zNLikqBLXhGSYSo0nK4zVsmp1ch6LSbBZjKNDsfLH9hej2F0mST6OFnDxJ
         lLzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oDUgR9pnsaWBDFSwkrbZ0JZ9Qg981RAkrXovwQDOhgQ=;
        b=SrQuCOyWMSNESNoz8s70MbWxJTC3JAZxxJ2ZOJHLJj8wGLKegCfLJsswRTK5276JQp
         7i9c79dfqdh1gD4SVJNSbaEG/W+skWy1JTJM2Gcl45s0lyX/Tk8Lm9mXxfQEQ1ToDbue
         EDc5qSM9+I09Mcqr2X2zWX3ATI13pUqBy65QbuWg+d9gB17BCYoSefofB/5p16NaA2If
         4frdjVNKym3REPK0FqEzIzoKq+Vxfh2yNC87245h38E8bIHCqB+3mPPcjKtWOgMkctw1
         WJ9qUUsJcUiwMSj6vi1V29kKR62uwSvP02LEJDDzZWK8INlZAqLf5hg0fxpL787E+yy1
         z3vg==
X-Gm-Message-State: AOAM532RgpuJpYvXTVpZ51HYlhxaJ0wcReKdofntKfuEjIUnyjZfv42S
        OxtRpy+eJB/YqKQv5jRK8go=
X-Google-Smtp-Source: ABdhPJz53sSkq0aq9h74vaoz7IZpjDq/JYeZNoWAnpUM9XJ7+6Kzn0ONEbhvKCdeFxgAWQPpoYNKFA==
X-Received: by 2002:a17:906:dffc:: with SMTP id lc28mr12134785ejc.96.1624041036759;
        Fri, 18 Jun 2021 11:30:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s11sm6071988edd.65.2021.06.18.11.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 11:30:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 6/6] net: dsa: remove cross-chip support from the MRP notifiers
Date:   Fri, 18 Jun 2021 21:30:17 +0300
Message-Id: <20210618183017.3340769-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210618183017.3340769-1-olteanv@gmail.com>
References: <20210618183017.3340769-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

With MRP hardware assist being supported only by the ocelot switch
family, which by design does not support cross-chip bridging, the
current match functions are at best a guess and have not been confirmed
in any way to do anything relevant in a multi-switch topology.

Drop the code and make the notifiers match only on the targeted switch
port.

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/switch.c | 53 +++++++-----------------------------------------
 1 file changed, 7 insertions(+), 46 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 75f567390a6b..7e948bf15fe0 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -346,36 +346,16 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
 	return 0;
 }
 
-static bool dsa_switch_mrp_match(struct dsa_switch *ds, int port,
-				 struct dsa_notifier_mrp_info *info)
-{
-	if (ds->index == info->sw_index && port == info->port)
-		return true;
-
-	if (dsa_is_dsa_port(ds, port))
-		return true;
-
-	return false;
-}
-
 static int dsa_switch_mrp_add(struct dsa_switch *ds,
 			      struct dsa_notifier_mrp_info *info)
 {
-	int err = 0;
-	int port;
-
 	if (!ds->ops->port_mrp_add)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_mrp_match(ds, port, info)) {
-			err = ds->ops->port_mrp_add(ds, port, info->mrp);
-			if (err)
-				break;
-		}
-	}
+	if (ds->index == info->sw_index)
+		return ds->ops->port_mrp_add(ds, info->port, info->mrp);
 
-	return err;
+	return 0;
 }
 
 static int dsa_switch_mrp_del(struct dsa_switch *ds,
@@ -390,39 +370,20 @@ static int dsa_switch_mrp_del(struct dsa_switch *ds,
 	return 0;
 }
 
-static bool
-dsa_switch_mrp_ring_role_match(struct dsa_switch *ds, int port,
-			       struct dsa_notifier_mrp_ring_role_info *info)
-{
-	if (ds->index == info->sw_index && port == info->port)
-		return true;
-
-	if (dsa_is_dsa_port(ds, port))
-		return true;
-
-	return false;
-}
-
 static int
 dsa_switch_mrp_add_ring_role(struct dsa_switch *ds,
 			     struct dsa_notifier_mrp_ring_role_info *info)
 {
 	int err = 0;
-	int port;
 
 	if (!ds->ops->port_mrp_add)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_mrp_ring_role_match(ds, port, info)) {
-			err = ds->ops->port_mrp_add_ring_role(ds, port,
-							      info->mrp);
-			if (err)
-				break;
-		}
-	}
+	if (ds->index == info->sw_index)
+		return ds->ops->port_mrp_add_ring_role(ds, info->port,
+						       info->mrp);
 
-	return err;
+	return 0;
 }
 
 static int
-- 
2.25.1


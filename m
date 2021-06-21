Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3612C3AF144
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhFURFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhFURFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:05:14 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48CDC051C7A
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:42:40 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id gn32so2463842ejc.2
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c315mCBT1tn5tr1zBb7HCFIpOOkGOXcsgmE+ZPvTa1s=;
        b=r7mt3CLbdiwUGtb1zNo9xySFpyDYew4x0mW3mwmgoUz0/ZE4s0T18cdp+Zz1G5H1gu
         MJ9FPMEU6/RqBz82uw5UAoNlBIobfjqfozYtFv7+Awtzke7ETTgoHc9YX+RIA6tatZn+
         w2fRYbGY5+HchHRcpZy2g1ql85AAPzf5g7mvocAbNtgH8SBXjVCyvTD1FdlmIuOpqMWO
         ep14AIkThCJdJQTlQtpaFN6KL8KNktoICeV3BGYcyCXgl/x2yxcLkI+Ou9YAEw46RVY9
         1EMWCCmKvPJQKhTxh9wrLnOg3TJUP4II68BSo+D8ZIS+ZLzdGwJbhBSjm57uwC04GN5O
         pYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c315mCBT1tn5tr1zBb7HCFIpOOkGOXcsgmE+ZPvTa1s=;
        b=mu6FpabwXED+tT3jhw9AjPBr32ocJ904tvACalULBUGFAZ8RU9xnyaf6wW6TvSBKeu
         NNFSMtxqvAPrPUa5XmASSFccPM5f1st6e5LMm6P0wSd1O2DA80TRifBcO91664pigofw
         KA/hEyoLohLHVnn5pup0daaYMVhaoQuXZK13JR7JuBRdtN1cBqbDueD2NuZKC6jn7B8I
         dAbCCV7CrGQt+IzkOTeBZBdzSpIFPfRZONugC2NuRomfgRI+sWDMguXTN/m3Gv9OHzBT
         mI31rLVG8GhZVWnAAym1Z/q6apkl3pCBWU33wySqhac31CkZMQosNVjkI03BjhjzATJL
         BbhQ==
X-Gm-Message-State: AOAM533g+/S9/5WtybA9VwSgdVIV3wBSCiyrbqGAwq1uVV5aMP8JdqMg
        f2XfaFFLA6PCONuBjmJDvog=
X-Google-Smtp-Source: ABdhPJwNcO58NSFwmRVyT0+AjuqnMep7ZO5NrrykOFYFMizxIpsowmY0ujJfdyFEtYvSzuKcuqqE7w==
X-Received: by 2002:a17:906:7742:: with SMTP id o2mr26292999ejn.284.1624293758950;
        Mon, 21 Jun 2021 09:42:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id c23sm10931093eds.57.2021.06.21.09.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 09:42:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v2 net-next 6/6] net: dsa: remove cross-chip support from the MRP notifiers
Date:   Mon, 21 Jun 2021 19:42:19 +0300
Message-Id: <20210621164219.3780244-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210621164219.3780244-1-olteanv@gmail.com>
References: <20210621164219.3780244-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: remove unused variable "err" in dsa_switch_mrp_add_ring_role()

 net/dsa/switch.c | 55 ++++++------------------------------------------
 1 file changed, 7 insertions(+), 48 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 75f567390a6b..c1e5afafe633 100644
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
@@ -390,39 +370,18 @@ static int dsa_switch_mrp_del(struct dsa_switch *ds,
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
-	int err = 0;
-	int port;
-
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


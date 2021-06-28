Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FF53B6AB0
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237374AbhF1WDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236864AbhF1WDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:03:07 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9510CC061787
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:39 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id i24so28237805edx.4
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=834iGMR1WRWnq6buci5F593+4lHqaxa+HUHZzFv31Jw=;
        b=Fzx4zTHMovsNyxgxfQtBNylscDRYe9/htChrMwnwyPYToBGwvqBTvDHAUz2Eoy+q7w
         QuuQG/JV1jnvpUjxOdw3nuYmQNaC8OnpWIiTeRWWf+tqN2d0RPDCjn24BE4Wac4U6vHw
         nWuQEqahL42LfnLhyo5S6t0UCAVKZEt/ktqkHHs1Bwiv+XRXtCHFAO/p2e1aX4fAmL6O
         FLwRVe4KoK+a9vtBRTUyUTd+rJ7bi60A/DooY+lzbALGOqMf2vqE6XNRgh6B5ST226gH
         u56k5lfs0B4ZiURC41pEIMRi2Nf/CjZQ/3nlqtXvkoRgREqSrPf3pem6MRJvucJp2b/s
         atng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=834iGMR1WRWnq6buci5F593+4lHqaxa+HUHZzFv31Jw=;
        b=dXD5AN5AK/vOAKh6f2yjK1cUNzvF0qmzrm+Jwva2qWqkx7hS7OaOqKO6hnoYIVTGxO
         y7zx6tFtKH3A2i/Civ3XYtZJGxBuLbMmwM4dGlZgb03vBNR6kkFEY8Xo3lVVuH3K1r8X
         D3QBp53n/ofBVQbNJqECgBgrxAQNUV8MVnt4eHH9XKRA60ksOxUNCUVJt3OTxx3XvfbE
         fo2YiyOrLGfYgC8R/NNHL5Ffsm9yNTqO0ZMD3XMTT1jhbzAvt3vt/AYJfsgboBoELAd8
         JI7FGPmjGcepnyGh6WK+FDHWJj8nRoOzDJYrlhPqciOjeCl9s8Oo7c4Qo+bXfsXYOBoK
         QIHQ==
X-Gm-Message-State: AOAM5315Vu2psLSlX3DhVajy9wNA0axjGnydn/cL89sXB8d2OeYvvZaG
        DrDObPQUIDpM7UV1hqROvG5xY3y1JM4=
X-Google-Smtp-Source: ABdhPJxRuxnD9TQ0cWNkbHx+zU/LzI+y0a8xnmFGRJkKVqnUUbS8saxRtXWrAwIdop2n1F3jBgEQ7g==
X-Received: by 2002:a05:6402:b8c:: with SMTP id cf12mr36605194edb.198.1624917638319;
        Mon, 28 Jun 2021 15:00:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dn7sm10146615edb.29.2021.06.28.15.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:00:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 04/14] net: dsa: introduce dsa_is_upstream_port and dsa_switch_is_upstream_of
Date:   Tue, 29 Jun 2021 01:00:01 +0300
Message-Id: <20210628220011.1910096-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628220011.1910096-1-olteanv@gmail.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In preparation for the new cross-chip notifiers for host addresses,
let's introduce some more topology helpers which we are going to use to
discern switches that are in our path towards the dedicated CPU port
from switches that aren't.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index ea47783d5695..5f632cfd33c7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -491,6 +491,32 @@ static inline unsigned int dsa_upstream_port(struct dsa_switch *ds, int port)
 	return dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
 }
 
+/* Return true if this is the local port used to reach the CPU port */
+static inline bool dsa_is_upstream_port(struct dsa_switch *ds, int port)
+{
+	if (dsa_is_unused_port(ds, port))
+		return false;
+
+	return port == dsa_upstream_port(ds, port);
+}
+
+/* Return true if @upstream_ds is an upstream switch of @downstream_ds, meaning
+ * that the routing port from @downstream_ds to @upstream_ds is also the port
+ * which @downstream_ds uses to reach its dedicated CPU.
+ */
+static inline bool dsa_switch_is_upstream_of(struct dsa_switch *upstream_ds,
+					     struct dsa_switch *downstream_ds)
+{
+	int routing_port;
+
+	if (upstream_ds == downstream_ds)
+		return true;
+
+	routing_port = dsa_routing_port(downstream_ds, upstream_ds->index);
+
+	return dsa_is_upstream_port(downstream_ds, routing_port);
+}
+
 static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 {
 	const struct dsa_switch *ds = dp->ds;
-- 
2.25.1


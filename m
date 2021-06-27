Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFAC3B539D
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhF0ONA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhF0OMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:12:53 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C330FC061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:27 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id yy20so16669940ejb.6
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=834iGMR1WRWnq6buci5F593+4lHqaxa+HUHZzFv31Jw=;
        b=qBA1gjCuKDK/3nw8JKYz9g2kY+H5KVIQ7QMJ+aRAtFUbmv6LvFAwhkrJaA8F3fqK44
         DXNMRFAwQFVN6MBfNjCVro4ib2QNSuXPhzxT1M4XqKbzdYZQUjCRsNG5I6C+MaGAKIja
         JbvQLKusG2wLSzrZcgc/tCD3Tw/Z+Jzi4o83Eaq3lHFgiizVRUUERjWmBJ19KTGk0/1d
         yenFksGHUCbcGAwxKmo8Mt5ctQdyvSi1x3J0F4XBCo54lBKrq0QTNjhXIVzn9r7/jqOY
         ybdVZoMzdhCeAiJ+2ahPBf21RCi8VTjbx1r3XpEWtva29pEpAbahRKBNCQj/UqFNoV2C
         pvDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=834iGMR1WRWnq6buci5F593+4lHqaxa+HUHZzFv31Jw=;
        b=sRWqB27jRrHMQAmM7NGv7XAWLd+NDoi0opKcnYL52T4hA/jUAYXnfOWyhcDzaNB24O
         k6pULljIOD+ZYqGyezeeBCoovLVPVEMnJcAyNDal13Vva7FBOp+D3TjoqjQhFZm2yJDw
         c9LmCK6G/cdATxu4cLFt1zDXzbOSP6V2LEn3pMw9yxveXnHjgh8rBqF2ckIZc68ndqDV
         v82IwY8h9RT49IHpm3VuAtjJ29frmNp8wtK9hDZwt4/PZskfTGY8qgTRCtU/tT93LKH8
         A14mM4wpqwhXS6tr/8Oj89/MqKnFt9xcNWWUnJWjeZ6926WI+uzaGypp76jWjt3Qa93h
         tVYQ==
X-Gm-Message-State: AOAM5317AytxD0LpmNxhvfHat29/Vsa5u5EHT8YEKGm5/dAS03ZxL67s
        eY6/SOeFolgx0lA8/b87KPOobbU47h0=
X-Google-Smtp-Source: ABdhPJztNzCuaN5AI7z8UU5SqGM/Gw5v01mnvfEJeTjYsdN2UytbSYgllRSuNBOa9N0kUXmYMLj85Q==
X-Received: by 2002:a17:906:cc9b:: with SMTP id oq27mr20120279ejb.301.1624803025911;
        Sun, 27 Jun 2021 07:10:25 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:25 -0700 (PDT)
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
Subject: [RFC PATCH v3 net-next 05/15] net: dsa: introduce dsa_is_upstream_port and dsa_switch_is_upstream_of
Date:   Sun, 27 Jun 2021 17:10:03 +0300
Message-Id: <20210627141013.1273942-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
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


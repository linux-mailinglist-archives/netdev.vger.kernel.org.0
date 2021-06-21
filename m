Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C143AF143
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhFURFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhFURFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:05:14 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC717C051C78
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:42:38 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id d7so19938328edx.0
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KORWMhnUBbgHwjYhqK1PttxgJfNlQ4Zi3Dop8SsLEok=;
        b=JpSnamxlUe74w0XaPRHl0nMiXA5G+f1D7m3w09bW3Ifc/0WV0S161D1clFTXDR4I6X
         JvUr0v/ynd1IyQgZFUuLCspnfyvQ8uidkKRMLLhFMYJXQE30N/51/bOAHohQF2OUN2KM
         onHQSiwOjCCmd/N0tD2Lu9+o+FA5DL4FL/p3GStGP4nHbfNZc95WTcYxiBDSCU+gOKUq
         MRnQTjkIYtD9BfouEaxFWnzbvs+i7usgMryipG/38/MBXx9d3PxIVzYDwQ1RrSkdnoU1
         ysj6GWnVSo+GNLcpbgws6OvqtCT6HvbVnC/EGXibl/7nnRF/5jk7xMYT9PfRUn+TwJOG
         2xFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KORWMhnUBbgHwjYhqK1PttxgJfNlQ4Zi3Dop8SsLEok=;
        b=LynbR9q9jSEHQs7cf9UI03YScC+EdSkSvTtd6frptTK3sVhS6FQzvHDPC1E5ErupWr
         ioTQl08c7NhIaKoRj0GMfAhXlml4yGvij1Z5nbwYc68IkQn9cRA/Z9ORnstH5Ek0Rst2
         TVMzjevR2kAJq2BAyUYKI+JXWUAxqErYBlq9/w8T4h+ZKZHtvOH3A5Blv6ttICYWE9D/
         byAkqYIrulCSbSbmz2TX/csaeBEeurzmkB2YuF6OVPy9U5X97T4yoqnK2nZYkoYvLr9O
         4LurPaAx910adp3cC9fAaE27Hwv1dU4zvY7aSbr2n1HSp3VMEQkPqrtrKEW70g9VHReC
         A2jw==
X-Gm-Message-State: AOAM533HQaXn4uST+jUKKTOhQh56YJUDaZGJcnSL7qAy2AXUj2J6T8qs
        M6/YFFxOZlVpnJjrRybYFs4=
X-Google-Smtp-Source: ABdhPJz279VjbUrenvZYbkVy2THGcHEWSHTmR1u4M1RC7w+19t5HALDnMLTpkJr3gdIUu9Lujqjd1Q==
X-Received: by 2002:a05:6402:b17:: with SMTP id bm23mr4556787edb.173.1624293757343;
        Mon, 21 Jun 2021 09:42:37 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id c23sm10931093eds.57.2021.06.21.09.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 09:42:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 4/6] net: dsa: calculate the largest_mtu across all ports in the tree
Date:   Mon, 21 Jun 2021 19:42:17 +0300
Message-Id: <20210621164219.3780244-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210621164219.3780244-1-olteanv@gmail.com>
References: <20210621164219.3780244-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

If we have a cross-chip topology like this:

   sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
[  cpu  ] [  user ] [  user ] [  dsa  ] [  user ]
                                  |
                                  +---------+
                                            |
   sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
[  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]

and we issue the following commands:

1. ip link set sw0p1 mtu 1700
2. ip link set sw1p1 mtu 1600

we notice the following happening:

Command 1. emits a non-targeted MTU notifier for the CPU port (sw0p0)
with the largest_mtu calculated across switch 0, of 1700. This matches
sw0p0, sw0p3 and sw1p4 (all CPU ports and DSA links).
Then, it emits a targeted MTU notifier for the user port (sw0p1), again
with MTU 1700 (this doesn't matter).

Command 2. emits a non-targeted MTU notifier for the CPU port (sw0p0)
with the largest_mtu calculated across switch 1, of 1600. This matches
the same group of ports as above, and decreases the MTU for the CPU port
and the DSA links from 1700 to 1600.

As a result, the sw0p1 user port can no longer communicate with its CPU
port at MTU 1700.

To address this, we should calculate the largest_mtu across all switches
that may share a CPU port, and only emit MTU notifiers with that value.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 net/dsa/slave.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 798944aa847a..ac2ca5f75af3 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1528,6 +1528,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct dsa_slave_priv *p = netdev_priv(dev);
 	struct dsa_switch *ds = p->dp->ds;
+	struct dsa_port *dp_iter;
 	struct dsa_port *cpu_dp;
 	int port = p->dp->index;
 	int largest_mtu = 0;
@@ -1535,31 +1536,31 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	int old_master_mtu;
 	int mtu_limit;
 	int cpu_mtu;
-	int err, i;
+	int err;
 
 	if (!ds->ops->port_change_mtu)
 		return -EOPNOTSUPP;
 
-	for (i = 0; i < ds->num_ports; i++) {
+	list_for_each_entry(dp_iter, &ds->dst->ports, list) {
 		int slave_mtu;
 
-		if (!dsa_is_user_port(ds, i))
+		if (!dsa_port_is_user(dp_iter))
 			continue;
 
 		/* During probe, this function will be called for each slave
 		 * device, while not all of them have been allocated. That's
 		 * ok, it doesn't change what the maximum is, so ignore it.
 		 */
-		if (!dsa_to_port(ds, i)->slave)
+		if (!dp_iter->slave)
 			continue;
 
 		/* Pretend that we already applied the setting, which we
 		 * actually haven't (still haven't done all integrity checks)
 		 */
-		if (i == port)
+		if (dp_iter == dp)
 			slave_mtu = new_mtu;
 		else
-			slave_mtu = dsa_to_port(ds, i)->slave->mtu;
+			slave_mtu = dp_iter->slave->mtu;
 
 		if (largest_mtu < slave_mtu)
 			largest_mtu = slave_mtu;
-- 
2.25.1


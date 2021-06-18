Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C653AD22B
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbhFRScy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbhFRScp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 14:32:45 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5440CC061768
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:34 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id my49so17213689ejc.7
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6mIj7KiO52SrARAQx2Qhs8X77ZprGkslo3wS6baXgus=;
        b=RBUF7C3Y+t/GNQQgE5cGHj6DXg64WbelSYLtt6WbkwWpVzsqfOV13B/ljnET9ldPBr
         CdbS9ZfupJBM2vWEOjW8InWK666nWUKK/K6WN38L/gzi0OOWgVggkbZZzxHn72lkCfEO
         tEBqCLFvn+86V1hPUqIiAkrvmxkQdqCrRT5ChFIkKQqK6urWAkfUtIehzyBArn04bCuP
         lHU5ckfC46iGB8FtEo/kwwF3PkmjSgxA0OX1q+LDM99k76vTu8H8pbWqB50X7pw0i92Q
         3dlgc2c94X2k9xb3PhzVrvFs8P+8KstcRAo2H3oUD0x5NdiV/Bvf9r+cV3wWwzDRXxCb
         u/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6mIj7KiO52SrARAQx2Qhs8X77ZprGkslo3wS6baXgus=;
        b=SYpQE9uVQCNHdygE5Vt6rTZ9rLpH4L6Ka+BF+bP1+GPt7OTVQ1p9YNUVGlrZU8/FIM
         oxlURulE7QIHFG1i2T7zlNvd/N/t+hjObzEJ38MxjjNw0LIch+ZBWMhKzLIn2/cQ0ikR
         dBjiJa9dkTkU5CwSnexAnDR8tNPtGPHDCfGPoV6D6sY8njm8ttq+D8+/1+oUN+dE2Z25
         tfw5/O+lUa4KikVb0pTmtO3l1s43faUXU263RytalX1yvsh77vD80Q60E0WgxN8SK9I5
         x61pGwKSMY341homw7rSRQL+zhfz4CJHXRZV/5oqBQMj00t6z2BYQmzlcsB63YcLhVRs
         bQrA==
X-Gm-Message-State: AOAM530x2QrnBHmiVlD+EIqFqbtGGKjyWeF5YpA7+7r0nADFQqpt7SUP
        6QN4uvjRl6+iEQrH1yalLmIAp4OCCZA=
X-Google-Smtp-Source: ABdhPJxi1fqy8BiyUKOKEX/DzZc70BtEn1G3bQUnFX2uCSIX4+JHbRD51YLbY1uPOH0Vm0yGjPKO1Q==
X-Received: by 2002:a17:906:19cc:: with SMTP id h12mr12208563ejd.306.1624041032951;
        Fri, 18 Jun 2021 11:30:32 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s11sm6071988edd.65.2021.06.18.11.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 11:30:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 3/6] net: dsa: execute dsa_switch_mdb_add only for routing port in cross-chip topologies
Date:   Fri, 18 Jun 2021 21:30:14 +0300
Message-Id: <20210618183017.3340769-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210618183017.3340769-1-olteanv@gmail.com>
References: <20210618183017.3340769-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently, the notifier for adding a multicast MAC address matches on
the targeted port and on all DSA links in the system, be they upstream
or downstream links.

This leads to a considerable amount of useless traffic.

Consider this daisy chain topology, and a MDB add notifier emitted on
sw0p0. It matches on sw0p0, sw0p3, sw1p3 and sw2p4.

   sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
[  user ] [  user ] [  user ] [  dsa  ] [  cpu  ]
[   x   ] [       ] [       ] [   x   ] [       ]
                                  |
                                  +---------+
                                            |
   sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
[  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
[       ] [       ] [       ] [   x   ] [   x   ]
                                  |
                                  +---------+
                                            |
   sw2p0     sw2p1     sw2p2     sw2p3     sw2p4
[  user ] [  user ] [  user ] [  user ] [  dsa  ]
[       ] [       ] [       ] [       ] [   x   ]

But switch 0 has no reason to send the multicast traffic for that MAC
address on sw0p3, which is how it reaches switches 1 and 2. Those
switches don't expect, according to the user configuration, to receive
this multicast address from switch 1, and they will drop it anyway,
because the only valid destination is the port they received it on.
They only need to configure themselves to deliver that multicast address
_towards_ switch 1, where the MDB entry is installed.

Similarly, switch 1 should not send this multicast traffic towards
sw1p3, because that is how it reaches switch 2.

With this change, the heat map for this MDB notifier changes as follows:

   sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
[  user ] [  user ] [  user ] [  dsa  ] [  cpu  ]
[   x   ] [       ] [       ] [       ] [       ]
                                  |
                                  +---------+
                                            |
   sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
[  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
[       ] [       ] [       ] [       ] [   x   ]
                                  |
                                  +---------+
                                            |
   sw2p0     sw2p1     sw2p2     sw2p3     sw2p4
[  user ] [  user ] [  user ] [  user ] [  dsa  ]
[       ] [       ] [       ] [       ] [   x   ]

Now the mdb notifier behaves the same as the fdb notifier.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/switch.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 9bf8e20ecdf3..8b601ced6b45 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -232,36 +232,15 @@ static int dsa_switch_lag_leave(struct dsa_switch *ds,
 	return 0;
 }
 
-static bool dsa_switch_mdb_match(struct dsa_switch *ds, int port,
-				 struct dsa_notifier_mdb_info *info)
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
 static int dsa_switch_mdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
 {
-	int err = 0;
-	int port;
+	int port = dsa_towards_port(ds, info->sw_index, info->port);
 
 	if (!ds->ops->port_mdb_add)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_mdb_match(ds, port, info)) {
-			err = ds->ops->port_mdb_add(ds, port, info->mdb);
-			if (err)
-				break;
-		}
-	}
-
-	return err;
+	return ds->ops->port_mdb_add(ds, port, info->mdb);
 }
 
 static int dsa_switch_mdb_del(struct dsa_switch *ds,
-- 
2.25.1


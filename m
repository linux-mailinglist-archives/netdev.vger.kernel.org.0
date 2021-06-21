Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EBE3AF140
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhFURFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhFURFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:05:13 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E72DC051C77
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:42:37 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id my49so29786577ejc.7
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fubqmhqBlcfQuk4CIMHD6bgtFWujos5iEFVkXjRunw4=;
        b=tCxRYx3bPk3m5MMir+pvNeLqKqr/dM4oQJnSM/xcCcCk/Al9/16xv+WzjELOv1o+NE
         nOP22r/ZB/e7rkcx3jlW/hj31dwbA8keOcNyzBDPFCLE9lusCsYvo/ZYPatjHiPzK6XS
         XO4FbT188taurp49AOXGRZQN9AidnRIVKnV/07yPFi7XktQx7iSwjs7sHugQEDaEAuVw
         0O52me2O4bu7OPZClja0HAdk3Bg6AVCXtBo84ROk19rTCZdabwmSka6gn5VcyKKqC1g7
         F1zoWOKZiQ9kMOwOj6aJuFqUTvbqFTtcR5zRDtcCsQMxlzmiNYaCRUYPiNuw1MsVk7x7
         pTZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fubqmhqBlcfQuk4CIMHD6bgtFWujos5iEFVkXjRunw4=;
        b=PsrcdQbpjZbWDTomQHO5P/p9d3bOr7EwC01HFhsAun3KZTk3eqo7bpTS7/m5WTIZr2
         zB4H/RG+S1UpcZur8tODgAJ6aZc8NQ953VrsNl/QEeomn++Cym4uy1qu8iI9wpXpH3rZ
         MpQJCT7+otEoQdb+nzjcmQTRXJchXKScQQdmN+t0AJrA3mJriP5LhI2aQIxPplZKFa96
         5gTK4u2tax56+UwgVGW/YCP3b5dbv5Er4m9VGh84z9Xvp4Rf+to1kWeQi5B2MKIxOid5
         ToqxN6iciDvVWY2ZPwHkCcgAVBaoBlje4VbeHwz/h2FY99c6Kj34oKuFnmQ+620LsGeE
         U1rQ==
X-Gm-Message-State: AOAM533WOJbIkVGZthyMzU4iUWxmb57ZTJD/WELfUcFZov+mlCp78tcn
        D4mVfD9vsCsNNAWlov9atwU=
X-Google-Smtp-Source: ABdhPJzTiqHbHYdFiFbc7d6UYZgrSUorYFSbU8Pj1Mck7hpxywvMvH/qa4FR64F4wnzpLDUA/AMTNQ==
X-Received: by 2002:a17:906:69cc:: with SMTP id g12mr18368046ejs.550.1624293756467;
        Mon, 21 Jun 2021 09:42:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id c23sm10931093eds.57.2021.06.21.09.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 09:42:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 3/6] net: dsa: execute dsa_switch_mdb_add only for routing port in cross-chip topologies
Date:   Mon, 21 Jun 2021 19:42:16 +0300
Message-Id: <20210621164219.3780244-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210621164219.3780244-1-olteanv@gmail.com>
References: <20210621164219.3780244-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

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


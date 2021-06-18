Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00BE3AD22C
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbhFRScz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbhFRScq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 14:32:46 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D26EC0617A6
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:35 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s15so9831183edt.13
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bxCxdl7smdQEJi6TjESjk98pk/y1jol/SJVHGSD71tc=;
        b=KnRXkRcJ0HgUM/eqxNfc9XFczN8tNYZhxP8bCq1dipg+6PAl0OIArabqfwBtAMqNFC
         45Ge2H6L/tbNe/qI5wx56lzwpTe6NwZWaDDQf6gQW3ii+qHLrQBIdkzQCQ/4ItJFT9e8
         zWgIyB9Zeu8COAXJPWRbmay6IYxpJVejOR69tK84ToB7CmiB03LEZdgVBcXB7XWj2S7x
         SV6je155QwdHaWaCroIhOlcyG/P3uVisRjir0QbrXOBaAuFYXlzc1TYBcRxFvWSuS1a3
         yi8432yYA8uyBDFgms7yUOV50LmmXBTwySPTKNBY2jhGESqfw90eWNZg/2lUtTWixU6C
         /9DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bxCxdl7smdQEJi6TjESjk98pk/y1jol/SJVHGSD71tc=;
        b=V6QLnuTy4DCUvVcCLRlLoxyknibBk2sReBBDTpFTf8w5DlF3Rq4mCLz5yFvYCfig97
         qkDeVQwNsFl+dgPKjI8H3Lis3Cqx3Nw8oz/6WBKFraplKBSC64UD0CbJP0aHg/Ua2/Sr
         B1KeZyy8rYpZPiDdOCAh11LFs6K7enXmJseeo3xdMkE0zMGsoYwloo7u6O+fl4NUGx8u
         fg+jU1YPkUzNYKil7aocP6APrnfNlgS9zZz/E+rgYkOXR2AtH5XfTFQas3EoTC1hm2HR
         lmOJzWhIGXiKItGUiFuM2f12x3CPw+B5aPFfsMThNucZYhgTMY9NTGLnz0E507vBcmXa
         FutA==
X-Gm-Message-State: AOAM532NtUxWsjVnsiUvFUN0D8ife6v37VK2YQd2OXlUhs+Ly4v/b7eu
        vofpxhK19CWsDi84ThQMTWo=
X-Google-Smtp-Source: ABdhPJz1vwiul8f4ywvp7KV6+iCn46A9kzJJDy0X+/lGF8jViySe8pQj51hCWoOmdl4Bq+9VVxy6ag==
X-Received: by 2002:a05:6402:d06:: with SMTP id eb6mr6784441edb.337.1624041033963;
        Fri, 18 Jun 2021 11:30:33 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s11sm6071988edd.65.2021.06.18.11.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 11:30:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 4/6] net: dsa: calculate the largest_mtu across all ports in the tree
Date:   Fri, 18 Jun 2021 21:30:15 +0300
Message-Id: <20210618183017.3340769-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210618183017.3340769-1-olteanv@gmail.com>
References: <20210618183017.3340769-1-olteanv@gmail.com>
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
---
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


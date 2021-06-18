Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FFF3AD22D
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbhFRSc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbhFRScq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 14:32:46 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4AAC0617A8
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:37 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id u24so9796046edy.11
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7OCEoq1hjGxlJE++ChuaWucYdz2CNykMHpgEYv142dg=;
        b=KSbuZsd8AXX+KAQQJdd5xwvKPSPdQ0RQF8gAi8SmvyVlhpt0INmMWJ7lKyRhbuadSg
         ZUYKjcQ99eLnJ8kBjvyqI5b3qotTulDGHD5kUgQRSxd9y3W9uAKtcJ+yQ+NLEGyOun0I
         abgw9pVitpPnpng3DZ5jeGSEGMX57ZQVWeSJeF4yBZQJLkeii1eETqILnErO6uk+9jEE
         Y56TjtQbl4NVL7H9jhZPjSGQdhggUOKCm0+SpAxKjHgjTXPzhkpKXlPf/9cFuAJRqZ0+
         G8yGSnNkJhKOV2n7QryTxRcCXkJeWJJOu4Vw6D7JWKOvd5QEYq4jX8gqcuH8ncYbTGvu
         Eieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7OCEoq1hjGxlJE++ChuaWucYdz2CNykMHpgEYv142dg=;
        b=eQwL8CzgHVlYYGuVh5p25g8HeT39Oix44YEwbrAfpRgphGtaGlqSAHitZ+TrkktxLT
         yQzavKDl6D9a70q2f2PFG9CshgHgyq8OXT6AI4WIm4Z76kkEIzvjiKupIx/s3EuJN+4B
         cVu2J4t06IG9IyhnIce55Gjmw0KsVI7AlG4v2hj4vTtObaY2yNdmBEJlSGsL6XRNaVkh
         TsAqXR79iRmq3uvMyEiFMH/gBB4dYODs1Wx9mmmcfYcLgoYq3pqmC2KG7C89T6JM99Pf
         RY4gMBp+WwQc5cnzyFzfzQlBHnGTKiJUulkb7pHdeNFvyr9naFoCOh0j5QrkX46+Tphz
         7LbQ==
X-Gm-Message-State: AOAM533hBvH/KSWIS2XvH5vFBB1hdUAxZmkHIviA5bloRv3e9c3rBA1T
        3JtgEuHYbxI0Agw111wSz1U=
X-Google-Smtp-Source: ABdhPJy9GtUl11A96o8ynfC/AdnDhfyL9w5CsRlCgsao0K+OGawXe9E7I2zclovUI3+fyhIsh9VnVw==
X-Received: by 2002:a05:6402:10cc:: with SMTP id p12mr6980092edu.328.1624041035645;
        Fri, 18 Jun 2021 11:30:35 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s11sm6071988edd.65.2021.06.18.11.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 11:30:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 5/6] net: dsa: targeted MTU notifiers should only match on one port
Date:   Fri, 18 Jun 2021 21:30:16 +0300
Message-Id: <20210618183017.3340769-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210618183017.3340769-1-olteanv@gmail.com>
References: <20210618183017.3340769-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

dsa_slave_change_mtu() calls dsa_port_mtu_change() twice:
- it sends a cross-chip notifier with the MTU of the CPU port which is
  used to update the DSA links.
- it sends one targeted MTU notifier which is supposed to only match the
  user port on which we are changing the MTU. The "propagate_upstream"
  variable is used here to bypass the cross-chip notifier system from
  switch.c

But due to a mistake, the second, targeted notifier matches not only on
the user port, but also on the DSA link which is a member of the same
switch, if that exists.

And because the DSA links of the entire dst were programmed in a
previous round to the largest_mtu via a "propagate_upstream == true"
notification, then the dsa_port_mtu_change(propagate_upstream == false)
call that is immediately upcoming will break the MTU on the one DSA link
which is chip-wise local to the dp whose MTU is changing right now.

Example given this daisy chain topology:

   sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
[  cpu  ] [  user ] [  user ] [  dsa  ] [  user ]
[   x   ] [       ] [       ] [   x   ] [       ]
                                  |
                                  +---------+
                                            |
   sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
[  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
[       ] [       ] [       ] [       ] [   x   ]

ip link set sw0p1 mtu 9000
ip link set sw1p1 mtu 9000 # at this stage, sw0p1 and sw1p1 can talk
                           # to one another using jumbo frames
ip link set sw0p2 mtu 1500 # this programs the sw0p3 DSA link first to
                           # the largest_mtu of 9000, then reprograms it to
                           # 1500 with the "propagate_upstream == false"
                           # notifier, breaking communication between
                           # sw0p1 and sw1p1

To escape from this situation, make the targeted match really match on a
single port - the user port, and rename the "propagate_upstream"
variable to "targeted_match" to clarify the intention and avoid future
issues.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 4 ++--
 net/dsa/port.c     | 4 ++--
 net/dsa/slave.c    | 9 +++++----
 net/dsa/switch.c   | 9 ++++++---
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b8b17474b72b..b0811253d101 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -84,7 +84,7 @@ struct dsa_notifier_vlan_info {
 
 /* DSA_NOTIFIER_MTU */
 struct dsa_notifier_mtu_info {
-	bool propagate_upstream;
+	bool targeted_match;
 	int sw_index;
 	int port;
 	int mtu;
@@ -200,7 +200,7 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
-			bool propagate_upstream);
+			bool targeted_match);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 6379d66a6bb3..5c93f1e1a03d 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -567,11 +567,11 @@ int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
 }
 
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
-			bool propagate_upstream)
+			bool targeted_match)
 {
 	struct dsa_notifier_mtu_info info = {
 		.sw_index = dp->ds->index,
-		.propagate_upstream = propagate_upstream,
+		.targeted_match = targeted_match,
 		.port = dp->index,
 		.mtu = new_mtu,
 	};
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ac2ca5f75af3..5e668e529575 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1586,14 +1586,15 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 			goto out_master_failed;
 
 		/* We only need to propagate the MTU of the CPU port to
-		 * upstream switches.
+		 * upstream switches, so create a non-targeted notifier which
+		 * updates all switches.
 		 */
-		err = dsa_port_mtu_change(cpu_dp, cpu_mtu, true);
+		err = dsa_port_mtu_change(cpu_dp, cpu_mtu, false);
 		if (err)
 			goto out_cpu_failed;
 	}
 
-	err = dsa_port_mtu_change(dp, new_mtu, false);
+	err = dsa_port_mtu_change(dp, new_mtu, true);
 	if (err)
 		goto out_port_failed;
 
@@ -1607,7 +1608,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	if (new_master_mtu != old_master_mtu)
 		dsa_port_mtu_change(cpu_dp, old_master_mtu -
 				    dsa_tag_protocol_overhead(cpu_dp->tag_ops),
-				    true);
+				    false);
 out_cpu_failed:
 	if (new_master_mtu != old_master_mtu)
 		dev_set_mtu(master, old_master_mtu);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 8b601ced6b45..75f567390a6b 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -52,10 +52,13 @@ static int dsa_switch_ageing_time(struct dsa_switch *ds,
 static bool dsa_switch_mtu_match(struct dsa_switch *ds, int port,
 				 struct dsa_notifier_mtu_info *info)
 {
-	if (ds->index == info->sw_index)
-		return (port == info->port) || dsa_is_dsa_port(ds, port);
+	if (ds->index == info->sw_index && port == info->port)
+		return true;
 
-	if (!info->propagate_upstream)
+	/* Do not propagate to other switches in the tree if the notifier was
+	 * targeted for a single switch.
+	 */
+	if (info->targeted_match)
 		return false;
 
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
-- 
2.25.1


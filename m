Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E192AAB1E
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 14:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgKHNWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 08:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgKHNUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 08:20:17 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF2FC0613D4;
        Sun,  8 Nov 2020 05:20:16 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id v4so5904352edi.0;
        Sun, 08 Nov 2020 05:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=btNm+7NkM4nMOz6PjQpFgxw9zsVPe2xepBIf2Pk6auk=;
        b=tMUonkDYyTtsjJwMx0G3T6uiNiuiZRCPRTfqETb73mDtjFm3zum/LlA7RBNAkET/Hd
         jhRttKpXEcK8zw14siGcJNGgv4af5N/ZzGShAViZSZ6ckkIQfh1SBcTiFhQuoC9VzKdn
         gCikL+Hh9XAZP2PwkEA8vElspIfCuXQaW1oDZs6QUUSM7xtXFjSUCp0lVDE+3wBbIxKu
         J+kuG2cLSrMvaw59XF8AeoADNYFBUB/A+/1Mcysmf1VA70Tyrf00AJAQPnjecnVfHxS2
         XKR9mFXdCAk8FFCMv1GGWKvLIrUOZ+DmGqmU86Ak4aCpkDNNawgCAYgwgK2oqwRc55UT
         Uyag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=btNm+7NkM4nMOz6PjQpFgxw9zsVPe2xepBIf2Pk6auk=;
        b=TDC0pQXCFVrtP9uBij8ga9r/5bWfwSwQyOyV9MwLSrpC4ReHDhODosRewrpwHVF1WO
         caqxzDppDPuLfc8Aw4PzG8/1COoDmdwTzLeVUSoDoIfSmxkSaJN91JFODr2lVh8WL3Vj
         o6Ja47mr5mTZbFmNl3RnTL1dpuxNtzxIUdQ0TedqRd1/HVmAtpWeJ+0GWidSi0uLuwHu
         ck3MzqbCmMyJE8BJ6jYTRrMCl3iNmqPsZy1qC/9vhYMHb1KphnGNt5SY0Nv700WF0Cnt
         1RJJcdeEXSeEudTvCf2ZmwS0niTYyIWMdGTNizxa51GQgf6OR5Wvy7vBZ6xy3kbp50aq
         EFtQ==
X-Gm-Message-State: AOAM533pYqINi10LbVt/MHpK0wsqnz6GZQkkhJGzRkiI30AX0hQZrRMT
        mEsnwuRWONX0Vpc4tgIr/Co=
X-Google-Smtp-Source: ABdhPJxyaK3MyN2t+U67VNfNOYbEuVnSx0SIr7c/n5lr+JpKUGnceoUaMIIKKvbeogzAqqz1QAFvBg==
X-Received: by 2002:a50:950e:: with SMTP id u14mr10614033eda.260.1604841614912;
        Sun, 08 Nov 2020 05:20:14 -0800 (PST)
Received: from localhost.localdomain ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id og19sm5967094ejb.7.2020.11.08.05.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 05:20:14 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 3/3] net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
Date:   Sun,  8 Nov 2020 15:19:53 +0200
Message-Id: <20201108131953.2462644-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201108131953.2462644-1-olteanv@gmail.com>
References: <20201108131953.2462644-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some DSA switches (and not only) cannot learn source MAC addresses from
packets injected from the CPU. They only perform hardware address
learning from inbound traffic.

This can be problematic when we have a bridge spanning some DSA switch
ports and some non-DSA ports (which we'll call "foreign interfaces" from
DSA's perspective).

There are 2 classes of problems created by the lack of learning on
CPU-injected traffic:
- excessive flooding, due to the fact that DSA treats those addresses as
  unknown
- the risk of stale routes, which can lead to temporary packet loss

To illustrate the second class, consider the following situation, which
is common in production equipment (wireless access points, where there
is a WLAN interface and an Ethernet switch, and these form a single
bridging domain).

 AP 1:
 +------------------------------------------------------------------------+
 |                                          br0                           |
 +------------------------------------------------------------------------+
 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
 +------------+ +------------+ +------------+ +------------+ +------------+
       |                                                       ^        ^
       |                                                       |        |
       |                                                       |        |
       |                                                    Client A  Client B
       |
       |
       |
 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
 +------------+ +------------+ +------------+ +------------+ +------------+
 +------------------------------------------------------------------------+
 |                                          br0                           |
 +------------------------------------------------------------------------+
 AP 2

- br0 of AP 1 will know that Clients A and B are reachable via wlan0
- the hardware fdb of a DSA switch driver today is not kept in sync with
  the software entries on other bridge ports, so it will not know that
  clients A and B are reachable via the CPU port UNLESS the hardware
  switch itself performs SA learning from traffic injected from the CPU.
  Nonetheless, a substantial number of switches don't.
- the hardware fdb of the DSA switch on AP 2 may autonomously learn that
  Client A and B are reachable through swp0. Therefore, the software br0
  of AP 2 also may or may not learn this. In the example we're
  illustrating, some Ethernet traffic has been going on, and br0 from AP
  2 has indeed learnt that it can reach Client B through swp0.

One of the wireless clients, say Client B, disconnects from AP 1 and
roams to AP 2. The topology now looks like this:

 AP 1:
 +------------------------------------------------------------------------+
 |                                          br0                           |
 +------------------------------------------------------------------------+
 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
 +------------+ +------------+ +------------+ +------------+ +------------+
       |                                                            ^
       |                                                            |
       |                                                         Client A
       |
       |
       |                                                         Client B
       |                                                            |
       |                                                            v
 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
 +------------+ +------------+ +------------+ +------------+ +------------+
 +------------------------------------------------------------------------+
 |                                          br0                           |
 +------------------------------------------------------------------------+
 AP 2

- br0 of AP 1 still knows that Client A is reachable via wlan0 (no change)
- br0 of AP 1 will (possibly) know that Client B has left wlan0. There
  are cases where it might never find out though. Either way, DSA today
  does not process that notification in any way.
- the hardware FDB of the DSA switch on AP 1 may learn autonomously that
  Client B can be reached via swp0, if it receives any packet with
  Client 1's source MAC address over Ethernet.
- the hardware FDB of the DSA switch on AP 2 still thinks that Client B
  can be reached via swp0. It does not know that it has roamed to wlan0,
  because it doesn't perform SA learning from the CPU port.

Now Client A contacts Client B.
AP 1 routes the packet fine towards swp0 and delivers it on the Ethernet
segment.
AP 2 sees a frame on swp0 and its fdb says that the destination is swp0.
Hairpinning is disabled => drop.

This problem comes from the fact that these switches have a 'blind spot'
for addresses coming from software bridging. The generic solution is not
to assume that hardware learning can be enabled somehow, but to listen
to more bridge learning events. It turns out that the bridge driver does
learn in software from all inbound frames, in __br_handle_local_finish.
A proper SWITCHDEV_FDB_ADD_TO_DEVICE notification is emitted for the
addresses serviced by the bridge on 'foreign' interfaces. The problem is
that DSA currently only cares about SWITCHDEV_FDB_ADD_TO_DEVICE events
received on its own interfaces, such as static FDB entries.

Luckily we can change that, and DSA can listen to all switchdev FDB
add/del events in the system and figure out if those events were emitted
by a bridge that spans at least one of DSA's own ports. In case that is
true, DSA will also offload that address towards its own CPU port, in
the eventuality that there might be bridge clients attached to the DSA
switch who want to talk to the station connected to the foreign
interface.

Reported-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/slave.c | 51 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b34da39722c7..5b3b07a39105 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2120,6 +2120,28 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		dev_put(dp->slave);
 }
 
+static int dsa_lower_dev_walk(struct net_device *lower_dev,
+			      struct netdev_nested_priv *priv)
+{
+	if (dsa_slave_dev_check(lower_dev)) {
+		priv->data = netdev_priv(lower_dev);
+		return 1;
+	}
+
+	return 0;
+}
+
+struct dsa_slave_priv *dsa_slave_dev_lower_find(struct net_device *dev)
+{
+	struct netdev_nested_priv priv = {
+		.data = NULL,
+	};
+
+	netdev_walk_all_lower_dev_rcu(dev, dsa_lower_dev_walk, &priv);
+
+	return priv.data;
+}
+
 /* Called under rcu_read_lock() */
 static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				     unsigned long event, void *ptr)
@@ -2140,13 +2162,32 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		fdb_info = ptr;
 
-		if (!dsa_slave_dev_check(dev))
-			return NOTIFY_DONE;
+		if (dsa_slave_dev_check(dev)) {
+			if (!fdb_info->added_by_user)
+				return NOTIFY_OK;
+
+			dp = dsa_slave_to_port(dev);
+		} else {
+			/* Snoop addresses learnt on foreign interfaces
+			 * bridged with us, for switches that don't
+			 * automatically learn SA from CPU-injected traffic
+			 */
+			struct net_device *br_dev;
+			struct dsa_slave_priv *p;
 
-		if (!fdb_info->added_by_user)
-			return NOTIFY_OK;
+			br_dev = netdev_master_upper_dev_get_rcu(dev);
+			if (!br_dev)
+				return NOTIFY_DONE;
 
-		dp = dsa_slave_to_port(dev);
+			if (!netif_is_bridge_master(br_dev))
+				return NOTIFY_DONE;
+
+			p = dsa_slave_dev_lower_find(br_dev);
+			if (!p)
+				return NOTIFY_DONE;
+
+			dp = p->dp->cpu_dp;
+		}
 
 		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 		if (!switchdev_work)
-- 
2.25.1


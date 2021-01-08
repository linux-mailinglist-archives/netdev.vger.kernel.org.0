Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405402EEA57
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbhAHAWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729638AbhAHAWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:22:12 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DEDC0612A2
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:46 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id 6so12220281ejz.5
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WTwKauFg3SRXKHDbLU4VcdUszuHdnd8habRgKW3Rgyw=;
        b=RSZ9CGNNQ7w4p8+pTdzlgE5lnecwWgluLsn2JNXUt0gEzUS7zFzXQiuaIhuscNw9NO
         mTkBJlCd7WrxF1iWlDFLXVGEHjIKtg945YP2lN+HEqKDGy9mk46wG04g0JecvLbV4xjj
         RyTa2uYqidCZJSGlDr69H3qRGQK4TayGTYilj55xteyvp/KhqhiR+GSKpMPIt8MKXv4I
         anfDVKQLcTa1Byh4gNWoaCnzzAcVNKfiwsFEoMIXZNGpldNqMEWObexoz4XRlwXE3pbr
         s2+GdMP6CJq1R3cUoMip9Bw1RvXzlHIcCkKImA6DYl5SBLJI0HsjrDANS4SNuXPR7iHq
         ckGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WTwKauFg3SRXKHDbLU4VcdUszuHdnd8habRgKW3Rgyw=;
        b=VA/OzKpWVqmRkApSA4/9Z79t3DBeg/Gdiemb0PmvZohCKkmWOhCdUi7lXFCh8VjdFx
         f/9eOgFBCzDgsmNvc2GmTwYkIaMmIur7PwQR4r2wCQp58RqeKC4VtEcUzm1XqkVVkjmy
         qWFhVeYE0AfGVn0qxr3wlmgU5PPbrS5vRvU05iZyyXrIZ80V8WBZ4WFFBT3m1so5lXYR
         ccvZHak8bNRycwkDzRtQrfDLcp00Ix6eafqdsUFPk9EU+/tIZBtHhOOOHfXocXmr1s2S
         Od6D1Ryv30Wld64eBb+eXnN2I5hoXbMpu1hAVrBiK5e78j2Y1vP4JZGWy7FBTXc/qIa5
         qZfQ==
X-Gm-Message-State: AOAM5337EsZsiHv2o/X8mywYhO0cou+PDaFC+YmwDq4Wk1ylvrnsR3Gu
        8yK/lheza8XXwrUwyCRGinQ=
X-Google-Smtp-Source: ABdhPJyBFak7G3H62MYTU6p/E4eQZ2Sri1DVZzNHy/naK/vccuPRbDwSUbSmIHo5BF9+SvE/BrnnVA==
X-Received: by 2002:a17:907:111c:: with SMTP id qu28mr909221ejb.540.1610065245276;
        Thu, 07 Jan 2021 16:20:45 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:44 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 net-next 15/18] net: net_failover: ensure .ndo_get_stats64 can sleep
Date:   Fri,  8 Jan 2021 02:20:02 +0200
Message-Id: <20210108002005.3429956-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The failover framework sets up a virtio_net interface [ when it has the
VIRTIO_NET_F_STANDBY feature ] and a VF interface, having the same MAC
address, in a standby/active relationship. When the active VF is
unplugged, the standby virtio_net temporarily kicks in.

The failover framework registers a common upper for the active and the
standby interface, which is what the application layer uses. This is
similar to bonding/team. The statistics of the upper interface are the
sum of the statistics of the active and of the standby interface.

There is an effort to convert .ndo_get_stats64 to sleepable context, and
for that to work, we need to prevent callers of dev_get_stats from using
atomic locking. The failover driver needs protection via an RCU
read-side critical section to access the standby and the active
interface. This has two features:
- It is atomic: this needs to change.
- It is reentrant: this is ok, because generally speaking, dev_get_stats
  is recursive, and taking global locks is a bad thing from a recursive
  context.

A better locking architecture would be to do what the team driver does.
Instead of using something as broad as the rtnl_mutex to ensure
serialization of updates, it should use something more specific, like a
private mutex. This patch adds that and names it slaves_lock. The
slaves_lock now protects the only updater, the rcu_assign_pointer
sections from net_failover_slave_register.

In the team driver, a separate lockdep class is created for each team
lock, to account for possible nesting (team over team over ...). For the
net_failover driver, we can do something simpler, which is to just not
hold any lock while we call dev_get_stats recursively. We can "cheat"
and use dev_hold to take a reference on the active and backup interfaces,
and netdev_wait_allrefs() will just have to wait until we finish.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
Now there is code to propagate errors.

Changes in v3:
None.

Changes in v2:
Switched to the new scheme of holding just a refcnt to the slave
interfaces while recursing with dev_get_stats.

 drivers/net/net_failover.c | 73 ++++++++++++++++++++++++++++----------
 include/net/net_failover.h |  9 +++--
 2 files changed, 62 insertions(+), 20 deletions(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index e032ad1c5e22..580e942667f8 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -27,6 +27,9 @@
 #include <uapi/linux/if_arp.h>
 #include <net/net_failover.h>
 
+#define nfo_dereference(nfo_info, p)				\
+	rcu_dereference_protected(p, lockdep_is_held(&nfo_info->slaves_lock))
+
 static bool net_failover_xmit_ready(struct net_device *dev)
 {
 	return netif_running(dev) && netif_carrier_ok(dev);
@@ -183,34 +186,59 @@ static int net_failover_get_stats(struct net_device *dev,
 				  struct rtnl_link_stats64 *stats)
 {
 	struct net_failover_info *nfo_info = netdev_priv(dev);
-	struct rtnl_link_stats64 temp;
-	struct net_device *slave_dev;
+	struct rtnl_link_stats64 primary_stats;
+	struct rtnl_link_stats64 standby_stats;
+	struct net_device *primary_dev;
+	struct net_device *standby_dev;
+	int err = 0;
 
-	spin_lock(&nfo_info->stats_lock);
-	memcpy(stats, &nfo_info->failover_stats, sizeof(*stats));
+	mutex_lock(&nfo_info->slaves_lock);
 
-	rcu_read_lock();
+	primary_dev = nfo_dereference(nfo_info, nfo_info->primary_dev);
+	if (primary_dev)
+		dev_hold(primary_dev);
 
-	slave_dev = rcu_dereference(nfo_info->primary_dev);
-	if (slave_dev) {
-		dev_get_stats(slave_dev, &temp);
-		net_failover_fold_stats(stats, &temp, &nfo_info->primary_stats);
-		memcpy(&nfo_info->primary_stats, &temp, sizeof(temp));
+	standby_dev = nfo_dereference(nfo_info, nfo_info->standby_dev);
+	if (standby_dev)
+		dev_hold(standby_dev);
+
+	mutex_unlock(&nfo_info->slaves_lock);
+
+	/* Don't hold slaves_lock while calling dev_get_stats, just a
+	 * reference to ensure they won't get unregistered.
+	 */
+	if (primary_dev) {
+		err = dev_get_stats(primary_dev, &primary_stats);
+		if (err)
+			goto out;
 	}
 
-	slave_dev = rcu_dereference(nfo_info->standby_dev);
-	if (slave_dev) {
-		dev_get_stats(slave_dev, &temp);
-		net_failover_fold_stats(stats, &temp, &nfo_info->standby_stats);
-		memcpy(&nfo_info->standby_stats, &temp, sizeof(temp));
+	if (standby_dev) {
+		err = dev_get_stats(standby_dev, &standby_stats);
+		if (err)
+			goto out;
 	}
 
-	rcu_read_unlock();
+	mutex_lock(&nfo_info->stats_lock);
+
+	memcpy(stats, &nfo_info->failover_stats, sizeof(*stats));
+
+	net_failover_fold_stats(stats, &primary_stats, &nfo_info->primary_stats);
+	memcpy(&nfo_info->primary_stats, &primary_stats, sizeof(primary_stats));
+	net_failover_fold_stats(stats, &standby_stats, &nfo_info->standby_stats);
+	memcpy(&nfo_info->standby_stats, &standby_stats, sizeof(standby_stats));
 
 	memcpy(&nfo_info->failover_stats, stats, sizeof(*stats));
-	spin_unlock(&nfo_info->stats_lock);
 
-	return 0;
+out:
+	mutex_unlock(&nfo_info->stats_lock);
+
+	if (primary_dev)
+		dev_put(primary_dev);
+	if (standby_dev)
+		dev_put(standby_dev);
+
+	return err;
 }
 
 static int net_failover_change_mtu(struct net_device *dev, int new_mtu)
@@ -542,6 +570,8 @@ static int net_failover_slave_register(struct net_device *slave_dev,
 	primary_dev = rtnl_dereference(nfo_info->primary_dev);
 	slave_is_standby = slave_dev->dev.parent == failover_dev->dev.parent;
 
+	mutex_lock(&nfo_info->slaves_lock);
+
 	if (slave_is_standby) {
 		rcu_assign_pointer(nfo_info->standby_dev, slave_dev);
 		standby_dev = slave_dev;
@@ -554,6 +584,8 @@ static int net_failover_slave_register(struct net_device *slave_dev,
 		failover_dev->max_mtu = slave_dev->max_mtu;
 	}
 
+	mutex_unlock(&nfo_info->slaves_lock);
+
 	net_failover_lower_state_changed(slave_dev, primary_dev, standby_dev);
 	net_failover_compute_features(failover_dev);
 
@@ -711,6 +743,7 @@ static struct failover_ops net_failover_ops = {
 struct failover *net_failover_create(struct net_device *standby_dev)
 {
 	struct device *dev = standby_dev->dev.parent;
+	struct net_failover_info *nfo_info;
 	struct net_device *failover_dev;
 	struct failover *failover;
 	int err;
@@ -755,6 +788,10 @@ struct failover *net_failover_create(struct net_device *standby_dev)
 	failover_dev->min_mtu = standby_dev->min_mtu;
 	failover_dev->max_mtu = standby_dev->max_mtu;
 
+	nfo_info = netdev_priv(failover_dev);
+	mutex_init(&nfo_info->slaves_lock);
+	mutex_init(&nfo_info->stats_lock);
+
 	err = register_netdev(failover_dev);
 	if (err) {
 		dev_err(dev, "Unable to register failover_dev!\n");
diff --git a/include/net/net_failover.h b/include/net/net_failover.h
index b12a1c469d1c..988cdfaf14ca 100644
--- a/include/net/net_failover.h
+++ b/include/net/net_failover.h
@@ -23,8 +23,13 @@ struct net_failover_info {
 	/* aggregated stats */
 	struct rtnl_link_stats64 failover_stats;
 
-	/* spinlock while updating stats */
-	spinlock_t stats_lock;
+	/* lock for updating stats */
+	struct mutex stats_lock;
+
+	/* lock for protecting lower interfaces.
+	 * TODO: convert all rtnl_dereference instances to nfo_dereference
+	 */
+	struct mutex slaves_lock;
 };
 
 struct failover *net_failover_create(struct net_device *standby_dev);
-- 
2.25.1


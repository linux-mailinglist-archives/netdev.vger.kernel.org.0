Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08627AC6CF
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 15:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394637AbfIGNqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 09:46:42 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33647 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394633AbfIGNqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 09:46:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id t11so4533460plo.0
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 06:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ez+JQwAKzEE02AdYPD2+QO7ui6wsJKK0ozfhm0sDP5o=;
        b=kd1h5PF+AlblPc47/v37Cs4/a4EQACdJGnkG7TMmbpX2LsM0UFNW3x9N1FwfAkNieZ
         zHZ10EHHJjJqweScHDsHSdp4HbvxidLLfHUZwa+f5UXJN24UgkHWOlgBj0F0jJ1np1eL
         vW66PPXo9D4n3yTEgvHSt0YpR/GQILUFMVIsb+uZF5gOXkgsgrdzXSeu3U3QeRbqJFxB
         mQ67O5tzdkVsBqHUTzKcXOKHqSFYwq9i/TXkRWP01vy4Uff+yyF1pFgHaGxc2ElYxSJT
         Q9H9avbNjFVxNoAKHZhDN1780cIWkEYYzKVvBP4+HxqtLxGE2/PCnyJkYnlduzP7aO43
         Im4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ez+JQwAKzEE02AdYPD2+QO7ui6wsJKK0ozfhm0sDP5o=;
        b=WvPp1LGrBe8+WwiAaYE3hzeYBVz3xljh7qlJepuFzoLTo6PXLpLrSXT2mrKVUNWI6v
         UQSoXlUjbwZcqguyxguhzH2REshkp5m9/bY27r/Wnym4hbQpw7LI1BGbT1HwJzRjRQlZ
         RsUIyS3IsQFuYHfcUjYEsIJZuDgWc6GRpFv+8pLMTqLeTnOSQbc9tdneo2KRQoZidbMp
         pVIedsl/qpH8dvLsAAet3nDOA33q99rRZgjHtqHHOlghc4J4CqxvJmsZ38afUR4VN0hT
         bQHdy1+ijpKd6R8HKopM9LHFGMYTRdjwlLEK4YXs6+y5rSo883JBsked2nuGL5SB3y3O
         c5UQ==
X-Gm-Message-State: APjAAAVy0yOgiULAYkXn0rKKg+oLf8wKaeaFrDfpt/BtHnM3VyqT+fdL
        0s2l+E4Wk0N5LpKhT6TnsUNC5XQZUqY=
X-Google-Smtp-Source: APXvYqwWMLISQL1GlbJwSq3HhjxubRMxpAh3T0hB6XUS0prVbMEwPrETNumcvzQZc4Bl2IUSVIjSjQ==
X-Received: by 2002:a17:902:26f:: with SMTP id 102mr14996787plc.189.1567864001077;
        Sat, 07 Sep 2019 06:46:41 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id g2sm10187147pfm.32.2019.09.07.06.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 06:46:40 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com, jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 05/11] team: use dynamic lockdep key instead of static key
Date:   Sat,  7 Sep 2019 22:46:31 +0900
Message-Id: <20190907134631.32325-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current code, all team devices have same static lockdep key
and team devices could be nested so that it makes unnecessary
lockdep warning.

Test commands:
    ip link add team0 type team
    for i in {1..7}
    do
	    let A=$i-1
	    ip link add team$i type team
	    ip link set team$i master team$A
    done
    ip link del team0

Splat looks like:
[  137.406730] ============================================
[  137.412685] WARNING: possible recursive locking detected
[  137.418642] 5.3.0-rc7+ #322 Not tainted
[  137.422941] --------------------------------------------
[  137.428886] ip/1383 is trying to acquire lock:
[  137.433869] 0000000089571080 (&dev_addr_list_lock_key/1){+...}, at: dev_uc_sync_multiple+0xfa/0x1a0
[  137.444034]
[  137.444034] but task is already holding lock:
[  137.450572] 00000000d9597252 (&dev_addr_list_lock_key/1){+...}, at: dev_uc_unsync+0x10c/0x1b0
[  137.460142]
[  137.460142] other info that might help us debug this:
[  137.467458]  Possible unsafe locking scenario:
[  137.467458]
[  137.474096]        CPU0
[  137.476828]        ----
[  137.479569]   lock(&dev_addr_list_lock_key/1);
[  137.484554]   lock(&dev_addr_list_lock_key/1);
[  137.489539]
[  137.489539]  *** DEADLOCK ***
[  137.489539]
[  137.496178]  May be due to missing lock nesting notation
[  137.496178]
[  137.503789] 5 locks held by ip/1383:
[  137.507797]  #0: 00000000d497f415 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[  137.516786]  #1: 000000008e4b4656 (&team->lock){+.+.}, at: team_uninit+0x3a/0x1a0 [team]
[  137.525882]  #2: 000000005cf248d1 (&dev_addr_list_lock_key){+...}, at: dev_uc_unsync+0x98/0x1b0
[  137.535649]  #3: 00000000d9597252 (&dev_addr_list_lock_key/1){+...}, at: dev_uc_unsync+0x10c/0x1b0
[  137.545709]  #4: 00000000bec134c3 (rcu_read_lock){....}, at: team_set_rx_mode+0x5/0x1d0 [team]
[  137.555384]
[  137.555384] stack backtrace:
[  137.560277] CPU: 0 PID: 1383 Comm: ip Not tainted 5.3.0-rc7+ #322
[  137.577826] Call Trace:
[  137.580586]  dump_stack+0x7c/0xbb
[  137.584307]  __lock_acquire+0x26a9/0x3de0
[  137.588820]  ? register_lock_class+0x14d0/0x14d0
[  137.594008]  ? register_lock_class+0x14d0/0x14d0
[  137.599194]  lock_acquire+0x164/0x3b0
[  137.603310]  ? dev_uc_sync_multiple+0xfa/0x1a0
[  137.608307]  _raw_spin_lock_nested+0x2e/0x60
[  137.613105]  ? dev_uc_sync_multiple+0xfa/0x1a0
[  137.618095]  dev_uc_sync_multiple+0xfa/0x1a0
[  137.622900]  team_set_rx_mode+0xa9/0x1d0 [team]
[  137.627993]  dev_uc_unsync+0x151/0x1b0
[  137.632205]  team_port_del+0x304/0x790 [team]
[  137.637110]  team_uninit+0xb0/0x1a0 [team]
[  137.641717]  rollback_registered_many+0x728/0xda0
[  137.647005]  ? generic_xdp_install+0x310/0x310
[  137.651994]  ? __set_pages_p+0xf4/0x150
[  137.656306]  ? check_chain_key+0x236/0x5d0
[  137.660914]  ? __nla_validate_parse+0x98/0x1ad0
[  137.666006]  unregister_netdevice_many.part.120+0x13/0x1b0
[  137.672167]  rtnl_delete_link+0xbc/0x100
[  137.676575]  ? rtnl_af_register+0xc0/0xc0
[  137.681084]  rtnl_dellink+0x2e7/0x870
[  137.685204]  ? find_held_lock+0x39/0x1d0
[  ... ]

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2 : this patch isn't changed

 drivers/net/team/team.c | 61 ++++++++++++++++++++++++++++++++++++++---
 include/linux/if_team.h |  5 ++++
 2 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index e8089def5a46..bfcd6ed57493 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1607,6 +1607,34 @@ static const struct team_option team_options[] = {
 	},
 };
 
+static void team_dev_set_lockdep_one(struct net_device *dev,
+				     struct netdev_queue *txq,
+				     void *_unused)
+{
+	struct team *team = netdev_priv(dev);
+
+	lockdep_set_class(&txq->_xmit_lock, &team->xmit_lock_key);
+}
+
+static struct lock_class_key qdisc_tx_busylock_key;
+static struct lock_class_key qdisc_running_key;
+
+static void team_dev_set_lockdep_class(struct net_device *dev)
+{
+	struct team *team = netdev_priv(dev);
+
+	dev->qdisc_tx_busylock = &qdisc_tx_busylock_key;
+	dev->qdisc_running_key = &qdisc_running_key;
+
+	lockdep_register_key(&team->team_lock_key);
+	__mutex_init(&team->lock, "team->team_lock_key", &team->team_lock_key);
+
+	lockdep_register_key(&team->addr_lock_key);
+	lockdep_set_class(&dev->addr_list_lock, &team->addr_lock_key);
+
+	lockdep_register_key(&team->xmit_lock_key);
+	netdev_for_each_tx_queue(dev, team_dev_set_lockdep_one, NULL);
+}
 
 static int team_init(struct net_device *dev)
 {
@@ -1615,7 +1643,6 @@ static int team_init(struct net_device *dev)
 	int err;
 
 	team->dev = dev;
-	mutex_init(&team->lock);
 	team_set_no_mode(team);
 
 	team->pcpu_stats = netdev_alloc_pcpu_stats(struct team_pcpu_stats);
@@ -1642,7 +1669,7 @@ static int team_init(struct net_device *dev)
 		goto err_options_register;
 	netif_carrier_off(dev);
 
-	netdev_lockdep_set_classes(dev);
+	team_dev_set_lockdep_class(dev);
 
 	return 0;
 
@@ -1673,6 +1700,11 @@ static void team_uninit(struct net_device *dev)
 	team_queue_override_fini(team);
 	mutex_unlock(&team->lock);
 	netdev_change_features(dev);
+
+	lockdep_unregister_key(&team->team_lock_key);
+	lockdep_unregister_key(&team->addr_lock_key);
+	lockdep_unregister_key(&team->xmit_lock_key);
+
 }
 
 static void team_destructor(struct net_device *dev)
@@ -1967,6 +1999,23 @@ static int team_add_slave(struct net_device *dev, struct net_device *port_dev,
 	return err;
 }
 
+static void team_update_lock_key(struct net_device *dev)
+{
+	struct team *team = netdev_priv(dev);
+
+	lockdep_unregister_key(&team->team_lock_key);
+	lockdep_unregister_key(&team->addr_lock_key);
+	lockdep_unregister_key(&team->xmit_lock_key);
+
+	lockdep_register_key(&team->team_lock_key);
+	lockdep_register_key(&team->addr_lock_key);
+	lockdep_register_key(&team->xmit_lock_key);
+
+	lockdep_set_class(&team->lock, &team->team_lock_key);
+	lockdep_set_class(&dev->addr_list_lock, &team->addr_lock_key);
+	netdev_for_each_tx_queue(dev, team_dev_set_lockdep_one, NULL);
+}
+
 static int team_del_slave(struct net_device *dev, struct net_device *port_dev)
 {
 	struct team *team = netdev_priv(dev);
@@ -1976,8 +2025,12 @@ static int team_del_slave(struct net_device *dev, struct net_device *port_dev)
 	err = team_port_del(team, port_dev);
 	mutex_unlock(&team->lock);
 
-	if (!err)
-		netdev_change_features(dev);
+	if (err)
+		return err;
+
+	if (netif_is_team_master(port_dev))
+		team_update_lock_key(port_dev);
+	netdev_change_features(dev);
 
 	return err;
 }
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index 06faa066496f..9c97bb19ed34 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -223,6 +223,11 @@ struct team {
 		atomic_t count_pending;
 		struct delayed_work dw;
 	} mcast_rejoin;
+
+	struct lock_class_key team_lock_key;
+	struct lock_class_key xmit_lock_key;
+	struct lock_class_key addr_lock_key;
+
 	long mode_priv[TEAM_MODE_PRIV_LONGS];
 };
 
-- 
2.17.1


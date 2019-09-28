Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF489C115C
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 18:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbfI1Qtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 12:49:47 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44781 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1Qtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 12:49:47 -0400
Received: by mail-pf1-f196.google.com with SMTP id q21so3211137pfn.11;
        Sat, 28 Sep 2019 09:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lnnmWURm6k9EQ+DtQjsTtP1Aom1VoK7uWrgxpoaLKOE=;
        b=o0lMz0VE40vlza5M+WJNxNwKuMx1r+ycjXNKAgbbkneJqZ07HwimgQrnHDgZ8PJfRI
         tYqsKkmUpJzORbsH5hN149wnBOD4vTTksB8uxcvyGaW4vkd/5XKZkHfnRoG/+u41S53N
         CG8B0TKVc+GpekWrdxRmVvnl1F9MU2rDde+1wLGPa0NkVw+UwGldX87oNZpKraRlJDUi
         LwxlsKfx7EGl60JZ3CyTgC27bR0n3WIfcR2GL628b9+gdEu6wR0jyqxfcinjampJWpF4
         uXcm7A0nCb1IT9/x66sx/aKcpjkgiBefV2qPbEv7w5hpp2JPbxf+TBvZ6DaPnap63nlR
         jjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lnnmWURm6k9EQ+DtQjsTtP1Aom1VoK7uWrgxpoaLKOE=;
        b=HxtbuNjiz4jl0X2/MO+XvRcSA2jtXK45Bk8Eyyy79bEhqynbgxFZM7FJvFzAxanopL
         aSLPW24b6ik5bsfaqS4xpK/en4YcVs714FKFQNUYRhrDh1HKi8NCV6mbHJsF5h4HLnkV
         Q+kvwOxd4oNAPaiBqdCi9xUAe1GtzAolA+mAvogBDmIw0YOkQ30+JytQyIMdCM6CB2bA
         j9uvPjq/jqtZw6Iv4pWuY/MO/G98DNP3ni88iQI0PsRI9ItqcuQt9PtgjmAj9g7I8HSH
         gw446dsL441z8eRgeUyiyteOxFHo76qNq6Yme/qDKAT4LTDCfmSNuNHH9En8HoXb77m+
         TrQg==
X-Gm-Message-State: APjAAAWwJNDs85hpUv8FnrpNkH1MiBn2xcIHJxorzbHhc9D8ITefAavl
        naQkvQO6P16mmh142BdO4do=
X-Google-Smtp-Source: APXvYqxiSRtDEU5B9WFF29tEuwnCB/nA04RUYniYjhWKZMFFY/jbI/xP9lErBLWwWDAQAeAvvj8IXw==
X-Received: by 2002:a17:90a:8990:: with SMTP id v16mr17195585pjn.131.1569689386390;
        Sat, 28 Sep 2019 09:49:46 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 30sm8663092pjk.25.2019.09.28.09.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 09:49:45 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Cc:     ap420073@gmail.com
Subject: [PATCH net v4 05/12] team: use dynamic lockdep key instead of static key
Date:   Sat, 28 Sep 2019 16:48:36 +0000
Message-Id: <20190928164843.31800-6-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190928164843.31800-1-ap420073@gmail.com>
References: <20190928164843.31800-1-ap420073@gmail.com>
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
[   32.862645] WARNING: possible recursive locking detected                                
[   32.863304] 5.3.0+ #3 Not tainted                                                              
[   32.863700] --------------------------------------------                                          
[   32.864358] ip/647 is trying to acquire lock:                                                 
[   32.864968] ffff8880666a6ad8 (&dev_addr_list_lock_key/1){+...}, at: dev_uc_sync_multiple+0xfa/0x1a0
[   32.866047]                              
[   32.866047] but task is already holding lock:             
[   32.866744] ffff888067402558 (&dev_addr_list_lock_key/1){+...}, at: dev_uc_unsync+0x10c/0x1b0
[   32.867774]                                 
[   32.867774] other info that might help us debug this:
[   32.868513]  Possible unsafe locking scenario: 
[   32.868513]                                     
[   32.869180]        CPU0                         
[   32.872973]        ----                   
[   32.876717]   lock(&dev_addr_list_lock_key/1);
[   32.877130]   lock(&dev_addr_list_lock_key/1);
[   32.877621]                                   
[   32.877621]  *** DEADLOCK ***               
[   32.877621]                                    
[   32.878284]  May be due to missing lock nesting notation
[   32.878284]                                  
[   32.878999] 5 locks held by ip/647:       
[   32.879382]  #0: ffffffff8fec7a30 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[   32.880110]  #1: ffff888068d5e300 (&team->lock){+.+.}, at: team_uninit+0x3a/0x1a0 [team]
[   32.880889]  #2: ffff888068d5d978 (&dev_addr_list_lock_key){+...}, at: dev_uc_unsync+0x98/0x1b0
[   32.881660]  #3: ffff888067402558 (&dev_addr_list_lock_key/1){+...}, at: dev_uc_unsync+0x10c/0x1b0
[   32.882451]  #4: ffffffff8fb22780 (rcu_read_lock){....}, at: team_set_rx_mode+0x5/0x1d0 [team]
[   32.883209]                               
[   32.883209] stack backtrace:                                                                                          
[   32.883605] CPU: 0 PID: 647 Comm: ip Not tainted 5.3.0+ #3                        
[   32.884144] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   32.884926] Call Trace:                                                      
[   32.885151]  dump_stack+0x7c/0xbb                                            
[   32.885460]  __lock_acquire+0x26a9/0x3df0                                    
[   32.885964]  ? register_lock_class+0x14d0/0x14d0                             
[   32.886522]  ? register_lock_class+0x14d0/0x14d0            
[   32.887114]  lock_acquire+0x164/0x3b0     
[   32.887578]  ? dev_uc_sync_multiple+0xfa/0x1a0                                                                       
[   32.888130]  _raw_spin_lock_nested+0x2e/0x60
[   32.888725]  ? dev_uc_sync_multiple+0xfa/0x1a0
[   32.889264]  dev_uc_sync_multiple+0xfa/0x1a0
[   32.889779]  team_set_rx_mode+0xa9/0x1d0 [team]
[   32.892841]  dev_uc_unsync+0x151/0x1b0
[ ... ]

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v4 :
 - This patch is not changed

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


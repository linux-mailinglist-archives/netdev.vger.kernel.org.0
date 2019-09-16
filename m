Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5725B3BC7
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387846AbfIPNsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:48:53 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35754 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387751AbfIPNsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:48:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id s17so12037877plp.2
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kiGUwG3+6UAbXYJEPg2wTZRIJUJDxXRvDswcnUc5v6U=;
        b=g4seRh1iShjj5fCZi2jL2CsAx8Edv3dDJ61u+PqqAtCfDt/JrSeu+2QTQ8ljbMgSLR
         tAbeGUQ10CxEupUaJ4nWGcMNlk/39gGEPisC4zkXvjGDzqlUsIBQJs9dYyO/GWaOMWVd
         CU0enJJLJ8/bsl13NpbuMDDVcNWE7LVBZEhIZrBfEhugK9uLdRVuazqNpv2U2Gl2HCNA
         qVlmcCoXNYn2HBUzwNyA+HcsAUHAln6fv2eteiZsZ8237pBL0G7Kvs02etvIyeUSbNx6
         jHukQE3NXIvDf/hhVMYN5czAVmfQpp4RdQ7Mgz8u57TzVMNxCtc2YcjCp3cVIY1YslQh
         nRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kiGUwG3+6UAbXYJEPg2wTZRIJUJDxXRvDswcnUc5v6U=;
        b=sCDqvWlCFUeItQwEdSlZPgZuiOJNmBy8jXcMb4y4ATF4as0rK+gFNFleYrUpJD1AXV
         PM6UtRC64rFPMHiykl6FhvIFiZGzaZUrX1biYHZmUkY57qbA894qpLTXwjPojzCYGDcE
         Q5Mziw+XzKpyAglTcJIvaoNklTEn9+ZeIvJpGpxSK2wZL83BKOw4SIysk+yjs2IyJn9L
         sIEPrNag+EBFnxWyDiyRdBRK2ffWew8+UOS16hUS0leLB+8CGLgBr1KzuOljHbZNA8qo
         ZFD7fEsZoERkZW9SmuinavUp6STNKs1UjyFwheBUDRB61tI16iFtjXdpUeDWqXs7FlFi
         zCOw==
X-Gm-Message-State: APjAAAWgsTO0V1McLQ1Nh17jWp8UTCeiVDRjsHDvp/Yq/5X4zieOOPXd
        x8o+W+mD/ZANwJT9bErgZ+Q=
X-Google-Smtp-Source: APXvYqxGw0GDbTMzCSa6XKtAqktAliHx/SqcfDztpl5EfzZ8uVJT1a+jd7fvXS1eTcA56+Q2xvCCuw==
X-Received: by 2002:a17:902:7d8b:: with SMTP id a11mr11562101plm.149.1568641730058;
        Mon, 16 Sep 2019 06:48:50 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id z20sm2822266pjn.12.2019.09.16.06.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 06:48:49 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 05/11] team: use dynamic lockdep key instead of static key
Date:   Mon, 16 Sep 2019 22:47:56 +0900
Message-Id: <20190916134802.8252-6-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916134802.8252-1-ap420073@gmail.com>
References: <20190916134802.8252-1-ap420073@gmail.com>
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
[   52.518420] WARNING: possible recursive locking detected
[   52.518955] 5.3.0-rc8+ #179 Not tainted
[   52.519373] --------------------------------------------
[   52.519925] ip/1005 is trying to acquire lock:
[   52.520893] 00000000c84e69ac (&dev_addr_list_lock_key/1){+...}, at: dev_uc_sync_multiple+0xfa/0x1a0
[   52.522194]
[   52.522194] but task is already holding lock:
[   52.523038] 0000000025864f52 (&dev_addr_list_lock_key/1){+...}, at: dev_uc_unsync+0x10c/0x1b0
[   52.524609]
[   52.524609] other info that might help us debug this:
[   52.525435]  Possible unsafe locking scenario:
[   52.525435]
[   52.526154]        CPU0
[   52.526460]        ----
[   52.526766]   lock(&dev_addr_list_lock_key/1);
[   52.527311]   lock(&dev_addr_list_lock_key/1);
[   52.527854]
[   52.527854]  *** DEADLOCK ***
[   52.527854]
[   52.528573]  May be due to missing lock nesting notation
[   52.528573]
[   52.529527] 5 locks held by ip/1005:
[   52.529968]  #0: 0000000080a68bb2 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[   52.530940]  #1: 0000000035d90450 (&team->lock){+.+.}, at: team_uninit+0x3a/0x1a0 [team]
[   52.531933]  #2: 00000000c75d8f70 (&dev_addr_list_lock_key){+...}, at: dev_uc_unsync+0x98/0x1b0
[   52.532991]  #3: 0000000025864f52 (&dev_addr_list_lock_key/1){+...}, at: dev_uc_unsync+0x10c/0x1b0
[   52.534142]  #4: 00000000efa4d642 (rcu_read_lock){....}, at: team_set_rx_mode+0x5/0x1d0 [team]
[   52.535195]
[   52.535195] stack backtrace:
[   52.535727] CPU: 0 PID: 1005 Comm: ip Not tainted 5.3.0-rc8+ #179
[   52.536376] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   52.537254] Call Trace:
[   52.537549]  dump_stack+0x7c/0xbb
[   52.537917]  __lock_acquire+0x26a9/0x3de0
[   52.538340]  ? register_lock_class+0x14d0/0x14d0
[   52.538872]  ? register_lock_class+0x14d0/0x14d0
[   52.539559]  lock_acquire+0x164/0x3b0
[   52.540043]  ? dev_uc_sync_multiple+0xfa/0x1a0
[   52.540663]  _raw_spin_lock_nested+0x2e/0x60
[   52.541241]  ? dev_uc_sync_multiple+0xfa/0x1a0
[   52.541867]  dev_uc_sync_multiple+0xfa/0x1a0
[   52.542435]  team_set_rx_mode+0xa9/0x1d0 [team]
[   52.543033]  dev_uc_unsync+0x151/0x1b0
[   52.543534]  team_port_del+0x304/0x790 [team]
[   52.544110]  team_uninit+0xb0/0x1a0 [team]
[   52.544653]  rollback_registered_many+0x728/0xda0
[   52.545271]  ? generic_xdp_install+0x310/0x310
[   52.545865]  ? check_chain_key+0x236/0x5d0
[   52.546425]  ? __nla_validate_parse+0x98/0x1ad0
[   52.547023]  unregister_netdevice_many.part.124+0x13/0x1b0
[   52.547741]  rtnl_delete_link+0xbc/0x100
[   52.548262]  ? rtnl_af_register+0xc0/0xc0
[   52.548793]  rtnl_dellink+0x30e/0x8a0
[ ... ]

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3 :
 - This patch is not changed
v1 -> v2 :
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


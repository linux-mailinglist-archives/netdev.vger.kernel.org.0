Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECE9DDF554
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbfJUSsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:48:52 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32961 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfJUSsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:48:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id i76so8356366pgc.0;
        Mon, 21 Oct 2019 11:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RXedEVaEhbQ1etXK4iTyhIN9jyo2TEProjX4EYbStPQ=;
        b=Vw9ed4aNpT6XJXChwOAGSgdJl61a9JZQe3Q0PkMPBF44g0Exb3QD+bBD6q7M+n5do+
         BUQhhQTVae9I0iPnlwa1xCiVd4v9Jhvmd0AhdmRI4Bfj7nKO8Ofvh+mfq2Hlv13O9Ooz
         v0/ybUXKdoOj25CBRYDq9mBeBtkWkeirS6ltUB/L8Y5Lfm52yGCLQV4hRm9JwrsWppaN
         QO+UU8Z87Gm/Bi0MUHQ9v02uGnLA2j7Tw0DKjZ2r5gQ54G2h/DNaYX7ym42GevuBDilH
         o5tDwTS+92rDnA1hteeRCTlp01GWjojis0xVJGF5tffXgUyyIO8hC1vwhaJnFk1RCj8B
         IYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RXedEVaEhbQ1etXK4iTyhIN9jyo2TEProjX4EYbStPQ=;
        b=Cyll3+sEKPXJep6q/zGy1xSw2MrXIXkOC8rv0uxrQbScNz/Ca0GXJCrr2/rs0Jl0HM
         A6WVhcfbSfXDeLJXJCJMQIapg5j0dBpTSp9WrYW3EpUvQOTlBVTAubly7fR0ZpVTS3Gl
         oILdJaAWxfum/mPrp8P6XALI9b8vA4sYQ88vGV1dX9z0EjV8++3lJfWkNY/x6M72HHrH
         9jBntWMC2XEyZ5aBvEMmv3caW1uR0PbsPtW0LKHL37/vfFp6WOVRSSTSRgeJLmQ0zfxz
         RUYWrOYfDN+k9Y3/+z5mCo0yMQJBboPLj+5hsW5TLIvAEMQljTPDmO8ake5avIVRxQ1B
         dSlQ==
X-Gm-Message-State: APjAAAXb9Dov90b7er9gglQP3f0W0CJMLWLwn+lWEGRF7YcvVQJNT0xp
        aDsp7D8VfXidQdSzvc+5MhM=
X-Google-Smtp-Source: APXvYqyzCzyzYPJ3ls2ougnPrdO16+Vk01fz6oAjgR2pVbc7aRL2PwhByeDV3UdJs3B9kvDbETbX8w==
X-Received: by 2002:a17:90a:3203:: with SMTP id k3mr30053792pjb.23.1571683729531;
        Mon, 21 Oct 2019 11:48:49 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id ev20sm14502835pjb.19.2019.10.21.11.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 11:48:48 -0700 (PDT)
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
Subject: [PATCH net v5 05/10] team: fix nested locking lockdep warning
Date:   Mon, 21 Oct 2019 18:47:54 +0000
Message-Id: <20191021184759.13125-5-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021184759.13125-1-ap420073@gmail.com>
References: <20191021184759.13125-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

team interface could be nested and it's lock variable could be nested too.
But this lock uses static lockdep key and there is no nested locking
handling code such as mutex_lock_nested() and so on.
so the Lockdep would warn about the circular locking scenario that
couldn't happen.
In order to fix, this patch makes the team module to use dynamic lock key
instead of static key.

Test commands:
    ip link add team0 type team
    ip link add team1 type team
    ip link set team0 master team1
    ip link set team0 nomaster
    ip link set team1 master team0
    ip link set team1 nomaster

Splat that looks like:
[   40.364352] WARNING: possible recursive locking detected
[   40.364964] 5.4.0-rc3+ #96 Not tainted
[   40.365405] --------------------------------------------
[   40.365973] ip/750 is trying to acquire lock:
[   40.366542] ffff888060b34c40 (&team->lock){+.+.}, at: team_set_mac_address+0x151/0x290 [team]
[   40.367689]
	       but task is already holding lock:
[   40.368729] ffff888051201c40 (&team->lock){+.+.}, at: team_del_slave+0x29/0x60 [team]
[   40.370280]
	       other info that might help us debug this:
[   40.371159]  Possible unsafe locking scenario:

[   40.371942]        CPU0
[   40.372338]        ----
[   40.372673]   lock(&team->lock);
[   40.373115]   lock(&team->lock);
[   40.373549]
	       *** DEADLOCK ***

[   40.374432]  May be due to missing lock nesting notation

[   40.375338] 2 locks held by ip/750:
[   40.375851]  #0: ffffffffabcc42b0 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[   40.376927]  #1: ffff888051201c40 (&team->lock){+.+.}, at: team_del_slave+0x29/0x60 [team]
[   40.377989]
	       stack backtrace:
[   40.378650] CPU: 0 PID: 750 Comm: ip Not tainted 5.4.0-rc3+ #96
[   40.379368] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   40.380574] Call Trace:
[   40.381208]  dump_stack+0x7c/0xbb
[   40.381959]  __lock_acquire+0x269d/0x3de0
[   40.382817]  ? register_lock_class+0x14d0/0x14d0
[   40.383784]  ? check_chain_key+0x236/0x5d0
[   40.384518]  lock_acquire+0x164/0x3b0
[   40.385074]  ? team_set_mac_address+0x151/0x290 [team]
[   40.385805]  __mutex_lock+0x14d/0x14c0
[   40.386371]  ? team_set_mac_address+0x151/0x290 [team]
[   40.387038]  ? team_set_mac_address+0x151/0x290 [team]
[   40.387632]  ? mutex_lock_io_nested+0x1380/0x1380
[   40.388245]  ? team_del_slave+0x60/0x60 [team]
[   40.388752]  ? rcu_read_lock_sched_held+0x90/0xc0
[   40.389304]  ? rcu_read_lock_bh_held+0xa0/0xa0
[   40.389819]  ? lock_acquire+0x164/0x3b0
[   40.390285]  ? lockdep_rtnl_is_held+0x16/0x20
[   40.390797]  ? team_port_get_rtnl+0x90/0xe0 [team]
[   40.391353]  ? __module_text_address+0x13/0x140
[   40.391886]  ? team_set_mac_address+0x151/0x290 [team]
[   40.392547]  team_set_mac_address+0x151/0x290 [team]
[   40.393111]  dev_set_mac_address+0x1f0/0x3f0
[ ... ]

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v4 -> v5 :
 - qdisc part is merge into second patch
v1 -> v4 :
 - This patch is not changed

 drivers/net/team/team.c | 16 +++++++++++++---
 include/linux/if_team.h |  1 +
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 6cea83b48cad..8156b33ee3e7 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1615,7 +1615,6 @@ static int team_init(struct net_device *dev)
 	int err;
 
 	team->dev = dev;
-	mutex_init(&team->lock);
 	team_set_no_mode(team);
 
 	team->pcpu_stats = netdev_alloc_pcpu_stats(struct team_pcpu_stats);
@@ -1642,6 +1641,9 @@ static int team_init(struct net_device *dev)
 		goto err_options_register;
 	netif_carrier_off(dev);
 
+	lockdep_register_key(&team->team_lock_key);
+	__mutex_init(&team->lock, "team->team_lock_key", &team->team_lock_key);
+
 	return 0;
 
 err_options_register:
@@ -1671,6 +1673,7 @@ static void team_uninit(struct net_device *dev)
 	team_queue_override_fini(team);
 	mutex_unlock(&team->lock);
 	netdev_change_features(dev);
+	lockdep_unregister_key(&team->team_lock_key);
 }
 
 static void team_destructor(struct net_device *dev)
@@ -1974,8 +1977,15 @@ static int team_del_slave(struct net_device *dev, struct net_device *port_dev)
 	err = team_port_del(team, port_dev);
 	mutex_unlock(&team->lock);
 
-	if (!err)
-		netdev_change_features(dev);
+	if (err)
+		return err;
+
+	if (netif_is_team_master(port_dev)) {
+		lockdep_unregister_key(&team->team_lock_key);
+		lockdep_register_key(&team->team_lock_key);
+		lockdep_set_class(&team->lock, &team->team_lock_key);
+	}
+	netdev_change_features(dev);
 
 	return err;
 }
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index 06faa066496f..ec7e4bd07f82 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -223,6 +223,7 @@ struct team {
 		atomic_t count_pending;
 		struct delayed_work dw;
 	} mcast_rejoin;
+	struct lock_class_key team_lock_key;
 	long mode_priv[TEAM_MODE_PRIV_LONGS];
 };
 
-- 
2.17.1


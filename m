Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0BCDF552
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbfJUSsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:48:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41398 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfJUSsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:48:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id t3so8332720pga.8;
        Mon, 21 Oct 2019 11:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R8wsPXAJ6V2ED/gXbQO9+7L+/V/BvBRfwqf0RYxHrFI=;
        b=SMStliBupAS7ABNmk9C9uDN8g8WFtfeL95tGYv1MzbU4DXOC3OOV7vSJjFYjNVHB/5
         q1B5NRET9VcREvzLMDYCZUnnylPocJdmeSbX207OPWOgYZ29/73DmYLk/K6ix+WSV38c
         lQUAh8wZrtNw38Dfo6OXer6jApovorsBhC5jGakc6pM9nzth77wgxJRd7gJZbt1S+JU/
         uecN5BlvPZpu+puangt3I9vPAJyo6ZBKE4oNRkMJbEw5j5+45BZ5JrQtYR5Q5IV/dBKv
         ufxWPaSu0tgEvHhk/aMsUHWCDakRIbv9qb75WUS3BIvthRY8qRRkMN2OvtBJD4UaJt7J
         2CSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R8wsPXAJ6V2ED/gXbQO9+7L+/V/BvBRfwqf0RYxHrFI=;
        b=AsBM8KMD/3Vs8bAE0QvRM1NdFC1NpxTP2IAbjavAtjh++lDsVtUXS0/nX/c/vEd07n
         pf3JR3fqcFihFWfDQcRXGDrng8cG2RJT3p27X8vchiBqmdPYYd29CmOZu9nwouUeo8c0
         3xOBYojB4e+uve+bws53sMqCbfBGCNAsqj74rzuMXqcigv3dlNC4rMp7kqJAE25mth32
         kWe6U08lMuEexB/DNltY9O0lrXP2c9djI6grEFMYTSu/YvZ3NvEvpYKM3t8zJO4XWApm
         kg/2D1q3wTQeVtgl7m1s5NzcGx2tVjyOpDFtmEu/iXb1R58v1NoCMFkG9PCMcO/eLhh6
         8oOQ==
X-Gm-Message-State: APjAAAVm4a/Ugz6PTInk3pHMq5WtFlLhpaNIkNNQjjB1eScg5LCSLKwB
        vFMcHFQI+pgwycjMnUbd9EU=
X-Google-Smtp-Source: APXvYqwq4CzqkVX/Q3YnMLMNNdCO+TvLXQvXtHMaKvoTBWLIuRin/i5Wv8GM8oy5ji0yc4hlB6PEvA==
X-Received: by 2002:a63:485f:: with SMTP id x31mr27088307pgk.33.1571683721004;
        Mon, 21 Oct 2019 11:48:41 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id ev20sm14502835pjb.19.2019.10.21.11.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 11:48:40 -0700 (PDT)
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
Subject: [PATCH net v5 04/10] bonding: use dynamic lockdep key instead of subclass
Date:   Mon, 21 Oct 2019 18:47:53 +0000
Message-Id: <20191021184759.13125-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021184759.13125-1-ap420073@gmail.com>
References: <20191021184759.13125-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All bonding device has same lockdep key and subclass is initialized with
nest_level.
But actual nest_level value can be changed when a lower device is attached.
And at this moment, the subclass should be updated but it seems to be
unsafe.
So this patch makes bonding use dynamic lockdep key instead of the
subclass.

Test commands:
    ip link add bond0 type bond

    for i in {1..5}
    do
	    let A=$i-1
	    ip link add bond$i type bond
	    ip link set bond$i master bond$A
    done
    ip link set bond5 master bond0

Splat looks like:
[  307.992912] WARNING: possible recursive locking detected
[  307.993656] 5.4.0-rc3+ #96 Tainted: G        W
[  307.994367] --------------------------------------------
[  307.995092] ip/761 is trying to acquire lock:
[  307.995710] ffff8880513aac60 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[  307.997045]
	       but task is already holding lock: 
[  307.997923] ffff88805fcbac60 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[  307.999215]
	       other info that might help us debug this:
[  308.000251]  Possible unsafe locking scenario: 

[  308.001137]        CPU0
[  308.001533]        ----
[  308.001915]   lock(&(&bond->stats_lock)->rlock#2/2);
[  308.002609]   lock(&(&bond->stats_lock)->rlock#2/2);
[  308.003302]
		*** DEADLOCK ***

[  308.004310]  May be due to missing lock nesting notation

[  308.005319] 3 locks held by ip/761:
[  308.005830]  #0: ffffffff9fcc42b0 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[  308.006894]  #1: ffff88805fcbac60 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[  308.008243]  #2: ffffffff9f9219c0 (rcu_read_lock){....}, at: bond_get_stats+0x9f/0x500 [bonding]
[  308.009422]
	       stack backtrace:
[  308.010124] CPU: 0 PID: 761 Comm: ip Tainted: G        W         5.4.0-rc3+ #96
[  308.011097] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  308.012179] Call Trace:
[  308.012601]  dump_stack+0x7c/0xbb
[  308.013089]  __lock_acquire+0x269d/0x3de0
[  308.013669]  ? register_lock_class+0x14d0/0x14d0
[  308.014318]  lock_acquire+0x164/0x3b0
[  308.014858]  ? bond_get_stats+0xb8/0x500 [bonding]
[  308.015520]  _raw_spin_lock_nested+0x2e/0x60
[  308.016129]  ? bond_get_stats+0xb8/0x500 [bonding]
[  308.017215]  bond_get_stats+0xb8/0x500 [bonding]
[  308.018454]  ? bond_arp_rcv+0xf10/0xf10 [bonding]
[  308.019710]  ? rcu_read_lock_held+0x90/0xa0
[  308.020605]  ? rcu_read_lock_sched_held+0xc0/0xc0
[  308.021286]  ? bond_get_stats+0x9f/0x500 [bonding]
[  308.021953]  dev_get_stats+0x1ec/0x270
[  308.022508]  bond_get_stats+0x1d1/0x500 [bonding]

Fixes: d3fff6c443fe ("net: add netdev_lockdep_set_classes() helper")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v4 -> v5 :
 - qdisc part is merged into second patch
v1 -> v4 :
 - This patch is not changed

 drivers/net/bonding/bond_main.c | 10 +++++++---
 include/net/bonding.h           |  1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 92713b93f66f..6a6273590288 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3459,7 +3459,7 @@ static void bond_get_stats(struct net_device *bond_dev,
 	struct list_head *iter;
 	struct slave *slave;
 
-	spin_lock_nested(&bond->stats_lock, bond_get_nest_level(bond_dev));
+	spin_lock(&bond->stats_lock);
 	memcpy(stats, &bond->bond_stats, sizeof(*stats));
 
 	rcu_read_lock();
@@ -4297,8 +4297,6 @@ void bond_setup(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 
-	spin_lock_init(&bond->mode_lock);
-	spin_lock_init(&bond->stats_lock);
 	bond->params = bonding_defaults;
 
 	/* Initialize pointers */
@@ -4367,6 +4365,7 @@ static void bond_uninit(struct net_device *bond_dev)
 
 	list_del(&bond->bond_list);
 
+	lockdep_unregister_key(&bond->stats_lock_key);
 	bond_debug_unregister(bond);
 }
 
@@ -4772,6 +4771,11 @@ static int bond_init(struct net_device *bond_dev)
 
 	bond->nest_level = SINGLE_DEPTH_NESTING;
 
+	spin_lock_init(&bond->mode_lock);
+	spin_lock_init(&bond->stats_lock);
+	lockdep_register_key(&bond->stats_lock_key);
+	lockdep_set_class(&bond->stats_lock, &bond->stats_lock_key);
+
 	list_add_tail(&bond->bond_list, &bn->dev_list);
 
 	bond_prepare_sysfs_group(bond);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index f7fe45689142..334909feb2bb 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -239,6 +239,7 @@ struct bonding {
 	struct	 dentry *debug_dir;
 #endif /* CONFIG_DEBUG_FS */
 	struct rtnl_link_stats64 bond_stats;
+	struct lock_class_key stats_lock_key;
 };
 
 #define bond_slave_get_rcu(dev) \
-- 
2.17.1


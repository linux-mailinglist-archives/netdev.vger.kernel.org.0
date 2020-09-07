Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF19B260737
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 01:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgIGXsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 19:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgIGXsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 19:48:53 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539E0C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 16:48:51 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q13so19979588ejo.9
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 16:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YDz9y0OpXoVjQLuRYQ7cDjfZCSI56x/ul+zMPHBzvpk=;
        b=iPamBxaJJCgzjDlwybvm2EqQTpFfuYI8urpM/h5lZfPN/2P+MPKf5zo6F6+ZD9td+/
         y05jMJPwAriiX7zXG5zGBpEpLcG6J85WGoK59Ss0+su16K0/5tjq+oRLiHx9gSgPHHD2
         k5DgGM9/9BHgDYLNAp/xMdLXgYx7QxN+37CaAyhs3Q37tFhUAUqLIz0ijiC5L1M7ifLL
         FV0bULz1IZpRpFuTsqURS7UG0LffT8avW99rRmyDjRDIN2pbzI5VJ6pTXdtAV1TNbjos
         8eSrW1S95Tv0chRxcx8qiPapRDIPCg7r4UAPGIZU6DPa8CSvhJOxnFAklkwGkNAFKo+H
         /sbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YDz9y0OpXoVjQLuRYQ7cDjfZCSI56x/ul+zMPHBzvpk=;
        b=keGMHlTmKq5STfnzgmlTShptKnAIH/u8tSaEdW/01+TpotxWXr75pbPX8M5OeFLhUw
         AQ7lWDMKryj1G76GccrX14FY6EgpU0nTFVimVo15MNTDQtLEMgsdTN49jLK4ZIXNU+au
         snl+m1skeJ+bu4n9io/yO9f8eqkCqOS45mQTc3/OcVKsnjWgYsF2NeGVwBMxbM4NhF0K
         ZR8jG9C0oey09f6Rr70boKA0OUkD3z6fimf8XFku3bgZ82aQpidUN9NlJ+Yp4uaR9D+g
         ts82jH64gPkOVj4KasR0GEx94FgSPknHWot0qnbCWT0H7yp+PiqvXX4R2k5RyWSXX2pC
         UHaA==
X-Gm-Message-State: AOAM5320djdeTw/4i31Ibucv65fIozTtT6Emt54MGjq/VVxPIGX3X7Px
        oKBvcH5BGhYM2ns73nH5gZ0=
X-Google-Smtp-Source: ABdhPJzc3ziDtSBgr5wjYrZwQL7/OKlNoQPGj9/DYI0aEr3362exY645b/mQqeHhN/cMOjA7NFHpZg==
X-Received: by 2002:a17:906:2a1a:: with SMTP id j26mr23021751eje.456.1599522529815;
        Mon, 07 Sep 2020 16:48:49 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id j8sm14161454ejj.91.2020.09.07.16.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 16:48:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        xiyou.wangcong@gmail.com, ap420073@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH v2 net] net: dsa: link interfaces with the DSA master to get rid of lockdep warnings
Date:   Tue,  8 Sep 2020 02:48:42 +0300
Message-Id: <20200907234842.1684223-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 845e0ebb4408 ("net: change addr_list_lock back to static
key"), cascaded DSA setups (DSA switch port as DSA master for another
DSA switch port) are emitting this lockdep warning:

============================================
WARNING: possible recursive locking detected
5.8.0-rc1-00133-g923e4b5032dd-dirty #208 Not tainted
--------------------------------------------
dhcpcd/323 is trying to acquire lock:
ffff000066dd4268 (&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at: dev_mc_sync+0x44/0x90

but task is already holding lock:
ffff00006608c268 (&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at: dev_mc_sync+0x44/0x90

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&dsa_master_addr_list_lock_key/1);
  lock(&dsa_master_addr_list_lock_key/1);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by dhcpcd/323:
 #0: ffffdbd1381dda18 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock+0x24/0x30
 #1: ffff00006614b268 (_xmit_ETHER){+...}-{2:2}, at: dev_set_rx_mode+0x28/0x48
 #2: ffff00006608c268 (&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at: dev_mc_sync+0x44/0x90

stack backtrace:
Call trace:
 dump_backtrace+0x0/0x1e0
 show_stack+0x20/0x30
 dump_stack+0xec/0x158
 __lock_acquire+0xca0/0x2398
 lock_acquire+0xe8/0x440
 _raw_spin_lock_nested+0x64/0x90
 dev_mc_sync+0x44/0x90
 dsa_slave_set_rx_mode+0x34/0x50
 __dev_set_rx_mode+0x60/0xa0
 dev_mc_sync+0x84/0x90
 dsa_slave_set_rx_mode+0x34/0x50
 __dev_set_rx_mode+0x60/0xa0
 dev_set_rx_mode+0x30/0x48
 __dev_open+0x10c/0x180
 __dev_change_flags+0x170/0x1c8
 dev_change_flags+0x2c/0x70
 devinet_ioctl+0x774/0x878
 inet_ioctl+0x348/0x3b0
 sock_do_ioctl+0x50/0x310
 sock_ioctl+0x1f8/0x580
 ksys_ioctl+0xb0/0xf0
 __arm64_sys_ioctl+0x28/0x38
 el0_svc_common.constprop.0+0x7c/0x180
 do_el0_svc+0x2c/0x98
 el0_sync_handler+0x9c/0x1b8
 el0_sync+0x158/0x180

Since DSA never made use of the netdev API for describing links between
upper devices and lower devices, the dev->lower_level value of a DSA
switch interface would be 1, which would warn when it is a DSA master.

We can use netdev_upper_dev_link() to describe the relationship between
a DSA slave and a DSA master. To be precise, a DSA "slave" (switch port)
is an "upper" to a DSA "master" (host port). The relationship is "many
uppers to one lower", like in the case of VLAN. So, for that reason, we
use the same function as VLAN uses.

There might be a chance that somebody will try to take hold of this
interface and use it immediately after register_netdev() and before
netdev_upper_dev_link(). To avoid that, we do the registration and
linkage while holding the RTNL, and we use the RTNL-locked cousin of
register_netdev(), which is register_netdevice().

Since this warning was not there when lockdep was using dynamic keys for
addr_list_lock, we are blaming the lockdep patch itself. The network
stack _has_ been using static lockdep keys before, and it _is_ likely
that stacked DSA setups have been triggering these lockdep warnings
since forever, however I can't test very old kernels on this particular
stacked DSA setup, to ensure I'm not in fact introducing regressions.

Fixes: 845e0ebb4408 ("net: change addr_list_lock back to static key")
Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
* Try to maintain an error path order which is similar to the one from
  the deregistration path.
* Keep the RTNL for register_netdevice() followed by
  netdev_upper_dev_link(), to avoid user space from trying to use the
  interface without an upper link.

 net/dsa/slave.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4987f94a8f52..03cf3a9b0a79 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1800,15 +1800,27 @@ int dsa_slave_create(struct dsa_port *port)
 
 	dsa_slave_notify(slave_dev, DSA_PORT_REGISTER);
 
-	ret = register_netdev(slave_dev);
+	rtnl_lock();
+
+	ret = register_netdevice(slave_dev);
 	if (ret) {
 		netdev_err(master, "error %d registering interface %s\n",
 			   ret, slave_dev->name);
+		rtnl_unlock();
 		goto out_phy;
 	}
 
+	ret = netdev_upper_dev_link(master, slave_dev, NULL);
+
+	rtnl_unlock();
+
+	if (ret)
+		goto out_unregister;
+
 	return 0;
 
+out_unregister:
+	unregister_netdev(slave_dev);
 out_phy:
 	rtnl_lock();
 	phylink_disconnect_phy(p->dp->pl);
@@ -1825,16 +1837,18 @@ int dsa_slave_create(struct dsa_port *port)
 
 void dsa_slave_destroy(struct net_device *slave_dev)
 {
+	struct net_device *master = dsa_slave_to_master(slave_dev);
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
 	struct dsa_slave_priv *p = netdev_priv(slave_dev);
 
 	netif_carrier_off(slave_dev);
 	rtnl_lock();
+	netdev_upper_dev_unlink(master, slave_dev);
+	unregister_netdevice(slave_dev);
 	phylink_disconnect_phy(dp->pl);
 	rtnl_unlock();
 
 	dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
-	unregister_netdev(slave_dev);
 	phylink_destroy(dp->pl);
 	gro_cells_destroy(&p->gcells);
 	free_percpu(p->stats64);
-- 
2.25.1


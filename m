Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FE521DBA1
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgGMQY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgGMQY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:24:58 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771B0C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:24:58 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o18so17882702eje.7
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VsMbBp6x0osJs7mV4hqko2bgRIjJIKrDgDOqvdmdL6U=;
        b=AOTYpHRKlK1x/l2jYVyACxkCaEgihViv+rci58UvkVcGVfWLVnUno64XjouIYXljpv
         agv8EjTQsJuil2dgjDOx7CzZe+OKeXQCvRHMOgMPjTeRPPEmyxCkRbb5t/2Q2tir/+vy
         ltPmCwRN1tmNabcRgsdYGrb4w11sit6d38BVr2+w9NRTOUDicpP/wH0aisL83rgbfk1J
         f1tz/op+Vxn9Q1dkiIcdtsCUaQ5jFb78er4k3eweNRDI6cOJk8FJlx/Pz7wZfpCqdY5P
         h165iwq8+Dv4DizTx8kn8d0Yr9f9G+fCjv94UdbeergpAYIg5yUQV97fz1Z0BaPZ9DCb
         DUng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VsMbBp6x0osJs7mV4hqko2bgRIjJIKrDgDOqvdmdL6U=;
        b=mU3WHO47RaOco/RXx9QmZ18GCLOGdTcM+zpnAxIhBlykVmieQFzgTwMN0vspAl+j97
         cCyRWqXjBWrpgmliLiVqoRR4ilcB3cJP7No3zxTcwo0fbuP4fIBgNuYxrbBkDHo7JUgZ
         42tON/kQu1RzQKxWYZkPAg4FKRoGtLrNeWOR8YVpL+BqI1SDaWhid20Aker8s74TuP39
         dWPe+vIVCNoCHQlAyZkNVzka2FFqpHIMTm83UO/5rfKPa0YydR59zmI2yVcjc6o9EqyX
         TA+xPnAwKpzeilzg0riDi0uq4+frmHQcc0TECR1pSmdH+O/tVZPJLiuNZzUWsdC6Yv23
         gPdg==
X-Gm-Message-State: AOAM532IK43W052s3G/ZVXl4bfRYleSSoGNsmvs0qrFK6Y4wW+LRmp+r
        PvEPFN0FqJ1lUcgryfjv+AhKMjqV
X-Google-Smtp-Source: ABdhPJwHmLuKSuDIFT4CMwFyO/6hMhJMvKZ3XFlg2OMghMbIw3VW/E/Ji8YntkvcRoRjSTeaS3PiWA==
X-Received: by 2002:a17:906:391:: with SMTP id b17mr566308eja.282.1594657496987;
        Mon, 13 Jul 2020 09:24:56 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id a2sm11725122edt.48.2020.07.13.09.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:24:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        xiyou.wangcong@gmail.com, ap420073@gmail.com
Subject: [PATCH net] net: dsa: link interfaces with the DSA master to get rid of lockdep warnings
Date:   Mon, 13 Jul 2020 19:24:43 +0300
Message-Id: <20200713162443.2510682-1-olteanv@gmail.com>
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
 net/dsa/slave.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 743caabeaaa6..a951b2a7d79a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1994,6 +1994,13 @@ int dsa_slave_create(struct dsa_port *port)
 			   ret, slave_dev->name);
 		goto out_phy;
 	}
+	rtnl_lock();
+	ret = netdev_upper_dev_link(master, slave_dev, NULL);
+	rtnl_unlock();
+	if (ret) {
+		unregister_netdevice(slave_dev);
+		goto out_phy;
+	}
 
 	return 0;
 
@@ -2013,11 +2020,13 @@ int dsa_slave_create(struct dsa_port *port)
 
 void dsa_slave_destroy(struct net_device *slave_dev)
 {
+	struct net_device *master = dsa_slave_to_master(slave_dev);
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
 	struct dsa_slave_priv *p = netdev_priv(slave_dev);
 
 	netif_carrier_off(slave_dev);
 	rtnl_lock();
+	netdev_upper_dev_unlink(master, slave_dev);
 	phylink_disconnect_phy(dp->pl);
 	rtnl_unlock();
 
-- 
2.25.1


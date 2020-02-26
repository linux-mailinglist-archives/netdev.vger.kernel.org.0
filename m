Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD95F170674
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgBZRrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:47:31 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34858 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgBZRrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:47:31 -0500
Received: by mail-pf1-f194.google.com with SMTP id i19so149624pfa.2
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YEewmmjg9L6uxTVzMfgFdNq1SumNAZgvtgHvnTSy5BQ=;
        b=g9v/jtOmWDbB8djivVMx/j25Izks1Gf+s2Ov3R1aNKfBseOYEujh/GU7gwRNMaedJo
         KtH6z5jLPofXpMeQF6E33z6YIj+FBJ4zGztx6WjgZv3056ZiA3AAY0lMQDr7bTmaCoJ4
         0NDA2P091cmHu5MCJUO6713QfSgvuUkAq9nkCHNia0I9gcePVi0C5uiDSHeJ36y3A+Op
         ljbo+ivvfxOMy2gvkSXDWFX+DxEud2r3QM1UsXou4k4OOKMhf0YcxQwzyYMAOx4sKVr4
         tVMs/HiT2ZTUZsSLQOALmDbALcFC6JfPRNETanVJO/c63p23Us5O8t4zFpzaG/h4N9DS
         tH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YEewmmjg9L6uxTVzMfgFdNq1SumNAZgvtgHvnTSy5BQ=;
        b=cSaupw5hFG6yAfCDb39AEjGRRBI/OahD0yQmbZBGg7E240fVofpjS6zujCn1wxlkMo
         tlIbZDvDsqW/Y0xqSAhvwvtfTnWi8jGy4mlt24ztOZevI7Qe0OzvcKstLWWqHrXCwR3P
         DHo2ztGYSCatkQu0g7rD2YZ7lpXeAhiI2Bt5mND3XhhNsWs0Toj0pfCC+D8lIXw2KTAw
         55c57Ba786DCRK7k/jFrIG1bFq5gWEMx4hx33sPxmKwlpMFBeEPg9p5XSh4UJgujytzv
         FxfAKGnO9JdAHQ6YI8FKrDapadAyRFsAp0r/A2kpOZZdYtORwzmKzyMjo/HEEznx3sBH
         gmVw==
X-Gm-Message-State: APjAAAW1Zbl1ypjYulnGQRofnG/7l5bO2A2N6ah+slMqWkLmverFn69K
        ni04/wBXewfwPMv1l8qxmds=
X-Google-Smtp-Source: APXvYqxJmpqaEFJx1dcmMxoe8Q7aRKP5zYU5eUsuat6r+F5eub33v3OEf5JO+gHiYlmuu0PFdKjL+w==
X-Received: by 2002:a65:6090:: with SMTP id t16mr42124pgu.2.1582739249615;
        Wed, 26 Feb 2020 09:47:29 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id o6sm4050442pfg.180.2020.02.26.09.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:47:28 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 05/10] net: rmnet: remove rcu_read_lock in rmnet_force_unassociate_device()
Date:   Wed, 26 Feb 2020 17:47:23 +0000
Message-Id: <20200226174723.5492-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The notifier_call() of the slave interface removes rmnet interface with
unregister_netdevice_queue().
But, before calling unregister_netdevice_queue(), it acquires
rcu readlock.
In the RCU critical section, sleeping isn't be allowed.
But, unregister_netdevice_queue() internally calls synchronize_net(),
which would sleep.
So, suspicious RCU usage warning occurs.

Test commands:
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link del dummy0

Splat looks like:
[  128.764922][  T979] WARNING: suspicious RCU usage
[  128.766356][  T979] 5.5.0+ #416 Not tainted
[  128.767667][  T979] -----------------------------
[  128.769008][  T979] ./include/linux/rcupdate.h:273 Illegal context switch in RCU read-side critical section!
[  128.771375][  T979]
[  128.771375][  T979] other info that might help us debug this:
[  128.771375][  T979]
[  128.773998][  T979]
[  128.773998][  T979] rcu_scheduler_active = 2, debug_locks = 1
[  128.775572][  T979] 2 locks held by ip/979:
[  128.776507][  T979]  #0: ffffffff9ccf6230 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x457/0x890
[  128.778241][  T979]  #1: ffffffff9c9254c0 (rcu_read_lock){....}, at: rmnet_config_notify_cb+0xf0/0x590 [rmnet]
[  128.779704][  T979]
[  128.779704][  T979] stack backtrace:
[  128.780699][  T979] CPU: 0 PID: 979 Comm: ip Not tainted 5.5.0+ #416
[  128.781763][  T979] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  128.783433][  T979] Call Trace:
[  128.783919][  T979]  dump_stack+0x96/0xdb
[  128.784535][  T979]  ___might_sleep+0x345/0x440
[  128.785216][  T979]  synchronize_net+0x18/0x30
[  128.785868][  T979]  netdev_rx_handler_unregister+0x40/0xb0
[  128.786536][  T979]  rmnet_unregister_real_device+0x42/0xb0 [rmnet]
[  128.787219][  T979]  rmnet_config_notify_cb+0x1f7/0x590 [rmnet]
[  128.787859][  T979]  ? rmnet_unregister_bridge.isra.6+0xf0/0xf0 [rmnet]
[  128.788668][  T979]  ? rmnet_unregister_bridge.isra.6+0xf0/0xf0 [rmnet]
[  128.789347][  T979]  ? __module_text_address+0x13/0x140
[  128.789853][  T979]  notifier_call_chain+0x90/0x160
[  128.790353][  T979]  rollback_registered_many+0x660/0xcf0
[  128.790877][  T979]  ? netif_set_real_num_tx_queues+0x780/0x780
[  128.791452][  T979]  ? __lock_acquire+0xdfe/0x3de0
[  128.791926][  T979]  ? memset+0x1f/0x40
[  128.792309][  T979]  ? __nla_validate_parse+0x98/0x1ab0
[  128.793033][  T979]  unregister_netdevice_many.part.134+0x13/0x1b0
[  128.794060][  T979]  rtnl_delete_link+0xbc/0x100
[ ... ]

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 93642cdd3305..c8b1bfe127ac 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -230,7 +230,6 @@ static void rmnet_force_unassociate_device(struct net_device *dev)
 
 	port = rmnet_get_port_rtnl(dev);
 
-	rcu_read_lock();
 	rmnet_unregister_bridge(dev, port);
 
 	hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
@@ -241,7 +240,6 @@ static void rmnet_force_unassociate_device(struct net_device *dev)
 		kfree(ep);
 	}
 
-	rcu_read_unlock();
 	unregister_netdevice_many(&list);
 
 	rmnet_unregister_real_device(real_dev, port);
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E7E171715
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgB0MZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:25:15 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41973 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgB0MZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 07:25:15 -0500
Received: by mail-pl1-f196.google.com with SMTP id t14so1075517plr.8
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 04:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZIJrbIPHhoUosDBOu3/ZLx+q8DHFQiwD2Y9ezIJ9cPo=;
        b=Dz5fMNuDTdy8V52GKv3ESPHA2eSLGM407MrSxKYSFLp3yMh/4JLDNyd1UFbcnO5dhd
         28Yp7qWcNl72aoh8/Fm2Mzcba8M+YkssElZ2Vz+zEp63ZjDujV+MOysPaAmjrOChuUX1
         SrX2RqAbob74FSRJSnxJkr8wYbanCOBMarZRFBipZ0ErZtGcxlgIeoNEL2WinZRxwOdR
         PGJ+x76/skYKV4msauJ7VV1CXF+c/NrZzXcOsfu2KuV8dJc2CUNcN0Q4SoDWNkl///4E
         opTF4AnxE2ko52jQCVh5Q3QjMPxvUGZxRSifPajdixh6YoelkURT0O8g8JZmobXMG5KU
         EiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZIJrbIPHhoUosDBOu3/ZLx+q8DHFQiwD2Y9ezIJ9cPo=;
        b=ibrfbxOkDJVC1FnE49kxGrMxY3N+od7AMOWIgfM0W7fCMiWSeYj3R4iqavcPwrroLc
         SZ50R2u1Lv5l4+w5Pz7b2znNJfOTCyQpFGlG6rB2+nPqjsEczGlWBjHyCiahFumBhosS
         BgwjULGtxuTJKmQtCTy2RL7Lfy8nqyAoGQAIpvee+y1/rzTFu2/qqKaGYMndHVmo1L98
         LSHcKVVlNXHC713TsIpnZRyqPcTAL3OJ9xS+2nIO1r8YMEurAxc6HUh5C6FZJ2690oq3
         xiRrOSLIuchG5CinMyN9xur5ItynE6IvWZfI4y33aBtg9/QVpj3wZT8vcGoM+DiHCVYa
         1w5Q==
X-Gm-Message-State: APjAAAVtmVINIU4oKgvF9uiPGXSNA3a2sr090f3bNIKc3ZT+oDpnypW4
        T7k7gie0EMtamwDuSucDpzc=
X-Google-Smtp-Source: APXvYqzxn6DCRMs4gF4NNDBq484Jbk9pFipuTX8RJyqI2C38VyDPgIXzIKJ5aWuTJVw0bsE5PYTFNg==
X-Received: by 2002:a17:902:aa05:: with SMTP id be5mr4187497plb.142.1582806313366;
        Thu, 27 Feb 2020 04:25:13 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id d1sm6394615pgj.79.2020.02.27.04.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 04:25:12 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 4/8] net: rmnet: remove rcu_read_lock in rmnet_force_unassociate_device()
Date:   Thu, 27 Feb 2020 12:25:05 +0000
Message-Id: <20200227122505.19262-1-ap420073@gmail.com>
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
    modprobe rmnet
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link set dummy1 master rmnet0
    ip link del dummy0

Splat looks like:
[   79.639245][ T1195] =============================
[   79.640134][ T1195] WARNING: suspicious RCU usage
[   79.640852][ T1195] 5.6.0-rc1+ #447 Not tainted
[   79.641657][ T1195] -----------------------------
[   79.642472][ T1195] ./include/linux/rcupdate.h:273 Illegal context switch in RCU read-side critical section!
[   79.644043][ T1195]
[   79.644043][ T1195] other info that might help us debug this:
[   79.644043][ T1195]
[   79.645682][ T1195]
[   79.645682][ T1195] rcu_scheduler_active = 2, debug_locks = 1
[   79.646980][ T1195] 2 locks held by ip/1195:
[   79.647629][ T1195]  #0: ffffffffa3cf64f0 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x457/0x890
[   79.649312][ T1195]  #1: ffffffffa39256c0 (rcu_read_lock){....}, at: rmnet_config_notify_cb+0xf0/0x590 [rmnet]
[   79.651717][ T1195]
[   79.651717][ T1195] stack backtrace:
[   79.652650][ T1195] CPU: 3 PID: 1195 Comm: ip Not tainted 5.6.0-rc1+ #447
[   79.653702][ T1195] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   79.655037][ T1195] Call Trace:
[   79.655560][ T1195]  dump_stack+0x96/0xdb
[   79.656252][ T1195]  ___might_sleep+0x345/0x440
[   79.656994][ T1195]  synchronize_net+0x18/0x30
[   79.661132][ T1195]  netdev_rx_handler_unregister+0x40/0xb0
[   79.666266][ T1195]  rmnet_unregister_real_device+0x42/0xb0 [rmnet]
[   79.667211][ T1195]  rmnet_config_notify_cb+0x1f7/0x590 [rmnet]
[   79.668121][ T1195]  ? rmnet_unregister_bridge.isra.6+0xf0/0xf0 [rmnet]
[   79.669166][ T1195]  ? rmnet_unregister_bridge.isra.6+0xf0/0xf0 [rmnet]
[   79.670286][ T1195]  ? __module_text_address+0x13/0x140
[   79.671139][ T1195]  notifier_call_chain+0x90/0x160
[   79.671973][ T1195]  rollback_registered_many+0x660/0xcf0
[   79.672893][ T1195]  ? netif_set_real_num_tx_queues+0x780/0x780
[   79.675091][ T1195]  ? __lock_acquire+0xdfe/0x3de0
[   79.675825][ T1195]  ? memset+0x1f/0x40
[   79.676367][ T1195]  ? __nla_validate_parse+0x98/0x1ab0
[   79.677290][ T1195]  unregister_netdevice_many.part.133+0x13/0x1b0
[   79.678163][ T1195]  rtnl_delete_link+0xbc/0x100
[ ... ]

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
  - update commit log.

 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index fc68ecdd804b..0ad64aa66592 100644
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4573528F691
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389525AbgJOQ0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388357AbgJOQ0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 12:26:14 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B30DC061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 09:26:14 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id x13so2216325pgp.7
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 09:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XeQyMSiRFrjngZmGhAferKWNdiScGw2gNzfstm/NcLY=;
        b=aPlTFA2igpiQFrERGATCbZERTSDidFazrXB1oVAbW3rE2LpcRC/FTQj3Zd15/TSnRB
         daDD1fIQHG1VO06/buaOggqHiYVTrMzCpA72MorqBpZbtDvZavixgAP7NQllkOZNcB59
         jI+WelnMl0fYMXVPM98jYC3DNA2s/sOc/T5ohCefxIOKF6CpmrIEbLDNQvPdgL1FOAEi
         Gn3SPYhe+glvTNj60eTvWWLIaJS1yoLCMJCwng92AXoj3WC2UXTNM0mrFFbHVAofZVzP
         M1gy9IW/1zFbJxzoxbLgXbuxJO85W+bprmHuQDi8YfjtIZrAEwQ6p9JJMqTOnuu5kjnw
         Voqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XeQyMSiRFrjngZmGhAferKWNdiScGw2gNzfstm/NcLY=;
        b=KWxdcEg4PMl7V4YO4KvYrfiMRgFukQs3pif/yDTz1zNoDz7KyaJ0vl1NGiKQCm5ozz
         BZzdtIr0/Uij/K6X7m/4Payzxft5JGRchAnSQ7PygMTutU/Kqt2kS65sR6WA2QoZX37+
         6dyeWDW3iz/0LPRXFxIZOhg+Kpi2HiJXa8LUGwtg7I5N1OsF9klQ0veq0PS7bSx8OKMb
         7hbaci+dFlIwIPVa9BP+ZSCuCPrO9SUE0RWAOgRJwUhhyfEfVrC3YuGscMiYmWgKZZg5
         R0Y8YR5ZwpqdQIqMwrV6AaTvmWAGyMYb24ryxT+tP+Rt2ZU1K+0zEVe5n1PApqs4Y50+
         KqYw==
X-Gm-Message-State: AOAM532oA2Uizs7FW/K58tSXWaIw/+9hpEdcoWxAKIaxCto4t0fPXNFT
        gGHQzzi7hVzJR/hUOmUL7WQjlmeszRw=
X-Google-Smtp-Source: ABdhPJzUvLMosXPznPqYKwIHWl0Z4AFFSx5t3FeBdxUF9V6l+VBRoVZYfhcbnoF/g1qpu/eVwsii8Q==
X-Received: by 2002:a63:1805:: with SMTP id y5mr3901363pgl.174.1602779173891;
        Thu, 15 Oct 2020 09:26:13 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id n125sm3938883pfn.185.2020.10.15.09.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 09:26:12 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] net: core: use list_del_init() instead of list_del() in netdev_run_todo()
Date:   Thu, 15 Oct 2020 16:26:06 +0000
Message-Id: <20201015162606.9377-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev->unlink_list is reused unless dev is deleted.
So, list_del() should not be used.
Due to using list_del(), dev->unlink_list can't be reused so that
dev->nested_level update logic doesn't work.
In order to fix this bug, list_del_init() should be used instead
of list_del().

Test commands:
    ip link add bond0 type bond
    ip link add bond1 type bond
    ip link set bond0 master bond1
    ip link set bond0 nomaster
    ip link set bond1 master bond0
    ip link set bond1 nomaster

Splat looks like:
[  255.750458][ T1030] ============================================
[  255.751967][ T1030] WARNING: possible recursive locking detected
[  255.753435][ T1030] 5.9.0-rc8+ #772 Not tainted
[  255.754553][ T1030] --------------------------------------------
[  255.756047][ T1030] ip/1030 is trying to acquire lock:
[  255.757304][ T1030] ffff88811782a280 (&dev_addr_list_lock_key/1){+...}-{2:2}, at: dev_mc_sync_multiple+0xc2/0x150
[  255.760056][ T1030]
[  255.760056][ T1030] but task is already holding lock:
[  255.761862][ T1030] ffff88811130a280 (&dev_addr_list_lock_key/1){+...}-{2:2}, at: bond_enslave+0x3d4d/0x43e0 [bonding]
[  255.764581][ T1030]
[  255.764581][ T1030] other info that might help us debug this:
[  255.766645][ T1030]  Possible unsafe locking scenario:
[  255.766645][ T1030]
[  255.768566][ T1030]        CPU0
[  255.769415][ T1030]        ----
[  255.770259][ T1030]   lock(&dev_addr_list_lock_key/1);
[  255.771629][ T1030]   lock(&dev_addr_list_lock_key/1);
[  255.772994][ T1030]
[  255.772994][ T1030]  *** DEADLOCK ***
[  255.772994][ T1030]
[  255.775091][ T1030]  May be due to missing lock nesting notation
[  255.775091][ T1030]
[  255.777182][ T1030] 2 locks held by ip/1030:
[  255.778299][ T1030]  #0: ffffffffb1f63250 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x2e4/0x8b0
[  255.780600][ T1030]  #1: ffff88811130a280 (&dev_addr_list_lock_key/1){+...}-{2:2}, at: bond_enslave+0x3d4d/0x43e0 [bonding]
[  255.783411][ T1030]
[  255.783411][ T1030] stack backtrace:
[  255.784874][ T1030] CPU: 7 PID: 1030 Comm: ip Not tainted 5.9.0-rc8+ #772
[  255.786595][ T1030] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[  255.789030][ T1030] Call Trace:
[  255.789850][ T1030]  dump_stack+0x99/0xd0
[  255.790882][ T1030]  __lock_acquire.cold.71+0x166/0x3cc
[  255.792285][ T1030]  ? register_lock_class+0x1a30/0x1a30
[  255.793619][ T1030]  ? rcu_read_lock_sched_held+0x91/0xc0
[  255.794963][ T1030]  ? rcu_read_lock_bh_held+0xa0/0xa0
[  255.796246][ T1030]  lock_acquire+0x1b8/0x850
[  255.797332][ T1030]  ? dev_mc_sync_multiple+0xc2/0x150
[  255.798624][ T1030]  ? bond_enslave+0x3d4d/0x43e0 [bonding]
[  255.800039][ T1030]  ? check_flags+0x50/0x50
[  255.801143][ T1030]  ? lock_contended+0xd80/0xd80
[  255.802341][ T1030]  _raw_spin_lock_nested+0x2e/0x70
[  255.803592][ T1030]  ? dev_mc_sync_multiple+0xc2/0x150
[  255.804897][ T1030]  dev_mc_sync_multiple+0xc2/0x150
[  255.806168][ T1030]  bond_enslave+0x3d58/0x43e0 [bonding]
[  255.807542][ T1030]  ? __lock_acquire+0xe53/0x51b0
[  255.808824][ T1030]  ? bond_update_slave_arr+0xdc0/0xdc0 [bonding]
[  255.810451][ T1030]  ? check_chain_key+0x236/0x5e0
[  255.811742][ T1030]  ? mutex_is_locked+0x13/0x50
[  255.812910][ T1030]  ? rtnl_is_locked+0x11/0x20
[  255.814061][ T1030]  ? netdev_master_upper_dev_get+0xf/0x120
[  255.815553][ T1030]  do_setlink+0x94c/0x3040
[ ... ]

Reported-by: syzbot+4a0f7bc34e3997a6c7df@syzkaller.appspotmail.com
Fixes: 1fc70edb7d7b ("net: core: add nested_level variable in net_device")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4906b44af850..010de57488ce 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10134,7 +10134,7 @@ void netdev_run_todo(void)
 		struct net_device *dev = list_first_entry(&unlink_list,
 							  struct net_device,
 							  unlink_list);
-		list_del(&dev->unlink_list);
+		list_del_init(&dev->unlink_list);
 		dev->nested_level = dev->lower_level - 1;
 	}
 #endif
-- 
2.17.1


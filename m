Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA3815FE0A
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 11:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgBOKuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 05:50:18 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33373 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgBOKuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 05:50:17 -0500
Received: by mail-pl1-f193.google.com with SMTP id ay11so4858082plb.0
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 02:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UJJCFEfeGq+B54g4NIp1SeYkp7WU8nJcjKMHfaeqFpM=;
        b=KRgqPwgk+GG438bNmb+MKIgxi5YPOXcRpQSISvrKiajvlFleLe21cFHwuSKJjYTXNt
         JoPLgSm6hRdlOv3rEChgEzd4invZuXS55YME9MZWSChwJlEixCXDPax8qvGl6oa/74zk
         Kds6YCBNTfRgVncqjqfJ1uTDkQFWk+PxgCj5M482vFCqa1Q4ejK7ZRdG0qfQHPvTxsbC
         IE9lFKqRVW4Z0QoYw9TPCq+c73eOI7hCvxs0PcmKrcVTTLrtgV7WCIgG4FDkd/Djabm2
         kqTwWh17u4/UBJ2zSUBV0yFU9QN1BDxvOOZl8MKGjp09IcFT7jAq1OKNzF8FNxWR9cfx
         AAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UJJCFEfeGq+B54g4NIp1SeYkp7WU8nJcjKMHfaeqFpM=;
        b=ec8nVCeDozJJwRHoiZGroxW2FzS3LjeUuhhi4JfQOBZCcRDnXsHULgkX9c0moVwCB5
         itKym6z5EH7LVF9LLGr68WR9wIF1NE+IUPBRGrQIhV28ugCXNExwMHuGZo27WIouhiiT
         QyXtOHh8uKaq+89RTCMqCWxiE9pa7ABGN4+sAtvHmSAz0QjR5dSR35M8WpeF/5QibBP2
         BF+RLUjcLk/Lg3GNdE8sCioDGq7m1ekWmL+LxE/j6f27xtg9r2jP/q8OpeRq55+i72zk
         Th8xUajFyrw+Zq3rCrbdYcv6Mj78oKgWJrXyteX1j77R4/TdcqAuApMZE/b+8XtUkeWc
         1+yg==
X-Gm-Message-State: APjAAAXdePbgaDHqLmc483F1KdSQ69M3Ds/P4c+OjKaNJ4tkbW5tIC21
        PTvYQKFTn50lh4xjmSjLifo=
X-Google-Smtp-Source: APXvYqyn68PK4iUkNheWfAa4jCM8B7Pf3MexbI/m3IZI2zpBJqnEdKtD9/zehTXq09BXq5JuUR2yig==
X-Received: by 2002:a17:90a:1b42:: with SMTP id q60mr8712054pjq.108.1581763816764;
        Sat, 15 Feb 2020 02:50:16 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id z30sm10554427pfq.154.2020.02.15.02.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 02:50:15 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 1/3] bonding: add missing netdev_update_lockdep_key()
Date:   Sat, 15 Feb 2020 10:50:08 +0000
Message-Id: <20200215105008.21434-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After bond_release(), netdev_update_lockdep_key() should be called.
But both ioctl path and attribute path don't call
netdev_update_lockdep_key().
This patch adds missing netdev_update_lockdep_key().

Test commands:
    ip link add bond0 type bond
    ip link add bond1 type bond
    ifenslave bond0 bond1
    ifenslave -d bond0 bond1
    ifenslave bond1 bond0

Splat looks like:
[   29.501182][ T1046] WARNING: possible circular locking dependency detected
[   29.501945][ T1039] hardirqs last disabled at (1962): [<ffffffffac6c807f>] handle_mm_fault+0x13f/0x700
[   29.503442][ T1046] 5.5.0+ #322 Not tainted
[   29.503447][ T1046] ------------------------------------------------------
[   29.504277][ T1039] softirqs last  enabled at (1180): [<ffffffffade00678>] __do_softirq+0x678/0x981
[   29.505443][ T1046] ifenslave/1046 is trying to acquire lock:
[   29.505886][ T1039] softirqs last disabled at (1169): [<ffffffffac19c18a>] irq_exit+0x17a/0x1a0
[   29.509997][ T1046] ffff88805d5da280 (&dev->addr_list_lock_key#3){+...}, at: dev_mc_sync_multiple+0x95/0x120
[   29.511243][ T1046]
[   29.511243][ T1046] but task is already holding lock:
[   29.512192][ T1046] ffff8880460f2280 (&dev->addr_list_lock_key#4){+...}, at: bond_enslave+0x4482/0x47b0 [bonding]
[   29.514124][ T1046]
[   29.514124][ T1046] which lock already depends on the new lock.
[   29.514124][ T1046]
[   29.517297][ T1046]
[   29.517297][ T1046] the existing dependency chain (in reverse order) is:
[   29.518231][ T1046]
[   29.518231][ T1046] -> #1 (&dev->addr_list_lock_key#4){+...}:
[   29.519076][ T1046]        _raw_spin_lock+0x30/0x70
[   29.519588][ T1046]        dev_mc_sync_multiple+0x95/0x120
[   29.520208][ T1046]        bond_enslave+0x448d/0x47b0 [bonding]
[   29.520862][ T1046]        bond_option_slaves_set+0x1a3/0x370 [bonding]
[   29.521640][ T1046]        __bond_opt_set+0x1ff/0xbb0 [bonding]
[   29.522438][ T1046]        __bond_opt_set_notify+0x2b/0xf0 [bonding]
[   29.523251][ T1046]        bond_opt_tryset_rtnl+0x92/0xf0 [bonding]
[   29.524082][ T1046]        bonding_sysfs_store_option+0x8a/0xf0 [bonding]
[   29.524959][ T1046]        kernfs_fop_write+0x276/0x410
[   29.525620][ T1046]        vfs_write+0x197/0x4a0
[   29.526218][ T1046]        ksys_write+0x141/0x1d0
[   29.526818][ T1046]        do_syscall_64+0x99/0x4f0
[   29.527430][ T1046]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   29.528265][ T1046]
[   29.528265][ T1046] -> #0 (&dev->addr_list_lock_key#3){+...}:
[   29.529272][ T1046]        __lock_acquire+0x2d8d/0x3de0
[   29.529935][ T1046]        lock_acquire+0x164/0x3b0
[   29.530638][ T1046]        _raw_spin_lock+0x30/0x70
[   29.531187][ T1046]        dev_mc_sync_multiple+0x95/0x120
[   29.531790][ T1046]        bond_enslave+0x448d/0x47b0 [bonding]
[   29.532451][ T1046]        bond_option_slaves_set+0x1a3/0x370 [bonding]
[   29.533163][ T1046]        __bond_opt_set+0x1ff/0xbb0 [bonding]
[   29.533789][ T1046]        __bond_opt_set_notify+0x2b/0xf0 [bonding]
[   29.534595][ T1046]        bond_opt_tryset_rtnl+0x92/0xf0 [bonding]
[   29.535500][ T1046]        bonding_sysfs_store_option+0x8a/0xf0 [bonding]
[   29.536379][ T1046]        kernfs_fop_write+0x276/0x410
[   29.537057][ T1046]        vfs_write+0x197/0x4a0
[   29.537640][ T1046]        ksys_write+0x141/0x1d0
[   29.538251][ T1046]        do_syscall_64+0x99/0x4f0
[   29.538870][ T1046]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   29.539659][ T1046]
[   29.539659][ T1046] other info that might help us debug this:
[   29.539659][ T1046]
[   29.540953][ T1046]  Possible unsafe locking scenario:
[   29.540953][ T1046]
[   29.541883][ T1046]        CPU0                    CPU1
[   29.542540][ T1046]        ----                    ----
[   29.543209][ T1046]   lock(&dev->addr_list_lock_key#4);
[   29.543880][ T1046]                                lock(&dev->addr_list_lock_key#3);
[   29.544873][ T1046]                                lock(&dev->addr_list_lock_key#4);
[   29.545863][ T1046]   lock(&dev->addr_list_lock_key#3);
[   29.546525][ T1046]
[   29.546525][ T1046]  *** DEADLOCK ***
[   29.546525][ T1046]
[   29.547542][ T1046] 5 locks held by ifenslave/1046:
[   29.548196][ T1046]  #0: ffff88806044c478 (sb_writers#5){.+.+}, at: vfs_write+0x3bb/0x4a0
[   29.549248][ T1046]  #1: ffff88805af00890 (&of->mutex){+.+.}, at: kernfs_fop_write+0x1cf/0x410
[   29.550343][ T1046]  #2: ffff88805b8b54b0 (kn->count#157){.+.+}, at: kernfs_fop_write+0x1f2/0x410
[   29.551575][ T1046]  #3: ffffffffaecf4cf0 (rtnl_mutex){+.+.}, at: bond_opt_tryset_rtnl+0x5f/0xf0 [bonding]
[   29.552819][ T1046]  #4: ffff8880460f2280 (&dev->addr_list_lock_key#4){+...}, at: bond_enslave+0x4482/0x47b0 [bonding]
[   29.554175][ T1046]
[   29.554175][ T1046] stack backtrace:
[   29.554907][ T1046] CPU: 0 PID: 1046 Comm: ifenslave Not tainted 5.5.0+ #322
[   29.555854][ T1046] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   29.557064][ T1046] Call Trace:
[   29.557504][ T1046]  dump_stack+0x96/0xdb
[   29.558054][ T1046]  check_noncircular+0x371/0x450
[   29.558723][ T1046]  ? print_circular_bug.isra.35+0x310/0x310
[   29.559486][ T1046]  ? hlock_class+0x130/0x130
[   29.560100][ T1046]  ? __lock_acquire+0x2d8d/0x3de0
[   29.560761][ T1046]  __lock_acquire+0x2d8d/0x3de0
[   29.561366][ T1046]  ? register_lock_class+0x14d0/0x14d0
[   29.562045][ T1046]  ? find_held_lock+0x39/0x1d0
[   29.562641][ T1046]  lock_acquire+0x164/0x3b0
[   29.563199][ T1046]  ? dev_mc_sync_multiple+0x95/0x120
[   29.563872][ T1046]  _raw_spin_lock+0x30/0x70
[   29.564464][ T1046]  ? dev_mc_sync_multiple+0x95/0x120
[   29.565146][ T1046]  dev_mc_sync_multiple+0x95/0x120
[   29.565793][ T1046]  bond_enslave+0x448d/0x47b0 [bonding]
[   29.566487][ T1046]  ? bond_update_slave_arr+0x940/0x940 [bonding]
[   29.567279][ T1046]  ? bstr_printf+0xc20/0xc20
[   29.567857][ T1046]  ? stack_trace_consume_entry+0x160/0x160
[   29.568614][ T1046]  ? deactivate_slab.isra.77+0x2c5/0x800
[   29.569320][ T1046]  ? check_chain_key+0x236/0x5d0
[   29.569939][ T1046]  ? sscanf+0x93/0xc0
[   29.570442][ T1046]  ? vsscanf+0x1e20/0x1e20
[   29.571003][ T1046]  bond_option_slaves_set+0x1a3/0x370 [bonding]
[ ... ]

Fixes: ab92d68fc22f ("net: core: add generic lockdep keys")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - This patch isn't changed

 drivers/net/bonding/bond_main.c    | 2 ++
 drivers/net/bonding/bond_options.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 48d5ec770b94..1e9d5d35fc78 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3640,6 +3640,8 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 	case BOND_RELEASE_OLD:
 	case SIOCBONDRELEASE:
 		res = bond_release(bond_dev, slave_dev);
+		if (!res)
+			netdev_update_lockdep_key(slave_dev);
 		break;
 	case BOND_SETHWADDR_OLD:
 	case SIOCBONDSETHWADDR:
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index ddb3916d3506..215c10923289 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1398,6 +1398,8 @@ static int bond_option_slaves_set(struct bonding *bond,
 	case '-':
 		slave_dbg(bond->dev, dev, "Releasing interface\n");
 		ret = bond_release(bond->dev, dev);
+		if (!ret)
+			netdev_update_lockdep_key(dev);
 		break;
 
 	default:
-- 
2.17.1


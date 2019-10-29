Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6408E83EA
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 10:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbfJ2JMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 05:12:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43401 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfJ2JMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 05:12:43 -0400
Received: by mail-pl1-f196.google.com with SMTP id v5so7258087ply.10
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 02:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vaGbtdU2+pf1eC+WPgLvE+XWiEc1Qtk4BLjXaYVNS84=;
        b=dC7bIPCXsi1UeVqykd+BWsmGvCAbDX3ygxgjrfyV+5LUIRKL4Zt/uTahn5AEhD+C4o
         YPBw9p6YQVCWu4KOK8K4qd1mPAt/GBUCcR9tc5Csxtw7TqnOgCvI80wSHdTqbZC+6zBc
         Ivrksu9/mNTViea5Mo9CaGc65k/mE5OX4tIm5x4k8Y6SiBtX7VXtq95bf2UlHBCh9/HL
         WkhXGRrdfSOgx81/qBQBzMjgI+0usF5M92XqeFWm0sItLgna/oPWg32ulTgHjGmheMTI
         0fbpNdK6ocGsAGIFyMz8cc4YonMU8HqX3qpRhSKmvKyA/YpPQ6Uq0cV1kKxUCIa2avu3
         oMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vaGbtdU2+pf1eC+WPgLvE+XWiEc1Qtk4BLjXaYVNS84=;
        b=MA4XV05XDGo1+9e0PEFetTit+hibJ0USbONDUrdAs79YURaYEuc3rB0IcCp8YIWYbS
         0B25XUzcsyGlkdAvHzRo5NlsTzg3Pd3vRLdQZpnYkd6meAi998L3rWhPeCnXzJHLo6j8
         lmPJma8lXv8td9qkLuCpuIDpks3an5YZhuCQYw/4rugsMy6M88JTvxGsgbecPLVeweA3
         TvHEiZcqko2sKsxmlbjD1qVoxTsbGM0ju8KzfJy/mNrPR77Y6QTlcM6qMNGxvWkGnbw2
         vcqAJTsQwEMbP5DuFya0Pe2KGmHCuCiLshSqdzlkkZUdZ4eP4FosWo8ymjODazqyDEb+
         tE2w==
X-Gm-Message-State: APjAAAV8uHJ6KJQ6TQzn5Uu+WTpNdpNcZnfOqSltQEwRf3n7jepWwj95
        ShGDuAbJfH/cnD5ktCJ+VQM=
X-Google-Smtp-Source: APXvYqxDIm329ahlCcKV3Kc/pDB9+LgGVZROWH9osF+khgfWqeKCsH4gunZpKOYyqQO94o/uBNRh+w==
X-Received: by 2002:a17:902:7605:: with SMTP id k5mr2700230pll.99.1572340361379;
        Tue, 29 Oct 2019 02:12:41 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id o15sm1617157pjs.14.2019.10.29.02.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 02:12:40 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Cc:     j.vosburgh@gmail.com, ap420073@gmail.com
Subject: [PATCH net] bonding: fix using uninitialized mode_lock
Date:   Tue, 29 Oct 2019 09:12:32 +0000
Message-Id: <20191029091232.12026-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a bonding interface is being created, it setups its mode and options.
At that moment, it uses mode_lock so mode_lock should be initialized
before that moment.

rtnl_newlink()
	rtnl_create_link()
		alloc_netdev_mqs()
			->setup() //bond_setup()
	->newlink //bond_newlink
		bond_changelink()
		register_netdevice()
			->ndo_init() //bond_init()

After commit 089bca2caed0 ("bonding: use dynamic lockdep key instead of
subclass"), mode_lock is initialized in bond_init().
So in the bond_changelink(), un-initialized mode_lock can be used.
mode_lock should be initialized in bond_setup().
This patch partially reverts commit 089bca2caed0 ("bonding: use dynamic
lockdep key instead of subclass")

Test command:
    ip link add bond0 type bond mode 802.3ad lacp_rate 0

Splat looks like:
[   60.615127] INFO: trying to register non-static key.
[   60.615900] the code is fine but needs lockdep annotation.
[   60.616697] turning off the locking correctness validator.
[   60.617490] CPU: 1 PID: 957 Comm: ip Not tainted 5.4.0-rc3+ #109
[   60.618350] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   60.619481] Call Trace:
[   60.619918]  dump_stack+0x7c/0xbb
[   60.620453]  register_lock_class+0x1215/0x14d0
[   60.621131]  ? alloc_netdev_mqs+0x7b3/0xcc0
[   60.621771]  ? is_bpf_text_address+0x86/0xf0
[   60.622416]  ? is_dynamic_key+0x230/0x230
[   60.623032]  ? unwind_get_return_address+0x5f/0xa0
[   60.623757]  ? create_prof_cpu_mask+0x20/0x20
[   60.624408]  ? arch_stack_walk+0x83/0xb0
[   60.625023]  __lock_acquire+0xd8/0x3de0
[   60.625616]  ? stack_trace_save+0x82/0xb0
[   60.626225]  ? stack_trace_consume_entry+0x160/0x160
[   60.626957]  ? deactivate_slab.isra.80+0x2c5/0x800
[   60.627668]  ? register_lock_class+0x14d0/0x14d0
[   60.628380]  ? alloc_netdev_mqs+0x7b3/0xcc0
[   60.629020]  ? save_stack+0x69/0x80
[   60.629574]  ? save_stack+0x19/0x80
[   60.630121]  ? __kasan_kmalloc.constprop.4+0xa0/0xd0
[   60.630859]  ? __kmalloc_node+0x16f/0x480
[   60.631472]  ? alloc_netdev_mqs+0x7b3/0xcc0
[   60.632121]  ? rtnl_create_link+0x2ed/0xad0
[   60.634388]  ? __rtnl_newlink+0xad4/0x11b0
[   60.635024]  lock_acquire+0x164/0x3b0
[   60.635608]  ? bond_3ad_update_lacp_rate+0x91/0x200 [bonding]
[   60.636463]  _raw_spin_lock_bh+0x38/0x70
[   60.637084]  ? bond_3ad_update_lacp_rate+0x91/0x200 [bonding]
[   60.637930]  bond_3ad_update_lacp_rate+0x91/0x200 [bonding]
[   60.638753]  ? bond_3ad_lacpdu_recv+0xb30/0xb30 [bonding]
[   60.639552]  ? bond_opt_get_val+0x180/0x180 [bonding]
[   60.640307]  ? ___slab_alloc+0x5aa/0x610
[   60.640925]  bond_option_lacp_rate_set+0x71/0x140 [bonding]
[   60.641751]  __bond_opt_set+0x1ff/0xbb0 [bonding]
[   60.643217]  ? kasan_unpoison_shadow+0x30/0x40
[   60.643924]  bond_changelink+0x9a4/0x1700 [bonding]
[   60.644653]  ? memset+0x1f/0x40
[   60.742941]  ? bond_slave_changelink+0x1a0/0x1a0 [bonding]
[   60.752694]  ? alloc_netdev_mqs+0x8ea/0xcc0
[   60.753330]  ? rtnl_create_link+0x2ed/0xad0
[   60.753964]  bond_newlink+0x1e/0x60 [bonding]
[   60.754612]  __rtnl_newlink+0xb9f/0x11b0
[ ... ]

Reported-by: syzbot+8da67f407bcba2c72e6e@syzkaller.appspotmail.com
Reported-by: syzbot+0d083911ab18b710da71@syzkaller.appspotmail.com
Fixes: 089bca2caed0 ("bonding: use dynamic lockdep key instead of subclass")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a48950b81434..480f9459b402 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4284,6 +4284,7 @@ void bond_setup(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 
+	spin_lock_init(&bond->mode_lock);
 	bond->params = bonding_defaults;
 
 	/* Initialize pointers */
@@ -4756,7 +4757,6 @@ static int bond_init(struct net_device *bond_dev)
 	if (!bond->wq)
 		return -ENOMEM;
 
-	spin_lock_init(&bond->mode_lock);
 	spin_lock_init(&bond->stats_lock);
 	lockdep_register_key(&bond->stats_lock_key);
 	lockdep_set_class(&bond->stats_lock, &bond->stats_lock_key);
-- 
2.17.1


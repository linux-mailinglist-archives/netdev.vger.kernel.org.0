Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6561017065E
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgBZRn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:43:59 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39643 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgBZRn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:43:58 -0500
Received: by mail-pg1-f195.google.com with SMTP id j15so19936pgm.6
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YoxBFaJwp79cTV0sFdQY2MHh7TsC1KL4EP7GRVxRbSc=;
        b=HQIr30J7ebCXafyv4ExmPURLzq9nSOaGdY/k3gYI8Ao9C1Q9zOWLEs21Jptb04HOfZ
         aE7auDTxVmmCrZf/9DqBe3h4enr6BZdMa9dpX0bda7TS9ynYHGu2+sVrvHBPLJMLlSWS
         1LRp7RHvvI6P0x691dMoU0mZnfy9V+fhmTlp01FWLgQz1euKZQS5d17fDmmpeKhaUFvz
         7R38vOZf5KuQKHfWqYwolMURA0+qQp8JY1K6nm12ytS382XcO8zFKwzaDLyX4ybhtvM7
         JWlBrs4cLSpyOs9461Q8FzVI7G17bdFOW0eOMjS5Yw0xHh1hZ+4a2XCCGdrrlM7FvB2l
         Q00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YoxBFaJwp79cTV0sFdQY2MHh7TsC1KL4EP7GRVxRbSc=;
        b=oH8PRxWndEtHMEPXY30RJlzwXJs/VMwjEa9EU03nUnbFbaVM7+3V/GyB0m/ReLS9F9
         OLG9jmpARXg322KntfSG7cBBveqFG09Ky11+UU/bFO8qI8mAZz6hiuY/ZDum1/rk6C8g
         yoaIX5BFvYo0tNEZWPgKnGHwLv14x3Z/0aXHt+pFtLZB5P0uT2hMqGfWSo36DFPNI6IJ
         w34yGYWbD4UwtlASs1fQ7zxCiDq2rCPw2AoM8+A0UcSKPSPVC3IYJqs6T26apQ8qXEj3
         O/f5DLNcpOCGe+oo5rv4439DEtw1SnZZBVgfnw2aO3PwLmuD7/nd7Fz++FrbPAq0/K6p
         SsDA==
X-Gm-Message-State: APjAAAU2omS2Gg/344oQ6hw0RfuFjxYv58QD5JiOgMumwfKFsgCq53br
        oVmWzSVW5j65TngoEFaOWjSoalyDGZY=
X-Google-Smtp-Source: APXvYqwCmGh8JNU2iG3TmzzvT7gNBer3UjfHDbkjOKyWdOvjICTeZS1e5EJNjCLOlKCUykCb/0F0VA==
X-Received: by 2002:aa7:84cd:: with SMTP id x13mr5720615pfn.130.1582739036381;
        Wed, 26 Feb 2020 09:43:56 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id l13sm3445699pjq.23.2020.02.26.09.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:43:55 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 01/10] net: rmnet: fix NULL pointer dereference in rmnet_newlink()
Date:   Wed, 26 Feb 2020 17:43:49 +0000
Message-Id: <20200226174349.4403-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rmnet registers IFLA_LINK interface as a lower interface.
But, IFLA_LINK could be NULL.
In the current code, rmnet doesn't check IFLA_LINK.
So, panic would occur.

Test commands:
    modprobe rmnet
    ip link add rmnet0 type rmnet mux_id 1

Splat looks like:
[   79.718433][  T923] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 I
[   79.721234][  T923] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[   79.722852][  T923] CPU: 0 PID: 923 Comm: ip Not tainted 5.5.0+ #394
[   79.723897][  T923] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   79.725395][  T923] RIP: 0010:rmnet_newlink+0x54/0x510 [rmnet]
[   79.726349][  T923] Code: 83 ec 18 48 c1 e9 03 80 3c 01 00 0f 85 d4 03 00 00 48 8b 6a 28 48 b8 00 00 00 00 00 fc ff dc
[   79.729114][  T923] RSP: 0018:ffff88804cc9f1c0 EFLAGS: 00010247
[   79.729970][  T923] RAX: dffffc0000000000 RBX: ffff8880620dfa00 RCX: 1ffff11009993e99
[   79.731122][  T923] RDX: 0000000000000000 RSI: ffff888064f34000 RDI: 0000000000000004
[   79.732389][  T923] RBP: 0000000000000000 R08: ffff88804cc9f8b0 R09: ffff8880644f0990
[   79.733533][  T923] R10: ffffffffc04cfa40 R11: ffffed100c89e137 R12: ffffffff96ceacc0
[   79.734810][  T923] R13: ffff888064f34000 R14: ffff88804cc9f8b0 R15: ffff888064f34000
[   79.736102][  T923] FS:  00007f11d83b60c0(0000) GS:ffff88806c000000(0000) knlGS:0000000000000000
[   79.737509][  T923] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   79.738430][  T923] CR2: 00005614e7c6bb00 CR3: 0000000064d58006 CR4: 00000000000606f0
[   79.739545][  T923] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   79.740663][  T923] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   79.741786][  T923] Call Trace:
[   79.742244][  T923]  __rtnl_newlink+0xbdb/0x1270
[   79.742846][  T923]  ? lock_downgrade+0x6e0/0x6e0
[   79.743450][  T923]  ? rtnl_link_unregister+0x220/0x220
[   79.744122][  T923]  ? lock_acquire+0x164/0x3b0
[   79.744724][  T923]  ? is_bpf_image_address+0xff/0x1d0
[   79.745397][  T923]  ? rtnl_newlink+0x4c/0x90
[   79.745958][  T923]  ? kernel_text_address+0x111/0x140
[   79.746621][  T923]  ? __kernel_text_address+0xe/0x30
[   79.747270][  T923]  ? unwind_get_return_address+0x5f/0xa0
[   79.747974][  T923]  ? create_prof_cpu_mask+0x20/0x20
[   79.748635][  T923]  ? arch_stack_walk+0x83/0xb0
[   79.749238][  T923]  ? stack_trace_save+0x82/0xb0
[   79.749850][  T923]  ? stack_trace_consume_entry+0x160/0x160
[   79.750574][  T923]  ? deactivate_slab.isra.78+0x2c5/0x800
[   79.751306][  T923]  ? kasan_unpoison_shadow+0x30/0x40
[   79.751971][  T923]  ? kmem_cache_alloc_trace+0x135/0x350
[   79.752671][  T923]  ? rtnl_newlink+0x4c/0x90
[   79.753239][  T923]  rtnl_newlink+0x65/0x90
[ ... ]

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 06de59521fc4..471e3b2a1403 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -135,6 +135,11 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 	int err = 0;
 	u16 mux_id;
 
+	if (!tb[IFLA_LINK]) {
+		NL_SET_ERR_MSG_MOD(extack, "link not specified");
+		return -EINVAL;
+	}
+
 	real_dev = __dev_get_by_index(src_net, nla_get_u32(tb[IFLA_LINK]));
 	if (!real_dev || !dev)
 		return -ENODEV;
-- 
2.17.1


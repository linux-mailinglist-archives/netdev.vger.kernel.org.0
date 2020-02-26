Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7113170665
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgBZRow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:44:52 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36718 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgBZRow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:44:52 -0500
Received: by mail-pg1-f194.google.com with SMTP id d9so28897pgu.3
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7a36pjxkFmsIkvhAgo7V/LR+VuMqWMf0y+Tp1c8BoGU=;
        b=DUA1lj9zhNElH7khRucQjSyh9alZJyfKKjSrd0/xlSzR6+rhk7m2ODOj7wub6ywgJM
         GoyMc9RMWYHhdI6TcQZmb0Xj/EpjDYkVKXyctPhkxSWamhZoK0V7jxmUgW1XhCkl7Tmt
         FUCw47f5flkTdLhHKsId4wTHz8xhM9zR36nKsHiYCxuQa5jxSVsL/3fZm8JpQb4FBGVI
         MFJB2wJO30ls1UIcz6nlLDSzX2n36vz3N6fQSqekSHfGthP4kJqq2x9kwc8wEdxvmmUV
         H55o8Hz8dkg+O0GD1g0D1iVyHu+hbTH96UXBxTKiKlfCBUs+2ja5XI3naQ14uQO7LqTX
         gnZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7a36pjxkFmsIkvhAgo7V/LR+VuMqWMf0y+Tp1c8BoGU=;
        b=r7/7UyQD93uQ0Ma34d8e8UqeMfvSR25PVGNQPFWlzmqAQwUPYQSAhsnyQtA2vjzXx4
         rFN6vr+Q1d6YGEvBgF/dMYNG3GJ+mUJEle2H8ST/xXhV8/AbTol4wj92hUVEB+A2mCHS
         jA9HRRD2MachHkqALerocOXezDQy9wEmSXCSBkVFOHllDc4/adyC4vqX4e37v9swmfbS
         xwCGjjo/84aJzOKT0Tqxbrdb7+J+DbrP44MUVidQIr75Z/RGQAsYfQUfujZ7cKMnwxAT
         bKyLahqag5x/0rI607CKCysb4NJBPqgyNoL1c9SnUGhmp+neO0ZlEqhMEcK2XnqzI7IR
         w6VQ==
X-Gm-Message-State: APjAAAX7PIn1DJvoVKCmpGUi/K0PT4SHQs6ItUGJcOC7Co3HSqKuq1ny
        vd104QzuVaRXZ9dpFG7+QSc=
X-Google-Smtp-Source: APXvYqwXq65f/IZVh3Nym4w1gjyJKAcbfF8tFNoK2MvZKglPntuj3EDUzI5rIrycoFbHixcQchZV+A==
X-Received: by 2002:a62:1958:: with SMTP id 85mr5246606pfz.221.1582739089760;
        Wed, 26 Feb 2020 09:44:49 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id k67sm3467842pga.91.2020.02.26.09.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:44:48 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 03/10] net: rmnet: fix NULL pointer dereference in rmnet_changelink()
Date:   Wed, 26 Feb 2020 17:44:43 +0000
Message-Id: <20200226174443.4749-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the rmnet_changelink(), it uses IFLA_LINK without checking
NULL pointer.
tb[IFLA_LINK] could be NULL pointer.
So, NULL-ptr-deref could occur.

rmnet already has a lower interface (real_dev).
So, after this patch, rmnet_changelink() does not use IFLA_LINK anymore.

Test commands:
    modprobe rmnet
    ip link add dummy0 type dummy
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link set rmnet0 type rmnet mux_id 2

Splat looks like:
[   73.784702][  T944] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 I
[   73.786128][  T944] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[   73.786894][  T944] CPU: 0 PID: 944 Comm: ip Not tainted 5.5.0+ #406
[   73.787573][  T944] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   73.788865][  T944] RIP: 0010:rmnet_changelink+0x5a/0x8a0 [rmnet]
[   73.789895][  T944] Code: 83 ec 20 48 c1 ea 03 80 3c 02 00 0f 85 6f 07 00 00 48 8b 5e 28 48 b8 00 00 00 00 00 fc ff d0
[   73.792187][  T944] RSP: 0018:ffff88804ca571b8 EFLAGS: 00010247
[   73.792939][  T944] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff88804ca578b0
[   73.793880][  T944] RDX: 0000000000000000 RSI: ffff88804ca574a0 RDI: 0000000000000004
[   73.794904][  T944] RBP: ffff88806241f400 R08: 0000000000000002 R09: 0000000000000002
[   73.796720][  T944] R10: ffffffffc03f2a80 R11: 0000000000000000 R12: ffff88804d094000
[   73.797721][  T944] R13: ffff88804d094000 R14: ffff88806241e800 R15: 0000000000000000
[   73.798770][  T944] FS:  00007fc9d81650c0(0000) GS:ffff88806c000000(0000) knlGS:0000000000000000
[   73.800184][  T944] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   73.801265][  T944] CR2: 0000557c57167458 CR3: 0000000066eea003 CR4: 00000000000606f0
[   73.802297][  T944] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   73.803290][  T944] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   73.804433][  T944] Call Trace:
[   73.804855][  T944]  __rtnl_newlink+0x922/0x1270
[   73.805459][  T944]  ? lock_downgrade+0x6e0/0x6e0
[   73.806068][  T944]  ? rtnl_link_unregister+0x220/0x220
[   73.806737][  T944]  ? lock_acquire+0x164/0x3b0
[   73.807328][  T944]  ? is_bpf_image_address+0xff/0x1d0
[   73.807983][  T944]  ? rtnl_newlink+0x4c/0x90
[   73.808540][  T944]  ? kernel_text_address+0x111/0x140
[   73.809196][  T944]  ? __kernel_text_address+0xe/0x30
[   73.809859][  T944]  ? unwind_get_return_address+0x5f/0xa0
[   73.810560][  T944]  ? create_prof_cpu_mask+0x20/0x20
[   73.811614][  T944]  ? arch_stack_walk+0x83/0xb0
[   73.812350][  T944]  ? stack_trace_save+0x82/0xb0
[   73.812976][  T944]  ? stack_trace_consume_entry+0x160/0x160
[   73.814174][  T944]  ? deactivate_slab.isra.78+0x2c5/0x800
[   73.814920][  T944]  ? kasan_unpoison_shadow+0x30/0x40
[   73.815594][  T944]  ? kmem_cache_alloc_trace+0x135/0x350
[   73.816789][  T944]  ? rtnl_newlink+0x4c/0x90
[   73.817357][  T944]  rtnl_newlink+0x65/0x90
[ ... ]

Fixes: 23790ef12082 ("net: qualcomm: rmnet: Allow to configure flags for existing devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index f3d6a43b97a1..7a7d0f521352 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -300,10 +300,8 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (!dev)
 		return -ENODEV;
 
-	real_dev = __dev_get_by_index(dev_net(dev),
-				      nla_get_u32(tb[IFLA_LINK]));
-
-	if (!real_dev || !rmnet_is_real_dev_registered(real_dev))
+	real_dev = priv->real_dev;
+	if (!rmnet_is_real_dev_registered(real_dev))
 		return -ENODEV;
 
 	port = rmnet_get_port_rtnl(real_dev);
-- 
2.17.1


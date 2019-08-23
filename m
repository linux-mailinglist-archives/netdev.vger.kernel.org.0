Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 140FC9A5E2
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 05:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404059AbfHWDDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 23:03:14 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37535 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfHWDDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 23:03:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id y9so5052683pfl.4
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 20:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=yAvoPzupIuR0xh/wfNpq0xS13G7AED6WrSvbPEM79Xs=;
        b=jLobQghDo8aRNJMTWs2nTm6QWlTmrek7KREbND3fI0zZldS63Xzx1TkuFWSKvFzDMw
         1QZ81Rs8lU5k7UE8C7NWq24gbVZT9aBzKtkO0vMN02es99/B03OFUymD2nwtMurfq5qi
         Ryl6jbzuH2phY7hLbYqUTjqv0L6imT9nAj+vLzuDO4pimjN/MTK4Uo/CZQv+bQ3Ay5mf
         yv0aRLtufkLEp6H6qc6CPtKDCMnfJJeE0z7csIG2CtfQmKt1eqAmZ8M4BOrH6l+1jSFC
         yQX4LmIc/HoFmsg+oNhYqCBHqjADLVV3jlVHvOiSmSJLZACVNyHn3jAoJ3hV6/IPOLiw
         NPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=yAvoPzupIuR0xh/wfNpq0xS13G7AED6WrSvbPEM79Xs=;
        b=eKxSQTC/J3wCA+BELcAjBYtknM4V8D6Wc/TCb/oB0vsIm3dWFavmR9pyER13retPMc
         uyF7ZnZJXurXG10G9TV0Rl6F6AMY9znMannqCnNcIEawwPQKA4gQIRuihIs+WwOjC1dM
         Gxk4OHDRoKI/a+hE+v//BFOOuA55QyqIwwueuGvKr+dgYTKuP043etrVP9RNnWkYuynP
         juG73d0lymzU6uJ6Aht3UnijeVKJRhbz0KP57XKm+ajyK5SmDFA2bFbKCvr5TNGvYAwT
         mq9gmzlMcIBfMOVxIKq1M7krlZkNpS/4qWhHqsAKUboF78Dki4JUn+6XTcYS7uqnLfRx
         f75g==
X-Gm-Message-State: APjAAAWYqu538WrNyeV6y5ZVlU1/on1WYIxPEutj/iFoHBmOCRdKy+WU
        xK3B7hFE+QXOvcuktqGz7ij+b1vl
X-Google-Smtp-Source: APXvYqxTfuOHKXC1fFcMVsCzGpWArxIBrt2NvWAQ65GNhTRDp3EeXwBhZm45aegKqb4c55LxtdOfNg==
X-Received: by 2002:a17:90a:fa0a:: with SMTP id cm10mr1094384pjb.133.1566529392840;
        Thu, 22 Aug 2019 20:03:12 -0700 (PDT)
Received: from [172.26.99.184] ([2620:10d:c090:180::3d5f])
        by smtp.gmail.com with ESMTPSA id g14sm833412pfo.41.2019.08.22.20.03.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 20:03:12 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     Netdev <netdev@vger.kernel.org>, michael.chan@broadcom.com
Cc:     kernel-team@fb.com
Subject: BUG: bnxt_en driver fails to initialize
Date:   Thu, 22 Aug 2019 20:03:11 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <E350D230-9E45-41FC-ADF5-5CF2317171DA@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On a recent net-next 932630fa902878f4c8c50d0b1260eeb9de16b0a4,
installing the build on a box which has a Broadcom card with
the 20.1 firmware, the driver refuses to initialize.  I tracked
this down to:

	static int bnxt_alloc_stats(struct bnxt *bp)
	...
                 cpr->hw_stats = dma_alloc_coherent(&pdev->dev, size,
                                                    &cpr->hw_stats_map,
                                                    GFP_KERNEL);
                 if (!cpr->hw_stats)
                         return -ENOMEM;

Where size == 0, so obviously it returns NULL, and -ENOMEM.

The same build, when installed on different box with the
20.6.167.0 firmware, works fine.  Details below.


Taken from the same box with a 4.16 kernel, showing firmware:

# ethtool -i eth0
driver: bnxt_en
version: 1.9.0
firmware-version: 20.1.20.0
expansion-rom-version:
bus-info: 0000:03:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: yes
supports-register-dump: no
supports-priv-flags: no


The problematic box:

[    0.000000] Linux version 5.3.0-rc5-00987-g12a993533ad1 
(bsd@devvm1828.vll1.facebook.com) (gcc version 4.8.5 20150623 (Red Hat 
4.8.5-36) (GCC)) #7 SMP Thu Aug 22 19:48:01 PDT 2019

[   11.195653] Broadcom NetXtreme-C/E driver bnxt_en v1.10.0
[   11.262489] b:00.0 (unnamed net_device) (uninitialized): Firmware 
does not support TC flower offload.
[   11.283546] bnxt_en 0000:03:00.0 eth0: Firmware does not support NVM 
params
[   11.297448] bnxt_en 0000:03:00.0 eth0: Broadcom BCM57302 NetXtreme-C 
10Gb/25Gb Ethernet found at mem 383fffe10000, node addr 
00:0a:f7:a3:d8:94
[   11.322965] bnxt_en 0000:03:00.0: 63.008 Gb/s available PCIe 
bandwidth (8 GT/s x8 link)

[   12.136319] WARNING: CPU: 5 PID: 1 at ../mm/page_alloc.c:4707 
__alloc_pages_nodemask+0x27c/0x330
[   12.155239] Modules linked in:
[   12.155242] CPU: 5 PID: 1 Comm: swapper/0 Not tainted 
5.3.0-rc5-00987-g12a993533ad1 #7
[   12.155243] Hardware name: Quanta Leopard ORv2-DDR4/Leopard 
ORv2-DDR4, BIOS F06_3B17 03/16/2018
[   12.155245] RIP: 0010:__alloc_pages_nodemask+0x27c/0x330
[   12.239793] Code: 48 83 c3 18 44 89 e9 44 89 e2 48 89 ee e8 5c b9 bb 
00 4c 8b 0b 4d 85 c9 75 df 48 89 e8 e9 42 ff ff ff 81 e7 00 20 00 00 75 
02 <0f> 0b 31 c0 e9 31 ff ff ff 48 89 e8 e9 29 ff ff ff 89 c2 90 e9 f0
[   12.277249] RSP: 0000:ffffc9000c4dfc08 EFLAGS: 00010246
[   12.287667] RAX: 0000000000000000 RBX: 0000000000000cc0 RCX: 
0000000000000000
[   12.301897] RDX: 0000000000000000 RSI: 0000000000000034 RDI: 
0000000000000000
[   12.316127] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000000
[   12.330358] R10: ffff888000000000 R11: 00000000ffdd4f00 R12: 
0000000000000034
[   12.344587] R13: 0000160000000000 R14: ffffffffffffffff R15: 
ffff889ff71ad0b0
[   12.358819] FS:  0000000000000000(0000) GS:ffff889fff540000(0000) 
knlGS:0000000000000000
[   12.374957] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.386413] CR2: 0000000000000000 CR3: 000000000240a001 CR4: 
00000000003606e0
[   12.400643] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   12.414875] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[   12.429107] Call Trace:
[   12.433981]  __dma_direct_alloc_pages+0x89/0x120
[   12.443200]  dma_direct_alloc_pages+0x1c/0xa0
[   12.451902]  bnxt_alloc_mem+0x32e/0xe20
[   12.459566]  ? bnxt_need_reserve_rings+0x30/0x120
[   12.468957]  __bnxt_open_nic+0x8c/0x880
[   12.476601]  bnxt_open+0x34/0xb0
[   12.483032]  __dev_open+0xd1/0x160
[   12.489807]  dev_open+0x43/0x90
[   12.496070]  netpoll_setup+0x26d/0x330
[   12.503558]  init_netconsole+0x145/0x276
[   12.511390]  ? option_setup+0x1f/0x1f
[   12.518705]  do_one_initcall+0x4e/0x1f4
[   12.526351]  ? trace_event_define_fields_initcall_finish+0x62/0x62
[   12.538690]  kernel_init_freeable+0x182/0x224
[   12.547376]  ? trace_event_define_fields_initcall_finish+0x62/0x62
[   12.559716]  ? rest_init+0xb0/0xb0
[   12.566491]  kernel_init+0xa/0x110
[   12.573269]  ret_from_fork+0x35/0x40
[   12.580392] ---[ end trace e4d68dee87999a79 ]---
[   12.589614] bnxt_en 0000:03:00.0 eth0: bnxt_alloc_mem err: fffffff4

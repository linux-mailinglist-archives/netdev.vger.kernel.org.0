Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B53427973
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 13:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhJILgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 07:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhJILge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 07:36:34 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC17FC061570;
        Sat,  9 Oct 2021 04:34:37 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id w14so7910270pll.2;
        Sat, 09 Oct 2021 04:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=V7I/zX/kf6LjDCTMk5AGPP51xv3tX1H+L4vkXCbxa2w=;
        b=n79fBPjgFUiVU2UrCeHd7L89wJf1au37YOsbprNAf/3l3v173mFsWio3kf8rw3OzSv
         R2bA1UucnJarbM86TnQpz4hXU2XwaG+ltM/VORH7VyOIy0LIfNfW/AtHM7ZKlGlQzFJV
         cQNhQ/21xcMtIxL8kdpSsNn34PYBjPy2Z8m4LlWoWLIYylfSTuWTi+doD1FVTMYsUUWp
         bcvzeuZvixoFmUgOP1/KPJHQyXDulNztR3Z7UfercQdDKDqkO1QfQP82ryATe2fzDYEl
         8YidikKxRO4i/IBm8A7U/BkjILYDgISLFBgJqL6zbsv7F5ctWl93NncAJ9lXpzowWrbK
         c/jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V7I/zX/kf6LjDCTMk5AGPP51xv3tX1H+L4vkXCbxa2w=;
        b=8PyPgWdwngxJev4YpabNzhX70B2XGyo7rzn/MTf4GnlKTuGqv8Lyri5Yov98Ity4tU
         DwP93FbxHYR174QPdEURch/xSGYB2mzCLY8B12JGa6Vqw1+fMx67AyQRhT4rRNE1oKED
         SAKmwWPyalEXvcQRcgPGD4Pj+gJ0OlFCsa/TORpbP4ccbOCqnSV7VHdspQCWHUqRe3u1
         r1ESHJBnpWEO75fym36w27OLAqde6a7chJcbtpjhCmwTi6M9I3k/EfWKWx16/TaiS4VR
         l3rs5t+hWvEwygLEVitmUjuipxZBnY7h3khzZqkkB3DRIpwc6qz82BhF1s+HM4G2plzk
         Ntwg==
X-Gm-Message-State: AOAM5324zDOlkHMWR/wii1NnqMYo641SUreMqqfEUVS7a2M3+i2jO74R
        Lmk/bxjbXl8v0Cvy9cOQRQ==
X-Google-Smtp-Source: ABdhPJzeMf7BDD6mihfI5di8cP/F7P9cb6X76Ksv2dYwlwm1EM/IBdKforvhZEOOTHCTWHhm5Zm1qg==
X-Received: by 2002:a17:90a:d58b:: with SMTP id v11mr17532601pju.207.1633779277348;
        Sat, 09 Oct 2021 04:34:37 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id u25sm1983246pfh.132.2021.10.09.04.34.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Oct 2021 04:34:36 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     isdn@linux-pingi.de, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] isdn: mISDN: Fix sleeping function called from invalid context
Date:   Sat,  9 Oct 2021 11:33:49 +0000
Message-Id: <1633779229-20840-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can call card->isac.release() function from an atomic
context.

Fix this by calling this function after releasing the lock.

The following log reveals it:

[   44.168226 ] BUG: sleeping function called from invalid context at kernel/workqueue.c:3018
[   44.168941 ] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 5475, name: modprobe
[   44.169574 ] INFO: lockdep is turned off.
[   44.169899 ] irq event stamp: 0
[   44.170160 ] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[   44.170627 ] hardirqs last disabled at (0): [<ffffffff814209ed>] copy_process+0x132d/0x3e00
[   44.171240 ] softirqs last  enabled at (0): [<ffffffff81420a1a>] copy_process+0x135a/0x3e00
[   44.171852 ] softirqs last disabled at (0): [<0000000000000000>] 0x0
[   44.172318 ] Preemption disabled at:
[   44.172320 ] [<ffffffffa009b0a9>] nj_release+0x69/0x500 [netjet]
[   44.174441 ] Call Trace:
[   44.174630 ]  dump_stack_lvl+0xa8/0xd1
[   44.174912 ]  dump_stack+0x15/0x17
[   44.175166 ]  ___might_sleep+0x3a2/0x510
[   44.175459 ]  ? nj_release+0x69/0x500 [netjet]
[   44.175791 ]  __might_sleep+0x82/0xe0
[   44.176063 ]  ? start_flush_work+0x20/0x7b0
[   44.176375 ]  start_flush_work+0x33/0x7b0
[   44.176672 ]  ? trace_irq_enable_rcuidle+0x85/0x170
[   44.177034 ]  ? kasan_quarantine_put+0xaa/0x1f0
[   44.177372 ]  ? kasan_quarantine_put+0xaa/0x1f0
[   44.177711 ]  __flush_work+0x11a/0x1a0
[   44.177991 ]  ? flush_work+0x20/0x20
[   44.178257 ]  ? lock_release+0x13c/0x8f0
[   44.178550 ]  ? __kasan_check_write+0x14/0x20
[   44.178872 ]  ? do_raw_spin_lock+0x148/0x360
[   44.179187 ]  ? read_lock_is_recursive+0x20/0x20
[   44.179530 ]  ? __kasan_check_read+0x11/0x20
[   44.179846 ]  ? do_raw_spin_unlock+0x55/0x900
[   44.180168 ]  ? ____kasan_slab_free+0x116/0x140
[   44.180505 ]  ? _raw_spin_unlock_irqrestore+0x41/0x60
[   44.180878 ]  ? skb_queue_purge+0x1a3/0x1c0
[   44.181189 ]  ? kfree+0x13e/0x290
[   44.181438 ]  flush_work+0x17/0x20
[   44.181695 ]  mISDN_freedchannel+0xe8/0x100
[   44.182006 ]  isac_release+0x210/0x260 [mISDNipac]
[   44.182366 ]  nj_release+0xf6/0x500 [netjet]
[   44.182685 ]  nj_remove+0x48/0x70 [netjet]
[   44.182989 ]  pci_device_remove+0xa9/0x250

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/isdn/hardware/mISDN/netjet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
index 2a1ddd47a096..a52f275f8263 100644
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -949,8 +949,8 @@ nj_release(struct tiger_hw *card)
 		nj_disable_hwirq(card);
 		mode_tiger(&card->bc[0], ISDN_P_NONE);
 		mode_tiger(&card->bc[1], ISDN_P_NONE);
-		card->isac.release(&card->isac);
 		spin_unlock_irqrestore(&card->lock, flags);
+		card->isac.release(&card->isac);
 		release_region(card->base, card->base_s);
 		card->base_s = 0;
 	}
-- 
2.17.6


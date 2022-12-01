Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F330B63F322
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 15:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiLAOuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 09:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiLAOui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 09:50:38 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BA1AC6D3
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 06:50:36 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id m11-20020a056e021c2b00b00302c7ea7e16so2156232ilh.22
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 06:50:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7OqqbGGfV7CnIAjWLX7v/xkTtEv375dPjP0bZcvVyAc=;
        b=Tgqtinhz36/UIHreG7S/vWTJ+GKUzz86hSwO28zQcZbic69hyqfXfQTcEiHcFIeabb
         pQaVXiZjD/gX+bknzq8r5i9+peekc03NFDmcDphd3/kseFsgNZV934fhMlPpqHLE2jyI
         9QWjg4Aw+Q5mXP9SrnDeKNpWFQG+01nqOGJ4myR+FPIGGzzwxX2KIbRgNTykftuJZwz0
         3vESEtbnO6mKwnRk15vkzLi5lnytU22SXk56AZtGYAbektMZXpMxSp0KeOj2IKW1R1XH
         ZM/ws4qs/5lZrt9IXIJ97POxshNwsnE6BQo0/Eu8FET6qb2hVjRzfmAI9qiwOubHbUFF
         cylw==
X-Gm-Message-State: ANoB5pmZN20K6xMKHdi9WOw6ZrA6vn4YjXn4JGTd3cVG/AvIBEDPqoSg
        F4tOtG7SnUIkFQw81j5kReSoudl9mGm2LXDgenaJsnb5zdiT
X-Google-Smtp-Source: AA0mqf6EWFfuPHoRflZazvz1RaxPt5YTGx/PmgBNF03Y2SbGPpXoI7i65XRqM0+FCaIGjuQT5DPp771jmIMxnsC5bXO+FYJSOLOh
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1189:b0:302:fa94:c735 with SMTP id
 y9-20020a056e02118900b00302fa94c735mr14905106ili.57.1669906236117; Thu, 01
 Dec 2022 06:50:36 -0800 (PST)
Date:   Thu, 01 Dec 2022 06:50:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000031adb05eec5581a@google.com>
Subject: [syzbot] memory leak in napi_skb_cache_get
From:   syzbot <syzbot+a1fab9d8e5da048ac8a1@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,LONGWORDS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    64c3dd0b98f5 Merge tag 'xfs-6.1-fixes-4' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1761a066880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7da85296f1024c6a
dashboard link: https://syzkaller.appspot.com/bug?extid=a1fab9d8e5da048ac8a1
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ac3e61880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17b2040a880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ebc55fa5a058/disk-64c3dd0b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/312317fcea89/vmlinux-64c3dd0b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b5a79a1512f2/bzImage-64c3dd0b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a1fab9d8e5da048ac8a1@syzkaller.appspotmail.com

executing program
executing program
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810ef20400 (size 240):
  comm "softirq", pid 0, jiffies 4294950045 (age 43.240s)
  hex dump (first 32 bytes):
    e0 04 1d 0c 81 88 ff ff e0 04 1d 0c 81 88 ff ff  ................
    00 c0 2b 0b 81 88 ff ff 00 00 00 00 00 00 00 00  ..+.............
  backtrace:
    [<ffffffff838525db>] napi_skb_cache_get+0x6b/0x90 net/core/skbuff.c:258
    [<ffffffff83852615>] __napi_build_skb+0x15/0x50 net/core/skbuff.c:387
    [<ffffffff838529e9>] __napi_alloc_skb+0x129/0x260 net/core/skbuff.c:691
    [<ffffffff82a1e9df>] napi_alloc_skb include/linux/skbuff.h:3212 [inline]
    [<ffffffff82a1e9df>] page_to_skb+0x11f/0x770 drivers/net/virtio_net.c:499
    [<ffffffff82a21dee>] receive_mergeable drivers/net/virtio_net.c:1122 [inline]
    [<ffffffff82a21dee>] receive_buf+0x6ae/0x2d70 drivers/net/virtio_net.c:1261
    [<ffffffff82a246fe>] virtnet_receive drivers/net/virtio_net.c:1556 [inline]
    [<ffffffff82a246fe>] virtnet_poll+0x24e/0x6f0 drivers/net/virtio_net.c:1674
    [<ffffffff8388909d>] __napi_poll+0x3d/0x290 net/core/dev.c:6498
    [<ffffffff838898cc>] napi_poll net/core/dev.c:6565 [inline]
    [<ffffffff838898cc>] net_rx_action+0x3ac/0x490 net/core/dev.c:6676
    [<ffffffff84a000eb>] __do_softirq+0xeb/0x2ef kernel/softirq.c:571
    [<ffffffff8124c9b6>] invoke_softirq kernel/softirq.c:445 [inline]
    [<ffffffff8124c9b6>] __irq_exit_rcu+0xc6/0x110 kernel/softirq.c:650
    [<ffffffff84609b08>] common_interrupt+0xb8/0xd0 arch/x86/kernel/irq.c:240
    [<ffffffff84800c22>] asm_common_interrupt+0x22/0x40 arch/x86/include/asm/idtentry.h:640
    [<ffffffff84622dc9>] native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
    [<ffffffff84622dc9>] arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
    [<ffffffff84622dc9>] acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
    [<ffffffff84622dc9>] acpi_idle_do_entry+0xc9/0xe0 drivers/acpi/processor_idle.c:572
    [<ffffffff846232e0>] acpi_idle_enter+0x150/0x230 drivers/acpi/processor_idle.c:709
    [<ffffffff83432934>] cpuidle_enter_state+0xc4/0x740 drivers/cpuidle/cpuidle.c:239
    [<ffffffff83433009>] cpuidle_enter+0x29/0x40 drivers/cpuidle/cpuidle.c:356



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches

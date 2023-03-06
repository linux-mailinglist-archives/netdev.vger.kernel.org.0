Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677016ACBB1
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjCFR6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjCFR5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:57:45 -0500
Received: from mail-io1-xd48.google.com (mail-io1-xd48.google.com [IPv6:2607:f8b0:4864:20::d48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC016BDEA
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 09:57:10 -0800 (PST)
Received: by mail-io1-xd48.google.com with SMTP id w4-20020a5d9604000000b0074d326b26bcso5722610iol.9
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 09:57:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678125344;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lyLuNdgZ1IvpwYziHJ8KnGU0TWTg6VLKPOdKY3yDHYk=;
        b=wHgFfb+1030AaZmm3QiKakHYy15PrZl6QmvXvlRkUfBm378fELERCord4SJFDEuveY
         BEiboS3blUV8yP/x6mVLjEq5jCy/WUV+8ymCLSjM+P1tljh3JfUkphadkKYEiBaIf1cN
         +nr83Oak5inFov0xTiVoQCfVoVryxc49OMwhxZQ3Ip+TGp58K1zpjXPmnbwwoe4seLza
         MkW7JLAOLZMNrayRGCcpzZx/Yn01+V2rdEOeqIKOm+yT8/M6wDqbpAbx4rQmm9hK7nyJ
         f8LrhrVhbt4R7X/SoYckj5uy2PGxS0iBkvmNYF4pN2SBJO2EF/jwMYG3uKIoLhurMNG9
         LiMQ==
X-Gm-Message-State: AO0yUKVLI9WDFMWxCmEKNBBGI8se4kiHgFQg5/cAzOZ0/b6IPabEN4nU
        chlcNBHIH0NrpzujLgm6zmYm3uin7goo3FmUEPgXK0kFUEw7
X-Google-Smtp-Source: AK7set8KFJTyxCTNZhTBiF3/TszCh8aFERtmUIHcpPzNXesrtaqxZMXLGjFX+k+5RxzObIWIcTsa+JAYk6xqh6DpLfsIWJZgHaZx
MIME-Version: 1.0
X-Received: by 2002:a6b:6a0a:0:b0:745:b287:c281 with SMTP id
 x10-20020a6b6a0a000000b00745b287c281mr5639958iog.2.1678125344375; Mon, 06 Mar
 2023 09:55:44 -0800 (PST)
Date:   Mon, 06 Mar 2023 09:55:44 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000a4e2d05f63f011e@google.com>
Subject: [syzbot] [wireless?] KMSAN: uninit-value in ath9k_wmi_ctrl_rx
From:   syzbot <syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        kuba@kernel.org, kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com, toke@toke.dk
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    944070199c5e kmsan: add memsetXX tests
git tree:       https://github.com/google/kmsan.git master
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1269e302c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46c642641b9ef616
dashboard link: https://syzkaller.appspot.com/bug?extid=f2cb6e0ffdb961921e4d
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17592674c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10340838c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/055bbd57e905/disk-94407019.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/82472690bcfe/vmlinux-94407019.xz
kernel image: https://storage.googleapis.com/syzbot-assets/db3f379532ab/bzImage-94407019.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ath9k_wmi_ctrl_rx+0x2fd/0x530 drivers/net/wireless/ath/ath9k/wmi.c:227
 ath9k_wmi_ctrl_rx+0x2fd/0x530 drivers/net/wireless/ath/ath9k/wmi.c:227
 ath9k_htc_rx_msg+0x5a7/0xac0 drivers/net/wireless/ath/ath9k/htc_hst.c:479
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:653 [inline]
 ath9k_hif_usb_rx_cb+0x18fd/0x1ee0 drivers/net/wireless/ath/ath9k/hif_usb.c:686
 __usb_hcd_giveback_urb+0x521/0x750 drivers/usb/core/hcd.c:1671
 usb_hcd_giveback_urb+0x158/0x680 drivers/usb/core/hcd.c:1754
 dummy_timer+0xd4d/0x4cc0 drivers/usb/gadget/udc/dummy_hcd.c:1988
 call_timer_fn+0x45/0x4e0 kernel/time/timer.c:1700
 expire_timers kernel/time/timer.c:1751 [inline]
 __run_timers+0x861/0xf90 kernel/time/timer.c:2022
 run_timer_softirq+0x68/0xe0 kernel/time/timer.c:2035
 __do_softirq+0x1c9/0x7c5 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0xe5/0x220 kernel/softirq.c:650
 irq_exit_rcu+0x12/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x9e/0xc0 arch/x86/kernel/apic/apic.c:1107
 asm_sysvec_apic_timer_interrupt+0x1f/0x30 arch/x86/include/asm/idtentry.h:649
 native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
 arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
 acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
 acpi_idle_do_entry drivers/acpi/processor_idle.c:570 [inline]
 acpi_idle_enter+0x6d7/0x820 drivers/acpi/processor_idle.c:707
 cpuidle_enter_state+0x84d/0x1ae0 drivers/cpuidle/cpuidle.c:239
 cpuidle_enter+0x7f/0xf0 drivers/cpuidle/cpuidle.c:356
 call_cpuidle kernel/sched/idle.c:155 [inline]
 cpuidle_idle_call kernel/sched/idle.c:236 [inline]
 do_idle+0x5ee/0x7f0 kernel/sched/idle.c:303
 cpu_startup_entry+0x21/0x30 kernel/sched/idle.c:400
 rest_init+0x22e/0x2b0 init/main.c:732
 arch_call_rest_init+0x12/0x20 init/main.c:894
 start_kernel+0x951/0xb40 init/main.c:1148
 x86_64_start_reservations+0x2e/0x30 arch/x86/kernel/head64.c:556
 x86_64_start_kernel+0x118/0x120 arch/x86/kernel/head64.c:537
 secondary_startup_64_no_verify+0xcf/0xdb

Uninit was created at:
 slab_post_alloc_hook+0x12d/0xb60 mm/slab.h:766
 slab_alloc_node mm/slub.c:3452 [inline]
 __kmem_cache_alloc_node+0x518/0x920 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc_node_track_caller+0x118/0x3c0 mm/slab_common.c:988
 kmalloc_reserve net/core/skbuff.c:492 [inline]
 __alloc_skb+0x3b8/0x900 net/core/skbuff.c:565
 __netdev_alloc_skb+0x12f/0x7e0 net/core/skbuff.c:630
 __dev_alloc_skb include/linux/skbuff.h:3165 [inline]
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:635 [inline]
 ath9k_hif_usb_rx_cb+0xda6/0x1ee0 drivers/net/wireless/ath/ath9k/hif_usb.c:686
 __usb_hcd_giveback_urb+0x521/0x750 drivers/usb/core/hcd.c:1671
 usb_hcd_giveback_urb+0x158/0x680 drivers/usb/core/hcd.c:1754
 dummy_timer+0xd4d/0x4cc0 drivers/usb/gadget/udc/dummy_hcd.c:1988
 call_timer_fn+0x45/0x4e0 kernel/time/timer.c:1700
 expire_timers kernel/time/timer.c:1751 [inline]
 __run_timers+0x861/0xf90 kernel/time/timer.c:2022
 run_timer_softirq+0x68/0xe0 kernel/time/timer.c:2035
 __do_softirq+0x1c9/0x7c5 kernel/softirq.c:571

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.2.0-syzkaller-81157-g944070199c5e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches

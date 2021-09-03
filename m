Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8F33FFE9F
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhICLFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:05:16 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:50096 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbhICLFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 07:05:08 -0400
Received: by mail-io1-f72.google.com with SMTP id k6-20020a6b3c060000b0290568c2302268so3567091iob.16
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 04:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=mACFfA/R4884V66P0DIgp0k6RK7+ec6mdLQHsLBqKxo=;
        b=ON0Bg/GU9c7nf1HpBJkORHr3mugFjeBKy93Vf4xihgVLEbj+nQTZxYNf4yMQB7KXtk
         VPYjgiEX1CGqvAVIl1TX/Jh/A8cb1oP/s3LHzBg/g8OLEV9Ya+X1LgOrTqeqkJH1/loc
         uvAtD6TqTU0CyqDgckUBMXcCWBC1gNiTpWXfG4sca7aLscmKa0aMry8HAFBYrMZu/z7j
         l+P/zNGm2Wgopr6uTwcYaPHBjoyYZjd7e9iDDNfzqey+NIgdZuWMpkP5yEowq/b2jsQS
         IMzzwSxL0MP3+Mf4wJjIwlC591RkVP2JOx5E1EuLwNAO8Wz3hXlVryFau3+S0VZf5fsF
         4dYw==
X-Gm-Message-State: AOAM532phw0K6odjuQVipjECLimdn/xVXG950V2XYI6Z7meflO0U4ZEh
        bGouFM0Oy93+hmp+M7I4J9XY7lQbeP77M2Zx6jIJzDSpWp+m
X-Google-Smtp-Source: ABdhPJzeCi1CaBwy8MctIZAVAL60RcUkDZ9D2yjD/T4ucuOOvPZmd7BjteJLRMyBvK4lbxBrehqV19mXXoDv43GEHMrYJvMsyl4x
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b88:: with SMTP id h8mr2184451ili.237.1630667048687;
 Fri, 03 Sep 2021 04:04:08 -0700 (PDT)
Date:   Fri, 03 Sep 2021 04:04:08 -0700
In-Reply-To: <20210903042820.2733-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002f1da805cb154204@google.com>
Subject: Re: [syzbot] WARNING: refcount bug in qrtr_node_lookup
From:   syzbot <syzbot+c613e88b3093ebf3686e@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, dan.carpenter@oracle.com,
        eric.dumazet@gmail.com, hdanton@sina.com,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, paul@paul-moore.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
UBSAN: object-size-mismatch in wg_xmit

================================================================================
UBSAN: object-size-mismatch in ./include/linux/skbuff.h:2048:28
member access within address 0000000096a277f4 with insufficient space
for an object of type 'struct sk_buff'
CPU: 0 PID: 3568 Comm: kworker/0:5 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x15e/0x1d3 lib/dump_stack.c:105
 ubsan_epilogue lib/ubsan.c:151 [inline]
 handle_object_size_mismatch lib/ubsan.c:232 [inline]
 ubsan_type_mismatch_common+0x1de/0x390 lib/ubsan.c:245
 __ubsan_handle_type_mismatch_v1+0x41/0x50 lib/ubsan.c:274
 __skb_queue_before include/linux/skbuff.h:2048 [inline]
 __skb_queue_tail include/linux/skbuff.h:2081 [inline]
 wg_xmit+0x4da/0xa60 drivers/net/wireguard/device.c:182
 __netdev_start_xmit include/linux/netdevice.h:4970 [inline]
 netdev_start_xmit+0x7b/0x140 include/linux/netdevice.h:4984
 xmit_one net/core/dev.c:3576 [inline]
 dev_hard_start_xmit+0x182/0x2e0 net/core/dev.c:3592
 __dev_queue_xmit+0x13b0/0x21a0 net/core/dev.c:4202
 neigh_output include/net/neighbour.h:510 [inline]
 ip6_finish_output2+0xc51/0x11b0 net/ipv6/ip6_output.c:126
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ndisc_send_skb+0x835/0xcf0 net/ipv6/ndisc.c:508
 addrconf_dad_completed+0x6c5/0xa70 net/ipv6/addrconf.c:4203
 addrconf_dad_work+0xba5/0x1510 net/ipv6/addrconf.c:3970
 process_one_work+0x4b5/0x8d0 kernel/workqueue.c:2297
 worker_thread+0x686/0x9e0 kernel/workqueue.c:2444
 kthread+0x3ca/0x3f0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
================================================================================
================================================================================
UBSAN: object-size-mismatch in ./include/linux/skbuff.h:1941:2
member access within address 0000000096a277f4 with insufficient space
for an object of type 'struct sk_buff'
CPU: 0 PID: 3568 Comm: kworker/0:5 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x15e/0x1d3 lib/dump_stack.c:105
 ubsan_epilogue lib/ubsan.c:151 [inline]
 handle_object_size_mismatch lib/ubsan.c:232 [inline]
 ubsan_type_mismatch_common+0x1de/0x390 lib/ubsan.c:245
 __ubsan_handle_type_mismatch_v1+0x41/0x50 lib/ubsan.c:274
 __skb_insert include/linux/skbuff.h:1941 [inline]
 __skb_queue_before include/linux/skbuff.h:2048 [inline]
 __skb_queue_tail include/linux/skbuff.h:2081 [inline]
 wg_xmit+0x53c/0xa60 drivers/net/wireguard/device.c:182
 __netdev_start_xmit include/linux/netdevice.h:4970 [inline]
 netdev_start_xmit+0x7b/0x140 include/linux/netdevice.h:4984
 xmit_one net/core/dev.c:3576 [inline]
 dev_hard_start_xmit+0x182/0x2e0 net/core/dev.c:3592
 __dev_queue_xmit+0x13b0/0x21a0 net/core/dev.c:4202
 neigh_output include/net/neighbour.h:510 [inline]
 ip6_finish_output2+0xc51/0x11b0 net/ipv6/ip6_output.c:126
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ndisc_send_skb+0x835/0xcf0 net/ipv6/ndisc.c:508
 addrconf_dad_completed+0x6c5/0xa70 net/ipv6/addrconf.c:4203
 addrconf_dad_work+0xba5/0x1510 net/ipv6/addrconf.c:3970
 process_one_work+0x4b5/0x8d0 kernel/workqueue.c:2297
 worker_thread+0x686/0x9e0 kernel/workqueue.c:2444
 kthread+0x3ca/0x3f0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
================================================================================
IPv6: ADDRCONF(NETDEV_CHANGE): macsec0: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): macsec0: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): batadv_slave_0: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): veth0_to_batadv: link becomes ready


Tested on:

commit:         a9c9a6f7 Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=134c5b6d300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5f845e3d82a95a0e
dashboard link: https://syzkaller.appspot.com/bug?extid=c613e88b3093ebf3686e
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14673df5300000


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EFD3FE7AD
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 04:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243084AbhIBCdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 22:33:05 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:43747 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241129AbhIBCdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 22:33:04 -0400
Received: by mail-il1-f198.google.com with SMTP id q3-20020a056e0220e300b0022b19efba3eso187387ilv.10
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 19:32:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=iMgjhEIXG363Robpty/zAubC9gKdw0yuPvVKpIvyV+U=;
        b=LxupVmvrWOvy0dJ0oCsTEdLsdTQW+LHLwY/qc8lBvekLj7293QGcwe2zNUbJuvUivx
         lUZ81b27F98zRFn+w6OSFNN2vQ6WovgzMz758Df0e6vcGRe8r/O8tFx+s5oIO3o8kpW2
         0W2nhS4o0nFhTZ4qFuDQ/5m/7kJkGTB3ENXR0qeX8VyoGKlOPpRAaEuPXh2H+241QbsV
         eJ7z+PsQeC9KJNeTgnLaDf4H+b+EpTimE5qyI23H+NUvcSNdur9P9IJaLDKMY2X2WtHS
         nSa/mNYVcE4Fbvo7jg/4q8URV6lBxpDnXrX0X0PlsfFSWzpZ5eOg71jZWbCC/W151q1q
         1fGQ==
X-Gm-Message-State: AOAM532wLfONo6kcEiaY16FH6GNyePcutEgph/46NP/9P2p3AbvaQWgP
        1m5+BLNT3RZe3FFqZrpZkDzo39RiRX0R5Qr1PfcjFRB3OwZn
X-Google-Smtp-Source: ABdhPJxvDGJUc29K5n9X5X2RKG0CMgfYjLYRx4F6q7yMfemj81ZVDOVj0H5/ayqRp/oAZivCa2rTOyu/r17y/1GE+kgn52xCDrUg
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1905:: with SMTP id w5mr593163ilu.165.1630549926813;
 Wed, 01 Sep 2021 19:32:06 -0700 (PDT)
Date:   Wed, 01 Sep 2021 19:32:06 -0700
In-Reply-To: <20210902005238.2413-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002d262305caf9fdde@google.com>
Subject: Re: [syzbot] WARNING: refcount bug in qrtr_node_lookup
From:   syzbot <syzbot+c613e88b3093ebf3686e@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, dan.carpenter@oracle.com,
        eric.dumazet@gmail.com, hdanton@sina.com,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
UBSAN: object-size-mismatch in send4

================================================================================
UBSAN: object-size-mismatch in ./include/net/flow.h:197:33
member access within address 000000001597b753 with insufficient space
for an object of type 'struct flowi'
CPU: 1 PID: 231 Comm: kworker/u4:4 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-kex-wg0 wg_packet_handshake_send_worker
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x15e/0x1d3 lib/dump_stack.c:105
 ubsan_epilogue lib/ubsan.c:148 [inline]
 handle_object_size_mismatch lib/ubsan.c:229 [inline]
 ubsan_type_mismatch_common+0x1de/0x390 lib/ubsan.c:242
 __ubsan_handle_type_mismatch_v1+0x41/0x50 lib/ubsan.c:271
 flowi4_to_flowi_common include/net/flow.h:197 [inline]
 send4+0x39b/0xdd0 drivers/net/wireguard/socket.c:52
 wg_socket_send_skb_to_peer+0xc7/0x200 drivers/net/wireguard/socket.c:174
 wg_packet_send_handshake_initiation drivers/net/wireguard/send.c:40 [inline]
 wg_packet_handshake_send_worker+0x14a/0x190 drivers/net/wireguard/send.c:51
 process_one_work+0x471/0x840 kernel/workqueue.c:2276
 worker_thread+0x686/0x9e0 kernel/workqueue.c:2422
 kthread+0x3ca/0x3f0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
================================================================================
================================================================================
UBSAN: object-size-mismatch in ./include/net/flow.h:197:33
member access within address 000000001597b753 with insufficient space
for an object of type 'union (anonymous union at ./include/net/flow.h:172:2)'
CPU: 1 PID: 231 Comm: kworker/u4:4 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-kex-wg0 wg_packet_handshake_send_worker
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x15e/0x1d3 lib/dump_stack.c:105
 ubsan_epilogue lib/ubsan.c:148 [inline]
 handle_object_size_mismatch lib/ubsan.c:229 [inline]
 ubsan_type_mismatch_common+0x1de/0x390 lib/ubsan.c:242
 __ubsan_handle_type_mismatch_v1+0x41/0x50 lib/ubsan.c:271
 flowi4_to_flowi_common include/net/flow.h:197 [inline]
 send4+0x3aa/0xdd0 drivers/net/wireguard/socket.c:52
 wg_socket_send_skb_to_peer+0xc7/0x200 drivers/net/wireguard/socket.c:174
 wg_packet_send_handshake_initiation drivers/net/wireguard/send.c:40 [inline]
 wg_packet_handshake_send_worker+0x14a/0x190 drivers/net/wireguard/send.c:51
 process_one_work+0x471/0x840 kernel/workqueue.c:2276
 worker_thread+0x686/0x9e0 kernel/workqueue.c:2422
 kthread+0x3ca/0x3f0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
================================================================================


Tested on:

commit:         b91db6a0 Merge tag 'for-5.15/io_uring-vfs-2021-08-30' ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=11740133300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d1b73d0f1d597e4
dashboard link: https://syzkaller.appspot.com/bug?extid=c613e88b3093ebf3686e
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13a44435300000


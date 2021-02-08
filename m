Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC0E3139C1
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 17:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhBHQkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 11:40:39 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:40859 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbhBHQkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 11:40:13 -0500
Received: by mail-il1-f199.google.com with SMTP id j7so11032646ilu.7
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 08:39:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ize3cUt2pb9IhKkCaJSDnfPZVDhJE3GoGvtfb0mk/Qs=;
        b=MqSj0swiVt17aO4jaNxa0h5JIIJKAj3LPBEKTY9WlmIGB36YCiE+Fmkkn5fmhJXpt0
         Sg0dn1kI/R3T1VICtQVEzb5ExA0V1S8WgUAdYruxvdPTcqzlhhaWfXPmlc2w+W5IdiHI
         G6jF2fIwVIHZz2F0nX74LowPiZLe6oU/8isWfpsGQecPRydKq5XhpG5haIjT6TkWg+Y7
         i0ODbj2ATq+s7ca1gCfdleg4GoI8dqEh/Kvead+osm4Yw9W7RNmsIOMlq9o6SV7HcpPE
         juvA+9271FUqRYDsQverMRVuKG3kH5WMrvRn6dwIvINw81vNObE61i4rzjqGQKFn1DBB
         Fn9Q==
X-Gm-Message-State: AOAM532pISE4PXm7QkWZrOEsv1pPs3bq/PyR7/3Sr3FukuLk4MQFRbth
        bfHQkvhTK6MXlskKw8Jrcn9jly5/IkiF8U8e9u7PHi44i9da
X-Google-Smtp-Source: ABdhPJweN+L91U8svnPDkiNsUD+RWVWzrn4YtHpaXcZrpSaNqkbCyHCIVdKug/YOAB8m1jvL2UhiUmxNQCh3AgEjxEsXWfBIe6QW
MIME-Version: 1.0
X-Received: by 2002:a92:8e42:: with SMTP id k2mr17500938ilh.250.1612802370935;
 Mon, 08 Feb 2021 08:39:30 -0800 (PST)
Date:   Mon, 08 Feb 2021 08:39:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000069a2e905bad5d02e@google.com>
Subject: memory leak in virtio_transport_send_pkt_info
From:   syzbot <syzbot+24452624fc4c571eedd9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sgarzare@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9f29bd8b Merge tag 'fs_for_v5.11-rc5' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11e435af500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=162a0109d6ff731f
dashboard link: https://syzkaller.appspot.com/bug?extid=24452624fc4c571eedd9
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=135dd494d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=128787e7500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+24452624fc4c571eedd9@syzkaller.appspotmail.com

executing program
BUG: memory leak
unreferenced object 0xffff88811477d380 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 26.670s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d280 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 26.670s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d200 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 26.670s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d180 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 26.670s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d380 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.040s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d280 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.040s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d200 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.040s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d180 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.040s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d380 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.100s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d280 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.100s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d200 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.100s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d180 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.100s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d380 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.160s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d280 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.160s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d200 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.160s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d180 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.160s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d380 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.230s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d280 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.230s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d200 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.230s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d180 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.230s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d380 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.290s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d280 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.290s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d200 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.290s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811477d180 (size 96):
  comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.290s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
  backtrace:
    [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
    [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
    [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
    [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
    [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
    [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
    [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
    [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
    [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
    [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

executing program
executing program


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches

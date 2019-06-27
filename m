Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 134D657A55
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 05:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfF0D7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 23:59:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:42629 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfF0D7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 23:59:06 -0400
Received: by mail-io1-f72.google.com with SMTP id f22so1063780ioj.9
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 20:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8pgHqabBi5mSPkIjY3IFdmWwgOLpGvbNYudJhVT77dg=;
        b=sZHK3S99nMZ1Tob3JlGGtd3AETGUtBgoD0e5XzH/V1b1vI+EZz28SslNE1HoTXfM4M
         UDExF2Ym1ZoIvTVauKdV1a3Xv/k3qmrU0CeSetzufRvAHyQnJgxqWsU6RUxH0RaR7j73
         GfBKHntbBRw8VQK9CvMdZRHY+2iMZh2FYeY74JjG3LVddts1vNbav0haTGnLx4Jdqn64
         UFAYbW8ZnI3sB7sTqEh8PPon5xRlDA8TTqMOB40GeI/s+FH4k2gksgSzmciJpkgAOz/Y
         gh/Ky5FGg4ZoRx9EGCCR5ey+0kdycYOV6/Y2+tE2Qz+ZniIOnxf1Obqg7DzGkC1wgDcg
         o4sA==
X-Gm-Message-State: APjAAAWYm3teRLHD9Kv/aeIa9NuRm+PU9E5U/SUXv3zVG50A9VLkECN7
        gglqCEssGDo5Av+iRzhlaHt8oz1JOcbT688CG+0Nddv9J4LN
X-Google-Smtp-Source: APXvYqziDY8uW1NwdQdNbOR/D9XSY1H6HsU13mWuIWA8tK+8q++u1XBbkGq9/dA6tDiBVAmLFu9WscqUoIGbB5bYG3094fYQWbqu
MIME-Version: 1.0
X-Received: by 2002:a6b:6409:: with SMTP id t9mr2072174iog.270.1561607945273;
 Wed, 26 Jun 2019 20:59:05 -0700 (PDT)
Date:   Wed, 26 Jun 2019 20:59:05 -0700
In-Reply-To: <000000000000d028b30588fed102@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000db481c058c462e4c@google.com>
Subject: Re: KASAN: use-after-free Write in xfrm_hash_rebuild
From:   syzbot <syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    249155c2 Merge branch 'parisc-5.2-4' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f017c3a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a31528e58cc12e2
dashboard link: https://syzkaller.appspot.com/bug?extid=0165480d4ef07360eeda
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cf37c3a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __write_once_size  
include/linux/compiler.h:221 [inline]
BUG: KASAN: use-after-free in __hlist_del include/linux/list.h:748 [inline]
BUG: KASAN: use-after-free in hlist_del_rcu include/linux/rculist.h:455  
[inline]
BUG: KASAN: use-after-free in xfrm_hash_rebuild+0xa0d/0x1000  
net/xfrm/xfrm_policy.c:1318
Write of size 8 at addr ffff888095e79c00 by task kworker/1:3/8066

CPU: 1 PID: 8066 Comm: kworker/1:3 Not tainted 5.2.0-rc6+ #7
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events xfrm_hash_rebuild
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  print_address_description+0x6d/0x310 mm/kasan/report.c:188
  __kasan_report+0x14b/0x1c0 mm/kasan/report.c:317
  kasan_report+0x26/0x50 mm/kasan/common.c:614
  __asan_report_store8_noabort+0x17/0x20 mm/kasan/generic_report.c:137
  __write_once_size include/linux/compiler.h:221 [inline]
  __hlist_del include/linux/list.h:748 [inline]
  hlist_del_rcu include/linux/rculist.h:455 [inline]
  xfrm_hash_rebuild+0xa0d/0x1000 net/xfrm/xfrm_policy.c:1318
  process_one_work+0x814/0x1130 kernel/workqueue.c:2269
  worker_thread+0xc01/0x1640 kernel/workqueue.c:2415
  kthread+0x325/0x350 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 8064:
  save_stack mm/kasan/common.c:71 [inline]
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:489
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
  __do_kmalloc mm/slab.c:3660 [inline]
  __kmalloc+0x23c/0x310 mm/slab.c:3669
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:742 [inline]
  xfrm_hash_alloc+0x38/0xe0 net/xfrm/xfrm_hash.c:21
  xfrm_policy_init net/xfrm/xfrm_policy.c:4036 [inline]
  xfrm_net_init+0x269/0xd60 net/xfrm/xfrm_policy.c:4120
  ops_init+0x336/0x420 net/core/net_namespace.c:130
  setup_net+0x212/0x690 net/core/net_namespace.c:316
  copy_net_ns+0x224/0x380 net/core/net_namespace.c:439
  create_new_namespaces+0x4ec/0x700 kernel/nsproxy.c:103
  unshare_nsproxy_namespaces+0x12a/0x190 kernel/nsproxy.c:202
  ksys_unshare+0x540/0xac0 kernel/fork.c:2692
  __do_sys_unshare kernel/fork.c:2760 [inline]
  __se_sys_unshare kernel/fork.c:2758 [inline]
  __x64_sys_unshare+0x38/0x40 kernel/fork.c:2758
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 17:
  save_stack mm/kasan/common.c:71 [inline]
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x12a/0x1e0 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3432 [inline]
  kfree+0xae/0x120 mm/slab.c:3755
  xfrm_hash_free+0x38/0xd0 net/xfrm/xfrm_hash.c:35
  xfrm_bydst_resize net/xfrm/xfrm_policy.c:602 [inline]
  xfrm_hash_resize+0x13f1/0x1840 net/xfrm/xfrm_policy.c:680
  process_one_work+0x814/0x1130 kernel/workqueue.c:2269
  worker_thread+0xc01/0x1640 kernel/workqueue.c:2415
  kthread+0x325/0x350 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff888095e79c00
  which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
  64-byte region [ffff888095e79c00, ffff888095e79c40)
The buggy address belongs to the page:
page:ffffea0002579e40 refcount:1 mapcount:0 mapping:ffff8880aa400340  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002540888 ffffea0002907548 ffff8880aa400340
raw: 0000000000000000 ffff888095e79000 0000000100000020 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888095e79b00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
  ffff888095e79b80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> ffff888095e79c00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                    ^
  ffff888095e79c80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ffff888095e79d00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
==================================================================


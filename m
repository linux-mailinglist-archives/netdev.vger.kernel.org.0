Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038B44B081C
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237342AbiBJI1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:27:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237337AbiBJI1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:27:11 -0500
X-Greylist: delayed 895 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 00:27:12 PST
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37ECE109E;
        Thu, 10 Feb 2022 00:27:11 -0800 (PST)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 21A8BQTo004763;
        Thu, 10 Feb 2022 09:11:26 +0100
Date:   Thu, 10 Feb 2022 09:11:26 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     syzbot <syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bjorn.topel@gmail.com, bjorn.topel@intel.com, bjorn@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        fgheet255t@gmail.com, hawk@kernel.org, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        magnus.karlsson@intel.com, mudongliangabcd@gmail.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        yhs@fb.com
Subject: Re: [syzbot] WARNING: kmalloc bug in xdp_umem_create (2)
Message-ID: <20220210081125.GA4616@1wt.eu>
References: <000000000000a3571605d27817b5@google.com>
 <0000000000001f60ef05d7a3c6ad@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000001f60ef05d7a3c6ad@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,GB_FAKE_RF_SHORT,
        SORTED_RECIPS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 10:08:07PM -0800, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 7661809d493b426e979f39ab512e3adf41fbcc69
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Jul 14 16:45:49 2021 +0000
> 
>     mm: don't allow oversized kvmalloc() calls
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13bc74c2700000
> start commit:   f4bc5bbb5fef Merge tag 'nfsd-5.17-2' of git://git.kernel.o..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=107c74c2700000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17bc74c2700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5707221760c00a20
> dashboard link: https://syzkaller.appspot.com/bug?extid=11421fbbff99b989670e
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e514a4700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15fcdf8a700000
> 
> Reported-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com
> Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Interesting, so in fact syzkaller has shown that the aforementioned
patch does its job well and has spotted a call path by which a single
userland setsockopt() can request more than 2 GB allocation in the
kernel. Most likely that's in fact what needs to be addressed.

FWIW the call trace at the URL above is:

Call Trace:
 kvmalloc include/linux/mm.h:806 [inline]
 kvmalloc_array include/linux/mm.h:824 [inline]
 kvcalloc include/linux/mm.h:829 [inline]
 xdp_umem_pin_pages net/xdp/xdp_umem.c:102 [inline]
 xdp_umem_reg net/xdp/xdp_umem.c:219 [inline]
 xdp_umem_create+0x6a5/0xf00 net/xdp/xdp_umem.c:252
 xsk_setsockopt+0x604/0x790 net/xdp/xsk.c:1068
 __sys_setsockopt+0x1fd/0x4e0 net/socket.c:2176
 __do_sys_setsockopt net/socket.c:2187 [inline]
 __se_sys_setsockopt net/socket.c:2184 [inline]
 __x64_sys_setsockopt+0xb5/0x150 net/socket.c:2184
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

and the meaningful part of the repro is:

  syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
  syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
  syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
  intptr_t res = 0;
  res = syscall(__NR_socket, 0x2cul, 3ul, 0);
  if (res != -1)
    r[0] = res;
  *(uint64_t*)0x20000080 = 0;
  *(uint64_t*)0x20000088 = 0xfff02000000;
  *(uint32_t*)0x20000090 = 0x800;
  *(uint32_t*)0x20000094 = 0;
  *(uint32_t*)0x20000098 = 0;
  syscall(__NR_setsockopt, r[0], 0x11b, 4, 0x20000080ul, 0x20ul);

Willy

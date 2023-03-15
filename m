Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15C06BB3A2
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbjCOMw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbjCOMw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:52:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4D88569E;
        Wed, 15 Mar 2023 05:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678884772; x=1710420772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SUsnUofbnZ17R3vhZK0KxvR7Ggj2IlHgALrzBei3N10=;
  b=Bz6a9LT01vKKue9/zPqyv4ouuspG3D+BLkfKJC3mFmZTNTUXI8EckEeS
   N3By8lR2wnj6qr850vRdmEnzW79mmv3v+aI5LBbclIqX9KBgvGJ9fOtUt
   NO5WeRqRHqF2b0i8uZStK3DbAWEI+2sdW/6tX6cK2Opdax/a6Xa61WdmJ
   4YMusc6ebYjbatV31WQ05zZJF3MR5fV4WAcy/amuaKt+LGO3B3et8CQL4
   v1nBQZue1f+ESoef5EdmAYr9ZP6/AC8O2v85ZxBkqhDY6LDTiEUQ1T1ro
   uNdFsf730VPC35VZJZBjt36IXvkov9q0ZDxl1adhAc0uuJ5jfIpp8gll/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="318085855"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="318085855"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:52:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="925331748"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="925331748"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by fmsmga006.fm.intel.com with ESMTP; 15 Mar 2023 05:52:45 -0700
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     ast@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        syzbot <syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, hawk@kernel.org, john.fastabend@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bpf?] [net?] BUG: unable to handle kernel NULL pointer dereference in __build_skb_around
Date:   Wed, 15 Mar 2023 13:51:23 +0100
Message-Id: <ec94dad7-188b-96d8-9005-74f507d96967@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <6b48673b-33a2-877d-dadd-b43a1364b330@intel.com>
References: <000000000000f1985705f6ef2243@google.com> <6b48673b-33a2-877d-dadd-b43a1364b330@intel.com>
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <aleksander.lobakin@intel.com>
Date: Wed, 15 Mar 2023 13:10:44 +0100

> From: Syzbot <syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com>
> Date: Wed, 15 Mar 2023 05:03:47 -0700
> 
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    3c2611bac08a selftests/bpf: Fix trace_virtqueue_add_sgs te..
>> git tree:       bpf-next
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1026d472c80000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=cab35c936731a347
>> dashboard link: https://syzkaller.appspot.com/bug?extid=e1d1b65f7c32f2a86a9f
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15826bc6c80000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15cd12e2c80000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/36a32f4d222a/disk-3c2611ba.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/f5c0da04f143/vmlinux-3c2611ba.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/ae2ca9bce51a/bzImage-3c2611ba.xz
>>
>> The issue was bisected to:
>>
>> commit 9c94bbf9a87b264294f42e6cc0f76d87854733ec
>> Author: Alexander Lobakin <aleksander.lobakin@intel.com>
>> Date:   Mon Mar 13 21:55:52 2023 +0000
>>
>>     xdp: recycle Page Pool backed skbs built from XDP frames
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11deec2ac80000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13deec2ac80000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=15deec2ac80000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com
>> Fixes: 9c94bbf9a87b ("xdp: recycle Page Pool backed skbs built from XDP frames")
>>
>> BUG: kernel NULL pointer dereference, address: 0000000000000d28
>> #PF: supervisor write access in kernel mode
>> #PF: error_code(0x0002) - not-present page
>> PGD 7b741067 P4D 7b741067 PUD 7c1ca067 PMD 0 
>> Oops: 0002 [#1] PREEMPT SMP KASAN
>> CPU: 1 PID: 5080 Comm: syz-executor371 Not tainted 6.2.0-syzkaller-13030-g3c2611bac08a #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
>> RIP: 0010:memset_erms+0xd/0x20 arch/x86/lib/memset_64.S:66
>> Code: 01 48 0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f 00 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f
>> RSP: 0018:ffffc90003baf730 EFLAGS: 00010246
>> RAX: 0000000000000000 RBX: ffff888028b94000 RCX: 0000000000000020
>> RDX: 0000000000000020 RSI: 0000000000000000 RDI: 0000000000000d28
>> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000d28
>> R10: ffffed100517281c R11: 0000000000094001 R12: 0000000000000d48
>> R13: 0000000000000d28 R14: 0000000000000f68 R15: 0000000000000100
>> FS:  0000555555979300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000d28 CR3: 0000000028e2d000 CR4: 00000000003506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  <TASK>
>>  __finalize_skb_around net/core/skbuff.c:321 [inline]
>>  __build_skb_around+0x232/0x3a0 net/core/skbuff.c:379
>>  build_skb_around+0x32/0x290 net/core/skbuff.c:444
>>  __xdp_build_skb_from_frame+0x121/0x760 net/core/xdp.c:622
>>  xdp_recv_frames net/bpf/test_run.c:248 [inline]
>>  xdp_test_run_batch net/bpf/test_run.c:334 [inline]
>>  bpf_test_run_xdp_live+0x1289/0x1930 net/bpf/test_run.c:362
>>  bpf_prog_test_run_xdp+0xa05/0x14e0 net/bpf/test_run.c:1418
>>  bpf_prog_test_run kernel/bpf/syscall.c:3675 [inline]
>>  __sys_bpf+0x1598/0x5100 kernel/bpf/syscall.c:5028
>>  __do_sys_bpf kernel/bpf/syscall.c:5114 [inline]
>>  __se_sys_bpf kernel/bpf/syscall.c:5112 [inline]
>>  __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5112
>>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> RIP: 0033:0x7f320b4efca9
>> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007ffd2c9924d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f320b4efca9
>> RDX: 0000000000000048 RSI: 0000000020000080 RDI: 000000000000000a
>> RBP: 00007f320b4b3e50 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f320b4b3ee0
>> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>>  </TASK>
>> Modules linked in:
>> CR2: 0000000000000d28
>> ---[ end trace 0000000000000000 ]---
>> RIP: 0010:memset_erms+0xd/0x20 arch/x86/lib/memset_64.S:66
>> Code: 01 48 0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f 00 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f
>> RSP: 0018:ffffc90003baf730 EFLAGS: 00010246
>> RAX: 0000000000000000 RBX: ffff888028b94000 RCX: 0000000000000020
>> RDX: 0000000000000020 RSI: 0000000000000000 RDI: 0000000000000d28
>> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000d28
>> R10: ffffed100517281c R11: 0000000000094001 R12: 0000000000000d48
>> R13: 0000000000000d28 R14: 0000000000000f68 R15: 0000000000000100
>> FS:  0000555555979300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000d28 CR3: 0000000028e2d000 CR4: 00000000003506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> ----------------
>> Code disassembly (best guess), 1 bytes skipped:
>>    0:	48 0f af c6          	imul   %rsi,%rax
>>    4:	f3 48 ab             	rep stos %rax,%es:(%rdi)
>>    7:	89 d1                	mov    %edx,%ecx
>>    9:	f3 aa                	rep stos %al,%es:(%rdi)
>>    b:	4c 89 c8             	mov    %r9,%rax
>>    e:	c3                   	retq
>>    f:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
>>   16:	00 00 00 00
>>   1a:	66 90                	xchg   %ax,%ax
>>   1c:	66 0f 1f 00          	nopw   (%rax)
>>   20:	49 89 f9             	mov    %rdi,%r9
>>   23:	40 88 f0             	mov    %sil,%al
>>   26:	48 89 d1             	mov    %rdx,%rcx
>> * 29:	f3 aa                	rep stos %al,%es:(%rdi) <-- trapping instruction
> 
> Looks like skb_shinfo() returns %NULL inside __finalize_skb_around(). My
> code didn't touch this at all, but I'm digging this already anyway :s

Ok got it.
So previously, on %XDP_PASS a page was released from the Pool and then a
new one allocated and its context filled. Now, the page gets recycled,
and when it gets recycled, PP doesn't reinit its context. But
xdp_scrub_frame() sets xdpf->data to %NULL, which means the ctx needs to
be reinitialized. Plus the &xdp_frame itself is located in the place
which might easily get overwritten when skb is wandering around the stack.
I'm curious then how it's been working on my side for several weeks
already and I've been using XDP trafgen extensively :D
Thus, I'd change it like that (see below). It's in general unsafe to
assume &xdp_frame residing at the beginning of data_hard_start is still
valid after the frame was cruising around. But let's wait for Toke's
comment.

Also, please merge bpf into bpf-next. I see it doesn't contain my fix
for ctx->frame. This will add merge conflicts after this one is fixed
and also can provoke additional bugs.

> 
> + Toke, test_run author :p
> 
>>   2b:	4c 89 c8             	mov    %r9,%rax
>>   2e:	c3                   	retq
>>   2f:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
>>   36:	00 00 00 00
>>   3a:	66 90                	xchg   %ax,%ax
>>   3c:	66                   	data16
>>   3d:	0f                   	.byte 0xf
>>   3e:	1f                   	(bad)
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>> syzbot can test patches for this issue, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
> 
> Thanks,
> Olek

Thanks,
Olek
---
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 6a8b33a103a4..5b9ca36ff21d 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -217,12 +217,12 @@ static bool ctx_was_changed(struct xdp_page_head *head)
 
 static void reset_ctx(struct xdp_page_head *head)
 {
-	if (likely(!ctx_was_changed(head)))
-		return;
+	if (unlikely(!ctx_was_changed(head))) {
+		head->ctx.data = head->orig_ctx.data;
+		head->ctx.data_meta = head->orig_ctx.data_meta;
+		head->ctx.data_end = head->orig_ctx.data_end;
+	}
 
-	head->ctx.data = head->orig_ctx.data;
-	head->ctx.data_meta = head->orig_ctx.data_meta;
-	head->ctx.data_end = head->orig_ctx.data_end;
 	xdp_update_frame_from_buff(&head->ctx, &head->frm);
 }
 
---
Alternative version, which fixes only this particular problem, but is
less safe as still assumes only xdpf->data could be nulled-out. It can
save a bunch o'cycles on hotpath tho, thus attaching it as well:

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 6a8b33a103a4..55789772f039 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -217,13 +217,15 @@ static bool ctx_was_changed(struct xdp_page_head *head)
 
 static void reset_ctx(struct xdp_page_head *head)
 {
-	if (likely(!ctx_was_changed(head)))
-		return;
+	if (unlikely(ctx_was_changed(head))) {
+		head->ctx.data = head->orig_ctx.data;
+		head->ctx.data_meta = head->orig_ctx.data_meta;
+		head->ctx.data_end = head->orig_ctx.data_end;
+		head->frm.data = NULL;
+	}
 
-	head->ctx.data = head->orig_ctx.data;
-	head->ctx.data_meta = head->orig_ctx.data_meta;
-	head->ctx.data_end = head->orig_ctx.data_end;
-	xdp_update_frame_from_buff(&head->ctx, &head->frm);
+	if (head->frm.data != head->ctx.data)
+		xdp_update_frame_from_buff(&head->ctx, &head->frm);
 }
 
 static int xdp_recv_frames(struct xdp_frame **frames, int nframes,

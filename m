Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D96485C09
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 00:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245275AbiAEXGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 18:06:32 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:11236 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245258AbiAEXGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 18:06:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1641423992; x=1672959992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B0eTEfSTWCod+D6PqFwyOUCIH18Ves727UdNg73fEls=;
  b=TinVhU1EU7snumlRDKgeKnL/gfxI1CLJRf9JkkweLWu5xck8gptqgXW/
   oCtAh5LWgiL3W7/3AknsTHu6MIO7qyn44M4C7aBpkeKsUlOhb5OpsUNTS
   c3L4n6lxwC/JtSgxUTzfEEmC48smPliALBjxqPcldXJod/cjvNKoW1B3i
   4=;
X-IronPort-AV: E=Sophos;i="5.88,265,1635206400"; 
   d="scan'208";a="53006765"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-b168f70e.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 05 Jan 2022 23:06:32 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-b168f70e.us-west-2.amazon.com (Postfix) with ESMTPS id 07AB5430F6;
        Wed,  5 Jan 2022 23:06:31 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 5 Jan 2022 23:06:30 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.87) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 5 Jan 2022 23:06:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <alexei.starovoitov@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/6] bpf: af_unix: Use batching algorithm in bpf unix iter.
Date:   Thu, 6 Jan 2022 08:06:22 +0900
Message-ID: <20220105230622.69436-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAADnVQLFSQk4TJAs3wz2uzyJYVzcprOF4sRV=j3-BQKzEMoz1w@mail.gmail.com>
References: <CAADnVQLFSQk4TJAs3wz2uzyJYVzcprOF4sRV=j3-BQKzEMoz1w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.87]
X-ClientProxiedBy: EX13D20UWC001.ant.amazon.com (10.43.162.244) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 5 Jan 2022 14:22:38 -0800
> On Mon, Jan 3, 2022 at 5:33 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > The commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock")
> > introduces the batching algorithm to iterate TCP sockets with more
> > consistency.
> >
> > This patch uses the same algorithm to iterate AF_UNIX sockets.
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> 
> There is something wrong in this patch:
> 
> ./test_progs -t bpf_iter_setsockopt_unix
> [   14.993474] bpf_testmod: loading out-of-tree module taints kernel.
> [   15.068986]
> [   15.069203] =====================================
> [   15.069698] WARNING: bad unlock balance detected!
> [   15.070187] 5.16.0-rc7-01992-g15d8ab86952d #3780 Tainted: G           O
> [   15.070937] -------------------------------------
> [   15.071441] test_progs/1438 is trying to release lock
> (&unix_table_locks[i]) at:
> [   15.072209] [<ffffffff831b7ae9>] unix_next_socket+0x169/0x460
> [   15.072825] but there are no more locks to release!
> [   15.073329]
> [   15.073329] other info that might help us debug this:
> [   15.074004] 1 lock held by test_progs/1438:
> [   15.074441]  #0: ffff8881072c81c8 (&p->lock){+.+.}-{3:3}, at:
> bpf_seq_read+0x61/0xfa0
> [   15.075279]
> [   15.075279] stack backtrace:
> [   15.075744] CPU: 0 PID: 1438 Comm: test_progs Tainted: G
> O      5.16.0-rc7-01992-g15d8ab86952d #3780
> [   15.076792] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> [   15.077986] Call Trace:
> [   15.078250]  <TASK>
> [   15.078476]  dump_stack_lvl+0x44/0x57
> [   15.078873]  lock_release+0x48e/0x650
> [   15.079262]  ? unix_next_socket+0x169/0x460
> [   15.079712]  ? lock_downgrade+0x690/0x690
> [   15.080131]  ? lock_downgrade+0x690/0x690
> [   15.080559]  _raw_spin_unlock+0x17/0x40
> [   15.080979]  unix_next_socket+0x169/0x460
> [   15.081402]  ? bpf_iter_unix_seq_show+0x20b/0x270
> [   15.081898]  bpf_iter_unix_batch+0xf7/0x580
> [   15.082337]  ? trace_kmalloc_node+0x29/0xd0
> [   15.082786]  bpf_seq_read+0x4a1/0xfa0
> [   15.083176]  ? up_read+0x1a1/0x720
> [   15.083538]  vfs_read+0x128/0x4e0
> [   15.083902]  ksys_read+0xe7/0x1b0
> [   15.084253]  ? vfs_write+0x8b0/0x8b0
> [   15.084638]  do_syscall_64+0x34/0x80
> [   15.085016]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   15.085545] RIP: 0033:0x7f2c4a5ad8b2
> [   15.085931] Code: 97 20 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb
> b6 0f 1f 80 00 00 00 00 f3 0f 1e fa 8b 05 96 db 20 00 85 c0 75 12 31
> c0 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 41 54 49 89 d4 55
> 48 89
> [   15.087875] RSP: 002b:00007fff4c8c24b8 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000000
> [   15.088658] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2c4a5ad8b2
> [   15.089396] RDX: 0000000000000001 RSI: 00007fff4c8c24cb RDI: 000000000000000a
> [   15.090132] RBP: 00007fff4c8c2550 R08: 0000000000000000 R09: 00007fff4c8c2397
> [   15.090870] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000040d910
> [   15.091618] R13: 00007fff4c8c2750 R14: 0000000000000000 R15: 0000000000000000
> [   15.092403]  </TASK>
> 
> 
> I've applied patches 1 and 2 to bpf-next.

Thanks, I will take a look with lockdep enabled.

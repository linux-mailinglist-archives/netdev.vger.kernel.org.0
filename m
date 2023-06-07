Return-Path: <netdev+bounces-9085-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C07B67271D9
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 00:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C7BB2815CC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B49263B3F2;
	Wed,  7 Jun 2023 22:38:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54A83B3EF
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 22:38:24 +0000 (UTC)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B96193;
	Wed,  7 Jun 2023 15:38:18 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 6A3AF61CECE4;
	Thu,  8 Jun 2023 00:38:16 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 7aSg4m-kiHXL; Thu,  8 Jun 2023 00:38:15 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id BB16963CC111;
	Thu,  8 Jun 2023 00:38:15 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id faOU-Qb9u7kn; Thu,  8 Jun 2023 00:38:15 +0200 (CEST)
Received: from foxxylove.corp.sigma-star.at (unknown [82.150.214.1])
	by lithops.sigma-star.at (Postfix) with ESMTPSA id ED14E63CC10C;
	Thu,  8 Jun 2023 00:38:14 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: linux-hardening@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	keescook@chromium.org,
	Richard Weinberger <richard@nod.at>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [RFC PATCH 0/1] Integer overflows while scanning for integers
Date: Thu,  8 Jun 2023 00:37:54 +0200
Message-Id: <20230607223755.1610-1-richard@nod.at>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi!

Lately I wondered whether users of integer scanning functions check
for overflows.
To detect such overflows around scanf I came up with the following
patch. It simply triggers a WARN_ON_ONCE() upon an overflow.

After digging into various scanf users I found that the network device
naming code can trigger an overflow.

e.g:
$ ip link add 1 type veth peer name 9999999999
$ ip link set name "%d" dev 1

It will trigger the following WARN_ON_ONCE():
------------[ cut here ]------------
WARNING: CPU: 2 PID: 433 at lib/vsprintf.c:3701 vsscanf+0x6ce/0x990
Modules linked in:
CPU: 2 PID: 433 Comm: ip Not tainted 6.4.0-rc5-00025-g12c9a6293a89-dirty =
#27
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-=
g2dd4b9b-rebuilt.opensuse.org 04/01/2014
RIP: 0010:vsscanf+0x6ce/0x990
Code: 8d 28 ff ff ff 0f 0b e9 21 ff ff ff 48 83 ee 01 e9 4c ff ff ff 0f 0=
b e9 ad fe ff ff 0f 0b e9 a6 fe ff ff 0f 0b e9 03 ff ff ff <0f> 0b e9 13 =
fb ff ff 0f 0b e9 0c fb ff ff 0f 0b e9 ee fe ff ff e8
RSP: 0018:ffffabd4405c3680 EFLAGS: 00010206
RAX: 00000002540be3ff RBX: 0000000000000000 RCX: ffffa160052cefff
RDX: 0000000000000000 RSI: 000000000000000a RDI: ffffa15f852cf00a
RBP: ffffa15f852cf000 R08: 0000000000000009 R09: 00000002540be3ff
R10: 000000000000000a R11: 000000000000000a R12: ffffffff83f66c20
R13: ffffabd4405c36f8 R14: 00000000ffffffff R15: 0000000000000001
FS:  00007f9cf488f680(0000) GS:ffffa15fbbd00000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556cc48e0e90 CR3: 00000001085ae000 CR4: 00000000000006e0
Call Trace:
 <TASK>
 ? __warn+0x78/0x130
 ? vsscanf+0x6ce/0x990
 ? report_bug+0xf8/0x1e0
 ? handle_bug+0x3f/0x70
 ? exc_invalid_op+0x13/0x60
 ? asm_exc_invalid_op+0x16/0x20
 ? vsscanf+0x6ce/0x990
 sscanf+0x49/0x70
 dev_alloc_name_ns+0x140/0x230
 dev_change_name+0x8e/0x2e0
 ? skb_queue_tail+0x16/0x50
 do_setlink+0x29e/0x11a0
 ? rtnl_getlink+0x396/0x3d0
 ? __nla_validate_parse.part.7+0x52/0xd50
 __rtnl_newlink+0x496/0x8e0
 ? avc_has_perm_noaudit+0xaa/0x130
 ? __kmem_cache_alloc_node+0x36/0x180
 rtnl_newlink+0x3e/0x60
 rtnetlink_rcv_msg+0x13b/0x3b0
 ? rep_movs_alternative+0x33/0xd0
 ? __pfx_rtnetlink_rcv_msg+0x10/0x10
 netlink_rcv_skb+0x51/0x100
 netlink_unicast+0x1b6/0x280
 netlink_sendmsg+0x360/0x4c0
 sock_sendmsg+0x8d/0x90
 ____sys_sendmsg+0x1ea/0x260
 ___sys_sendmsg+0x83/0xd0
 ? folio_add_lru+0x29/0x50
 ? do_wp_page+0x7de/0xca0
 ? nfulnl_rcv_nl_event+0x2c/0xa0
 ? __inode_wait_for_writeback+0x7a/0xf0
 ? fsnotify_grab_connector+0x46/0x90
 ? fsnotify_destroy_marks+0x1f/0x150
 ? __call_rcu_common.constprop.85+0x92/0x360
 ? __sys_sendmsg+0x59/0xa0
 __sys_sendmsg+0x59/0xa0
 ? exit_to_user_mode_prepare+0x27/0x120
 do_syscall_64+0x3a/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f9cf3d72033
Code: 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 9=
0 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 =
ff ff 77 55 f3 c3 0f 1f 00 41 54 55 41 89 d4 53 48 89
RSP: 002b:00007ffe7d50a8e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000006480fe41 RCX: 00007f9cf3d72033
RDX: 0000000000000000 RSI: 00007ffe7d50a950 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000007
R10: 00007f9cf3c60468 R11: 0000000000000246 R12: 0000000000000001
R13: 0000556cc4897540 R14: 00007ffe7d50aa20 R15: 0000000000000005
 </TASK>
---[ end trace 0000000000000000 ]---

Underflowing is also possible:
$ ip link add 1 type veth peer name -9999999999
$ ip link set name "%d" dev 1

Luckily in __dev_alloc_name() the overflow is currently harmless because
the function uses sscanf() only to construct the inuse bitmap.
While the overflow will cause wrong bits set the selected interface
name is later explicitly checked for being available.
But who knows what happens when the code is changed in future, at least
to me it was not clear that there overflows can happen.

So I think as part of kernel hardening we should offer a way to detect
overflows in scanf.

Richard Weinberger (1):
  vsprintf: Warn on integer scanning overflows

 lib/vsprintf.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

--=20
2.35.3



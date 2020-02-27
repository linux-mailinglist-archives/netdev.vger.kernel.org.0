Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3119A170D1A
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 01:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgB0ASF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 19:18:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:63408 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgB0ASF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 19:18:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Feb 2020 16:18:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,490,1574150400"; 
   d="scan'208";a="438629982"
Received: from tvtrimel-mobl2.amr.corp.intel.com ([10.251.11.94])
  by fmsmga006.fm.intel.com with ESMTP; 26 Feb 2020 16:18:04 -0800
Date:   Wed, 26 Feb 2020 16:18:04 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@tvtrimel-mobl2.amr.corp.intel.com
To:     netdev@vger.kernel.org
Subject: Re: [PATCH net] mptcp: add dummy icsk_sync_mss()
In-Reply-To: <3b06c9fdc9d0e00a8a6eaef4dc08eeb9322be4a0.1582715453.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2002261613380.50710@tvtrimel-mobl2.amr.corp.intel.com>
References: <3b06c9fdc9d0e00a8a6eaef4dc08eeb9322be4a0.1582715453.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 26 Feb 2020, Paolo Abeni wrote:

> syzbot noted that the master MPTCP socket lacks the icsk_sync_mss
> callback, and was able to trigger a null pointer dereference:
>
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 8e171067 P4D 8e171067 PUD 93fa2067 PMD 0
> Oops: 0010 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 8984 Comm: syz-executor066 Not tainted 5.6.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:0x0
> Code: Bad RIP value.
> RSP: 0018:ffffc900020b7b80 EFLAGS: 00010246
> RAX: 1ffff110124ba600 RBX: 0000000000000000 RCX: ffff88809fefa600
> RDX: ffff8880994cdb18 RSI: 0000000000000000 RDI: ffff8880925d3140
> RBP: ffffc900020b7bd8 R08: ffffffff870225be R09: fffffbfff140652a
> R10: fffffbfff140652a R11: 0000000000000000 R12: ffff8880925d35d0
> R13: ffff8880925d3140 R14: dffffc0000000000 R15: 1ffff110124ba6ba
> FS:  0000000001a0b880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 00000000a6d6f000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> cipso_v4_sock_setattr+0x34b/0x470 net/ipv4/cipso_ipv4.c:1888
> netlbl_sock_setattr+0x2a7/0x310 net/netlabel/netlabel_kapi.c:989
> smack_netlabel security/smack/smack_lsm.c:2425 [inline]
> smack_inode_setsecurity+0x3da/0x4a0 security/smack/smack_lsm.c:2716
> security_inode_setsecurity+0xb2/0x140 security/security.c:1364
> __vfs_setxattr_noperm+0x16f/0x3e0 fs/xattr.c:197
> vfs_setxattr fs/xattr.c:224 [inline]
> setxattr+0x335/0x430 fs/xattr.c:451
> __do_sys_fsetxattr fs/xattr.c:506 [inline]
> __se_sys_fsetxattr+0x130/0x1b0 fs/xattr.c:495
> __x64_sys_fsetxattr+0xbf/0xd0 fs/xattr.c:495
> do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
> entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x440199
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffcadc19e48 EFLAGS: 00000246 ORIG_RAX: 00000000000000be
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440199
> RDX: 0000000020000200 RSI: 00000000200001c0 RDI: 0000000000000003
> RBP: 00000000006ca018 R08: 0000000000000003 R09: 00000000004002c8
> R10: 0000000000000009 R11: 0000000000000246 R12: 0000000000401a20
> R13: 0000000000401ab0 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> CR2: 0000000000000000
>
> Address the issue adding a dummy icsk_sync_mss callback.
> To properly sync the subflows mss and options list we need some
> additional infrastructure, which will land to net-next.
>
> Reported-by: syzbot+f4dfece964792d80b139@syzkaller.appspotmail.com
> Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel

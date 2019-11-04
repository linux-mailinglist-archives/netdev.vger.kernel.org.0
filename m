Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B825EE57A
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 18:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfKDRDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 12:03:09 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33025 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbfKDRDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 12:03:08 -0500
X-Originating-IP: 90.63.246.187
Received: from gandi.net (laubervilliers-658-1-215-187.w90-63.abo.wanadoo.fr [90.63.246.187])
        (Authenticated sender: thibaut.sautereau@clip-os.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 9FBF3E0011;
        Mon,  4 Nov 2019 17:03:03 +0000 (UTC)
Date:   Mon, 4 Nov 2019 18:03:03 +0100
From:   Thibaut Sautereau <thibaut.sautereau@clip-os.org>
To:     netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, clipos@ssi.gouv.fr
Subject: Double free of struct sk_buff reported by SLAB_CONSISTENCY_CHECKS
 with init_on_free
Message-ID: <20191104170303.GA50361@gandi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I ran into the following BUG on a 5.3.8 kernel:

	=============================================================================
	BUG skbuff_head_cache (Tainted: G                T): Object already free
	-----------------------------------------------------------------------------

	INFO: Slab 0x000000000d2d2f8f objects=16 used=3 fp=0x0000000064309071 flags=0x3fff00000000201
	BUG: kernel NULL pointer dereference, address: 0000000000000000
	#PF: supervisor read access in kernel mode
	#PF: error_code(0x0000) - not-present page
	PGD 0 P4D 0
	Oops: 0000 [#1] PREEMPT SMP PTI
	CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B           T 5.3.8 #1
	Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
	RIP: 0010:print_trailer+0x70/0x1d5
	Code: 28 4d 8b 4d 00 4d 8b 45 20 81 e2 ff 7f 00 00 e8 86 ce ef ff 8b 4b 20 48 89 ea 48 89 ee 4c 29 e2 48 c7 c7 90 6f d4 89 48 01 e9 <48> 33 09 48 33 8b 70 01 00 00 e8 61 ce ef ff f6 43 09 04 74 35 8b
	RSP: 0018:ffffbf7680003d58 EFLAGS: 00010046
	RAX: 000000000000005d RBX: ffffa3d2bb08e540 RCX: 0000000000000000
	RDX: 00005c2d8fdc2000 RSI: 0000000000000000 RDI: ffffffff89d46f90
	RBP: 0000000000000000 R08: 0000000000000242 R09: 000000000000006c
	R10: 0000000000000000 R11: 0000000000000030 R12: ffffa3d27023e000
	R13: fffff11080c08f80 R14: ffffa3d2bb047a80 R15: 0000000000000002
	FS:  0000000000000000(0000) GS:ffffa3d2be400000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	CR2: 0000000000000000 CR3: 000000007a6c4000 CR4: 00000000000006f0
	Call Trace:
	 <IRQ>
	 free_debug_processing.cold.37+0xc9/0x149
	 ? __kfree_skb_flush+0x30/0x40
	 ? __kfree_skb_flush+0x30/0x40
	 __slab_free+0x22a/0x3d0
	 ? tcp_wfree+0x2a/0x140
	 ? __sock_wfree+0x1b/0x30
	 kmem_cache_free_bulk+0x415/0x420
	 ? __kfree_skb_flush+0x30/0x40
	 __kfree_skb_flush+0x30/0x40
	 net_rx_action+0x2dd/0x480
	 __do_softirq+0xf0/0x246
	 irq_exit+0x93/0xb0
	 do_IRQ+0xa0/0x110
	 common_interrupt+0xf/0xf
	 </IRQ>
	RIP: 0010:default_idle+0x13/0x20
	Code: 24 28 eb 9e 4c 89 ff e8 eb 9f c9 ff eb 9f e8 84 03 8c ff 90 90 90 90 e8 2b 96 bc ff e9 07 00 00 00 0f 00 2d 01 71 41 00 fb f4 <e9> 18 96 bc ff 0f 1f 84 00 00 00 00 00 53 65 48 8b 1c 25 00 5d 01
	RSP: 0018:ffffffff89e03eb8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffd6
	RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
	RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff89d8fe58
	RBP: ffffffff89e85d78 R08: 00000000000d2730 R09: 0000000000000000
	R10: 0000000000000222 R11: 0000000000000000 R12: 0000000000000000
	R13: 0000000000000000 R14: ffffffff8a2ea920 R15: 000000007efbbd98
	 ? default_idle+0x5/0x20
	 do_idle+0x1ad/0x220
	 cpu_startup_entry+0x14/0x20
	 start_kernel+0x62f/0x66e
	 secondary_startup_64+0xa4/0xb0
	Modules linked in: [...]
	CR2: 0000000000000000
	---[ end trace 0d08341f1cb4ff43 ]---
	RIP: 0010:print_trailer+0x70/0x1d5
	Code: 28 4d 8b 4d 00 4d 8b 45 20 81 e2 ff 7f 00 00 e8 86 ce ef ff 8b 4b 20 48 89 ea 48 89 ee 4c 29 e2 48 c7 c7 90 6f d4 89 48 01 e9 <48> 33 09 48 33 8b 70 01 00 00 e8 61 ce ef ff f6 43 09 04 74 35 8b
	RSP: 0018:ffffbf7680003d58 EFLAGS: 00010046
	RAX: 000000000000005d RBX: ffffa3d2bb08e540 RCX: 0000000000000000
	RDX: 00005c2d8fdc2000 RSI: 0000000000000000 RDI: ffffffff89d46f90
	RBP: 0000000000000000 R08: 0000000000000242 R09: 000000000000006c
	R10: 0000000000000000 R11: 0000000000000030 R12: ffffa3d27023e000
	R13: fffff11080c08f80 R14: ffffa3d2bb047a80 R15: 0000000000000002
	FS:  0000000000000000(0000) GS:ffffa3d2be400000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	CR2: 0000000000000000 CR3: 000000007a6c4000 CR4: 00000000000006f0
	Kernel panic - not syncing: Fatal exception in interrupt
	Shutting down cpus with NMI
	Kernel Offset: 0x8000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
	---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

We first encountered this issue under huge network traffic (system image
download), and I was able to reproduce by simply sending a big packet
with `ping -s 65507 <ip>`, which crashes the kernel every single time.

The BUG only happens when using `slub_debug=F` on the command-line (to
enable SLAB_CONSISTENCY_CHECKS), otherwise the double free is not
reported and the system keeps running.

The code path is:
	net_rx_action
	  __kfree_skb_flush
		kmem_cache_free_bulk()  # skbuff_head_cache
		  slab_free()
			do_slab_free()
			  __slab_free()
				free_debug_processing()
				  free_consistency_check()
					object_err()    # "Object already free"
					  print_trailer()
						print_tracking()    # !(s->flags & SLAB_STORE_USER) => return;
						print_page_info()   # "INFO: Slab ..."
						pr_err("INFO: Object ...", ..., get_freepointer(s, p))
						  get_freepointer()
						    freelist_dereference() # NULL pointer dereference

Enabling KASAN shows less info because the NULL pointer dereference then
apparently happens before reaching free_debug_processing().

Bisection points to the following commit: 1b7e816fc80e ("mm: slub: Fix
slab walking for init_on_free"), and indeed the BUG is not triggered
when init_on_free is disabled.

-- 
Thibaut Sautereau
CLIP OS developer

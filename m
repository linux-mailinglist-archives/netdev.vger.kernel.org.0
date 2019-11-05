Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4BA9EFFD6
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 15:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389584AbfKEOc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 09:32:57 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:41273 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389110AbfKEOc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 09:32:57 -0500
X-Originating-IP: 90.63.246.187
Received: from gandi.net (laubervilliers-658-1-215-187.w90-63.abo.wanadoo.fr [90.63.246.187])
        (Authenticated sender: thibaut.sautereau@clip-os.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id D29E9240009;
        Tue,  5 Nov 2019 14:32:53 +0000 (UTC)
Date:   Tue, 5 Nov 2019 15:32:53 +0100
From:   Thibaut Sautereau <thibaut.sautereau@clip-os.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, clipos@ssi.gouv.fr
Subject: Re: Double free of struct sk_buff reported by
 SLAB_CONSISTENCY_CHECKS with init_on_free
Message-ID: <20191105143253.GB1006@gandi.net>
References: <20191104170303.GA50361@gandi.net>
 <23c73a23-8fd9-c462-902b-eec2a0c04d36@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <23c73a23-8fd9-c462-902b-eec2a0c04d36@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 10:00:39AM +0100, Vlastimil Babka wrote:
> On 11/4/19 6:03 PM, Thibaut Sautereau wrote:
> > The BUG only happens when using `slub_debug=F` on the command-line (to
> > enable SLAB_CONSISTENCY_CHECKS), otherwise the double free is not
> > reported and the system keeps running.
> 
> You could change slub_debug parameter to:
> slub_debug=FU,skbuff_head_cache
> 
> That will also print out who previously allocated and freed the double
> freed object. And limit all the tracking just to the affected cache.

Thanks, I did not know about that.

However, as kind of expected, I get a BUG due to a NULL pointer
dereference in print_track():

	=============================================================================
	BUG skbuff_head_cache (Tainted: G                T): Object already free
	-----------------------------------------------------------------------------

	BUG: kernel NULL pointer dereference, address: 00000000000000e0
	#PF: supervisor read access in kernel mode
	#PF: error_code(0x0000) - not-present page
	PGD 0 P4D 0 
	Oops: 0000 [#1] PREEMPT SMP PTI
	CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B           T 5.3.8 #1
	Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
	RIP: 0010:print_track+0xd/0x67
	Code: 24 20 89 ee 48 c7 c7 70 33 d5 8c 49 8b 4c 24 28 49 89 c0 e8 77 f2 ef ff 83 c5 01 eb b9 41 54 49 89 fc 55 48 89 d5 53 48 89 f3 <48> 8b 13 48 85 d2 74 4d 48 89 e9 44 8b 8b 8c 00 00 00 4c 89 e6 48
	RSP: 0018:ffff99d1c0003d18 EFLAGS: 00010002
	RAX: 0000000000000000 RBX: 00000000000000e0 RCX: 0000000000000000
	RDX: 00000000fffc0d26 RSI: 00000000000000e0 RDI: ffffffff8cd538a0
	RBP: 00000000fffc0d26 R08: 0000000000000240 R09: 0000000000000004
	R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff8cd538a0
	R13: ffffd1cd00c88700 R14: ffff93613e077e00 R15: 0000000000000002
	FS:  0000000000000000(0000) GS:ffff93613e600000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	CR2: 00000000000000e0 CR3: 00000000010c0000 CR4: 00000000000006f0
	Call Trace:
	 <IRQ>
	 print_tracking+0x38/0x6b
	 print_trailer+0x33/0x1d4
	 free_debug_processing.cold.38+0xc9/0x149
	 ? __kfree_skb_flush+0x30/0x40
	 ? __kfree_skb_flush+0x30/0x40
	 ? __kfree_skb_flush+0x30/0x40
	 __slab_free+0x22a/0x3d0
	 ? sock_wfree+0x5d/0x70
	 ? __kfree_skb_flush+0x30/0x40
	 kmem_cache_free_bulk+0x354/0x420
	 __kfree_skb_flush+0x30/0x40
	 net_rx_action+0x2be/0x460
	 __do_softirq+0xf3/0x249
	 irq_exit+0x93/0xb0
	 do_IRQ+0xa0/0x110
	 common_interrupt+0xf/0xf
	 </IRQ>
	RIP: 0010:default_idle+0x13/0x20
	Code: ff eb 9f e8 8f eb 8c ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 e8 0b 4b bd ff e9 07 00 00 00 0f 00 2d 21 5a 42 00 fb f4 <e9> f8 4a bd ff 0f 1f 84 00 00 00 00 00 53 65 48 8b 1c 25 00 5d 01
	RSP: 0018:ffffffff8d003eb8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffd6
	RAX: 0000000000000000 RBX: 0000000000000000 RCX: 7ffffff6501e23c1
	RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8cda0130
	RBP: ffffffff8d088438 R08: 0000000000000000 R09: 00000009b00fa2fe
	R10: 00000000000001fd R11: 0000000000000001 R12: 0000000000000000
	R13: 0000000000000000 R14: ffffffff8d502920 R15: 000000007efbbd98
	 ? default_idle+0x5/0x20
	 do_idle+0x1a8/0x220
	 cpu_startup_entry+0x14/0x20
	 start_kernel+0x615/0x654
	 secondary_startup_64+0xa4/0xb0
	Modules linked in: virtio_scsi virtio_net net_failover failover virtio_mmio virtio_input virtio_gpu virtio_crypto crypto_engine virtio_console virtio_balloon uhci_hcd uas usb_storage snd_hda_codec_generic snd_hda_codec snd_hda_core ledtrig_audio rtc_cmos qxl qemu_fw_cfg psmouse mousedev ehci_pci ehci_hcd button bochs_drm drm_vram_helper ttm virtio_rng
	CR2: 00000000000000e0
	---[ end trace 386b05c18ef99c32 ]---
	RIP: 0010:print_track+0xd/0x67
	Code: 24 20 89 ee 48 c7 c7 70 33 d5 8c 49 8b 4c 24 28 49 89 c0 e8 77 f2 ef ff 83 c5 01 eb b9 41 54 49 89 fc 55 48 89 d5 53 48 89 f3 <48> 8b 13 48 85 d2 74 4d 48 89 e9 44 8b 8b 8c 00 00 00 4c 89 e6 48
	RSP: 0018:ffff99d1c0003d18 EFLAGS: 00010002
	RAX: 0000000000000000 RBX: 00000000000000e0 RCX: 0000000000000000
	RDX: 00000000fffc0d26 RSI: 00000000000000e0 RDI: ffffffff8cd538a0
	RBP: 00000000fffc0d26 R08: 0000000000000240 R09: 0000000000000004
	R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff8cd538a0
	R13: ffffd1cd00c88700 R14: ffff93613e077e00 R15: 0000000000000002
	FS:  0000000000000000(0000) GS:ffff93613e600000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	CR2: 00000000000000e0 CR3: 00000000010c0000 CR4: 00000000000006f0
	Kernel panic - not syncing: Fatal exception in interrupt
	Shutting down cpus with NMI
	Kernel Offset: 0xb000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
	---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

I tried reverting 1b7e816fc80e ("mm: slub: Fix slab walking for
init_on_free") or disabling init_on_free, but then again I cannot
reproduce the bug and nothing is logged.

> 
> > The code path is:
> > 	net_rx_action
> > 	  __kfree_skb_flush
> > 		kmem_cache_free_bulk()  # skbuff_head_cache
> > 		  slab_free()
> > 			do_slab_free()
> > 			  __slab_free()
> > 				free_debug_processing()
> > 				  free_consistency_check()
> > 					object_err()    # "Object already free"
> > 					  print_trailer()
> > 						print_tracking()    # !(s->flags & SLAB_STORE_USER) => return;
> > 						print_page_info()   # "INFO: Slab ..."
> > 						pr_err("INFO: Object ...", ..., get_freepointer(s, p))
> > 						  get_freepointer()
> > 						    freelist_dereference() # NULL pointer dereference
> > 
> > Enabling KASAN shows less info because the NULL pointer dereference then
> > apparently happens before reaching free_debug_processing().
> > 
> > Bisection points to the following commit: 1b7e816fc80e ("mm: slub: Fix
> > slab walking for init_on_free"), and indeed the BUG is not triggered
> > when init_on_free is disabled.
> 
> That could be either buggy SLUB code, or the commit somehow exposed a
> real bug in skbuff users.

Right. At first I thought about some incompatibility between
init_on_free and SLAB_CONSISTENCY_CHECKS, but in that case why would it
only happen with skbuff_head_cache? On the other hand, if it's a bug in
skbuff users, why is the on_freelist() check in free_consistency_check()
not detecting anything when init_on_free is disabled? 

-- 
Thibaut Sautereau
CLIP OS developer

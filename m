Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98412CAA08
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 18:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390341AbgLARoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 12:44:18 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:57792 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389109AbgLARoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 12:44:18 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4ClqFr4Nghz9txgX;
        Tue,  1 Dec 2020 18:43:28 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 6ojkic6WN5Yc; Tue,  1 Dec 2020 18:43:28 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4ClqFr3XPmz9txgW;
        Tue,  1 Dec 2020 18:43:28 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 33F2C8B7B7;
        Tue,  1 Dec 2020 18:43:30 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id V9BBQeITFvFa; Tue,  1 Dec 2020 18:43:30 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 7ED1C8B7C6;
        Tue,  1 Dec 2020 18:43:29 +0100 (CET)
Subject: Re: powerpc32: BUG: KASAN: use-after-free in
 test_bpf_init+0x6f8/0xde8 [test_bpf]
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <ccdc2bc3-ce71-1faa-c83f-cd3b0eaf963d@csgroup.eu>
Message-ID: <baadc4fe-54b9-e629-a22f-3ce936d31d32@csgroup.eu>
Date:   Tue, 1 Dec 2020 18:43:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <ccdc2bc3-ce71-1faa-c83f-cd3b0eaf963d@csgroup.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 01/12/2020 à 15:03, Christophe Leroy a écrit :
> I've got the following KASAN error while running test_bpf module on a powerpc 8xx (32 bits).
> 
> That's reproductible, happens each time at the same test.
> 
> Can someone help me to investigate and fix that ?
> 
> [  209.381037] test_bpf: #298 LD_IND byte frag

Without KASAN, this test and a few others fail:

[12493.832074] test_bpf: #298 LD_IND byte frag jited:1 ret 201 != 66 FAIL (1 times)
[12493.844921] test_bpf: #299 LD_IND halfword frag jited:1 ret 51509 != 17220 FAIL (1 times)
[12493.869990] test_bpf: #301 LD_IND halfword mixed head/frag jited:1 ret 51509 != 1305 FAIL (1 times)
[12493.897298] test_bpf: #303 LD_ABS byte frag jited:1 ret 201 != 66 FAIL (1 times)
[12493.911351] test_bpf: #304 LD_ABS halfword frag jited:1 ret 51509 != 17220 FAIL (1 times)
[12493.933244] test_bpf: #306 LD_ABS halfword mixed head/frag jited:1 ret 51509 != 1305 FAIL (1 times)
[12494.471983] test_bpf: Summary: 371 PASSED, 7 FAILED, [119/366 JIT'ed]

Christophe


> [  209.383041] Pass 1: shrink = 0, seen = 0x30000
> [  209.383284] Pass 2: shrink = 0, seen = 0x30000
> [  209.383562] flen=3 proglen=104 pass=3 image=8166dc91 from=modprobe pid=380
> [  209.383805] JIT code: 00000000: 7c 08 02 a6 90 01 00 04 91 c1 ff b8 91 e1 ff bc
> [  209.384044] JIT code: 00000010: 94 21 ff 70 80 e3 00 58 81 e3 00 54 7d e7 78 50
> [  209.384279] JIT code: 00000020: 81 c3 00 a0 38 a0 00 00 38 80 00 00 38 a0 00 40
> [  209.384516] JIT code: 00000030: 3c e0 c0 02 60 e7 62 14 7c e8 03 a6 38 c5 00 00
> [  209.384753] JIT code: 00000040: 4e 80 00 21 41 80 00 0c 60 00 00 00 7c 83 23 78
> [  209.384990] JIT code: 00000050: 38 21 00 90 80 01 00 04 7c 08 03 a6 81 c1 ff b8
> [  209.385207] JIT code: 00000060: 81 e1 ff bc 4e 80 00 20
> [  209.385442] jited:1
> [  209.385762] ==================================================================
> [  209.386272] BUG: KASAN: use-after-free in test_bpf_init+0x6f8/0xde8 [test_bpf]
> [  209.386503] Read of size 4 at addr c2de70c0 by task modprobe/380
> [  209.386622]
> [  209.386881] CPU: 0 PID: 380 Comm: modprobe Not tainted 5.10.0-rc5-s3k-dev-01341-g72d20eec3f8b #4178
> [  209.387032] Call Trace:
> [  209.387404] [cad6b878] [c020e0d4] print_address_description.constprop.0+0x70/0x4e0 (unreliable)
> [  209.387920] [cad6b8f8] [c020dc98] kasan_report+0x118/0x1c0
> [  209.388503] [cad6b938] [cb0e0c98] test_bpf_init+0x6f8/0xde8 [test_bpf]
> [  209.388918] [cad6ba58] [c0004084] do_one_initcall+0xa4/0x33c
> [  209.389377] [cad6bb28] [c00f9144] do_init_module+0x158/0x7f4
> [  209.389820] [cad6bbc8] [c00fccb0] load_module+0x3394/0x38d8
> [  209.390273] [cad6be38] [c00fd4e0] sys_finit_module+0x118/0x17c
> [  209.390700] [cad6bf38] [c00170d0] ret_from_syscall+0x0/0x34
> [  209.391020] --- interrupt: c01 at 0xfd5e7c0
> [  209.395301]
> [  209.395472] Allocated by task 276:
> [  209.395767]  __kasan_kmalloc.constprop.0+0xe8/0x134
> [  209.396029]  kmem_cache_alloc+0x150/0x290
> [  209.396281]  __alloc_skb+0x58/0x28c
> [  209.396563]  alloc_skb_with_frags+0x74/0x314
> [  209.396872]  sock_alloc_send_pskb+0x404/0x424
> [  209.397205]  unix_dgram_sendmsg+0x200/0xbf0
> [  209.397473]  __sys_sendto+0x17c/0x21c
> [  209.397754]  ret_from_syscall+0x0/0x34
> [  209.397877]
> [  209.398039] Freed by task 274:
> [  209.398308]  kasan_set_track+0x34/0x6c
> [  209.398608]  kasan_set_free_info+0x28/0x48
> [  209.398878]  __kasan_slab_free+0x10c/0x19c
> [  209.399141]  kmem_cache_free+0x68/0x390
> [  209.399433]  skb_free_datagram+0x20/0x8c
> [  209.399759]  unix_dgram_recvmsg+0x474/0x710
> [  209.400084]  sock_read_iter+0x17c/0x228
> [  209.400348]  vfs_read+0x3c8/0x4f4
> [  209.400603]  ksys_read+0x17c/0x1cc
> [  209.400878]  ret_from_syscall+0x0/0x34
> [  209.401001]
> [  209.401222] The buggy address belongs to the object at c2de70c0
> [  209.401222]  which belongs to the cache skbuff_head_cache of size 176
> [  209.401462] The buggy address is located 0 bytes inside of
> [  209.401462]  176-byte region [c2de70c0, c2de7170)
> [  209.401604] The buggy address belongs to the page:
> [  209.401867] page:464e6411 refcount:1 mapcount:0 mapping:00000000 index:0x0 pfn:0xb79
> [  209.402080] flags: 0x200(slab)
> [  209.402477] raw: 00000200 00000100 00000122 c2004a90 00000000 00440088 ffffffff 00000001
> [  209.402646] page dumped because: kasan: bad access detected
> [  209.402765]
> [  209.402897] Memory state around the buggy address:
> [  209.403142]  c2de6f80: fb fb fc fc fc fc fc fc fc fc fa fb fb fb fb fb
> [  209.403388]  c2de7000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  209.403639] >c2de7080: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
> [  209.403798]                                    ^
> [  209.404048]  c2de7100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
> [  209.404304]  c2de7180: fc fc fc fc fc fc fa fb fb fb fb fb fb fb fb fb
> [  209.404456] ==================================================================
> [  209.404591] Disabling lock debugging due to kernel taint
> 
> 
> Thanks
> Christophe

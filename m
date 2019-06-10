Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5312A3BF74
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390080AbfFJWZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388328AbfFJWZ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 18:25:28 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B3BB20859;
        Mon, 10 Jun 2019 22:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560205526;
        bh=uQYpGPOMH2kyXx/WRPJM1aIq9nzGgwH9vntVZmd3Wsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tbXh1+6k5pdfMN84Jrc+KnP6+Q+svuFi1bWN93V7oj5wvEHeZ3Fn98079pW2kP21u
         OKa31wHHHmUxADudbS2i6nUl3L2zTEZKhpwZTgNf91ylOLhVGRjkpfB4ly/UhMvGNA
         TPZKekB9b9kCoY01T0OzluILcDhdjTCkxIGVvb70=
Date:   Mon, 10 Jun 2019 15:25:25 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Dave Watson <davejwatson@fb.com>
Cc:     Alexander Potapenko <glider@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: [net/tls] Re: KMSAN: uninit-value in gf128mul_4k_lle (3)
Message-ID: <20190610222524.GS63833@gmail.com>
References: <000000000000bf2457057b5ccda3@google.com>
 <CAKv+Gu8nZhmFhSy_FJLA2HkO4O56N3BdowNKmBcmCRoH+iNx+A@mail.gmail.com>
 <CAG_fn=UGCoDk04tL2vB981JmXgo6+-RUPmrTa3dSsK5UbZaTjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=UGCoDk04tL2vB981JmXgo6+-RUPmrTa3dSsK5UbZaTjA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This TLS bug is still present.  See more recent report here:
https://syzkaller.appspot.com/text?tag=CrashReport&x=10613446a00000

On Wed, Nov 28, 2018 at 11:58:37AM +0100, 'Alexander Potapenko' via syzkaller-bugs wrote:
> On Sat, Nov 24, 2018 at 12:02 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > (+ TLS maintainers)
> 
> This bug is also reproducible without KMSAN: if we fill the newly
> allocated skb fragment with "AAAA" (see the patch below) we can see
> these bytes being passed into the crypto functions.
> Note that KMSAN enables CONFIG_GENERIC_CSUM, so one might need
> something along the lines of
> https://github.com/google/kmsan/commit/fffec98ae2a605a3b8a6b3518e3d61d66c1bfd0a
> to reproduce this.
> 
> =======================================
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index 2545c5f89c4c..654b3e9877a5 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -1005,6 +1005,25 @@ void __crypto_xor(u8 *dst, const u8 *src1,
> const u8 *src2, unsigned int len)
>  {
>         int relalign = 0;
> 
> +       char saved;
> +       char *s1 = (char*)src1, *s2 = (char*)src2;
> +       if (len) {
> +               saved = s1[len-1];
> +               s1[len-1] = 0;
> +               if (strstr(s1, "AAAA"))
> +                       pr_err("src1: %s\n", s1);
> +               s1[len-1] = saved;
> +       }
> +       if (len) {
> +               saved = s2[len-1];
> +               s2[len-1] = 0;
> +               if (strstr(s2, "AAAA")) {
> +                       pr_err("src2: %s\n", s2);
> +                       if (s1 == s2)
> +                               pr_err("s1 == s2\n");
> +               }
> +               s2[len-1] = saved;
> +       }
>         if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
>                 int size = sizeof(unsigned long);
>                 int d = (((unsigned long)dst ^ (unsigned long)src1) |
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 080a880a1761..83f15668c3e8 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2216,6 +2216,7 @@ bool skb_page_frag_refill(unsigned int sz,
> struct page_frag *pfrag, gfp_t gfp)
>                                           SKB_FRAG_PAGE_ORDER);
>                 if (likely(pfrag->page)) {
>                         pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
> +                       memset(page_address(pfrag->page), 'A', pfrag->size);
>                         return true;
>                 }
>         }
> 
> The bug itself seems to be a data race, it only worked for me with the
> multithreaded C reproducer that collided the syscalls.
> > On Fri, 23 Nov 2018 at 23:51, syzbot
> > <syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    cddc52641fd2 kmsan: use __memmove() in fixup_bad_iret()
> > > git tree:       https://github.com/google/kmsan.git/master
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=111c426d400000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=e2808e34f8becb71
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=f8495bff23a879a6d0bd
> > > compiler:       clang version 8.0.0 (trunk 343298)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c0326d400000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e4d45d400000
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> > >
> > > Local variable description: ----walk@crypto_ctr_crypt
> > > Variable was created at:
> > >   crypto_ctr_crypt+0xae/0xc30 crypto/ctr.c:129
> > >   skcipher_crypt_blkcipher crypto/skcipher.c:622 [inline]
> > >   skcipher_encrypt_blkcipher+0x232/0x340 crypto/skcipher.c:631
> > > ==================================================================
> > > BUG: KMSAN: uninit-value in gf128mul_4k_lle+0x29e/0x310
> > > crypto/gf128mul.c:391
> > > CPU: 0 PID: 8470 Comm: syz-executor696 Not tainted 4.20.0-rc2+ #88
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > Google 01/01/2011
> > > Call Trace:
> > >   __dump_stack lib/dump_stack.c:77 [inline]
> > >   dump_stack+0x32d/0x480 lib/dump_stack.c:113
> > >   kmsan_report+0x19f/0x300 mm/kmsan/kmsan.c:911
> > >   __msan_warning+0x76/0xc0 mm/kmsan/kmsan_instr.c:415
> > >   gf128mul_4k_lle+0x29e/0x310 crypto/gf128mul.c:391
> > >   ghash_update+0x9d3/0x10e0 crypto/ghash-generic.c:75
> > >   crypto_shash_update crypto/shash.c:103 [inline]
> > >   shash_ahash_update+0x4de/0x600 crypto/shash.c:244
> > >   shash_async_update+0x50/0x60 crypto/shash.c:252
> > >   crypto_ahash_update include/crypto/hash.h:557 [inline]
> > >   gcm_hash_update crypto/gcm.c:235 [inline]
> > >   gcm_hash_assoc_remain_continue crypto/gcm.c:344 [inline]
> > >   gcm_hash_assoc_continue crypto/gcm.c:375 [inline]
> > >   gcm_hash_init_continue crypto/gcm.c:400 [inline]
> > >   gcm_hash+0x1dbe/0x4870 crypto/gcm.c:430
> > >   gcm_encrypt_continue crypto/gcm.c:455 [inline]
> > >   crypto_gcm_encrypt+0x781/0xaa0 crypto/gcm.c:484
> > >   crypto_aead_encrypt include/crypto/aead.h:364 [inline]
> > >   tls_do_encryption net/tls/tls_sw.c:460 [inline]
> > >   tls_push_record+0x2545/0x4290 net/tls/tls_sw.c:657
> > >   bpf_exec_tx_verdict+0x16c0/0x1b40 net/tls/tls_sw.c:694
> > >   tls_sw_sendmsg+0x136d/0x2a30 net/tls/tls_sw.c:949
> > >   inet_sendmsg+0x4e9/0x800 net/ipv4/af_inet.c:798
> > >   sock_sendmsg_nosec net/socket.c:621 [inline]
> > >   sock_sendmsg net/socket.c:631 [inline]
> > >   __sys_sendto+0x940/0xb80 net/socket.c:1788
> > >   __do_sys_sendto net/socket.c:1800 [inline]
> > >   __se_sys_sendto+0x107/0x130 net/socket.c:1796
> > >   __x64_sys_sendto+0x6e/0x90 net/socket.c:1796
> > >   do_syscall_64+0xcf/0x110 arch/x86/entry/common.c:291
> > >   entry_SYSCALL_64_after_hwframe+0x63/0xe7
> > > RIP: 0033:0x448509
> > > Code: e8 fc e5 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7
> > > 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> > > ff 0f 83 0b 01 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> > > RSP: 002b:00007f9ff6aa3cd8 EFLAGS: 00000216 ORIG_RAX: 000000000000002c
> > > RAX: ffffffffffffffda RBX: 00000000006f0038 RCX: 0000000000448509
> > > RDX: 000000000039a191 RSI: 00000000200005c0 RDI: 0000000000000003
> > > RBP: 00000000006f0030 R08: 0000000020000000 R09: 000000000000001c
> > > R10: 0000000000000000 R11: 0000000000000216 R12: 00000000006f003c
> > > R13: 00000000007ffc6f R14: 00007f9ff6aa49c0 R15: 00000000000003e8
> > >
> > > Uninit was stored to memory at:
> > >   kmsan_save_stack_with_flags mm/kmsan/kmsan.c:252 [inline]
> > >   kmsan_save_stack mm/kmsan/kmsan.c:267 [inline]
> > >   kmsan_internal_chain_origin+0x136/0x240 mm/kmsan/kmsan.c:569
> > >   __msan_chain_origin+0x6d/0xb0 mm/kmsan/kmsan_instr.c:292
> > >   __crypto_xor+0x224/0x15c0 crypto/algapi.c:1029
> > >   crypto_xor include/crypto/algapi.h:219 [inline]
> > >   ghash_update+0x991/0x10e0 crypto/ghash-generic.c:74
> > >   crypto_shash_update crypto/shash.c:103 [inline]
> > >   shash_ahash_update+0x4de/0x600 crypto/shash.c:244
> > >   shash_async_update+0x50/0x60 crypto/shash.c:252
> > >   crypto_ahash_update include/crypto/hash.h:557 [inline]
> > >   gcm_hash_update crypto/gcm.c:235 [inline]
> > >   gcm_hash_assoc_remain_continue crypto/gcm.c:344 [inline]
> > >   gcm_hash_assoc_continue crypto/gcm.c:375 [inline]
> > >   gcm_hash_init_continue crypto/gcm.c:400 [inline]
> > >   gcm_hash+0x1dbe/0x4870 crypto/gcm.c:430
> > >   gcm_encrypt_continue crypto/gcm.c:455 [inline]
> > >   crypto_gcm_encrypt+0x781/0xaa0 crypto/gcm.c:484
> > >   crypto_aead_encrypt include/crypto/aead.h:364 [inline]
> > >   tls_do_encryption net/tls/tls_sw.c:460 [inline]
> > >   tls_push_record+0x2545/0x4290 net/tls/tls_sw.c:657
> > >   bpf_exec_tx_verdict+0x16c0/0x1b40 net/tls/tls_sw.c:694
> > >   tls_sw_sendmsg+0x136d/0x2a30 net/tls/tls_sw.c:949
> > >   inet_sendmsg+0x4e9/0x800 net/ipv4/af_inet.c:798
> > >   sock_sendmsg_nosec net/socket.c:621 [inline]
> > >   sock_sendmsg net/socket.c:631 [inline]
> > >   __sys_sendto+0x940/0xb80 net/socket.c:1788
> > >   __do_sys_sendto net/socket.c:1800 [inline]
> > >   __se_sys_sendto+0x107/0x130 net/socket.c:1796
> > >   __x64_sys_sendto+0x6e/0x90 net/socket.c:1796
> > >   do_syscall_64+0xcf/0x110 arch/x86/entry/common.c:291
> > >   entry_SYSCALL_64_after_hwframe+0x63/0xe7
> > >
> > > Uninit was stored to memory at:
> > >   kmsan_save_stack_with_flags mm/kmsan/kmsan.c:252 [inline]
> > >   kmsan_save_stack mm/kmsan/kmsan.c:267 [inline]
> > >   kmsan_internal_chain_origin+0x136/0x240 mm/kmsan/kmsan.c:569
> > >   __msan_chain_origin+0x6d/0xb0 mm/kmsan/kmsan_instr.c:292
> > >   __crypto_xor+0x224/0x15c0 crypto/algapi.c:1029
> > >   crypto_xor include/crypto/algapi.h:219 [inline]
> > >   crypto_ctr_crypt_inplace crypto/ctr.c:115 [inline]
> > >   crypto_ctr_crypt+0x776/0xc30 crypto/ctr.c:142
> > >   skcipher_crypt_blkcipher crypto/skcipher.c:622 [inline]
> > >   skcipher_encrypt_blkcipher+0x232/0x340 crypto/skcipher.c:631
> > >   crypto_skcipher_encrypt include/crypto/skcipher.h:534 [inline]
> > >   crypto_gcm_encrypt+0x512/0xaa0 crypto/gcm.c:483
> > >   crypto_aead_encrypt include/crypto/aead.h:364 [inline]
> > >   tls_do_encryption net/tls/tls_sw.c:460 [inline]
> > >   tls_push_record+0x2545/0x4290 net/tls/tls_sw.c:657
> > >   bpf_exec_tx_verdict+0x16c0/0x1b40 net/tls/tls_sw.c:694
> > >   tls_sw_sendmsg+0x136d/0x2a30 net/tls/tls_sw.c:949
> > >   inet_sendmsg+0x4e9/0x800 net/ipv4/af_inet.c:798
> > >   sock_sendmsg_nosec net/socket.c:621 [inline]
> > >   sock_sendmsg net/socket.c:631 [inline]
> > >   __sys_sendto+0x940/0xb80 net/socket.c:1788
> > >   __do_sys_sendto net/socket.c:1800 [inline]
> > >   __se_sys_sendto+0x107/0x130 net/socket.c:1796
> > >   __x64_sys_sendto+0x6e/0x90 net/socket.c:1796
> > >   do_syscall_64+0xcf/0x110 arch/x86/entry/common.c:291
> > >   entry_SYSCALL_64_after_hwframe+0x63/0xe7
> > >
> > > Uninit was created at:
> > >   kmsan_save_stack_with_flags mm/kmsan/kmsan.c:252 [inline]
> > >   kmsan_internal_alloc_meta_for_pages+0x155/0x740 mm/kmsan/kmsan.c:689
> > >   kmsan_alloc_page+0x77/0xc0 mm/kmsan/kmsan_hooks.c:320
> > >   __alloc_pages_nodemask+0x12ac/0x64d0 mm/page_alloc.c:4421
> > >   alloc_pages_current+0x55d/0x7d0 mm/mempolicy.c:2080
> > >   alloc_pages include/linux/gfp.h:511 [inline]
> > >   skb_page_frag_refill+0x48e/0x7a0 net/core/sock.c:2213
> > >   sk_page_frag_refill+0xa4/0x330 net/core/sock.c:2233
> > >   sk_msg_alloc+0x22f/0x11a0 net/core/skmsg.c:37
> > >   tls_alloc_encrypted_msg net/tls/tls_sw.c:236 [inline]
> > >   tls_sw_sendmsg+0xd0c/0x2a30 net/tls/tls_sw.c:871
> > >   inet_sendmsg+0x4e9/0x800 net/ipv4/af_inet.c:798
> > >   sock_sendmsg_nosec net/socket.c:621 [inline]
> > >   sock_sendmsg net/socket.c:631 [inline]
> > >   __sys_sendto+0x940/0xb80 net/socket.c:1788
> > >   __do_sys_sendto net/socket.c:1800 [inline]
> > >   __se_sys_sendto+0x107/0x130 net/socket.c:1796
> > >   __x64_sys_sendto+0x6e/0x90 net/socket.c:1796
> > >   do_syscall_64+0xcf/0x110 arch/x86/entry/common.c:291
> > >   entry_SYSCALL_64_after_hwframe+0x63/0xe7
> > > ==================================================================
> > >
> > >
> > > ---
> > > This bug is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > > syzbot will keep track of this bug report. See:
> > > https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> > > syzbot.
> > > syzbot can test patches for this bug, for details see:
> > > https://goo.gl/tpsmEJ#testing-patches

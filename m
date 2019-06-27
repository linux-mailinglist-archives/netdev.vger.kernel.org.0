Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F8458788
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfF0Qqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbfF0Qqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 12:46:31 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10B28208E3;
        Thu, 27 Jun 2019 16:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561653989;
        bh=9TJaoG+cF3efcTMZdlr5R5j+Er/dwFJt54fTVviXPvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z6rh590anyEdtxst126PmejSGUO2LdcNxhX8AG+w7tsb+uklPXooZBaEFlDPnhZ7r
         ugCk5wnlceRaOtHuoBZVYZeHdcnqNb/upura0uvGkbG9jR1U3/C3JZe9FsEjAPfseO
         YTn1xqsJuu+giCVOeVqQ94rFbOJvDFIQRlCCbBTU=
Date:   Thu, 27 Jun 2019 09:46:27 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Dave Watson <davejwatson@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, glider@google.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com>
Subject: [net/tls] Re: KMSAN: uninit-value in aesti_encrypt
Message-ID: <20190627164627.GF686@sol.localdomain>
References: <000000000000a97a15058c50c52e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000a97a15058c50c52e@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+TLS maintainers]

Very likely a net/tls bug, not a crypto bug.

Possibly a duplicate of other reports such as "KMSAN: uninit-value in gf128mul_4k_lle (3)"

See https://lore.kernel.org/netdev/20190625055019.GD17703@sol.localdomain/ for
the list of 17 other open syzbot bugs I've assigned to the TLS subsystem.  TLS
maintainers, when are you planning to look into these?

On Thu, Jun 27, 2019 at 09:37:05AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    3351e2b9 usb-fuzzer: main usb gadget fuzzer driver
> git tree:       kmsan
> console output: https://syzkaller.appspot.com/x/log.txt?x=135d0c06a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=40511ad0c5945201
> dashboard link: https://syzkaller.appspot.com/bug?extid=6f50c99e8f6194bf363f
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1534241aa00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KMSAN: uninit-value in subshift crypto/aes_ti.c:148 [inline]
> BUG: KMSAN: uninit-value in aesti_encrypt+0x1238/0x1bc0 crypto/aes_ti.c:292
> CPU: 1 PID: 11187 Comm: syz-executor.2 Not tainted 5.2.0-rc4+ #5
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan.c:611
>  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:304
>  subshift crypto/aes_ti.c:148 [inline]
>  aesti_encrypt+0x1238/0x1bc0 crypto/aes_ti.c:292
>  crypto_cipher_encrypt_one include/linux/crypto.h:1753 [inline]
>  crypto_cbcmac_digest_update+0x3cf/0x550 crypto/ccm.c:871
>  crypto_shash_update crypto/shash.c:107 [inline]
>  shash_ahash_finup+0x659/0xb20 crypto/shash.c:276
>  shash_async_finup+0xbb/0x110 crypto/shash.c:291
>  crypto_ahash_op+0x1cd/0x6e0 crypto/ahash.c:368
>  crypto_ahash_finup+0x8c/0xb0 crypto/ahash.c:393
>  crypto_ccm_auth+0x14b2/0x1570 crypto/ccm.c:230
>  crypto_ccm_encrypt+0x272/0x8d0 crypto/ccm.c:309
>  crypto_aead_encrypt include/crypto/aead.h:331 [inline]
>  tls_do_encryption net/tls/tls_sw.c:521 [inline]
>  tls_push_record+0x341a/0x4f70 net/tls/tls_sw.c:730
>  bpf_exec_tx_verdict+0x1454/0x1c90 net/tls/tls_sw.c:770
>  tls_sw_sendmsg+0x15bd/0x2740 net/tls/tls_sw.c:1033
>  inet_sendmsg+0x48e/0x750 net/ipv4/af_inet.c:798
>  sock_sendmsg_nosec net/socket.c:646 [inline]
>  sock_sendmsg net/socket.c:665 [inline]
>  __sys_sendto+0x905/0xb90 net/socket.c:1958
>  __do_sys_sendto net/socket.c:1970 [inline]
>  __se_sys_sendto+0x107/0x130 net/socket.c:1966
>  __x64_sys_sendto+0x6e/0x90 net/socket.c:1966
>  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:302
>  entry_SYSCALL_64_after_hwframe+0x63/0xe7
> RIP: 0033:0x4592c9
> Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff
> 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f01788fdc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 00000000004592c9
> RDX: ffffffffffffff7f RSI: 00000000200005c0 RDI: 0000000000000003
> RBP: 000000000075c070 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f01788fe6d4
> R13: 00000000004c707f R14: 00000000004dc260 R15: 00000000ffffffff
> 
> Uninit was stored to memory at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:201 [inline]
>  kmsan_save_stack mm/kmsan/kmsan.c:213 [inline]
>  kmsan_internal_chain_origin+0xcc/0x150 mm/kmsan/kmsan.c:414
>  __msan_chain_origin+0x6b/0xe0 mm/kmsan/kmsan_instr.c:200
>  __crypto_xor+0x1e8/0x1470 crypto/algapi.c:1019
>  crypto_xor include/crypto/algapi.h:214 [inline]
>  crypto_cbcmac_digest_update+0x2ba/0x550 crypto/ccm.c:865
>  crypto_shash_update crypto/shash.c:107 [inline]
>  shash_ahash_finup+0x659/0xb20 crypto/shash.c:276
>  shash_async_finup+0xbb/0x110 crypto/shash.c:291
>  crypto_ahash_op+0x1cd/0x6e0 crypto/ahash.c:368
>  crypto_ahash_finup+0x8c/0xb0 crypto/ahash.c:393
>  crypto_ccm_auth+0x14b2/0x1570 crypto/ccm.c:230
>  crypto_ccm_encrypt+0x272/0x8d0 crypto/ccm.c:309
>  crypto_aead_encrypt include/crypto/aead.h:331 [inline]
>  tls_do_encryption net/tls/tls_sw.c:521 [inline]
>  tls_push_record+0x341a/0x4f70 net/tls/tls_sw.c:730
>  bpf_exec_tx_verdict+0x1454/0x1c90 net/tls/tls_sw.c:770
>  tls_sw_sendmsg+0x15bd/0x2740 net/tls/tls_sw.c:1033
>  inet_sendmsg+0x48e/0x750 net/ipv4/af_inet.c:798
>  sock_sendmsg_nosec net/socket.c:646 [inline]
>  sock_sendmsg net/socket.c:665 [inline]
>  __sys_sendto+0x905/0xb90 net/socket.c:1958
>  __do_sys_sendto net/socket.c:1970 [inline]
>  __se_sys_sendto+0x107/0x130 net/socket.c:1966
>  __x64_sys_sendto+0x6e/0x90 net/socket.c:1966
>  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:302
>  entry_SYSCALL_64_after_hwframe+0x63/0xe7
> 
> Uninit was created at:
>  kmsan_save_stack_with_flags+0x37/0x70 mm/kmsan/kmsan.c:201
>  kmsan_internal_alloc_meta_for_pages+0x123/0x510 mm/kmsan/kmsan_hooks.c:102
>  kmsan_alloc_page+0x7a/0xf0 mm/kmsan/kmsan_hooks.c:246
>  __alloc_pages_nodemask+0x144d/0x6020 mm/page_alloc.c:4700
>  alloc_pages_current+0x6a0/0x9b0 mm/mempolicy.c:2132
>  alloc_pages include/linux/gfp.h:511 [inline]
>  skb_page_frag_refill+0x15e/0x560 net/core/sock.c:2349
>  sk_page_frag_refill+0xa4/0x330 net/core/sock.c:2369
>  sk_msg_alloc+0x203/0x1050 net/core/skmsg.c:37
>  tls_alloc_encrypted_msg net/tls/tls_sw.c:284 [inline]
>  tls_sw_sendmsg+0xb6a/0x2740 net/tls/tls_sw.c:953
>  inet_sendmsg+0x48e/0x750 net/ipv4/af_inet.c:798
>  sock_sendmsg_nosec net/socket.c:646 [inline]
>  sock_sendmsg net/socket.c:665 [inline]
>  __sys_sendto+0x905/0xb90 net/socket.c:1958
>  __do_sys_sendto net/socket.c:1970 [inline]
>  __se_sys_sendto+0x107/0x130 net/socket.c:1966
>  __x64_sys_sendto+0x6e/0x90 net/socket.c:1966
>  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:302
>  entry_SYSCALL_64_after_hwframe+0x63/0xe7
> ==================================================================
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000a97a15058c50c52e%40google.com.
> For more options, visit https://groups.google.com/d/optout.

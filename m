Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62C51B5494
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 08:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgDWGKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 02:10:15 -0400
Received: from terminus.zytor.com ([198.137.202.136]:38869 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgDWGKO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 02:10:14 -0400
Received: from [IPv6:2601:646:8600:3281:2dc6:4436:b0b:d574] ([IPv6:2601:646:8600:3281:2dc6:4436:b0b:d574])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 03N68l0t1936638
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 22 Apr 2020 23:08:49 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 03N68l0t1936638
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020032201; t=1587622131;
        bh=qcwWHmAYuKK9NDnuYiBmOsdGFELE+uhJI1KsTVUwtAk=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=rexKojhVR8+sBYcf0j09kqGZjlyvJ6k58iw6qKKQ2hWBt5XhlZxW8zeT73wGXKSHz
         P9ZF24INPir9d/LsnmcLPa6f/rXDrIK9rYTgVzw7f0GsQF3us+vnCXlesWTCdKMQGx
         8KrFKl0sd4icdkcqU/WE/vefxLO/loPbhdPeFE5fCo65Y7bS629SFA93hkHCitkxL9
         CrKR55OBy6SwUlirswJ7SuHyRaRuLSR/WL9qp5NTqDx2or6l+pQezb73w2IAkEuAHN
         7BJ5BxIbbJGMJgOpjIer8u20haIZdwyxxgHhQgiYGkM/YrS7sk/0ACRumPP2kcpmdH
         dQNhpCbn0+3Ag==
Date:   Wed, 22 Apr 2020 23:08:40 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <20200422173630.8351-1-luke.r.nels@gmail.com>
References: <20200422173630.8351-1-luke.r.nels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH bpf v2 1/2] bpf, x86_32: Fix incorrect encoding in BPF_LDX zero-extension
To:     Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org
CC:     Brian Gerst <brgerst@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Wang YanQing <udknight@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   hpa@zytor.com
Message-ID: <57BB877E-685A-4FC8-945C-3E1F30CF5926@zytor.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On April 22, 2020 10:36:29 AM PDT, Luke Nelson <lukenels@cs=2Ewashington=2E=
edu> wrote:
>The current JIT uses the following sequence to zero-extend into the
>upper 32 bits of the destination register for BPF_LDX BPF_{B,H,W},
>when the destination register is not on the stack:
>
>  EMIT3(0xC7, add_1reg(0xC0, dst_hi), 0);
>
>The problem is that C7 /0 encodes a MOV instruction that requires a
>4-byte
>immediate; the current code emits only 1 byte of the immediate=2E This
>means that the first 3 bytes of the next instruction will be treated as
>the rest of the immediate, breaking the stream of instructions=2E
>
>This patch fixes the problem by instead emitting "xor dst_hi,dst_hi"
>to clear the upper 32 bits=2E This fixes the problem and is more
>efficient
>than using MOV to load a zero immediate=2E
>
>This bug may not be currently triggerable as BPF_REG_AX is the only
>register not stored on the stack and the verifier uses it in a limited
>way, and the verifier implements a zero-extension optimization=2E But the
>JIT should avoid emitting incorrect encodings regardless=2E
>
>Fixes: 03f5781be2c7b ("bpf, x86_32: add eBPF JIT compiler for ia32")
>Signed-off-by: Xi Wang <xi=2Ewang@gmail=2Ecom>
>Signed-off-by: Luke Nelson <luke=2Er=2Enels@gmail=2Ecom>
>---
>v1 -> v2: Updated commit message to better reflect the bug=2E
>          (H=2E Peter Anvin and Brian Gerst)
>---
> arch/x86/net/bpf_jit_comp32=2Ec | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/net/bpf_jit_comp32=2Ec
>b/arch/x86/net/bpf_jit_comp32=2Ec
>index 4d2a7a764602=2E=2Ecc9ad3892ea6 100644
>--- a/arch/x86/net/bpf_jit_comp32=2Ec
>+++ b/arch/x86/net/bpf_jit_comp32=2Ec
>@@ -1854,7 +1854,9 @@ static int do_jit(struct bpf_prog *bpf_prog, int
>*addrs, u8 *image,
> 					      STACK_VAR(dst_hi));
> 					EMIT(0x0, 4);
> 				} else {
>-					EMIT3(0xC7, add_1reg(0xC0, dst_hi), 0);
>+					/* xor dst_hi,dst_hi */
>+					EMIT2(0x33,
>+					      add_2reg(0xC0, dst_hi, dst_hi));
> 				}
> 				break;
> 			case BPF_DW:

Reviewed-by: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E

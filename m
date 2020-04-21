Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572CE1B2E79
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgDURkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:40:19 -0400
Received: from terminus.zytor.com ([198.137.202.136]:57271 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgDURkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 13:40:19 -0400
Received: from hanvin-mobl2.amr.corp.intel.com (jfdmzpr05-ext.jf.intel.com [134.134.139.74])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 03LHd4SZ1367462
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Tue, 21 Apr 2020 10:39:05 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 03LHd4SZ1367462
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020032201; t=1587490748;
        bh=2eEU+EJFQOujIVEE8U93Ltuhe2VZbe2J6MQcshNq8Gc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FRu+zW3aT1xB/O9RhVPpuaCU1a00em4UZGRUXlpI8adUD4oxWt3N3O4gQSAs8ktqX
         GMSwtqLpOpUyQd7tnA4svUvQNn++7WjDPRDzbPX0iCvp1MTB07sv/vM7ljC7UfIo+5
         ixGBAYj0t1brz5FO9eL9cICHKXvbiywjDXllHcD+y7iEsxcD73eNW5XpUlysWujhUY
         thY8dgONC2pH3wDnNTFlBxeSzrJaLF/PbAOpKrNJleFbRpMX+XzWnTRwwaCqy7a0KX
         UwUd3BqQ8mAWhzckyRBmQJKdsx/8PLZZ/OOaTE2xN0bRv/YbVdsKDZZuZqPg4z0lZ8
         4tr7BuUBIzp8Q==
Subject: Re: [PATCH bpf 1/2] bpf, x32: Fix invalid instruction in BPF_LDX
 zero-extension
To:     Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
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
References: <20200421171552.28393-1-luke.r.nels@gmail.com>
From:   "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <6f1130b3-eaea-cc5e-716f-5d6be77101b9@zytor.com>
Date:   Tue, 21 Apr 2020 10:39:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200421171552.28393-1-luke.r.nels@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-21 10:15, Luke Nelson wrote:
> The current JIT uses the following sequence to zero-extend into the
> upper 32 bits of the destination register for BPF_LDX BPF_{B,H,W},
> when the destination register is not on the stack:
> 
>   EMIT3(0xC7, add_1reg(0xC0, dst_hi), 0);
> 
> However, this is not a valid instruction on x86.
> 
> This patch fixes the problem by instead emitting "xor dst_hi,dst_hi"
> to clear the upper 32 bits.

x32 is not x86-32.  In Linux we generally call the latter "i386".

C7 /0 imm32 is a valid instruction on i386. However, it is also
inefficient when the destination is a register, because B8+r imm32 is
equivalent, and when the value is zero, XOR is indeed more efficient.

The real error is using EMIT3() instead of EMIT2_off32(), but XOR is
more efficient. However, let's make the bug statement *correct*, or it
is going to confuse the Hades out of people in the future.

	-hpa

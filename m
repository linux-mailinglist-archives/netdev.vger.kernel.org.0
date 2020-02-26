Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01841701B9
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 15:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgBZO7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 09:59:49 -0500
Received: from www62.your-server.de ([213.133.104.62]:58464 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgBZO7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 09:59:48 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j6yA5-0005YR-VF; Wed, 26 Feb 2020 15:59:46 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j6yA5-000WjF-JX; Wed, 26 Feb 2020 15:59:45 +0100
Subject: Re: selftests/bpf: arm64: test_verifier 13 "FAIL retval 65507 != -29
 (run 1/1)"
To:     Paolo Pisati <paolo.pisati@canonical.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
References: <20200226134458.GA65282@harukaze>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3707ef0b-010e-52b8-aff9-720d6a5e60ec@iogearbox.net>
Date:   Wed, 26 Feb 2020 15:59:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200226134458.GA65282@harukaze>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25734/Tue Feb 25 15:06:17 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/20 2:44 PM, Paolo Pisati wrote:
> This particular selftest fails on arm64 (x86-64 is fine):
> 
> $ sudo ./tools/testing/selftests/bpf/test_verifier -v 13
> #13/p valid read map access into a read-only array 2 , verifier log:
> 0: (7a) *(u64 *)(r10 -8) = 0
> 1: (bf) r2 = r10
> 2: (07) r2 += -8
> 3: (18) r1 = 0xffff00becd0d8c00
> 5: (85) call bpf_map_lookup_elem#1
> 6: (15) if r0 == 0x0 goto pc+6
>   R0_w=map_value(id=0,off=0,ks=4,vs=48,imm=0) R10=fp0 fp-8_w=mmmmmmmm
> 7: (bf) r1 = r0
> 8: (b7) r2 = 4
> 9: (b7) r3 = 0
> 10: (b7) r4 = 0
> 11: (b7) r5 = 0
> 12: (85) call bpf_csum_diff#28
>   R0_w=map_value(id=0,off=0,ks=4,vs=48,imm=0)
> R1_w=map_value(id=0,off=0,ks=4,vs=48,imm=0) R2_w=inv4 R3_w=inv0 R4_w=inv0
> R5_w=inv0 R10=fp0 fp-8_w=mmmmmmmm
> last_idx 12 first_idx 0
> regs=4 stack=0 before 11: (b7) r5 = 0
> regs=4 stack=0 before 10: (b7) r4 = 0
> regs=4 stack=0 before 9: (b7) r3 = 0
> regs=4 stack=0 before 8: (b7) r2 = 4
> last_idx 12 first_idx 0
> regs=10 stack=0 before 11: (b7) r5 = 0
> regs=10 stack=0 before 10: (b7) r4 = 0
> 13: (95) exit
> 
> from 6 to 13: safe
> processed 14 insns (limit 1000000) max_states_per_insn 0 total_states 1
> peak_states 1 mark_read 1
> FAIL retval 65507 != -29 (run 1/1)
> 0: (7a) *(u64 *)(r10 -8) = 0
> 1: (bf) r2 = r10
> 2: (07) r2 += -8
> 3: (18) r1 = 0xffff00becd0d8c00
> 5: (85) call bpf_map_lookup_elem#1
> 6: (15) if r0 == 0x0 goto pc+6
>   R0_w=map_value(id=0,off=0,ks=4,vs=48,imm=0) R10=fp0 fp-8_w=mmmmmmmm
> 7: (bf) r1 = r0
> 8: (b7) r2 = 4
> 9: (b7) r3 = 0
> 10: (b7) r4 = 0
> 11: (b7) r5 = 0
> 12: (85) call bpf_csum_diff#28
>   R0_w=map_value(id=0,off=0,ks=4,vs=48,imm=0)
> R1_w=map_value(id=0,off=0,ks=4,vs=48,imm=0) R2_w=inv4 R3_w=inv0 R4_w=inv0
> R5_w=inv0 R10=fp0 fp-8_w=mmmmmmmm
> last_idx 12 first_idx 0
> regs=4 stack=0 before 11: (b7) r5 = 0
> regs=4 stack=0 before 10: (b7) r4 = 0
> regs=4 stack=0 before 9: (b7) r3 = 0
> regs=4 stack=0 before 8: (b7) r2 = 4
> last_idx 12 first_idx 0
> regs=10 stack=0 before 11: (b7) r5 = 0
> regs=10 stack=0 before 10: (b7) r4 = 0
> 13: (95) exit
> 
> from 6 to 13: safe
> processed 14 insns (limit 1000000) max_states_per_insn 0 total_states 1
> peak_states 1 mark_read 1
> Summary: 0 PASSED, 0 SKIPPED, 1 FAILED
> 
> Above output without line wrapping: https://paste.ubuntu.com/p/qhCK8nJjKw/
> 
> Kernel version 5.4.21, config: https://paste.ubuntu.com/p/G3yxvvjRMS/

Yep, the csum_diff is broken for non-x86_64. Fix is wip on my side, will keep
you posted.

Thanks,
Daniel

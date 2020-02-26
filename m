Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F05A17005B
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 14:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgBZNpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 08:45:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48339 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgBZNpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 08:45:00 -0500
Received: from 1.general.ppisati.uk.vpn ([10.172.193.134] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <paolo.pisati@canonical.com>)
        id 1j6wzi-0007d7-Jm; Wed, 26 Feb 2020 13:44:58 +0000
Date:   Wed, 26 Feb 2020 14:44:58 +0100
From:   Paolo Pisati <paolo.pisati@canonical.com>
To:     bpf@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: selftests/bpf: arm64: test_verifier 13 "FAIL retval 65507 != -29
 (run 1/1)"
Message-ID: <20200226134458.GA65282@harukaze>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This particular selftest fails on arm64 (x86-64 is fine):

$ sudo ./tools/testing/selftests/bpf/test_verifier -v 13
#13/p valid read map access into a read-only array 2 , verifier log:
0: (7a) *(u64 *)(r10 -8) = 0
1: (bf) r2 = r10
2: (07) r2 += -8
3: (18) r1 = 0xffff00becd0d8c00
5: (85) call bpf_map_lookup_elem#1
6: (15) if r0 == 0x0 goto pc+6
 R0_w=map_value(id=0,off=0,ks=4,vs=48,imm=0) R10=fp0 fp-8_w=mmmmmmmm
7: (bf) r1 = r0
8: (b7) r2 = 4
9: (b7) r3 = 0
10: (b7) r4 = 0
11: (b7) r5 = 0
12: (85) call bpf_csum_diff#28
 R0_w=map_value(id=0,off=0,ks=4,vs=48,imm=0)
R1_w=map_value(id=0,off=0,ks=4,vs=48,imm=0) R2_w=inv4 R3_w=inv0 R4_w=inv0
R5_w=inv0 R10=fp0 fp-8_w=mmmmmmmm
last_idx 12 first_idx 0
regs=4 stack=0 before 11: (b7) r5 = 0
regs=4 stack=0 before 10: (b7) r4 = 0
regs=4 stack=0 before 9: (b7) r3 = 0
regs=4 stack=0 before 8: (b7) r2 = 4
last_idx 12 first_idx 0
regs=10 stack=0 before 11: (b7) r5 = 0
regs=10 stack=0 before 10: (b7) r4 = 0
13: (95) exit

from 6 to 13: safe
processed 14 insns (limit 1000000) max_states_per_insn 0 total_states 1
peak_states 1 mark_read 1
FAIL retval 65507 != -29 (run 1/1) 
0: (7a) *(u64 *)(r10 -8) = 0
1: (bf) r2 = r10
2: (07) r2 += -8
3: (18) r1 = 0xffff00becd0d8c00
5: (85) call bpf_map_lookup_elem#1
6: (15) if r0 == 0x0 goto pc+6
 R0_w=map_value(id=0,off=0,ks=4,vs=48,imm=0) R10=fp0 fp-8_w=mmmmmmmm
7: (bf) r1 = r0
8: (b7) r2 = 4
9: (b7) r3 = 0
10: (b7) r4 = 0
11: (b7) r5 = 0
12: (85) call bpf_csum_diff#28
 R0_w=map_value(id=0,off=0,ks=4,vs=48,imm=0)
R1_w=map_value(id=0,off=0,ks=4,vs=48,imm=0) R2_w=inv4 R3_w=inv0 R4_w=inv0
R5_w=inv0 R10=fp0 fp-8_w=mmmmmmmm
last_idx 12 first_idx 0
regs=4 stack=0 before 11: (b7) r5 = 0
regs=4 stack=0 before 10: (b7) r4 = 0
regs=4 stack=0 before 9: (b7) r3 = 0
regs=4 stack=0 before 8: (b7) r2 = 4
last_idx 12 first_idx 0
regs=10 stack=0 before 11: (b7) r5 = 0
regs=10 stack=0 before 10: (b7) r4 = 0
13: (95) exit

from 6 to 13: safe
processed 14 insns (limit 1000000) max_states_per_insn 0 total_states 1
peak_states 1 mark_read 1
Summary: 0 PASSED, 0 SKIPPED, 1 FAILED

Above output without line wrapping: https://paste.ubuntu.com/p/qhCK8nJjKw/

Kernel version 5.4.21, config: https://paste.ubuntu.com/p/G3yxvvjRMS/

Anything i can do to help debug this?
-- 
bye,
p.

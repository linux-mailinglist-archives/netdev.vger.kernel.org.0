Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFE91FBFE9
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 22:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731633AbgFPUVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 16:21:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:54006 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbgFPUVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 16:21:09 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jlI4w-0004C2-3O; Tue, 16 Jun 2020 22:21:06 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jlI4v-0000cm-Qx; Tue, 16 Jun 2020 22:21:05 +0200
Subject: Re: [PATCH bpf 2/2] selftests/bpf: add variable-length data
 concatenation pattern test
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Christoph Hellwig <hch@lst.de>
References: <20200616050432.1902042-1-andriin@fb.com>
 <20200616050432.1902042-2-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5fed920d-aeb6-c8de-18c0-7c046bbfb242@iogearbox.net>
Date:   Tue, 16 Jun 2020 22:21:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200616050432.1902042-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25845/Tue Jun 16 15:01:35 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/20 7:04 AM, Andrii Nakryiko wrote:
> Add selftest that validates variable-length data reading and concatentation
> with one big shared data array. This is a common pattern in production use for
> monitoring and tracing applications, that potentially can read a lot of data,
> but usually reads much less. Such pattern allows to determine precisely what
> amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
> 
> This is the first BPF selftest that at all looks at and tests
> bpf_probe_read_str()-like helper's return value, closing a major gap in BPF
> testing. It surfaced the problem with bpf_probe_read_kernel_str() returning
> 0 on success, instead of amount of bytes successfully read.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Fix looks good, but I'm seeing an issue in the selftest on my side. With latest
Clang/LLVM I'm getting:

# ./test_progs -t varlen
#86 varlen:OK
Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

All good, however, the test_progs-no_alu32 fails for me with:

# ./test_progs-no_alu32 -t varlen
Switching to flavor 'no_alu32' subdirectory...
libbpf: load bpf program failed: Invalid argument
libbpf: -- BEGIN DUMP LOG ---
libbpf:
arg#0 type is not a struct
Unrecognized arg#0 type PTR
; int pid = bpf_get_current_pid_tgid() >> 32;
0: (85) call bpf_get_current_pid_tgid#14
; int pid = bpf_get_current_pid_tgid() >> 32;
1: (77) r0 >>= 32
; if (test_pid != pid || !capture)
2: (18) r1 = 0xffffb14a4010c200
4: (61) r1 = *(u32 *)(r1 +0)
  R0_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R1_w=map_value(id=0,off=512,ks=4,vs=1056,imm=0) R10=fp0
; if (test_pid != pid || !capture)
5: (5d) if r1 != r0 goto pc+43
  R0_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R10=fp0
6: (18) r1 = 0xffffb14a4010c204
8: (71) r1 = *(u8 *)(r1 +0)
  R0_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R1_w=map_value(id=0,off=516,ks=4,vs=1056,imm=0) R10=fp0
9: (15) if r1 == 0x0 goto pc+39
  R0=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R1=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) R10=fp0
; len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
10: (18) r6 = 0xffffb14a4010c220
12: (18) r1 = 0xffffb14a4010c220
14: (b7) r2 = 256
15: (18) r3 = 0xffffb14a4010c000
17: (85) call bpf_probe_read_kernel_str#115
  R0=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R1_w=map_value(id=0,off=544,ks=4,vs=1056,imm=0) R2_w=inv256 R3_w=map_value(id=0,off=0,ks=4,vs=1056,imm=0) R6_w=map_value(id=0,off=544,ks=4,vs=1056,imm=0) R10=fp0
last_idx 17 first_idx 9
regs=4 stack=0 before 15: (18) r3 = 0xffffb14a4010c000
regs=4 stack=0 before 14: (b7) r2 = 256
18: (67) r0 <<= 32
19: (bf) r1 = r0
20: (77) r1 >>= 32
; if (len <= MAX_LEN) {
21: (25) if r1 > 0x100 goto pc+7
  R0=inv(id=0,smax_value=1099511627776,umax_value=18446744069414584320,var_off=(0x0; 0xffffffff00000000),s32_min_value=0,s32_max_value=0,u32_max_value=0) R1=inv(id=0,umax_value=256,var_off=(0x0; 0x1ff)) R6=map_value(id=0,off=544,ks=4,vs=1056,imm=0) R10=fp0
;
22: (c7) r0 s>>= 32
; payload1_len1 = len;
23: (18) r1 = 0xffffb14a4010c208
25: (7b) *(u64 *)(r1 +0) = r0
  R0_w=inv(id=0,smin_value=-2147483648,smax_value=256) R1_w=map_value(id=0,off=520,ks=4,vs=1056,imm=0) R6=map_value(id=0,off=544,ks=4,vs=1056,imm=0) R10=fp0
; payload += len;
26: (18) r6 = 0xffffb14a4010c220
28: (0f) r6 += r0
last_idx 28 first_idx 21
regs=1 stack=0 before 26: (18) r6 = 0xffffb14a4010c220
regs=1 stack=0 before 25: (7b) *(u64 *)(r1 +0) = r0
regs=1 stack=0 before 23: (18) r1 = 0xffffb14a4010c208
regs=1 stack=0 before 22: (c7) r0 s>>= 32
regs=1 stack=0 before 21: (25) if r1 > 0x100 goto pc+7
  R0_rw=invP(id=0,smax_value=1099511627776,umax_value=18446744069414584320,var_off=(0x0; 0xffffffff00000000),s32_min_value=0,s32_max_value=0,u32_max_value=0) R1_rw=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R6_w=map_value(id=0,off=544,ks=4,vs=1056,imm=0) R10=fp0
parent didn't have regs=1 stack=0 marks
last_idx 20 first_idx 9
regs=1 stack=0 before 20: (77) r1 >>= 32
regs=1 stack=0 before 19: (bf) r1 = r0
regs=1 stack=0 before 18: (67) r0 <<= 32
regs=1 stack=0 before 17: (85) call bpf_probe_read_kernel_str#115
value -2147483648 makes map_value pointer be out of bounds
processed 22 insns (limit 1000000) max_states_per_insn 0 total_states 2 peak_states 2 mark_read 1

libbpf: -- END LOG --
libbpf: failed to load program 'raw_tp/sys_enter'
libbpf: failed to load object 'test_varlen'
libbpf: failed to load BPF skeleton 'test_varlen': -4007
test_varlen:FAIL:skel_open failed to open skeleton
#86 varlen:FAIL
Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

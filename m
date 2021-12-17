Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F0747976F
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 00:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhLQXLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 18:11:41 -0500
Received: from www62.your-server.de ([213.133.104.62]:42466 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhLQXLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 18:11:40 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1myMO3-0006QB-Js; Sat, 18 Dec 2021 00:11:39 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1myMO3-000O5g-Bo; Sat, 18 Dec 2021 00:11:39 +0100
Subject: Re: [PATCH bpf-next v3 0/3] libbpf: Implement BTFGen
To:     =?UTF-8?Q?Mauricio_V=c3=a1squez?= <mauricio@kinvolk.io>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
References: <20211217185654.311609-1-mauricio@kinvolk.io>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7a628aaf-852a-2118-85f4-f49bb0d35944@iogearbox.net>
Date:   Sat, 18 Dec 2021 00:11:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211217185654.311609-1-mauricio@kinvolk.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26390/Fri Dec 17 10:20:34 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/21 7:56 PM, Mauricio Vásquez wrote:
> CO-RE requires to have BTF information describing the types of the
> kernel in order to perform the relocations. This is usually provided by
> the kernel itself when it's configured with CONFIG_DEBUG_INFO_BTF.
> However, this configuration is not enabled in all the distributions and
> it's not available on kernels before 5.12.
> 
[...]
> Changelog:
> 
> v2 > v3:
> - expose internal libbpf APIs to bpftool instead
> - implement btfgen in bpftool
> - drop btf__raw_data() from libbpf

Looks like this breaks bpf-next CI, please take a look:

https://github.com/kernel-patches/bpf/runs/4565944884?check_suite_focus=true

   [...]

   All error logs:

   #36 core_kern_lskel:FAIL
   test_core_kern_lskel:FAIL:open_and_load unexpected error: -22

   #69 kfunc_call:FAIL
   test_main:PASS:skel 0 nsec
   test_main:PASS:bpf_prog_test_run(test1) 0 nsec
   test_main:PASS:test1-retval 0 nsec
   test_main:PASS:bpf_prog_test_run(test2) 0 nsec
   test_main:PASS:test2-retval 0 nsec
   #69/1 kfunc_call/main:OK
   test_subprog:PASS:skel 0 nsec
   test_subprog:PASS:bpf_prog_test_run(test1) 0 nsec
   test_subprog:PASS:test1-retval 0 nsec
   test_subprog:PASS:active_res 0 nsec
   test_subprog:PASS:sk_state_res 0 nsec
   #69/2 kfunc_call/subprog:OK
   test_subprog_lskel:FAIL:skel unexpected error: -22
   #69/3 kfunc_call/subprog_lskel:FAIL

   #71 ksyms_btf:FAIL
   test_ksyms_btf:PASS:btf_exists 0 nsec
   test_basic:PASS:kallsyms_fopen 0 nsec
   test_basic:PASS:ksym_find 0 nsec
   test_basic:PASS:kallsyms_fopen 0 nsec
   test_basic:PASS:ksym_find 0 nsec
   test_basic:PASS:skel_open 0 nsec
   test_basic:PASS:skel_attach 0 nsec
   test_basic:PASS:runqueues_addr 0 nsec
   test_basic:PASS:bpf_prog_active_addr 0 nsec
   test_basic:PASS:rq_cpu 0 nsec
   test_basic:PASS:bpf_prog_active 0 nsec
   test_basic:PASS:cpu_rq(0)->cpu 0 nsec
   test_basic:PASS:this_rq_cpu 0 nsec
   test_basic:PASS:this_bpf_prog_active 0 nsec
   #71/1 ksyms_btf/basic:OK
   libbpf: prog 'handler': BPF program load failed: Permission denied
   libbpf: prog 'handler': -- BEGIN PROG LOAD LOG --
   arg#0 reference type('UNKNOWN ') size cannot be determined: -22
   0: R1=ctx(id=0,off=0,imm=0) R10=fp0
   ; cpu = bpf_get_smp_processor_id();
   0: (85) call bpf_get_smp_processor_id#8       ; R0_w=inv(id=0)
   1: (bc) w7 = w0                       ; R0_w=inv(id=0) R7_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff))
   ; rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, cpu);
   2: (18) r1 = 0x2bd80                  ; R1_w=percpu_ptr_rq(id=0,off=0,imm=0)
   4: (bc) w2 = w7                       ; R2_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R7_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff))
   5: (85) call bpf_per_cpu_ptr#153      ; R0_w=ptr_or_null_rq(id=1,off=0,imm=0)
   6: (bf) r6 = r0                       ; R0_w=ptr_or_null_rq(id=1,off=0,imm=0) R6_w=ptr_or_null_rq(id=1,off=0,imm=0)
   ; active = (int *)bpf_per_cpu_ptr(&bpf_prog_active, cpu);
   7: (18) r1 = 0x27de0                  ; R1_w=percpu_ptr_int(id=0,off=0,imm=0)
   9: (bc) w2 = w7                       ; R2_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R7_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff))
   10: (85) call bpf_per_cpu_ptr#153     ; R0=mem_or_null(id=2,ref_obj_id=0,off=0,imm=0)
   ; if (active) {
   11: (15) if r0 == 0x0 goto pc+2       ; R0=mem(id=0,ref_obj_id=0,off=0,imm=0)
   ; *(volatile int *)active;
   12: (61) r1 = *(u32 *)(r0 +0)         ; R0=mem(id=0,ref_obj_id=0,off=0,imm=0) R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff))
   ; *(volatile int *)(&rq->cpu);
   13: (61) r1 = *(u32 *)(r6 +2848)
   R6 invalid mem access 'ptr_or_null_'
   processed 12 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 1
   -- END PROG LOAD LOG --
   libbpf: failed to load program 'handler'
   libbpf: failed to load object 'test_ksyms_btf_null_check'
   libbpf: failed to load BPF skeleton 'test_ksyms_btf_null_check': -13
   test_null_check:PASS:skel_open 0 nsec
   #71/2 ksyms_btf/null_check:OK
   test_weak_syms:PASS:test_ksyms_weak__open_and_load 0 nsec
   test_weak_syms:PASS:test_ksyms_weak__attach 0 nsec
   test_weak_syms:PASS:existing typed ksym 0 nsec
   test_weak_syms:PASS:existing typeless ksym 0 nsec
   test_weak_syms:PASS:nonexistent typeless ksym 0 nsec
   test_weak_syms:PASS:nonexistent typed ksym 0 nsec
   #71/3 ksyms_btf/weak_ksyms:OK
   test_weak_syms_lskel:FAIL:test_ksyms_weak_lskel__open_and_load unexpected error: -22
   #71/4 ksyms_btf/weak_ksyms_lskel:FAIL

   #89 map_ptr:FAIL
   test_map_ptr:PASS:skel_open 0 nsec
   test_map_ptr:FAIL:skel_load unexpected error: -22 (errno 22)
   Summary: 221/1052 PASSED, 8 SKIPPED, 4 FAILED
test_progs-no_alu32 - Testing test_progs-no_alu32
test_maps - Testing test_maps
test_verifier - Testing test_verifier
collect_status - Collect status
shutdown - Shutdown
Test Results:
              bpftool: PASS
           test_progs: FAIL (returned 1)
  test_progs-no_alu32: FAIL (returned 1)
            test_maps: PASS
        test_verifier: PASS
             shutdown: CLEAN
Error: Process completed with exit code 1.

> v1 > v2:
> - introduce bpf_object__prepare() and ‘record_core_relos’ to expose
>    CO-RE relocations instead of bpf_object__reloc_info_gen()
> - rename btf__save_to_file() to btf__raw_data()
> 
> v1: https://lore.kernel.org/bpf/20211027203727.208847-1-mauricio@kinvolk.io/
> v2: https://lore.kernel.org/bpf/20211116164208.164245-1-mauricio@kinvolk.io/
> 
> Mauricio Vásquez (3):
>    libbpf: split bpf_core_apply_relo()
>    libbpf: Implement changes needed for BTFGen in bpftool
>    bpftool: Implement btfgen
> 
>   kernel/bpf/btf.c                |  11 +-
>   tools/bpf/bpftool/gen.c         | 892 ++++++++++++++++++++++++++++++++
>   tools/lib/bpf/Makefile          |   2 +-
>   tools/lib/bpf/libbpf.c          | 124 +++--
>   tools/lib/bpf/libbpf.h          |   3 +
>   tools/lib/bpf/libbpf.map        |   2 +
>   tools/lib/bpf/libbpf_internal.h |  22 +
>   tools/lib/bpf/relo_core.c       |  83 +--
>   tools/lib/bpf/relo_core.h       |  46 +-
>   9 files changed, 1086 insertions(+), 99 deletions(-)
> 


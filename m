Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8629A6E14F7
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDMTPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDMTPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:15:33 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2E29B;
        Thu, 13 Apr 2023 12:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=eH/DahIDVrAIa1NsZLg30scAIckyQ4JmqUU5xej4Ytg=; b=a63SYtXQbkwHgGTG8FPjUi6zyd
        LD2YEZWGECkO9noZO2f7W5Xphnn5TE40XRtz7j0uCqZl6VhgKonTmmmFYD30YuO2O+8uUbmu9fvsA
        xWwja8fP0STAIxUehBXH0sRCUczJuNPZ0BiR2N7AOV4ITeg6M+lOq3Htk8IGwhmTdnLMXlVOy1GZn
        OVFWjEC+w+kAZyecoqj+WS8gHTIenHQ+ePxw7ea2z8ImzOkOPo202xHvSix6FrrpNVOOHKRtmvka0
        +rySEDIYbuisVT7oRxcsd+FWQJuMrvr6Nh6UzhCN71otxvNcsEx9pNoUY36XgSisHpiy7aIBwH74L
        2O8GU4hA==;
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pn2Pl-000GRp-V5; Thu, 13 Apr 2023 21:15:26 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2023-04-13
Date:   Thu, 13 Apr 2023 21:15:25 +0200
Message-Id: <20230413191525.7295-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26874/Thu Apr 13 09:30:39 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 260 non-merge commits during the last 36 day(s) which contain
a total of 356 files changed, 21786 insertions(+), 11275 deletions(-).

There is a simple merge conflict in include/net/ip_tunnels.h between net-next
commit bc9d003dc48c ("ip_tunnel: Preserve pointer const in ip_tunnel_info_opts")
and bpf-next commit ac931d4cdec3 ("ipip,ip_tunnel,sit: Add FOU support for
externally controlled ipip devices"), resolution is to take both hunks:

  [...]
  /* Maximum tunnel options length. */
  #define IP_TUNNEL_OPTS_MAX                                      \
          GENMASK((sizeof_field(struct ip_tunnel_info,            \
                                options_len) * BITS_PER_BYTE) - 1, 0)
  
  #define ip_tunnel_info_opts(info)                               \
          _Generic(info,                                          \
                   const struct ip_tunnel_info * : ((const void *)((info) + 1)),\
                   struct ip_tunnel_info * : ((void *)((info) + 1))\
          )
  
  struct ip_tunnel_info {
  [...]

Another small one in Documentation/bpf/bpf_devel_QA.rst between net-next commit
b7abcd9c656b ("bpf, doc: Link to submitting-patches.rst for general patch
submission info") and bpf-next commit 0f10f647f455 ("bpf, docs: Use internal
linking for link to netdev subsystem doc"), resolve by removing both hunks:

  [...]
  .. Links
  .. _selftests:
     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/bpf/
  [...]

And the last one concerns a small conflict in net/bpf/test_run.c between net-next
commit 294635a8165a ("bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES")
and bpf-next commit e5995bc7e2ba ("bpf, test_run: fix crashes due to XDP frame
overwriting/corruption"). The correct solution is to change `frm.` into `frame->`,
resulting in:

  [...]
  static bool frame_was_changed(const struct xdp_page_head *head)
  {
          /* xdp_scrub_frame() zeroes the data pointer, flags is the last field,
           * i.e. has the highest chances to be overwritten. If those two are
           * untouched, it's most likely safe to skip the context reset.
           */
          return head->frame->data != head->orig_ctx.data ||
                 head->frame->flags != head->orig_ctx.flags;
  }
  [...]

The main changes are:

1) Rework BPF verifier log behavior and implement it as a rotating log by default
   with the option to retain old-style fixed log behavior, from Andrii Nakryiko.

2) Adds support for using {FOU,GUE} encap with an ipip device operating in collect_md
   mode and add a set of BPF kfuncs for controlling encap params, from Christian Ehrig.

3) Allow BPF programs to detect at load time whether a particular kfunc exists or
   not, and also add support for this in light skeleton, from Alexei Starovoitov.

4) Optimize hashmap lookups when key size is multiple of 4, from Anton Protopopov.

5) Enable RCU semantics for task BPF kptrs and allow referenced kptr tasks to be
   stored in BPF maps, from David Vernet.

6) Add support for stashing local BPF kptr into a map value via bpf_kptr_xchg().
   This is useful e.g. for rbtree node creation for new cgroups, from Dave Marchevsky.

7) Fix BTF handling of is_int_ptr to skip modifiers to work around tracing issues
   where a program cannot be attached, from Feng Zhou.

8) Migrate a big portion of test_verifier unit tests over to test_progs -a verifier_*
   via inline asm to ease {read,debug}ability, from Eduard Zingerman.

9) Several updates to the instruction-set.rst documentation which is subject to
   future IETF standardization (https://lwn.net/Articles/926882/), from Dave Thaler.

10) Fix BPF verifier in the __reg_bound_offset's 64->32 tnum sub-register known bits
    information propagation, from Daniel Borkmann.

11) Add skb bitfield compaction work related to BPF with the overall goal to
    make more of the sk_buff bits optional, from Jakub Kicinski.

12) BPF selftest cleanups for build id extraction which stand on its own from the
    upcoming integration work of build id into struct file object, from Jiri Olsa.

13) Add fixes and optimizations for xsk descriptor validation and several selftest
    improvements for xsk sockets, from Kal Conley.

14) Add BPF links for struct_ops and enable switching implementations of BPF TCP
    cong-ctls under a given name by replacing backing struct_ops map, from Kui-Feng Lee.

15) Remove a misleading BPF verifier env->bypass_spec_v1 check on variable offset
    stack read as earlier Spectre checks cover this, from Luis Gerhorst.

16) Fix issues in copy_from_user_nofault() for BPF and other tracers to resemble
    copy_from_user_nmi() from safety PoV, from Florian Lehner and Alexei Starovoitov.

17) Add --json-summary option to test_progs in order for CI tooling to ease parsing
    of test results, from Manu Bretelle.

18) Batch of improvements and refactoring to prep for upcoming bpf_local_storage
    conversion to bpf_mem_cache_{alloc,free} allocator, from Martin KaFai Lau.

19) Improve bpftool's visual program dump which produces the control flow graph in
    a DOT format by adding C source inline annotations, from Quentin Monnet.

20) Fix attaching fentry/fexit/fmod_ret/lsm to modules by extracting the module name from
    BTF of the target and searching kallsyms of the correct module, from Viktor Malik.

21) Improve BPF verifier handling of '<const> <cond> <non_const>' to better detect
    whether in particular jmp32 branches are taken, from Yonghong Song.

22) Allow BPF TCP cong-ctls to write app_limited of struct tcp_sock. A built-in cc or
    one from a kernel module is already able to write to app_limited, from Yixin Shen.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Artem Savkov, Dan Carpenter, Daniel 
Borkmann, Dave Marchevsky, David Vernet, Eduard Zingerman, Florian 
Lehner, Hsin-Wei Hung, Ilya Leoshkevich, James Hilliard, Jiri Olsa, John 
Fastabend, kernel test robot, Kui-Feng Lee, Kumar Kartikeya Dwivedi, 
Linux Kernel Functional Testing, Lorenz Bauer, Luis Chamberlain, Maciej 
Fijalkowski, Magnus Karlsson, Martin KaFai Lau, Michael S. Tsirkin, Oleg 
Nesterov, Quentin Monnet, Stanislav Fomichev, Steven Rostedt (Google), 
Tejun Heo, Toke Høiland-Jørgensen, Xu Kuohai, Yonghong Song, Zhen Lei

----------------------------------------------------------------

The following changes since commit ed69e0667db5fd0f7eb1fdef329e0985939b0148:

  Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2023-03-08 14:34:22 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to 8c5c2a4898e3d6bad86e29d471e023c8a19ba799:

  bpf, sockmap: Revert buggy deadlock fix in the sockhash and sockmap (2023-04-13 20:36:32 +0200)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alejandro Colomar (1):
      bpf: Remove extra whitespace in SPDX tag for syscall/helpers man pages

Alexander Lobakin (6):
      selftests/bpf: robustify test_xdp_do_redirect with more payload magics
      net: page_pool, skbuff: make skb_mark_for_recycle() always available
      xdp: recycle Page Pool backed skbs built from XDP frames
      xdp: remove unused {__,}xdp_release_frame()
      bpf, test_run: fix crashes due to XDP frame overwriting/corruption
      selftests/bpf: fix "metadata marker" getting overwritten by the netstack

Alexei Starovoitov (42):
      Merge branch 'BPF open-coded iterators'
      Merge branch 'selftests/bpf: make BPF_CFLAGS stricter with -Wall'
      Merge branch 'Support stashing local kptrs with bpf_kptr_xchg'
      bpf: Fix bpf_strncmp proto.
      bpf: Allow helpers access trusted PTR_TO_BTF_ID.
      selftests/bpf: Add various tests to check helper access into ptr_to_btf_id.
      Merge branch 'xdp: recycle Page Pool backed skbs built from XDP frames'
      selftests/bpf: Fix trace_virtqueue_add_sgs test issue with LLVM 17.
      Merge branch 'Fix attaching fentry/fexit/fmod_ret/lsm to modules'
      Merge branch 'Make struct bpf_cpumask RCU safe'
      Merge branch 'double-fix bpf_test_run + XDP_PASS recycling'
      bpf: Allow ld_imm64 instruction to point to kfunc.
      libbpf: Fix relocation of kfunc ksym in ld_imm64 insn.
      libbpf: Introduce bpf_ksym_exists() macro.
      selftests/bpf: Add test for bpf_ksym_exists().
      libbpf: Fix ld_imm64 copy logic for ksym in light skeleton.
      selftest/bpf: Add a test case for ld_imm64 copy logic.
      libbpf: Rename RELO_EXTERN_VAR/FUNC.
      bpf: Teach the verifier to recognize rdonly_mem as not null.
      libbpf: Support kfunc detection in light skeleton.
      selftests/bpf: Add light skeleton test for kfunc detection.
      Merge branch 'error checking where helpers call bpf_map_ops'
      Merge branch 'Don't invoke KPTR_REF destructor on NULL xchg'
      Merge branch 'First set of verifier/*.c migrated to inline assembly'
      Merge branch 'bpf: Use bpf_mem_cache_alloc/free in bpf_local_storage'
      Merge branch 'veristat: add better support of freplace programs'
      Merge branch 'selftests/bpf: Add read_build_id function'
      Merge branch 'Prepare veristat for packaging'
      Merge branch 'Enable RCU semantics for task kptrs'
      bpf: Invoke btf_struct_access() callback only for writes.
      bpf: Remove unused arguments from btf_struct_access().
      bpf: Refactor btf_nested_type_is_trusted().
      bpf: Teach verifier that certain helpers accept NULL pointer.
      bpf: Refactor NULL-ness check in check_reg_type().
      bpf: Allowlist few fields similar to __rcu tag.
      bpf: Undo strict enforcement for walking untagged fields.
      selftests/bpf: Add tracing tests for walking skb and req.
      Merge branch 'bpftool: Add inline annotations when dumping program CFGs'
      Merge branch 'bpf: Improve verifier for cond_op and spilled loop index variables'
      bpf: Handle NULL in bpf_local_storage_free.
      Merge branch 'Add FOU support for externally controlled ipip devices'
      mm: Fix copy_from_user_nofault().

Andrii Nakryiko (49):
      bpf: factor out fetching basic kfunc metadata
      bpf: add iterator kfuncs registration and validation logic
      bpf: add support for open-coded iterator loops
      bpf: implement numbers iterator
      selftests/bpf: add bpf_for_each(), bpf_for(), and bpf_repeat() macros
      selftests/bpf: add iterators tests
      selftests/bpf: add number iterator tests
      selftests/bpf: implement and test custom testmod_seq iterator
      selftests/bpf: prevent unused variable warning in bpf_for()
      selftests/bpf: add __sink() macro to fake variable consumption
      selftests/bpf: fix lots of silly mistakes pointed out by compiler
      selftests/bpf: make BPF compiler flags stricter
      bpf: ensure state checkpointing at iter_next() call sites
      bpf: take into account liveness when propagating precision
      bpf: fix precision propagation verbose logging
      Merge branch 'bpf: Add detection of kfuncs.'
      Merge branch 'bpf: Support ksym detection in light skeleton.'
      bpf: remember meta->iter info only for initialized iters
      Merge branch 'verifier/xdp_direct_packet_access.c converted to inline assembly'
      libbpf: disassociate section handler on explicit bpf_program__set_type() call
      veristat: add -d debug mode option to see debug libbpf log
      veristat: guess and substitue underlying program type for freplace (EXT) progs
      veristat: change guess for __sk_buff from CGROUP_SKB to SCHED_CLS
      veristat: relicense veristat.c as dual GPL-2.0-only or BSD-2-Clause licensed
      veristat: improve version reporting
      veristat: avoid using kernel-internal headers
      veristat: small fixed found in -O2 mode
      Merge branch 'bpf: Follow up to RCU enforcement in the verifier.'
      bpf: Split off basic BPF verifier log into separate file
      bpf: Remove minimum size restrictions on verifier log buffer
      bpf: Switch BPF verifier log to be a rotating log by default
      libbpf: Don't enforce unnecessary verifier log restrictions on libbpf side
      veristat: Add more veristat control over verifier log options
      selftests/bpf: Add fixed vs rotating verifier log tests
      bpf: Ignore verifier log reset in BPF_LOG_KERNEL mode
      bpf: Fix missing -EFAULT return on user log buf error in btf_parse()
      bpf: Avoid incorrect -EFAULT error in BPF_LOG_KERNEL mode
      bpf: Simplify logging-related error conditions handling
      bpf: Keep track of total log content size in both fixed and rolling modes
      bpf: Add log_true_size output field to return necessary log buffer size
      bpf: Simplify internal verifier log interface
      bpf: Relax log_buf NULL conditions when log_level>0 is requested
      libbpf: Wire through log_true_size returned from kernel for BPF_PROG_LOAD
      libbpf: Wire through log_true_size for bpf_btf_load() API
      selftests/bpf: Add tests to validate log_true_size feature
      selftests/bpf: Add testing of log_buf==NULL condition for BPF_PROG_LOAD
      selftests/bpf: Add verifier log tests for BPF_BTF_LOAD command
      selftests/bpf: Remove stand-along test_verifier_log test binary
      selftests/bpf: Fix compiler warnings in bpf_testmod for kfuncs

Anton Protopopov (2):
      bpf: optimize hashmap lookups when key_size is divisible by 4
      bpf: compute hashes in bloom filter similar to hashmap

Bagas Sanjaya (1):
      bpf, docs: Use internal linking for link to netdev subsystem doc

Barret Rhoden (1):
      bpf: ensure all memory is initialized in bpf_get_current_comm

Christian Ehrig (3):
      ipip,ip_tunnel,sit: Add FOU support for externally controlled ipip devices
      bpf,fou: Add bpf_skb_{set,get}_fou_encap kfuncs
      selftests/bpf: Test FOU kfuncs for externally controlled ipip devices

Daniel Borkmann (3):
      bpf: Fix __reg_bound_offset 64->32 var_off subreg propagation
      Merge branch 'bpf-verifier-log-rotation'
      bpf, sockmap: Revert buggy deadlock fix in the sockhash and sockmap

Daniel Müller (1):
      libbpf: Ignore warnings about "inefficient alignment"

Dave Marchevsky (8):
      bpf: verifier: Rename kernel_type_name helper to btf_type_name
      bpf: btf: Remove unused btf_field_info_type enum
      bpf: Change btf_record_find enum parameter to field_mask
      bpf: Support __kptr to local kptrs
      bpf: Allow local kptrs to be exchanged via bpf_kptr_xchg
      selftests/bpf: Add local kptr stashing test
      bpf: Disable migration when freeing stashed local kptr using obj drop
      bpf: Fix struct_meta lookup for bpf_obj_free_fields kfunc call

Dave Thaler (4):
      bpf, docs: Explain helper functions
      bpf, docs: Add signed comparison example
      bpf, docs: Add extended call instructions
      bpf, docs: Add docs on extended 64-bit immediate instructions

David Vernet (18):
      bpf/selftests: Fix send_signal tracepoint tests
      tasks: Extract rcu_users out of union
      bpf: Free struct bpf_cpumask in call_rcu handler
      bpf: Mark struct bpf_cpumask as rcu protected
      bpf/selftests: Test using global cpumask kptr with RCU
      bpf: Remove bpf_cpumask_kptr_get() kfunc
      bpf,docs: Remove bpf_cpumask_kptr_get() from documentation
      bpf: Only invoke kptr dtor following non-NULL xchg
      bpf: Remove now-unnecessary NULL checks for KF_RELEASE kfuncs
      bpf: Treat KF_RELEASE kfuncs as KF_TRUSTED_ARGS
      bpf: Handle PTR_MAYBE_NULL case in PTR_TO_BTF_ID helper call arg
      selftests/bpf: Add testcases for ptr_*_or_null_ in bpf_kptr_xchg
      bpf: Make struct task_struct an RCU-safe type
      bpf: Remove now-defunct task kfuncs
      bpf,docs: Update documentation to reflect new task kfuncs
      bpf: Make bpf_cgroup_acquire() KF_RCU | KF_RET_NULL
      bpf: Remove bpf_cgroup_kptr_get() kfunc
      bpf,docs: Remove references to bpf_cgroup_kptr_get()

Eduard Zingerman (46):
      selftests/bpf: Report program name on parse_test_spec error
      selftests/bpf: __imm_insn & __imm_const macro for bpf_misc.h
      selftests/bpf: Unprivileged tests for test_loader.c
      selftests/bpf: Tests execution support for test_loader.c
      selftests/bpf: prog_tests entry point for migrated test_verifier tests
      selftests/bpf: verifier/and.c converted to inline assembly
      selftests/bpf: verifier/array_access.c converted to inline assembly
      selftests/bpf: verifier/basic_stack.c converted to inline assembly
      selftests/bpf: verifier/bounds_deduction.c converted to inline assembly
      selftests/bpf: verifier/bounds_mix_sign_unsign.c converted to inline assembly
      selftests/bpf: verifier/cfg.c converted to inline assembly
      selftests/bpf: verifier/cgroup_inv_retcode.c converted to inline assembly
      selftests/bpf: verifier/cgroup_skb.c converted to inline assembly
      selftests/bpf: verifier/cgroup_storage.c converted to inline assembly
      selftests/bpf: verifier/const_or.c converted to inline assembly
      selftests/bpf: verifier/ctx_sk_msg.c converted to inline assembly
      selftests/bpf: verifier/direct_stack_access_wraparound.c converted to inline assembly
      selftests/bpf: verifier/div0.c converted to inline assembly
      selftests/bpf: verifier/div_overflow.c converted to inline assembly
      selftests/bpf: verifier/helper_access_var_len.c converted to inline assembly
      selftests/bpf: verifier/helper_packet_access.c converted to inline assembly
      selftests/bpf: verifier/helper_restricted.c converted to inline assembly
      selftests/bpf: verifier/helper_value_access.c converted to inline assembly
      selftests/bpf: verifier/int_ptr.c converted to inline assembly
      selftests/bpf: verifier/ld_ind.c converted to inline assembly
      selftests/bpf: verifier/leak_ptr.c converted to inline assembly
      selftests/bpf: verifier/map_ptr.c converted to inline assembly
      selftests/bpf: verifier/map_ret_val.c converted to inline assembly
      selftests/bpf: verifier/masking.c converted to inline assembly
      selftests/bpf: verifier/meta_access.c converted to inline assembly
      selftests/bpf: verifier/raw_stack.c converted to inline assembly
      selftests/bpf: verifier/raw_tp_writable.c converted to inline assembly
      selftests/bpf: verifier/ringbuf.c converted to inline assembly
      selftests/bpf: verifier/spill_fill.c converted to inline assembly
      selftests/bpf: verifier/stack_ptr.c converted to inline assembly
      selftests/bpf: verifier/uninit.c converted to inline assembly
      selftests/bpf: verifier/value_adj_spill.c converted to inline assembly
      selftests/bpf: verifier/value.c converted to inline assembly
      selftests/bpf: verifier/value_or_null.c converted to inline assembly
      selftests/bpf: verifier/var_off.c converted to inline assembly
      selftests/bpf: verifier/xadd.c converted to inline assembly
      selftests/bpf: verifier/xdp.c converted to inline assembly
      libbpf: Fix double-free when linker processes empty sections
      selftests/bpf: Verifier/xdp_direct_packet_access.c converted to inline assembly
      selftests/bpf: Remove verifier/xdp_direct_packet_access.c, converted to progs/verifier_xdp_direct_packet_access.c
      selftests/bpf: Prevent infinite loop in veristat when base file is too short

Feng Zhou (2):
      bpf/btf: Fix is_int_ptr()
      selftests/bpf: Add test to access u32 ptr argument in tracing program

Hao Zeng (1):
      samples/bpf: Fix fout leak in hbm's run_bpf_prog

Hengqi Chen (1):
      selftests/bpf: Don't assume page size is 4096

Ilya Leoshkevich (1):
      selftests/bpf: Add RESOLVE_BTFIDS dependency to bpf_testmod.ko

JP Kobryn (3):
      bpf/selftests: coverage for bpf_map_ops errors
      bpf: return long from bpf_map_ops funcs
      libbpf: Ensure print callback usage is thread-safe

Jakub Kicinski (3):
      net: skbuff: rename __pkt_vlan_present_offset to __mono_tc_offset
      net: skbuff: reorder bytes 2 and 3 of the bitfield
      net: skbuff: move the fields BPF cares about directly next to the offset marker

James Hilliard (1):
      selftests/bpf: Fix conflicts with built-in functions in bench_local_storage_create

Jiri Olsa (4):
      selftests/bpf: Add err.h header
      selftests/bpf: Add read_build_id function
      selftests/bpf: Replace extract_build_id with read_build_id
      kallsyms: Disable preemption for find_kallsyms_symbol_value

Kal Conley (9):
      selftests: xsk: Add xskxceiver.h dependency to Makefile
      selftests: xsk: Use correct UMEM size in testapp_invalid_desc
      selftests: xsk: Add test case for packets at end of UMEM
      selftests: xsk: Disable IPv6 on VETH1
      selftests: xsk: Deflakify STATS_RX_DROPPED test
      xsk: Fix unaligned descriptor validation
      selftests: xsk: Add test UNALIGNED_INV_DESC_4K1_FRAME_SIZE
      xsk: Simplify xp_aligned_validate_desc implementation
      xsk: Elide base_addr comparison in xp_unaligned_validate_desc

Kui-Feng Lee (8):
      bpf: Retire the struct_ops map kvalue->refcnt.
      net: Update an existing TCP congestion control algorithm.
      bpf: Create links for BPF struct_ops maps.
      libbpf: Create a bpf_link in bpf_map__attach_struct_ops().
      bpf: Update the struct_ops of a bpf_link.
      libbpf: Update a bpf_link with another struct_ops.
      libbpf: Use .struct_ops.link section to indicate a struct_ops with a link.
      selftests/bpf: Test switching TCP Congestion Control algorithms.

Liu Pan (1):
      libbpf: Explicitly call write to append content to file

Lorenz Bauer (1):
      selftests/bpf: Fix use of uninitialized op_name in log tests

Lorenzo Bianconi (2):
      selftests/bpf: Use ifname instead of ifindex in XDP compliance test tool
      selftests/bpf: Improve error logs in XDP compliance test tool

Luis Gerhorst (1):
      bpf: Remove misleading spec_v1 check on var-offset stack read

Manu Bretelle (3):
      selftests/bpf: Add --json-summary option to test_progs
      tools: bpftool: json: Fix backslash escape typo in jsonw_puts
      selftests/bpf: Reset err when symbol name already exist in kprobe_multi_test

Martin KaFai Lau (29):
      selftests/bpf: Fix flaky fib_lookup test
      bpf: Move a few bpf_local_storage functions to static scope
      bpf: Refactor codes into bpf_local_storage_destroy
      bpf: Remove __bpf_local_storage_map_alloc
      bpf: Remove the preceding __ from __bpf_selem_unlink_storage
      bpf: Remember smap in bpf_local_storage
      bpf: Repurpose use_trace_rcu to reuse_now in bpf_local_storage
      bpf: Remove bpf_selem_free_fields*_rcu
      bpf: Add bpf_selem_free_rcu callback
      bpf: Add bpf_selem_free()
      bpf: Add bpf_local_storage_rcu callback
      bpf: Add bpf_local_storage_free()
      selftests/bpf: Replace CHECK with ASSERT in test_local_storage
      selftests/bpf: Check freeing sk->sk_local_storage with sk_local_storage->smap is NULL
      selftests/bpf: Add local-storage-create benchmark
      Merge branch 'bpf: Allow helpers access ptr_to_btf_id.'
      selftests/bpf: Use ASSERT_EQ instead ASSERT_OK for testing memcmp result
      selftests/bpf: Fix a fd leak in an error path in network_helpers.c
      Merge branch 'net: skbuff: skb bitfield compaction - bpf'
      Merge branch 'Transit between BPF TCP congestion controls.'
      bpf: Check IS_ERR for the bpf_map_get() return value
      bpf: Add a few bpf mem allocator functions
      bpf: Use bpf_mem_cache_alloc/free in bpf_local_storage_elem
      bpf: Use bpf_mem_cache_alloc/free for bpf_local_storage
      selftests/bpf: Test task storage when local_storage->smap is NULL
      selftests/bpf: Add bench for task storage creation
      Merge branch 'Allow BPF TCP CCs to write app_limited'
      Merge branch 'selftests: xsk: Add test case for packets at end of UMEM'
      Merge branch 'xsk: Fix unaligned descriptor validation'

Michael Weiß (1):
      bpf: Fix a typo for BPF_F_ANY_ALIGNMENT in bpf.h

Nuno Gonçalves (1):
      xsk: allow remap of fill and/or completion rings

Quentin Monnet (7):
      bpftool: Fix documentation about line info display for prog dumps
      bpftool: Fix bug for long instructions in program CFG dumps
      bpftool: Support inline annotations when dumping the CFG of a program
      bpftool: Return an error on prog dumps if both CFG and JSON are required
      bpftool: Support "opcodes", "linum", "visual" simultaneously
      bpftool: Support printing opcodes and source file references in CFG
      bpftool: Clean up _bpftool_once_attr() calls in bash completion

Ross Zwisler (2):
      bpf: use canonical ftrace path
      selftests/bpf: use canonical ftrace path

Song Liu (4):
      selftests/bpf: Use PERF_COUNT_HW_CPU_CYCLES event for get_branch_snapshot
      selftests/bpf: Use read_perf_max_sample_freq() in perf_event_stackmap
      selftests/bpf: Fix leaked bpf_link in get_stackid_cannot_attach
      selftests/bpf: Keep the loop in bpf_testmod_loop_test

Sreevani Sreejith (1):
      bpf, docs: Libbpf overview documentation

Tejun Heo (1):
      cgroup: Make current_cgns_cgroup_dfl() safe to call after exit_task_namespace()

Tushar Vyavahare (1):
      selftests/xsk: add xdp populate metadata test

Viktor Malik (4):
      bpf: Fix attaching fentry/fexit/fmod_ret/lsm to modules
      bpf/selftests: Test fentry attachment to shadowed functions
      kallsyms, bpf: Move find_kallsyms_symbol_value out of internal header
      kallsyms: move module-related functions under correct configs

Wei Yongjun (1):
      bpftool: Set program type only if it differs from the desired one

Xin Liu (1):
      bpf, sockmap: fix deadlocks in the sockhash and sockmap

Xu Kuohai (2):
      selftests/bpf: Check when bounds are not in the 32-bit range
      selftests/bpf: Rewrite two infinite loops in bound check cases

YiFei Zhu (1):
      selftests/bpf: Wait for receive in cg_storage_multi test

Yixin Shen (2):
      bpf: allow a TCP CC to write app_limited
      selftests/bpf: test a BPF CC writing app_limited

Yonghong Song (5):
      selftests/bpf: Workaround verification failure for fexit_bpf2bpf/func_replace_return_code
      bpf: Improve verifier JEQ/JNE insn branch taken checking
      selftests/bpf: Add tests for non-constant cond_op NE/EQ bound deduction
      bpf: Improve handling of pattern '<const> <cond_op> <non_const>' in verifier
      selftests/bpf: Add verifier tests for code pattern '<const> <cond_op> <non_const>'

 Documentation/bpf/bpf_devel_QA.rst                 |   20 +-
 Documentation/bpf/clang-notes.rst                  |    6 +
 Documentation/bpf/cpumasks.rst                     |   30 +-
 Documentation/bpf/instruction-set.rst              |  129 +-
 Documentation/bpf/kfuncs.rst                       |  124 +-
 Documentation/bpf/libbpf/index.rst                 |   25 +-
 Documentation/bpf/libbpf/libbpf_overview.rst       |  228 +++
 Documentation/bpf/linux-notes.rst                  |   30 +
 drivers/hid/bpf/hid_bpf_dispatch.c                 |    3 -
 include/linux/bpf.h                                |   54 +-
 include/linux/bpf_local_storage.h                  |   19 +-
 include/linux/bpf_mem_alloc.h                      |    2 +
 include/linux/bpf_verifier.h                       |   72 +-
 include/linux/btf.h                                |    8 +-
 include/linux/filter.h                             |    9 +-
 include/linux/module.h                             |  127 +-
 include/linux/sched.h                              |    7 +-
 include/linux/skbuff.h                             |   40 +-
 include/net/fou.h                                  |    2 +
 include/net/ip_tunnels.h                           |   28 +-
 include/net/tcp.h                                  |    3 +
 include/net/xdp.h                                  |   29 -
 include/net/xsk_buff_pool.h                        |    9 +-
 include/uapi/linux/bpf.h                           |   61 +-
 kernel/bpf/Makefile                                |    3 +-
 kernel/bpf/arraymap.c                              |   12 +-
 kernel/bpf/bloom_filter.c                          |   29 +-
 kernel/bpf/bpf_cgrp_storage.c                      |   23 +-
 kernel/bpf/bpf_inode_storage.c                     |   22 +-
 kernel/bpf/bpf_iter.c                              |   70 +
 kernel/bpf/bpf_local_storage.c                     |  382 +++--
 kernel/bpf/bpf_struct_ops.c                        |  260 ++-
 kernel/bpf/bpf_task_storage.c                      |   27 +-
 kernel/bpf/btf.c                                   |  279 +++-
 kernel/bpf/cpumap.c                                |    8 +-
 kernel/bpf/cpumask.c                               |   43 +-
 kernel/bpf/devmap.c                                |   24 +-
 kernel/bpf/hashtab.c                               |   38 +-
 kernel/bpf/helpers.c                               |  139 +-
 kernel/bpf/local_storage.c                         |    6 +-
 kernel/bpf/log.c                                   |  330 ++++
 kernel/bpf/lpm_trie.c                              |    6 +-
 kernel/bpf/memalloc.c                              |   59 +-
 kernel/bpf/queue_stack_maps.c                      |   22 +-
 kernel/bpf/reuseport_array.c                       |    2 +-
 kernel/bpf/ringbuf.c                               |    6 +-
 kernel/bpf/stackmap.c                              |    6 +-
 kernel/bpf/syscall.c                               |  112 +-
 kernel/bpf/trampoline.c                            |   28 -
 kernel/bpf/verifier.c                              | 1096 ++++++++++---
 kernel/cgroup/cgroup.c                             |   14 +-
 kernel/module/internal.h                           |    1 -
 kernel/module/kallsyms.c                           |   16 +-
 mm/maccess.c                                       |   16 +-
 mm/usercopy.c                                      |    2 +-
 net/bpf/bpf_dummy_struct_ops.c                     |   14 +-
 net/bpf/test_run.c                                 |   34 +-
 net/core/bpf_sk_storage.c                          |   24 +-
 net/core/filter.c                                  |   29 +-
 net/core/sock_map.c                                |    8 +-
 net/core/xdp.c                                     |   19 +-
 net/ipv4/Makefile                                  |    2 +-
 net/ipv4/bpf_tcp_ca.c                              |   23 +-
 net/ipv4/fou_bpf.c                                 |  119 ++
 net/ipv4/fou_core.c                                |    5 +
 net/ipv4/ip_tunnel.c                               |   22 +-
 net/ipv4/ipip.c                                    |    1 +
 net/ipv4/tcp_cong.c                                |   66 +-
 net/ipv6/sit.c                                     |    2 +-
 net/netfilter/nf_conntrack_bpf.c                   |    5 +-
 net/xdp/xsk.c                                      |    9 +-
 net/xdp/xsk_queue.h                                |   19 +-
 net/xdp/xskmap.c                                   |    8 +-
 samples/bpf/cpustat_kern.c                         |    4 +-
 samples/bpf/hbm.c                                  |    5 +-
 samples/bpf/ibumad_kern.c                          |    4 +-
 samples/bpf/lwt_len_hist.sh                        |    2 +-
 samples/bpf/offwaketime_kern.c                     |    2 +-
 samples/bpf/task_fd_query_user.c                   |    4 +-
 samples/bpf/test_lwt_bpf.sh                        |    2 +-
 samples/bpf/test_overhead_tp.bpf.c                 |    4 +-
 scripts/bpf_doc.py                                 |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   18 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   42 +-
 tools/bpf/bpftool/btf_dumper.c                     |   83 +
 tools/bpf/bpftool/cfg.c                            |   29 +-
 tools/bpf/bpftool/cfg.h                            |    5 +-
 tools/bpf/bpftool/json_writer.c                    |    2 +-
 tools/bpf/bpftool/json_writer.h                    |    1 +
 tools/bpf/bpftool/main.h                           |    2 +
 tools/bpf/bpftool/prog.c                           |   81 +-
 tools/bpf/bpftool/xlated_dumper.c                  |   54 +-
 tools/bpf/bpftool/xlated_dumper.h                  |    3 +-
 tools/include/uapi/linux/bpf.h                     |   61 +-
 tools/lib/bpf/bpf.c                                |   25 +-
 tools/lib/bpf/bpf.h                                |   25 +-
 tools/lib/bpf/bpf_gen_internal.h                   |    4 +-
 tools/lib/bpf/bpf_helpers.h                        |    5 +
 tools/lib/bpf/gen_loader.c                         |   48 +-
 tools/lib/bpf/libbpf.c                             |  245 ++-
 tools/lib/bpf/libbpf.h                             |    3 +
 tools/lib/bpf/libbpf.map                           |    1 +
 tools/lib/bpf/linker.c                             |   14 +-
 tools/lib/bpf/zip.c                                |    6 +
 tools/testing/selftests/bpf/DENYLIST.aarch64       |    1 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |    2 +
 tools/testing/selftests/bpf/Makefile               |   22 +-
 tools/testing/selftests/bpf/autoconf_helper.h      |    9 +
 tools/testing/selftests/bpf/bench.c                |    4 +
 .../bpf/benchs/bench_local_storage_create.c        |  264 +++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |   60 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.h        |    6 +
 tools/testing/selftests/bpf/get_cgroup_id_user.c   |    9 +-
 tools/testing/selftests/bpf/json_writer.c          |    1 +
 tools/testing/selftests/bpf/json_writer.h          |    1 +
 tools/testing/selftests/bpf/network_helpers.c      |    2 +-
 tools/testing/selftests/bpf/prog_tests/align.c     |    4 +-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |  160 ++
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |    6 +
 .../selftests/bpf/prog_tests/cg_storage_multi.c    |    8 +-
 tools/testing/selftests/bpf/prog_tests/cpumask.c   |    2 +-
 .../testing/selftests/bpf/prog_tests/ctx_rewrite.c |   14 +-
 .../testing/selftests/bpf/prog_tests/fib_lookup.c  |   12 +-
 .../selftests/bpf/prog_tests/get_branch_snapshot.c |    4 +-
 .../bpf/prog_tests/get_stackid_cannot_attach.c     |    1 +
 tools/testing/selftests/bpf/prog_tests/iters.c     |  106 ++
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |   11 +-
 .../selftests/bpf/prog_tests/local_kptr_stash.c    |   60 +
 tools/testing/selftests/bpf/prog_tests/log_fixup.c |    1 +
 tools/testing/selftests/bpf/prog_tests/map_ops.c   |  162 ++
 .../bpf/prog_tests/module_fentry_shadow.c          |  128 ++
 .../selftests/bpf/prog_tests/perf_event_stackmap.c |    3 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |    6 +-
 .../selftests/bpf/prog_tests/stacktrace_build_id.c |   19 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |   32 +-
 .../selftests/bpf/prog_tests/task_fd_query_tp.c    |    9 +-
 .../testing/selftests/bpf/prog_tests/task_kfunc.c  |    3 +-
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |    4 +-
 .../selftests/bpf/prog_tests/test_local_storage.c  |   54 +-
 .../testing/selftests/bpf/prog_tests/test_tunnel.c |  153 +-
 .../selftests/bpf/prog_tests/tp_attach_query.c     |    9 +-
 .../selftests/bpf/prog_tests/trace_printk.c        |   10 +-
 .../selftests/bpf/prog_tests/trace_vprintk.c       |   10 +-
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   |    1 -
 tools/testing/selftests/bpf/prog_tests/verifier.c  |  108 ++
 .../selftests/bpf/prog_tests/verifier_log.c        |  450 +++++
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |    7 +-
 .../bpf/progs/bench_local_storage_create.c         |   82 +
 tools/testing/selftests/bpf/progs/bpf_iter_ksym.c  |    1 -
 .../selftests/bpf/progs/bpf_iter_setsockopt.c      |    1 -
 tools/testing/selftests/bpf/progs/bpf_loop.c       |    2 -
 tools/testing/selftests/bpf/progs/bpf_misc.h       |  148 ++
 tools/testing/selftests/bpf/progs/cb_refs.c        |    1 -
 .../bpf/progs/cgroup_skb_sk_lookup_kern.c          |    1 -
 .../selftests/bpf/progs/cgrp_kfunc_common.h        |    8 +-
 .../selftests/bpf/progs/cgrp_kfunc_failure.c       |  104 +-
 .../selftests/bpf/progs/cgrp_kfunc_success.c       |   15 +-
 .../selftests/bpf/progs/cgrp_ls_attach_cgroup.c    |    1 -
 .../selftests/bpf/progs/cgrp_ls_sleepable.c        |    1 -
 tools/testing/selftests/bpf/progs/connect4_prog.c  |    2 +-
 tools/testing/selftests/bpf/progs/core_kern.c      |    2 +-
 tools/testing/selftests/bpf/progs/cpumask_common.h |    7 +-
 .../testing/selftests/bpf/progs/cpumask_failure.c  |   96 +-
 .../testing/selftests/bpf/progs/cpumask_success.c  |   30 +-
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |    5 +-
 tools/testing/selftests/bpf/progs/dynptr_success.c |    5 +-
 tools/testing/selftests/bpf/progs/err.h            |   18 +
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c  |    2 -
 .../selftests/bpf/progs/freplace_attach_probe.c    |    2 +-
 tools/testing/selftests/bpf/progs/iters.c          |  719 ++++++++
 tools/testing/selftests/bpf/progs/iters_looping.c  |  163 ++
 tools/testing/selftests/bpf/progs/iters_num.c      |  242 +++
 .../selftests/bpf/progs/iters_state_safety.c       |  426 +++++
 .../selftests/bpf/progs/iters_testmod_seq.c        |   79 +
 tools/testing/selftests/bpf/progs/linked_funcs1.c  |    3 +
 tools/testing/selftests/bpf/progs/linked_funcs2.c  |    3 +
 tools/testing/selftests/bpf/progs/linked_list.c    |    4 -
 .../testing/selftests/bpf/progs/linked_list_fail.c |    1 -
 .../testing/selftests/bpf/progs/local_kptr_stash.c |  108 ++
 tools/testing/selftests/bpf/progs/local_storage.c  |   76 +-
 tools/testing/selftests/bpf/progs/loop6.c          |    3 +
 tools/testing/selftests/bpf/progs/lsm.c            |    4 +-
 tools/testing/selftests/bpf/progs/map_kptr.c       |    3 -
 tools/testing/selftests/bpf/progs/map_kptr_fail.c  |   23 +
 tools/testing/selftests/bpf/progs/netcnt_prog.c    |    1 -
 .../selftests/bpf/progs/netif_receive_skb.c        |    1 -
 tools/testing/selftests/bpf/progs/perfbuf_bench.c  |    1 -
 tools/testing/selftests/bpf/progs/profiler.inc.h   |    3 +-
 tools/testing/selftests/bpf/progs/pyperf.h         |   16 +-
 tools/testing/selftests/bpf/progs/pyperf600_iter.c |    7 +
 .../selftests/bpf/progs/pyperf600_nounroll.c       |    3 -
 .../bpf/progs/rbtree_btf_fail__wrong_node_type.c   |   11 -
 tools/testing/selftests/bpf/progs/rbtree_fail.c    |    3 +-
 tools/testing/selftests/bpf/progs/rcu_read_lock.c  |   13 +-
 .../bpf/progs/read_bpf_task_storage_busy.c         |    1 -
 tools/testing/selftests/bpf/progs/recvmsg4_prog.c  |    2 -
 tools/testing/selftests/bpf/progs/recvmsg6_prog.c  |    2 -
 tools/testing/selftests/bpf/progs/sendmsg4_prog.c  |    2 -
 .../selftests/bpf/progs/sockmap_verdict_prog.c     |    4 +
 tools/testing/selftests/bpf/progs/strobemeta.h     |    1 -
 .../selftests/bpf/progs/tailcall_bpf2bpf3.c        |   11 +
 .../selftests/bpf/progs/tailcall_bpf2bpf6.c        |    3 +
 .../selftests/bpf/progs/task_kfunc_common.h        |    6 +-
 .../selftests/bpf/progs/task_kfunc_failure.c       |  178 +-
 .../selftests/bpf/progs/task_kfunc_success.c       |   78 +-
 tools/testing/selftests/bpf/progs/tcp_ca_update.c  |   80 +
 .../selftests/bpf/progs/tcp_ca_write_sk_pacing.c   |   13 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |    1 -
 .../selftests/bpf/progs/test_cls_redirect_dynptr.c |    1 -
 .../bpf/progs/test_core_reloc_bitfields_probed.c   |    1 -
 .../selftests/bpf/progs/test_global_func1.c        |    4 +
 .../selftests/bpf/progs/test_global_func2.c        |    4 +
 .../selftests/bpf/progs/test_hash_large_key.c      |    2 +-
 .../bpf/progs/test_ksyms_btf_write_check.c         |    1 -
 .../testing/selftests/bpf/progs/test_ksyms_weak.c  |   17 +-
 .../selftests/bpf/progs/test_legacy_printk.c       |    2 +-
 tools/testing/selftests/bpf/progs/test_map_lock.c  |    2 +-
 tools/testing/selftests/bpf/progs/test_map_ops.c   |  138 ++
 tools/testing/selftests/bpf/progs/test_obj_id.c    |    2 +
 .../selftests/bpf/progs/test_parse_tcp_hdr_opt.c   |    1 -
 .../bpf/progs/test_parse_tcp_hdr_opt_dynptr.c      |    2 +-
 .../testing/selftests/bpf/progs/test_pkt_access.c  |    5 +
 tools/testing/selftests/bpf/progs/test_ringbuf.c   |    1 -
 .../selftests/bpf/progs/test_ringbuf_map_key.c     |    1 +
 .../selftests/bpf/progs/test_ringbuf_multi.c       |    1 -
 .../bpf/progs/test_select_reuseport_kern.c         |    2 +-
 tools/testing/selftests/bpf/progs/test_sk_assign.c |    4 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |    9 +-
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |    2 -
 .../selftests/bpf/progs/test_sk_storage_tracing.c  |   16 +
 .../testing/selftests/bpf/progs/test_sock_fields.c |    2 +-
 .../selftests/bpf/progs/test_sockmap_kern.h        |   14 +-
 tools/testing/selftests/bpf/progs/test_spin_lock.c |    3 +
 .../selftests/bpf/progs/test_stacktrace_map.c      |    2 +-
 tools/testing/selftests/bpf/progs/test_tc_dtime.c  |    4 +-
 tools/testing/selftests/bpf/progs/test_tc_neigh.c  |    4 +-
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |    2 -
 .../testing/selftests/bpf/progs/test_tracepoint.c  |    2 +-
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |  123 +-
 .../selftests/bpf/progs/test_usdt_multispec.c      |    2 -
 .../selftests/bpf/progs/test_verif_scale1.c        |    2 +-
 .../selftests/bpf/progs/test_verif_scale2.c        |    2 +-
 .../selftests/bpf/progs/test_verif_scale3.c        |    2 +-
 .../bpf/progs/test_xdp_adjust_tail_grow.c          |    2 -
 .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |    2 -
 .../selftests/bpf/progs/test_xdp_do_redirect.c     |   38 +-
 .../testing/selftests/bpf/progs/test_xdp_dynptr.c  |    2 -
 .../selftests/bpf/progs/test_xdp_noinline.c        |   43 -
 tools/testing/selftests/bpf/progs/test_xdp_vlan.c  |   13 -
 tools/testing/selftests/bpf/progs/type_cast.c      |    1 -
 tools/testing/selftests/bpf/progs/udp_limit.c      |    2 -
 .../selftests/bpf/progs/user_ringbuf_success.c     |    6 -
 tools/testing/selftests/bpf/progs/verifier_and.c   |  107 ++
 .../selftests/bpf/progs/verifier_array_access.c    |  529 ++++++
 .../selftests/bpf/progs/verifier_basic_stack.c     |  100 ++
 .../bpf/progs/verifier_bounds_deduction.c          |  171 ++
 .../progs/verifier_bounds_deduction_non_const.c    |  639 ++++++++
 .../bpf/progs/verifier_bounds_mix_sign_unsign.c    |  554 +++++++
 tools/testing/selftests/bpf/progs/verifier_cfg.c   |  100 ++
 .../bpf/progs/verifier_cgroup_inv_retcode.c        |   89 +
 .../selftests/bpf/progs/verifier_cgroup_skb.c      |  227 +++
 .../selftests/bpf/progs/verifier_cgroup_storage.c  |  308 ++++
 .../selftests/bpf/progs/verifier_const_or.c        |   82 +
 .../selftests/bpf/progs/verifier_ctx_sk_msg.c      |  228 +++
 .../verifier_direct_stack_access_wraparound.c      |   56 +
 tools/testing/selftests/bpf/progs/verifier_div0.c  |  213 +++
 .../selftests/bpf/progs/verifier_div_overflow.c    |  144 ++
 .../bpf/progs/verifier_helper_access_var_len.c     |  825 ++++++++++
 .../bpf/progs/verifier_helper_packet_access.c      |  550 +++++++
 .../bpf/progs/verifier_helper_restricted.c         |  279 ++++
 .../bpf/progs/verifier_helper_value_access.c       | 1245 ++++++++++++++
 .../testing/selftests/bpf/progs/verifier_int_ptr.c |  157 ++
 .../testing/selftests/bpf/progs/verifier_ld_ind.c  |  110 ++
 .../selftests/bpf/progs/verifier_leak_ptr.c        |   92 ++
 .../testing/selftests/bpf/progs/verifier_map_ptr.c |  159 ++
 .../selftests/bpf/progs/verifier_map_ret_val.c     |  110 ++
 .../testing/selftests/bpf/progs/verifier_masking.c |  410 +++++
 .../selftests/bpf/progs/verifier_meta_access.c     |  284 ++++
 .../selftests/bpf/progs/verifier_raw_stack.c       |  371 +++++
 .../selftests/bpf/progs/verifier_raw_tp_writable.c |   50 +
 .../testing/selftests/bpf/progs/verifier_ringbuf.c |  131 ++
 .../selftests/bpf/progs/verifier_spill_fill.c      |  374 +++++
 .../selftests/bpf/progs/verifier_stack_ptr.c       |  484 ++++++
 .../testing/selftests/bpf/progs/verifier_uninit.c  |   61 +
 tools/testing/selftests/bpf/progs/verifier_value.c |  158 ++
 .../selftests/bpf/progs/verifier_value_adj_spill.c |   78 +
 .../selftests/bpf/progs/verifier_value_or_null.c   |  288 ++++
 .../testing/selftests/bpf/progs/verifier_var_off.c |  349 ++++
 tools/testing/selftests/bpf/progs/verifier_xadd.c  |  124 ++
 tools/testing/selftests/bpf/progs/verifier_xdp.c   |   24 +
 .../bpf/progs/verifier_xdp_direct_packet_access.c  | 1722 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/xdp_features.c   |    1 -
 tools/testing/selftests/bpf/progs/xdping_kern.c    |    2 -
 tools/testing/selftests/bpf/progs/xdpwall.c        |    1 -
 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c  |   25 +
 tools/testing/selftests/bpf/test_ftrace.sh         |    7 +-
 tools/testing/selftests/bpf/test_loader.c          |  536 +++++-
 tools/testing/selftests/bpf/test_progs.c           |  108 +-
 tools/testing/selftests/bpf/test_progs.h           |    2 +-
 tools/testing/selftests/bpf/test_tunnel.sh         |   13 +-
 tools/testing/selftests/bpf/test_verifier.c        |   27 +-
 tools/testing/selftests/bpf/test_verifier_log.c    |  175 --
 tools/testing/selftests/bpf/test_xsk.sh            |    1 +
 tools/testing/selftests/bpf/testing_helpers.c      |   22 +-
 tools/testing/selftests/bpf/testing_helpers.h      |    2 +
 tools/testing/selftests/bpf/trace_helpers.c        |   90 +-
 tools/testing/selftests/bpf/trace_helpers.h        |    5 +
 tools/testing/selftests/bpf/unpriv_helpers.c       |   26 +
 tools/testing/selftests/bpf/unpriv_helpers.h       |    7 +
 tools/testing/selftests/bpf/verifier/and.c         |   68 -
 .../testing/selftests/bpf/verifier/array_access.c  |  379 -----
 tools/testing/selftests/bpf/verifier/basic_stack.c |   64 -
 tools/testing/selftests/bpf/verifier/bounds.c      |  129 ++
 .../selftests/bpf/verifier/bounds_deduction.c      |  136 --
 .../bpf/verifier/bounds_mix_sign_unsign.c          |  411 -----
 .../selftests/bpf/verifier/btf_ctx_access.c        |   13 +
 tools/testing/selftests/bpf/verifier/calls.c       |   10 +-
 tools/testing/selftests/bpf/verifier/cfg.c         |   73 -
 .../selftests/bpf/verifier/cgroup_inv_retcode.c    |   72 -
 tools/testing/selftests/bpf/verifier/cgroup_skb.c  |  197 ---
 .../selftests/bpf/verifier/cgroup_storage.c        |  220 ---
 tools/testing/selftests/bpf/verifier/const_or.c    |   60 -
 tools/testing/selftests/bpf/verifier/ctx_sk_msg.c  |  181 --
 .../bpf/verifier/direct_stack_access_wraparound.c  |   40 -
 tools/testing/selftests/bpf/verifier/div0.c        |  184 ---
 .../testing/selftests/bpf/verifier/div_overflow.c  |  110 --
 .../selftests/bpf/verifier/helper_access_var_len.c |  650 --------
 .../selftests/bpf/verifier/helper_packet_access.c  |  460 ------
 .../selftests/bpf/verifier/helper_restricted.c     |  196 ---
 .../selftests/bpf/verifier/helper_value_access.c   |  953 -----------
 tools/testing/selftests/bpf/verifier/int_ptr.c     |  161 --
 tools/testing/selftests/bpf/verifier/ld_ind.c      |   72 -
 tools/testing/selftests/bpf/verifier/leak_ptr.c    |   67 -
 tools/testing/selftests/bpf/verifier/map_ptr.c     |   99 --
 tools/testing/selftests/bpf/verifier/map_ret_val.c |   65 -
 tools/testing/selftests/bpf/verifier/masking.c     |  322 ----
 tools/testing/selftests/bpf/verifier/meta_access.c |  235 ---
 tools/testing/selftests/bpf/verifier/raw_stack.c   |  305 ----
 .../selftests/bpf/verifier/raw_tp_writable.c       |   35 -
 .../testing/selftests/bpf/verifier/ref_tracking.c  |    6 +-
 tools/testing/selftests/bpf/verifier/ringbuf.c     |   95 --
 tools/testing/selftests/bpf/verifier/spill_fill.c  |  345 ----
 tools/testing/selftests/bpf/verifier/stack_ptr.c   |  359 ----
 tools/testing/selftests/bpf/verifier/uninit.c      |   39 -
 tools/testing/selftests/bpf/verifier/value.c       |  104 --
 .../selftests/bpf/verifier/value_adj_spill.c       |   43 -
 .../testing/selftests/bpf/verifier/value_or_null.c |  220 ---
 tools/testing/selftests/bpf/verifier/var_off.c     |  291 ----
 tools/testing/selftests/bpf/verifier/xadd.c        |   97 --
 tools/testing/selftests/bpf/verifier/xdp.c         |   14 -
 .../bpf/verifier/xdp_direct_packet_access.c        | 1468 -----------------
 tools/testing/selftests/bpf/veristat.c             |  207 ++-
 tools/testing/selftests/bpf/xdp_features.c         |   67 +-
 tools/testing/selftests/bpf/xsk_xdp_metadata.h     |    5 +
 tools/testing/selftests/bpf/xskxceiver.c           |   96 +-
 tools/testing/selftests/bpf/xskxceiver.h           |    4 +-
 356 files changed, 21786 insertions(+), 11275 deletions(-)
 create mode 100644 Documentation/bpf/libbpf/libbpf_overview.rst
 create mode 100644 kernel/bpf/log.c
 create mode 100644 net/ipv4/fou_bpf.c
 create mode 100644 tools/testing/selftests/bpf/autoconf_helper.h
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_local_storage_create.c
 create mode 120000 tools/testing/selftests/bpf/json_writer.c
 create mode 120000 tools/testing/selftests/bpf/json_writer.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/iters.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/local_kptr_stash.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/module_fentry_shadow.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verifier.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verifier_log.c
 create mode 100644 tools/testing/selftests/bpf/progs/bench_local_storage_create.c
 create mode 100644 tools/testing/selftests/bpf/progs/err.h
 create mode 100644 tools/testing/selftests/bpf/progs/iters.c
 create mode 100644 tools/testing/selftests/bpf/progs/iters_looping.c
 create mode 100644 tools/testing/selftests/bpf/progs/iters_num.c
 create mode 100644 tools/testing/selftests/bpf/progs/iters_state_safety.c
 create mode 100644 tools/testing/selftests/bpf/progs/iters_testmod_seq.c
 create mode 100644 tools/testing/selftests/bpf/progs/local_kptr_stash.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf600_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_ca_update.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_map_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_and.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_array_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_basic_stack.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_bounds_deduction.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_bounds_deduction_non_const.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_bounds_mix_sign_unsign.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_cfg.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_cgroup_inv_retcode.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_cgroup_skb.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_cgroup_storage.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_const_or.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_ctx_sk_msg.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_direct_stack_access_wraparound.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_div0.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_div_overflow.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_helper_access_var_len.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_helper_packet_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_helper_restricted.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_helper_value_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_int_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_ld_ind.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_leak_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_map_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_map_ret_val.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_masking.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_meta_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_raw_stack.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_raw_tp_writable.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_spill_fill.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_stack_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_uninit.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_value.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_value_adj_spill.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_value_or_null.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_var_off.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_xadd.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_xdp.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_xdp_direct_packet_access.c
 delete mode 100644 tools/testing/selftests/bpf/test_verifier_log.c
 create mode 100644 tools/testing/selftests/bpf/unpriv_helpers.c
 create mode 100644 tools/testing/selftests/bpf/unpriv_helpers.h
 delete mode 100644 tools/testing/selftests/bpf/verifier/and.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/array_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/basic_stack.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/bounds_deduction.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/cfg.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/cgroup_inv_retcode.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/cgroup_skb.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/cgroup_storage.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/const_or.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/ctx_sk_msg.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/direct_stack_access_wraparound.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/div0.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/div_overflow.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/helper_access_var_len.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/helper_packet_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/helper_restricted.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/helper_value_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/int_ptr.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/ld_ind.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/leak_ptr.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/map_ptr.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/map_ret_val.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/masking.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/meta_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/raw_stack.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/raw_tp_writable.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/ringbuf.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/spill_fill.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/stack_ptr.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/uninit.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/value.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/value_adj_spill.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/value_or_null.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/var_off.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/xadd.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/xdp.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c
 create mode 100644 tools/testing/selftests/bpf/xsk_xdp_metadata.h

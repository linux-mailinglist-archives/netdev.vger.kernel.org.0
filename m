Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A02618EF2
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiKDD1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiKDDZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:25:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E140763B4
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:25:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y65-20020a25c844000000b006bb773548d5so3852437ybf.5
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 20:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PUk/KzpzScQpgR6M7qGYfZX/G9X9dItCofF/HHylYj4=;
        b=gMWIfG1emRxrVj3GyaVOH00tmqqnQXYIzwJzyGg+LotRtT7/13UdKQCitTcq1lddFF
         w7YoyreI/+mDOVzPc/bFF8SQE/T7Z/8qGxTc0Fdq0c5HmeYGP5WVmosxwEcW3VDg9VL/
         gupQdFaR26PAjkrXLt0FYzyKaPNfJfTWqIUCDrbSiKJEHFao/OQfEgCYP29Uy6t5KaQN
         r0Rf+/FM0Lam4KlajBiPQwgeh1/5vK89s8U0CD6H5sYA2vz88FHawMAG7x8fpY6Q3W/i
         jhsbcRGsaS++U/GsdSLSbCoIdn+MzR15ZsorjSJNxkVZaC41STe9fVSsml7G7t7hU2oO
         SRUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PUk/KzpzScQpgR6M7qGYfZX/G9X9dItCofF/HHylYj4=;
        b=OxVSrtnX2ztI9owFouEE78OMgbnmg0HfyZv53PJxwEsqrXqkD2zY/MrFSCCama4kFJ
         4hCZK4c+fEyd/jsazgMimSPNNAn88f6o2sUS7JvqwfJvfgYOlpHAzc0WxBbsk7HRsBqk
         uoBfbZso8aMvlzPLoH1IQp59uTf7UR7uNcZJYdfDQHrBw/n/HFVKob/v7f74pwwF9xaJ
         flsdIbmm87Kjgl6iflcnQrZpiN3M8O1OFgGa721yIa8uHg0CXt/Mm2Nvb9jFE4V4p+gR
         QCDtKHg8LihrM2m0CgLDt6pSnDvdZwqA9O8gAPgAcfBYp4f6+Ug1dlP/9oecSgLWQ4Yk
         mMyw==
X-Gm-Message-State: ACrzQf0SHoU8+iONl5SgeAisXnnVKiOhZEtbvBL4jKJS4KISSwjQpCLF
        cbIKYIo2KET4q5AjZ0ymowoaIws=
X-Google-Smtp-Source: AMsMyM7zc6prS8uR4b3KOrhY0adVhR9NmhhrHCa3CBp7mSaJS3isYh571BeYQWM6TiZfTQQ1/Yt3ojg=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a0d:e647:0:b0:36f:f93f:7f7d with SMTP id
 p68-20020a0de647000000b0036ff93f7f7dmr33503616ywe.149.1667532334126; Thu, 03
 Nov 2022 20:25:34 -0700 (PDT)
Date:   Thu,  3 Nov 2022 20:25:18 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104032532.1615099-1-sdf@google.com>
Subject: [RFC bpf-next v2 00/14] xdp: hints via kfuncs
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since the original RFC:

- 'struct bpf_patch' to more easily manage insn arrays

  While working on longer unrolled functions I've bumped into verifier's
  insn_buf[16]. Instead of increasing it, I've added a simple
  abstraction that handles resizing.

  *insn++ = BPF_XXX_XXX();
  *insn++ = BPF_YYY_YYY();

  vs

  bpf_patch_append(patch,
          BPF_XXX_XXX(),
          BPF_YYY_YYY(),
  );

  There are also some tricks where we resolve BPF_JMP_IMM(op, dst, imm,
  S16_MAX) to the real end of the program; mostly to make it easy to generate
  the following:

  if (some_condition) {
          if (some_other_condition) {
                  // insns
          }
  }

- Drop xdp_buff->priv in favor of container_of (Jakub)

  The drivers might need to maintain more data, so instead of
  constraining them to a single ->priv pointer in xdp_buff, use container_of
  and require the users to define the outer struct. xdp_buff should
  be the first member.

  Each driver now has two patches: the first one introduces new struct
  wrapper; the second one does the actual work.

- bpf_xdp_metadata_export_to_skb (Toke)

  To solve the case where we're constructing skb from a redirected
  frame. bpf_xdp_metadata_export_to_skb is an unrolled kfunc
  that prepares 'struct xdp_to_skb_metadata' in the metadata.
  The layout is randomized and it has a randomized magic number
  to make sure userspace doesn't depend on it. I'm not sure how
  strict we should be here? Toke/Jesper seem to be ok with
  userspace depending on this but as long as they read the
  layout via BTF, so maybe having a fixed magic is ok/better her?

  Later, at skb_metadata_set time, we call into
  skb_metadata_import_from_xdp that tries to parse this fixed format
  and extract relevant metadata.

  Note that because we are unrolling bpf_xdp_metadata_export_to_skb,
  we have to constrain other kfuncs to R2-R5 only; I've added the
  reasoning to the comments. It might be better idea to do a real
  kfunc call (but we have to generate this kfunc anyway)?

- helper to make it easier to call kernel code from unrolled kfuncs

  Since we're unrolling, we're running in a somewhat constrained
  environment. R6-R9 belong to the real callee, so we can't use them
  to stash our R1-R5. We also can't use stack in any way. Another
  constraint comes from bpf_xdp_metadata_export_to_skb which
  might call several metadata kfuncs and wants its R1 to be preserved.

  Thus, we add xdp_kfunc_call_preserving_r1, which generates the
  bytecode to preserve r1 somewhere in the user-supplied context.

  Again, we have to do this because we unroll bpf_xdp_metadata_export_to_skb.

- mlx4/bnxt/ice examples (Jesper)

  ice is the only one where it seems feasible to unroll. The code is
  untested, but at least it shows that it's somewhat possible to
  get to the timestamp in our R2-R5-constrained environment.

  mlx4/bnxt do spinlocks/seqlocks, so I'm just calling into the kernel
  code.

- Unroll default implementation to return false/0/NULL

  Original RFC left default kfuncs calls when the driver doesn't
  do the unrolling. Here, instead, we unroll to single 'return 0'
  instruction.

- Drop prog_ifindex libbpf patch, use bpf_program__set_ifindex instead (Andrii)

- Keep returning metadata by value instead of using a pointer

  I've tried using the pointer, it works currently, but it requires extra
  argument per commit eb1f7f71c126 ("bpf/verifier: allow kfunc to return
  an allocated mem"). The requirement can probably be lifted for our
  case, but not sure it's necessary for now.

  While adding rx_timestamp support for the drivers, it turns out
  we never really return the raw pointer to the descriptor field. We read
  the descriptor field, do shifts/multiplies, convert to kernel clock,
  etc/etc. So returning a value instead of a pointer seems more logical,
  at least for the rx timestamp case. For the other types of metadata,
  we might reconsider.

- rename bpf_xdp_metadata_have_<xxx> to bpf_xdp_metadata_<xxx>_supported

  Spotted in one of Toke's emails. Seems like it better conveys
  the intent that it actually tests that the device supports the
  metadata, not that the particular packet has the metadata.

The following is unchanged since the original RFC:

This is an RFC for the alternative approach suggested by Martin and
Jakub. I've tried to CC most of the people from the original discussion,
feel free to add more if you think I've missed somebody.

Summary:
- add new BPF_F_XDP_HAS_METADATA program flag and abuse
  attr->prog_ifindex to pass target device ifindex at load time
- at load time, find appropriate ndo_unroll_kfunc and call
  it to unroll/inline kfuncs; kfuncs have the default "safe"
  implementation if unrolling is not supported by a particular
  device
- rewrite xskxceiver test to use C bpf program and extend
  it to export rx_timestamp (plus add rx timestamp to veth driver)

I've intentionally kept it small and hacky to see whether the approach is
workable or not.

Pros:
- we avoid BTF complexity; the BPF programs themselves are now responsible
  for agreeing on the metadata layout with the AF_XDP consumer
- the metadata is free if not used
- the metadata should, in theory, be cheap if used; kfuncs should be
  unrolled to the same code as if the metadata was pre-populated and
  passed with a BTF id
- it's not all or nothing; users can use small subset of metadata which
  is more efficient than the BTF id approach where all metadata has to be
  exposed for every frame (and selectively consumed by the users)

Cons:
- forwarding has to be handled explicitly; the BPF programs have to
  agree on the metadata layout (IOW, the forwarding program
  has to be aware of the final AF_XDP consumer metadata layout)
- TX picture is not clear; but it's not clear with BTF ids as well;
  I think we've agreed that just reusing whatever we have at RX
  won't fly at TX; seems like TX XDP program might be the answer
  here? (with a set of another tx kfuncs to "expose" bpf/af_xdp metatata
  back into the kernel)

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org

Stanislav Fomichev (14):
  bpf: Introduce bpf_patch
  bpf: Support inlined/unrolled kfuncs for xdp metadata
  veth: Introduce veth_xdp_buff wrapper for xdp_buff
  veth: Support rx timestamp metadata for xdp
  selftests/bpf: Verify xdp_metadata xdp->af_xdp path
  xdp: Carry over xdp metadata into skb context
  selftests/bpf: Verify xdp_metadata xdp->skb path
  bpf: Helper to simplify calling kernel routines from unrolled kfuncs
  ice: Introduce ice_xdp_buff wrapper for xdp_buff
  ice: Support rx timestamp metadata for xdp
  mlx4: Introduce mlx4_xdp_buff wrapper for xdp_buff
  mxl4: Support rx timestamp metadata for xdp
  bnxt: Introduce bnxt_xdp_buff wrapper for xdp_buff
  bnxt: Support rx timestamp metadata for xdp

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  73 +++-
 drivers/net/ethernet/intel/ice/ice.h          |   5 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 105 ++++-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |   1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  66 ++-
 drivers/net/veth.c                            |  89 ++--
 include/linux/bpf.h                           |   1 +
 include/linux/bpf_patch.h                     |  29 ++
 include/linux/btf.h                           |   1 +
 include/linux/btf_ids.h                       |   4 +
 include/linux/mlx4/device.h                   |   7 +
 include/linux/netdevice.h                     |   5 +
 include/linux/skbuff.h                        |   4 +
 include/net/xdp.h                             |  41 ++
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/Makefile                           |   2 +-
 kernel/bpf/bpf_patch.c                        |  81 ++++
 kernel/bpf/syscall.c                          |  28 +-
 kernel/bpf/verifier.c                         |  85 ++++
 net/core/dev.c                                |   7 +
 net/core/skbuff.c                             |  25 ++
 net/core/xdp.c                                | 165 +++++++-
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c   | 394 ++++++++++++++++++
 .../selftests/bpf/progs/xdp_metadata.c        |  78 ++++
 27 files changed, 1244 insertions(+), 65 deletions(-)
 create mode 100644 include/linux/bpf_patch.h
 create mode 100644 kernel/bpf/bpf_patch.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c

-- 
2.38.1.431.g37b22c650d-goog


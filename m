Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4E362905C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237855AbiKODD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237221AbiKODDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:03:11 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B150DF0B
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:12 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id g6-20020a17090a300600b00212f609f6aeso6769058pjb.9
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jmoFjVUpIScIBXVlBGccTMF8ONCdDUS7UktVwh7iZmE=;
        b=Y1uFrunl6UnS9d2RPWNj2avXr22GuFyGPTISJ3LB3jEji0/Cc1h+fSpKSRPrl2HPOB
         WWyG+g6K4HVRRONXPZGgAkDmyEExMuVEXINiwO5WTqLT2NrZ2Ai7HjtpSIjtLyhMf27F
         J3OUh4vSWzB9iKzGRMpmqd/FD5vLmsgahGKlAapwK6RIRpbwra6Xv73VH/asKTPl44Ql
         GgLnQ9AvzpA06xQ5hewxqhJqXiR/RtS9Z5EwLvnfnkDxutNW+8FeTh/sZeyJoFoED7jV
         jDgDZp5IVlao/qyQgFM1JAxBHrGrFvMIfVK+DPFzLTCRpHaX8abEt/eImkwnN4AO4tFD
         M2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jmoFjVUpIScIBXVlBGccTMF8ONCdDUS7UktVwh7iZmE=;
        b=Pb3PnP4Ma4OrTEaX2hm09nVXOkmAXEVZcV3Q+L9/Ar2FeRDnPbRLq/Z6rgC7uOakUl
         hxuiR5gFofpa86u0ImNm6Wbnd/nMYAzASs2ZRQ6Jlt4Mcu5PF80csWq8pyVC5xXeCF4K
         Q5HXGL1X21+j9uem4QyRSWcL7Fch/oiF9Q4oYZY7MAydduxVSS3GhTn1GlVhxkPTuZAo
         RhLxpEa2kAsIIxdQyeM/ZOjN2pZflv2QOZcvrp/jsNCXFF7TlrPOt9Mo245h99EDFNK2
         Zl6p3WSAfb68OfC/d/kb0XFzAo4yTIxm9fTZrY2uNy2aryogtBQgYeStiExeQ3oMi6aV
         3xtA==
X-Gm-Message-State: ANoB5pkRUvInXzYDI77komKTIIIZMj8SL5CZZJp8IJAhA8sjqHr6o6qG
        8F/LO8wfN0yT98NIfg80waj51c0=
X-Google-Smtp-Source: AA0mqf7VU5XHuRqXRyQfM/PJ2eyCTEP96FM8RRPAA+2ZO/Hi8ZzOLB2rh5A/wMibAztCTehRhBbSDwo=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:aa7:8891:0:b0:562:9a93:7c91 with SMTP id
 z17-20020aa78891000000b005629a937c91mr16485801pfe.21.1668481332141; Mon, 14
 Nov 2022 19:02:12 -0800 (PST)
Date:   Mon, 14 Nov 2022 19:01:59 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115030210.3159213-1-sdf@google.com>
Subject: [PATCH bpf-next 00/11] xdp: hints via kfuncs
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

Please see the first patch in the series for the overall
design and use-cases.

Changes since last RFC:

- drop ice/bnxt example implementation (Alexander)

  -ENOHARDWARE to test

- fix/test mlx4 implementation

  Confirmed that I get reasonable looking timestamp.
  The last patch in the series is the small xsk program that can
  be used to dump incoming metadata.

- bpf_push64/bpf_pop64 (Alexei)

  x86_64+arm64(untested)+disassembler

- struct xdp_to_skb_metadata -> struct xdp_skb_metadata (Toke)

  s/xdp_to_skb/xdp_skb/

- Documentation/bpf/xdp-rx-metadata.rst

  Documents functionality, assumptions and limitations.

- bpf_xdp_metadata_export_to_skb returns true/false (Martin)

  Plus xdp_md->skb_metadata field to access it.

- BPF_F_XDP_HAS_METADATA flag (Toke/Martin)

  Drop magic, use the flag instead.

- drop __randomize_layout

  Not sure it's possible to sanely expose it via UAPI. Because every
  .o potentially gets its own randomized layout, test_progs
  refuses to link.

- remove __net_timestamp in veth driver (John/Jesper)

  Instead, calling ktime_get from the kfunc; enough for the selftests.

Future work on RX side:

- Support more devices besides veth and mlx4
- Support more metadata besides RX timestamp.
- Convert skb_metadata_set() callers to xdp_convert_skb_metadata()
  which handles extra xdp_skb_metadata

Prior art (to record pros/cons for different approaches):

- Stable UAPI approach:
  https://lore.kernel.org/bpf/20220628194812.1453059-1-alexandr.lobakin@intel.com/
- Metadata+BTF_ID appoach:
  https://lore.kernel.org/bpf/166256538687.1434226.15760041133601409770.stgit@firesoul/
- kfuncs v2 RFC:
  https://lore.kernel.org/bpf/20221027200019.4106375-1-sdf@google.com/
- kfuncs v1 RFC:
  https://lore.kernel.org/bpf/20221104032532.1615099-1-sdf@google.com/

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

Stanislav Fomichev (11):
  bpf: Document XDP RX metadata
  bpf: Introduce bpf_patch
  bpf: Support inlined/unrolled kfuncs for xdp metadata
  bpf: Implement hidden BPF_PUSH64 and BPF_POP64 instructions
  veth: Support rx timestamp metadata for xdp
  xdp: Carry over xdp metadata into skb context
  selftests/bpf: Verify xdp_metadata xdp->af_xdp path
  selftests/bpf: Verify xdp_metadata xdp->skb path
  mlx4: Introduce mlx4_xdp_buff wrapper for xdp_buff
  mxl4: Support rx timestamp metadata for xdp
  selftests/bpf: Simple program to dump XDP RX metadata

 Documentation/bpf/kfuncs.rst                  |   8 +
 Documentation/bpf/xdp-rx-metadata.rst         | 109 +++++
 arch/arm64/net/bpf_jit_comp.c                 |   8 +
 arch/x86/net/bpf_jit_comp.c                   |   8 +
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |   2 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  68 ++-
 drivers/net/veth.c                            |  22 +-
 include/linux/bpf.h                           |   1 +
 include/linux/bpf_patch.h                     |  29 ++
 include/linux/btf.h                           |   1 +
 include/linux/btf_ids.h                       |   4 +
 include/linux/filter.h                        |  23 +
 include/linux/mlx4/device.h                   |   7 +
 include/linux/netdevice.h                     |   5 +
 include/linux/skbuff.h                        |   4 +
 include/net/xdp.h                             |  41 ++
 include/uapi/linux/bpf.h                      |  12 +
 kernel/bpf/Makefile                           |   2 +-
 kernel/bpf/bpf_patch.c                        |  77 +++
 kernel/bpf/disasm.c                           |   6 +
 kernel/bpf/syscall.c                          |  28 +-
 kernel/bpf/verifier.c                         |  80 ++++
 net/core/dev.c                                |   7 +
 net/core/filter.c                             |  40 ++
 net/core/skbuff.c                             |  20 +
 net/core/xdp.c                                | 184 +++++++-
 tools/include/uapi/linux/bpf.h                |  12 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/DENYLIST.s390x    |   1 +
 tools/testing/selftests/bpf/Makefile          |   8 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c   | 440 ++++++++++++++++++
 .../selftests/bpf/progs/xdp_hw_metadata.c     |  99 ++++
 .../selftests/bpf/progs/xdp_metadata.c        | 114 +++++
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 404 ++++++++++++++++
 tools/testing/selftests/bpf/xdp_hw_metadata.h |   6 +
 35 files changed, 1856 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/bpf/xdp-rx-metadata.rst
 create mode 100644 include/linux/bpf_patch.h
 create mode 100644 kernel/bpf/bpf_patch.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.h

-- 
2.38.1.431.g37b22c650d-goog


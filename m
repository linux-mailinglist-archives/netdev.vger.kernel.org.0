Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5556632C06
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiKUSZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKUSZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:25:55 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A143CCFE98
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:25:54 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id q194-20020a632acb000000b00476fda6a1d2so7249326pgq.15
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=neyclIYmG2MJG0dCgBX3z1WFmjD9qCZi8nD0qNfRZRU=;
        b=YbJPFsOK1XLIQ5fT/xSiHlNBomXbIsycXsSxoWDiNeEgRNXmMvMjF9knrQ77sUE9s9
         k08aLCK0GAenX9iZv9vu3+6Dzj/1CnGh2sJd+vRqbTG10RgtdpWUHjj+4PNLlZ1+ycRc
         n9Kt+xuryiKGNWWYo+fK9/KPpFaBKRvo/uNVuGytj68vT7fIxSn/sicXHKTH3if3PO/t
         wZ7NsaFYzzJ5kSPjRdjewIPDReexUHIqR/qxfHVvXJHWzQHgpHIfsDAtb2uqQP2UIjo+
         s9NAZmGTMVMCsWInsr01nknMm2S4i3z7PWwXWTMB6ed74iBAL7qbDHAYXWVWo7YUxE5x
         zTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=neyclIYmG2MJG0dCgBX3z1WFmjD9qCZi8nD0qNfRZRU=;
        b=gcDt0ZR6d2oQEjtotwQr9wIf4bPEsutfbFNyNFw2rkRr0RBwWm4gMmvNkdu6vTY+WL
         GcZCwzSAlP4g5ADfOlyMQB0+GvVWSJLFyjcJcIX7esx7G3vxRzXhqhpCjXWuoI5fFS8d
         RYjQQhUKPQTlORhOk3UFgORjYtEEwRMcitOsARuINUolH6cozIgsGUpEWo3xcPkg52RK
         EX0WbJ03zZdizvfX4nV8KXGpmYk4A2Y317qKXX9pIu/pisgMawMs5EWKHKINCBG+mySC
         stxaN4IS9GWeDEy7ZIfhA5X88z+hAh7bRJ01r3bPuKceYeWWdCuLepMCQuTNoF7RRP3H
         qeaA==
X-Gm-Message-State: ANoB5plfEojy5zEGgy6NNBIVQETBFkiM8WTUqZIqtHO+XdTF1rl9Jj3N
        HqMqx/NOFolXgyBimGIP3jF8HUQ=
X-Google-Smtp-Source: AA0mqf42La1ts4Pi84zycQoiDeWxQo7HER3f6PUKjfK6gBRvLd0L4veQzAa8AuF2uk9BG+d3UIeZFOQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:eac2:b0:186:b91b:17ec with SMTP id
 p2-20020a170902eac200b00186b91b17ecmr12951852pld.10.1669055154167; Mon, 21
 Nov 2022 10:25:54 -0800 (PST)
Date:   Mon, 21 Nov 2022 10:25:44 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221121182552.2152891-1-sdf@google.com>
Subject: [PATCH bpf-next v2 0/8] xdp: hints via kfuncs
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

Changes since v1:

- Drop xdp->skb metadata path (Jakub)

  No consensus yet on exposing xdp_skb_metadata in UAPI. Exploring
  whether everyone would be ok with kfunc to access that part..
  Will follow up separately.

- Drop kfunc unrolling (Alexei)

  Starting with simple code to resolve per-device ndo kfuncs.
  We can always go back to unrolling and keep the same kfuncs
  interface in the future.

- Add rx hash metadata (Toke)

  Not adding the rest (csum/hash_type/etc), I'd like us to agree on
  the framework.

- use dev_get_by_index and add proper refcnt (Toke)

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
- v1:
  https://lore.kernel.org/bpf/20221115030210.3159213-1-sdf@google.com/T/#t
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

Stanislav Fomichev (8):
  bpf: Document XDP RX metadata
  bpf: XDP metadata RX kfuncs
  veth: Introduce veth_xdp_buff wrapper for xdp_buff
  veth: Support RX XDP metadata
  selftests/bpf: Verify xdp_metadata xdp->af_xdp path
  mlx4: Introduce mlx4_xdp_buff wrapper for xdp_buff
  mxl4: Support RX XDP metadata
  selftests/bpf: Simple program to dump XDP RX metadata

 Documentation/bpf/xdp-rx-metadata.rst         |  90 ++++
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  10 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  78 +++-
 drivers/net/veth.c                            |  88 ++--
 include/linux/bpf.h                           |   1 +
 include/linux/mlx4/device.h                   |   7 +
 include/linux/netdevice.h                     |   5 +
 include/net/xdp.h                             |  20 +
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/core.c                             |   1 +
 kernel/bpf/syscall.c                          |  17 +-
 kernel/bpf/verifier.c                         |  33 ++
 net/core/dev.c                                |   5 +
 net/core/xdp.c                                |  52 +++
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   8 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c   | 365 ++++++++++++++++
 .../selftests/bpf/progs/xdp_hw_metadata.c     |  93 ++++
 .../selftests/bpf/progs/xdp_metadata.c        |  57 +++
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 405 ++++++++++++++++++
 tools/testing/selftests/bpf/xdp_metadata.h    |   7 +
 22 files changed, 1311 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/bpf/xdp-rx-metadata.rst
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_metadata.h

-- 
2.38.1.584.g0f3c55d4c2-goog


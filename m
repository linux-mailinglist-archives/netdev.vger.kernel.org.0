Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3F564ADA8
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 03:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiLMCgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 21:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbiLMCgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 21:36:09 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FC41A073
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:07 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id bq9-20020a056a000e0900b00571802a2eaaso1097227pfb.22
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qSiUOmEe/JLRtV5BB333baYbdxk8WblWmfCGqq5APxo=;
        b=qgRph/Cw5aw1xqkIR0mvgiQeFfv5+b2UHTf3HbtXKEnHZvbSdyyG1oe6jzOGjKFrnj
         Q1kDCtC82FcfTldj7+W6miIzLtIi8bUj5NWBMK59n9xAiN1vkyMRmqQwbQZ6m71IzYsm
         hGjDHPPNR3ufDrplVUyRjvO7VSvpx0zqltPz5aRz7wDO7syesCZRfKnOjhb1G+VZM8eo
         qBSL5osbZ2LycnX3SluZTsiCy7Lxe3dyxQn2auaaJj+o+JnhmiFK/U/9X6zk8V9MJbgS
         PRrZ93ZysPtEzfYMLWCoAwpolYvCvqx9rcRQwYKhsWZmol/E/74CHa9LCwh8fEPoT4XI
         NNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qSiUOmEe/JLRtV5BB333baYbdxk8WblWmfCGqq5APxo=;
        b=B8WTKA8TowjdpT3YxsTTq2dZhcPxfWoQJp3cW2vtW6PLKzV4LTbUWZCnnBwk1blTbA
         Hc6gxiawyAde0uHJvbjp8Fu4bc3sc1ERcpDMJtVcB3m62Y6c2llxoxd0+8DGztPicx+2
         LRSVC6SPd72Bvr7BYxu05GF9LqiwSNEu0e+vmq4Soi2mnUWEczlS/lXwXdH8ZGFfrcR3
         6VvsiP2s/M64p3YOBYAO7KawlnvuOaJyLB+HswYgug3kuEzbef7kmGZbeErCD7rFhijp
         yNxU8sMr0XCgWfigfuemtTtJE7Bnq0yfhCVOKSL/m59FixN2rHqaO5Fs/hkFwpBi5APQ
         QmaA==
X-Gm-Message-State: ANoB5plTjQ98yhjRi0q5rcNxvvB6OWxUAlZxrDVIUqcnICPzGtvcVlOC
        y6Mfgtngd0CSBGnb/76ZwNPJjTw=
X-Google-Smtp-Source: AA0mqf61ClJVpJhd7X+ZToJEF69dUEALkxJgEs3tfo4HqTb9KzZxRROIhEp31Nf1gPtX2U8U/up09is=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:ed94:b0:186:748f:e8c5 with SMTP id
 e20-20020a170902ed9400b00186748fe8c5mr79948051plj.73.1670898967396; Mon, 12
 Dec 2022 18:36:07 -0800 (PST)
Date:   Mon, 12 Dec 2022 18:35:50 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213023605.737383-1-sdf@google.com>
Subject: [PATCH bpf-next v4 00/15] xdp: hints via kfuncs
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
Content-Transfer-Encoding: quoted-printable
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

See the following email from Toke for the per-packet metadata overhead:
https://lore.kernel.org/bpf/20221206024554.3826186-1-sdf@google.com/T/#m49d=
48ea08d525ec88360c7d14c4d34fb0e45e798

Recent changes:

- Drop _supported kfuncs, return status from the existing ones,
  return the actual payload via arguments (Jakub)

- Use 'device-bound' instead of 'offloaded' in existing error message (Jaku=
b)

- Move offload init into late_initcall (Jakub)

- Separate xdp_metadata_ops to host netdev kfunc pointers (Jakub)

- Remove forward declarations (Jakub)

- Rename more offload routines to dev_bound (Jakub)
  bpf_offload_resolve_kfunc -> bpf_dev_bound_resolve_kfunc
  bpf_offload_bound_netdev_unregister -> bpf_dev_bound_netdev_unregister
  bpf_prog_offload_init -> bpf_prog_dev_bound_init
  bpf_prog_offload_destroy -> bpf_prog_dev_bound_destroy
  maybe_remove_bound_netdev -> bpf_dev_bound_try_remove_netdev

- Move bpf_prog_is_dev_bound check into bpf_prog_map_compatible (Toke)

- Prohibit metadata kfuncs unless device-bound (Toke)

- Adjust selftest to exercise freplace + include the path (Toke)

- Take rtnl in bpf_prog_offload_destroy to avoid the race (Martin)

- BPF_F_XDP_HAS_METADATA -> BPF_F_XDP_DEV_BOUND_ONLY (Martin)

- Prohibit only metadata kfuncs, not all (Alexei/Martin)

- Try to fix xdp_hw_metadata.c build issue on CI (Alexei)

  Wasn't able to reproduce it locally, so trying my best guess...

- mlx4 -> mlx4_en (Tariq)

  Plus other issues like using net/mlx4 prefix and using mlx4_en_xdp_buff
  instead of mlx4_xdp_buff. Applied those same patterns to mlx5.

- Separate device-bound changes into separate patch to make it easier to
  review

Prior art (to record pros/cons for different approaches):

- Stable UAPI approach:
  https://lore.kernel.org/bpf/20220628194812.1453059-1-alexandr.lobakin@int=
el.com/
- Metadata+BTF_ID appoach:
  https://lore.kernel.org/bpf/166256538687.1434226.15760041133601409770.stg=
it@firesoul/
- v3:
  https://lore.kernel.org/bpf/20221206024554.3826186-1-sdf@google.com/
- v2:
  https://lore.kernel.org/bpf/20221121182552.2152891-1-sdf@google.com/
- v1:
  https://lore.kernel.org/bpf/20221115030210.3159213-1-sdf@google.com/
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
  bpf: Rename bpf_{prog,map}_is_dev_bound to is_offloaded
  bpf: Introduce device-bound XDP programs
  selftests/bpf: Update expected test_offload.py messages
  bpf: XDP metadata RX kfuncs
  veth: Introduce veth_xdp_buff wrapper for xdp_buff
  veth: Support RX XDP metadata
  selftests/bpf: Verify xdp_metadata xdp->af_xdp path
  net/mlx4_en: Introduce wrapper for xdp_buff
  net/mlx4_en: Support RX XDP metadata
  selftests/bpf: Simple program to dump XDP RX metadata

Toke H=C3=B8iland-J=C3=B8rgensen (4):
  bpf: Support consuming XDP HW metadata from fext programs
  xsk: Add cb area to struct xdp_buff_xsk
  net/mlx5e: Introduce wrapper for xdp_buff
  net/mlx5e: Support RX XDP metadata

 Documentation/bpf/xdp-rx-metadata.rst         |  90 ++++
 drivers/net/ethernet/mellanox/mlx4/en_clock.c |  13 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |   6 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  63 ++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  11 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  26 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  11 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  35 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   6 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  99 +++--
 drivers/net/netdevsim/bpf.c                   |   4 -
 drivers/net/veth.c                            |  80 ++--
 include/linux/bpf.h                           |  39 +-
 include/linux/netdevice.h                     |   7 +
 include/net/xdp.h                             |  25 ++
 include/net/xsk_buff_pool.h                   |   5 +
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/core.c                             |  11 +-
 kernel/bpf/offload.c                          | 360 +++++++++------
 kernel/bpf/syscall.c                          |  35 +-
 kernel/bpf/verifier.c                         |  56 ++-
 net/core/dev.c                                |   9 +-
 net/core/filter.c                             |   2 +-
 net/core/xdp.c                                |  44 ++
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   8 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c   | 412 ++++++++++++++++++
 .../selftests/bpf/progs/xdp_hw_metadata.c     |  81 ++++
 .../selftests/bpf/progs/xdp_metadata.c        |  56 +++
 .../selftests/bpf/progs/xdp_metadata2.c       |  23 +
 tools/testing/selftests/bpf/test_offload.py   |  10 +-
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 405 +++++++++++++++++
 tools/testing/selftests/bpf/xdp_metadata.h    |  15 +
 36 files changed, 1780 insertions(+), 285 deletions(-)
 create mode 100644 Documentation/bpf/xdp-rx-metadata.rst
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata2.c
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_metadata.h

--=20
2.39.0.rc1.256.g54fd8350bd-goog


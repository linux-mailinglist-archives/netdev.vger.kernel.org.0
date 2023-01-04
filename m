Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480AD65DF65
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 22:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240299AbjADV7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 16:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbjADV7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 16:59:52 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AD813D67
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 13:59:51 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id bx21-20020a056a00429500b00582d85bb03bso2515795pfb.16
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 13:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l9z1LqEz7Fh64pPbqNasXJtSoPwx+819o+O2qTJvWLQ=;
        b=ROIwmn5LQGrBQ7apF7mQlA5rR2DQ5z1bMmxIsTsshe6kKeD63tkSnmEQVVwLtGbxzJ
         q8AG7nb8qdxf3nyiR4Kp+3XMZmFl95i+/wTx5wWFupVjGSo8iQHta08vX4CvGSTZX5+O
         WLTDVsQhiju+CmggZMgS77gi95hydZrq9wxdiBqLAfXf8foqu+Tg1NeeYg29FF57vI2N
         WTf6GXKEKJ3JAFtEOSsi6oCoeLc9sfgp1V7lUiDNboEoaD3qSfKQne6xAEG7hr72icJJ
         CJ8OVz+ggTW3P2tw1TgxL0jaO2RCyAgAimV3YNUoWVCEMJ1rFm2bypGYiWH1soNa9aDZ
         LHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l9z1LqEz7Fh64pPbqNasXJtSoPwx+819o+O2qTJvWLQ=;
        b=0hcc/K9ThIc5Nhoxdkk4k0EukegRSTbtvzxPhGHr/5fIM07ulCoFB8U/kx5OX8jKUU
         H4mybsKvNAcP+6F5/YgaDmIJYzqv6+v/VU4jpU+sttLj1NJgheCRxNkNwEKS1mZO3a/w
         3QsetJCONDfaSBXytJnZibYTE+xrjqHh9C7qyAyb6Qp0Fg5RxuyzOvFOJ7R3BYxkcs9I
         uzGFGk5slgY6ClioIYjxe5Cv0tq6gLAg0/HoWrWmzkxaXHbXQBXZ7JE9sURDIkvWa+yS
         M/02/XdGuh0ORhJaeItyzfD43orVPSDbUc489i6Ux+UpTvkhw7HdyxVt4Pr0eRZOgcph
         Hq5g==
X-Gm-Message-State: AFqh2kqT22mzT0FpKUjw+z2Wuzi18bVq+Sm6cn8YT1rCIgXfvXtFq0Na
        qTSZN2NAcmj08qS0yxT5mih+kYo=
X-Google-Smtp-Source: AMrXdXs/NTbP5gwSmyjFKqbz0g6d4XJkrtjUD6tGOvIbbcpR532t5mqn2L8VOCesAaX4C6iEIObgv9Q=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a62:19cf:0:b0:582:5779:3876 with SMTP id
 198-20020a6219cf000000b0058257793876mr849919pfz.40.1672869591058; Wed, 04 Jan
 2023 13:59:51 -0800 (PST)
Date:   Wed,  4 Jan 2023 13:59:32 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230104215949.529093-1-sdf@google.com>
Subject: [PATCH bpf-next v6 00/17] xdp: hints via kfuncs
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

- Reject dev-bound progs at tc (Martin)

- Reuse __bpf_prog_offload_destroy instead of adding
  __bpf_prog_dev_bound_destroy (Marin)

- Drop a bunch of unnecessary NULL checks (Martin)

- Fix compilation of xdp_hw_metadata (Martin and thank you David for the hi=
nts)

- Move bpf_dev_bound_kfunc_check into offload.c (Martin)

- Swap "ip netns del" and close_netns in the selftest (Martin)

- Move some code out of bpf_devs_lock (Martin)

- Remove some excessive gotos (Martin)

- Trigger bpf_prog_dev_bound_inherit for BPF_PROG_TYPE_EXT only when
  the destination program is dev-bound (Martin)

- Document @xdp_metadata_ops (David)

- Use :identifiers: when referencing metadata kfuns in the doc (David)

- Spelling and teletyping fixes for the doc (David)

- Add a note about xsk_umem__get_data and METADATA_SIZE (David)

Prior art (to record pros/cons for different approaches):

- Stable UAPI approach:
  https://lore.kernel.org/bpf/20220628194812.1453059-1-alexandr.lobakin@int=
el.com/
- Metadata+BTF_ID appoach:
  https://lore.kernel.org/bpf/166256538687.1434226.15760041133601409770.stg=
it@firesoul/
- v5:
  https://lore.kernel.org/bpf/20221220222043.3348718-1-sdf@google.com/
- v4:
  https://lore.kernel.org/bpf/20221213023605.737383-1-sdf@google.com/
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

Stanislav Fomichev (13):
  bpf: Document XDP RX metadata
  bpf: Rename bpf_{prog,map}_is_dev_bound to is_offloaded
  bpf: Move offload initialization into late_initcall
  bpf: Reshuffle some parts of bpf/offload.c
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

 Documentation/networking/index.rst            |   1 +
 Documentation/networking/xdp-rx-metadata.rst  | 108 +++++
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
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  99 ++--
 drivers/net/netdevsim/bpf.c                   |   4 -
 drivers/net/veth.c                            |  87 +++-
 include/linux/bpf.h                           |  61 ++-
 include/linux/netdevice.h                     |   8 +
 include/net/xdp.h                             |  21 +
 include/net/xsk_buff_pool.h                   |   5 +
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/core.c                             |  12 +-
 kernel/bpf/offload.c                          | 426 ++++++++++++------
 kernel/bpf/syscall.c                          |  40 +-
 kernel/bpf/verifier.c                         |  38 +-
 net/bpf/test_run.c                            |   3 +
 net/core/dev.c                                |   9 +-
 net/core/filter.c                             |   2 +-
 net/core/xdp.c                                |  64 +++
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   9 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c   | 410 +++++++++++++++++
 .../selftests/bpf/progs/xdp_hw_metadata.c     |  81 ++++
 .../selftests/bpf/progs/xdp_metadata.c        |  64 +++
 .../selftests/bpf/progs/xdp_metadata2.c       |  23 +
 tools/testing/selftests/bpf/test_offload.py   |  10 +-
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 405 +++++++++++++++++
 tools/testing/selftests/bpf/xdp_metadata.h    |  15 +
 38 files changed, 1902 insertions(+), 292 deletions(-)
 create mode 100644 Documentation/networking/xdp-rx-metadata.rst
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata2.c
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_metadata.h

--=20
2.39.0.314.g84b9a713c41-goog


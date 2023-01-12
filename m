Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708006667A2
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 01:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjALAce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 19:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjALAcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 19:32:33 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66527140E3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:32:32 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id k20-20020aa792d4000000b0058347d2f5e3so7617703pfa.15
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rqR03ObPuVca1Zb/cG3CW16PBi9kN5soMqNd0ejtMX4=;
        b=UK8uK5CrvhaaGg8Hnn6oXZEzuxi2LJt0J4eZJO7Sn664TQvgwXmo6l/ZppYKWXVpRo
         zq5+k2aNTDtQ6lMa4iLzOxDsMUZ/pL+5LF1KqLXZPOnHxAQXBGdamTYWEsYEJ3xgECT/
         v9BNWYUwP4Lp7wXnEiaNLx+TJ0yAMb+K2zX9JIkrua6SohY5EJIS52g92brOvLXd1LH/
         PnZy3f0DtokhTHqYlulerO8+N7nBtBL7TNZ6lwXAiVz6UDKbkEeBgnaZxfnB7EeOyrwr
         QsriIyJTjF6EO6najU30J4QULXueR8p9uY9y2NDJ96y7/izjpci4694edKmtR3qomvMH
         82Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqR03ObPuVca1Zb/cG3CW16PBi9kN5soMqNd0ejtMX4=;
        b=d7gjP9l46vQYpGO7btQs4LdOKW0yRR3C6frA86gWW96wohVirJLcEbHyOlnIU6OS9c
         4IOtMwszyAUII4tvbyPttpzQtBPQGDg2maksXkT/4azkB/akPo2ItzHckVG9JEldDu3O
         iLRvbQzKWjfO2P5VOyku8NrK1sYcNYNLiX9vAVF2CE4SRPP61JyUjzU37U351gRfTJlj
         dBBxpT5RPHrlHrOWB3s14quyxP61mHtE0QFgDxc+iSK5rv5WOsEF5WJ7UKzPryhFD8PY
         vy4U5Z3MuAlFP+fI1ldiwRzpErKeK9hJTZB2Slz7C/X9ISTNNJ6slD1Z9PjbPsa35fjO
         L2hg==
X-Gm-Message-State: AFqh2kq43Geb9YCXoXXJ8HsYGC+Vck7Ub0N1eXbbtMhtlmezditEx0UL
        2orj8W1dbt4qdbK3JboS+0W15yg=
X-Google-Smtp-Source: AMrXdXvmIz91dC68IgICzDRvWlOJI8onC0/CDwMBgVb9qg0/AWyMCQa6V6QJ9l7ClkFBV9u2rMSpDjs=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:2149:b0:582:998c:1f5 with SMTP id
 o9-20020a056a00214900b00582998c01f5mr2525053pfk.10.1673483551841; Wed, 11 Jan
 2023 16:32:31 -0800 (PST)
Date:   Wed, 11 Jan 2023 16:32:13 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230112003230.3779451-1-sdf@google.com>
Subject: [PATCH bpf-next v7 00/17] xdp: hints via kfuncs
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

- Bring back parts that were removed during patch reshuffling from "bpf:
  Introduce device-bound XDP programs" patch (Martin)

- Remove netdev NULL check from __bpf_prog_dev_bound_init (Martin)

- Remove netdev NULL check from bpf_dev_bound_resolve_kfunc (Martin)

- Move target bound device verification from bpf_tracing_prog_attach into
  bpf_check_attach_target (Martin)

- Move mlx5e_free_rx_in_progress_descs into txrx.h (Tariq)

- mlx5e_fill_xdp_buff -> mlx5e_fill_mxbuf (Tariq)

Prior art (to record pros/cons for different approaches):

- Stable UAPI approach:
  https://lore.kernel.org/bpf/20220628194812.1453059-1-alexandr.lobakin@int=
el.com/
- Metadata+BTF_ID appoach:
  https://lore.kernel.org/bpf/166256538687.1434226.15760041133601409770.stg=
it@firesoul/
- v6:
  https://lore.kernel.org/bpf/20230104215949.529093-1-sdf@google.com/
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
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   5 +
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  26 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  11 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  35 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   6 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  99 ++--
 drivers/net/netdevsim/bpf.c                   |   4 -
 drivers/net/veth.c                            |  87 ++--
 include/linux/bpf.h                           |  61 ++-
 include/linux/netdevice.h                     |   8 +
 include/net/xdp.h                             |  21 +
 include/net/xsk_buff_pool.h                   |   5 +
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/core.c                             |  12 +-
 kernel/bpf/offload.c                          | 425 ++++++++++++------
 kernel/bpf/syscall.c                          |  34 +-
 kernel/bpf/verifier.c                         |  44 +-
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
 39 files changed, 1900 insertions(+), 293 deletions(-)
 create mode 100644 Documentation/networking/xdp-rx-metadata.rst
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata2.c
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_metadata.h

--=20
2.39.0.314.g84b9a713c41-goog


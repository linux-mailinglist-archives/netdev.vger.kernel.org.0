Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925CE6528DC
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 23:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiLTWVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 17:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbiLTWUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 17:20:48 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A199E14
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 14:20:46 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id p17-20020a056a0026d100b005769067d113so7405251pfw.3
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 14:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Iam3/ShjZhlGxX9KAXlycUxmHYC4Ccabtm9A5kBwKM=;
        b=TmB9r1Diw77SvqT15bMhahipKJIwrm1P1T25Ds99iMm63BSagQDuM3GcjCrbS3VCVG
         mMmsCjt/OZpATVS3iKpzJgzPKcnExNGNaFcJfqYzbg6onytKEOhKzsfi7A8BzJEgKhlj
         zWJqMnpFzzgPIj5b4s8+cyPwFTZhTedN1h8resfOyjnETZnK5f0co5gTFVywKmZxxshg
         +NkAYGTjNmVf7bXhXJHv2hqg1tqgU2BOK1+z+bM22sSYxyBvfZg2vPEczIJdI642vCAs
         ExPyo0WALt7SR/VnhqmDCAHCM7VrGpejtOAsLme5OLxN1obeoxoBeahpkJmM9URbX1mx
         4jmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Iam3/ShjZhlGxX9KAXlycUxmHYC4Ccabtm9A5kBwKM=;
        b=AMvQ+eKBbJf+7TArab4LfnbJIbqQDXkpxbINCjjKiDNf+3kNnuqYLcRoV5mQMKxey9
         ffEZZEJg2uwaRNGfq5HNVX+nFRUueIWcBmc2jbaYZ3yRTWXl5B9EMFJ/rgk30RaCcN4L
         wn6Xiq1xEMTSSyLETFonAvlS0bJeBRT5wE72WcJN7EhF6yJC5VWg15HFn2TT7kRiNwoN
         ZxsUhz0cnJEe8odIA6B8/F98LqDkoY1icQBcYgSm8eqIBxEfRnSE05kYMva0sAkpNEDo
         YgW1nyw/PJpX0kstYglTmKDgU4LDZsCTYz33XerO8taOzhBEiyhxULE5jYUhrxdgqbms
         MiqQ==
X-Gm-Message-State: AFqh2kr9Rb8Aa5m0tpEnpzckgizGN3HDuXWqcnBb/kj3jBkb1PPPJAZY
        SOlOq4cYTReqXYvU5GMAbgh7PGs=
X-Google-Smtp-Source: AMrXdXuFKtzodN+Fpx9EzYjrTS2SdKtaJ6gV0lEIqeGddUQ07NBScPaaRqoK92U6p3ZeEFV3f+6swiM=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:4d83:b0:220:1f03:129b with SMTP id
 oj3-20020a17090b4d8300b002201f03129bmr60042pjb.0.1671574844959; Tue, 20 Dec
 2022 14:20:44 -0800 (PST)
Date:   Tue, 20 Dec 2022 14:20:26 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220222043.3348718-1-sdf@google.com>
Subject: [PATCH bpf-next v5 00/17] xdp: hints via kfuncs
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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

- Various updates to the documentation (Toke)

- !CONFIG_NET for bpf_dev_bound_resolve_kfunc (Martin)

- Comment about race when resolving multiple kfuncs vs attach (Martin)

- Move kfuncs check part under add_kfunc_call (Martin)

- Add missing freplace locks (via bpf_prog_dev_bound_inherit and
  bpf_prog_dev_bound_match) (Martin)

- Rework selftest to expect 0 HW timestamp instead of adding test-specific
  code to veth (Martin)

- Separate patches for offload.c refactoring (Martin)

- Remove sem unlock in __bpf_offload_dev_netdev_register (Martin)

- Rework error handling in bpf_prog_offload_init (Martin)

- Fix wrongly placed list_del_init and unroll
  bpf_dev_bound_try_remove_netdev (Martin)

- Drop locks from bpf_offload_init (Martin)

- Swap the order of bpf_dev_bound_netdev_unregister and
  dev_xdp_uninstall (Martin)

- Return HW timestamp in veth kfunc (Jesper)

- Various fixes around documentation (David)

- Don't define kfunc prototypes (David)

- More clear XDP_METADATA_KFUNC argument names (David)

Prior art (to record pros/cons for different approaches):

- Stable UAPI approach:
  https://lore.kernel.org/bpf/20220628194812.1453059-1-alexandr.lobakin@int=
el.com/
- Metadata+BTF_ID appoach:
  https://lore.kernel.org/bpf/166256538687.1434226.15760041133601409770.stg=
it@firesoul/
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
 Documentation/networking/xdp-rx-metadata.rst  | 107 +++++
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
 drivers/net/veth.c                            |  87 ++--
 include/linux/bpf.h                           |  53 ++-
 include/linux/netdevice.h                     |   7 +
 include/net/xdp.h                             |  21 +
 include/net/xsk_buff_pool.h                   |   5 +
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/core.c                             |  12 +-
 kernel/bpf/offload.c                          | 404 +++++++++++------
 kernel/bpf/syscall.c                          |  39 +-
 kernel/bpf/verifier.c                         |  54 ++-
 net/bpf/test_run.c                            |   3 +
 net/core/dev.c                                |   9 +-
 net/core/filter.c                             |   2 +-
 net/core/xdp.c                                |  50 +++
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   8 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c   | 412 ++++++++++++++++++
 .../selftests/bpf/progs/xdp_hw_metadata.c     |  81 ++++
 .../selftests/bpf/progs/xdp_metadata.c        |  64 +++
 .../selftests/bpf/progs/xdp_metadata2.c       |  23 +
 tools/testing/selftests/bpf/test_offload.py   |  10 +-
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 405 +++++++++++++++++
 tools/testing/selftests/bpf/xdp_metadata.h    |  15 +
 38 files changed, 1883 insertions(+), 281 deletions(-)
 create mode 100644 Documentation/networking/xdp-rx-metadata.rst
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata2.c
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_metadata.h

--=20
2.39.0.314.g84b9a713c41-goog


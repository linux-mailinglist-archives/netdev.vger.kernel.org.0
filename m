Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99275643B6B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbiLFCp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiLFCp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:45:57 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7835317A94
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 18:45:56 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3dddef6adb6so126759147b3.11
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 18:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WVqzTJK/MBFUSO8hAqhMz7njH7WeU2V0OYyjLQcQhCc=;
        b=lNpw428R0hgYF5AbXK0z3+148FBHky/sODJuqvE+XaaLJOqDurD4Db5xDuTnlX/l7W
         h1Hp6deGlkdMaGPPVefDIQNE0zp3KXx4hHslOYEyYvY+g7mFEEK86WIgHVW90Re0Bgsl
         bPwgqAqvIeMOLSmUFAOKdHM6LRlUykFyWLK0laIM26CHUsur/nPhYPEo97mYOdUKd/dY
         CXssEXIvTzxedhdPwI2ClNxw/rHw0+TPvlP8/lGI998+DkEgQtmpzXNGtZdZUYqtyBOe
         2Uj/mG3BIa/TdbUjRaQHrNspiGoJUxItS554sHd5QAspv0c/YCqb4J/AWttJWtr74Gs4
         JEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVqzTJK/MBFUSO8hAqhMz7njH7WeU2V0OYyjLQcQhCc=;
        b=lwDQ14I0fLdG+QmGeij0FrUoY3T2pJQ0DYSeGmpngWCVD4kJcvqGHS1u5z5odgr/1w
         QhNG+R3iiPvbXP1uYloBNqvZRHSLc80TJId2s7GHuaHwxgZLvqR3QMfnn1R73dB6TEQ8
         4HHmJHSUebjAXePMEh+HaYCs8qlTQVUNiXkV6MdhJZJMmb9ltdqm15OubAEJrSLvWrxK
         +ZFqNUQJQjWIrpGtOPKO0O42PmwmzKU//lDFw9bbaKCypzDkxKMDGSo5v2gAGLzlR9vv
         JhcRcP1Wj3FCamZWauUcKjI6ztVbKyBs6J4EBqltlSG48fivKaF3g8VwfpyKqCVCSOZM
         vO+g==
X-Gm-Message-State: ANoB5pmx0BMm9kNhfVYUHq2SNq1mrIpwdsZQiYcqdGdxkymfs225VjnY
        pBlOCMqOyStk/XPGEUTi5ZRxWs4=
X-Google-Smtp-Source: AA0mqf7tTfa0QwZVgPzwhmTqtexxWiJmQVjzbIQt0CK61/Bs5Q/mF6NTUAVzCwTGakzTn1CQjoVTz0Y=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6902:72d:b0:702:84b2:afc7 with SMTP id
 l13-20020a056902072d00b0070284b2afc7mr3515268ybt.388.1670294755722; Mon, 05
 Dec 2022 18:45:55 -0800 (PST)
Date:   Mon,  5 Dec 2022 18:45:42 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206024554.3826186-1-sdf@google.com>
Subject: [PATCH bpf-next v3 00/12] xdp: hints via kfuncs
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

Changes since v3:

- Rework prog->bound_netdev refcounting (Jakub/Marin)

  Now it's based on the offload.c framework. It mostly fits, except
  I had to automatically insert a HT entry for the netdev. In the
  offloaded case, the netdev is added via a call to
  bpf_offload_dev_netdev_register from the driver init path; with
  a dev-bound programs, we have to manually add (and remove) the entry.

  As suggested by Toke, I'm also prohibiting putting dev-bound programs
  into prog-array map; essentially prohibiting tail calling into it.
  I'm also disabling freplace of the dev-bound programs. Both of those
  restrictions can be loosened up eventually.
  Note that we don't require maps to be dev-bound when the program is
  dev-bound.

  Confirmed with the test_offload.py that the existing parts are still
  operational.

- Fix compile issues with CONFIG_NET=3Dn and mlx5 driver (lkp@intel.com)

Changes since v2:

- Rework bpf_prog_aux->xdp_netdev refcnt (Martin)

  Switched to dropping the count early, after loading / verification is
  done. At attach time, the pointer value is used only for comparing
  the actual netdev at attach vs netdev at load.

  (potentially can be a problem if the same slub slot is reused
  for another netdev later on?)

- Use correct RX queue number in xdp_hw_metadata (Toke / Jakub)

- Fix wrongly placed '*cnt=3D0' in fixup_kfunc_call after merge (Toke)

- Fix sorted BTF_SET8_START (Toke)

  Introduce old-school unsorted BTF_ID_LIST for lookup purposes.

- Zero-initialize mlx4_xdp_buff (Tariq)

- Separate common timestamp handling into mlx4_en_get_hwtstamp (Tariq)

- mlx5 patches (Toke)

  Note, I've renamed the following for consistency with the rest:
  - s/mlx5_xdp_ctx/mlx5_xdp_buff/
  - s/mctx/mxbuf/

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
  https://lore.kernel.org/bpf/20220628194812.1453059-1-alexandr.lobakin@int=
el.com/
- Metadata+BTF_ID appoach:
  https://lore.kernel.org/bpf/166256538687.1434226.15760041133601409770.stg=
it@firesoul/
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

Stanislav Fomichev (9):
  bpf: Document XDP RX metadata
  bpf: Rename bpf_{prog,map}_is_dev_bound to is_offloaded
  bpf: XDP metadata RX kfuncs
  veth: Introduce veth_xdp_buff wrapper for xdp_buff
  veth: Support RX XDP metadata
  selftests/bpf: Verify xdp_metadata xdp->af_xdp path
  mlx4: Introduce mlx4_xdp_buff wrapper for xdp_buff
  mxl4: Support RX XDP metadata
  selftests/bpf: Simple program to dump XDP RX metadata

Toke H=C3=B8iland-J=C3=B8rgensen (3):
  xsk: Add cb area to struct xdp_buff_xsk
  mlx5: Introduce mlx5_xdp_buff wrapper for xdp_buff
  mlx5: Support RX XDP metadata

 Documentation/bpf/xdp-rx-metadata.rst         |  90 ++++
 drivers/net/ethernet/mellanox/mlx4/en_clock.c |  13 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  10 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  68 ++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  11 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  32 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  13 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  35 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   4 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  98 ++---
 drivers/net/veth.c                            |  88 ++--
 include/linux/bpf.h                           |  26 +-
 include/linux/mlx4/device.h                   |   7 +
 include/linux/netdevice.h                     |   5 +
 include/net/xdp.h                             |  29 ++
 include/net/xsk_buff_pool.h                   |   5 +
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/arraymap.c                         |  17 +-
 kernel/bpf/core.c                             |   2 +-
 kernel/bpf/offload.c                          | 162 +++++--
 kernel/bpf/syscall.c                          |  25 +-
 kernel/bpf/verifier.c                         |  42 +-
 net/core/dev.c                                |   7 +-
 net/core/filter.c                             |   2 +-
 net/core/xdp.c                                |  58 +++
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   8 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c   | 394 +++++++++++++++++
 .../selftests/bpf/progs/xdp_hw_metadata.c     |  93 ++++
 .../selftests/bpf/progs/xdp_metadata.c        |  70 +++
 .../selftests/bpf/progs/xdp_metadata2.c       |  15 +
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 405 ++++++++++++++++++
 tools/testing/selftests/bpf/xdp_metadata.h    |   7 +
 36 files changed, 1688 insertions(+), 167 deletions(-)
 create mode 100644 Documentation/bpf/xdp-rx-metadata.rst
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata2.c
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_metadata.h

--=20
2.39.0.rc0.267.gcb52ba06e7-goog


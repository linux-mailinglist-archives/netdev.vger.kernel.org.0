Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0B763C874
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 20:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbiK2Te6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 14:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiK2Tez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 14:34:55 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562CF2E6AA
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:34:54 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id a3-20020a17090a8c0300b00218bfce4c03so15857645pjo.1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JRokEe8pLiOxH9LOXcdCyVz+kq2JA+PPAN2lbEuJRoA=;
        b=Txg3mtrJUCpJW8BJpf4fJKQrge+uHe145cdfh79ZnNWyb1itxovN5guh2SDvj5p2Ux
         VfcIgOXBDHc7cW5aAZUcvODElv5L42CtjNxsioe/0nEJVx0l5XuLkBULEQBxLz4MWq94
         r0noJY0hSvOZUjeROb8Ot22EK3u1JbyK+tzuJVNTguY/L9kzsvAboqeboe5cr0ruCOTw
         2kGkYZtwnRHgYbr/qy141dhcwWHE+LnhatXwga7zuqpq0w4J4FbOX0zcY3GKOFYb1gAj
         PD8rELJknNsl+QtyGZxkzunLdhI02ao+lRTEZLcCvIXZ9VMyP5e4ewA2ZoEd8Yo+dzWb
         xzxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRokEe8pLiOxH9LOXcdCyVz+kq2JA+PPAN2lbEuJRoA=;
        b=vMUwVAHIT19mXbGpJKOXODQ2GMM0We4ET4QK6ziJ9gD8O6+DrupicxNg1bhYsr+4sX
         n17Eu7mxqQvzlSmWECWjOtmsPPqzbEXrfn7uwLSPXIt9yhz8dJfhhaBa0r3YJsRYCRIU
         0Hhw8tm3AWeCy72iUqtnBwKm7b37wEIMQkwJ3SLwxS7QlE6pvShKKfcokt6CfZobMZ2+
         P87IGn47VFxMJ1QQIWVvkFHFnwzOmfV2toiRVDnt35ciPoEDr38+LYaEBVI3sTdIR+rf
         OAF0v5Ez0sGJcL+9NXPz8vnYhARq3uX2jDeXfVR3Nr8At7I8NwE28uF1Bm4eLbWH7QdE
         zOyQ==
X-Gm-Message-State: ANoB5plpnjXcRxlhXW8Mt7nAdOPRCYi0aYQK4i6GJ2kMxZI/R8uqnrqZ
        hRC8lTLCqERM4VpQoFuWMJebKDs=
X-Google-Smtp-Source: AA0mqf62pmvztezrBNopHYtbddipcVC+3lDq9/mTZD7BLIvvm8eB/hr2YcINGuT+aSbxcmA8k67RJ2Q=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:ef47:b0:186:a394:aef7 with SMTP id
 e7-20020a170902ef4700b00186a394aef7mr52608764plx.79.1669750493693; Tue, 29
 Nov 2022 11:34:53 -0800 (PST)
Date:   Tue, 29 Nov 2022 11:34:41 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129193452.3448944-1-sdf@google.com>
Subject: [PATCH bpf-next v3 00/11] xdp: hints via kfuncs
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

Stanislav Fomichev (8):
  bpf: Document XDP RX metadata
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
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  92 ++--
 drivers/net/veth.c                            |  88 ++--
 include/linux/bpf.h                           |   4 +
 include/linux/mlx4/device.h                   |   7 +
 include/linux/netdevice.h                     |   5 +
 include/net/xdp.h                             |  25 ++
 include/net/xsk_buff_pool.h                   |   5 +
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/syscall.c                          |  24 +-
 kernel/bpf/verifier.c                         |  37 +-
 net/core/dev.c                                |   5 +
 net/core/xdp.c                                |  58 +++
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   8 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c   | 365 ++++++++++++++++
 .../selftests/bpf/progs/xdp_hw_metadata.c     |  93 ++++
 .../selftests/bpf/progs/xdp_metadata.c        |  57 +++
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 405 ++++++++++++++++++
 tools/testing/selftests/bpf/xdp_metadata.h    |   7 +
 31 files changed, 1467 insertions(+), 108 deletions(-)
 create mode 100644 Documentation/bpf/xdp-rx-metadata.rst
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_metadata.h

--=20
2.38.1.584.g0f3c55d4c2-goog


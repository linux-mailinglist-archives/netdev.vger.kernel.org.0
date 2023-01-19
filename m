Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F387674610
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 23:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjASWcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 17:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjASWcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 17:32:07 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26778A839F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:15:38 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id j16-20020a170902da9000b00194c056109eso2052659plx.18
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s6wcP6RWB5SYtmKPUHmIscUbqw75lHL7Mr8Z5DyfUQs=;
        b=Vos6f3EulFO6uFSnNRE8joDrp2WDDUxxxP3pEBifFl4gUqMQOcScQs4x0mTspgKiPD
         fljHSEm27Fetsj0x5T8tEZ6dVtUXzlKBvrKQ8L7O6anWX5i3Z3NWOQyB8BzbyUcErY21
         Pscr5P3cgalkv9Jc7v/gVbCTbqHBAe0wWqmP+lchGkIultxRZci416cTJFsV565U8eCQ
         00jWH7Z5ORoX3yBNZZK1jQCWVaDOjw8EQab9/kesvzhhy2gU6MZeaxN7CB45ejgHRzVl
         aK/1QqDD4AyelknPIAg8eOsezr6wH6xnSFBBK/mbfekdMwmCC0frQ202VfjsJ9TlLy4k
         j6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6wcP6RWB5SYtmKPUHmIscUbqw75lHL7Mr8Z5DyfUQs=;
        b=ezShN5HjLS6F5hrX+l1owyza0XqeuKklrL2NRuRyyJEticj8btWFm9U8dGxl2W0Dd0
         JOh4bZKtf+bWH26T5VFn1I2QIlqdj8AfFHfzqUTsLc4zcrXSeUXvAUECOoccw8OrhDnw
         AQtVkDh/rLfVeSUzYvFYwqNQi4mrU2lD2rXCNIofo7HHSjdZF1SGJPrtDUjIXnZBA4zK
         pZGSM+kLzUFuWHU/F1GTGDqwFX8bD69zIb8GTzCH2/y2iq1LVdOlOCE8SKtYmi5WTkje
         1Oe2Vxl5sD3amCuaX+IcPxfEfEUyro+3G5jDEFTYcSYCrjRjEodkBfzPjLlzLYVJNRhM
         /CIA==
X-Gm-Message-State: AFqh2koZGr8dkowm/ELysiWzcQg5fUdjiWtj0LDqlOW10tbIwOVxb9NV
        uiSbr/EA+JTqA+WzGgXptN/YHEU=
X-Google-Smtp-Source: AMrXdXvYvQ0murMOUx2J8H9DFUYWYb0VKQya/NfS9NsH1IIoz80c+rQuKkoe0Aohj4hDVe0U9BjkV2w=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:903:3252:b0:194:ca6a:529d with SMTP id
 ji18-20020a170903325200b00194ca6a529dmr431836plb.33.1674166537546; Thu, 19
 Jan 2023 14:15:37 -0800 (PST)
Date:   Thu, 19 Jan 2023 14:15:19 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119221536.3349901-1-sdf@google.com>
Subject: [PATCH bpf-next v8 00/17] xdp: hints via kfuncs
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
- Keep new functions in en/xdp.c, do 'extern mlx5_xdp_metadata_ops' (Tariq)

- Remove mxbuf pointer and use xsk_buff_to_mxbuf (Tariq)

- Clarify xdp_buff vs 'XDP frame' (Jesper)

- Explicitly mention that AF_XDP RX descriptor lacks metadata size (Jesper)

- Drop libbpf_flags/xdp_flags from selftests and use ifindex instead
  of ifname (due to recent xsk.h refactoring)

Prior art (to record pros/cons for different approaches):

- Stable UAPI approach:
  https://lore.kernel.org/bpf/20220628194812.1453059-1-alexandr.lobakin@int=
el.com/
- Metadata+BTF_ID appoach:
  https://lore.kernel.org/bpf/166256538687.1434226.15760041133601409770.stg=
it@firesoul/
- v7:
  https://lore.kernel.org/bpf/20230112003230.3779451-1-sdf@google.com/
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
 Documentation/networking/xdp-rx-metadata.rst  | 110 +++++
 drivers/net/ethernet/mellanox/mlx4/en_clock.c |  13 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |   6 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  63 ++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   5 +
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  31 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  10 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  47 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
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
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 403 +++++++++++++++++
 tools/testing/selftests/bpf/xdp_metadata.h    |  15 +
 39 files changed, 1910 insertions(+), 293 deletions(-)
 create mode 100644 Documentation/networking/xdp-rx-metadata.rst
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata2.c
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_metadata.h

--=20
2.39.0.246.g2a6d74b583-goog


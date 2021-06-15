Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDD73A8362
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhFOO5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:57:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231480AbhFOO5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:57:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623768911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jsmFUHJU0jtXU3GGMToOByMQ5jR14adcLCwMi9CMD1M=;
        b=WczwA8Q5il4tLls55fTUZOZk6TzXl9N+sho7rXe8SglqggZBGvUWeX5wrzVlQdwighLYZs
        k0pLeZK7JbYA9LeQo9xguK1WIA3KMNVBlI2nCfne3vltqjoU0PSmY9gMfo/BKisj3iAWjZ
        Avr1l9zjP5hFvPQJzqPYJa8U+9mufOs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-dGvnLtraOwaNfovuJ3OrGg-1; Tue, 15 Jun 2021 10:55:03 -0400
X-MC-Unique: dGvnLtraOwaNfovuJ3OrGg-1
Received: by mail-ed1-f69.google.com with SMTP id v12-20020aa7dbcc0000b029038fc8e57037so4214451edt.0
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jsmFUHJU0jtXU3GGMToOByMQ5jR14adcLCwMi9CMD1M=;
        b=WFZtotUiobqJIKUHMCF05fJj1LZaTS2MxuUVW4aL9MDCkQiRDdaPIoAGvE+IdtGJ+2
         VdXuLI4uXZIako+VAfzfBVgg859ufqz73y0hD0m+FluPEeAjI7/ICLT++yGZzZAxUVEQ
         HZDUWDZqnXsGAA9djw6nnRpxsIlPBdbDrpg6FuveBy5FjS4hqcHR/ZP2al90lRFdrrpu
         uRAoeQOTpc7WeqHil1ZPMdkffdxSPZ3hhJoyBB+jJkiygktPHJZIA2CFxD1eUV4KHVuW
         Sl8NeBKshQoqvL7rylwZYJmAsBlPqjMWGZgqwXJ1m8ZeKoopOyesOrmJosImQkXu1Mjw
         21BA==
X-Gm-Message-State: AOAM532gmCD9XV+BIaYNoJak+C0/+rS3zDT2iK+9NnZe4JI5XgnMivno
        WZGvgW5M+NGxMK+7ibteQ94UHZcFOtjc3JYpqjrY+Ax7dYaEUzqIxeXVFslcDLevFpGHbLuOQg7
        U1kQjPzwTtjcgZqup
X-Received: by 2002:a05:6402:655:: with SMTP id u21mr23879018edx.211.1623768900337;
        Tue, 15 Jun 2021 07:55:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzepJ27/G7iCpuyA7bFmAeYr9gqzK0v04wsRcNTp5eb1XEl1d7OLnTuryzGzsp5FJqY+kzJ8w==
X-Received: by 2002:a05:6402:655:: with SMTP id u21mr23878979edx.211.1623768899961;
        Tue, 15 Jun 2021 07:54:59 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id w8sm2423385edq.67.2021.06.15.07.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:54:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A29221802B8; Tue, 15 Jun 2021 16:54:58 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v2 00/16] Clean up and document RCU-based object protection for XDP_REDIRECT
Date:   Tue, 15 Jun 2021 16:54:39 +0200
Message-Id: <20210615145455.564037-1-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the discussion[0] of Hangbin's multicast patch series, Martin pointed out
that the lifetime of the RCU-protected  map entries used by XDP_REDIRECT is by
no means obvious. I promised to look into cleaning this up, and Paul helpfully
provided some hints and a new unrcu_pointer() helper to aid in this.

It seems[1] that back in the early days of XDP, local_bh_disable() did not
provide RCU protection, which is why the rcu_read_lock() calls were added
to drivers in the first place. But according to Paul[2], in recent kernels
a local_bh_disable()/local_bh_enable() pair functions as one big RCU
read-side section, so no further protection is needed. This even applies to
-rt kernels, which has an explicit rcu_read_lock() in place as part of the
local_bh_disable()[3].

This patch series is mostly a documentation exercise, cleaning up the
description of the lifetime expectations and adding __rcu annotations so
sparse and lockdep can help verify it.

Patches 1 and 2 are preparatory: Patch 1 adds Paul's unrcu_pointer()
helper (which has already been added to his tree), which we need for some
of the operations in devmap, and patch 2 adds bh context as a valid
condition for map lookups. Patch 3 is the main bit that adds the __rcu
annotations and updates documentation comments, and the rest are patches
updating the drivers, with one patch per distinct maintainer.

Unfortunately I don't have any hardware to test any of the driver patches;
Jesper helpfully verified that it doesn't break anything on i40e, but the rest
of the driver patches are only compile-tested.

[0] https://lore.kernel.org/bpf/20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com/
[1] https://lore.kernel.org/bpf/c5192ab3-1c05-8679-79f2-59d98299095b@iogearbox.net/
[2] https://lore.kernel.org/bpf/20210417002301.GO4212@paulmck-ThinkPad-P17-Gen-1/
[3] https://lore.kernel.org/bpf/20210419165837.GA975577@paulmck-ThinkPad-P17-Gen-1/

Changelog:
v2:
  - Add a comment about RCU protection to the drivers where rcu_read_lock()
    is removed
  - Drop unnecessary patch 3 which changed dev_get_by_index_rcu()
  - Add some more text with the history to cover letter
  - Fix a few places where the wrong RCU checks were used in cpumap and
    xskmap code
  - Carry forward ACKs

Paul E. McKenney (1):
  rcu: Create an unrcu_pointer() to remove __rcu from a pointer

Toke Høiland-Jørgensen (15):
  bpf: allow RCU-protected lookups to happen from bh context
  xdp: add proper __rcu annotations to redirect map entries
  ena: remove rcu_read_lock() around XDP program invocation
  bnxt: remove rcu_read_lock() around XDP program invocation
  thunderx: remove rcu_read_lock() around XDP program invocation
  freescale: remove rcu_read_lock() around XDP program invocation
  net: intel: remove rcu_read_lock() around XDP program invocation
  marvell: remove rcu_read_lock() around XDP program invocation
  mlx4: remove rcu_read_lock() around XDP program invocation
  nfp: remove rcu_read_lock() around XDP program invocation
  qede: remove rcu_read_lock() around XDP program invocation
  sfc: remove rcu_read_lock() around XDP program invocation
  netsec: remove rcu_read_lock() around XDP program invocation
  stmmac: remove rcu_read_lock() around XDP program invocation
  net: ti: remove rcu_read_lock() around XDP program invocation

 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  6 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  5 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  5 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 11 ++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  6 +--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 11 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  6 +--
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  6 +--
 drivers/net/ethernet/intel/igb/igb_main.c     |  5 +-
 drivers/net/ethernet/intel/igc/igc_main.c     | 10 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  5 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |  9 ++--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  5 +-
 drivers/net/ethernet/marvell/mvneta.c         |  6 ++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  8 +--
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  8 +--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  6 ++-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  7 +--
 drivers/net/ethernet/sfc/rx.c                 | 12 ++---
 drivers/net/ethernet/socionext/netsec.c       |  7 +--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 13 ++---
 drivers/net/ethernet/ti/cpsw_priv.c           | 13 ++---
 include/linux/rcupdate.h                      | 14 +++++
 include/net/xdp_sock.h                        |  2 +-
 kernel/bpf/cpumap.c                           | 13 +++--
 kernel/bpf/devmap.c                           | 52 ++++++++-----------
 kernel/bpf/hashtab.c                          | 21 +++++---
 kernel/bpf/helpers.c                          |  6 +--
 kernel/bpf/lpm_trie.c                         |  6 ++-
 net/core/filter.c                             | 28 ++++++++++
 net/xdp/xsk.c                                 |  4 +-
 net/xdp/xsk.h                                 |  4 +-
 net/xdp/xskmap.c                              | 29 ++++++-----
 34 files changed, 196 insertions(+), 158 deletions(-)

-- 
2.31.1


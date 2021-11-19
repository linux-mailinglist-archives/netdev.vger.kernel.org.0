Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D66457341
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbhKSQnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:43:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236569AbhKSQnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:43:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637340047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sdPNsUt5ET11fnQU5zA7SZiidRIb9KqsblL/TZmoJ+E=;
        b=ZU5zRGfjSux0bsim4VKcJ0/jhy+hJIQh323p6bfofiR06L1fybAhHPEtbIVdLiUY+z/1cS
        +KF3XXkZsnND1UX+DAeeB5kUeRCfrdhyTPr9XEwYR77X2dcGvppEL+1oYFfRVZ52k9eUye
        ybjtAnVK/lOkTWch5MOdy0XwVS7vUhQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-431-hNm8gD4TPjCS5T72cy7rsg-1; Fri, 19 Nov 2021 11:40:44 -0500
X-MC-Unique: hNm8gD4TPjCS5T72cy7rsg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 316A4425CB;
        Fri, 19 Nov 2021 16:40:43 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B28E860BF1;
        Fri, 19 Nov 2021 16:40:41 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH net-next 0/2] bpf: do not WARN in bpf_warn_invalid_xdp_action()
Date:   Fri, 19 Nov 2021 17:39:14 +0100
Message-Id: <cover.1637339774.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mentioned WARN is quite noisy, especially vs fuzzers and
apparently used only to track the relevant BPF program and/or
involved driver.

The first patch replace it with a pr_warn_once(), and the 2nd
patch allow dumps relevant info to track the reported issue.

This is quite invasive, but the mentioned WARN makes the hunt
for some bugs reported by syzkaller quite difficult.

Paolo Abeni (2):
  bpf: do not WARN in bpf_warn_invalid_xdp_action()
  bpf: let bpf_warn_invalid_xdp_action() report more info

 drivers/net/ethernet/amazon/ena/ena_netdev.c           | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c          | 2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c       | 2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c         | 2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c       | 2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c           | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c            | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c             | 2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c              | 2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c               | 2 +-
 drivers/net/ethernet/intel/igb/igb_main.c              | 2 +-
 drivers/net/ethernet/intel/igc/igc_main.c              | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c          | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c           | 2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c      | 2 +-
 drivers/net/ethernet/marvell/mvneta.c                  | 2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c        | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c             | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c       | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c    | 2 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c             | 2 +-
 drivers/net/ethernet/sfc/rx.c                          | 2 +-
 drivers/net/ethernet/socionext/netsec.c                | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c      | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.c                    | 2 +-
 drivers/net/hyperv/netvsc_bpf.c                        | 2 +-
 drivers/net/tun.c                                      | 2 +-
 drivers/net/veth.c                                     | 4 ++--
 drivers/net/virtio_net.c                               | 4 ++--
 drivers/net/xen-netfront.c                             | 2 +-
 include/linux/filter.h                                 | 2 +-
 kernel/bpf/cpumap.c                                    | 4 ++--
 kernel/bpf/devmap.c                                    | 4 ++--
 net/core/dev.c                                         | 2 +-
 net/core/filter.c                                      | 8 ++++----
 36 files changed, 43 insertions(+), 43 deletions(-)

-- 
2.33.1


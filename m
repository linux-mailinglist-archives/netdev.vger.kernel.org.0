Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01A04630AE
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 11:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbhK3KMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:12:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50223 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235812AbhK3KMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 05:12:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638266922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=twwJk6JtGxCJUPAGtD2AzqOgyFV161hRgPPv72whdVw=;
        b=GT2zYxxoZ4lHqIMA1luEpH/JEfdQ5jsI3w7HSsSLLjd7k0gp4w2RnoV4e8YNuYpboiNCu0
        pc5oV7R6vn+WOQ+BLkiyiDLsItncjljS9+70kno6eMCxKVfKOAjOhTpAixKwPYNoRFGyqO
        dUw2YkxqegR3RMvByfsI9Q++MzBw3W8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-69-lL1ijP2cM8C-ZWXjFUB7sw-1; Tue, 30 Nov 2021 05:08:38 -0500
X-MC-Unique: lL1ijP2cM8C-ZWXjFUB7sw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD931109D83E;
        Tue, 30 Nov 2021 10:08:14 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 534DE2B178;
        Tue, 30 Nov 2021 10:08:13 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH v3 net-next 0/2] bpf: do not WARN in bpf_warn_invalid_xdp_action()
Date:   Tue, 30 Nov 2021 11:08:05 +0100
Message-Id: <cover.1638189075.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

v2 -> v3:
 - properly check NULL dev argument (kernel test robot)

v1 -> v2:
 - do not include the device name for maps caller (Toke)

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
 drivers/net/ethernet/microsoft/mana/mana_bpf.c         | 2 +-
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
 37 files changed, 44 insertions(+), 44 deletions(-)

-- 
2.33.1


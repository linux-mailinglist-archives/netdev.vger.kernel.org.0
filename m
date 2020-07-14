Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0E021E483
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgGNAbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgGNAbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 20:31:19 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F20521582;
        Tue, 14 Jul 2020 00:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594686679;
        bh=BVEDmu+aci4iRgQOEITnx9yOMfsDjDSXCLMNWbwAKU4=;
        h=From:To:Cc:Subject:Date:From;
        b=lXS9groAOUX1iHcANpC/AX1fx2qX1WTWD5tHRhZObQyBffxWrDaFUjuD8d6Y6t6MX
         3+4PY3Y+yg7/uiiwo/ivz2JiWin4qnSXKolc0daxuxtcltCO86/D/6HwperI2nQNWl
         RYAz75EMjyvnVKXVZH+Mb5eu7rBKTJTzhevIti0Y=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        thomas.lendacky@amd.com, aelior@marvell.com, skalluru@marvell.com,
        vishal@chelsio.com, benve@cisco.com, _govind@gmx.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/12] udp_tunnel: NIC RX port offload infrastructure
Date:   Mon, 13 Jul 2020 17:30:25 -0700
Message-Id: <20200714003037.669012-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set of patches converts further drivers to use the new
infrastructure to UDP tunnel port offload merged in
commit 0ea460474d70 ("Merge branch 'udp_tunnel-add-NIC-RX-port-offload-infrastructure'").

Jakub Kicinski (12):
  nfp: convert to new udp_tunnel_nic infra
  be2net: convert to new udp_tunnel_nic infra
  xgbe: switch to more generic VxLAN detection
  xgbe: convert to new udp_tunnel_nic infra
  bnx2x: convert to new udp_tunnel_nic infra
  cxgb4: convert to new udp_tunnel_nic infra
  enic: convert to new udp_tunnel_nic infra
  liquidio: convert to new udp_tunnel_nic infra
  liquidio_vf: convert to new udp_tunnel_nic infra
  fm10k: convert to new udp_tunnel_nic infra
  qede: convert to new udp_tunnel_nic infra
  qlcnic: convert to new udp_tunnel_nic infra

 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      | 273 +++---------------
 drivers/net/ethernet/amd/xgbe/xgbe-main.c     |  12 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h          |  13 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |   8 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |   8 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 136 ++-------
 .../net/ethernet/cavium/liquidio/lio_main.c   |  59 ++--
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  59 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   2 -
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 108 ++-----
 drivers/net/ethernet/cisco/enic/enic_main.c   | 105 +++----
 drivers/net/ethernet/emulex/benet/be.h        |   5 -
 drivers/net/ethernet/emulex/benet/be_main.c   | 198 +++----------
 drivers/net/ethernet/intel/fm10k/fm10k.h      |  10 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |   9 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   | 164 ++---------
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |   4 -
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   5 -
 .../ethernet/netronome/nfp/nfp_net_common.c   | 126 +++-----
 drivers/net/ethernet/qlogic/qede/qede.h       |   1 +
 .../net/ethernet/qlogic/qede/qede_filter.c    | 142 +++------
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  18 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h   |   7 +-
 .../ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |  31 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  64 ++--
 25 files changed, 393 insertions(+), 1174 deletions(-)

-- 
2.26.2


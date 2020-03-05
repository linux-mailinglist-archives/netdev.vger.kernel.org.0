Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4CA179F00
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgCEFQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:16:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgCEFQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 00:16:30 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8552208CD;
        Thu,  5 Mar 2020 05:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583385389;
        bh=hC8R0fTazeXhyF475M2ozVSewfDx0kxK8wU8di3JtVE=;
        h=From:To:Cc:Subject:Date:From;
        b=QWOdowySW5/GBiba4MWQKB8tgldlvRLIGe8vnDUzLOHVgnyg39m1SGXeUFSffsK3S
         339h9xsdrn3AdZnCCvCQqyCzTKLh/fvZagELeZ82pxC391wm7Jv/v/M+rJPY3BcrNo
         ivhZ1+PY0Fr+PacMfulD1dU6VBi9WrZ1z5RRZaJ0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, ecree@solarflare.com, mkubecek@suse.cz,
        thomas.lendacky@amd.com, benve@cisco.com, _govind@gmx.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, snelson@pensando.io, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, alexander.h.duyck@linux.intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 00/12] ethtool: consolidate parameter checking for irq coalescing
Date:   Wed,  4 Mar 2020 21:15:30 -0800
Message-Id: <20200305051542.991898-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set aims to simplify and unify the unsupported irq
coalescing parameter handling.

First patch adds a bitmask which drivers should fill in
in their ethtool_ops structs to declare which parameters
they support. Core will then ensure that driver callback
won't see any parameter outside of that set.

This allows us to save some LoC and make sure all drivers
respond the same to unsupported parameters.

If any parameter driver does not support is set to a value
other than 0 core will return -EINVAL. In the future we can
reject any present but unsupported netlink attribute, without
assuming 0 means unset. We can also add some prints or extack,
perhaps a'la Intel's current code.

I started converting the drivers alphabetically but then
realized that for the first set it's probably best to
address a representative mix of actively developed drivers.

According to my unreliable math there are roughly 69 drivers
in the tree which support some form of interrupt coalescing
settings via ethtool. Of these roughly 17 reject parameters
they don't support.

I hope drivers which ignore the parameters don't care, and
won't care about the slight change in behavior. Once all
drivers are converted we can make the checking mandatory.

I've only tested the e1000e and virtio patches, the rest builds.

v2: fix up ice and virtio conversions
v3: (patch 1)
    - move the (temporary) check if driver defines types
      earlier (Michal)
    - rename used_types -> nonzero_params, and
      coalesce_types -> supported_coalesce_params (Alex)
    - use EOPNOTSUPP instead of EINVAL (Andrew, Michal)

Jakub Kicinski (12):
  ethtool: add infrastructure for centralized checking of coalescing
    parameters
  xgbe: let core reject the unsupported coalescing parameters
  enic: let core reject the unsupported coalescing parameters
  stmmac: let core reject the unsupported coalescing parameters
  nfp: let core reject the unsupported coalescing parameters
  ionic: let core reject the unsupported coalescing parameters
  hisilicon: let core reject the unsupported coalescing parameters
  ice: let core reject the unsupported coalescing parameters
  bnxt: reject unsupported coalescing params
  mlx5: reject unsupported coalescing params
  e1000e: reject unsupported coalescing params
  virtio_net: reject unsupported coalescing params

 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c  | 26 +-------
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  6 ++
 .../net/ethernet/cisco/enic/enic_ethtool.c    | 23 ++-----
 drivers/net/ethernet/hisilicon/hip04_eth.c    | 16 +----
 drivers/net/ethernet/intel/e1000e/ethtool.c   |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 59 +----------------
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  3 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  6 ++
 .../mellanox/mlx5/core/ipoib/ethtool.c        |  3 +
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 22 +------
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 23 +------
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 16 +----
 drivers/net/virtio_net.c                      | 14 +---
 include/linux/ethtool.h                       | 45 ++++++++++++-
 net/ethtool/ioctl.c                           | 66 +++++++++++++++++++
 15 files changed, 146 insertions(+), 183 deletions(-)

-- 
2.24.1


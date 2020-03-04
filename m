Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9078417899A
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgCDEe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:34:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgCDEe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 23:34:27 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D93520838;
        Wed,  4 Mar 2020 04:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583296466;
        bh=hSUp3fpqS1d6hhQ8uXD6HNSn34d4iLxN3j/kvG0mmgU=;
        h=From:To:Cc:Subject:Date:From;
        b=eT5C7Q/s/i6ERAaT7w/Jy3OxldPE5jssy1WIsbzEwFf66YXA/WYXnRAUC0xCvAvQG
         pUSMDIqb4XSrkge70qk8tNweCA4zVooxi+0CT71Jb8Fy4/MfAtYBfC478lDpyFYsIb
         BZpQiAcro5gH118HUTel21dVtY/DYJhvinptb+jw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 00/12] ethtool: consolidate parameter checking for irq coalescing
Date:   Tue,  3 Mar 2020 20:33:42 -0800
Message-Id: <20200304043354.716290-1-kuba@kernel.org>
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
 drivers/net/virtio_net.c                      | 14 +----
 include/linux/ethtool.h                       | 45 ++++++++++++-
 net/ethtool/ioctl.c                           | 63 +++++++++++++++++++
 15 files changed, 143 insertions(+), 183 deletions(-)

-- 
2.24.1


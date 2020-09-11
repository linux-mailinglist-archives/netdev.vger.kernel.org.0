Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D512267686
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgIKX3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgIKX27 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 19:28:59 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E0BB21D40;
        Fri, 11 Sep 2020 23:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599866938;
        bh=JhnGyXCe2u9VNFg6x7OmlwnSSW7+nUfLIX5n3vX9WjQ=;
        h=From:To:Cc:Subject:Date:From;
        b=IgnGqXiP5Ovsinm3WHI72rLe/Tyidsxb5BtxdIfaifnHf61zXiuvyIxkCUrW7qM+r
         h4KRz5VR0J2xnZTXcgR5rRHhJ19FgftHcHXIGCLl4t9M1iXTfGLLj8u2JbSdT0bc/V
         RS4IUL0PC8zQdQM8/xtILf/7+x1+dJpZ+xLarBH0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Date:   Fri, 11 Sep 2020 16:28:45 -0700
Message-Id: <20200911232853.1072362-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This is the first (small) series which exposes some stats via
the corresponding ethtool interface. Here (thanks to the
excitability of netlink) we expose pause frame stats via
the same interfaces as ethtool -a / -A.

In particular the following stats from the standard:
 - 30.3.4.2 aPAUSEMACCtrlFramesTransmitted
 - 30.3.4.3 aPAUSEMACCtrlFramesReceived

4 real drivers are converted, hopefully the semantics match
the standard.

v2:
 - netdevsim: add missing static
 - bnxt: fix sparse warning
 - mlx5: address Saeed's comments

Jakub Kicinski (8):
  ethtool: add standard pause stats
  docs: net: include the new ethtool pause stats in the stats doc
  netdevsim: add pause frame stats
  selftests: add a test for ethtool pause stats
  bnxt: add pause frame stats
  ixgbe: add pause frame stats
  mlx5: add pause frame stats
  mlx4: add pause frame stats

 Documentation/networking/ethtool-netlink.rst  |  11 ++
 Documentation/networking/statistics.rst       |  57 ++++++++-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  17 +++
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  11 ++
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |  19 +++
 .../net/ethernet/mellanox/mlx4/mlx4_stats.h   |  12 ++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   9 ++
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   9 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  29 +++++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   3 +
 drivers/net/netdevsim/Makefile                |   2 +-
 drivers/net/netdevsim/ethtool.c               |  64 +++++++++++
 drivers/net/netdevsim/netdev.c                |   1 +
 drivers/net/netdevsim/netdevsim.h             |  11 ++
 include/linux/ethtool.h                       |  26 +++++
 include/uapi/linux/ethtool_netlink.h          |  18 ++-
 net/ethtool/pause.c                           |  57 ++++++++-
 .../drivers/net/netdevsim/ethtool-pause.sh    | 108 ++++++++++++++++++
 18 files changed, 456 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/netdevsim/ethtool.c
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh

-- 
2.26.2


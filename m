Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE4A22A346
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 01:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733032AbgGVXsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 19:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbgGVXsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 19:48:46 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E53E020825;
        Wed, 22 Jul 2020 23:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595461726;
        bh=HDRX8GJw5axG7U4bpdzf3zhI+r92v4HvTlNXTnCxmhQ=;
        h=From:To:Cc:Subject:Date:From;
        b=MV8ju4VGyLdER00ZCbTwwzq3WLYEcV+jKEbY25BUiD1JCODVdSGapBfZsbvRlJvXL
         kJZnwK5j8x+cdgMp/Sg1gbwl6U+5LyH3hL7Pm4BRBS1rfbujJQ4hkPVEuGy3ttMVTh
         jIj/VJJoUA/epOiC/0D6jT0LBPW4QM3pFWu2Tscs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC 0/4] udp_tunnel: convert mlx5 to the new udp_tunnel infrastructure
Date:   Wed, 22 Jul 2020 16:48:34 -0700
Message-Id: <20200722234838.3200228-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set converts the last driver not using the new infrastructure - mlx5.

We need a small amount of special handling as mlx5 expects IANA VXLAN
port to always be programmed into the device. ethtool will show such
ports in a separate, type-less, fake table, at the end:

Tunnel information for eth0:
  UDP port table 0: 
    Size: 7
    Types: vxlan
    No entries
  UDP port table 1: 
    Size: 1
    Types: none (static entries)
    Entries (1):
        port 4789, vxlan

Posting as an RFC because the netdevsim patches will conflict with
the Intel series but otherwise the work should be independent.
Reviews and testing would be much appreciated.

Jakub Kicinski (4):
  udp_tunnel: add the ability to hard-code IANA VXLAN
  mlx5: convert to new udp_tunnel infrastructure
  netdevsim: support the static IANA VXLAN port flag
  selftests: net: add a test for static UDP tunnel ports

 Documentation/networking/ethtool-netlink.rst  |  3 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 -
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 88 ++-----------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 -
 .../ethernet/mellanox/mlx5/core/lib/vxlan.c   | 87 +++++++++---------
 .../ethernet/mellanox/mlx5/core/lib/vxlan.h   |  6 +-
 drivers/net/netdevsim/netdevsim.h             |  1 +
 drivers/net/netdevsim/udp_tunnels.c           |  4 +
 include/net/udp_tunnel.h                      |  5 ++
 net/ethtool/tunnels.c                         | 70 +++++++++++++--
 net/ipv4/udp_tunnel_nic.c                     |  7 ++
 .../drivers/net/netdevsim/udp_tunnel_nic.sh   | 58 ++++++++++++
 12 files changed, 190 insertions(+), 143 deletions(-)

-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED6231516
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgG1VqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbgG1VqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 17:46:18 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E34C2074F;
        Tue, 28 Jul 2020 21:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595972778;
        bh=B3qZcoh20NCg2ULPOohV4FcECGJ9q6OpboMN8B5Blnw=;
        h=From:To:Cc:Subject:Date:From;
        b=Kzfs2t0iU/OlVdx3vdP6SJMuWHQXVqTRAxOYclBeqUfWfWorP3IBTbBceNMjQosRo
         alvqRrPaoi0LFGFseY7nEDUl7hWs1D7VAflso7+ZsS4PrbdYRWIrbTQ6hqLHfIMfPp
         XRs0WXeqdFvgZxEggZCtS26g6vY7KBYhFFKqtGDE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/2] udp_tunnel: convert mlx5 to the new udp_tunnel infrastructure
Date:   Tue, 28 Jul 2020 14:46:04 -0700
Message-Id: <20200728214606.303058-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set converts mlx5 to the new infrastructure.

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

Saeed - this should apply on top of net-next, independently of
the Intel patches, would you mind taking this in for testing
and review? I'll post the netdevsim & test once Intel patches
re-emerge.

v2: - don't disable the offload on reprs in patch #2.

Jakub Kicinski (2):
  udp_tunnel: add the ability to hard-code IANA VXLAN
  mlx5: convert to new udp_tunnel infrastructure

 Documentation/networking/ethtool-netlink.rst  |  3 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 -
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 88 ++-----------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  6 +-
 .../ethernet/mellanox/mlx5/core/lib/vxlan.c   | 87 +++++++++---------
 .../ethernet/mellanox/mlx5/core/lib/vxlan.h   |  6 +-
 include/net/udp_tunnel.h                      |  5 ++
 net/ethtool/tunnels.c                         | 69 +++++++++++++--
 net/ipv4/udp_tunnel_nic.c                     |  7 ++
 9 files changed, 130 insertions(+), 143 deletions(-)

-- 
2.26.2


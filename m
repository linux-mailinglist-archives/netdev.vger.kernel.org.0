Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC8122D3E8
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 04:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgGYCwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 22:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbgGYCwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 22:52:30 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41D2620737;
        Sat, 25 Jul 2020 02:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595645550;
        bh=qqcNpDGZFUFXyUrI2D9pHqYpgAcfKg/NvjiR7pjVVRQ=;
        h=From:To:Cc:Subject:Date:From;
        b=jwPEfZjX08Tg9M/16c813esFRERvybcwb9Fx37MYCHE7HUfIwl1XJ2MovuFJ9FMvd
         bkcJ9XBkCOZyw0lZpCmMAGaG/De26hxDsD+MSzWA/ErW6CIjs7yvEaZP7EtjkAURYe
         vceli6pxWz9j+72YJfpXlnOxCQM9KqhGHu827ZtM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/2] udp_tunnel: convert mlx5 to the new udp_tunnel infrastructure
Date:   Fri, 24 Jul 2020 19:51:44 -0700
Message-Id: <20200725025146.3770263-1-kuba@kernel.org>
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

Jakub Kicinski (2):
  udp_tunnel: add the ability to hard-code IANA VXLAN
  mlx5: convert to new udp_tunnel infrastructure

 Documentation/networking/ethtool-netlink.rst  |  3 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 -
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 88 ++-----------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 -
 .../ethernet/mellanox/mlx5/core/lib/vxlan.c   | 87 +++++++++---------
 .../ethernet/mellanox/mlx5/core/lib/vxlan.h   |  6 +-
 include/net/udp_tunnel.h                      |  5 ++
 net/ethtool/tunnels.c                         | 69 +++++++++++++--
 net/ipv4/udp_tunnel_nic.c                     |  7 ++
 9 files changed, 126 insertions(+), 143 deletions(-)

-- 
2.26.2


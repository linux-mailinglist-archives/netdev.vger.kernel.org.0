Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605FF3390A9
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhCLPFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:43504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229728AbhCLPEr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:04:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4121D64F78;
        Fri, 12 Mar 2021 15:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561487;
        bh=CNHLPIdle5MxLyf1o+fB/u81f7LS7W0UZ0rlCXJLDYo=;
        h=From:To:Cc:Subject:Date:From;
        b=pBR4OGijNwaAIDxQBEuePJKCyIUMYObs+4Lq8GSgZxuf19uN6+k/+jJ0/H9lUthDx
         uU95VZudYJpW1ePL4Hxxq+82uu33/edm0RkfpfYlAFqfqxe5/pT6sHUw6sZ+HIGKLb
         T/OIDYIyqnKy4rKnxGnzTqyGOI/TgJ9YAZaA1JRjnUpxBpYPY8VwuXx2Pe4NnWsCCJ
         CAH4hH71CGogUg9vcf36B/6OE4qjVUwbr8v7vgQfygIxoPNEfP7E4lQpPXWBmGd3As
         9TEcsajJBzrCrevS+diUKsIQToP2TuxQTL0SWvXe6Uh3y8s/wugrn6aWgydsQEfXWk
         UmDZE7p//NXYQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 00/16] net: xps: improve the xps maps handling
Date:   Fri, 12 Mar 2021 16:04:28 +0100
Message-Id: <20210312150444.355207-1-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series aims at fixing various issues with the xps code, including
out-of-bound accesses and use-after-free. While doing so we try to
improve the xps code maintainability and readability.

The main change is moving dev->num_tc and dev->nr_ids in the xps maps, to
avoid out-of-bound accesses as those two fields can be updated after the
maps have been allocated. This allows further reworks, to improve the
xps code readability and allow to stop taking the rtnl lock when
reading the maps in sysfs. The maps are moved to an array in net_device,
which simplifies the code a lot.

Note that patch 6 adds a check to assert the rtnl lock is taken when
calling netif_set_xps_queue. Two drivers (mlx5 and virtio_net) are fixed
in this regard, but we might see new warnings in the near future because
of this. This is expected and shouldn't be an issue (it's only a
warning, and the fix should be fairly easy to do).

One future improvement may be to remove the use of xps_map_mutex from
net/core/dev.c, but that may require extra care.

Thanks!
Antoine

Since v2:
  - Patches 13-16 are new to the series.
  - Fixed another issue I found while preparing v3 (use after free of
    old xps maps).
  - Kept the rtnl lock when calling netdev_get_tx_queue and
    netdev_txq_to_tc.
  - Use get_device/put_device when using the sb_dev.
  - Take the rtnl lock in mlx5 and virtio_net when calling
    netif_set_xps_queue.
  - Fixed a coding style issue.

Since v1:
  - Reordered the patches to improve readability and avoid introducing
    issues in between patches.
  - Use dev_maps->nr_ids to allocate the mask in xps_queue_show but
    still default to nr_cpu_ids/dev->num_rx_queues in xps_queue_show
    when dev_maps hasn't been allocated yet for backward compatibility.

Antoine Tenart (16):
  net-sysfs: convert xps_cpus_show to bitmap_zalloc
  net-sysfs: store the return of get_netdev_queue_index in an unsigned
    int
  net-sysfs: make xps_cpus_show and xps_rxqs_show consistent
  net: embed num_tc in the xps maps
  net: embed nr_ids in the xps maps
  net: assert the rtnl lock is held when calling __netif_set_xps_queue
  net: remove the xps possible_mask
  net: move the xps maps to an array
  net: add an helper to copy xps maps to the new dev_maps
  net: improve queue removal readability in __netif_set_xps_queue
  net-sysfs: move the rtnl unlock up in the xps show helpers
  net-sysfs: move the xps cpus/rxqs retrieval in a common function
  net: fix use after free in xps
  net: NULL the old xps map entries when freeing them
  net/mlx5e: take the rtnl lock when calling netif_set_xps_queue
  virtio_net: take the rtnl lock when calling virtnet_set_affinity

 .../net/ethernet/mellanox/mlx5/core/en_main.c |  11 +-
 drivers/net/virtio_net.c                      |   8 +-
 include/linux/netdevice.h                     |  27 +-
 net/core/dev.c                                | 250 +++++++++---------
 net/core/net-sysfs.c                          | 177 +++++--------
 5 files changed, 233 insertions(+), 240 deletions(-)

-- 
2.29.2


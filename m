Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781E8340D3C
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhCRSiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232666AbhCRSh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 14:37:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0880C6023B;
        Thu, 18 Mar 2021 18:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616092675;
        bh=Zw9UUEM9Y48RCpajlb2jm4fIkam4VbpD5oFXqxAPFsM=;
        h=From:To:Cc:Subject:Date:From;
        b=BmkQhaRefFxj91QOUePHdR8lorfnWuZi3LQ90W6MdSqpisDE8a2QFhYw6mv+P3e/s
         lI1MBV7nJmuUaTc4SQGlHpseoQhb/Gt21pRY+NLx3jGX7f019LGoup8BfveuWdz5vh
         hTWcUkrDT7lRqwSCH+3coEddRnjD3ypuKo6Z3YMgetvku2LX+NnUdIbPUg4CWbI9gK
         bg3mbPcF8IfkDq+Qqeza8gIHFlTgg/GKKMGcz+5qav28kerfALV8rvlUNiIo55DSJL
         pOEO7yD1Cm5iTCPtjohF3nXOTn3MwVrglcO59DUSqss2OY5vjPxUqUJAVv4wYgJ5wp
         JOfHUPmBwa6fA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v4 00/13] net: xps: improve the xps maps handling
Date:   Thu, 18 Mar 2021 19:37:39 +0100
Message-Id: <20210318183752.2612563-1-atenart@kernel.org>
X-Mailer: git-send-email 2.30.2
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

One future improvement may be to remove the use of xps_map_mutex from
net/core/dev.c, but that may require extra care.

Thanks!
Antoine

Since v3:
  - Removed the 3 patches about the rtnl lock and __netif_set_xps_queue
    as there are extra issues. Those patches were not tied to the
    others, and I'll see want can be done as a separate effort.
  - One small fix in patch 12.

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
    when dev_maps hasn't been allocated yet for backward
    compatibility.:w


Antoine Tenart (13):
  net-sysfs: convert xps_cpus_show to bitmap_zalloc
  net-sysfs: store the return of get_netdev_queue_index in an unsigned
    int
  net-sysfs: make xps_cpus_show and xps_rxqs_show consistent
  net: embed num_tc in the xps maps
  net: embed nr_ids in the xps maps
  net: remove the xps possible_mask
  net: move the xps maps to an array
  net: add an helper to copy xps maps to the new dev_maps
  net: improve queue removal readability in __netif_set_xps_queue
  net-sysfs: move the rtnl unlock up in the xps show helpers
  net-sysfs: move the xps cpus/rxqs retrieval in a common function
  net: fix use after free in xps
  net: NULL the old xps map entries when freeing them

 drivers/net/virtio_net.c  |   2 +-
 include/linux/netdevice.h |  27 ++++-
 net/core/dev.c            | 247 ++++++++++++++++++++------------------
 net/core/net-sysfs.c      | 177 +++++++++++----------------
 4 files changed, 222 insertions(+), 231 deletions(-)

-- 
2.30.2


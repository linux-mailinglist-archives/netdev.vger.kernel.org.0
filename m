Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3CB313AB8
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhBHRVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:21:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230264AbhBHRUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:20:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E33FE64E5A;
        Mon,  8 Feb 2021 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612804760;
        bh=CjB3ql4RdI30xWqtJ2kOT9iHdIBwPIhB04QWiPQhXMk=;
        h=From:To:Cc:Subject:Date:From;
        b=smRf9xa8eCx16yP7jpjUX5m5ao7Q/DeTFAJUTNCilwvey997gsI01a7yALIwLJCdi
         yswZr4ulN/3y0cE/phoZ+Gn2YQQAWWk7ZEGSPJqvREdAsYTCWSiZlRJ7yxxdNG5PRp
         HUFbo8DhWTxBhfLcCdjAvz02Ph1FrLtM8UvK7MnNpT4wfRo90Jh7oXO9+lM8uSRaiW
         Q1ZVnqzSOaGKna63J3zmtykwb/Rv4EO6Z6ODJAPQyZhHNDVrlVGrbolMqs3/4AqFyC
         v9Ka/hgsuOU4u7wDjF+z7s6kR83epxC6YOQ+yVREHs5wGPTgrc6wJFspCUFEr8iefU
         6rnzm6fsSXQWQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 00/12] net: xps: improve the xps maps handling
Date:   Mon,  8 Feb 2021 18:19:05 +0100
Message-Id: <20210208171917.1088230-1-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

A small series moving the xps cpus/rxqs retrieval logic in net-sysfs was
sent[1] and while there was no comments asking for modifications in the
patches themselves, we had discussions about other xps related reworks.
In addition to the patches sent in the previous series[1] (included),
this series has extra patches introducing the modifications we
discussed.

The main change is moving dev->num_tc and dev->nr_ids in the xps maps, to
avoid out-of-bound accesses as those two fields can be updated after the
maps have been allocated. This allows further reworks, to improve the
xps code readability and allow to stop taking the rtnl lock when
reading the maps in sysfs.

Finally, the maps are moved to an array in net_device, which simplifies
the code a lot.

One future improvement may be to remove the use of xps_map_mutex from
net/core/dev.c, but that may require extra care.

Thanks!
Antoine

[1] https://lore.kernel.org/netdev/20210106180428.722521-1-atenart@kernel.org/

Since v1:
  - Reordered the patches to improve readability and avoid introducing
    issues in between patches.
  - Use dev_maps->nr_ids to allocate the mask in xps_queue_show but
    still default to nr_cpu_ids/dev->num_rx_queues in xps_queue_show
    when dev_maps hasn't been allocated yet for backward compatibility.

Antoine Tenart (12):
  net-sysfs: convert xps_cpus_show to bitmap_zalloc
  net-sysfs: store the return of get_netdev_queue_index in an unsigned
    int
  net-sysfs: make xps_cpus_show and xps_rxqs_show consistent
  net: embed num_tc in the xps maps
  net: embed nr_ids in the xps maps
  net: assert the rtnl lock is held when calling __netif_set_xps_queue
  net: remove the xps possible_mask
  net: move the xps maps to an array
  net-sysfs: remove the rtnl lock when accessing the xps maps
  net: add an helper to copy xps maps to the new dev_maps
  net: improve queue removal readability in __netif_set_xps_queue
  net-sysfs: move the xps cpus/rxqs retrieval in a common function

 drivers/net/virtio_net.c  |   2 +-
 include/linux/netdevice.h |  27 ++++-
 net/core/dev.c            | 233 +++++++++++++++++++-------------------
 net/core/net-sysfs.c      | 165 +++++++++------------------
 4 files changed, 194 insertions(+), 233 deletions(-)

-- 
2.29.2


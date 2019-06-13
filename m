Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9393444AA5
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbfFMS2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:28:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728711AbfFMS2M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 14:28:12 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 620A13082E6B;
        Thu, 13 Jun 2019 18:28:07 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-44.brq.redhat.com [10.40.200.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 297D559140;
        Thu, 13 Jun 2019 18:28:03 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E85DE3009AEFD;
        Thu, 13 Jun 2019 20:28:01 +0200 (CEST)
Subject: [PATCH net-next v1 00/11] xdp: page_pool fixes and in-flight
 accounting
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Thu, 13 Jun 2019 20:28:01 +0200
Message-ID: <156045046024.29115.11802895015973488428.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 13 Jun 2019 18:28:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fix page_pool API and users, such that drivers can use it for
DMA-mapping. A number of places exist, where the DMA-mapping would not get
released/unmapped, all these are fixed. This occurs e.g. when an xdp_frame
gets converted to an SKB. As network stack doesn't have any callback for XDP
memory models.

The patchset also address a shutdown race-condition. Today removing a XDP
memory model, based on page_pool, is only delayed one RCU grace period. This
isn't enough as redirected xdp_frames can still be in-flight on different
queues (remote driver TX, cpumap or veth).

We stress that when drivers use page_pool for DMA-mapping, then they MUST
use one packet per page. This might change in the future, but more work lies
ahead, before we can lift this restriction.

This patchset change the page_pool API to be more strict, as in-flight page
accounting is added.

---

Ilias Apalodimas (2):
      net: page_pool: add helper function to retrieve dma addresses
      net: page_pool: add helper function to unmap dma addresses

Jesper Dangaard Brouer (9):
      xdp: fix leak of IDA cyclic id if rhashtable_insert_slow fails
      xdp: page_pool related fix to cpumap
      veth: use xdp_release_frame for XDP_PASS
      page_pool: introduce page_pool_free and use in mlx5
      mlx5: more strict use of page_pool API
      xdp: tracking page_pool resources and safe removal
      xdp: force mem allocator removal and periodic warning
      xdp: add tracepoints for XDP mem
      page_pool: add tracepoints for page_pool with details need by XDP


 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |   12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |    3 -
 drivers/net/veth.c                                |    1 
 include/net/page_pool.h                           |   69 +++++++++++-
 include/net/xdp.h                                 |   15 +++
 include/net/xdp_priv.h                            |   23 ++++
 include/trace/events/page_pool.h                  |   87 +++++++++++++++
 include/trace/events/xdp.h                        |  115 ++++++++++++++++++++
 kernel/bpf/cpumap.c                               |    3 +
 net/core/net-traces.c                             |    4 +
 net/core/page_pool.c                              |   87 +++++++++++++--
 net/core/xdp.c                                    |  120 ++++++++++++++++++---
 12 files changed, 494 insertions(+), 45 deletions(-)
 create mode 100644 include/net/xdp_priv.h
 create mode 100644 include/trace/events/page_pool.h

--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6E54A19A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfFRNFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:05:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5027 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfFRNFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:05:20 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0F7B223861;
        Tue, 18 Jun 2019 13:05:14 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FFEA7EA33;
        Tue, 18 Jun 2019 13:05:08 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 57375306665E6;
        Tue, 18 Jun 2019 15:05:07 +0200 (CEST)
Subject: [PATCH net-next v2 00/12] xdp: page_pool fixes and in-flight
 accounting
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Tue, 18 Jun 2019 15:05:07 +0200
Message-ID: <156086304827.27760.11339786046465638081.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 18 Jun 2019 13:05:20 +0000 (UTC)
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

Jesper Dangaard Brouer (10):
      xdp: fix leak of IDA cyclic id if rhashtable_insert_slow fails
      xdp: page_pool related fix to cpumap
      veth: use xdp_release_frame for XDP_PASS
      page_pool: introduce page_pool_free and use in mlx5
      mlx5: more strict use of page_pool API
      xdp: tracking page_pool resources and safe removal
      xdp: force mem allocator removal and periodic warning
      xdp: add tracepoints for XDP mem
      page_pool: add tracepoints for page_pool with details need by XDP
      page_pool: make sure struct device is stable


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
 net/core/page_pool.c                              |   95 +++++++++++++++--
 net/core/xdp.c                                    |  120 ++++++++++++++++++---
 12 files changed, 502 insertions(+), 45 deletions(-)
 create mode 100644 include/net/xdp_priv.h
 create mode 100644 include/trace/events/page_pool.h

--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307C52B1A4E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 12:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgKMLuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 06:50:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:35942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbgKMLte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 06:49:34 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B394C2223C;
        Fri, 13 Nov 2020 11:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605268122;
        bh=RPaLrGPJJAuXPXMlJ74xRTTpGp01uRKuWplrEIVo6aU=;
        h=From:To:Cc:Subject:Date:From;
        b=FrO5hVR1L8OAs4BoPnFdLwpzSBwsgCukBVSYmUwdN+vkdZ0eezL2gRN6DeWtVOXtc
         VaJpTCvXCM3xcERpHw+QUitstu1Nu2o1YN7I3SH84DeodYWClgo/iI9ZR1db22WHQg
         LwVOHKKunNei5tYkxedUo++SyS4MXCnKNf2lvaNo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, john.fastabend@gmail.com
Subject: [PATCH v6 net-nex 0/5] xdp: introduce bulking for page_pool tx return path
Date:   Fri, 13 Nov 2020 12:48:27 +0100
Message-Id: <cover.1605267335.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP bulk APIs introduce a defer/flush mechanism to return
pages belonging to the same xdp_mem_allocator object
(identified via the mem.id field) in bulk to optimize
I-cache and D-cache since xdp_return_frame is usually run
inside the driver NAPI tx completion loop.
Convert mvneta, mvpp2 and mlx5 drivers to xdp_return_frame_bulk APIs.

More details on benchmarks run on mlx5 can be found here:
https://github.com/xdp-project/xdp-project/blob/master/areas/mem/xdp_bulk_return01.org

Changes since v5:
- do not keep looping over ptr_ring if the cache is full but release leftover
  pages running page_pool_return_page

Changes since v4:
- fix comments
- introduce xdp_frame_bulk_init utility routine
- compiler annotations for I-cache code layout
- move rcu_read_lock outside fast-path
- mlx5 xdp bulking code optimization

Changes since v3:
- align DEV_MAP_BULK_SIZE to XDP_BULK_QUEUE_SIZE
- refactor page_pool_put_page_bulk to avoid code duplication

Changes since v2:
- move mvneta changes in a dedicated patch

Changes since v1:
- improve comments
- rework xdp_return_frame_bulk routine logic
- move count and xa fields at the beginning of xdp_frame_bulk struct
- invert logic in page_pool_put_page_bulk for loop

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Lorenzo Bianconi (5):
  net: xdp: introduce bulking for xdp tx return path
  net: page_pool: add bulk support for ptr_ring
  net: mvneta: add xdp tx return bulking support
  net: mvpp2: add xdp tx return bulking support
  net: mlx5: add xdp tx return bulking support

 drivers/net/ethernet/marvell/mvneta.c         | 10 ++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 10 ++-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 22 ++++--
 include/net/page_pool.h                       | 26 +++++++
 include/net/xdp.h                             | 17 ++++-
 net/core/page_pool.c                          | 70 ++++++++++++++++---
 net/core/xdp.c                                | 54 ++++++++++++++
 7 files changed, 192 insertions(+), 17 deletions(-)

-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871512A9BBA
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 19:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgKFST1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 13:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgKFST1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 13:19:27 -0500
Received: from localhost.localdomain (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4467220853;
        Fri,  6 Nov 2020 18:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604686766;
        bh=kUxqyP4MOyVQhNkc1WjIKVrWlS397P7MZjoOpC5WKZw=;
        h=From:To:Cc:Subject:Date:From;
        b=hfw1yDLws7wCw8dWUrz41C56K7ToZxCcIS19fq7O3DbF+CoVJpesuyqsl78f0J2RD
         TgcGeX0khKbGKOxnGx7xX6Fh4zaGEF2OKdIZnszCFksr6980UkNYTzUrSV1Jo26eMG
         TV1s3vgoNbTxRZ0iM/is3djg3EQOcqDz9CAqKfrA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH v4 net-next 0/5] xdp: introduce bulking for page_pool tx return path
Date:   Fri,  6 Nov 2020 19:19:06 +0100
Message-Id: <cover.1604686496.git.lorenzo@kernel.org>
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

Lorenzo Bianconi (5):
  net: xdp: introduce bulking for xdp tx return path
  net: page_pool: add bulk support for ptr_ring
  net: mvneta: add xdp tx return bulking support
  net: mvpp2: add xdp tx return bulking support
  net: mlx5: add xdp tx return bulking support

 drivers/net/ethernet/marvell/mvneta.c         |  5 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  5 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  5 +-
 include/net/page_pool.h                       | 26 ++++++++
 include/net/xdp.h                             | 11 +++-
 net/core/page_pool.c                          | 66 ++++++++++++++++---
 net/core/xdp.c                                | 56 ++++++++++++++++
 7 files changed, 160 insertions(+), 14 deletions(-)

-- 
2.26.2


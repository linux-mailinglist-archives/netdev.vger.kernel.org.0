Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915C02A617C
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 11:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbgKDKYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 05:24:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729341AbgKDKXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 05:23:08 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BE3B223AB;
        Wed,  4 Nov 2020 10:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604485387;
        bh=+RUZHynLyxTatAmq9hoGDTN7qqG/7NdYssFLQkyjpbk=;
        h=From:To:Cc:Subject:Date:From;
        b=jan2z8DmW/i/koF9YOZgmPubatlBkDg+NL5itOcjeGgKr4yGEz8VcNyY2nYDPZE9x
         +OjmPHK6tFCSaQDSdKWi9ra3OME0nkR606aYBE38ynPsAMcPP5Us33Y/6bXhHUNoCx
         dJQaAGlWTXSkkpTiV/FvH2F5xntgZK6WPZF9a5N4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH v3 net-next 0/5] xdp: introduce bulking for page_pool tx return path
Date:   Wed,  4 Nov 2020 11:22:53 +0100
Message-Id: <cover.1604484917.git.lorenzo@kernel.org>
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
 include/net/page_pool.h                       | 26 +++++++++
 include/net/xdp.h                             |  9 +++
 net/core/page_pool.c                          | 35 ++++++++++++
 net/core/xdp.c                                | 56 +++++++++++++++++++
 7 files changed, 138 insertions(+), 3 deletions(-)

-- 
2.26.2


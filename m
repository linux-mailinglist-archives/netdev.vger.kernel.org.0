Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFF929F538
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 20:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgJ2T3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 15:29:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726226AbgJ2T3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 15:29:32 -0400
Received: from lore-desk.redhat.com (unknown [151.66.29.159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B8DC204FD;
        Thu, 29 Oct 2020 19:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603999737;
        bh=oAprieKuw4Y/NSNpSPIW2/x4vRSmn30JSRz7wRBT+/E=;
        h=From:To:Cc:Subject:Date:From;
        b=YCoi2EfUy+4BzvW2/+iao4LP8fxxc5EMX4LKu0cNDseM9akHcAoZmHPn7fW3Z+2fo
         rD6qFGU6xqs5v7A9V01oLRAmCvYgudGqPSfb5ehjq6dgQ4P2yarUiya6yPWVIe6Qkr
         taFmZ46/oiCF3PYWGiBevVOz0oeWpZoUxb20+GT8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH v2 net-next 0/4] xdp: introduce bulking for page_pool tx return path
Date:   Thu, 29 Oct 2020 20:28:43 +0100
Message-Id: <cover.1603998519.git.lorenzo@kernel.org>
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

Changes since v1:
- improve comments
- rework xdp_return_frame_bulk routine logic
- move count and xa fields at the beginning of xdp_frame_bulk struct
- invert logic in page_pool_put_page_bulk for loop

Lorenzo Bianconi (4):
  net: xdp: introduce bulking for xdp tx return path
  net: page_pool: add bulk support for ptr_ring
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


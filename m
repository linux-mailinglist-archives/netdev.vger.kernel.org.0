Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C141103DC9
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 15:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731606AbfKTOyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 09:54:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729157AbfKTOyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 09:54:37 -0500
Received: from localhost.localdomain.com (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C202A206EC;
        Wed, 20 Nov 2019 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574261676;
        bh=Thadl04novci7ML+I1PIxRzBhkBH9ByjE09NDkCvwxE=;
        h=From:To:Cc:Subject:Date:From;
        b=11LjERi4WUHPENZT9ve97XjIBQpGvzNl9o9FDYnn2yMpFZVzuBY/2c6lUW7mtOPdl
         9paWMXiBJWZMTg0Qx7GfgTtXytoy+9GbqxlRhzQ5tHx3fFlYzygHXJRZkivYMU91En
         a9yS3T9fFCwvvZfebwojoalMwO7dLGa8y5XewUSE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, ilias.apalodimas@linaro.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, mcroce@redhat.com,
        jonathan.lemon@gmail.com
Subject: [PATCH v5 net-next 0/3] add DMA-sync-for-device capability to page_pool API
Date:   Wed, 20 Nov 2019 16:54:16 +0200
Message-Id: <cover.1574261017.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the possibility to sync DMA memory for device in the page_pool API.
This feature allows to sync proper DMA size and not always full buffer
(dma_sync_single_for_device can be very costly).
Please note DMA-sync-for-CPU is still device driver responsibility.
Relying on page_pool DMA sync mvneta driver improves XDP_DROP pps of
about 170Kpps:

- XDP_DROP DMA sync managed by mvneta driver:	~420Kpps
- XDP_DROP DMA sync managed by page_pool API:	~585Kpps

Do not change naming convention for the moment since the changes will hit other
drivers as well. I will address it in another series.

Changes since v4:
- do not allow the driver to set max_len to 0
- convert PP_FLAG_DMA_MAP/PP_FLAG_DMA_SYNC_DEV to BIT() macro

Changes since v3:
- move dma_sync_for_device before putting the page in ptr_ring in
  __page_pool_recycle_into_ring since ptr_ring can be consumed
  concurrently. Simplify the code moving dma_sync_for_device
  before running __page_pool_recycle_direct/__page_pool_recycle_into_ring

Changes since v2:
- rely on PP_FLAG_DMA_SYNC_DEV flag instead of dma_sync

Changes since v1:
- rename sync in dma_sync
- set dma_sync_size to 0xFFFFFFFF in page_pool_recycle_direct and
  page_pool_put_page routines
- Improve documentation

Lorenzo Bianconi (3):
  net: mvneta: rely on page_pool_recycle_direct in mvneta_run_xdp
  net: page_pool: add the possibility to sync DMA memory for device
  net: mvneta: get rid of huge dma sync in mvneta_rx_refill

 drivers/net/ethernet/marvell/mvneta.c | 24 +++++++++++-------
 include/net/page_pool.h               | 24 +++++++++++++-----
 net/core/page_pool.c                  | 36 +++++++++++++++++++++++++--
 3 files changed, 67 insertions(+), 17 deletions(-)

-- 
2.21.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3914FC873
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 15:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfKNOKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 09:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfKNOKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 09:10:53 -0500
Received: from localhost.localdomain.com (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D3320715;
        Thu, 14 Nov 2019 14:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573740653;
        bh=49WhZRAlU70+vumQlj1DEZ/48qWk1N3wyj/YF34aXZw=;
        h=From:To:Cc:Subject:Date:From;
        b=P6bhsfZgtIFHhpm1bjesLTS9if1J194yqLzZJVBoocM1h3jnFu49HbxJMmxbIXYHS
         w53Wcv09+H8RhQvej0Wtc0RQ2GxI67itysXIEbwtIxh/r8JQfb7ZyRcSNsbxDf6VnZ
         /Yj6fpiM3ypvSmKxRMfJkcMeRxIXX/uIlYYwcV3s=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, ilias.apalodimas@linaro.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, mcroce@redhat.com
Subject: [PATCH v2 net-next 0/3] add DMA-sync-for-device capability to page_pool API
Date:   Thu, 14 Nov 2019 16:10:34 +0200
Message-Id: <cover.1573740067.git.lorenzo@kernel.org>
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
Please note DMA-sync-for-CPU is still device drivers responsibility.
Relying on page_pool DMA sync mvneta driver improves XDP_DROP pps of
about 180Kpps:

- XDP_DROP DMA sync managed by mvneta driver:	~420Kpps
- XDP_DROP DMA sync managed by page_pool API:	~595Kpps

Changes since v1:
- rename sync in dma_sync
- set dma_sync_size to 0xFFFFFFFF in page_pool_recycle_direct and
  page_pool_put_page routines
- Improve documentation

Lorenzo Bianconi (3):
  net: mvneta: rely on page_pool_recycle_direct in mvneta_run_xdp
  net: page_pool: add the possibility to sync DMA memory for device
  net: mvneta: get rid of huge dma sync in mvneta_rx_refill

 drivers/net/ethernet/marvell/mvneta.c | 23 ++++++++++++------
 include/net/page_pool.h               | 16 +++++++++---
 net/core/page_pool.c                  | 35 ++++++++++++++++++++++-----
 3 files changed, 56 insertions(+), 18 deletions(-)

-- 
2.21.0


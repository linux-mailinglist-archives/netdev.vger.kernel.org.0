Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 888AEFE554
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 20:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfKOTBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 14:01:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbfKOTBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 14:01:55 -0500
Received: from localhost.localdomain.com (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABF1F20732;
        Fri, 15 Nov 2019 19:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573844514;
        bh=tlj22l7/LTEexEzbFvzvD4XsFk/OMusxlw3mMaGexVM=;
        h=From:To:Cc:Subject:Date:From;
        b=SNtrkLQZ6ndJJ1Ex21KOOwerLQaD0sMIMN9XTviIycpMcrGDpw5PelW44T5NL16AO
         ggkWDR6BWdCWudhgFYAc/uQsUIqknvt5A2xksIIvdpgjeD5sL8HKGX21/JDmXydQzg
         dsR20YXNItgWZ7gFa7HpcDMlLpmSRSrt53/bIjSU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, ilias.apalodimas@linaro.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, mcroce@redhat.com
Subject: [PATCH v3 net-next 0/3] add DMA-sync-for-device capability to page_pool API
Date:   Fri, 15 Nov 2019 21:01:36 +0200
Message-Id: <cover.1573844190.git.lorenzo@kernel.org>
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
about 180Kpps:

- XDP_DROP DMA sync managed by mvneta driver:	~420Kpps
- XDP_DROP DMA sync managed by page_pool API:	~595Kpps

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

 drivers/net/ethernet/marvell/mvneta.c | 24 +++++++++------
 include/net/page_pool.h               | 21 ++++++++++----
 net/core/page_pool.c                  | 42 +++++++++++++++++++++++----
 3 files changed, 66 insertions(+), 21 deletions(-)

-- 
2.21.0


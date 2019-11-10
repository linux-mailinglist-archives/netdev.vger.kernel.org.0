Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B2BF68D7
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 13:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfKJMJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 07:09:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfKJMJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 07:09:32 -0500
Received: from localhost.localdomain (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28C0720818;
        Sun, 10 Nov 2019 12:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573387771;
        bh=ZqkxJb+MiOhZ4V2mSqUJErYXEkJA4jPMiCwhVTyIGy8=;
        h=From:To:Cc:Subject:Date:From;
        b=oNPk0g0Egh0KNS39ErQmtCmgKnIZhvkf8gqC2B7eplcIk3riIPGxDjxjpDspdT84H
         ug9a3RS7aGZbulwx29Dd7HQ+U7niMonGODrgwJVCil+lYyp8H5InvjSh8RRNBIfn1Z
         ZIUVdlbiW2mKKY+e9UA9yCLqccV41aplFSh6KYtk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com
Subject: [PATCH net-next 0/3] add DMA sync capability to page_pool API
Date:   Sun, 10 Nov 2019 14:09:07 +0200
Message-Id: <cover.1573383212.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the possibility to sync DMA memory in the page_pool API for
non-coherent devices. This feature allows to sync proper DMA size and
not always full buffer (dma_sync_single_for_device can be very costly).
Relying on page_pool DMA sync mvneta driver improves XDP_DROP pps of
about 180Kpps:

- XDP_DROP DMA sync managed by mvneta driver:	~420Kpps
- XDP_DROP DMA sync managed by page_pool API:	~595Kpps

Lorenzo Bianconi (3):
  net: mvneta: rely on page_pool_recycle_direct in mvneta_run_xdp
  net: page_pool: add the possibility sync dma memory for non-coherent
    devices
  net: mvneta: get rid of huge dma sync in mvneta_rx_refill

 drivers/net/ethernet/marvell/mvneta.c | 23 ++++++++++------
 include/net/page_pool.h               | 11 +++++---
 net/core/page_pool.c                  | 39 ++++++++++++++++++++++-----
 3 files changed, 55 insertions(+), 18 deletions(-)

-- 
2.21.0


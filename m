Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A08D608D
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 12:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731520AbfJNKuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 06:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731305AbfJNKuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 06:50:15 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C35220854;
        Mon, 14 Oct 2019 10:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571050215;
        bh=fsE5wHSrCebivqhQQxTtoL+hlJowNSQUCSqRiSY+5fU=;
        h=From:To:Cc:Subject:Date:From;
        b=PAEh2ogYw2QUyzd7ZKu5/c80rQ7tKABSz1B6AI8Trx5DXJcKi81Cqp83dyHWatfsK
         m9+II9YiUvIkswdcszq14cnwHrMJM126ShF8B54PGSa0hCohQqTWmTylMuIfX7jvng
         uGdcEvHOj5MFG3oolLj6VNMIQwX74Zsg55CCs7uw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: [PATCH v3 net-next 0/8] add XDP support to mvneta driver
Date:   Mon, 14 Oct 2019 12:49:47 +0200
Message-Id: <cover.1571049326.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add XDP support to mvneta driver for devices that rely on software
buffer management. Supported verdicts are:
- XDP_DROP
- XDP_PASS
- XDP_REDIRECT
- XDP_TX
Moreover set ndo_xdp_xmit net_device_ops function pointer in order to support
redirecting from other device (e.g. virtio-net).
Convert mvneta driver to page_pool API.
This series is based on previous work done by Jesper and Ilias.
We will send follow-up patches to reduce DMA-sync operations.

Changes since v2:
- rely on page_pool_recycle_direct instead of xdp_return_buff for XDP_DROP
- define xdp buffer in mvneta_rx_swbm and avoid default initializations
- use dma_sync_single_for_cpu instead of dma_sync_single_range_for_cpu
- run page_pool_release_page in mvneta_swbm_add_rx_fragment even if the buffer
  contains just ETH_FCS

Changes since v1:
- sync dma buffers before refilling hw queues
- fix stats accounting

Changes since RFC:
- implement XDP_TX
- make tx pending buffer list agnostic
- code refactoring
- check if device is running in mvneta_xdp_setup

Lorenzo Bianconi (8):
  net: mvneta: introduce mvneta_update_stats routine
  net: mvneta: introduce page pool API for sw buffer manager
  net: mvneta: rely on build_skb in mvneta_rx_swbm poll routine
  net: mvneta: sync dma buffers before refilling hw queues
  net: mvneta: add basic XDP support
  net: mvneta: move header prefetch in mvneta_swbm_rx_frame
  net: mvneta: make tx buffer array agnostic
  net: mvneta: add XDP_TX support

 drivers/net/ethernet/marvell/Kconfig  |   1 +
 drivers/net/ethernet/marvell/mvneta.c | 631 +++++++++++++++++++-------
 2 files changed, 472 insertions(+), 160 deletions(-)

-- 
2.21.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFA7DD74E
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 10:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfJSINi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 04:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfJSINi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 04:13:38 -0400
Received: from localhost.localdomain (unknown [151.66.3.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CE3A21D80;
        Sat, 19 Oct 2019 08:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571472817;
        bh=kGL9v8H0zy9WW5WtAgkJUOPtk3SwxeV8jXaXr2zwTyw=;
        h=From:To:Cc:Subject:Date:From;
        b=f66K9Wd2EG/CDQcY716jM8+7MqmnHjpbd0pGuDtzdVeCiD2w3ZiFcK8O4DTBFhpR0
         +c6gG5grlmkYV8FpF0LZu6FFxAKkv+TTYxzLP2tf5zcuoXDbDC2YjhglbGZntBQVhm
         0SZdjesLnszaCfVjjlxPWJlkGS4zdI/lb0+SNorc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com, jakub.kicinski@netronome.com
Subject: [PATCH v5 net-next 0/7] add XDP support to mvneta driver
Date:   Sat, 19 Oct 2019 10:13:20 +0200
Message-Id: <cover.1571472169.git.lorenzo@kernel.org>
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
Moreover set ndo_xdp_xmit net_device_ops function pointer in order
to support redirecting from other device (e.g. virtio-net).
Convert mvneta driver to page_pool API.
This series is based on previous work done by Jesper and Ilias.
We will send follow-up patches to reduce DMA-sync operations.

Changes since v4:
- reset page_pool pointer to NULL in mvneta_rxq_drop_pkts and in
  mvneta_create_page_pool error path
- move dma sync in mvneta_rx_refill() in patch 2/7
- verify bpf prog pointer in mvneta_xdp_setup to double-check if
  stop/start is really necessary
- coding style fixes

Changes since v3:
- rename MVNETA_XDP_CONSUMED in MVNETA_XDP_DROPPED
- squash patch 4/8 and patch 3/8
- fix dma sync for XDP_TX verdict
- fix queue_index in xdp_rxq_info_reg
- cosmetics

Changes since v2:
- rely on page_pool_recycle_direct instead of xdp_return_buff for XDP_DROP
- define xdp buffer in mvneta_rx_swbm and avoid default initializations
- use dma_sync_single_for_cpu instead of dma_sync_single_range_for_cpu
- run page_pool_release_page in mvneta_swbm_add_rx_fragment even if
  the buffer contains just ETH_FCS

Changes since v1:
- sync dma buffers before refilling hw queues
- fix stats accounting

Changes since RFC:
- implement XDP_TX
- make tx pending buffer list agnostic
- code refactoring
- check if device is running in mvneta_xdp_setup

Lorenzo Bianconi (7):
  net: mvneta: introduce mvneta_update_stats routine
  net: mvneta: introduce page pool API for sw buffer manager
  net: mvneta: rely on build_skb in mvneta_rx_swbm poll routine
  net: mvneta: add basic XDP support
  net: mvneta: move header prefetch in mvneta_swbm_rx_frame
  net: mvneta: make tx buffer array agnostic
  net: mvneta: add XDP_TX support

 drivers/net/ethernet/marvell/Kconfig  |   1 +
 drivers/net/ethernet/marvell/mvneta.c | 618 +++++++++++++++++++-------
 2 files changed, 470 insertions(+), 149 deletions(-)

-- 
2.21.0


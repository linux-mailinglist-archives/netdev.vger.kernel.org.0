Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7083DD9C25
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 23:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406497AbfJPVDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 17:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfJPVDX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 17:03:23 -0400
Received: from localhost.localdomain (unknown [151.66.3.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C47D020872;
        Wed, 16 Oct 2019 21:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571259802;
        bh=hd5sTpCzaxiyxUfwpjomQM3HNySDB2BN3Xa2f7YKVSk=;
        h=From:To:Cc:Subject:Date:From;
        b=O34+z4EoPPxWNOnwXXKFjZWnLWdznJdo7VvKod5Yw/jxkcRSRvGGjWN1WWQhXrOxe
         R5NEoILZAOuulxT4jdnLtMIaMrruc96BW+ShnQZkF7Y7HBLXpP07oK3C9Vh2Srdame
         kwzweShAi1o9Jepw6Sdb4Tc9VrJRPfGFn141E1yY=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com, jakub.kicinski@netronome.com
Subject: [PATCH v4 net-next 0/7] add XDP support to mvneta driver
Date:   Wed, 16 Oct 2019 23:03:05 +0200
Message-Id: <cover.1571258792.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/marvell/mvneta.c | 632 +++++++++++++++++++-------
 2 files changed, 473 insertions(+), 160 deletions(-)

-- 
2.21.0


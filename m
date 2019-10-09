Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B823ED1C8F
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732218AbfJIXSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731145AbfJIXSw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 19:18:52 -0400
Received: from localhost.localdomain (unknown [151.66.37.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D95D1206C0;
        Wed,  9 Oct 2019 23:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570663132;
        bh=YwSebObcyXh1agm7q15cb4cv9xJB2D/ZByC7Z338erE=;
        h=From:To:Cc:Subject:Date:From;
        b=p8KV8+bvZlRvBGnYRyvBESN3dqElsyBA+5dcfLFI+ZRB9R8hpCCqDrr27V3dcT7pt
         Q64HmFAXrQ4xzlMiaf11VFH8bMmIMlu/zQZySZYf/bFrdAZ+isz364qlMARONmHPu9
         2wPyjo8po4Ztw5D6bQ/ISdD3F54st6kzxRWbMV/s=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: [PATCH v2 net-next 0/8] add XDP support to mvneta driver
Date:   Thu, 10 Oct 2019 01:18:30 +0200
Message-Id: <cover.1570662004.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/marvell/mvneta.c | 630 +++++++++++++++++++-------
 2 files changed, 471 insertions(+), 160 deletions(-)

-- 
2.21.0


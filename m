Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E22CCCB8
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 22:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfJEUo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 16:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfJEUo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 16:44:56 -0400
Received: from lore-desk.lan (unknown [151.66.37.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1013222C5;
        Sat,  5 Oct 2019 20:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570308295;
        bh=b7W5pOI7PokibKU7g4+n3RClfS4MjV44kHyT0UKjGSQ=;
        h=From:To:Cc:Subject:Date:From;
        b=zHRjfUNtX+BY0svLZwR3o6QI+ogBZ0kGnoLw0K+zqaImgQAlw9CsVCFoNGa+yHG0y
         3OqlGxdxnSm7hGpmp8/jjsAnNtqqSK8Gzubvj5mVXZ+mGEajgOQQN8FpguxDfqPRqI
         dRzP1bS8NICJkDKbhAg5DJlUaiWaAwsCkbb9uwPE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, matteo.croce@redhat.com
Subject: [PATCH 0/7] add XDP support to mvneta driver
Date:   Sat,  5 Oct 2019 22:44:33 +0200
Message-Id: <cover.1570307172.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/marvell/mvneta.c | 627 +++++++++++++++++++-------
 2 files changed, 468 insertions(+), 160 deletions(-)

-- 
2.21.0


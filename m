Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A784F10C
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 09:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfD3HSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 03:18:02 -0400
Received: from first.geanix.com ([116.203.34.67]:43578 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfD3HSC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 03:18:02 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id AC378308E8F;
        Tue, 30 Apr 2019 07:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556608674; bh=4rqV1Wk3WHJpxTLnolP66mxNSRcVmroFO5cATlZaLUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=R3e+bOV/z04aUZC05P782AkVNVzP1SWU6XSRxW2w8ynpYLunNL+dyGNphRhx36lGF
         WjJMgnNJQ2FnLBk85yOPRPFau/Bk5ioVFxGfGzL/WYX1UH6OJtH9u2dZ5UU9i5zarK
         ZHcNq3E7zfzfhNhiGQtuCUjLXtIwwYnG0GlWSaSzaUQ2JPmUdDmopfp+DI6pHFVdI1
         /gTHirVWGZD6zl15W4rZBHJRlsUf1AGFkobu6QtDmlp++z8JJE/tvE0NdXj1xOjUDG
         hmhlbnJQIQ1jFd8x/zd+xzrjSVeaFKX+47+rCrODl3nahf0/ug/66D0HWHhc4zgwXC
         tuKvjAhFq8A9Q==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Michal Simek <michal.simek@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Yang Wei <yang.wei9@zte.com.cn>,
        YueHaibing <yuehaibing@huawei.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/12] net: ll_temac: x86_64 support
Date:   Tue, 30 Apr 2019 09:17:47 +0200
Message-Id: <20190430071759.2481-1-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429083422.4356-1-esben@geanix.com>
References: <20190429083422.4356-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b7bf6291adac
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for use of ll_temac driver with
platform_data configuration and fixes endianess and 64-bit problems so
that it can be used on x86_64 platform.

A few bugfixes are also included.

Changes since v2:
  - Fixed lp->indirect_mutex initialization regression for OF
    platforms introduced in v2

Changes since v1:
  - Make indirect_mutex specification mandatory when using platform_data
  - Move header to include/linux/platform_data
  - Enable COMPILE_TEST for XILINX_LL_TEMAC
  - Rebased to v5.1-rc7


Esben Haabendal (12):
  net: ll_temac: Fix and simplify error handling by using devres
    functions
  net: ll_temac: Extend support to non-device-tree platforms
  net: ll_temac: Fix support for 64-bit platforms
  net: ll_temac: Add support for non-native register endianness
  net: ll_temac: Fix support for little-endian platforms
  net: ll_temac: Allow use on x86 platforms
  net: ll_temac: Support indirect_mutex share within TEMAC IP
  net: ll_temac: Fix iommu/swiotlb leak
  net: ll_temac: Fix bug causing buffer descriptor overrun
  net: ll_temac: Replace bad usage of msleep() with usleep_range()
  net: ll_temac: Allow configuration of IRQ coalescing
  net: ll_temac: Enable DMA when ready, not before

 drivers/net/ethernet/xilinx/Kconfig           |   5 +-
 drivers/net/ethernet/xilinx/ll_temac.h        |  26 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   | 519 +++++++++++++++++---------
 drivers/net/ethernet/xilinx/ll_temac_mdio.c   |  53 +--
 include/linux/platform_data/xilinx-ll-temac.h |  32 ++
 5 files changed, 432 insertions(+), 203 deletions(-)
 create mode 100644 include/linux/platform_data/xilinx-ll-temac.h

-- 
2.4.11


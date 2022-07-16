Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BA3576C5A
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 09:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiGPHer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 03:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiGPHeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 03:34:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57262E9C7
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 00:34:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29BC760C00
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 07:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9C3C34114;
        Sat, 16 Jul 2022 07:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657956884;
        bh=aXcypMJ8Aw9aRI5gpgw0Ik52pfX90PV8mAPwawjM6Vo=;
        h=From:To:Cc:Subject:Date:From;
        b=scVCqwaB45yPcObm48WyqO30zp677bBvfG1a8Q2fdILkGJ8mRVcH5S5/8NCanxMMn
         x5CimiOoA1na6j87VOTuEO4cFMcQDPVWuX5hz5M25gGog5x/B0SGx3rdfVMnjGdgFu
         j3Wdx0RPvA2cCpIrM9D28C2N/aa7Ogd7X1PBlhxpkoktYn4XFKkIeI8+pXHpVrQB54
         ok4Buy13OcbCv7w58zdOtxNQ7NqaoalrvlYeNfh0VCyYaSo7emAq00wA62p5UJqB5V
         GvLoIwCIKn+S8ixzemKFxPcgWA+iMP/7qXl1I7NgZ1xLcnOsA+aZK6IitrBV3LGOWS
         GSpjZUuWIObqg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH v3 net-next 0/5] mtk_eth_soc: add xdp support
Date:   Sat, 16 Jul 2022 09:34:26 +0200
Message-Id: <cover.1657956652.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce XDP support for mtk_eth_soc driver if rx hwlro is not
enabled in the chipset (e.g. mt7986).
Supported XDP verdicts:
- XDP_PASS
- XDP_DROP
- XDP_REDIRECT
- XDP_TX
- ndo_xdp_xmit
Rely on page_pool allocator for single page buffers in order to keep
them dma mapped and add skb recycling support.

Changes since v2:
- fix leftover sparse warning
- add page_pool ethtool stats

Changes since v1:
- do not allocate mtk_xdp_stats array on the stack in mtk_rx_poll
- add rcu annotation to bpf program

Lorenzo Bianconi (5):
  net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers
  net: ethernet: mtk_eth_soc: add basic XDP support
  net: ethernet: mtk_eth_soc: introduce xdp ethtool counters
  net: ethernet: mtk_eth_soc: add xmit XDP support
  net: ethernet: mtk_eth_soc: add support for page_pool_get_stats

 drivers/net/ethernet/mediatek/Kconfig       |   2 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 564 +++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  34 +-
 3 files changed, 529 insertions(+), 71 deletions(-)

-- 
2.36.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0158057285B
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 23:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiGLVQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 17:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiGLVQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 17:16:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B68CC781
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 14:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 26DCECE1DB2
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 21:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF18C3411C;
        Tue, 12 Jul 2022 21:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657660589;
        bh=AbUcC72Ah9hQ2GlOEd5+kOaYu7/y5h2BxO/b/U1a5nA=;
        h=From:To:Cc:Subject:Date:From;
        b=CkDgr5I6RaJVvfkDnqlsYIh9e1yynkfROfTMvZIX9p9yghbCp+f4LgqHR9lxQGPKE
         uEknR9NgRn5hHc3vusoma34k8KNx4lAZggBSAZH97WWINDz5+sl23cyEaJfxeiRks6
         p2C/ik9+9jG0uIYTSnFMoZlX5N+QafGeHuxLJZX7EQTyPb0GZdYR0dFQaaSOVZWlhD
         n+zSkKbZx5M/kW1dRLkxFYl7sis7yB6SX9hRI+qBWLt2Chy9t/YBC1HQ94JIlLW5i5
         UfqkWaA7V+SyeheYxfbxtlbn1SD8B+MwewPfNvLdasfT9DJxGOPAOq84SoBz1pjznL
         AzLOFrBndAkdQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH v2 net-next 0/4] mtk_eth_soc: add xdp support
Date:   Tue, 12 Jul 2022 23:16:13 +0200
Message-Id: <cover.1657660277.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
- do not allocate mtk_xdp_stats array on the stack in mtk_rx_poll
- add rcu annotation to bpf program

Lorenzo Bianconi (4):
  net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers
  net: ethernet: mtk_eth_soc: add basic XDP support
  net: ethernet: mtk_eth_soc: introduce xdp ethtool counters
  net: ethernet: mtk_eth_soc: add xmit XDP support

 drivers/net/ethernet/mediatek/Kconfig       |   1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 524 +++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  34 +-
 3 files changed, 491 insertions(+), 68 deletions(-)

-- 
2.36.1


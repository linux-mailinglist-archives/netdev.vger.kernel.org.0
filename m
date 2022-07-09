Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E35F56CA65
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 17:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiGIPtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 11:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiGIPtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 11:49:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E99810FF8
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 08:48:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50F13B819CA
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 15:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B95DC3411C;
        Sat,  9 Jul 2022 15:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657381736;
        bh=sqhl2+qpAkvEcbSeL7R8DIr884GD434thtHF8xdUfZ8=;
        h=From:To:Cc:Subject:Date:From;
        b=IO8mbt/rGmWcs1q7/c3JhwDzl/A1Laif8i+N5ouhM2yFyCYQYBM9h5EMmVbkwEG08
         hrs8lQXR/3/0woVigIdgtE2C9B/eHmxFzRQoG7baJ8qAv4+G+So5Qu7E3dnZo0BiI4
         RcYx6cV0owGJE/AwV62czyQ0xonW79Llxb18008nhUcmn7j4OP4tmF2OaHQI7ueoAi
         HHiGH2Fp+bDMz3fW6cYXEmMCoLSKqgJ8g/FQ1PA/KYmNvfUrLItFGgCrb/kAp4/X/q
         KoyqrgXZu/tjB4U9flBF4dDUE4ycYA03PFEwqHGWVzddygQbabyBfymi6Yfm+yuPG3
         N7wPhwG7JCjzQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH net-next 0/4] mtk_eth_soc: add xdp support
Date:   Sat,  9 Jul 2022 17:48:28 +0200
Message-Id: <cover.1657381056.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Lorenzo Bianconi (4):
  net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers
  net: ethernet: mtk_eth_soc: add basic XDP support
  net: ethernet: mtk_eth_soc: introduce xdp ethtool counters
  net: ethernet: mtk_eth_soc: add xmit XDP support

 drivers/net/ethernet/mediatek/Kconfig       |   1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 546 +++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  34 +-
 3 files changed, 513 insertions(+), 68 deletions(-)

-- 
2.36.1


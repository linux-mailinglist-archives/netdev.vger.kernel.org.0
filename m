Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1571B57DB13
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 09:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiGVHUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 03:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbiGVHUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 03:20:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C723BAB
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 00:20:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D25F621C0
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 07:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31E4C341C6;
        Fri, 22 Jul 2022 07:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658474405;
        bh=yqRNzyJg+fSV//vMTnzmP5OyPzyg8nL3aMeh38VyGNs=;
        h=From:To:Cc:Subject:Date:From;
        b=n42sZhAX59RqdAnxtGdo3HAacZfIJ35RTuCR6Z8ef5/vrc4WkOfms5gkzdLsrh7Jf
         z4swg2ZtYL6SXbO6blfFi7NyA9Yjb5cauB6cjVfVIKAC07PppzTqlwDFDLiOasfzeR
         bib9bB0C1t3dcBd95ESHEoqy1cjBhcAWW9Wo8q7u+ef4m0U30CxO3HwrxMxN8hSfPo
         cChmHicutcj/xzvwJni1PJP9Vj1Tl7V1Vp6DV9K4qKREXaY3lakjy1881izsyd1gq8
         YyDsFoWJEpCQWN4AI4gcbF0P0FqVEZlqKnAiEuiHo/8dMK5042mXUlGMjVu1q1IwmK
         HXTnZjwpDtn6g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH v4 net-next 0/5] mtk_eth_soc: add xdp support
Date:   Fri, 22 Jul 2022 09:19:35 +0200
Message-Id: <cover.1658474059.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Changes since v3:
- add missing rcu_read_lock()/rcu_read_unlock()
- introduce mtk_page_pool_enabled() utility routine

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
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 572 +++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  34 +-
 3 files changed, 537 insertions(+), 71 deletions(-)

-- 
2.36.1


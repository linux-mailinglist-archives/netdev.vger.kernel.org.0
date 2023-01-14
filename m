Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FDD66ACC1
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 18:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjANRBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 12:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjANRBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 12:01:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A276DA5EB
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 09:01:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B0CF60BFF
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 17:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4F6C433D2;
        Sat, 14 Jan 2023 17:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673715699;
        bh=98zHMoSqmHit6X+kXUwElyOZPhVbLUIYPQxvfNSVhx4=;
        h=From:To:Cc:Subject:Date:From;
        b=I1b59xkViv98PmPgcVUm+qyZddrtABxjYLT4O2x7KedhZjUTdiZZ+ACfChbZYGIvW
         XT8XkNbLNzdU9vhND+b0DW06LHqGap1KKKX0xkmPwJxassXeV02bjyytNTPjwJBv3c
         eg/vsP5Ey9ciu+OcE3hseMjZgs+Z6Dx/4GPRpKsgTBYO4ax6IaWR5unZNSuCxZd3bU
         MIhKuFzckUINZO4R1jqIHZuxtVl+t6/YXiyR9GQ0IjtBF8+To0Dn0MBC8vuRKc7p89
         WiXqvcIQisWI3RIcqfvJ1U+rHRwI9+Jxb5mdrANgHivNJ6BI7/ObvfRmVthEbohJ8j
         BRSZVjZZBCGbw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org,
        alexander.duyck@gmail.com
Subject: [PATCH v6 net-next 0/5] net: ethernet: mtk_wed: introduce reset support
Date:   Sat, 14 Jan 2023 18:01:27 +0100
Message-Id: <cover.1673715298.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce proper reset integration between ethernet and wlan drivers in order
to schedule wlan driver reset when ethernet/wed driver is resetting.
Introduce mtk_hw_reset_monitor work in order to detect possible DMA hangs.

Changes since v5:
- log error reported by reset callback
- convert reset_complete callback from int to void

Changes since v4:
- add missing usleep_range

Changes since v3:
- rely on msleep() utility instead of mdelay() in mtk_hw_init() and
  usleep_range() in mtk_ppe_prepare_reset() since the code runs in
  non-atomic context

Changes since v2:
- rebase on top of net-next
- move rtnl_lock/rtnl_unlock in reset callback
- re-run mtk_prepare_for_reset() after mtk_wed_fe_reset() acquiring RTNL lock

Changes since v1:
- rebase on top of net-next

Lorenzo Bianconi (5):
  net: ethernet: mtk_eth_soc: introduce mtk_hw_reset utility routine
  net: ethernet: mtk_eth_soc: introduce mtk_hw_warm_reset support
  net: ethernet: mtk_eth_soc: align reset procedure to vendor sdk
  net: ethernet: mtk_eth_soc: add dma checks to mtk_hw_reset_check
  net: ethernet: mtk_wed: add reset/reset_complete callbacks

 drivers/net/ethernet/mediatek/mtk_eth_soc.c  | 297 ++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h  |  38 +++
 drivers/net/ethernet/mediatek/mtk_ppe.c      |  27 ++
 drivers/net/ethernet/mediatek/mtk_ppe.h      |   1 +
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h |   6 +
 drivers/net/ethernet/mediatek/mtk_wed.c      |  42 +++
 drivers/net/ethernet/mediatek/mtk_wed.h      |   9 +
 include/linux/soc/mediatek/mtk_wed.h         |   2 +
 8 files changed, 383 insertions(+), 39 deletions(-)

-- 
2.39.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95606647A4
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjAJRtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbjAJRtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:49:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AB75F4B5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:49:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE3B3B818F9
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 17:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7B8C433D2;
        Tue, 10 Jan 2023 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673372978;
        bh=MRs1rHhGp92jsVIX8FWZCrYsPZq5D7L/9rIww5w5Lr0=;
        h=From:To:Cc:Subject:Date:From;
        b=ELZTv08c2o7gShHjw0UKNEACq/7+aozAVI6E2sSkBFKiqxV9L78YCtcPkplv3pxTG
         ymWs7BKKdOKlP4ETtuAs+EST2s8ZEj+JN57mvnkWLwZ1rPdipluOSKhOS4yFg37+uR
         iUEmry7ohLUit7wOY6stRcf7H41b9ghA8YXwOxCYCesFOoVPbvNXsGLYSh/IF3ioAm
         zlak1AwsJ+9IBM0C9B5Ch0XAU08ITJ04uiknhpyMJhzP5+U0YP9uj5tjh83Qgrk2Gc
         GL5TIj8w5NgkhN1yfJhZXI7ItPl2BMSbiSJxmyHsGLMBdzlZrmTe+KkCdTYdWGjL/o
         u5Pyp11nF1Mdw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: [PATCH v4 net-next 0/5] net: ethernet: mtk_wed: introduce reset support
Date:   Tue, 10 Jan 2023 18:49:20 +0100
Message-Id: <cover.1673372414.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/mediatek/mtk_wed.c      |  40 +++
 drivers/net/ethernet/mediatek/mtk_wed.h      |   8 +
 include/linux/soc/mediatek/mtk_wed.h         |   2 +
 8 files changed, 379 insertions(+), 40 deletions(-)

-- 
2.39.0


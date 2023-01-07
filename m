Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73795660F9B
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 15:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjAGOvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 09:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjAGOvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 09:51:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF19216
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 06:51:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A47C3B81975
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 14:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8D2C433D2;
        Sat,  7 Jan 2023 14:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673103080;
        bh=wioYI3i7PiwpBEZ+tZzjLvvew6sL4iUpozMsoTz0zwg=;
        h=From:To:Cc:Subject:Date:From;
        b=SxHE9EhK0bmegAMxZ+p8huMYzjaVwT3Ey454XlQatjKa/fy+Bgp+iKDSmojl1Y0RK
         CHjxg8c3FVs2aY/5WnFRWC3fJapLuXBxK79yides4eoxHVvLQ/Hl1T2HmoeNrdvLcf
         g0iO5In+qlxdSKIdSbV2YApvq//VF9KdJyX3ySy0alse42pw7EJzhDQGXisbJUHHVn
         zdjF16b6WfMsVAm4+OLav+6VUnnsJOmhYcaMF0l1PlbZ5hlSLtPHOWSwUYQ+LvWPKN
         2iGCxZ18iSnZIxOoft/m1OiURqhbStQwHjIpk3E8NRPW92sw120qwW/yvkoEGTHEml
         Uby3YkqCg3lhg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: [PATCH v3 net-next 0/5] net: ethernet: mtk_wed: introduce reset support
Date:   Sat,  7 Jan 2023 15:50:49 +0100
Message-Id: <cover.1673102767.git.lorenzo@kernel.org>
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

 drivers/net/ethernet/mediatek/mtk_eth_soc.c  | 300 ++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h  |  38 +++
 drivers/net/ethernet/mediatek/mtk_ppe.c      |  27 ++
 drivers/net/ethernet/mediatek/mtk_ppe.h      |   1 +
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h |   6 +
 drivers/net/ethernet/mediatek/mtk_wed.c      |  40 +++
 drivers/net/ethernet/mediatek/mtk_wed.h      |   8 +
 include/linux/soc/mediatek/mtk_wed.h         |   2 +
 8 files changed, 381 insertions(+), 41 deletions(-)

-- 
2.39.0


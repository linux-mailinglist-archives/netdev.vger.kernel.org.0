Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66FD60E1DF
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJZNTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbiJZNSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:18:50 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B589FFF235;
        Wed, 26 Oct 2022 06:17:40 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,214,1661785200"; 
   d="scan'208";a="140456021"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 26 Oct 2022 22:17:40 +0900
Received: from localhost.localdomain (unknown [10.226.92.188])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id C09FD4255D25;
        Wed, 26 Oct 2022 22:17:34 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 0/6] R-Car CAN FD driver enhancements
Date:   Wed, 26 Oct 2022 14:17:26 +0100
Message-Id: <20221026131732.1843105-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CAN FD IP found on RZ/G2L SoC has some HW features different to that
of R-Car. For example, it has multiple resets, dedicated channel tx
and error interrupts, separate global rx and error interrupts compared
to shared irq for R-Car. it does not s ECC error flag registers
and clk post divider present on R-Car.
Similarly, R-Car V3U has 8 channels whereas other SoCs has only 2
channels. Currently all the HW differences are handled by comparing
with chip_id enum.

This patch series aims to replace chip_id with struct rcar_canfd_hw_info
to handle the HW feature differences and driver data present
on both IPs.

The changes are trivial and tested on RZ/G2L SMARC EVK.

This patch series depend upon[1]
[1] https://lore.kernel.org/linux-renesas-soc/20221025155657.1426948-1-biju.das.jz@bp.renesas.com/T/#t

v1->v2:
 * Updated commit description for R-Car V3U SoC detection using
   driver data.
 * Replaced data type of max_channels from u32->unsigned int.
 * Replaced multi_global_irqs->shared_global_irqs to make it
   positive checks.
 * Replaced clk_postdiv->postdiv driver data variable.
 * Simplified the calcualtion for fcan_freq.
 * Replaced info->has_gerfl to gpriv->info->has_gerfl and wrapped
   the ECC error flag checks inside a single if statement.
 * Added Rb tag from Geert patch#1,#2,#3 and #5

Biju Das (6):
  can: rcar_canfd: rcar_canfd_probe: Add struct rcar_canfd_hw_info to
    driver data
  can: rcar_canfd: Add max_channels to struct rcar_canfd_hw_info
  can: rcar_canfd: Add shared_global_irqs to struct rcar_canfd_hw_info
  can: rcar_canfd: Add postdiv to struct rcar_canfd_hw_info
  can: rcar_canfd: Add multi_channel_irqs to struct rcar_canfd_hw_info
  can: rcar_canfd: Add has_gerfl_eef to struct rcar_canfd_hw_info

 drivers/net/can/rcar/rcar_canfd.c | 104 ++++++++++++++++++------------
 1 file changed, 63 insertions(+), 41 deletions(-)

-- 
2.25.1


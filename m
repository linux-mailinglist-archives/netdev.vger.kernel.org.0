Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B42C5646CC
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbiGCKrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiGCKrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:47:16 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1EC0642C;
        Sun,  3 Jul 2022 03:47:14 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,241,1650898800"; 
   d="scan'208";a="124888145"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 03 Jul 2022 19:47:13 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 67DA1427AD01;
        Sun,  3 Jul 2022 19:47:08 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 0/6] Add support for RZ/N1 SJA1000 CAN controller
Date:   Sun,  3 Jul 2022 11:46:59 +0100
Message-Id: <20220703104705.341070-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series aims to add support for RZ/N1 SJA1000 CAN controller.

The SJA1000 CAN controller on RZ/N1 SoC has some differences compared
to others like it has no clock divider register (CDR) support and it has
no HW loopback (HW doesn't see tx messages on rx), so introduced a new
compatible 'renesas,rzn1-sja1000' to handle these differences.

v1->v2:
 * Moved $ref: can-controller.yaml# to top along with if conditional to
   avoid multiple mapping issues with the if conditional in the subsequent
   patch.
 * Added an example for RZ/N1D SJA1000 usage.
 * Updated commit description for patch#2,#3 and #6
 * Removed the quirk macro SJA1000_NO_HW_LOOPBACK_QUIRK
 * Added prefix SJA1000_QUIRK_* for quirk macro.
 * Replaced of_device_get_match_data->device_get_match_data.
 * Added error handling on clk error path
 * Started using "devm_clk_get_optional_enabled" for clk get,prepare and enable.

Ref:
 [1] https://lore.kernel.org/linux-renesas-soc/20220701162320.102165-1-biju.das.jz@bp.renesas.com/T/#t

Biju Das (6):
  dt-bindings: can: sja1000: Convert to json-schema
  dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S} support
  can: sja1000: Add Quirk for RZ/N1 SJA1000 CAN controller
  can: sja1000: Use device_get_match_data to get device data
  can: sja1000: Change the return type as void for SoC specific init
  can: sja1000: Add support for RZ/N1 SJA1000 CAN Controller

 .../bindings/net/can/nxp,sja1000.yaml         | 136 ++++++++++++++++++
 .../devicetree/bindings/net/can/sja1000.txt   |  58 --------
 drivers/net/can/sja1000/sja1000.c             |  13 +-
 drivers/net/can/sja1000/sja1000.h             |   3 +-
 drivers/net/can/sja1000/sja1000_platform.c    |  56 +++++---
 5 files changed, 184 insertions(+), 82 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/sja1000.txt

-- 
2.25.1


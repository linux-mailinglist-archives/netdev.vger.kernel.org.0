Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32D1565409
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 13:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbiGDLqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 07:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiGDLqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 07:46:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70911146B;
        Mon,  4 Jul 2022 04:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656935164; x=1688471164;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bSictZZlQk8kvD6FBfESakih6SXoepE+d4RIMig+lpo=;
  b=pXxG92xcd8hyUF/aEWzopEQKw+jfJzasopq5vlt1v/+mm1o55eYOr5yI
   Z1+qowp/tGxaTB8N2vdhW7WdO6gM8HSvJ+KSmN5NoHtxin6rtHFCKvRa+
   v5u4efGrCekR8Kfwt4NfT2XdaeBRy9OBv3ZgtFW9+vs3xDFZy9VwoByQJ
   lVb0wfm07QwH9cYMzKcWr71Q7uVWPKXKc9ztxsCLZaa+bvYdRZ2HwSI80
   N+mpn4waG+rbde4M7811ElakIQ7Bu59/ymGPzeqpUGb+SGPXSVKPwSoFu
   5JiD4pFR4H7t3QVKBdPgnpbBFElKz3GJfLZWrt5dcdH7/BAmRHEDTFnzP
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="102905894"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jul 2022 04:46:03 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 4 Jul 2022 04:46:03 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 4 Jul 2022 04:46:00 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Conor Dooley" <conor.dooley@microchip.com>
Subject: [net-next PATCH v2 0/5] PolarFire SoC macb reset support
Date:   Mon, 4 Jul 2022 12:45:07 +0100
Message-ID: <20220704114511.1892332-1-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey all,
Jakub requested that these patches be split off from the series
adding the reset controller itself that I sent ~yesterday~ last
week [0].

The Cadence MACBs on PolarFire SoC (MPFS) have reset capability and are
compatible with the zynqmp's init function. I have removed the zynqmp
specific comments from that function & renamed it to reflect what it
does, since it is no longer zynqmp only.

MPFS's MACB had previously used the generic binding, so I also added
the required specific binding.

For v2, I noticed some low hanging cleanup fruit so there are extra
patches added for that:
moving the init function out of the config structs, aligning the
alignment of the zynqmp & default config structs with the other dozen
or so structs & simplifing the error paths to use dev_err_probe().

Feel free to apply as many or as few of those as you like.

Thanks,
Conor.

Changes since v1:
- added the 3 aforementioned cleanup patches
- fixed two stylistic complaints from Claudiu

Conor Dooley (5):
  dt-bindings: net: cdns,macb: document polarfire soc's macb
  net: macb: add polarfire soc reset support
  net: macb: unify macb_config alignment style
  net: macb: simplify error paths in init_reset_optional()
  net: macb: sort init_reset_optional() with other init()s

 .../devicetree/bindings/net/cdns,macb.yaml    |   1 +
 drivers/net/ethernet/cadence/macb_main.c      | 106 +++++++++---------
 2 files changed, 56 insertions(+), 51 deletions(-)

-- 
2.36.1


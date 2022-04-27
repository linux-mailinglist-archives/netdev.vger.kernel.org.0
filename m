Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E7151119F
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358346AbiD0GvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244328AbiD0GvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:51:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C5D14CC1F;
        Tue, 26 Apr 2022 23:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651042091; x=1682578091;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Wrr2acTes9Dn1J1j0LC1OLNlWlSW00Omrf7FPInY+0E=;
  b=YWzVY4L/R/BPgol7as31JIvecyXz4aUWTkAPUxZcQ8cEhzpHzSg6rEtu
   iIpkjzf+Ql/qmBx9pG8qc+pCqhuPI5WDF8Zff7gOg0SlbUrKsIgVWH78A
   UPfG3nPMMejpaLMM8QAi0G5vVsIgiGr232aNrYJbloq2WgYKbzFcQAuf7
   wEIIOd8s5FHPdfXqdL/XsoAg93xb94tjN41JejfSkO8BuuNLk4RpejPUt
   vwsCrcl75VWsSbMIuFaC9A0WMcqx7Npi0TPLLLuQqk6lvouAam1rJ8i41
   JKD3/mxjxJ9XwzbIhRa256vtM3em2935SqXy8zmauJjaPZNQMZi36zgiJ
   w==;
X-IronPort-AV: E=Sophos;i="5.90,292,1643698800"; 
   d="scan'208";a="153965848"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2022 23:48:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 26 Apr 2022 23:48:08 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 26 Apr 2022 23:48:06 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/5] net: lan966x: Add support for PTP programmable pins
Date:   Wed, 27 Apr 2022 08:51:22 +0200
Message-ID: <20220427065127.3765659-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lan966x has 8 PTP programmable pins. The last pin is hardcoded to be used
by PHC0 and all the rest are shareable between the PHCs. The PTP pins can
implement both extts and perout functions.

v1->v2:
- use ptp_find_pin_unlocked instead of ptp_find_pin inside the irq handler.

Horatiu Vultur (5):
  dt-bindings: net: lan966x: Extend with the ptp external interrupt.
  net: lan966x: Change the PTP pin used to read/write the PHC.
  net: lan966x: Add registers used to configure the PTP pin
  net: lan966x: Add support for PTP_PF_PEROUT
  net: lan966x: Add support for PTP_PF_EXTTS

 .../net/microchip,lan966x-switch.yaml         |   2 +
 .../ethernet/microchip/lan966x/lan966x_main.c |  17 ++
 .../ethernet/microchip/lan966x/lan966x_main.h |   4 +
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 276 +++++++++++++++++-
 .../ethernet/microchip/lan966x/lan966x_regs.h |  40 +++
 5 files changed, 338 insertions(+), 1 deletion(-)

-- 
2.33.0


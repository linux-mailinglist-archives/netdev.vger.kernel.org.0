Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E554DCDE4
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbiCQSum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237584AbiCQSul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:50:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A366514964C;
        Thu, 17 Mar 2022 11:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647542964; x=1679078964;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZmwolZ5iOd/9V4MN6DapEmj7rhiSSyG/Olfb51uk8Nk=;
  b=P2FE7yt0lsG78FVzk+y0JJV83P6YNuMRk2OeIijCX/br6YUpfFvq5Sb4
   wHqUSAsrr//Mkwqvw/t0uZdkSOQrSx4qheBsu+Qb2Owsx0d5IIJZSb0zy
   GjR6by5YXKG4Ud6NdOqjx5M7W4sx4rNKEx/W0rStLFoATWMRKOBnWJvBP
   ivl25OYn3BbkNNSdTtevvb1v85oE4ESi24RVU3BfYXqTx0HkVoENg3eUt
   CvcptiUffaObytPWJ2AC41Cb+PPCHR/ph59mnFIt4zko61z6MCjASvMvS
   MVcNYq2lillaQ0t3VARlsNiXTZ6Rr9C29YkQC8PapPwL6dGu86CCmmA8u
   g==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="89304216"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 11:49:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 11:49:23 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 17 Mar 2022 11:49:21 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/5] net: lan966x: Add support for FDMA
Date:   Thu, 17 Mar 2022 19:51:54 +0100
Message-ID: <20220317185159.1661469-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when injecting or extracting a frame from CPU, the frame
is given to the HW each word at a time. There is another way to
inject/extract frames from CPU using FDMA(Frame Direct Memory Access).
In this way the entire frame is given to the HW. This improves both
RX and TX bitrate.

Horatiu Vultur (5):
  dt-bindings: net: lan966x: Extend with FDMA interrupt
  net: lan966x: Add registers that are used for FDMA.
  net: lan966x: Expose functions that are needed by FDMA
  net: lan966x: Add FDMA functionality
  net: lan96x: Update FDMA to change MTU.

 .../net/microchip,lan966x-switch.yaml         |   2 +
 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 772 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  44 +-
 .../ethernet/microchip/lan966x/lan966x_main.h | 120 +++
 .../ethernet/microchip/lan966x/lan966x_port.c |   3 +
 .../ethernet/microchip/lan966x/lan966x_regs.h | 106 +++
 7 files changed, 1037 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c

-- 
2.33.0


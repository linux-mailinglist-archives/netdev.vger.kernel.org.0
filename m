Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DCA63286B
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiKUPmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbiKUPmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:42:09 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB61A4B986;
        Mon, 21 Nov 2022 07:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669045323; x=1700581323;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2/oxAXLOp39GLFi3+acpxJRqZsGAlZP5t3Ltf3CliCM=;
  b=LgQygZbQ0MgLSdO+awtg5xeQnaSkWnA74mu7ENK9nSgqgeLD8No4yz00
   sJdozDQo97IpyydlLVeP8q2KGZ2mk2nQevkzCVaYQVOtWOPSPD6TurV+T
   nHqlbPI+oeQyqYRmhQ+3Pordjd8W3sJPlLlq95NqjEBfhnC3GrjEvNtQ9
   qQ4EPvEfZQln1WxRi1JDdrDMAhnfFiQMjkVM2tJJJu7l04HeT4OFiYB10
   TwSEAEcbrGLgfFHXvOHC4D8BUUwIJPPW5M/HexGH1nlI7q9OIlgdHFKd3
   pN6Ahk+ko9DAwYUi/2unPd/lVdqVhuzF2c843g3GiY/9RqQ2iSsoXxmLN
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="189907560"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Nov 2022 08:42:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 21 Nov 2022 08:42:02 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 21 Nov 2022 08:41:58 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: [RFC Patch net-next v2 0/8] net: dsa: microchip: add PTP support for KSZ9x and LAN937x
Date:   Mon, 21 Nov 2022 21:11:42 +0530
Message-ID: <20221121154150.9573-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LAN937x switch has capable for supporting IEEE 1588 PTP protocol. This
patch series add PTP support and tested using the ptp4l application.
LAN937x has the same PTP register set similar to KSZ9563, hence the
implementation has been made common for the ksz switches.
KSZ9563 does not support two step timestamping but LAN937x supports both.
Tested the 1step & 2step p2p timestamping in LAN937x and p2p1step
timestamping in KSZ9563.

RFC v1 -> v2
- Added the p2p1step timestamping and conditional execution of 2 step for
  LAN937x only.
- Added the periodic output support

Arun Ramadoss (7):
  net: dsa: microchip: adding the posix clock support
  net: dsa: microchip: Initial hardware time stamping support
  net: dsa: microchip: Manipulating absolute time using ptp hw clock
  net: dsa: microchip: enable the ptp interrupt for timestamping
  net: dsa: microchip: Adding the ptp packet reception logic
  net: dsa: microchip: add the transmission tstamp logic
  net: dsa: microchip: ptp: add periodic output signal

Christian Eggers (1):
  net: ptp: add helper for one-step P2P clocks

 drivers/net/dsa/microchip/Kconfig       |   12 +
 drivers/net/dsa/microchip/Makefile      |    5 +
 drivers/net/dsa/microchip/ksz_common.c  |   44 +-
 drivers/net/dsa/microchip/ksz_common.h  |   48 +
 drivers/net/dsa/microchip/ksz_ptp.c     | 1117 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h     |   96 ++
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  136 +++
 include/linux/dsa/ksz_common.h          |   55 ++
 include/linux/ptp_classify.h            |   73 ++
 net/dsa/tag_ksz.c                       |  288 +++++-
 10 files changed, 1859 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.c
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.h
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp_reg.h
 create mode 100644 include/linux/dsa/ksz_common.h

-- 
2.36.1


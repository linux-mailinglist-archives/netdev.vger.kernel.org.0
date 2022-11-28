Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AB863A61F
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiK1Kc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiK1Kc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:32:57 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7E710C1;
        Mon, 28 Nov 2022 02:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669631573; x=1701167573;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RKGu8AereV3oFQUJ8+g7J+D6DU1lqTrSFzCBi04Ag68=;
  b=Lsj/8gwl6I3yB8KjOh5Xb9/hiUjK4WY+iWsCSkAq67v4VRK39gt8dpJA
   x0Qom9G3PzEcY3u8KZ8AWSwuR/ztDSouHM+fiegl8s3/obVkR9U6LKi3i
   k+TeyTtj0g9uvuTixaUAL1qhe4jwQx81mLiLjnf4hMxKgHpl1yZwYEkm+
   2nbcZKgKOgpLarX6Oy/Saa7sM0I4grU+PSRI+baZCSOzmE+GdrU+wr8wz
   5crXkvxmnu3stNT0uAL6xugIubpKhTJUEu72Mv7P3StGt96iIAlJQ1z6I
   ZEnB3gV0XfIg7SPT1Qfwp2V9KbpPyct0gO1rLsyT5W5RHc5ZfrIp0i0r4
   g==;
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="188931263"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2022 03:32:51 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 28 Nov 2022 03:32:51 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 28 Nov 2022 03:32:45 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v1 00/12] net: dsa: microchip: add PTP support for KSZ9563/KSZ8563 and LAN937x
Date:   Mon, 28 Nov 2022 16:02:15 +0530
Message-ID: <20221128103227.23171-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KSZ9563/KSZ8563 and  LAN937x switch are capable for supporting IEEE 1588 PTP
protocol.  LAN937x has the same PTP register set similar to KSZ9563, hence the
implementation has been made common for the KSZ switches.  KSZ9563 does not
support two step timestamping but LAN937x supports both.  Tested the 1step &
2step p2p timestamping in LAN937x and p2p1step timestamping in KSZ9563.

This patch series is based on the Christian Eggers PTP support for KSZ9563.
Applied the Christian patch and updated as per the latest refactoring of KSZ
series code. The features added on top are PTP packet Interrupt
implementation based on nested handler, LAN937x two step timestamping and
programmable per_out pins.

Link: https://www.spinics.net/lists/netdev/msg705531.html

RFC v2 -> Patch v1
- Changed the patch author based on past patch submission
- Changed the commit message prefix as net: dsa: microchip: ptp
Individual patch changes are listed in correspondig commits.

RFC v1 -> v2
- Added the p2p1step timestamping and conditional execution of 2 step for
  LAN937x only.
- Added the periodic output support

Arun Ramadoss (4):
  net: dsa: microchip: ptp: add 4 bytes in tail tag when ptp enabled
  net: dsa: microchip: ptp: enable interrupt for timestamping
  net: dsa: microchip: ptp: add 2 step timestamping for LAN937x
  net: dsa: microchip: ptp: add support for perout programmable pins

Christian Eggers (8):
  net: dsa: microchip: ptp: add the posix clock support
  net: dsa: microchip: ptp: Initial hardware time stamping support
  net: dsa: microchip: ptp: Manipulating absolute time using ptp hw
    clock
  net: ptp: add helper for one-step P2P clocks
  net: dsa: microchip: ptp: add packet reception timestamping
  net: dsa: microchip: ptp: add packet transmission timestamping
  net: dsa: microchip: ptp: move pdelay_rsp correction field to tail tag
  net: dsa: microchip: ptp: add periodic output signal

 MAINTAINERS                             |    1 +
 drivers/net/dsa/microchip/Kconfig       |   11 +
 drivers/net/dsa/microchip/Makefile      |    5 +
 drivers/net/dsa/microchip/ksz_common.c  |   45 +-
 drivers/net/dsa/microchip/ksz_common.h  |   46 +
 drivers/net/dsa/microchip/ksz_ptp.c     | 1132 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h     |  101 ++
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  147 +++
 include/linux/dsa/ksz_common.h          |   55 ++
 include/linux/ptp_classify.h            |   73 ++
 net/dsa/tag_ksz.c                       |  275 +++++-
 11 files changed, 1873 insertions(+), 18 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.c
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.h
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp_reg.h
 create mode 100644 include/linux/dsa/ksz_common.h


base-commit: a6e3d86ece0b42a571a11055ace5c3148cb7ce76
-- 
2.36.1


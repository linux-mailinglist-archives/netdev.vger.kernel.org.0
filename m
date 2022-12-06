Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26F0643F83
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbiLFJOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLFJOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:14:47 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B83C2DFB;
        Tue,  6 Dec 2022 01:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670318087; x=1701854087;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=41maBJWSA+KHxYSRffA4bRimbz6oUD4nzZp8MVlzs20=;
  b=BdjGHrzaUWkHyQYOpe0M1/RUJt/PBcGagOR5gdUUvHJBXp8PPjKEatEN
   0o5lOzXgsIvsLsLAbqnR2v/L1bnSgRReVBMGWyJyvtRVTdYJCvdSKTSRX
   WnlJmcQCuZ2PiN5M5oZhwK3qpsM7BwoA13u2xYTvV2AjbeCIjH9Kism8B
   HH8nL6u+xydwclNyjsKjnMCXv5v2FGl3P602jczlbW2HbcMy16uAVNl20
   GdFhHsfiWGUueZEanpBOB8fsUQyVB7NjE48vQPP7LdZhqIvyl5vf3xuHZ
   lchxOLGKp3sRrP+S7jb0R6Rdeb8DbOfSZP1zlqKoXe/ydcgqa5hT2DGb2
   w==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="191874464"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 02:14:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 02:14:43 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 02:14:37 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v2 00/13] net: dsa: microchip: add PTP support for KSZ9563/KSZ8563 and LAN937x
Date:   Tue, 6 Dec 2022 14:44:15 +0530
Message-ID: <20221206091428.28285-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Patch v1 -> v2
- GPIO perout enable bit is different for LAN937x and KSZ9x. Added new patch
for configuring LAN937x programmable pins.
- PTP enabled in hardware based on both tx and rx timestamping of all the user
ports.
- Replaced setting of 802.1AS bit with P2P bit in PTP_MSG_CONF1 register.

RFC v2 -> Patch v1
- Changed the patch author based on past patch submission
- Changed the commit message prefix as net: dsa: microchip: ptp
Individual patch changes are listed in correspondig commits.

RFC v1 -> v2
- Added the p2p1step timestamping and conditional execution of 2 step for
  LAN937x only.
- Added the periodic output support

Arun Ramadoss (5):
  net: dsa: microchip: ptp: add 4 bytes in tail tag when ptp enabled
  net: dsa: microchip: ptp: enable interrupt for timestamping
  net: dsa: microchip: ptp: add support for perout programmable pins
  net: dsa: microchip: ptp: lan937x: add 2 step timestamping
  net: dsa: microchip: ptp: lan937x: Enable periodic output in LED pins

Christian Eggers (8):
  net: dsa: microchip: ptp: add the posix clock support
  net: dsa: microchip: ptp: Initial hardware time stamping support
  net: dsa: microchip: ptp: manipulating absolute time using ptp hw
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
 drivers/net/dsa/microchip/ksz_common.h  |   48 +
 drivers/net/dsa/microchip/ksz_ptp.c     | 1157 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h     |   88 ++
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  142 +++
 include/linux/dsa/ksz_common.h          |   54 ++
 include/linux/ptp_classify.h            |   71 ++
 net/dsa/tag_ksz.c                       |  271 +++++-
 11 files changed, 1875 insertions(+), 18 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.c
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.h
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp_reg.h
 create mode 100644 include/linux/dsa/ksz_common.h


base-commit: c9f8d73645b6f76c8d14f49bc860f7143d001cb7
-- 
2.36.1


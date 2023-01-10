Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB928663BB8
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 09:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjAJIvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 03:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbjAJIum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 03:50:42 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAF25371C;
        Tue, 10 Jan 2023 00:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673340599; x=1704876599;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BBdovsgplLEsmsAL8RTzVlMLITE3Mi+IAqk/wcVY71U=;
  b=WA8ryBbq/Qhg7ldvvjSXs0Y1FbIY9hc/HeZ/PuzTYh56VbllCSIhOstZ
   JvPU58sCEXnlwZJnQE9j6I63fIPaaRy4silb4KRrbh/lDK7wIdwJcIafz
   kizHozdijpaQ4+uvz3BXcMQM/QPZb05GHSAu/0I4UfffMtFjKKHf+m5hn
   gd0B+AJYIqFl0WaayrR3CIxiZzpSEY2cbgRdCGTSHXPlEyyIuddmlSGTM
   /Gh5tPuKnV/hHHYZvNUT4meD42OwO3/HmleBZscmYZH+2X+GIaimLKnU5
   2AmEQZ5NZ1xtku8FECkrAaXqcbaWWtWDdqe4t78TqbqdIO2ow92cNNU5z
   w==;
X-IronPort-AV: E=Sophos;i="5.96,314,1665471600"; 
   d="scan'208";a="131614317"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jan 2023 01:49:57 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 01:49:55 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 01:49:48 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v8 00/13] net: dsa: microchip: add PTP support for KSZ9563/KSZ8563 and LAN937x
Date:   Tue, 10 Jan 2023 14:19:17 +0530
Message-ID: <20230110084930.16049-1-arun.ramadoss@microchip.com>
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

Patch v7 -> v8
- set skb->ip_summed = CHECKSUM_NONE after updating the checksum

Patch v6 -> v7
- Corrected the misplaced spaces and tabs
- Added mutex lock in do_aux_work
- Replaced 0/1 with false/true for ts_en
- SKB_TX_INPROGRESS flag is set before dsa_enqueue_skb
- Removed the fallthrough keyword
- pdelay_resp header correction is performed based on
  KSZ_SKB_CB(skb)->update_correction instead of clone

Patch v5 -> v6
- Rebased to latest net-next and renamed from RFC to patch net-next.

Patch v4 -> v5
- Replaced irq_domain_add_simple with irq_doamin_add_linear
- Used the helper diff_by_scaled_ppm() for adjfine.

Patch v3 -> v4
- removed IRQF_TRIGGER_FALLING from the request_threaded_irq of ptp msg
- addressed review comments on patch 10 periodic output
- added sign off in patch 6 & 9
- reverted to set PTP_1STEP bit for lan937x which is missed during v3 regression

Patch v2-> v3
- used port_rxtstamp for reconstructing the absolute timestamp instead of
tagger function pointer.
- Reverted to setting of 802.1As bit.

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
 drivers/net/dsa/microchip/ksz_common.c  |   44 +-
 drivers/net/dsa/microchip/ksz_common.h  |   48 +
 drivers/net/dsa/microchip/ksz_ptp.c     | 1199 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h     |   86 ++
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  142 +++
 include/linux/dsa/ksz_common.h          |   53 +
 include/linux/ptp_classify.h            |   73 ++
 net/dsa/tag_ksz.c                       |  201 +++-
 11 files changed, 1845 insertions(+), 18 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.c
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.h
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp_reg.h
 create mode 100644 include/linux/dsa/ksz_common.h


base-commit: cbdbb58b6c796e48ad6346e07bf3ae65cf4dc69b
-- 
2.36.1


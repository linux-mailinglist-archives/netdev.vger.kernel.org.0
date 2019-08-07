Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18D184890
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 11:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfHGJZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 05:25:04 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:45405 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfHGJZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 05:25:04 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 0442A20012;
        Wed,  7 Aug 2019 09:25:01 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: [PATCH net-next v5 0/6] net: mscc: PTP Hardware Clock (PHC) support
Date:   Wed,  7 Aug 2019 11:22:08 +0200
Message-Id: <20190807092214.19936-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series introduces the PTP Hardware Clock (PHC) support to the Mscc
Ocelot switch driver. In order to make use of this, a new register bank
is added and described in the device tree, as well as a new interrupt.
The use this bank and interrupt was made optional in the driver for dt
compatibility reasons.

Thanks!
Antoine

Since v4:
  - Added SKBTX_IN_PROGRESS.
  - Fixed two xmas trees.
  - Rework the loop condition in ocelot_ptp_rdy_irq_handler.

Since v3:
  - Fixed a spin_unlock_irqrestore issue.

Since v2:
  - Prevented from a possible infinite loop when reading the h/w
    timestamps.
  - s/GFP_KERNEL/GFP_ATOMIC/ in the Tx path.
  - Set rx_filter to HWTSTAMP_FILTER_PTP_V2_EVENT at probe.
  - Fixed s/w timestamping dependencies.
  - Added Paul Burton's Acked-by on patches 2 and 4.

Since v1:
  - Used list_for_each_safe() in ocelot_deinit().
  - Fixed a memory leak in ocelot_deinit() by calling
    dev_kfree_skb_any().
  - Fixed a locking issue in get_hwtimestamp().
  - Handled the NULL case of ptp_clock_register().
  - Added comments on optional dt properties.

Antoine Tenart (6):
  Documentation/bindings: net: ocelot: document the PTP bank
  Documentation/bindings: net: ocelot: document the PTP ready IRQ
  net: mscc: describe the PTP register range
  net: mscc: improve the frame header parsing readability
  net: mscc: remove the frame_info cpuq member
  net: mscc: PTP Hardware Clock (PHC) support

 .../devicetree/bindings/net/mscc-ocelot.txt   |  20 +-
 drivers/net/ethernet/mscc/ocelot.c            | 396 +++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot.h            |  49 ++-
 drivers/net/ethernet/mscc/ocelot_board.c      | 146 ++++++-
 drivers/net/ethernet/mscc/ocelot_ptp.h        |  41 ++
 drivers/net/ethernet/mscc/ocelot_regs.c       |  11 +
 6 files changed, 629 insertions(+), 34 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_ptp.h

-- 
2.21.0


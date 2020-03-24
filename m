Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D253619108F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgCXNX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:23:58 -0400
Received: from foss.arm.com ([217.140.110.172]:34458 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbgCXNXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:23:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 530011FB;
        Tue, 24 Mar 2020 06:23:54 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 01D953F52E;
        Tue, 24 Mar 2020 06:23:52 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 00/14] net: axienet: Update error handling and add 64-bit DMA support
Date:   Tue, 24 Mar 2020 13:23:33 +0000
Message-Id: <20200324132347.23709-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

a minor update, fixing the 32-bit build breakage, and brightening up
Dave's christmas tree. Rebased against latest net-next/master.

This series is based on net-next as of today (9970de8b013a), which
includes Russell's fixes [1], solving the SGMII issues I have had.

A git branch is available at:
http://www.linux-arm.org/git?p=linux-ap.git;a=shortlog;h=refs/heads/axienet/v3
git://linux-arm.org/linux-ap.git branch axienet/v3

Thanks,
Andre

[1] https://lore.kernel.org/netdev/E1j6trA-0003GY-N1@rmk-PC.armlinux.org.uk/

Changelog v2 .. v3:
- Use two "left-shifts by 16" to fix builds with 32-bit phys_addr_t
- reorder variable declarations

Changelog v1 .. v2:
- Add Reviewed-by: tags from Radhey
- Extend kerndoc documentation
- Convert DMA error handler tasklet to work queue
- log DMA mapping errors
- mark DMA mapping error checks as unlikely (in "hot" paths)
- return NETDEV_TX_OK on TX DMA mapping error (increasing TX drop counter)
- Request eth IRQ as an optional IRQ
- Remove no longer needed MDIO IRQ register names
- Drop DT propery check for address width, assume full 64 bit

===============
This series updates the Xilinx Axienet driver to work on our board
here. One big issue was broken SGMII support, which Russell fixed already
(in net-next).
While debugging and understanding the driver, I found several problems
in the error handling and cleanup paths, which patches 2-7 address.
Patch 8 removes a annoying error message, patch 9 paves the way for newer
revisions of the IP. The next patch adds mii-tool support, just for good
measure.

The next four patches add support for 64-bit DMA. This is an integration
option on newer IP revisions (>= v7.1), and expects MSB bits in formerly
reserved registers. Without writing to those MSB registers, the state
machine won't trigger, so it's mandatory to access them, even if they
are zero. Patches 11 and 12 prepare the code by adding accessors, to
wrap this properly and keep it working on older IP revisions.
Patch 13 enables access to the MSB registers, by trying to write a
non-zero value to them and checking if that sticks. Older IP revisions
always read those registers as zero.
Patch 14 then adjusts the DMA mask, based on the autodetected MSB
feature. It uses the full 64 bits in this case, the rest of the system
(actual physical addresses in use) should provide a natural limit if the
chip has connected fewer address lines. If not, the parent DT node can
use a dma-range property.

The Xilinx PG138 and PG021 documents (in versions 7.1 in both cases)
were used for this series.

Andre Przywara (14):
  net: xilinx: temac: Relax Kconfig dependencies
  net: axienet: Convert DMA error handler to a work queue
  net: axienet: Propagate failure of DMA descriptor setup
  net: axienet: Fix DMA descriptor cleanup path
  net: axienet: Improve DMA error handling
  net: axienet: Factor out TX descriptor chain cleanup
  net: axienet: Check for DMA mapping errors
  net: axienet: Mark eth_irq as optional
  net: axienet: Drop MDIO interrupt registers from ethtools dump
  net: axienet: Add mii-tool support
  net: axienet: Wrap DMA pointer writes to prepare for 64 bit
  net: axienet: Upgrade descriptors to hold 64-bit addresses
  net: axienet: Autodetect 64-bit DMA capability
  net: axienet: Allow DMA to beyond 4GB

 drivers/net/ethernet/xilinx/Kconfig           |   1 -
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  19 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 385 +++++++++++++-----
 3 files changed, 289 insertions(+), 116 deletions(-)

-- 
2.17.1


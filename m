Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 175CB136C79
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgAJLyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:54:24 -0500
Received: from foss.arm.com ([217.140.110.172]:43072 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727717AbgAJLyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 06:54:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D45A1396;
        Fri, 10 Jan 2020 03:54:23 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5382B3F534;
        Fri, 10 Jan 2020 03:54:22 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] net: axienet: Error handling, SGMII and 64-bit DMA fixes
Date:   Fri, 10 Jan 2020 11:54:01 +0000
Message-Id: <20200110115415.75683-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series updates the Xilinx Axienet driver to work on our board
here. One big issue was broken SGMII support, which patch 7 fixes.
While debugging and understanding the driver, I found several problems
in the error handling and cleanup paths, which patches 2-6 address.
Patch 8 paves the way for newer revisions of the IP, the following patch
adds mii-tool support, just for good measure.

The next four patches add support for 64-bit DMA. This is an integration
option on newer IP revisions (>= v7.1), and expects MSB bits in formerly
reserved registers. Without writing to those MSB registers, the state
machine won't trigger, so it's mandatory to access them, even if they
are zero. Patches 10 and 11 prepare the code by adding accessors, to
wrap this properly and keep it working on older IP revisions.
Patch 12 enables access to the MSB registers, by trying to write a
non-zero value to them and checking if that sticks. Older IP revisions
always read those registers as zero.

Patch 13 then adjusts the DMA mask, if it finds a "xlnx,addrwidth"
property in the DMA DT node. I did not manage to autodetect this actual
implemented DMA width, so we need to rely on a DT property. If this is
missing, it will fall back to the current default of 32 bit.
The final patch updates the DT binding documentation in this respect.

The Xilinx PG138 and PG021 documents (in versions 7.1 in both cases)
were used for this series.

Please have a look and comment!

Cheers,
Andre

Andre Przywara (14):
  net: xilinx: temac: Relax Kconfig dependencies
  net: axienet: Propagate failure of DMA descriptor setup
  net: axienet: Fix DMA descriptor cleanup path
  net: axienet: Improve DMA error handling
  net: axienet: Factor out TX descriptor chain cleanup
  net: axienet: Check for DMA mapping errors
  net: axienet: Fix SGMII support
  net: axienet: Drop MDIO interrupt registers from ethtools dump
  net: axienet: Add mii-tool support
  net: axienet: Wrap DMA pointer writes to prepare for 64 bit
  net: axienet: Upgrade descriptors to hold 64-bit addresses
  net: axienet: Autodetect 64-bit DMA capability
  net: axienet: Allow DMA to beyond 4GB
  net: axienet: Update devicetree binding documentation

 .../bindings/net/xilinx_axienet.txt           |  57 ++-
 drivers/net/ethernet/xilinx/Kconfig           |   1 -
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  10 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 366 +++++++++++++-----
 4 files changed, 328 insertions(+), 106 deletions(-)

-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4007DFAC8C
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 10:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfKMJFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 04:05:05 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:58695 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfKMJFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 04:05:05 -0500
X-Originating-IP: 86.206.246.123
Received: from localhost (lfbn-tou-1-421-123.w86-206.abo.wanadoo.fr [86.206.246.123])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 93927240018;
        Wed, 13 Nov 2019 09:05:01 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, linux@armlinux.org.uk
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, andrew@lunn.ch,
        alexandre.belloni@bootlin.com, nicolas.ferre@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        mparab@cadence.com, piotrs@cadence.com, dkangude@cadence.com,
        ewanm@cadence.com, arthurm@cadence.com, stevenh@cadence.com
Subject: [PATCH net-next v3 0/2] net: macb: convert to phylink
Date:   Wed, 13 Nov 2019 10:00:04 +0100
Message-Id: <20191113090006.58898-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series converts the MACB Ethernet driver to the Phylink framework.
The MAC configuration is moved to the Phylink ops and Phylink helpers
are now used in the ethtools functions. This helps to access the flow
control and pauseparam logic and this will be helpful in the future for
boards using this controller with SFP cages.

Thanks,
Antoine

Since v2:
  - Moved the Tx and Rx buffer initialization rework to its own patch.

Since v1:
  - Stopped using state->link in mac_config and moved macb_set_tx_clk to
    the link_up helper..
  - Fixed the node given to phylink_of_phy_connect.
  - Removed netif_carrier_off from macb_open.
  - Fixed the macb_get_wol logic.
  - Rewored macb_ioctl as suggested.
  - Added a call to phylink_destroy in macb_remove.
  - Fixed the suspend/resume case by calling phylink_start/stop in the
    resume/suspend helpers. I had to take the rtnl lock to do this,
    which might be something to discuss.

Antoine Tenart (2):
  net: macb: move the Tx and Rx buffer initialization into a function
  net: macb: convert to phylink

 drivers/net/ethernet/cadence/Kconfig     |   2 +-
 drivers/net/ethernet/cadence/macb.h      |   9 +-
 drivers/net/ethernet/cadence/macb_main.c | 484 ++++++++++++-----------
 3 files changed, 261 insertions(+), 234 deletions(-)

-- 
2.23.0


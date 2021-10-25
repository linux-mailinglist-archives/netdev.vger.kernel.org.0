Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67036439E08
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhJYR7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:59:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:30381 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232797AbhJYR7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:59:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10148"; a="229575740"
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="229575740"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 10:56:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="554291207"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 25 Oct 2021 10:56:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     =?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 3/4] igb: unbreak I2C bit-banging on i350
Date:   Mon, 25 Oct 2021 10:55:07 -0700
Message-Id: <20211025175508.1461435-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jan Kundrát <jan.kundrat@cesnet.cz>

The driver tried to use Linux' native software I2C bus master
(i2c-algo-bits) for exporting the I2C interface that talks to the SFP
cage(s) towards userspace. As-is, however, the physical SCL/SDA pins
were not moving at all, staying at logical 1 all the time.

The main culprit was the I2CPARAMS register where igb was not setting
the I2CBB_EN bit. That meant that all the careful signal bit-banging was
actually not being propagated to the chip pads (I verified this with a
scope).

The bit-banging was not correct either, because I2C is supposed to be an
open-collector bus, and the code was driving both lines via a totem
pole. The code was also trying to do operations which did not make any
sense with the i2c-algo-bits, namely manipulating both SDA and SCL from
igb_set_i2c_data (which is only supposed to set SDA). I'm not sure if
that was meant as an optimization, or was just flat out wrong, but given
that the i2c-algo-bits is set up to work with a totally dumb GPIO-ish
implementation underneath, there's no need for this code to be smart.

The open-drain vs. totem-pole is fixed by the usual trick where the
logical zero is implemented via regular output mode and outputting a
logical 0, and the logical high is implemented via the IO pad configured
as an input (thus floating), and letting the mandatory pull-up resistors
do the rest. Anything else is actually wrong on I2C where all devices
are supposed to have open-drain connection to the bus.

The missing I2CBB_EN is set (along with a safe initial value of the
GPIOs) just before registering this software I2C bus.

The chip datasheet mentions HW-implemented I2C transactions (SFP EEPROM
reads and writes) as well, but I'm not touching these for simplicity.

Tested on a LR-Link LRES2203PF-2SFP (which is an almost-miniPCIe form
factor card, a cable, and a module with two SFP cages). There was one
casualty, an old broken SFP we had laying around, which was used to
solder some thin wires as a DIY I2C breakout. Thanks for your service.
With this patch in place, I can `i2cdump -y 3 0x51 c` and read back data
which make sense. Yay.

Signed-off-by: Jan Kundrát <jan.kundrat@cesnet.cz>
See-also: https://www.spinics.net/lists/netdev/msg490554.html
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index e67a71c3f141..836be0d3b291 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -577,16 +577,15 @@ static void igb_set_i2c_data(void *data, int state)
 	struct e1000_hw *hw = &adapter->hw;
 	s32 i2cctl = rd32(E1000_I2CPARAMS);
 
-	if (state)
-		i2cctl |= E1000_I2C_DATA_OUT;
-	else
+	if (state) {
+		i2cctl |= E1000_I2C_DATA_OUT | E1000_I2C_DATA_OE_N;
+	} else {
+		i2cctl &= ~E1000_I2C_DATA_OE_N;
 		i2cctl &= ~E1000_I2C_DATA_OUT;
+	}
 
-	i2cctl &= ~E1000_I2C_DATA_OE_N;
-	i2cctl |= E1000_I2C_CLK_OE_N;
 	wr32(E1000_I2CPARAMS, i2cctl);
 	wrfl();
-
 }
 
 /**
@@ -603,8 +602,7 @@ static void igb_set_i2c_clk(void *data, int state)
 	s32 i2cctl = rd32(E1000_I2CPARAMS);
 
 	if (state) {
-		i2cctl |= E1000_I2C_CLK_OUT;
-		i2cctl &= ~E1000_I2C_CLK_OE_N;
+		i2cctl |= E1000_I2C_CLK_OUT | E1000_I2C_CLK_OE_N;
 	} else {
 		i2cctl &= ~E1000_I2C_CLK_OUT;
 		i2cctl &= ~E1000_I2C_CLK_OE_N;
@@ -3116,12 +3114,21 @@ static void igb_init_mas(struct igb_adapter *adapter)
  **/
 static s32 igb_init_i2c(struct igb_adapter *adapter)
 {
+	struct e1000_hw *hw = &adapter->hw;
 	s32 status = 0;
+	s32 i2cctl;
 
 	/* I2C interface supported on i350 devices */
 	if (adapter->hw.mac.type != e1000_i350)
 		return 0;
 
+	i2cctl = rd32(E1000_I2CPARAMS);
+	i2cctl |= E1000_I2CBB_EN
+		| E1000_I2C_CLK_OUT | E1000_I2C_CLK_OE_N
+		| E1000_I2C_DATA_OUT | E1000_I2C_DATA_OE_N;
+	wr32(E1000_I2CPARAMS, i2cctl);
+	wrfl();
+
 	/* Initialize the i2c bus which is controlled by the registers.
 	 * This bus will use the i2c_algo_bit structure that implements
 	 * the protocol through toggling of the 4 bits in the register.
-- 
2.31.1


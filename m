Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF902696D6D
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 19:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjBNS4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 13:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBNS43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 13:56:29 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1BF4224
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 10:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676400988; x=1707936988;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KTq4aY3LXE6EjinyfA3DX2sC/SGTQK6kSIpLfQLctKM=;
  b=m0IKgVyEpT1TnhhSrmEKCkDfd2b/TwI3pDquFbIBo6kW/ApfGEiWVMD5
   0KMJi/DWfnl6kLy5GhssBDgNgzCOQS1Q3DEBB24tvhmmaK6TiqQGoO0/z
   bkDhG3GEH1HjC1MXTeGotYBMn2/Qjtn8cbcFL3tJz8CNzQ0n55bcj7uO7
   EXGrRmCwkev/Dzx58Fph5IdUOUiJLuIDlHgUBIzyFAa1l/ejVC4U56AXN
   lltjvjpk6oXEhkA0aiMeznV7B5UcbZnwLj79IRH8YWU5pHX8qeW3rp3VH
   G9dW4NfKZ9qjk4ZRYiQ10/HwetXepggnfqwCUQGdlec1m8xXlNDnEHrIG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="310871366"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="310871366"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 10:56:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="671310250"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="671310250"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 14 Feb 2023 10:56:23 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Corinna Vinschen <vinschen@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, jan.kundrat@cesnet.cz,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Jamie Bainbridge <jbainbri@redhat.com>
Subject: [PATCH net 1/1] igb: conditionalize I2C bit banging on external thermal sensor support
Date:   Tue, 14 Feb 2023 10:55:48 -0800
Message-Id: <20230214185549.1306522-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corinna Vinschen <vinschen@redhat.com>

Commit a97f8783a937 ("igb: unbreak I2C bit-banging on i350") introduced
code to change I2C settings to bit banging unconditionally.

However, this patch introduced a regression:  On an Intel S2600CWR
Server Board with three NICs:

- 1x dual-port copper
  Intel I350 Gigabit Network Connection [8086:1521] (rev 01)
  fw 1.63, 0x80000dda

- 2x quad-port SFP+ with copper SFP Avago ABCU-5700RZ
  Intel I350 Gigabit Fiber Network Connection [8086:1522] (rev 01)
  fw 1.52.0

the SFP NICs no longer get link at all.  Reverting commit a97f8783a937
or switching to the Intel out-of-tree driver both fix the problem.

Per the igb out-of-tree driver, I2C bit banging on i350 depends on
support for an external thermal sensor (ETS).  However, commit
a97f8783a937 added bit banging unconditionally.  Additionally, the
out-of-tree driver always calls init_thermal_sensor_thresh on probe,
while our driver only calls init_thermal_sensor_thresh only in
igb_reset(), and only if an ETS is present, ignoring the internal
thermal sensor.  The affected SFPs don't provide an ETS.  Per Intel,
the behaviour is a result of i350 firmware requirements.

This patch fixes the problem by aligning the behaviour to the
out-of-tree driver:

- split igb_init_i2c() into two functions:
  - igb_init_i2c() only performs the basic I2C initialization.
  - igb_set_i2c_bb() makes sure that E1000_CTRL_I2C_ENA is set
    and enables bit-banging.

- igb_probe() only calls igb_set_i2c_bb() if an ETS is present.

- igb_probe() calls init_thermal_sensor_thresh() unconditionally.

- igb_reset() aligns its behaviour to igb_probe(), i. e., call
  igb_set_i2c_bb() if an ETS is present and call
  init_thermal_sensor_thresh() unconditionally.

Fixes: a97f8783a937 ("igb: unbreak I2C bit-banging on i350")
Tested-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Co-developed-by: Jamie Bainbridge <jbainbri@redhat.com>
Signed-off-by: Jamie Bainbridge <jbainbri@redhat.com>
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 42 +++++++++++++++++------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 3c0c35ecea10..0327d53965b1 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2256,6 +2256,30 @@ static void igb_enable_mas(struct igb_adapter *adapter)
 	}
 }
 
+#ifdef CONFIG_IGB_HWMON
+/**
+ *  igb_set_i2c_bb - Init I2C interface
+ *  @hw: pointer to hardware structure
+ **/
+static void igb_set_i2c_bb(struct e1000_hw *hw)
+{
+	u32 ctrl_ext;
+	s32 i2cctl;
+
+	ctrl_ext = rd32(E1000_CTRL_EXT);
+	ctrl_ext |= E1000_CTRL_I2C_ENA;
+	wr32(E1000_CTRL_EXT, ctrl_ext);
+	wrfl();
+
+	i2cctl = rd32(E1000_I2CPARAMS);
+	i2cctl |= E1000_I2CBB_EN
+		| E1000_I2C_CLK_OE_N
+		| E1000_I2C_DATA_OE_N;
+	wr32(E1000_I2CPARAMS, i2cctl);
+	wrfl();
+}
+#endif
+
 void igb_reset(struct igb_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
@@ -2400,7 +2424,8 @@ void igb_reset(struct igb_adapter *adapter)
 			 * interface.
 			 */
 			if (adapter->ets)
-				mac->ops.init_thermal_sensor_thresh(hw);
+				igb_set_i2c_bb(hw);
+			mac->ops.init_thermal_sensor_thresh(hw);
 		}
 	}
 #endif
@@ -3117,21 +3142,12 @@ static void igb_init_mas(struct igb_adapter *adapter)
  **/
 static s32 igb_init_i2c(struct igb_adapter *adapter)
 {
-	struct e1000_hw *hw = &adapter->hw;
 	s32 status = 0;
-	s32 i2cctl;
 
 	/* I2C interface supported on i350 devices */
 	if (adapter->hw.mac.type != e1000_i350)
 		return 0;
 
-	i2cctl = rd32(E1000_I2CPARAMS);
-	i2cctl |= E1000_I2CBB_EN
-		| E1000_I2C_CLK_OUT | E1000_I2C_CLK_OE_N
-		| E1000_I2C_DATA_OUT | E1000_I2C_DATA_OE_N;
-	wr32(E1000_I2CPARAMS, i2cctl);
-	wrfl();
-
 	/* Initialize the i2c bus which is controlled by the registers.
 	 * This bus will use the i2c_algo_bit structure that implements
 	 * the protocol through toggling of the 4 bits in the register.
@@ -3521,6 +3537,12 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			adapter->ets = true;
 		else
 			adapter->ets = false;
+		/* Only enable I2C bit banging if an external thermal
+		 * sensor is supported.
+		 */
+		if (adapter->ets)
+			igb_set_i2c_bb(hw);
+		hw->mac.ops.init_thermal_sensor_thresh(hw);
 		if (igb_sysfs_init(adapter))
 			dev_err(&pdev->dev,
 				"failed to allocate sysfs resources\n");
-- 
2.38.1


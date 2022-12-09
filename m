Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1445D64815F
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiLILL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLILL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:11:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB045E3F1
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 03:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670584261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g7Xw+SjJpeMN8PiCtdlUQR+YT00BC5YxfDj735a9vIM=;
        b=KpMNR9aoNKTl1BkEDo1qvkBNOKxQkCavmfiIK05zzQRPK5ApQg+0T1hKorvgSqqVUNxl2P
        93xRgRT0v9UzOReS5GjkCTZUW4PXDeWTGizmeeRQLVFHHNsBnigJUjReiu7DPIqa8GBBxb
        I7q3fffFM9hnDZEsh74iJdKIobTkF0s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-aPTTVbFwP9q8hgdqLkQNKQ-1; Fri, 09 Dec 2022 06:10:55 -0500
X-MC-Unique: aPTTVbFwP9q8hgdqLkQNKQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DB691C087AB;
        Fri,  9 Dec 2022 11:10:55 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.219])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 309D340C6EC2;
        Fri,  9 Dec 2022 11:10:55 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id DC93FA8079F; Fri,  9 Dec 2022 12:10:51 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     mateusz.palczewski@intel.com, patryk.piotrowski@intel.com
Subject: [PATCH net v3] igb: conditionalize I2C bit banging on external thermal sensor support
Date:   Fri,  9 Dec 2022 12:10:51 +0100
Message-Id: <20221209111051.3117836-1-vinschen@redhat.com>
In-Reply-To: <b062430c-b827-3ea7-7836-ebf3aa5b0936@intel.com>
References: <b062430c-b827-3ea7-7836-ebf3aa5b0936@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

v2: Add variable name in function declaration,
    rearrange declaration of local variables
v3: Co-authored-by: -> Co-developed-by:
    Move igb_set_i2c_bb to avoid forward declaration
    Fix comments
    Fix indentation

Fixes: a97f8783a937 ("igb: unbreak I2C bit-banging on i350")
Tested-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Co-developed-by: Jamie Bainbridge <jbainbri@redhat.com>
Signed-off-by: Jamie Bainbridge <jbainbri@redhat.com>
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 42 +++++++++++++++++------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index f8e32833226c..1a68a3e91e7f 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2252,6 +2252,30 @@ static void igb_enable_mas(struct igb_adapter *adapter)
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
@@ -2396,7 +2420,8 @@ void igb_reset(struct igb_adapter *adapter)
 			 * interface.
 			 */
 			if (adapter->ets)
-				mac->ops.init_thermal_sensor_thresh(hw);
+				igb_set_i2c_bb(hw);
+			mac->ops.init_thermal_sensor_thresh(hw);
 		}
 	}
 #endif
@@ -3113,21 +3138,12 @@ static void igb_init_mas(struct igb_adapter *adapter)
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
@@ -3517,6 +3533,12 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
2.31.1


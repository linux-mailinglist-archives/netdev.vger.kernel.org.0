Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEC5646E66
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiLHLX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiLHLXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:23:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FAC89AD1
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 03:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670498472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JwEklUVcE2hY+E8ByQ+1DVAaQ4gbfmB2fYCEDol6FwY=;
        b=DXs/cpOOoZs/0E4hN5xuG2BS+rRu1luVgsDPr9UHFnkojn1qmbY6C/L16sqMtx81woWfWF
        ajsq19j3dr84H8K9fFHtn4UkYOdndKeY3CpnI41VJUe9eUX6Lk6+FhsmC05dcms0uJdowA
        atnuUYAAFTNRi5L1V5CsCQFglwDghBc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-8P74pipKO7-_r69o9_jdeg-1; Thu, 08 Dec 2022 06:21:09 -0500
X-MC-Unique: 8P74pipKO7-_r69o9_jdeg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A4D1802E5D;
        Thu,  8 Dec 2022 11:21:08 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.219])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DA58492B04;
        Thu,  8 Dec 2022 11:21:08 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id CA625A80A3A; Thu,  8 Dec 2022 12:21:04 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>
Cc:     mateusz.palczewski@intel.com, patryk.piotrowski@intel.com
Subject: [PATCH net v2] igb: conditionalize I2C bit banging on external thermal sensor support
Date:   Thu,  8 Dec 2022 12:21:04 +0100
Message-Id: <20221208112104.2769660-1-vinschen@redhat.com>
In-Reply-To: <Y5GjAu4Uu6mg9a1I@unreal>
References: <Y5GjAu4Uu6mg9a1I@unreal>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

Fixes: a97f8783a937 ("igb: unbreak I2C bit-banging on i350")
Co-authored-by: Jamie Bainbridge <jbainbri@redhat.com>
Tested-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Jamie Bainbridge <jbainbri@redhat.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 44 +++++++++++++++++------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 4e65ffe3f4e3..7f56322b3ec2 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -138,6 +138,9 @@ static irqreturn_t igb_msix_ring(int irq, void *);
 static void igb_update_dca(struct igb_q_vector *);
 static void igb_setup_dca(struct igb_adapter *);
 #endif /* CONFIG_IGB_DCA */
+#ifdef CONFIG_IGB_HWMON
+static void igb_set_i2c_bb(struct e1000_hw *hw);
+#endif /* CONFIG_IGB_HWMON */
 static int igb_poll(struct napi_struct *, int);
 static bool igb_clean_tx_irq(struct igb_q_vector *, int);
 static int igb_clean_rx_irq(struct igb_q_vector *, int);
@@ -2399,7 +2402,8 @@ void igb_reset(struct igb_adapter *adapter)
 			 * interface.
 			 */
 			if (adapter->ets)
-				mac->ops.init_thermal_sensor_thresh(hw);
+				igb_set_i2c_bb(hw);
+			mac->ops.init_thermal_sensor_thresh(hw);
 		}
 	}
 #endif
@@ -3116,21 +3120,12 @@ static void igb_init_mas(struct igb_adapter *adapter)
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
@@ -3146,6 +3141,30 @@ static s32 igb_init_i2c(struct igb_adapter *adapter)
 	return status;
 }
 
+#ifdef CONFIG_IGB_HWMON
+/**
+ *  igb_set_i2c_bb - Init I2C interface
+ *  @adapter: pointer to adapter structure
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
 /**
  *  igb_probe - Device Initialization Routine
  *  @pdev: PCI device information struct
@@ -3520,6 +3539,11 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			adapter->ets = true;
 		else
 			adapter->ets = false;
+		/* Only enable I2C bit banging if an external thermal
+		   sensor is supported. */
+		if (adapter->ets)
+		  igb_set_i2c_bb(hw);
+		hw->mac.ops.init_thermal_sensor_thresh(hw);
 		if (igb_sysfs_init(adapter))
 			dev_err(&pdev->dev,
 				"failed to allocate sysfs resources\n");
-- 
2.31.1


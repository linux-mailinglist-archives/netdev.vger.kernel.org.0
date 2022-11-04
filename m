Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4BE6197B5
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiKDNX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiKDNX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:23:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B63110A;
        Fri,  4 Nov 2022 06:23:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C8C5B82CFE;
        Fri,  4 Nov 2022 13:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D922BC433D6;
        Fri,  4 Nov 2022 13:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667568200;
        bh=hiVOrDmoo5mWY3jYeQIALAtM77QmIzCznqlGhLcSSZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRDTjUQ3BFkrXQAkrw/QsX25wtrfyvqmHRyRUdq6kQqgSgsagM29GZw5sNTs4kfrW
         gxvLFcoe8YpTwoXFEE5fI2Fbe/SQMY4KrkrOKwkM4hmpyVWsrgN27O57v/ZMVJHCqS
         FO/kHHfGN/i+EPSjB8liHyO6ymCOiWrQgaKmqzMJHyCA/v9BWrBZABU8hFkT7zoPJz
         Kqi/sZveTwL1FUnFX+O++F8w0JzJJ2ZY7m0EDnIKTUV+gMYIY/uAaOErEIp3xT+ZtW
         5qEiRb89UxPPm88GBymXumT+76hCx4O18xdaPe6Noth/gRJT6vjjKfXF/ONgKafJro
         wi35s7HM5ou1Q==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vigneshr@ti.com, vibhore@ti.com, srk@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH 1/5] net: ethernet: ti: am65-cpsw/cpts: Add suspend/resume helpers
Date:   Fri,  4 Nov 2022 15:23:06 +0200
Message-Id: <20221104132310.31577-2-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221104132310.31577-1-rogerq@kernel.org>
References: <20221104132310.31577-1-rogerq@kernel.org>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPTS looses context on suspend (e.g. on AM62).
Provide suspend/resume hooks in CPTS driver. These will be
invoked by CPSW driver if CPTS was instantiated by CPSW.

Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpts.c | 76 +++++++++++++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpts.h | 10 ++++
 2 files changed, 86 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index e2f0fb286143..7f928c343426 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -176,6 +176,16 @@ struct am65_cpts {
 	u32 genf_enable;
 	u32 hw_ts_enable;
 	struct sk_buff_head txq;
+	/* context save/restore */
+	u64 sr_cpts_ns;
+	u64 sr_ktime_ns;
+	u32 sr_control;
+	u32 sr_int_enable;
+	u32 sr_rftclk_sel;
+	u32 sr_ts_ppm_hi;
+	u32 sr_ts_ppm_low;
+	struct am65_genf_regs sr_genf[AM65_CPTS_GENF_MAX_NUM];
+	struct am65_genf_regs sr_estf[AM65_CPTS_ESTF_MAX_NUM];
 };
 
 struct am65_cpts_skb_cb_data {
@@ -1029,6 +1039,72 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 }
 EXPORT_SYMBOL_GPL(am65_cpts_create);
 
+void am65_cpts_suspend(struct am65_cpts *cpts)
+{
+	/* save state and disable CPTS */
+	cpts->sr_control = am65_cpts_read32(cpts, control);
+	cpts->sr_int_enable = am65_cpts_read32(cpts, int_enable);
+	cpts->sr_rftclk_sel = am65_cpts_read32(cpts, rftclk_sel);
+	cpts->sr_ts_ppm_hi = am65_cpts_read32(cpts, ts_ppm_hi);
+	cpts->sr_ts_ppm_low = am65_cpts_read32(cpts, ts_ppm_low);
+	cpts->sr_cpts_ns = am65_cpts_gettime(cpts, NULL);
+	cpts->sr_ktime_ns = ktime_to_ns(ktime_get_real());
+	am65_cpts_disable(cpts);
+	clk_disable(cpts->refclk);
+
+	/* Save GENF state */
+	memcpy_fromio(&cpts->sr_genf, &cpts->reg->genf, sizeof(cpts->sr_genf));
+
+	/* Save ESTF state */
+	memcpy_fromio(&cpts->sr_estf, &cpts->reg->estf, sizeof(cpts->sr_estf));
+}
+EXPORT_SYMBOL_GPL(am65_cpts_suspend);
+
+void am65_cpts_resume(struct am65_cpts *cpts)
+{
+	int i;
+	s64 ktime_ns;
+
+	/* restore state and enable CPTS */
+	clk_enable(cpts->refclk);
+	am65_cpts_write32(cpts, cpts->sr_rftclk_sel, rftclk_sel);
+	am65_cpts_set_add_val(cpts);
+	am65_cpts_write32(cpts, cpts->sr_control, control);
+	am65_cpts_write32(cpts, cpts->sr_int_enable, int_enable);
+
+	/* Restore time to saved CPTS time + time in suspend/resume */
+	ktime_ns = ktime_to_ns(ktime_get_real());
+	ktime_ns -= cpts->sr_ktime_ns;
+	am65_cpts_settime(cpts, cpts->sr_cpts_ns + ktime_ns);
+
+	/* Restore compensation (PPM) */
+	am65_cpts_write32(cpts, cpts->sr_ts_ppm_hi, ts_ppm_hi);
+	am65_cpts_write32(cpts, cpts->sr_ts_ppm_low, ts_ppm_low);
+
+	/* Restore GENF state */
+	for (i = 0; i < AM65_CPTS_GENF_MAX_NUM; i++) {
+		am65_cpts_write32(cpts, 0, genf[i].length);	/* TRM sequence */
+		am65_cpts_write32(cpts, cpts->sr_genf[i].comp_hi, genf[i].comp_hi);
+		am65_cpts_write32(cpts, cpts->sr_genf[i].comp_lo, genf[i].comp_lo);
+		am65_cpts_write32(cpts, cpts->sr_genf[i].length, genf[i].length);
+		am65_cpts_write32(cpts, cpts->sr_genf[i].control, genf[i].control);
+		am65_cpts_write32(cpts, cpts->sr_genf[i].ppm_hi, genf[i].ppm_hi);
+		am65_cpts_write32(cpts, cpts->sr_genf[i].ppm_low, genf[i].ppm_low);
+	}
+
+	/* Restore ESTTF state */
+	for (i = 0; i < AM65_CPTS_ESTF_MAX_NUM; i++) {
+		am65_cpts_write32(cpts, 0, estf[i].length);	/* TRM sequence */
+		am65_cpts_write32(cpts, cpts->sr_estf[i].comp_hi, estf[i].comp_hi);
+		am65_cpts_write32(cpts, cpts->sr_estf[i].comp_lo, estf[i].comp_lo);
+		am65_cpts_write32(cpts, cpts->sr_estf[i].length, estf[i].length);
+		am65_cpts_write32(cpts, cpts->sr_estf[i].control, estf[i].control);
+		am65_cpts_write32(cpts, cpts->sr_estf[i].ppm_hi, estf[i].ppm_hi);
+		am65_cpts_write32(cpts, cpts->sr_estf[i].ppm_low, estf[i].ppm_low);
+	}
+}
+EXPORT_SYMBOL_GPL(am65_cpts_resume);
+
 static int am65_cpts_probe(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
diff --git a/drivers/net/ethernet/ti/am65-cpts.h b/drivers/net/ethernet/ti/am65-cpts.h
index cf9fbc28fd03..bd08f4b2edd2 100644
--- a/drivers/net/ethernet/ti/am65-cpts.h
+++ b/drivers/net/ethernet/ti/am65-cpts.h
@@ -28,6 +28,8 @@ u64 am65_cpts_ns_gettime(struct am65_cpts *cpts);
 int am65_cpts_estf_enable(struct am65_cpts *cpts, int idx,
 			  struct am65_cpts_estf_cfg *cfg);
 void am65_cpts_estf_disable(struct am65_cpts *cpts, int idx);
+void am65_cpts_suspend(struct am65_cpts *cpts);
+void am65_cpts_resume(struct am65_cpts *cpts);
 #else
 static inline struct am65_cpts *am65_cpts_create(struct device *dev,
 						 void __iomem *regs,
@@ -69,6 +71,14 @@ static inline int am65_cpts_estf_enable(struct am65_cpts *cpts, int idx,
 static inline void am65_cpts_estf_disable(struct am65_cpts *cpts, int idx)
 {
 }
+
+static inline void am65_cpts_suspend(struct am65_cpts *cpts)
+{
+}
+
+static inline void am65_cpts_resume(struct am65_cpts *cpts)
+{
+}
 #endif
 
 #endif /* K3_CPTS_H_ */
-- 
2.17.1


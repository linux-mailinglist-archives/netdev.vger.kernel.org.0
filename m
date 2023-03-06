Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BE96ABDCB
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 12:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjCFLKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 06:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCFLKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 06:10:02 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C2711668;
        Mon,  6 Mar 2023 03:10:00 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 326B9kZW002892;
        Mon, 6 Mar 2023 05:09:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678100986;
        bh=Cf8v7ecsIavw408Q8DTyKydOytqFM4ubuQmB7wdtXeQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=aBMl0XXALpY4CihOzuoAvEiOat2dSykwcj0RiR2Akqf53Ox96R/uYZDNNuHTHSsDa
         FsrxEYPJJJwy2B41GJQ1plOa8EC70vBEy+pt7RYW7B0uVdFnVIJQkKj00eoxnsLUfd
         a0pl2pBfTp2xjqlrDF8dnIDiEbhRiWOYb47Q/kpg=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 326B9kFm042552
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Mar 2023 05:09:46 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 6
 Mar 2023 05:09:46 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 6 Mar 2023 05:09:46 -0600
Received: from lelv0854.itg.ti.com (lelv0854.itg.ti.com [10.181.64.140])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 326B9k05067142;
        Mon, 6 Mar 2023 05:09:46 -0600
Received: from localhost (a0501179-pc.dhcp.ti.com [10.24.69.114])
        by lelv0854.itg.ti.com (8.14.7/8.14.7) with ESMTP id 326B9j0r029591;
        Mon, 6 Mar 2023 05:09:45 -0600
From:   MD Danish Anwar <danishanwar@ti.com>
To:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        MD Danish Anwar <danishanwar@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        "Santosh Shilimkar" <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
CC:     <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 4/6] soc: ti: pruss: Add helper functions to set GPI mode, MII_RT_event and XFR
Date:   Mon, 6 Mar 2023 16:39:32 +0530
Message-ID: <20230306110934.2736465-5-danishanwar@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230306110934.2736465-1-danishanwar@ti.com>
References: <20230306110934.2736465-1-danishanwar@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

The PRUSS CFG module is represented as a syscon node and is currently
managed by the PRUSS platform driver. Add easy accessor functions to set
GPI mode, MII_RT event enable/disable and XFR (XIN XOUT) enable/disable
to enable the PRUSS Ethernet usecase. These functions reuse the generic
pruss_cfg_update() API function.

Signed-off-by: Suman Anna <s-anna@ti.com>
Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
---
 include/linux/remoteproc/pruss.h | 55 ++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
index d41bec448f06..7952f250301a 100644
--- a/include/linux/remoteproc/pruss.h
+++ b/include/linux/remoteproc/pruss.h
@@ -240,4 +240,59 @@ static inline bool is_pru_rproc(struct device *dev)
 	return true;
 }
 
+/**
+ * pruss_cfg_gpimode() - set the GPI mode of the PRU
+ * @pruss: the pruss instance handle
+ * @pru_id: id of the PRU core within the PRUSS
+ * @mode: GPI mode to set
+ *
+ * Sets the GPI mode for a given PRU by programming the
+ * corresponding PRUSS_CFG_GPCFGx register
+ *
+ * Return: 0 on success, or an error code otherwise
+ */
+static inline int pruss_cfg_gpimode(struct pruss *pruss,
+				    enum pruss_pru_id pru_id,
+				    enum pruss_gpi_mode mode)
+{
+	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
+		return -EINVAL;
+
+	return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
+				PRUSS_GPCFG_PRU_GPI_MODE_MASK,
+				mode << PRUSS_GPCFG_PRU_GPI_MODE_SHIFT);
+}
+
+/**
+ * pruss_cfg_miirt_enable() - Enable/disable MII RT Events
+ * @pruss: the pruss instance
+ * @enable: enable/disable
+ *
+ * Enable/disable the MII RT Events for the PRUSS.
+ *
+ * Return: 0 on success, or an error code otherwise
+ */
+static inline int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable)
+{
+	u32 set = enable ? PRUSS_MII_RT_EVENT_EN : 0;
+
+	return pruss_cfg_update(pruss, PRUSS_CFG_MII_RT,
+				PRUSS_MII_RT_EVENT_EN, set);
+}
+
+/**
+ * pruss_cfg_xfr_enable() - Enable/disable XIN XOUT shift functionality
+ * @pruss: the pruss instance
+ * @enable: enable/disable
+ *
+ * Return: 0 on success, or an error code otherwise
+ */
+static inline int pruss_cfg_xfr_enable(struct pruss *pruss, bool enable)
+{
+	u32 set = enable ? PRUSS_SPP_XFER_SHIFT_EN : 0;
+
+	return pruss_cfg_update(pruss, PRUSS_CFG_SPP,
+				PRUSS_SPP_XFER_SHIFT_EN, set);
+}
+
 #endif /* __LINUX_PRUSS_H */
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0B13799E
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 18:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfFFQbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 12:31:39 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:54192 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729745AbfFFQbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 12:31:38 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x56GVM6I064604;
        Thu, 6 Jun 2019 11:31:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559838682;
        bh=MwfT++VN1Q8SFfYZPQ1nyXL9tf0XJigqffqFWo4XOL0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Z9/3hJEm8B4Z+HEUtpsuIegHlSbxlBan5DN8vKeq7fPGVZ5XXeIpxVhT4Ima9GFsB
         IcVCiSoSHvB7L41vKuFTptGEiEtF3oOxHUdQrk6ZLmIE3ox8JZxxqBB1nGjrAsMRXJ
         XuTTGlg9clZku7C4l7LPOV55ZsLmH8LgMQfYR8c8=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x56GVMMa006861
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 6 Jun 2019 11:31:22 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 6 Jun
 2019 11:31:21 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 6 Jun 2019 11:31:21 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x56GVKsY055672;
        Thu, 6 Jun 2019 11:31:21 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Wingman Kwok <w-kwok2@ti.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 04/10] net: ethernet: ti: cpts: add support for ext rftclk selection
Date:   Thu, 6 Jun 2019 19:30:41 +0300
Message-ID: <20190606163047.31199-5-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606163047.31199-1-grygorii.strashko@ti.com>
References: <20190606163047.31199-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some CPTS instances, which can be found on KeyStone 2 1G Ethernet Switch
Subsystems, can control an external multiplexer that selects one of up to
32 clocks as time sync reference (RFTCLK) clock. This feature can be
configured through CPTS_RFTCLK_SEL register (offset: x08) in CPTS module
and can be represented as multiplexer clock.

Hence, introduce support for optional cpts-refclk-mux clock, which, once
defined will allow to select required CPTS RFTCLK by using
assigned-clock-parents DT property in board files.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/ti/cpts.c | 79 +++++++++++++++++++++++++++++++++-
 drivers/net/ethernet/ti/cpts.h |  2 +-
 2 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 0e79f9743c19..61136428e2c0 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2012 Richard Cochran <richardcochran@gmail.com>
  *
  */
+#include <linux/clk-provider.h>
 #include <linux/err.h>
 #include <linux/if.h>
 #include <linux/hrtimer.h>
@@ -532,6 +533,82 @@ static void cpts_calc_mult_shift(struct cpts *cpts)
 		 freq, cpts->cc.mult, cpts->cc.shift, (ns - NSEC_PER_SEC));
 }
 
+static int cpts_of_mux_clk_setup(struct cpts *cpts, struct device_node *node)
+{
+	struct device_node *refclk_np;
+	const char **parent_names;
+	unsigned int num_parents;
+	struct clk_hw *clk_hw;
+	int ret = -EINVAL;
+	u32 *mux_table;
+
+	refclk_np = of_get_child_by_name(node, "cpts-refclk-mux");
+	if (!refclk_np)
+		/* refclk selection supported not for all SoCs */
+		return 0;
+
+	num_parents = of_clk_get_parent_count(refclk_np);
+	if (num_parents < 1) {
+		dev_err(cpts->dev, "mux-clock %s must have parents\n",
+			refclk_np->name);
+		goto mux_fail;
+	}
+
+	parent_names = devm_kzalloc(cpts->dev, (sizeof(char *) * num_parents),
+				    GFP_KERNEL);
+
+	mux_table = devm_kzalloc(cpts->dev, sizeof(*mux_table) * num_parents,
+				 GFP_KERNEL);
+	if (!mux_table || !parent_names) {
+		ret = -ENOMEM;
+		goto mux_fail;
+	}
+
+	of_clk_parent_fill(refclk_np, parent_names, num_parents);
+
+	ret = of_property_read_variable_u32_array(refclk_np, "ti,mux-tbl",
+						  mux_table,
+						  num_parents, num_parents);
+	if (ret < 0)
+		goto mux_fail;
+
+	clk_hw = clk_hw_register_mux_table(cpts->dev, refclk_np->name,
+					   parent_names, num_parents,
+					   0,
+					   &cpts->reg->rftclk_sel, 0, 0x1F,
+					   0, mux_table, NULL);
+	if (IS_ERR(clk_hw)) {
+		ret = PTR_ERR(clk_hw);
+		goto mux_fail;
+	}
+
+	ret = devm_add_action_or_reset(cpts->dev,
+				       (void(*)(void *))clk_hw_unregister_mux,
+				       clk_hw);
+	if (ret) {
+		dev_err(cpts->dev, "add clkmux unreg action %d", ret);
+		goto mux_fail;
+	}
+
+	ret = of_clk_add_hw_provider(refclk_np, of_clk_hw_simple_get, clk_hw);
+	if (ret)
+		goto mux_fail;
+
+	ret = devm_add_action_or_reset(cpts->dev,
+				       (void(*)(void *))of_clk_del_provider,
+				       refclk_np);
+	if (ret) {
+		dev_err(cpts->dev, "add clkmux provider unreg action %d", ret);
+		goto mux_fail;
+	}
+
+	return ret;
+
+mux_fail:
+	of_node_put(refclk_np);
+	return ret;
+}
+
 static int cpts_of_parse(struct cpts *cpts, struct device_node *node)
 {
 	int ret = -EINVAL;
@@ -547,7 +624,7 @@ static int cpts_of_parse(struct cpts *cpts, struct device_node *node)
 	    (!cpts->cc.mult && cpts->cc.shift))
 		goto of_error;
 
-	return 0;
+	return cpts_of_mux_clk_setup(cpts, node);
 
 of_error:
 	dev_err(cpts->dev, "CPTS: Missing property in the DT.\n");
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index 024aab6af12f..bb997c11ee15 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -24,7 +24,7 @@
 struct cpsw_cpts {
 	u32 idver;                /* Identification and version */
 	u32 control;              /* Time sync control */
-	u32 res1;
+	u32 rftclk_sel;		  /* Reference Clock Select Register */
 	u32 ts_push;              /* Time stamp event push */
 	u32 ts_load_val;          /* Time stamp load value */
 	u32 ts_load_en;           /* Time stamp load enable */
-- 
2.17.1


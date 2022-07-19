Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C5557A208
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239519AbiGSOma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239532AbiGSOmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:42:17 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C77184
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:39:22 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id e16so13708532pfm.11
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CcUdcoTXJ3qu+Hm+Ki6doP9e2OuC2e6g8uTH1eXsFCQ=;
        b=G7oi6hAfh1G7aw8XHS/wUDkZu/L9+r4y6l8gzEy3NSzs+QRCip7TD+GzHbt2XMVxd6
         cq+JTfpiKV0QCehKDqslEYJSPBCgFCLvdtGU3b4vz4capDAbzCGoqly4fWCLJ2wmQX5y
         6rHVrpwlKmr2YhJUA0bUfqY4TptwHsIe4BmfQPNmymhlrgG70w36T4AOdBigd8xdH0I2
         ulf9PJFHODlelIABYT/vbs+hedgcqfR/vvEI+Tnjmo5gxMXzavboPzHzfijfKDA+HooQ
         LNJKdWhvU8JRvfahZLsuqxPUZ2ft3qktltKiq2I3qVNG/Xbj0eyfhIJ59prseiu+Rd0/
         3zKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CcUdcoTXJ3qu+Hm+Ki6doP9e2OuC2e6g8uTH1eXsFCQ=;
        b=Pkq83eYFXgLVHw8fWRaMVMXiUDywATcwhGZeGluUtMX56IZ3R6LPa3GIonnU2XqdFk
         MNvmBCW8z4qIsdneD0l0ihTueQK3ik4pNdCfvpSEuBexqyPTxwv7UBpV6V2RQvNsG3RG
         ijYW/guzdCcpiShjKLbpkh/Q/r5S7CGjqAOdiL2NpIVOhrP+VcJebp7GoujxAQH403eo
         TdNXU6oGyPAOXu5NXUfjLXu5YxJ/bn66BPxfEALwtc/JfAlc0u3i2a1huWruK03Nwo0m
         k1QU8xJoS3Y6VkUK4wabkPwPVHtHBmW64feZcOvtLcY3KaxF25MrkGlbp4zYxvySU087
         d7Tw==
X-Gm-Message-State: AJIora/VA/ROPzbqiz4BggZF/nKlMrp/zmeE5HTbdWnHBD5DQ4caab/7
        wt2rXie352eiXVBCmjQGD9k=
X-Google-Smtp-Source: AGRyM1t9423GQOMCQkLOrVnd97BNzzJyZ2TkfiooFcNwJdQgOrcfDoJkO9Mni0VdJx6L2xGo3jDZrA==
X-Received: by 2002:a63:2254:0:b0:40d:d291:7710 with SMTP id t20-20020a632254000000b0040dd2917710mr28742975pgm.269.1658241562006;
        Tue, 19 Jul 2022 07:39:22 -0700 (PDT)
Received: from localhost.localdomain ([104.28.240.137])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902dac100b0016c46ff9741sm11885496plx.67.2022.07.19.07.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:39:21 -0700 (PDT)
From:   Qingfang DENG <dqfext@gmail.com>
To:     Russell King <linux@armlinux.org.uk>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org
Subject: Handling standalone PCS IRQ
Date:   Tue, 19 Jul 2022 22:39:12 +0800
Message-Id: <20220719143912.2727014-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I was working with an SoC that has a built-in DWC XPCS with IRQ support.
However the current driver still uses polling.

I may modify xpcs_create() to try getting an IRQ number from DT, and fall back
to polling if it fails (see the code below). But I don't know how to notify
phylink in the IRQ handler.

There is a phylink_mac_change() function to notify phylink, but it is supposed
to be used in a MAC driver, and it requires a (struct phylink *), not a
(struct phylink_pcs *). Do we need a similar one for PCS?

Thanks.

--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1272,6 +1272,13 @@ static const struct phylink_pcs_ops xpcs_phylink_ops = {
 	.pcs_link_up = xpcs_link_up,
 };
 
+static irqreturn_t xpcs_irq(int irq, void *dev_id) {
+	struct dw_xpcs *xpcs = dev_id;
+
+	/* XXX: notify phylink */
+	return IRQ_HANDLED;
+}
+
 struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
 			    phy_interface_t interface)
 {
@@ -1303,7 +1310,21 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
 		}
 
 		xpcs->pcs.ops = &xpcs_phylink_ops;
-		xpcs->pcs.poll = true;
+
+		ret = of_irq_get(mdiodev->dev.of_node, 0);
+		if (ret == -EPROBE_DEFER)
+			goto out;
+
+		if (ret > 0) {
+			ret = devm_request_threaded_irq(&mdiodev->dev, ret,
+							NULL, xpcs_irq,
+							IRQF_ONESHOT,
+							KBUILD_MODNAME, xpcs);
+			if (ret < 0)
+				goto out;
+		} else {
+			xpcs->pcs.poll = true;
+		}
 
 		ret = xpcs_soft_reset(xpcs, compat);
 		if (ret)


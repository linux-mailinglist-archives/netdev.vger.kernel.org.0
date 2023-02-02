Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDDE687E23
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjBBM7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjBBM7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:59:17 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477418F241;
        Thu,  2 Feb 2023 04:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675342749; x=1706878749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gOPgGw0RohtMRFMCFrPybEvNkhUd8DRkAKdQTixdWLk=;
  b=wN/tie7PXKsvgyYPNfmOkfUVkYMGFhEVyLZK00FvOasaK7psHFcP1jOG
   54bL5xl+kyEU/2UXRqycUh9pn00FcsjuzZ+aq07tzXPLBp1BxS1p/Y+J0
   3UY5zfA0gERa6Iz005fxWOIGgb03JHt5EP2tPVFh6e/nGUCLUBxH3SKyU
   9OECkTzbXzLpsB1BFr0ToLg981AJGmxlEA0l6NVQ1zrv7Xsoh2Y8rFXFm
   bBlp+ugzlhI8kRv1lvJ711piq+7XdOXOOA0GJsYD0whSWK8gecg+B8EPi
   f+02oK+rD3Ek7vot+EfFeWmGQSY+B9wMJn94Wd6FvnEbaLIOUBhx9GYV9
   g==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="135251855"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 05:59:08 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 05:59:05 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 05:59:01 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 07/11] net: dsa: microchip: lan937x: update switch register
Date:   Thu, 2 Feb 2023 18:29:26 +0530
Message-ID: <20230202125930.271740-8-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Second switch in cascaded connection doesn't have port with macb
interface. dsa_switch_register returns error if macb interface is
not up. Due to this reason, second switch in cascaded connection will
not report error during dsa_switch_register and mib thread work will be
invoked even if actual switch register is not done. This will lead to
kernel warning and it can be avoided by checking device tree setup
status. This will return true only after actual switch register is done.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 2160a3e61a5a..0df71156a540 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -3213,6 +3213,7 @@ int ksz_switch_register(struct ksz_device *dev)
 {
 	const struct ksz_chip_data *info;
 	struct device_node *port, *ports;
+	struct dsa_switch_tree *dst;
 	phy_interface_t interface;
 	unsigned int port_num;
 	int ret;
@@ -3330,6 +3331,15 @@ int ksz_switch_register(struct ksz_device *dev)
 		return ret;
 	}
 
+	/* Do not proceed further if device tree setup is not done.
+	 * dsa_register_switch() will not report error in case of
+	 * cascaded switch. This will lead to scheduling mib read
+	 * work and kernel warning.
+	 */
+	dst = dev->ds->dst;
+	if (!dst->setup)
+		return 0;
+
 	/* Read MIB counters every 30 seconds to avoid overflow. */
 	dev->mib_read_interval = msecs_to_jiffies(5000);
 
-- 
2.34.1


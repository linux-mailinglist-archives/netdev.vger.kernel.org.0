Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF51B6607E3
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 21:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjAFULz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 15:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236639AbjAFULQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 15:11:16 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4463AB02;
        Fri,  6 Jan 2023 12:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673035863; x=1704571863;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iNGgPBxl9mMcCW/EJLM/F3Imh9ZuEmThyhwpRRQ3fnM=;
  b=TrrLxCVR5nF8b+YuuDT6Hyh0FlKKeB2XlVwShV2CDDUIjzHKNBEiUtFS
   5lfaJ9aM6JkwoVoAU3fRtUvK4c/GcT3deczxVmrH/yNSICtX4eY0iAGxc
   xrLwi59sX5+Wcz2wvz7QXcEnmqb5gOkGm/lxtFSEgDzhJiB2DJfLJX6qV
   VAm9Yz78nBXEt83TGfhXmMVJj6fBFacLgitV8jOTATXHVAXIccmY6pvmy
   IK0TwzJQ003PGKNZqGrJdHI+jlMD/YpVeuMBUI1uYZXaThJuBDxSfjh1o
   m2VCftpoldp40bDgqCcLbEYpONR3z9C/vqxfmhU5OFUta0wSJp0vZNwsA
   g==;
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="191137480"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jan 2023 13:11:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 13:10:46 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 13:10:44 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        <michael@walle.cc>, <steen.hegelund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH] net: lan966x: Allow to add rules in TCAM even if not enabled
Date:   Fri, 6 Jan 2023 21:15:07 +0100
Message-ID: <20230106201507.2206113-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit implemented the vcap_operations to allow to add an
entry in the TCAM. One of the callbacks is to validate the supported
keysets. If the TCAM lookup was not enabled, then this will return
failure so no entries could be added.
This doesn't make much sense, as you can enable at a later point the
TCAM. Therefore change it such to allow entries in TCAM even it is not
enabled.

Fixes: 4426b78c626d ("net: lan966x: Add port keyset config and callback interface")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
index d8dc9fbb81e1a..a54c0426a35f3 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
@@ -95,10 +95,7 @@ lan966x_vcap_is2_get_port_keysets(struct net_device *dev, int lookup,
 	bool found = false;
 	u32 val;
 
-	/* Check if the port keyset selection is enabled */
 	val = lan_rd(lan966x, ANA_VCAP_S2_CFG(port->chip_port));
-	if (!ANA_VCAP_S2_CFG_ENA_GET(val))
-		return -ENOENT;
 
 	/* Collect all keysets for the port in a list */
 	if (l3_proto == ETH_P_ALL)
-- 
2.38.0


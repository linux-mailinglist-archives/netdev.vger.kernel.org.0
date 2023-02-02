Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAB1687E1F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjBBM7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbjBBM7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:59:03 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCD689FAC;
        Thu,  2 Feb 2023 04:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675342741; x=1706878741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=32H2oJWTk/bY+4r4IuXy3k5EXeQhNmioppl2l7N7A2E=;
  b=St3z3Em+sFB1Naes9cIk9mdM0mhZF1hfBRVP3q/xy+VbJ+VddBeYDacW
   PQibYf/GYKF2iAeXDuPaFac3Vs495+kyLmh2wy3U+wX4yxoqxHd6bDkU1
   ujWQuIMZoGoMStOiNhAlllhz/IcQbRd5KzHCK39TR7z0Z7W9tu9X4MG2L
   mBlVN51k5TfT/ctOGKCv4V8rjUdI4Cq7IWFkbWhh1myzMN6OH6+qgnUts
   a4fXeJXdOeIRWNKH2V2ptQokPEfhcDoh6XZgM5opXGFU3zZOPhw086a3n
   sA5QO8aO0hGmOwIVbTQEvZcUbJx5Pm0qMmp1x++/Y7UCJWcfoJd3FpVIO
   g==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="135251838"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 05:59:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 05:59:00 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 05:58:55 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 06/11] net: dsa: microchip: lan937x: get cascade tag protocol
Date:   Thu, 2 Feb 2023 18:29:25 +0530
Message-ID: <20230202125930.271740-7-rakesh.sankaranarayanan@microchip.com>
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

Update ksz_get_tag_protocol to return separate tag protocol if
switch is connected in cascade mode. Variable ds->dst->last_switch
will contain total number of switches registered. For cascaded
connection alone, this will be more than zero.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index adf8391dd29f..2160a3e61a5a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2567,9 +2567,13 @@ static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 	    dev->chip_id == KSZ9567_CHIP_ID)
 		proto = DSA_TAG_PROTO_KSZ9477;
 
-	if (is_lan937x(dev))
+	if (is_lan937x(dev)) {
 		proto = DSA_TAG_PROTO_LAN937X_VALUE;
 
+		if (ds->dst->last_switch)
+			proto = DSA_TAG_PROTO_LAN937X_CASCADE_VALUE;
+	}
+
 	return proto;
 }
 
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25D1687E28
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjBBM7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbjBBM7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:59:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B118F25B;
        Thu,  2 Feb 2023 04:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675342752; x=1706878752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IPrDFvqI3OZVkXu9LgANLuFGMbNRDf2adVIuQuhodQ4=;
  b=ruAuCAvm3vIujiNwqYsYVNOBzTXBCBYVAniNwYzHhie02EPuwuY+0sKX
   wLMni1nTN8t9u3AoLvlirZM1+v3ETOmr+eXf/qsDZt55MWuWN52TkwCNf
   BqndCA4Fw+zv1Am5jj29rYxZrdzyUk5w8IRi7gAkHesfSwPHXT3dZ6igG
   wYeQJOw/KMi+S8uT1jQ9UsMXHvrh8Hq1xsFQK7rzqZIQ2iIyHfAAkUcrg
   mH6PHPvWiWbg0/Pw5ljy48xA3bZF+W2Ey2+eYCrtZ7OTCmIicKW1uhF6S
   oBTdJvE6pq7ZV/94SJ+PJrmqoIsX9I3L/YCkPCll52K5RCqHoCHFSRWRX
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="135251882"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 05:59:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 05:59:10 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 05:59:06 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 08/11] net: dsa: microchip: lan937x: avoid mib read for cascaded port
Date:   Thu, 2 Feb 2023 18:29:27 +0530
Message-ID: <20230202125930.271740-9-rakesh.sankaranarayanan@microchip.com>
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

Cascaded port need not be involved in mib read process. Unlike cpu port,
mib read function will be called for all other ports. Add check to skip
function if port is of type DSA_PORT_TYPE_DSA.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 0df71156a540..913296c5dd50 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2230,7 +2230,8 @@ static void ksz_mib_read_work(struct work_struct *work)
 	int i;
 
 	for (i = 0; i < dev->info->port_cnt; i++) {
-		if (dsa_is_unused_port(dev->ds, i))
+		if (dsa_is_unused_port(dev->ds, i) ||
+		    dsa_is_dsa_port(dev->ds, i))
 			continue;
 
 		p = &dev->ports[i];
-- 
2.34.1


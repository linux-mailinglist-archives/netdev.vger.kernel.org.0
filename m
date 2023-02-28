Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962286A609E
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 21:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjB1UsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 15:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjB1UsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 15:48:16 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F659D304;
        Tue, 28 Feb 2023 12:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1677617288; x=1709153288;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WfkJSHVX8viEFAtDtKjqj0PzUjCvDzCn7Cy2sK93AaA=;
  b=EX0lPT2lGeaaJYVZUHefQLbj+N2jhTJIvvO5uJWssG11JMkMdd0BxkBl
   XDoQ5MFlX7DN3BAigU2QNqiUublXVXCrbAdU4vR/PfWo+EmKMwyF6fqww
   yvA/ZP8CnQNCT3MwLaoIQjMfUV1i99F+0fWRCjvTWz/gogKTb8KQZVNN0
   uHUrjWVfzpKTwk0Gx2AeYCFCX7/AaZMEbh/of/r/r0W4BElxjswy0BRNA
   SUhZYmarijc81IYLQewu60z+OKLUYOpFOAN423/AXPZN5+fByHomQXZGf
   4Dk3G3LI6+4O6WorpWmtkx2A/Qz/Yq2uOBNAe72qFWfnacU4/MfOzIA6W
   w==;
X-IronPort-AV: E=Sophos;i="5.98,222,1673938800"; 
   d="scan'208";a="202642252"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Feb 2023 13:48:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 13:48:07 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 13:48:05 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: lan966x: Fix port police support using tc-matchall
Date:   Tue, 28 Feb 2023 21:47:42 +0100
Message-ID: <20230228204742.2599151-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
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

When the police was removed from the port, then it was trying to
remove the police from the police id and not from the actual
police index.
The police id represents the id of the police and police index
represents the position in HW where the police is situated.
The port police id can be any number while the port police index
is a number based on the port chip port.
Fix this by deleting the police from HW that is situated at the
police index and not police id.

Fixes: 5390334b59a3 ("net: lan966x: Add port police support using tc-matchall")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_police.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
index a9aec900d608d..7d66fe75cd3bf 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
@@ -194,7 +194,7 @@ int lan966x_police_port_del(struct lan966x_port *port,
 		return -EINVAL;
 	}
 
-	err = lan966x_police_del(port, port->tc.police_id);
+	err = lan966x_police_del(port, POL_IDX_PORT + port->chip_port);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed to add policer to port");
-- 
2.38.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13CE4FAA33
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 20:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243059AbiDISla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 14:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243029AbiDISlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 14:41:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85C829F59A;
        Sat,  9 Apr 2022 11:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649529545; x=1681065545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YsP1IVNf55NG73OXKQeumu+QVgE0A14MitZqXw4kQzA=;
  b=pljZFkIMz7IGZC2WmzrAdaXnGolsMlFpnUBeizCc6/VVAyEtr7qL9QHu
   TSZy4rxlLwylt8TgcYLnmY7U+qax68jf+pzdwHc4wlsSiKARbyCE3VfS+
   j9PXQEg91e0yA5owm0eMg+MGMPaKpABRkxJ2bgJr0j0xrXoSgxpiKmfZn
   bvVSO2SilBDzLaarR0nImT0Ty2CXvzeq5OjEaPjc8JIfNNxfaTaoWZ5jL
   WCXXxaiO+7REU8bYGaw76IxcCiimLJrxugIYSyFLbTfo5IeZRe7OidNHe
   BEcXmL7wNm87ELbENu0Q1uAjVHBzzgXtfgdyyOFV9tEW6XLNxpsqlsiEQ
   A==;
X-IronPort-AV: E=Sophos;i="5.90,248,1643698800"; 
   d="scan'208";a="169060535"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Apr 2022 11:39:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 9 Apr 2022 11:39:05 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 9 Apr 2022 11:39:03 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 4/4] net: lan966x: Stop processing the MAC entry is port is wrong.
Date:   Sat, 9 Apr 2022 20:41:43 +0200
Message-ID: <20220409184143.1204786-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220409184143.1204786-1-horatiu.vultur@microchip.com>
References: <20220409184143.1204786-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when getting a new MAC is learn, the HW generates an
interrupt. So then the SW will check the new entry and checks if it
arrived on a correct port. If it didn't just generate a warning.
But this could still crash the system. Therefore stop processing that
entry when an issue is seen.

Fixes: 5ccd66e01cbef8 ("net: lan966x: add support for interrupts from analyzer")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index ce5970bdcc6a..2679111ef669 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -346,7 +346,8 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 
 			lan966x_mac_process_raw_entry(&raw_entries[column],
 						      mac, &vid, &dest_idx);
-			WARN_ON(dest_idx > lan966x->num_phys_ports);
+			if (WARN_ON(dest_idx > lan966x->num_phys_ports))
+				continue;
 
 			/* If the entry in SW is found, then there is nothing
 			 * to do
@@ -392,7 +393,8 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 
 		lan966x_mac_process_raw_entry(&raw_entries[column],
 					      mac, &vid, &dest_idx);
-		WARN_ON(dest_idx > lan966x->num_phys_ports);
+		if (WARN_ON(dest_idx > lan966x->num_phys_ports))
+			continue;
 
 		mac_entry = lan966x_mac_alloc_entry(mac, vid, dest_idx);
 		if (!mac_entry)
-- 
2.33.0


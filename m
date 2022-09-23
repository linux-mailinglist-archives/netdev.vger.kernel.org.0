Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E924F5E775C
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 11:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiIWJks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 05:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiIWJio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 05:38:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E830F184D;
        Fri, 23 Sep 2022 02:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663925839; x=1695461839;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bIO/NRfK+8hLta04E3Rq6Senn8z/tJVFm8Ma4wyZzQY=;
  b=tsmw8v5HRY3iNId4e0SF2r61o04NLEB1k9UakgD/GEelKb/DSYFKoGHH
   lCP9IPc6455zXYTXRLuA+wGnhfURNu7H76YBJIHor4zaBhWvYHEx6FcqL
   fAuERzL4u0vW8qI6oQSug0cTGKmPlsIghnRX5t8HJiervSz4vWh18blgq
   UG9lk/WpePKBTIMLyJ2nm706P2+Qcj6Zl64FEYR6BHVQMUlWikpe6wkHm
   +Hm71wb6FeXbTB4QDe5rZeO2DoBXqe0XIMlTLUJK1mAJzAQz0aDa6OoOm
   iFi2g7KESYWpeD4GmKCEiVCmraAj2feVD0L7mNOpsnEPCQH/bPxIgEPV2
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="181665623"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Sep 2022 02:37:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 23 Sep 2022 02:37:16 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 23 Sep 2022 02:37:12 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <bryan.whitehead@microchip.com>, <richardcochran@gmail.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH] net: lan743x: Fixes: 60942c397af6 ("Add support for PTP-IO Event Input External  Timestamp (extts)"
Date:   Fri, 23 Sep 2022 15:07:09 +0530
Message-ID: <20220923093709.10355-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove PTP_PF_EXTTS support for non-PCI11x1x devices since they do not
support the PTP-IO Input event triggered timestamping mechanisms
added
---
 drivers/net/ethernet/microchip/lan743x_ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 6a11e2ceb013..da3ea905adbb 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -1049,6 +1049,10 @@ static int lan743x_ptpci_verify_pin_config(struct ptp_clock_info *ptp,
 					   enum ptp_pin_function func,
 					   unsigned int chan)
 {
+	struct lan743x_ptp *lan_ptp =
+		container_of(ptp, struct lan743x_ptp, ptp_clock_info);
+	struct lan743x_adapter *adapter =
+		container_of(lan_ptp, struct lan743x_adapter, ptp);
 	int result = 0;
 
 	/* Confirm the requested function is supported. Parameter
@@ -1057,7 +1061,10 @@ static int lan743x_ptpci_verify_pin_config(struct ptp_clock_info *ptp,
 	switch (func) {
 	case PTP_PF_NONE:
 	case PTP_PF_PEROUT:
+		break;
 	case PTP_PF_EXTTS:
+		if (!adapter->is_pci11x1x)
+			result = -1;
 		break;
 	case PTP_PF_PHYSYNC:
 	default:
-- 
2.25.1


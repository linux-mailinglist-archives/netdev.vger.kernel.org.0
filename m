Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B065F64821C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 13:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiLIMC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 07:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiLIMCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 07:02:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5253206F;
        Fri,  9 Dec 2022 04:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670587331; x=1702123331;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wsM3FY6DnRodmBXZFbVV09BKkLbtFB2sIt9sAbnVvkg=;
  b=jH5fbe5zfFOZ5QwtfB5WfPNrRWtML8Mk4aQph1sgbLRceucV3ao1LCG2
   J0qIsSuHdyijmA9CcJhN2MIA36A+DIr14+oxR37FrvZ+HkxHhj8HTfP29
   1l/7ncQ577CYY7gFM04/uxpHH35jBC0W9YqXKFBPXiEioAwgmuPZKom7q
   4fMbXFzAcIBPEBsP/c4UZ2/M2E5bO8TCU63/eijfFbhS83BVuy5PwK6Iz
   ImQ/NdVn/kyGU1heF8aTgEZ49W8+am6qGlL/UeinygENWsBM5h/LXfDQG
   4Ibzx9go6DvtM3ks1blZ7UuhdSzkYuY9QwQ8xDgO67PP4/Ayny9p890B0
   A==;
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="190869007"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 05:02:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 05:02:10 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Dec 2022 05:02:07 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        kernel test robot <lkp@intel.com>,
        "Dan Carpenter" <error27@gmail.com>
Subject: [PATCH net-next] net: microchip: vcap: Fix initialization of value and mask
Date:   Fri, 9 Dec 2022 13:07:01 +0100
Message-ID: <20221209120701.218937-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
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

Fix the following smatch warning:

smatch warnings:
drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c:103 vcap_debugfs_show_rule_keyfield() error: uninitialized symbol 'value'.
drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c:106 vcap_debugfs_show_rule_keyfield() error: uninitialized symbol 'mask'.

In case the vcap field was VCAP_FIELD_U128 and the key was different
than IP6_S/DIP then the value and mask were not initialized, therefore
initialize them.

Fixes: 610c32b2ce66 ("net: microchip: vcap: Add vcap_get_rule")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index 895bfff550d23..1237601ac9dc1 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -83,6 +83,8 @@ static void vcap_debugfs_show_rule_keyfield(struct vcap_control *vctrl,
 		hex = true;
 		break;
 	case VCAP_FIELD_U128:
+		value = data->u128.value;
+		mask = data->u128.value;
 		if (key == VCAP_KF_L3_IP6_SIP || key == VCAP_KF_L3_IP6_DIP) {
 			u8 nvalue[16], nmask[16];
 
-- 
2.38.0


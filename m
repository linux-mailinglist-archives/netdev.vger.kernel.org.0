Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81AE650874
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 09:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiLSIRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 03:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLSIRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 03:17:14 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FE4BE23;
        Mon, 19 Dec 2022 00:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671437831; x=1702973831;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y+btHyYZt6deb9ZTjxKgTd1t5WxObKlAJo5VmP00Z6U=;
  b=xwaqUpwRop2MKwm/HalQ5KuYXbglFLih8Mo+YovkOxv0u59D0B2UBDFc
   2WbRhudB7liA9ad20X5+6EoFQQd/F5JIDje3AsqbAs0ah6XQen57PEuJT
   EqN59nUUYq2ljf7LJlrIF1eYcgtF24lM8CEa6Xr0YZBPeq+RUQFxV8y+3
   YGyVWNIWnup3ECCviitRm2QQMD0PBtRY1v6QuAyaRQDQFd7O95xi1Np18
   hwCV6ZnWCLVoNoKPINHBpZn9gGIb6VH/gAKu3raespz3sE+BwHhBBZUIm
   sfXqjTL1q0PEwOvsBay/kWp6YxM8zIgfB+ffHaflVnzKsPJwYfUTfUDaj
   A==;
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="128773399"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Dec 2022 01:17:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 01:17:08 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 01:17:06 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        kernel test robot <lkp@intel.com>,
        "Dan Carpenter" <error27@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCH net v2] net: microchip: vcap: Fix initialization of value and mask
Date:   Mon, 19 Dec 2022 09:22:15 +0100
Message-ID: <20221219082215.76652-1-horatiu.vultur@microchip.com>
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
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
v1->v2:
- rebase on net
- both the mask and value were assigned to data->u128.value, which is
  wrong, fix this.
---
 drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index 895bfff550d23..e0b206247f2eb 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -83,6 +83,8 @@ static void vcap_debugfs_show_rule_keyfield(struct vcap_control *vctrl,
 		hex = true;
 		break;
 	case VCAP_FIELD_U128:
+		value = data->u128.value;
+		mask = data->u128.mask;
 		if (key == VCAP_KF_L3_IP6_SIP || key == VCAP_KF_L3_IP6_DIP) {
 			u8 nvalue[16], nmask[16];
 
-- 
2.38.0


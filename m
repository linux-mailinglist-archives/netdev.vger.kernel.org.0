Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7300D6718DF
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjARKYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjARKYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:24:25 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC642B2D04;
        Wed, 18 Jan 2023 01:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674034132; x=1705570132;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l27HwclIeNetABY6+nzs7YJaxeaFyHEyRmuPbaM03G8=;
  b=HDxThLy8kTzCShiHxffNEa7AsAVQKfPHtGMWUGHBweT9NMM9VgMfp2G9
   up/A/hcBowE2gC2VsEptY68HFtoXjtXWgOzIDnUswq4n6aIF2hEMwz/gJ
   VIZNih0czKruV5J7OqhXFYI0zb4CpByS+XCWisEivEpG/tT8voZK6LJjZ
   vL1AUIlQblc8D9LoUpEAkFSunX+AsOwguKMMOXM1ty/JMd5T/u9eaMxQ6
   U6PrwnuqpFogrqmmt1rKobHp7/DVH7wQpkj23dexvwEiudcQoHjs5UJ0S
   M3IlJ1F0+ipOAocp2zW53LAGu8f8uW/N7P9rSVYvbaQ+kbkZH6am79wdK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="411179885"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="411179885"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 01:28:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="723013897"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="723013897"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jan 2023 01:28:50 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id D10A0368; Wed, 18 Jan 2023 11:29:24 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v1 1/1] net: hns: Switch to use acpi_evaluate_dsm_typed()
Date:   Wed, 18 Jan 2023 11:29:22 +0200
Message-Id: <20230118092922.39426-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The acpi_evaluate_dsm_typed() provides a way to check the type of the
object evaluated by _DSM call. Use it instead of open coded variant.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../net/ethernet/hisilicon/hns/hns_dsaf_misc.c   | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
index 740850b64aff..d8fb9ed96258 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -554,11 +554,11 @@ static phy_interface_t hns_mac_get_phy_if_acpi(struct hns_mac_cb *mac_cb)
 	argv4.package.count = 1;
 	argv4.package.elements = &obj_args;
 
-	obj = acpi_evaluate_dsm(ACPI_HANDLE(mac_cb->dev),
-				&hns_dsaf_acpi_dsm_guid, 0,
-				HNS_OP_GET_PORT_TYPE_FUNC, &argv4);
-
-	if (!obj || obj->type != ACPI_TYPE_INTEGER)
+	obj = acpi_evaluate_dsm_typed(ACPI_HANDLE(mac_cb->dev),
+				      &hns_dsaf_acpi_dsm_guid, 0,
+				      HNS_OP_GET_PORT_TYPE_FUNC, &argv4,
+				      ACPI_TYPE_INTEGER);
+	if (!obj)
 		return phy_if;
 
 	phy_if = obj->integer.value ?
@@ -603,9 +603,9 @@ static int hns_mac_get_sfp_prsnt_acpi(struct hns_mac_cb *mac_cb, int *sfp_prsnt)
 
 	obj = acpi_evaluate_dsm(ACPI_HANDLE(mac_cb->dev),
 				&hns_dsaf_acpi_dsm_guid, 0,
-				HNS_OP_GET_SFP_STAT_FUNC, &argv4);
-
-	if (!obj || obj->type != ACPI_TYPE_INTEGER)
+				HNS_OP_GET_SFP_STAT_FUNC, &argv4,
+				ACPI_TYPE_INTEGER);
+	if (!obj)
 		return -ENODEV;
 
 	*sfp_prsnt = obj->integer.value;
-- 
2.39.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7E2674B88
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjATE7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjATE7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:59:36 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53BED05EE;
        Thu, 19 Jan 2023 20:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674190079; x=1705726079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E98QGbc8dlCtreJMfmIlTfn2lZ42kDRmuNfuyIyYYMg=;
  b=jjyFhL55I2x8bWRNfQ3IImS98aao5Khj9QMvYOuVf3SLe57yyCJRhoYI
   +rRilMz0XGGkdCjMKVEwI4O/FNZhyAcoh2D9JIx/ZSGOkyotHrb1TJXmH
   gEUZAfP5kudBd66ye6pOTdSrt/hdOtJHbZnVhjf+sA7cHFLN4celEEGWx
   rHoSOR0du3kcz27xKqI1E8SWqGmmgv6QsFe5W5j6EGEXIOWt02nO8IuAK
   8Y0WHq7X07Zlb1w4L63VwBZvPjoK8CzzBOuXUMKbx8saBEvF8R4kEo+J4
   9bSRxGUDFuabAHOSc9Th1omcoGeMPJ4VvAA9ADdB8W9RXHRo698Bu2NeZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="308970218"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="308970218"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 11:10:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="728816425"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="728816425"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 19 Jan 2023 11:10:28 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 529D292; Thu, 19 Jan 2023 21:11:03 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>
Subject: [PATCH net-next v2 2/2] net: hns: Switch to use acpi_evaluate_dsm_typed()
Date:   Thu, 19 Jan 2023 21:11:01 +0200
Message-Id: <20230119191101.80131-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119191101.80131-1-andriy.shevchenko@linux.intel.com>
References: <20230119191101.80131-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The acpi_evaluate_dsm_typed() provides a way to check the type of the
object evaluated by _DSM call. Use it instead of open coded variant.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
v2: added tag (Tony), fixed compilation errors (LKP)
 .../ethernet/hisilicon/hns/hns_dsaf_misc.c    | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
index 740850b64aff..5df19c604d09 100644
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
@@ -601,11 +601,11 @@ static int hns_mac_get_sfp_prsnt_acpi(struct hns_mac_cb *mac_cb, int *sfp_prsnt)
 	argv4.package.count = 1;
 	argv4.package.elements = &obj_args;
 
-	obj = acpi_evaluate_dsm(ACPI_HANDLE(mac_cb->dev),
-				&hns_dsaf_acpi_dsm_guid, 0,
-				HNS_OP_GET_SFP_STAT_FUNC, &argv4);
-
-	if (!obj || obj->type != ACPI_TYPE_INTEGER)
+	obj = acpi_evaluate_dsm_typed(ACPI_HANDLE(mac_cb->dev),
+				      &hns_dsaf_acpi_dsm_guid, 0,
+				      HNS_OP_GET_SFP_STAT_FUNC, &argv4,
+				      ACPI_TYPE_INTEGER);
+	if (!obj)
 		return -ENODEV;
 
 	*sfp_prsnt = obj->integer.value;
-- 
2.39.0


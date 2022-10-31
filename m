Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD06613B9B
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 17:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiJaQqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 12:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiJaQqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 12:46:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45BE12627
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 09:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667234759; x=1698770759;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6bC4kh1lmby4YdGGRv2xpkD8AhDbBOird6TACXnsh1Y=;
  b=RZQfNssv/PncOZWdlFbEb4LILhvf67DbChy+YaGRGwKsC2uKNUN9yqKj
   h7mmcU9yS/NOquNP0byB+tXiF4Be1bBHgZcO+SR4yN0eANPbNKwWrq2oz
   VcHKYd/j1LQq3G46B+RbNztcIhw8NgxsnrbSB8pbpXwBfDWuTQXWYQ3YO
   4xQLMjY/Xm6deigtfmHuuGzvqdxVBkz8FK0YBfDOo0GGp1eqxMomcEcv2
   E/E02YTcAV9emNxgkyjBSLosOlrVkQfxB5WNdDI/csP8+Tu8bJJkPfDDB
   vI06GmpXt8hLTsDMAwhUxSWKbI3JstlLr8QRj1ZojVT3QZN18MBsH79Xz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="335607978"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="335607978"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 09:45:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="739018634"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="739018634"
Received: from bswcg005.iind.intel.com ([10.224.174.25])
  by fmsmga002.fm.intel.com with ESMTP; 31 Oct 2022 09:45:56 -0700
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        linuxwwan@intel.com,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Subject: [PATCH net 1/3] net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg
Date:   Mon, 31 Oct 2022 22:15:19 +0530
Message-Id: <20221031164519.1886836-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

ipc_pcie_read_bios_cfg() is using the acpi_evaluate_dsm() to
obtain the wwan power state configuration from BIOS but is
not freeing the acpi_object. The acpi_evaluate_dsm() returned
acpi_object to be freed.

Free the acpi_object after use.

Fixes: 7e98d785ae61 ("net: iosm: entry point")
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 31f57b986df2..97cb6846c6ae 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -232,6 +232,7 @@ static void ipc_pcie_config_init(struct iosm_pcie *ipc_pcie)
  */
 static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 {
+	enum ipc_pcie_sleep_state sleep_state = IPC_PCIE_D0L12;
 	union acpi_object *object;
 	acpi_handle handle_acpi;
 
@@ -242,12 +243,16 @@ static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 	}
 
 	object = acpi_evaluate_dsm(handle_acpi, &wwan_acpi_guid, 0, 3, NULL);
+	if (!object)
+		goto default_ret;
+
+	if (object->integer.value == 3)
+		sleep_state = IPC_PCIE_D3L2;
 
-	if (object && object->integer.value == 3)
-		return IPC_PCIE_D3L2;
+	kfree(object);
 
 default_ret:
-	return IPC_PCIE_D0L12;
+	return sleep_state;
 }
 
 static int ipc_pcie_probe(struct pci_dev *pci,
-- 
2.34.1


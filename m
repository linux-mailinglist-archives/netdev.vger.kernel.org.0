Return-Path: <netdev+bounces-6337-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D52DC715D13
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:24:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71E4628113C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B02417AA9;
	Tue, 30 May 2023 11:24:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902464A0C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:24:16 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02EC110
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685445845; x=1716981845;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DTyJbfcCuD2xoElw8R1IpsbO9/IwcYEsoLeg/6fBQIs=;
  b=eRc5nHCk6hdiioNUbiB4hwx8aJRac7m71EGTl3nBLcryhC2PMjk+3pVk
   iyhZCEYIzspV1gYX3qRmr5VdvMRfACw5YqflFYF5px6YtmbXIJLRbGpmH
   XI9F6wV1F04U8T9EQMwuLTLthKMRgX2+MxDZU5Kcp//Jjrjdd8FjUkzH7
   xu8163JDhVaTvOSGjDPeGpE6oNO3X/Z+bwNsG8sw8/btWwNb2iZVycqhe
   FT79GTRRtnbVHINUH6yD/wFslikmCU+5EuIBq9gmXybmB/SkexKfdtMRH
   QePHWMvTCjrYHO4sq8PBLWsPghRmtor2WXvTq+IkLBjKuKfIFK9YnhKQ2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="420645329"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="420645329"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 04:23:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="776293860"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="776293860"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga004.fm.intel.com with ESMTP; 30 May 2023 04:23:41 -0700
Received: from pkitszel-desk.intel.com (unknown [10.254.150.168])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id E400535FB1;
	Tue, 30 May 2023 12:23:39 +0100 (IST)
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
To: intel-wired-lan-bounces@osuosl.org
Cc: netdev@vger.kernel.org,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH iwl-next] ice: clean up freeing SR-IOV VFs
Date: Tue, 30 May 2023 13:23:15 +0200
Message-Id: <20230530112315.20795-1-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The check for existing VFs was redundant since very
inception of SR-IOV sysfs interface in the kernel,
see commit 1789382a72a5 ("PCI: SRIOV control and status via sysfs").

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 2ea6d24977a6..1f66914c7a20 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -905,14 +905,13 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
  */
 static int ice_pci_sriov_ena(struct ice_pf *pf, int num_vfs)
 {
-	int pre_existing_vfs = pci_num_vf(pf->pdev);
 	struct device *dev = ice_pf_to_dev(pf);
 	int err;
 
-	if (pre_existing_vfs && pre_existing_vfs != num_vfs)
+	if (!num_vfs) {
 		ice_free_vfs(pf);
-	else if (pre_existing_vfs && pre_existing_vfs == num_vfs)
 		return 0;
+	}
 
 	if (num_vfs > pf->vfs.num_supported) {
 		dev_err(dev, "Can't enable %d VFs, max VFs supported is %d\n",
-- 
2.38.1



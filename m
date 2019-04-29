Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77ADEABA
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbfD2TOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:14:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:61547 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729215AbfD2TOL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:14:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 12:14:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="341867048"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 29 Apr 2019 12:14:09 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/12] i40e: remove out-of-range comparisons in i40e_validate_cloud_filter
Date:   Mon, 29 Apr 2019 12:16:24 -0700
Message-Id: <20190429191628.31212-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The function i40e_validate_cloud_filter checks that the destination and
source port numbers are valid by attempting to ensure that the number is
non-zero and no larger than 0xFFFF. However, the types for the dst_port
and src_port variable are __be16 which by definition cannot be larger
than 0xFFFF

Since these values cannot be larger than 2 bytes, the check to see if
they exceed 0xFFFF is meaningless.

One might consider these checks as some sort of defensive coding, in
case the type was later changed. However, these checks also byte-swap
the value before comparison using be16_to_cpu, which will truncate the
values to 16bits anyways. Additionally, changing the type would require
updating the opcodes to support new data layout of these virtchnl
commands.

Remove the check to silence the -Wtype-limits warning that was added to
GCC 8.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 24628de8e624..925ca880bea3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3129,7 +3129,7 @@ static int i40e_validate_cloud_filter(struct i40e_vf *vf,
 	}
 
 	if (mask.dst_port & data.dst_port) {
-		if (!data.dst_port || be16_to_cpu(data.dst_port) > 0xFFFF) {
+		if (!data.dst_port) {
 			dev_info(&pf->pdev->dev, "VF %d: Invalid Dest port\n",
 				 vf->vf_id);
 			goto err;
@@ -3137,7 +3137,7 @@ static int i40e_validate_cloud_filter(struct i40e_vf *vf,
 	}
 
 	if (mask.src_port & data.src_port) {
-		if (!data.src_port || be16_to_cpu(data.src_port) > 0xFFFF) {
+		if (!data.src_port) {
 			dev_info(&pf->pdev->dev, "VF %d: Invalid Source port\n",
 				 vf->vf_id);
 			goto err;
-- 
2.20.1


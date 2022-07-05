Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FEA56607D
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 03:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiGEBIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 21:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiGEBIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 21:08:48 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE8E2AF3;
        Mon,  4 Jul 2022 18:08:46 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LcPd86CJKzhYZG;
        Tue,  5 Jul 2022 09:06:20 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Jul
 2022 09:08:12 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] i40e: i40e_reset_vf should return false if reset vf timeout
Date:   Tue, 5 Jul 2022 09:13:04 +0800
Message-ID: <20220705011304.230622-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when trigger vf reset, but vf status is not ready, i40e_reset_vf
should not do other cleanup action. The current logic is always return
true. But it can't cover timeout scenary, and the looping in function
i40e_vc_reset_vf is useless. 
Waiting for 120ms will cover most normal scenary. And the caller 
function should try again when timeout or accept that resetting vf 
failed.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index d01fb592778c..42262009a00c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1564,11 +1564,17 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	if (flr)
 		usleep_range(10000, 20000);
 
-	if (!rsd)
-		dev_err(&pf->pdev->dev, "VF reset check timeout on VF %d\n",
-			vf->vf_id);
 	usleep_range(10000, 20000);
 
+	if (!rsd) {
+		reg = rd32(hw, I40E_VPGEN_VFRSTAT(vf->vf_id));
+		if (!(reg & I40E_VPGEN_VFRSTAT_VFRD_MASK)) {
+			dev_err(&pf->pdev->dev, "VF reset check timeout on VF %d\n",
+				vf->vf_id);
+			return false;
+		}
+	}
+
 	/* On initial reset, we don't have any queues to disable */
 	if (vf->lan_vsi_idx != 0)
 		i40e_vsi_stop_rings(pf->vsi[vf->lan_vsi_idx]);
-- 
2.17.1


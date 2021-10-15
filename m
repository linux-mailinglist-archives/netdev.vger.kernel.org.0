Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54EC42EE60
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 12:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbhJOKHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 06:07:00 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:47826 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237806AbhJOKGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 06:06:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Us8GmCj_1634292278;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Us8GmCj_1634292278)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Oct 2021 18:04:41 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     jesse.brandeburg@intel.com
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] ice: Fix missing error code in ice_ena_vfs()
Date:   Fri, 15 Oct 2021 18:04:09 +0800
Message-Id: <1634292249-63098-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'ret'.

Eliminate the follow smatch warning:

drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:1979 ice_ena_vfs()
warn: missing error code 'ret'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 1c54c839935b ("ice: enable/disable switchdev when managing VFs")
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 4d0b643..b2a018c 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1975,8 +1975,10 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 
 	clear_bit(ICE_VF_DIS, pf->state);
 
-	if (ice_eswitch_configure(pf))
+	if (ice_eswitch_configure(pf)) {
+		ret = -EINVAL;
 		goto err_unroll_sriov;
+	}
 
 	return 0;
 
-- 
1.8.3.1


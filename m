Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B1BB59CC
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 04:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfIRCjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 22:39:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58806 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbfIRCjy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 22:39:54 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E8493CCD94CCCA3EC4AC;
        Wed, 18 Sep 2019 10:39:52 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Wed, 18 Sep 2019 10:39:45 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <jakub.kicinski@netronome.com>, <davem@davemloft.net>
CC:     <anna.schumaker@netapp.com>, <trond.myklebust@hammerspace.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhongjiang@huawei.com>
Subject: [PATCH net-next] ixgbe: Use memzero_explicit directly in crypto cases
Date:   Wed, 18 Sep 2019 10:36:35 +0800
Message-ID: <1568774195-8677-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In general, Use kzfree() to replace memset() + kfree() is feasible and
resonable.  But It's btter to use memzero_explicit() to replace memset()
in crypto cases.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index 113f608..7e4f32f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -960,9 +960,11 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 	return 0;
 
 err_aead:
-	kzfree(xs->aead);
+	memzero_explicit(xs->aead, sizeof(*xs->aead));
+	kfree(xs->aead);
 err_xs:
-	kzfree(xs);
+	memzero_explicit(xs, sizeof(*xs));
+	kfree(xs);
 err_out:
 	msgbuf[1] = err;
 	return err;
@@ -1047,7 +1049,8 @@ int ixgbe_ipsec_vf_del_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 	ixgbe_ipsec_del_sa(xs);
 
 	/* remove the xs that was made-up in the add request */
-	kzfree(xs);
+	memzero_explicit(xs, sizeof(*xs));
+	kfree(xs);
 
 	return 0;
 }
-- 
1.7.12.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F020DB4623
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 05:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387551AbfIQDs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 23:48:26 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2278 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728010AbfIQDs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 23:48:26 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A52C9B69D9B9EEE43606;
        Tue, 17 Sep 2019 11:48:24 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Tue, 17 Sep 2019 11:48:16 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <jakub.kicinski@netronome.com>, <davem@davemloft.net>
CC:     <anna.schumaker@netapp.com>, <trond.myklebust@hammerspace.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhongjiang@huawei.com>
Subject: [PATCH v2] ixgbe: Use memset_explicit directly in crypto cases
Date:   Tue, 17 Sep 2019 11:45:10 +0800
Message-ID: <1568691910-21442-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's better to use memset_explicit() to replace memset() in crypto cases.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index 31629fc..7e4f32f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -960,10 +960,10 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 	return 0;
 
 err_aead:
-	memset(xs->aead, 0, sizeof(*xs->aead));
+	memzero_explicit(xs->aead, sizeof(*xs->aead));
 	kfree(xs->aead);
 err_xs:
-	memset(xs, 0, sizeof(*xs));
+	memzero_explicit(xs, sizeof(*xs));
 	kfree(xs);
 err_out:
 	msgbuf[1] = err;
@@ -1049,7 +1049,7 @@ int ixgbe_ipsec_vf_del_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 	ixgbe_ipsec_del_sa(xs);
 
 	/* remove the xs that was made-up in the add request */
-	memset(xs, 0, sizeof(*xs));
+	memzero_explicit(xs, sizeof(*xs));
 	kfree(xs);
 
 	return 0;
-- 
1.7.12.4


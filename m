Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCBC2EB8FC
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 05:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbhAFEbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 23:31:01 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:1770 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbhAFEbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 23:31:01 -0500
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 1064TfXi022094;
        Tue, 5 Jan 2021 20:30:10 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net 6/7] chtls: Added a check to avoid NULL pointer dereference
Date:   Wed,  6 Jan 2021 09:59:11 +0530
Message-Id: <20210106042912.23512-7-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
In-Reply-To: <20210106042912.23512-1-ayush.sawal@chelsio.com>
References: <20210106042912.23512-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of server removal lookup_stid() may return NULL pointer, which
is used as listen_ctx. So added a check before accessing this pointer.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index ff3969a24d74..1c6d3c93a0c8 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1597,6 +1597,11 @@ static int chtls_pass_establish(struct chtls_dev *cdev, struct sk_buff *skb)
 			sk_wake_async(sk, 0, POLL_OUT);
 
 		data = lookup_stid(cdev->tids, stid);
+		if (!data) {
+			/* listening server close */
+			kfree_skb(skb);
+			goto unlock;
+		}
 		lsk = ((struct listen_ctx *)data)->lsk;
 
 		bh_lock_sock(lsk);
-- 
2.28.0.rc1.6.gae46588


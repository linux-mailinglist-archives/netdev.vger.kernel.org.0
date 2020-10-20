Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFDA2926B3
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgJSLv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:51:28 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:29923 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgJSLvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:51:25 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09JBoo1f003914;
        Mon, 19 Oct 2020 04:51:19 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Venkatesh Ellapu <venkatesh.e@chelsio.com>
Subject: [PATCH net 2/6] chelsio/chtls: correct netdevice for vlan interface
Date:   Mon, 19 Oct 2020 17:20:21 +0530
Message-Id: <20201019115025.24233-3-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201019115025.24233-1-vinay.yadav@chelsio.com>
References: <20201019115025.24233-1-vinay.yadav@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check if netdevice is a vlan interface and find real vlan netdevice.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Venkatesh Ellapu <venkatesh.e@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 05520dccd906..2f9eceaf706d 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1157,6 +1157,9 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	ndev = n->dev;
 	if (!ndev)
 		goto free_dst;
+	if (is_vlan_dev(ndev))
+		ndev = vlan_dev_real_dev(ndev);
+
 	port_id = cxgb4_port_idx(ndev);
 
 	csk = chtls_sock_create(cdev);
-- 
2.18.1


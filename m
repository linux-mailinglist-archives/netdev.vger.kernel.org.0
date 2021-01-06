Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827EF2EB8F7
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 05:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbhAFEar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 23:30:47 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:46673 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbhAFEar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 23:30:47 -0500
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 1064TfXf022094;
        Tue, 5 Jan 2021 20:29:56 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net 3/7] chtls: Fix panic when route to peer not configured
Date:   Wed,  6 Jan 2021 09:59:08 +0530
Message-Id: <20210106042912.23512-4-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
In-Reply-To: <20210106042912.23512-1-ayush.sawal@chelsio.com>
References: <20210106042912.23512-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If route to peer is not configured, we might get non tls
devices from dst_neigh_lookup() which is invalid, adding a
check to avoid it.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 .../chelsio/inline_crypto/chtls/chtls_cm.c         | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 431d1e3844ab..04a8bd5af3b9 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1109,6 +1109,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 				    const struct cpl_pass_accept_req *req,
 				    struct chtls_dev *cdev)
 {
+	struct adapter *adap = pci_get_drvdata(cdev->pdev);
 	struct neighbour *n = NULL;
 	struct inet_sock *newinet;
 	const struct iphdr *iph;
@@ -1118,9 +1119,10 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	struct dst_entry *dst;
 	struct tcp_sock *tp;
 	struct sock *newsk;
+	bool found = false;
 	u16 port_id;
 	int rxq_idx;
-	int step;
+	int step, i;
 
 	iph = (const struct iphdr *)network_hdr;
 	newsk = tcp_create_openreq_child(lsk, oreq, cdev->askb);
@@ -1152,7 +1154,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 		n = dst_neigh_lookup(dst, &ip6h->saddr);
 #endif
 	}
-	if (!n)
+	if (!n || !n->dev)
 		goto free_sk;
 
 	ndev = n->dev;
@@ -1161,6 +1163,13 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	if (is_vlan_dev(ndev))
 		ndev = vlan_dev_real_dev(ndev);
 
+	for_each_port(adap, i)
+		if (cdev->ports[i] == ndev)
+			found = true;
+
+	if (!found)
+		goto free_dst;
+
 	port_id = cxgb4_port_idx(ndev);
 
 	csk = chtls_sock_create(cdev);
@@ -1238,6 +1247,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 free_csk:
 	chtls_sock_release(&csk->kref);
 free_dst:
+	neigh_release(n);
 	dst_release(dst);
 free_sk:
 	inet_csk_prepare_forced_close(newsk);
-- 
2.28.0.rc1.6.gae46588


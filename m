Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8FB2926B5
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgJSLvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:51:36 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:51867 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgJSLvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:51:36 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09JBoo1h003914;
        Mon, 19 Oct 2020 04:51:30 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Venkatesh Ellapu <venkatesh.e@chelsio.com>
Subject: [PATCH net 4/6] chelsio/chtls: Fix panic when listen on multiadapter
Date:   Mon, 19 Oct 2020 17:20:23 +0530
Message-Id: <20201019115025.24233-5-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201019115025.24233-1-vinay.yadav@chelsio.com>
References: <20201019115025.24233-1-vinay.yadav@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the logic to compare net_device returned by ip_dev_find()
with the net_device list in cdev->ports[] array and return
net_device if matched else NULL.

Fixes: 6abde0b24122 ("crypto/chtls: IPv6 support for inline TLS")
Signed-off-by: Venkatesh Ellapu <venkatesh.e@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 .../ethernet/chelsio/inline_crypto/chtls/chtls_cm.c    | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index e46228ca49ad..bdb53fa41022 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -92,11 +92,13 @@ static void chtls_sock_release(struct kref *ref)
 static struct net_device *chtls_find_netdev(struct chtls_dev *cdev,
 					    struct sock *sk)
 {
+	struct adapter *adap = pci_get_drvdata(cdev->pdev);
 	struct net_device *ndev = cdev->ports[0];
 #if IS_ENABLED(CONFIG_IPV6)
 	struct net_device *temp;
 	int addr_type;
 #endif
+	int i;
 
 	switch (sk->sk_family) {
 	case PF_INET:
@@ -127,8 +129,12 @@ static struct net_device *chtls_find_netdev(struct chtls_dev *cdev,
 		return NULL;
 
 	if (is_vlan_dev(ndev))
-		return vlan_dev_real_dev(ndev);
-	return ndev;
+		ndev = vlan_dev_real_dev(ndev);
+
+	for_each_port(adap, i)
+		if (cdev->ports[i] == ndev)
+			return ndev;
+	return NULL;
 }
 
 static void assign_rxopt(struct sock *sk, unsigned int opt)
-- 
2.18.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B3721DFD1
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGMSg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:36:57 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:30619 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgGMSg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:36:57 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06DIa8xR004006;
        Mon, 13 Jul 2020 11:36:53 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next 1/3] crypto/chtls: correct net_device reference count
Date:   Tue, 14 Jul 2020 00:05:53 +0530
Message-Id: <20200713183554.11719-2-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200713183554.11719-1-vinay.yadav@chelsio.com>
References: <20200713183554.11719-1-vinay.yadav@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Release net_device reference hold by ip_dev_find().

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index f200fae6f..eedad8caa 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -95,6 +95,7 @@ static struct net_device *chtls_find_netdev(struct chtls_dev *cdev,
 	struct net_device *ndev = cdev->ports[0];
 #if IS_ENABLED(CONFIG_IPV6)
 	struct net_device *temp;
+	bool put = false;
 	int addr_type;
 #endif
 
@@ -103,6 +104,7 @@ static struct net_device *chtls_find_netdev(struct chtls_dev *cdev,
 		if (likely(!inet_sk(sk)->inet_rcv_saddr))
 			return ndev;
 		ndev = ip_dev_find(&init_net, inet_sk(sk)->inet_rcv_saddr);
+		put = true;
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case PF_INET6:
@@ -126,6 +128,9 @@ static struct net_device *chtls_find_netdev(struct chtls_dev *cdev,
 	if (!ndev)
 		return NULL;
 
+	if (put)
+		dev_put(ndev);
+
 	if (is_vlan_dev(ndev))
 		return vlan_dev_real_dev(ndev);
 	return ndev;
-- 
2.18.1


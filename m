Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2777E393A22
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 02:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhE1ARk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 20:17:40 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2378 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbhE1AR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 20:17:28 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FrlVl00C4z65nt;
        Fri, 28 May 2021 08:12:14 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 08:15:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 08:15:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 05/10] net: hdlc_fr: move out assignment in if condition
Date:   Fri, 28 May 2021 08:12:44 +0800
Message-ID: <1622160769-6678-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622160769-6678-1-git-send-email-huangguangbin2@huawei.com>
References: <1622160769-6678-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Should not use assignment in if condition.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_fr.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 512ef79..a39e508 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -937,7 +937,8 @@ static int fr_rx(struct sk_buff *skb)
 		pvc->state.becn ^= 1;
 	}
 
-	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL) {
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb) {
 		frad->stats.rx_dropped++;
 		return NET_RX_DROP;
 	}
@@ -1064,7 +1065,8 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 	struct net_device *dev;
 	int used;
 
-	if ((pvc = add_pvc(frad, dlci)) == NULL) {
+	pvc = add_pvc(frad, dlci);
+	if (!pvc) {
 		netdev_warn(frad, "Memory squeeze on fr_add_pvc()\n");
 		return -ENOBUFS;
 	}
@@ -1121,10 +1123,12 @@ static int fr_del_pvc(hdlc_device *hdlc, unsigned int dlci, int type)
 	struct pvc_device *pvc;
 	struct net_device *dev;
 
-	if ((pvc = find_pvc(hdlc, dlci)) == NULL)
+	pvc = find_pvc(hdlc, dlci);
+	if (!pvc)
 		return -ENOENT;
 
-	if ((dev = *get_dev_p(pvc, type)) == NULL)
+	dev = *get_dev_p(pvc, type);
+	if (!dev)
 		return -ENOENT;
 
 	if (dev->flags & IFF_UP)
-- 
2.8.1


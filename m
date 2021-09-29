Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5C741C909
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345845AbhI2QA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:58 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13839 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345423AbhI2P7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:46 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWT21Fgz8yrZ;
        Wed, 29 Sep 2021 23:53:25 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:02 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 053/167] net: decnet: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:40 +0800
Message-ID: <20210929155334.12454-54-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/decnet/af_decnet.c  | 2 +-
 net/decnet/dn_nsp_out.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index dc92a67baea3..83138e013c46 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -949,7 +949,7 @@ static int __dn_connect(struct sock *sk, struct sockaddr_dn *addr, int addrlen,
 	if (dn_route_output_sock(&sk->sk_dst_cache, &fld, sk, flags) < 0)
 		goto out;
 	dst = __sk_dst_get(sk);
-	sk->sk_route_caps = dst->dev->features;
+	netdev_feature_copy(&sk->sk_route_caps, dst->dev->features);
 	sock->state = SS_CONNECTING;
 	scp->state = DN_CI;
 	scp->segsize_loc = dst_metric_advmss(dst);
diff --git a/net/decnet/dn_nsp_out.c b/net/decnet/dn_nsp_out.c
index eadc89583168..613e81bb6ed8 100644
--- a/net/decnet/dn_nsp_out.c
+++ b/net/decnet/dn_nsp_out.c
@@ -89,7 +89,7 @@ static void dn_nsp_send(struct sk_buff *skb)
 	fld.flowidn_proto = DNPROTO_NSP;
 	if (dn_route_output_sock(&sk->sk_dst_cache, &fld, sk, 0) == 0) {
 		dst = sk_dst_get(sk);
-		sk->sk_route_caps = dst->dev->features;
+		netdev_feature_copy(&sk->sk_route_caps, dst->dev->features);
 		goto try_again;
 	}
 
-- 
2.33.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B303D8A4D
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhG1JKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:10:20 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:12326 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbhG1JKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 05:10:20 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GZSRx3X6Cz7ys9;
        Wed, 28 Jul 2021 17:05:33 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 17:10:16 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 28 Jul
 2021 17:10:16 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <simon.horman@corigine.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, <louis.peens@corigine.com>,
        <yinjun.zhang@corigine.com>
Subject: [PATCH net-next] nfp: flower-ct: fix error return code in nfp_fl_ct_add_offload()
Date:   Wed, 28 Jul 2021 17:16:31 +0800
Message-ID: <20210728091631.2421865-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If nfp_tunnel_add_ipv6_off() fails, it should return error code
in nfp_fl_ct_add_offload().

Fixes: 5a2b93041646 ("nfp: flower-ct: compile match sections of flow_payload")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/netronome/nfp/flower/conntrack.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 1ac3b65df600..bfd7d1c35076 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -710,8 +710,10 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 			dst = &gre_match->ipv6.dst;
 
 			entry = nfp_tunnel_add_ipv6_off(priv->app, dst);
-			if (!entry)
+			if (!entry) {
+				err = -ENOMEM;
 				goto ct_offload_err;
+			}
 
 			flow_pay->nfp_tun_ipv6 = entry;
 		} else {
@@ -760,8 +762,10 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 			dst = &udp_match->ipv6.dst;
 
 			entry = nfp_tunnel_add_ipv6_off(priv->app, dst);
-			if (!entry)
+			if (!entry) {
+				err = -ENOMEM;
 				goto ct_offload_err;
+			}
 
 			flow_pay->nfp_tun_ipv6 = entry;
 		} else {
-- 
2.25.1


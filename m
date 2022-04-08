Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5334F8F5C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 09:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiDHHUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 03:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiDHHU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 03:20:28 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1662421FF50;
        Fri,  8 Apr 2022 00:18:25 -0700 (PDT)
Received: from kwepemi500005.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KZV2V04KlzdZm7;
        Fri,  8 Apr 2022 15:17:53 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500005.china.huawei.com (7.221.188.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Apr 2022 15:18:23 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 8 Apr 2022 15:18:22 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>, <wangjie125@huawei.com>
Subject: [PATCH net-next 2/3] net: ethtool: move checks before rtnl_lock() in ethnl_set_rings
Date:   Fri, 8 Apr 2022 15:12:44 +0800
Message-ID: <20220408071245.40554-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220408071245.40554-1-huangguangbin2@huawei.com>
References: <20220408071245.40554-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently these two checks in ethnl_set_rings are added after rtnl_lock()
which will do useless works if the request is invalid.

So this patch moves these checks before the rtnl_lock() to avoid these
costs.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 net/ethtool/rings.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 9ed60c507d97..46415d8fc256 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -152,6 +152,26 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 	if (!ops->get_ringparam || !ops->set_ringparam)
 		goto out_dev;
 
+	if (tb[ETHTOOL_A_RINGS_RX_BUF_LEN] &&
+	    nla_get_u32(tb[ETHTOOL_A_RINGS_RX_BUF_LEN]) != 0 &&
+	    !(ops->supported_ring_params & ETHTOOL_RING_USE_RX_BUF_LEN)) {
+		ret = -EOPNOTSUPP;
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_RINGS_RX_BUF_LEN],
+				    "setting rx buf len not supported");
+		goto out_dev;
+	}
+
+	if (tb[ETHTOOL_A_RINGS_CQE_SIZE] &&
+	    nla_get_u32(tb[ETHTOOL_A_RINGS_CQE_SIZE]) &&
+	    !(ops->supported_ring_params & ETHTOOL_RING_USE_CQE_SIZE)) {
+		ret = -EOPNOTSUPP;
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_RINGS_CQE_SIZE],
+				    "setting cqe size not supported");
+		goto out_dev;
+	}
+
 	if (tb[ETHTOOL_A_RINGS_TX_PUSH] &&
 	    !(ops->supported_ring_params & ETHTOOL_RING_USE_TX_PUSH)) {
 		ret = -EOPNOTSUPP;
@@ -201,24 +221,6 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 	}
 
-	if (kernel_ringparam.rx_buf_len != 0 &&
-	    !(ops->supported_ring_params & ETHTOOL_RING_USE_RX_BUF_LEN)) {
-		ret = -EOPNOTSUPP;
-		NL_SET_ERR_MSG_ATTR(info->extack,
-				    tb[ETHTOOL_A_RINGS_RX_BUF_LEN],
-				    "setting rx buf len not supported");
-		goto out_ops;
-	}
-
-	if (kernel_ringparam.cqe_size &&
-	    !(ops->supported_ring_params & ETHTOOL_RING_USE_CQE_SIZE)) {
-		ret = -EOPNOTSUPP;
-		NL_SET_ERR_MSG_ATTR(info->extack,
-				    tb[ETHTOOL_A_RINGS_CQE_SIZE],
-				    "setting cqe size not supported");
-		goto out_ops;
-	}
-
 	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam,
 					      &kernel_ringparam, info->extack);
 	if (ret < 0)
-- 
2.33.0


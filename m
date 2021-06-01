Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495813974CA
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhFAOCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:02:04 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2827 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbhFAOCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:02:03 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvYZx5qM9zWnHw;
        Tue,  1 Jun 2021 21:55:37 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 22:00:18 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: dcb: Return the correct errno code
Date:   Tue, 1 Jun 2021 22:13:58 +0800
Message-ID: <20210601141358.4131155-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/dcb/dcbnl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 653e3bc9c87b..7352ff6133c1 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1381,7 +1381,7 @@ static int dcbnl_notify(struct net_device *dev, int event, int cmd,
 
 	skb = dcbnl_newmsg(event, cmd, portid, seq, 0, &nlh);
 	if (!skb)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	if (dcbx_ver == DCB_CAP_DCBX_VER_IEEE)
 		err = dcbnl_ieee_fill(skb, dev);
@@ -1781,7 +1781,7 @@ static int dcb_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	reply_skb = dcbnl_newmsg(fn->type, dcb->cmd, portid, nlh->nlmsg_seq,
 				 nlh->nlmsg_flags, &reply_nlh);
 	if (!reply_skb)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	ret = fn->cb(netdev, nlh, nlh->nlmsg_seq, tb, reply_skb);
 	if (ret < 0) {
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C284C3AAE3D
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 09:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhFQIA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 04:00:29 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8250 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhFQIA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 04:00:28 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G5DnQ0Y1Nz1BNTK;
        Thu, 17 Jun 2021 15:53:14 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 15:58:15 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 17 Jun
 2021 15:58:15 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next] net: sched: fix error return code in tcf_del_walker()
Date:   Thu, 17 Jun 2021 16:02:07 +0800
Message-ID: <20210617080207.1346017-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When nla_put_u32() fails, 'ret' could be 0, it should
return error code in tcf_del_walker().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/sched/act_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f6d5755d669e..d17a66aab8ee 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -381,7 +381,8 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	}
 	mutex_unlock(&idrinfo->lock);
 
-	if (nla_put_u32(skb, TCA_FCNT, n_i))
+	ret = nla_put_u32(skb, TCA_FCNT, n_i);
+	if (ret)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 
-- 
2.25.1


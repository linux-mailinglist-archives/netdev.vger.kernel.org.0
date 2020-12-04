Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DC12CEA19
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 09:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbgLDIpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 03:45:38 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8944 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgLDIph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 03:45:37 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CnR8L6NBFzhmNg;
        Fri,  4 Dec 2020 16:44:18 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 4 Dec 2020 16:44:34 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] ipv4: fix error return code in rtm_to_fib_config()
Date:   Fri, 4 Dec 2020 16:48:14 +0800
Message-ID: <1607071695-33740-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/ipv4/fib_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b87140a..cdf6ec5 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -825,7 +825,7 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 	if (has_gw && has_via) {
 		NL_SET_ERR_MSG(extack,
 			       "Nexthop configuration can not contain both GATEWAY and VIA");
-		goto errout;
+		return -EINVAL;
 	}
 
 	return 0;
-- 
2.9.5


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54B62B5700
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgKQCnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:43:31 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7691 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgKQCnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:43:31 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CZqxT0vftzkXRZ;
        Tue, 17 Nov 2020 10:43:09 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 17 Nov 2020 10:43:25 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] ah6: fix error return code in ah6_input()
Date:   Tue, 17 Nov 2020 10:45:05 +0800
Message-ID: <1605581105-35295-1-git-send-email-zhangchangzhong@huawei.com>
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

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/ipv6/ah6.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index d88d976..440080d 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -588,7 +588,8 @@ static int ah6_input(struct xfrm_state *x, struct sk_buff *skb)
 	memcpy(auth_data, ah->auth_data, ahp->icv_trunc_len);
 	memset(ah->auth_data, 0, ahp->icv_trunc_len);
 
-	if (ipv6_clear_mutable_options(ip6h, hdr_len, XFRM_POLICY_IN))
+	err = ipv6_clear_mutable_options(ip6h, hdr_len, XFRM_POLICY_IN);
+	if (err)
 		goto out_free;
 
 	ip6h->priority    = 0;
-- 
2.9.5


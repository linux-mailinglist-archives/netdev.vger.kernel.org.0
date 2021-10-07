Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67E6424CEA
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 07:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240164AbhJGF51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 01:57:27 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37692 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232427AbhJGF5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 01:57:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 00CB72056D;
        Thu,  7 Oct 2021 07:55:29 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9JZP_A_P2vyw; Thu,  7 Oct 2021 07:55:28 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DDAC720539;
        Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id CF3D080004A;
        Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 07:55:27 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 7 Oct
 2021 07:55:26 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9F69A318010D; Thu,  7 Oct 2021 07:55:26 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/5] net: xfrm: fix shift-out-of-bounds in xfrm_get_default
Date:   Thu, 7 Oct 2021 07:55:20 +0200
Message-ID: <20211007055524.319785-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007055524.319785-1-steffen.klassert@secunet.com>
References: <20211007055524.319785-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

Syzbot hit shift-out-of-bounds in xfrm_get_default. The problem was in
missing validation check for user data.

up->dirmask comes from user-space, so we need to check if this value
is less than XFRM_USERPOLICY_DIRMASK_MAX to avoid shift-out-of-bounds bugs.

Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Reported-and-tested-by: syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 03b66d154b2b..4719a6d54aa6 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2005,6 +2005,11 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EMSGSIZE;
 	}
 
+	if (up->dirmask >= XFRM_USERPOLICY_DIRMASK_MAX) {
+		kfree_skb(r_skb);
+		return -EINVAL;
+	}
+
 	r_up = nlmsg_data(r_nlh);
 
 	r_up->action = ((net->xfrm.policy_default & (1 << up->dirmask)) >> up->dirmask);
-- 
2.25.1


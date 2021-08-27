Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B193F957A
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 09:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244510AbhH0HvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 03:51:13 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41150 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244480AbhH0HvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 03:51:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 16D902049A;
        Fri, 27 Aug 2021 09:50:22 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zzlQuVotui2M; Fri, 27 Aug 2021 09:50:18 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6C827205A6;
        Fri, 27 Aug 2021 09:50:18 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 5E15180004A;
        Fri, 27 Aug 2021 09:50:18 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 09:50:18 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 27 Aug
 2021 09:50:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B13A53180727; Fri, 27 Aug 2021 09:50:17 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/3] net: xfrm: fix shift-out-of-bounce
Date:   Fri, 27 Aug 2021 09:50:15 +0200
Message-ID: <20210827075015.2584560-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210827075015.2584560-1-steffen.klassert@secunet.com>
References: <20210827075015.2584560-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

We need to check up->dirmask to avoid shift-out-of-bounce bug,
since up->dirmask comes from userspace.

Also, added XFRM_USERPOLICY_DIRMASK_MAX constant to uapi to inform
user-space that up->dirmask has maximum possible value

Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Reported-and-tested-by: syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/uapi/linux/xfrm.h | 1 +
 net/xfrm/xfrm_user.c      | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 6e8095106192..b96c1ea7166d 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -514,6 +514,7 @@ struct xfrm_user_offload {
 #define XFRM_OFFLOAD_INBOUND	2
 
 struct xfrm_userpolicy_default {
+#define XFRM_USERPOLICY_DIRMASK_MAX	(sizeof(__u8) * 8)
 	__u8				dirmask;
 	__u8				action;
 };
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 4eafd1130c3e..127c99f71c99 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1966,9 +1966,14 @@ static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
-	u8 dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK;
+	u8 dirmask;
 	u8 old_default = net->xfrm.policy_default;
 
+	if (up->dirmask >= XFRM_USERPOLICY_DIRMASK_MAX)
+		return -EINVAL;
+
+	dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK;
+
 	net->xfrm.policy_default = (old_default & (0xff ^ dirmask))
 				    | (up->action << up->dirmask);
 
-- 
2.25.1


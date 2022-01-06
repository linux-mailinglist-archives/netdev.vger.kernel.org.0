Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFFF486231
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237469AbiAFJgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:36:19 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:38800 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237435AbiAFJgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 04:36:18 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9D23A20627;
        Thu,  6 Jan 2022 10:36:17 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id upc_6inAZskw; Thu,  6 Jan 2022 10:36:17 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1822B2063F;
        Thu,  6 Jan 2022 10:36:13 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 098DC80004A;
        Thu,  6 Jan 2022 10:36:13 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 6 Jan 2022 10:36:12 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 10:36:12 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 1CDBE3183032; Thu,  6 Jan 2022 10:36:09 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/6] xfrm: state and policy should fail if XFRMA_IF_ID 0
Date:   Thu, 6 Jan 2022 10:36:05 +0100
Message-ID: <20220106093606.3046771-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106093606.3046771-1-steffen.klassert@secunet.com>
References: <20220106093606.3046771-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

xfrm ineterface does not allow xfrm if_id = 0
fail to create or update xfrm state and policy.

With this commit:
 ip xfrm policy add src 192.0.2.1 dst 192.0.2.2 dir out if_id 0
 RTNETLINK answers: Invalid argument

 ip xfrm state add src 192.0.2.1 dst 192.0.2.2 proto esp spi 1 \
            reqid 1 mode tunnel aead 'rfc4106(gcm(aes))' \
            0x1111111111111111111111111111111111111111 96 if_id 0
 RTNETLINK answers: Invalid argument

v1->v2 change:
 - add Fixes: tag

Fixes: 9f8550e4bd9d ("xfrm: fix disable_xfrm sysctl when used on xfrm interfaces")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 0a2d2bae2831..b571892fe10f 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -621,8 +621,13 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 
 	xfrm_smark_init(attrs, &x->props.smark);
 
-	if (attrs[XFRMA_IF_ID])
+	if (attrs[XFRMA_IF_ID]) {
 		x->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
+		if (!x->if_id) {
+			err = -EINVAL;
+			goto error;
+		}
+	}
 
 	err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV]);
 	if (err)
@@ -1413,8 +1418,13 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	mark = xfrm_mark_get(attrs, &m);
 
-	if (attrs[XFRMA_IF_ID])
+	if (attrs[XFRMA_IF_ID]) {
 		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
+		if (!if_id) {
+			err = -EINVAL;
+			goto out_noput;
+		}
+	}
 
 	if (p->info.seq) {
 		x = xfrm_find_acq_byseq(net, mark, p->info.seq);
@@ -1727,8 +1737,13 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 
 	xfrm_mark_get(attrs, &xp->mark);
 
-	if (attrs[XFRMA_IF_ID])
+	if (attrs[XFRMA_IF_ID]) {
 		xp->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
+		if (!xp->if_id) {
+			err = -EINVAL;
+			goto error;
+		}
+	}
 
 	return xp;
  error:
-- 
2.25.1


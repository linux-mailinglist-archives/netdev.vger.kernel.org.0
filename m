Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6DE46EBE6
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240271AbhLIPmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:42:10 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:54424 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240836AbhLIPld (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 10:41:33 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 55F8E204E0;
        Thu,  9 Dec 2021 16:37:58 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id m1Y7_G3wzJhZ; Thu,  9 Dec 2021 16:37:57 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B7F6F2019D;
        Thu,  9 Dec 2021 16:37:57 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id A8AAB80004A;
        Thu,  9 Dec 2021 16:37:57 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 9 Dec 2021 16:37:57 +0100
Received: from moon.secunet.de (172.18.149.1) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 9 Dec
 2021 16:37:56 +0100
Date:   Thu, 9 Dec 2021 16:37:50 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Eyal Birger <eyal.birger@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Antony Antony <antony.antony@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 2/2] xfrm: state and policy should fail if XFRMA_IF_ID 0
Message-ID: <7b0d10bb577794138b97fe365ba0cc0bdce6f057.1639064232.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
References: <0bfebd4e5f317cbf301750d5dd5cc706d4385d7f.1639064232.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0bfebd4e5f317cbf301750d5dd5cc706d4385d7f.1639064232.git.antony.antony@secunet.com>
Organization: secunet
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm ineterface does not allow xfrm if_id = 0
fail to create or update xfrm state and policy.

With this commit:
 ip xfrm policy add src 192.0.2.1 dst 192.0.2.2 dir out if_id 0
 RTNETLINK answers: Invalid argument

 ip xfrm state add src 192.0.2.1 dst 192.0.2.2 proto esp spi 1 \
            reqid 1 mode tunnel aead 'rfc4106(gcm(aes))' \
            0x1111111111111111111111111111111111111111 96 if_id 0
 RTNETLINK answers: Invalid argument

Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 net/xfrm/xfrm_user.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 064f91cd2f01..3e5fb1648be3 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -626,8 +626,13 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 
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
@@ -1418,8 +1423,13 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 
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
@@ -1732,8 +1742,13 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 
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
2.30.2


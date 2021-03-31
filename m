Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159B234FB6F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhCaITn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:19:43 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48056 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234392AbhCaIS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 04:18:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0CBF22057E;
        Wed, 31 Mar 2021 10:18:57 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1Kk-2AxKzxuW; Wed, 31 Mar 2021 10:18:56 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 33905205B5;
        Wed, 31 Mar 2021 10:18:55 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 31 Mar 2021 10:18:55 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 31 Mar
 2021 10:18:53 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AFDA43180695; Wed, 31 Mar 2021 10:18:52 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 11/11] xfrm/compat: Cleanup WARN()s that can be user-triggered
Date:   Wed, 31 Mar 2021 10:18:47 +0200
Message-ID: <20210331081847.3547641-12-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331081847.3547641-1-steffen.klassert@secunet.com>
References: <20210331081847.3547641-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

Replace WARN_ONCE() that can be triggered from userspace with
pr_warn_once(). Those still give user a hint what's the issue.

I've left WARN()s that are not possible to trigger with current
code-base and that would mean that the code has issues:
- relying on current compat_msg_min[type] <= xfrm_msg_min[type]
- expected 4-byte padding size difference between
  compat_msg_min[type] and xfrm_msg_min[type]
- compat_policy[type].len <= xfrma_policy[type].len
(for every type)

Reported-by: syzbot+834ffd1afc7212eb8147@syzkaller.appspotmail.com
Fixes: 5f3eea6b7e8f ("xfrm/compat: Attach xfrm dumps to 64=>32 bit translator")
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_compat.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index d8e8a11ca845..a20aec9d7393 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -216,7 +216,7 @@ static struct nlmsghdr *xfrm_nlmsg_put_compat(struct sk_buff *skb,
 	case XFRM_MSG_GETSADINFO:
 	case XFRM_MSG_GETSPDINFO:
 	default:
-		WARN_ONCE(1, "unsupported nlmsg_type %d", nlh_src->nlmsg_type);
+		pr_warn_once("unsupported nlmsg_type %d\n", nlh_src->nlmsg_type);
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
@@ -277,7 +277,7 @@ static int xfrm_xlate64_attr(struct sk_buff *dst, const struct nlattr *src)
 		return xfrm_nla_cpy(dst, src, nla_len(src));
 	default:
 		BUILD_BUG_ON(XFRMA_MAX != XFRMA_IF_ID);
-		WARN_ONCE(1, "unsupported nla_type %d", src->nla_type);
+		pr_warn_once("unsupported nla_type %d\n", src->nla_type);
 		return -EOPNOTSUPP;
 	}
 }
@@ -315,8 +315,10 @@ static int xfrm_alloc_compat(struct sk_buff *skb, const struct nlmsghdr *nlh_src
 	struct sk_buff *new = NULL;
 	int err;
 
-	if (WARN_ON_ONCE(type >= ARRAY_SIZE(xfrm_msg_min)))
+	if (type >= ARRAY_SIZE(xfrm_msg_min)) {
+		pr_warn_once("unsupported nlmsg_type %d\n", nlh_src->nlmsg_type);
 		return -EOPNOTSUPP;
+	}
 
 	if (skb_shinfo(skb)->frag_list == NULL) {
 		new = alloc_skb(skb->len + skb_tailroom(skb), GFP_ATOMIC);
@@ -378,6 +380,10 @@ static int xfrm_attr_cpy32(void *dst, size_t *pos, const struct nlattr *src,
 	struct nlmsghdr *nlmsg = dst;
 	struct nlattr *nla;
 
+	/* xfrm_user_rcv_msg_compat() relies on fact that 32-bit messages
+	 * have the same len or shorted than 64-bit ones.
+	 * 32-bit translation that is bigger than 64-bit original is unexpected.
+	 */
 	if (WARN_ON_ONCE(copy_len > payload))
 		copy_len = payload;
 
-- 
2.25.1


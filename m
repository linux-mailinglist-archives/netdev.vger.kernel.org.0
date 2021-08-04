Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE213DFBAD
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbhHDHDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:03:53 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41858 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235723AbhHDHDq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 03:03:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 833A320534;
        Wed,  4 Aug 2021 09:03:33 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nB0TtGpQpH5j; Wed,  4 Aug 2021 09:03:32 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 41273205DD;
        Wed,  4 Aug 2021 09:03:32 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 38B2880004A;
        Wed,  4 Aug 2021 09:03:32 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 09:03:32 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 4 Aug 2021
 09:03:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 15BF4318095E; Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/6] net/xfrm/compat: Copy xfrm_spdattr_type_t atributes
Date:   Wed, 4 Aug 2021 09:03:27 +0200
Message-ID: <20210804070329.1357123-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804070329.1357123-1-steffen.klassert@secunet.com>
References: <20210804070329.1357123-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

The attribute-translator has to take in mind maxtype, that is
xfrm_link::nla_max. When it is set, attributes are not of xfrm_attr_type_t.
Currently, they can be only XFRMA_SPD_MAX (message XFRM_MSG_NEWSPDINFO),
their UABI is the same for 64/32-bit, so just copy them.

Thanks to YueHaibing for reporting this:
In xfrm_user_rcv_msg_compat() if maxtype is not zero and less than
XFRMA_MAX, nlmsg_parse_deprecated() do not initialize attrs array fully.
xfrm_xlate32() will access uninit 'attrs[i]' while iterating all attrs
array.

KASAN: probably user-memory-access in range [0x0000000041b58ab0-0x0000000041b58ab7]
CPU: 0 PID: 15799 Comm: syz-executor.2 Tainted: G        W         5.14.0-rc1-syzkaller #0
RIP: 0010:nla_type include/net/netlink.h:1130 [inline]
RIP: 0010:xfrm_xlate32_attr net/xfrm/xfrm_compat.c:410 [inline]
RIP: 0010:xfrm_xlate32 net/xfrm/xfrm_compat.c:532 [inline]
RIP: 0010:xfrm_user_rcv_msg_compat+0x5e5/0x1070 net/xfrm/xfrm_compat.c:577
[...]
Call Trace:
 xfrm_user_rcv_msg+0x556/0x8b0 net/xfrm/xfrm_user.c:2774
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2824
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:702 [inline]

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Cc: <stable@kernel.org>
Reported-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_compat.c | 49 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index a20aec9d7393..2bf269390163 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -298,8 +298,16 @@ static int xfrm_xlate64(struct sk_buff *dst, const struct nlmsghdr *nlh_src)
 	len = nlmsg_attrlen(nlh_src, xfrm_msg_min[type]);
 
 	nla_for_each_attr(nla, attrs, len, remaining) {
-		int err = xfrm_xlate64_attr(dst, nla);
+		int err;
 
+		switch (type) {
+		case XFRM_MSG_NEWSPDINFO:
+			err = xfrm_nla_cpy(dst, nla, nla_len(nla));
+			break;
+		default:
+			err = xfrm_xlate64_attr(dst, nla);
+			break;
+		}
 		if (err)
 			return err;
 	}
@@ -341,7 +349,8 @@ static int xfrm_alloc_compat(struct sk_buff *skb, const struct nlmsghdr *nlh_src
 
 /* Calculates len of translated 64-bit message. */
 static size_t xfrm_user_rcv_calculate_len64(const struct nlmsghdr *src,
-					    struct nlattr *attrs[XFRMA_MAX+1])
+					    struct nlattr *attrs[XFRMA_MAX + 1],
+					    int maxtype)
 {
 	size_t len = nlmsg_len(src);
 
@@ -358,10 +367,20 @@ static size_t xfrm_user_rcv_calculate_len64(const struct nlmsghdr *src,
 	case XFRM_MSG_POLEXPIRE:
 		len += 8;
 		break;
+	case XFRM_MSG_NEWSPDINFO:
+		/* attirbutes are xfrm_spdattr_type_t, not xfrm_attr_type_t */
+		return len;
 	default:
 		break;
 	}
 
+	/* Unexpected for anything, but XFRM_MSG_NEWSPDINFO, please
+	 * correct both 64=>32-bit and 32=>64-bit translators to copy
+	 * new attributes.
+	 */
+	if (WARN_ON_ONCE(maxtype))
+		return len;
+
 	if (attrs[XFRMA_SA])
 		len += 4;
 	if (attrs[XFRMA_POLICY])
@@ -440,7 +459,8 @@ static int xfrm_xlate32_attr(void *dst, const struct nlattr *nla,
 
 static int xfrm_xlate32(struct nlmsghdr *dst, const struct nlmsghdr *src,
 			struct nlattr *attrs[XFRMA_MAX+1],
-			size_t size, u8 type, struct netlink_ext_ack *extack)
+			size_t size, u8 type, int maxtype,
+			struct netlink_ext_ack *extack)
 {
 	size_t pos;
 	int i;
@@ -520,6 +540,25 @@ static int xfrm_xlate32(struct nlmsghdr *dst, const struct nlmsghdr *src,
 	}
 	pos = dst->nlmsg_len;
 
+	if (maxtype) {
+		/* attirbutes are xfrm_spdattr_type_t, not xfrm_attr_type_t */
+		WARN_ON_ONCE(src->nlmsg_type != XFRM_MSG_NEWSPDINFO);
+
+		for (i = 1; i <= maxtype; i++) {
+			int err;
+
+			if (!attrs[i])
+				continue;
+
+			/* just copy - no need for translation */
+			err = xfrm_attr_cpy32(dst, &pos, attrs[i], size,
+					nla_len(attrs[i]), nla_len(attrs[i]));
+			if (err)
+				return err;
+		}
+		return 0;
+	}
+
 	for (i = 1; i < XFRMA_MAX + 1; i++) {
 		int err;
 
@@ -564,7 +603,7 @@ static struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
 	if (err < 0)
 		return ERR_PTR(err);
 
-	len = xfrm_user_rcv_calculate_len64(h32, attrs);
+	len = xfrm_user_rcv_calculate_len64(h32, attrs, maxtype);
 	/* The message doesn't need translation */
 	if (len == nlmsg_len(h32))
 		return NULL;
@@ -574,7 +613,7 @@ static struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
 	if (!h64)
 		return ERR_PTR(-ENOMEM);
 
-	err = xfrm_xlate32(h64, h32, attrs, len, type, extack);
+	err = xfrm_xlate32(h64, h32, attrs, len, type, maxtype, extack);
 	if (err < 0) {
 		kvfree(h64);
 		return ERR_PTR(err);
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1508A280CF9
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 07:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgJBFB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 01:01:27 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41906 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgJBFB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 01:01:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9AEE020512;
        Fri,  2 Oct 2020 07:01:24 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OBgqMz0tbkQy; Fri,  2 Oct 2020 07:01:24 +0200 (CEST)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1471A2019C;
        Fri,  2 Oct 2020 07:01:24 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 2 Oct 2020 07:01:23 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 2 Oct 2020
 07:01:23 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 51C2931843B3;
 Fri,  2 Oct 2020 07:01:23 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/7] xfrm/compat: Attach xfrm dumps to 64=>32 bit translator
Date:   Fri, 2 Oct 2020 07:01:09 +0200
Message-ID: <20201002050113.2210-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002050113.2210-1-steffen.klassert@secunet.com>
References: <20201002050113.2210-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

Currently nlmsg_unicast() is used by functions that dump structures that
can be different in size for compat tasks, see dump_one_state() and
dump_one_policy().

The following nlmsg_unicast() users exist today in xfrm:

         Function                          |    Message can be different
                                           |       in size on compat
-------------------------------------------|------------------------------
    xfrm_get_spdinfo()                     |               N
    xfrm_get_sadinfo()                     |               N
    xfrm_get_sa()                          |               Y
    xfrm_alloc_userspi()                   |               Y
    xfrm_get_policy()                      |               Y
    xfrm_get_ae()                          |               N

Besides, dump_one_state() and dump_one_policy() can be used by filtered
netlink dump for XFRM_MSG_GETSA, XFRM_MSG_GETPOLICY.

Just as for xfrm multicast, allocate frag_list for compat skb journey
down to recvmsg() which will give user the desired skb according to
syscall bitness.

Signed-off-by: Dmitry Safonov <dima@arista.com>

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 3769227ed4e1..7fd7b16a8805 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -975,6 +975,7 @@ static int dump_one_state(struct xfrm_state *x, int count, void *ptr)
 	struct xfrm_dump_info *sp = ptr;
 	struct sk_buff *in_skb = sp->in_skb;
 	struct sk_buff *skb = sp->out_skb;
+	struct xfrm_translator *xtr;
 	struct xfrm_usersa_info *p;
 	struct nlmsghdr *nlh;
 	int err;
@@ -992,6 +993,18 @@ static int dump_one_state(struct xfrm_state *x, int count, void *ptr)
 		return err;
 	}
 	nlmsg_end(skb, nlh);
+
+	xtr = xfrm_get_translator();
+	if (xtr) {
+		err = xtr->alloc_compat(skb, nlh);
+
+		xfrm_put_translator(xtr);
+		if (err) {
+			nlmsg_cancel(skb, nlh);
+			return err;
+		}
+	}
+
 	return 0;
 }
 
@@ -1320,6 +1333,7 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
 	struct xfrm_userspi_info *p;
+	struct xfrm_translator *xtr;
 	struct sk_buff *resp_skb;
 	xfrm_address_t *daddr;
 	int family;
@@ -1370,6 +1384,17 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 	}
 
+	xtr = xfrm_get_translator();
+	if (xtr) {
+		err = xtr->alloc_compat(skb, nlmsg_hdr(skb));
+
+		xfrm_put_translator(xtr);
+		if (err) {
+			kfree_skb(resp_skb);
+			goto out;
+		}
+	}
+
 	err = nlmsg_unicast(net->xfrm.nlsk, resp_skb, NETLINK_CB(skb).portid);
 
 out:
@@ -1776,6 +1801,7 @@ static int dump_one_policy(struct xfrm_policy *xp, int dir, int count, void *ptr
 	struct xfrm_userpolicy_info *p;
 	struct sk_buff *in_skb = sp->in_skb;
 	struct sk_buff *skb = sp->out_skb;
+	struct xfrm_translator *xtr;
 	struct nlmsghdr *nlh;
 	int err;
 
@@ -1800,6 +1826,18 @@ static int dump_one_policy(struct xfrm_policy *xp, int dir, int count, void *ptr
 		return err;
 	}
 	nlmsg_end(skb, nlh);
+
+	xtr = xfrm_get_translator();
+	if (xtr) {
+		err = xtr->alloc_compat(skb, nlh);
+
+		xfrm_put_translator(xtr);
+		if (err) {
+			nlmsg_cancel(skb, nlh);
+			return err;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.17.1


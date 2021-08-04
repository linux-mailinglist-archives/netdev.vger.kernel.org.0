Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95803DFBA9
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbhHDHDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:03:46 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41818 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235719AbhHDHDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 03:03:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AB062205F4;
        Wed,  4 Aug 2021 09:03:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yZ9MpJwZZq5o; Wed,  4 Aug 2021 09:03:32 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E2B28205E3;
        Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id DC9C280004A;
        Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 09:03:31 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 4 Aug 2021
 09:03:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0539A31800D1; Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/6] net: xfrm: fix memory leak in xfrm_user_rcv_msg
Date:   Wed, 4 Aug 2021 09:03:24 +0200
Message-ID: <20210804070329.1357123-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804070329.1357123-1-steffen.klassert@secunet.com>
References: <20210804070329.1357123-1-steffen.klassert@secunet.com>
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

Syzbot reported memory leak in xfrm_user_rcv_msg(). The
problem was is non-freed skb's frag_list.

In skb_release_all() skb_release_data() will be called only
in case of skb->head != NULL, but netlink_skb_destructor()
sets head to NULL. So, allocated frag_list skb should be
freed manualy, since consume_skb() won't take care of it

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Reported-and-tested-by: syzbot+fb347cf82c73a90efcca@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index b47d613409b7..7aff641c717d 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2811,6 +2811,16 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	err = link->doit(skb, nlh, attrs);
 
+	/* We need to free skb allocated in xfrm_alloc_compat() before
+	 * returning from this function, because consume_skb() won't take
+	 * care of frag_list since netlink destructor sets
+	 * sbk->head to NULL. (see netlink_skb_destructor())
+	 */
+	if (skb_has_frag_list(skb)) {
+		kfree_skb(skb_shinfo(skb)->frag_list);
+		skb_shinfo(skb)->frag_list = NULL;
+	}
+
 err:
 	kvfree(nlh64);
 	return err;
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87616021B
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfGEI1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:27:07 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36372 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbfGEI1H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:27:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E141820254;
        Fri,  5 Jul 2019 10:27:05 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AJh9Xxvrr0Cq; Fri,  5 Jul 2019 10:27:05 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6E6B9201DB;
        Fri,  5 Jul 2019 10:27:05 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:27:05 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 22F8C3180684;
 Fri,  5 Jul 2019 10:27:05 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/7] af_key: fix leaks in key_pol_get_resp and dump_sp.
Date:   Fri, 5 Jul 2019 10:26:55 +0200
Message-ID: <20190705082700.31107-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705082700.31107-1-steffen.klassert@secunet.com>
References: <20190705082700.31107-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

In both functions, if pfkey_xfrm_policy2msg failed we leaked the newly
allocated sk_buff.  Free it on error.

Fixes: 55569ce256ce ("Fix conversion between IPSEC_MODE_xxx and XFRM_MODE_xxx.")
Reported-by: syzbot+4f0529365f7f2208d9f0@syzkaller.appspotmail.com
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/key/af_key.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 4af1e1d60b9f..51c0f10bb131 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2442,8 +2442,10 @@ static int key_pol_get_resp(struct sock *sk, struct xfrm_policy *xp, const struc
 		goto out;
 	}
 	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
-	if (err < 0)
+	if (err < 0) {
+		kfree_skb(out_skb);
 		goto out;
+	}
 
 	out_hdr = (struct sadb_msg *) out_skb->data;
 	out_hdr->sadb_msg_version = hdr->sadb_msg_version;
@@ -2694,8 +2696,10 @@ static int dump_sp(struct xfrm_policy *xp, int dir, int count, void *ptr)
 		return PTR_ERR(out_skb);
 
 	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
-	if (err < 0)
+	if (err < 0) {
+		kfree_skb(out_skb);
 		return err;
+	}
 
 	out_hdr = (struct sadb_msg *) out_skb->data;
 	out_hdr->sadb_msg_version = pfk->dump.msg_version;
-- 
2.17.1


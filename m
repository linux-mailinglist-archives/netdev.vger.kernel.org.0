Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7CD32A5F2
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 20:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfEYSCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 14:02:19 -0400
Received: from kadath.azazel.net ([81.187.231.250]:56540 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEYSCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 14:02:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6NOgK7FT/we+ISsPK3hXp1mMPGNuZAXRawMukl9aF0k=; b=izNQGYOgVH4tn59Vu3GmaopMwp
        c9YcJOONT5sdFhUO/ZvtT9bU5AVwlCNuU9EuG6odqtY0G4HvMdf2NsjfgiPK5drFhnUTs4mSqVsYp
        v4A292m6dht63DNZqUAOlUL1qf+5S+IkbKpnLVsJ6Au+40sR/AlovwMdgE4iVo/E8l34APHssgFx4
        pXhUCst8uOONcrtJXq7mUhSxqdLPYupAKQDkaPSTsHRxJMP5XZT5+o3cyFKgpSIJ5iK+79RKnIHlm
        3w2DcgjmQCuKKduP570LwjHTPcHF4opgHd+RDhIJ4Rq2SllglHf5BV2eCL4epRc2IUGC//Ovij1ZY
        KOyQw7FA==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hUazc-0004dA-Ni; Sat, 25 May 2019 19:02:04 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     syzbot+4f0529365f7f2208d9f0@syzkaller.appspotmail.com
Subject: [PATCH net] af_key: fix leaks in key_pol_get_resp and dump_sp.
Date:   Sat, 25 May 2019 19:02:04 +0100
Message-Id: <20190525180204.6936-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <000000000000113abb0589b9c77c@google.com>
References: <000000000000113abb0589b9c77c@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In both functions, if pfkey_xfrm_policy2msg failed we leaked the newly
allocated sk_buff.  Free it on error.

Fixes: 55569ce256ce ("Fix conversion between IPSEC_MODE_xxx and XFRM_MODE_xxx.")
Reported-by: syzbot+4f0529365f7f2208d9f0@syzkaller.appspotmail.com
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/key/af_key.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 4af1e1d60b9f..4cca397fd032 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2442,8 +2442,10 @@ static int key_pol_get_resp(struct sock *sk, struct xfrm_policy *xp, const struc
 		goto out;
 	}
 	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
-	if (err < 0)
-		goto out;
+	if (err < 0) {
+		kfree_skb(out_skb);
+		return err;
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
2.20.1


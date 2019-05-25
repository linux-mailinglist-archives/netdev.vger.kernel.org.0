Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC1FA2A615
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 20:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfEYSKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 14:10:08 -0400
Received: from kadath.azazel.net ([81.187.231.250]:56872 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbfEYSJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 14:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qG6F8hivqd22vYumF3SNYdpcZ6QPt9V2/5v6Rmzo8JU=; b=PuWFOEqDd2dV81M0vg5L1rVvpn
        mHPYeazpAqpRu5D/6w8Eg07Sgo0L39Ua7ASm8g6X2/+QA+MrLyxZwts1Pui6EzCAZfjC6zajcCYzy
        8pcu4nOFzdaa9ofITU5h9KIR2cQnjtJptQ4p/o1VURAc+wwCP2YktYKdnvfqTzUAAG7f+eRaC1tVp
        nBP3B4TSWD4SQZP0gFMjKp+x4xVfTlPeHn+mHK1dhNL9MzEaxA9PU0TbxgfYy0k8P09KkmSlaA2/S
        fdwHr0n/5KRG4Hy5Z6w03REqYIbFckTwsGDaq2UguP5XI633gvWVz7/YuRlFCEUKt/eG93D2IsRol
        Ba3DXVcg==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hUb6t-0004k1-HM; Sat, 25 May 2019 19:09:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     syzbot+4f0529365f7f2208d9f0@syzkaller.appspotmail.com
Subject: [PATCH net v2] af_key: fix leaks in key_pol_get_resp and dump_sp.
Date:   Sat, 25 May 2019 19:09:35 +0100
Message-Id: <20190525180935.7919-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190525180204.6936-1-jeremy@azazel.net>
References: <20190525180204.6936-1-jeremy@azazel.net>
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
Since v1.

  * Changed return back to goto in key_pol_get_resp.

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
2.20.1


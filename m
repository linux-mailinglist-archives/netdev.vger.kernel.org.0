Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D04328D0D
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 20:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241032AbhCATEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 14:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240825AbhCATBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 14:01:13 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5648C061793
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 11:00:26 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id EF20C806B7;
        Tue,  2 Mar 2021 08:00:23 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1614625223;
        bh=WKHtECatzQfael+AQiWWuyJ3y/+f6zcgUcKeJWW2cbs=;
        h=From:To:Cc:Subject:Date;
        b=Wo7VoMveQJ7/MPyoV4CRwpv1OuAB39p1lx4AwAw+nKDQ4VbT2KbLBSRL80mBxWXOn
         aSmL0WvO5PFYuATYVz7YNm+UagzQUd9PNl8MPQA2t0j8uKUa5KKd9ChTAhWT/v9kTk
         v+mIKSLvBTW0DbQMwv3fiP4jjlJpojMeiOrsR/7Td1ux9WJ2B6dDCVn41J+LZLY2gi
         qZjNo0EoH3MBIUYr7SaLjo/Mo1DTQ/C9eO+3ml5UgTYzRYiZqrE6UVN+e6nXezuVxK
         f8js148C43ddT1uJeFmBCWcScVLHh/JdUVHepw0/O0+IsQZy/TJPC2bhwmgUlC/i0F
         bSAL02iQ3uxpg==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B603d39c70000>; Tue, 02 Mar 2021 08:00:23 +1300
Received: from evann-dl.ws.atlnz.lc (evann-dl.ws.atlnz.lc [10.33.23.31])
        by smtp (Postfix) with ESMTP id 586FF13EECD;
        Tue,  2 Mar 2021 08:00:34 +1300 (NZDT)
Received: by evann-dl.ws.atlnz.lc (Postfix, from userid 1780)
        id B33201A4EB7; Tue,  2 Mar 2021 08:00:23 +1300 (NZDT)
From:   Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>
Subject: [PATCH v2 1/1] xfrm: Use actual socket sk instead of skb socket for xfrm_output_resume
Date:   Tue,  2 Mar 2021 08:00:04 +1300
Message-Id: <20210301190004.9586-1-evan.nimmo@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7uXNjH+ c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=dESyimp9J3IA:10 a=7ZN4cI0QAAAA:8 a=tm9BhY98yDMkBz91zHIA:9 a=Dl0WHwQvj8hGZljrFLtM:22
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A situation can occur where the interface bound to the sk is different
to the interface bound to the sk attached to the skb. The interface
bound to the sk is the correct one however this information is lost insid=
e
xfrm_output2 and instead the sk on the skb is used in xfrm_output_resume
instead. This assumes that the sk bound interface and the bound interface
attached to the sk within the skb are the same which can lead to lookup
failures inside ip_route_me_harder resulting in the packet being dropped.

We have an l2tp v3 tunnel with ipsec protection. The tunnel is in the
global VRF however we have an encapsulated dot1q tunnel interface that
is within a different VRF. We also have a mangle rule that marks the=20
packets causing them to be processed inside ip_route_me_harder.

Prior to commit 31c70d5956fc ("l2tp: keep original skb ownership") this
worked fine as the sk attached to the skb was changed from the dot1q
encapsulated interface to the sk for the tunnel which meant the interface
bound to the sk and the interface bound to the skb were identical.
Commit 46d6c5ae953c ("netfilter: use actual socket sk rather than skb sk
when routing harder") fixed some of these issues however a similar
problem existed in the xfrm code.

Fixes: 31c70d5956fc ("l2tp: keep original skb ownership")

Signed-off-by: Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>
Reviewed-by: Steffen Klassert <steffen.klassert@secunet.com>
---
changes in v2:
- Added proper fixes field for backporting

 include/net/xfrm.h     |  2 +-
 net/ipv4/ah4.c         |  2 +-
 net/ipv4/esp4.c        |  2 +-
 net/ipv6/ah6.c         |  2 +-
 net/ipv6/esp6.c        |  2 +-
 net/xfrm/xfrm_output.c | 10 +++++-----
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b2a06f10b62c..bfbc7810df94 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1557,7 +1557,7 @@ int xfrm_trans_queue_net(struct net *net, struct sk=
_buff *skb,
 int xfrm_trans_queue(struct sk_buff *skb,
 		     int (*finish)(struct net *, struct sock *,
 				   struct sk_buff *));
-int xfrm_output_resume(struct sk_buff *skb, int err);
+int xfrm_output_resume(struct sock *sk, struct sk_buff *skb, int err);
 int xfrm_output(struct sock *sk, struct sk_buff *skb);
=20
 #if IS_ENABLED(CONFIG_NET_PKTGEN)
diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index d99e1be94019..36ed85bf2ad5 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -141,7 +141,7 @@ static void ah_output_done(struct crypto_async_reques=
t *base, int err)
 	}
=20
 	kfree(AH_SKB_CB(skb)->tmp);
-	xfrm_output_resume(skb, err);
+	xfrm_output_resume(skb->sk, skb, err);
 }
=20
 static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index a3271ec3e162..4b834bbf95e0 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -279,7 +279,7 @@ static void esp_output_done(struct crypto_async_reque=
st *base, int err)
 		    x->encap && x->encap->encap_type =3D=3D TCP_ENCAP_ESPINTCP)
 			esp_output_tail_tcp(x, skb);
 		else
-			xfrm_output_resume(skb, err);
+			xfrm_output_resume(skb->sk, skb, err);
 	}
 }
=20
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 440080da805b..080ee7f44c64 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -316,7 +316,7 @@ static void ah6_output_done(struct crypto_async_reque=
st *base, int err)
 	}
=20
 	kfree(AH_SKB_CB(skb)->tmp);
-	xfrm_output_resume(skb, err);
+	xfrm_output_resume(skb->sk, skb, err);
 }
=20
 static int ah6_output(struct xfrm_state *x, struct sk_buff *skb)
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 153ad103ba74..727d791ed5e6 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -314,7 +314,7 @@ static void esp_output_done(struct crypto_async_reque=
st *base, int err)
 		    x->encap && x->encap->encap_type =3D=3D TCP_ENCAP_ESPINTCP)
 			esp_output_tail_tcp(x, skb);
 		else
-			xfrm_output_resume(skb, err);
+			xfrm_output_resume(skb->sk, skb, err);
 	}
 }
=20
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index a7ab19353313..b81ca117dac7 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -503,22 +503,22 @@ static int xfrm_output_one(struct sk_buff *skb, int=
 err)
 	return err;
 }
=20
-int xfrm_output_resume(struct sk_buff *skb, int err)
+int xfrm_output_resume(struct sock *sk, struct sk_buff *skb, int err)
 {
 	struct net *net =3D xs_net(skb_dst(skb)->xfrm);
=20
 	while (likely((err =3D xfrm_output_one(skb, err)) =3D=3D 0)) {
 		nf_reset_ct(skb);
=20
-		err =3D skb_dst(skb)->ops->local_out(net, skb->sk, skb);
+		err =3D skb_dst(skb)->ops->local_out(net, sk, skb);
 		if (unlikely(err !=3D 1))
 			goto out;
=20
 		if (!skb_dst(skb)->xfrm)
-			return dst_output(net, skb->sk, skb);
+			return dst_output(net, sk, skb);
=20
 		err =3D nf_hook(skb_dst(skb)->ops->family,
-			      NF_INET_POST_ROUTING, net, skb->sk, skb,
+			      NF_INET_POST_ROUTING, net, sk, skb,
 			      NULL, skb_dst(skb)->dev, xfrm_output2);
 		if (unlikely(err !=3D 1))
 			goto out;
@@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(xfrm_output_resume);
=20
 static int xfrm_output2(struct net *net, struct sock *sk, struct sk_buff=
 *skb)
 {
-	return xfrm_output_resume(skb, 1);
+	return xfrm_output_resume(sk, skb, 1);
 }
=20
 static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_b=
uff *skb)
--=20
2.27.0


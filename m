Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACB5233FF5
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbgGaH2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:28:09 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:50420 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731419AbgGaH2J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:28:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 48ED32027C;
        Fri, 31 Jul 2020 09:28:07 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rLbRXIYZ4ZnW; Fri, 31 Jul 2020 09:28:06 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id CA7AB20538;
        Fri, 31 Jul 2020 09:28:06 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 31 Jul 2020 09:28:06 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 31 Jul
 2020 09:28:06 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 78917318465C;
 Fri, 31 Jul 2020 09:18:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 10/10] espintcp: count packets dropped in espintcp_rcv
Date:   Fri, 31 Jul 2020 09:18:04 +0200
Message-ID: <20200731071804.29557-11-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731071804.29557-1-steffen.klassert@secunet.com>
References: <20200731071804.29557-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Currently, espintcp_rcv drops packets silently, which makes debugging
issues difficult. Count packets as either XfrmInHdrError (when the
packet was too short or contained invalid data) or XfrmInError (for
other issues).

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/espintcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 0a91b07f2b43..827ccdf2db57 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -15,6 +15,7 @@ static void handle_nonesp(struct espintcp_ctx *ctx, struct sk_buff *skb,
 {
 	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf ||
 	    !sk_rmem_schedule(sk, skb, skb->truesize)) {
+		XFRM_INC_STATS(sock_net(sk), LINUX_MIB_XFRMINERROR);
 		kfree_skb(skb);
 		return;
 	}
@@ -59,6 +60,7 @@ static void espintcp_rcv(struct strparser *strp, struct sk_buff *skb)
 
 		err = skb_copy_bits(skb, rxm->offset + 2, &data, 1);
 		if (err < 0) {
+			XFRM_INC_STATS(sock_net(strp->sk), LINUX_MIB_XFRMINHDRERROR);
 			kfree_skb(skb);
 			return;
 		}
@@ -71,6 +73,7 @@ static void espintcp_rcv(struct strparser *strp, struct sk_buff *skb)
 
 	/* drop other short messages */
 	if (unlikely(len <= sizeof(nonesp_marker))) {
+		XFRM_INC_STATS(sock_net(strp->sk), LINUX_MIB_XFRMINHDRERROR);
 		kfree_skb(skb);
 		return;
 	}
@@ -78,17 +81,20 @@ static void espintcp_rcv(struct strparser *strp, struct sk_buff *skb)
 	err = skb_copy_bits(skb, rxm->offset + 2, &nonesp_marker,
 			    sizeof(nonesp_marker));
 	if (err < 0) {
+		XFRM_INC_STATS(sock_net(strp->sk), LINUX_MIB_XFRMINHDRERROR);
 		kfree_skb(skb);
 		return;
 	}
 
 	/* remove header, leave non-ESP marker/SPI */
 	if (!__pskb_pull(skb, rxm->offset + 2)) {
+		XFRM_INC_STATS(sock_net(strp->sk), LINUX_MIB_XFRMINERROR);
 		kfree_skb(skb);
 		return;
 	}
 
 	if (pskb_trim(skb, rxm->full_len - 2) != 0) {
+		XFRM_INC_STATS(sock_net(strp->sk), LINUX_MIB_XFRMINERROR);
 		kfree_skb(skb);
 		return;
 	}
-- 
2.17.1


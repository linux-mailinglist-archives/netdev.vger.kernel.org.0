Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F6B27A97B
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 10:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgI1IZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 04:25:13 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48620 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgI1IY5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 04:24:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1814C2052E;
        Mon, 28 Sep 2020 10:24:56 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SxKa_IgU2IRy; Mon, 28 Sep 2020 10:24:55 +0200 (CEST)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8071320504;
        Mon, 28 Sep 2020 10:24:55 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 28 Sep 2020 10:24:55 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 28 Sep
 2020 10:24:54 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 77DCC3184713;
 Mon, 28 Sep 2020 10:24:54 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/8] espintcp: restore IP CB before handing the packet to xfrm
Date:   Mon, 28 Sep 2020 10:24:44 +0200
Message-ID: <20200928082450.29414-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200928082450.29414-1-steffen.klassert@secunet.com>
References: <20200928082450.29414-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Xiumei reported a bug with espintcp over IPv6 in transport mode,
because xfrm6_transport_finish expects to find IP6CB data (struct
inet6_skb_cb). Currently, espintcp zeroes the CB, but the relevant
part is actually preserved by previous layers (first set up by tcp,
then strparser only zeroes a small part of tcp_skb_tb), so we can just
relocate it to the start of skb->cb.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/espintcp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 827ccdf2db57..1f08ebf7d80c 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -29,8 +29,12 @@ static void handle_nonesp(struct espintcp_ctx *ctx, struct sk_buff *skb,
 
 static void handle_esp(struct sk_buff *skb, struct sock *sk)
 {
+	struct tcp_skb_cb *tcp_cb = (struct tcp_skb_cb *)skb->cb;
+
 	skb_reset_transport_header(skb);
-	memset(skb->cb, 0, sizeof(skb->cb));
+
+	/* restore IP CB, we need at least IP6CB->nhoff */
+	memmove(skb->cb, &tcp_cb->header, sizeof(tcp_cb->header));
 
 	rcu_read_lock();
 	skb->dev = dev_get_by_index_rcu(sock_net(sk), skb->skb_iif);
-- 
2.17.1


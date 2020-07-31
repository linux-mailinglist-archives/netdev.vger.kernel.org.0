Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFCF233FDE
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731671AbgGaHST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:18:19 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49956 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731656AbgGaHSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:18:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 94FA720519;
        Fri, 31 Jul 2020 09:18:11 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JWzX3tidMC9v; Fri, 31 Jul 2020 09:18:11 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C050420590;
        Fri, 31 Jul 2020 09:18:10 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 31 Jul 2020 09:18:10 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 31 Jul
 2020 09:18:09 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 7430A318465B;
 Fri, 31 Jul 2020 09:18:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 09/10] espintcp: handle short messages instead of breaking the encap socket
Date:   Fri, 31 Jul 2020 09:18:03 +0200
Message-ID: <20200731071804.29557-10-steffen.klassert@secunet.com>
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

Currently, short messages (less than 4 bytes after the length header)
will break the stream of messages. This is unnecessary, since we can
still parse messages even if they're too short to contain any usable
data. This is also bogus, as keepalive messages (a single 0xff byte),
though not needed with TCP encapsulation, should be allowed.

This patch changes the stream parser so that short messages are
accepted and dropped in the kernel. Messages that contain a valid SPI
or non-ESP header are processed as before.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Reported-by: Andrew Cagney <cagney@libreswan.org>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/espintcp.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index cb83e3664680..0a91b07f2b43 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -49,9 +49,32 @@ static void espintcp_rcv(struct strparser *strp, struct sk_buff *skb)
 	struct espintcp_ctx *ctx = container_of(strp, struct espintcp_ctx,
 						strp);
 	struct strp_msg *rxm = strp_msg(skb);
+	int len = rxm->full_len - 2;
 	u32 nonesp_marker;
 	int err;
 
+	/* keepalive packet? */
+	if (unlikely(len == 1)) {
+		u8 data;
+
+		err = skb_copy_bits(skb, rxm->offset + 2, &data, 1);
+		if (err < 0) {
+			kfree_skb(skb);
+			return;
+		}
+
+		if (data == 0xff) {
+			kfree_skb(skb);
+			return;
+		}
+	}
+
+	/* drop other short messages */
+	if (unlikely(len <= sizeof(nonesp_marker))) {
+		kfree_skb(skb);
+		return;
+	}
+
 	err = skb_copy_bits(skb, rxm->offset + 2, &nonesp_marker,
 			    sizeof(nonesp_marker));
 	if (err < 0) {
@@ -91,7 +114,7 @@ static int espintcp_parse(struct strparser *strp, struct sk_buff *skb)
 		return err;
 
 	len = be16_to_cpu(blen);
-	if (len < 6)
+	if (len < 2)
 		return -EINVAL;
 
 	return len;
-- 
2.17.1


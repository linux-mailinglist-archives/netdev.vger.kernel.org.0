Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1C235F161
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 12:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhDNKRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 06:17:33 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:59498 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbhDNKR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 06:17:27 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 841F580005B;
        Wed, 14 Apr 2021 12:17:04 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 12:17:04 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Apr
 2021 12:17:03 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 94DED31803B5; Wed, 14 Apr 2021 12:17:03 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/3] esp6: remove a duplicative condition
Date:   Wed, 14 Apr 2021 12:17:00 +0200
Message-ID: <20210414101701.324777-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210414101701.324777-1-steffen.klassert@secunet.com>
References: <20210414101701.324777-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Junlin Yang <yangjunlin@yulong.com>

Fixes coccicheck warnings:
./net/ipv6/esp6_offload.c:319:32-34:
WARNING !A || A && B is equivalent to !A || B

Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/esp6_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 1ca516fb30e1..631c168774f5 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -316,7 +316,7 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 	esp.plen = esp.clen - skb->len - esp.tfclen;
 	esp.tailen = esp.tfclen + esp.plen + alen;
 
-	if (!hw_offload || (hw_offload && !skb_is_gso(skb))) {
+	if (!hw_offload || !skb_is_gso(skb)) {
 		esp.nfrags = esp6_output_head(x, skb, &esp);
 		if (esp.nfrags < 0)
 			return esp.nfrags;
-- 
2.25.1


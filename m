Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2039A63959A
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 12:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiKZLDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 06:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiKZLDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 06:03:12 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72E01900E
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 03:03:10 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 882B02052E;
        Sat, 26 Nov 2022 12:03:09 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ui9QgA9RjefO; Sat, 26 Nov 2022 12:03:09 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EB0F520538;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id E5DD180004A;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 12:03:07 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 26 Nov
 2022 12:03:06 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 456AD3183C55; Sat, 26 Nov 2022 12:03:06 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 10/10] xfrm: add extack to xfrm_set_spdinfo
Date:   Sat, 26 Nov 2022 12:03:03 +0100
Message-ID: <20221126110303.1859238-11-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221126110303.1859238-1-steffen.klassert@secunet.com>
References: <20221126110303.1859238-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 5c280e04e02c..0eb4696661c8 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1367,20 +1367,28 @@ static int xfrm_set_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (attrs[XFRMA_SPD_IPV4_HTHRESH]) {
 		struct nlattr *rta = attrs[XFRMA_SPD_IPV4_HTHRESH];
 
-		if (nla_len(rta) < sizeof(*thresh4))
+		if (nla_len(rta) < sizeof(*thresh4)) {
+			NL_SET_ERR_MSG(extack, "Invalid SPD_IPV4_HTHRESH attribute length");
 			return -EINVAL;
+		}
 		thresh4 = nla_data(rta);
-		if (thresh4->lbits > 32 || thresh4->rbits > 32)
+		if (thresh4->lbits > 32 || thresh4->rbits > 32) {
+			NL_SET_ERR_MSG(extack, "Invalid hash threshold (must be <= 32 for IPv4)");
 			return -EINVAL;
+		}
 	}
 	if (attrs[XFRMA_SPD_IPV6_HTHRESH]) {
 		struct nlattr *rta = attrs[XFRMA_SPD_IPV6_HTHRESH];
 
-		if (nla_len(rta) < sizeof(*thresh6))
+		if (nla_len(rta) < sizeof(*thresh6)) {
+			NL_SET_ERR_MSG(extack, "Invalid SPD_IPV6_HTHRESH attribute length");
 			return -EINVAL;
+		}
 		thresh6 = nla_data(rta);
-		if (thresh6->lbits > 128 || thresh6->rbits > 128)
+		if (thresh6->lbits > 128 || thresh6->rbits > 128) {
+			NL_SET_ERR_MSG(extack, "Invalid hash threshold (must be <= 128 for IPv6)");
 			return -EINVAL;
+		}
 	}
 
 	if (thresh4 || thresh6) {
-- 
2.25.1


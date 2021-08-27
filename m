Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE643F957C
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 09:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244520AbhH0HvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 03:51:16 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41176 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244480AbhH0HvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 03:51:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 641A52049A;
        Fri, 27 Aug 2021 09:50:25 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2BLfE5y8tDCX; Fri, 27 Aug 2021 09:50:22 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B2A64205B5;
        Fri, 27 Aug 2021 09:50:18 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id AD83980004A;
        Fri, 27 Aug 2021 09:50:18 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 09:50:18 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 27 Aug
 2021 09:50:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A89233180409; Fri, 27 Aug 2021 09:50:17 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/3] ipsec: Remove unneeded extra variable in esp4 esp_ssg_unref()
Date:   Fri, 27 Aug 2021 09:50:13 +0200
Message-ID: <20210827075015.2584560-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210827075015.2584560-1-steffen.klassert@secunet.com>
References: <20210827075015.2584560-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

It's assigned twice, but only used to calculate the size of the
structure it points to.  Just remove it and take a sizeof the
actual structure.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index a09e36c4a413..851f542928a3 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -97,7 +97,6 @@ static inline struct scatterlist *esp_req_sg(struct crypto_aead *aead,
 
 static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 {
-	struct esp_output_extra *extra = esp_tmp_extra(tmp);
 	struct crypto_aead *aead = x->data;
 	int extralen = 0;
 	u8 *iv;
@@ -105,9 +104,8 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 	struct scatterlist *sg;
 
 	if (x->props.flags & XFRM_STATE_ESN)
-		extralen += sizeof(*extra);
+		extralen += sizeof(struct esp_output_extra);
 
-	extra = esp_tmp_extra(tmp);
 	iv = esp_tmp_iv(aead, tmp, extralen);
 	req = esp_tmp_req(aead, iv);
 
-- 
2.25.1


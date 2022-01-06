Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EED4861E5
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbiAFJOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:14:04 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37794 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237247AbiAFJOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 04:14:00 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2810220627;
        Thu,  6 Jan 2022 10:13:59 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ll-niOWH8wyI; Thu,  6 Jan 2022 10:13:58 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 11A472065B;
        Thu,  6 Jan 2022 10:13:58 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 02DB980004A;
        Thu,  6 Jan 2022 10:13:58 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 6 Jan 2022 10:13:57 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 10:13:57 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6172A318045E; Thu,  6 Jan 2022 10:13:54 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/7] ipv6/esp6: Remove structure variables and alignment statements
Date:   Thu, 6 Jan 2022 10:13:44 +0100
Message-ID: <20220106091350.3038869-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106091350.3038869-1-steffen.klassert@secunet.com>
References: <20220106091350.3038869-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

The definition of this variable is just to find the length of the
structure after aligning the structure. The PTR alignment function
is to optimize the size of the structure. In fact, it doesn't seem
to be of much use, because both members of the structure are of
type u32.
So I think that the definition of the variable and the
corresponding alignment can be deleted, the value of extralen can
be directly passed in the size of the structure.

The clang_analyzer complains as follows:

net/ipv6/esp6.c:117:27 warning:

Value stored to 'extra' during its initialization is never read

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/esp6.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index ed2f061b8768..c35c211c9cb7 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -114,7 +114,6 @@ static inline struct scatterlist *esp_req_sg(struct crypto_aead *aead,
 
 static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 {
-	struct esp_output_extra *extra = esp_tmp_extra(tmp);
 	struct crypto_aead *aead = x->data;
 	int extralen = 0;
 	u8 *iv;
@@ -122,7 +121,7 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 	struct scatterlist *sg;
 
 	if (x->props.flags & XFRM_STATE_ESN)
-		extralen += sizeof(*extra);
+		extralen += sizeof(struct esp_output_extra);
 
 	iv = esp_tmp_iv(aead, tmp, extralen);
 	req = esp_tmp_req(aead, iv);
-- 
2.25.1


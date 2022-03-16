Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622254DAF65
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355583AbiCPMNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355578AbiCPMNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:13:02 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4F857143
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 05:11:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5C65A20613;
        Wed, 16 Mar 2022 13:11:46 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2DVVyqp5ywnO; Wed, 16 Mar 2022 13:11:45 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9574B20638;
        Wed, 16 Mar 2022 13:11:45 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 8766680004A;
        Wed, 16 Mar 2022 13:11:45 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Wed, 16 Mar 2022 13:11:45 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 16 Mar
 2022 13:11:44 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 8877E31801A7; Wed, 16 Mar 2022 13:11:44 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/2] af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
Date:   Wed, 16 Mar 2022 13:11:41 +0100
Message-ID: <20220316121142.3142336-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316121142.3142336-1-steffen.klassert@secunet.com>
References: <20220316121142.3142336-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

Add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
to initialize the buffer of supp_skb to fix a kernel-info-leak issue.
1) Function pfkey_register calls compose_sadb_supported to request
a sk_buff. 2) compose_sadb_supported calls alloc_sbk to allocate
a sk_buff, but it doesn't zero it. 3) If auth_len is greater 0, then
compose_sadb_supported treats the memory as a struct sadb_supported and
begins to initialize. But it just initializes the field sadb_supported_len
and field sadb_supported_exttype without field sadb_supported_reserved.

Reported-by: TCS Robot <tcs_robot@tencent.com>
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/key/af_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 9bf52a09b5ff..fd51db3be91c 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1699,7 +1699,7 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
 
 	xfrm_probe_algs();
 
-	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL);
+	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL | __GFP_ZERO);
 	if (!supp_skb) {
 		if (hdr->sadb_msg_satype != SADB_SATYPE_UNSPEC)
 			pfk->registered &= ~(1<<hdr->sadb_msg_satype);
-- 
2.25.1


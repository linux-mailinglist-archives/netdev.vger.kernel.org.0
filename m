Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1945757B2AC
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbiGTIR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiGTIRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:17:55 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC96145F52
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:17:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 36B0E20628;
        Wed, 20 Jul 2022 10:17:52 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tXUeW_fY9tVg; Wed, 20 Jul 2022 10:17:51 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6724E2061E;
        Wed, 20 Jul 2022 10:17:51 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 5DE8D80004A;
        Wed, 20 Jul 2022 10:17:51 +0200 (CEST)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 10:17:51 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 10:17:50 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D6B2C3182A75; Wed, 20 Jul 2022 10:17:49 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/5] xfrm: convert alg_key to flexible array member
Date:   Wed, 20 Jul 2022 10:17:43 +0200
Message-ID: <20220720081746.1187382-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220720081746.1187382-1-steffen.klassert@secunet.com>
References: <20220720081746.1187382-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

Iproute2 build generates a warning when built with gcc-12.
This is because the alg_key in xfrm.h API has zero size
array element instead of flexible array.

    CC       xfrm_state.o
In function ‘xfrm_algo_parse’,
    inlined from ‘xfrm_state_modify.constprop’ at xfrm_state.c:573:5:
xfrm_state.c:162:32: warning: writing 1 byte into a region of size 0 [-Wstringop-overflow=]
  162 |                         buf[j] = val;
      |                         ~~~~~~~^~~~~

This patch convert the alg_key into flexible array member.
There are other zero size arrays here that should be converted as
well.

This patch is RFC only since it is only compile tested and
passes trivial iproute2 tests.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/uapi/linux/xfrm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 65e13a099b1a..3ed61df9cc91 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -102,21 +102,21 @@ struct xfrm_replay_state_esn {
 struct xfrm_algo {
 	char		alg_name[64];
 	unsigned int	alg_key_len;    /* in bits */
-	char		alg_key[0];
+	char		alg_key[];
 };
 
 struct xfrm_algo_auth {
 	char		alg_name[64];
 	unsigned int	alg_key_len;    /* in bits */
 	unsigned int	alg_trunc_len;  /* in bits */
-	char		alg_key[0];
+	char		alg_key[];
 };
 
 struct xfrm_algo_aead {
 	char		alg_name[64];
 	unsigned int	alg_key_len;	/* in bits */
 	unsigned int	alg_icv_len;	/* in bits */
-	char		alg_key[0];
+	char		alg_key[];
 };
 
 struct xfrm_stats {
-- 
2.25.1


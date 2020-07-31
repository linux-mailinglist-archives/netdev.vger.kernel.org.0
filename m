Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F29F233FDF
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbgGaHST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:18:19 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49954 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731652AbgGaHSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:18:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 643CF205DB;
        Fri, 31 Jul 2020 09:18:11 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EG2Jzfc037Ar; Fri, 31 Jul 2020 09:18:10 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8A44420519;
        Fri, 31 Jul 2020 09:18:10 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 31 Jul 2020 09:18:10 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 31 Jul
 2020 09:18:09 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 6BE673184658;
 Fri, 31 Jul 2020 09:18:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 07/10] af_key: pfkey_dump needs parameter validation
Date:   Fri, 31 Jul 2020 09:18:01 +0200
Message-ID: <20200731071804.29557-8-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731071804.29557-1-steffen.klassert@secunet.com>
References: <20200731071804.29557-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Salyzyn <salyzyn@android.com>

In pfkey_dump() dplen and splen can both be specified to access the
xfrm_address_t structure out of bounds in__xfrm_state_filter_match()
when it calls addr_match() with the indexes.  Return EINVAL if either
are out of range.

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/key/af_key.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 979c579afc63..a915bc86620a 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1849,6 +1849,13 @@ static int pfkey_dump(struct sock *sk, struct sk_buff *skb, const struct sadb_ms
 	if (ext_hdrs[SADB_X_EXT_FILTER - 1]) {
 		struct sadb_x_filter *xfilter = ext_hdrs[SADB_X_EXT_FILTER - 1];
 
+		if ((xfilter->sadb_x_filter_splen >=
+			(sizeof(xfrm_address_t) << 3)) ||
+		    (xfilter->sadb_x_filter_dplen >=
+			(sizeof(xfrm_address_t) << 3))) {
+			mutex_unlock(&pfk->dump_lock);
+			return -EINVAL;
+		}
 		filter = kmalloc(sizeof(*filter), GFP_KERNEL);
 		if (filter == NULL) {
 			mutex_unlock(&pfk->dump_lock);
-- 
2.17.1


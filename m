Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A1925D1AF
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 08:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgIDGuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 02:50:22 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:54030 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgIDGuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 02:50:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 99D2C20539;
        Fri,  4 Sep 2020 08:50:19 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3wz8WCDui6Jg; Fri,  4 Sep 2020 08:50:17 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AD69A20538;
        Fri,  4 Sep 2020 08:50:17 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Sep 2020 08:50:17 +0200
Received: from moon.secunet.de (172.18.26.122) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 4 Sep 2020
 08:50:17 +0200
Date:   Fri, 4 Sep 2020 08:50:11 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
CC:     Antony Antony <antony@phenome.org>,
        Antony Antony <antony.antony@secunet.com>
Subject: [PATCH v3 3/4] xfrm: clone XFRMA_SEC_CTX in xfrm_do_migrate
Message-ID: <20200904065011.GA21546@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20200820181158.GA19658@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200820181158.GA19658@moon.secunet.de>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XFRMA_SEC_CTX was not cloned from the old to the new.
Migrate this attribute during XFRMA_MSG_MIGRATE

v1->v2:
 - return -ENOMEM on error
v2->v3:
 - fix return type to int

Fixes: 80c9abaabf42 ("[XFRM]: Extension for dynamic update of endpoint address(es)")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 net/xfrm/xfrm_state.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 3a000f289dcd..5e5ed8108498 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1441,6 +1441,30 @@ int xfrm_state_add(struct xfrm_state *x)
 EXPORT_SYMBOL(xfrm_state_add);
 
 #ifdef CONFIG_XFRM_MIGRATE
+static inline int clone_security(struct xfrm_state *x, struct xfrm_sec_ctx *security)
+{
+	struct xfrm_user_sec_ctx *uctx;
+	int size = sizeof(*uctx) + security->ctx_len;
+	int err;
+
+	uctx = kmalloc(size, GFP_KERNEL);
+	if (!uctx)
+		return -ENOMEM;
+
+	uctx->exttype = XFRMA_SEC_CTX;
+	uctx->len = size;
+	uctx->ctx_doi = security->ctx_doi;
+	uctx->ctx_alg = security->ctx_alg;
+	uctx->ctx_len = security->ctx_len;
+	memcpy(uctx + 1, security->ctx_str, security->ctx_len);
+	err = security_xfrm_state_alloc(x, uctx);
+	kfree(uctx);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 					   struct xfrm_encap_tmpl *encap)
 {
@@ -1497,6 +1521,10 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 			goto error;
 	}
 
+	if (orig->security)
+		if (clone_security(x, orig->security))
+			goto error;
+
 	if (orig->coaddr) {
 		x->coaddr = kmemdup(orig->coaddr, sizeof(*x->coaddr),
 				    GFP_KERNEL);
-- 
2.20.1


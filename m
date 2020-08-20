Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BB124C526
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 20:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHTSQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 14:16:16 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:38836 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbgHTSQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 14:16:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 08D332057A;
        Thu, 20 Aug 2020 20:16:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Dk4HPiFtsfhd; Thu, 20 Aug 2020 20:16:13 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4E98D20512;
        Thu, 20 Aug 2020 20:16:13 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 20:16:13 +0200
Received: from moon.secunet.de (172.18.26.122) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 20 Aug
 2020 20:16:12 +0200
Date:   Thu, 20 Aug 2020 20:16:08 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
CC:     Antony Antony <antony@phenome.org>,
        Antony Antony <antony.antony@secunet.com>
Subject: [PATCH 3/3] xfrm: clone XFRMA_SEC_CTX during xfrm_do_migrate
Message-ID: <20200820181608.GA19772@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20200820181158.GA19658@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XFRMA_SEC_CTX was not cloned from the old to the new.
Migrate this attribute during XFRMA_MSG_MIGRATE

Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 net/xfrm/xfrm_state.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 20a12c67a931..dbcb71b800b8 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1441,6 +1441,30 @@ int xfrm_state_add(struct xfrm_state *x)
 EXPORT_SYMBOL(xfrm_state_add);
 
 #ifdef CONFIG_XFRM_MIGRATE
+static inline bool clone_security(struct xfrm_state *x, struct xfrm_sec_ctx *security)
+{
+	struct xfrm_user_sec_ctx *uctx;
+	int size = sizeof(*uctx) + security->ctx_len;
+	int err;
+
+	uctx = kmalloc(size, GFP_KERNEL);
+	if (!uctx)
+		return true;
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
+		return true;
+
+	return false;
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


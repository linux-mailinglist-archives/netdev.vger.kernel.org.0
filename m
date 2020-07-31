Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127CB233FE0
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731676AbgGaHSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:18:20 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49946 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731643AbgGaHSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:18:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B08D2205CD;
        Fri, 31 Jul 2020 09:18:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DIwvn3nwhL9e; Fri, 31 Jul 2020 09:18:10 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E6C9220590;
        Fri, 31 Jul 2020 09:18:09 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 31 Jul 2020 09:18:09 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 31 Jul
 2020 09:18:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 678123184657;
 Fri, 31 Jul 2020 09:18:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 06/10] xfrm: Fix crash when the hold queue is used.
Date:   Fri, 31 Jul 2020 09:18:00 +0200
Message-ID: <20200731071804.29557-7-steffen.klassert@secunet.com>
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

The commits "xfrm: Move dst->path into struct xfrm_dst"
and "net: Create and use new helper xfrm_dst_child()."
changed xfrm bundle handling under the assumption
that xdst->path and dst->child are not a NULL pointer
only if dst->xfrm is not a NULL pointer. That is true
with one exception. If the xfrm hold queue is used
to wait until a SA is installed by the key manager,
we create a dummy bundle without a valid dst->xfrm
pointer. The current xfrm bundle handling crashes
in that case. Fix this by extending the NULL check
of dst->xfrm with a test of the DST_XFRM_QUEUE flag.

Fixes: 0f6c480f23f4 ("xfrm: Move dst->path into struct xfrm_dst")
Fixes: b92cf4aab8e6 ("net: Create and use new helper xfrm_dst_child().")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 5c20953c8deb..51f65d23ebaf 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -941,7 +941,7 @@ struct xfrm_dst {
 static inline struct dst_entry *xfrm_dst_path(const struct dst_entry *dst)
 {
 #ifdef CONFIG_XFRM
-	if (dst->xfrm) {
+	if (dst->xfrm || (dst->flags & DST_XFRM_QUEUE)) {
 		const struct xfrm_dst *xdst = (const struct xfrm_dst *) dst;
 
 		return xdst->path;
@@ -953,7 +953,7 @@ static inline struct dst_entry *xfrm_dst_path(const struct dst_entry *dst)
 static inline struct dst_entry *xfrm_dst_child(const struct dst_entry *dst)
 {
 #ifdef CONFIG_XFRM
-	if (dst->xfrm) {
+	if (dst->xfrm || (dst->flags & DST_XFRM_QUEUE)) {
 		struct xfrm_dst *xdst = (struct xfrm_dst *) dst;
 		return xdst->child;
 	}
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DB0223719
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 10:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgGQIeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 04:34:31 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37556 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgGQIea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 04:34:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 22C3B20265
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 10:34:29 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nPaTQ9v4_VJn for <netdev@vger.kernel.org>;
        Fri, 17 Jul 2020 10:34:28 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id ADBB1201E4
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 10:34:28 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 17 Jul 2020 10:34:28 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 17 Jul
 2020 10:34:28 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A9D6F31805A7; Fri, 17 Jul 2020 10:34:27 +0200 (CEST)
Date:   Fri, 17 Jul 2020 10:34:27 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
Subject: [PATCH RFC ipsec] xfrm: Fix crash when the hold queue is used.
Message-ID: <20200717083427.GA20687@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
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


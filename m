Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E76260222
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfGEI1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:27:19 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36424 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbfGEI1K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:27:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 82E0A2024F;
        Fri,  5 Jul 2019 10:27:09 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id v8dY_BAUMpBq; Fri,  5 Jul 2019 10:27:09 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E318520251;
        Fri,  5 Jul 2019 10:27:05 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:27:05 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 1C3FD318061C;
 Fri,  5 Jul 2019 10:27:05 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/7] xfrm: Fix xfrm sel prefix length validation
Date:   Fri, 5 Jul 2019 10:26:54 +0200
Message-ID: <20190705082700.31107-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705082700.31107-1-steffen.klassert@secunet.com>
References: <20190705082700.31107-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Gupta <anirudhrudr@gmail.com>

Family of src/dst can be different from family of selector src/dst.
Use xfrm selector family to validate address prefix length,
while verifying new sa from userspace.

Validated patch with this command:
ip xfrm state add src 1.1.6.1 dst 1.1.6.2 proto esp spi 4260196 \
reqid 20004 mode tunnel aead "rfc4106(gcm(aes))" \
0x1111016400000000000000000000000044440001 128 \
sel src 1011:1:4::2/128 sel dst 1021:1:4::2/128 dev Port5

Fixes: 07bf7908950a ("xfrm: Validate address prefix lengths in the xfrm selector.")
Signed-off-by: Anirudh Gupta <anirudh.gupta@sophos.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index eb8d14389601..74a3d1e0ff63 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -150,6 +150,22 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 
 	err = -EINVAL;
 	switch (p->family) {
+	case AF_INET:
+		break;
+
+	case AF_INET6:
+#if IS_ENABLED(CONFIG_IPV6)
+		break;
+#else
+		err = -EAFNOSUPPORT;
+		goto out;
+#endif
+
+	default:
+		goto out;
+	}
+
+	switch (p->sel.family) {
 	case AF_INET:
 		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
 			goto out;
-- 
2.17.1


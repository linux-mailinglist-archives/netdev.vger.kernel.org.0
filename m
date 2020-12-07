Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17802D0D83
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 10:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgLGJ4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 04:56:09 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:49398 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgLGJ4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 04:56:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5B5C92049B;
        Mon,  7 Dec 2020 10:55:27 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tKRhO60bTKUX; Mon,  7 Dec 2020 10:55:26 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C9DF1201C7;
        Mon,  7 Dec 2020 10:55:26 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 10:55:26 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 7 Dec 2020
 10:55:26 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9E8CE3182E76; Mon,  7 Dec 2020 10:39:43 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/4] xfrm/compat: Don't allocate memory with __GFP_ZERO
Date:   Mon, 7 Dec 2020 10:39:36 +0100
Message-ID: <20201207093937.2874932-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207093937.2874932-1-steffen.klassert@secunet.com>
References: <20201207093937.2874932-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

32-bit to 64-bit messages translator zerofies needed paddings in the
translation, the rest is the actual payload.
Don't allocate zero pages as they are not needed.

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index 556e9f33b815..d8e8a11ca845 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -564,7 +564,7 @@ static struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
 		return NULL;
 
 	len += NLMSG_HDRLEN;
-	h64 = kvmalloc(len, GFP_KERNEL | __GFP_ZERO);
+	h64 = kvmalloc(len, GFP_KERNEL);
 	if (!h64)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.25.1


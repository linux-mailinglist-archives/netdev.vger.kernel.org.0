Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B472D0D88
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 10:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgLGJ4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 04:56:16 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:49432 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgLGJ4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 04:56:12 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 34C2E204EF;
        Mon,  7 Dec 2020 10:55:31 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6vtN618LYGm1; Mon,  7 Dec 2020 10:55:27 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 399C120491;
        Mon,  7 Dec 2020 10:55:27 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 10:55:27 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 7 Dec 2020
 10:55:26 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9B6933182E6C; Mon,  7 Dec 2020 10:39:43 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/4] xfrm/compat: memset(0) 64-bit padding at right place
Date:   Mon, 7 Dec 2020 10:39:35 +0100
Message-ID: <20201207093937.2874932-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207093937.2874932-1-steffen.klassert@secunet.com>
References: <20201207093937.2874932-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

32-bit messages translated by xfrm_compat can have attributes attached.
For all, but XFRMA_SA, XFRMA_POLICY the size of payload is the same
in 32-bit UABI and 64-bit UABI. For XFRMA_SA (struct xfrm_usersa_info)
and XFRMA_POLICY (struct xfrm_userpolicy_info) it's only tail-padding
that is present in 64-bit payload, but not in 32-bit.
The proper size for destination nlattr is already calculated by
xfrm_user_rcv_calculate_len64() and allocated with kvmalloc().

xfrm_attr_cpy32() copies 32-bit copy_len into 64-bit attribute
translated payload, zero-filling possible padding for SA/POLICY.
Due to a typo, *pos already has 64-bit payload size, in a result next
memset(0) is called on the memory after the translated attribute, not on
the tail-padding of it.

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Reported-by: syzbot+c43831072e7df506a646@syzkaller.appspotmail.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index 17edbf935e35..556e9f33b815 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -388,7 +388,7 @@ static int xfrm_attr_cpy32(void *dst, size_t *pos, const struct nlattr *src,
 
 	memcpy(nla, src, nla_attr_size(copy_len));
 	nla->nla_len = nla_attr_size(payload);
-	*pos += nla_attr_size(payload);
+	*pos += nla_attr_size(copy_len);
 	nlmsg->nlmsg_len += nla->nla_len;
 
 	memset(dst + *pos, 0, payload - copy_len);
-- 
2.25.1


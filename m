Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E8D2D0D86
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 10:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgLGJ4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 04:56:16 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:49446 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbgLGJ4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 04:56:13 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B66E92027C;
        Mon,  7 Dec 2020 10:55:31 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jt5oPFuYOvnG; Mon,  7 Dec 2020 10:55:27 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5A4872049A;
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
        id 97C1D3182E67; Mon,  7 Dec 2020 10:39:43 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/4] xfrm/compat: Translate by copying XFRMA_UNSPEC attribute
Date:   Mon, 7 Dec 2020 10:39:34 +0100
Message-ID: <20201207093937.2874932-2-steffen.klassert@secunet.com>
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

xfrm_xlate32() translates 64-bit message provided by kernel to be sent
for 32-bit listener (acknowledge or monitor). Translator code doesn't
expect XFRMA_UNSPEC attribute as it doesn't know its payload.
Kernel never attaches such attribute, but a user can.

I've searched if any opensource does it and the answer is no.
Nothing on github and google finds only tfcproject that has such code
commented-out.

What will happen if a user sends a netlink message with XFRMA_UNSPEC
attribute? Ipsec code ignores this attribute. But if there is a
monitor-process or 32-bit user requested ack - kernel will try to
translate such message and will hit WARN_ONCE() in xfrm_xlate64_attr().

Deal with XFRMA_UNSPEC by copying the attribute payload with
xfrm_nla_cpy(). In result, the default switch-case in xfrm_xlate64_attr()
becomes an unused code. Leave those 3 lines in case a new xfrm attribute
will be added.

Fixes: 5461fc0c8d9f ("xfrm/compat: Add 64=>32-bit messages translator")
Reported-by: syzbot+a7e701c8385bd8543074@syzkaller.appspotmail.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_compat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index e28f0c9ecd6a..17edbf935e35 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -234,6 +234,7 @@ static int xfrm_xlate64_attr(struct sk_buff *dst, const struct nlattr *src)
 	case XFRMA_PAD:
 		/* Ignore */
 		return 0;
+	case XFRMA_UNSPEC:
 	case XFRMA_ALG_AUTH:
 	case XFRMA_ALG_CRYPT:
 	case XFRMA_ALG_COMP:
-- 
2.25.1


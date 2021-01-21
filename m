Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F942FE9C5
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbhAUMRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:17:07 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:54592 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730850AbhAUMQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 07:16:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DEDE720491;
        Thu, 21 Jan 2021 13:16:02 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vvN7hErchJP8; Thu, 21 Jan 2021 13:16:02 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 63001201D5;
        Thu, 21 Jan 2021 13:16:02 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 21 Jan 2021 13:16:01 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 21 Jan
 2021 13:16:02 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id A13443181CAC;
 Thu, 21 Jan 2021 13:16:01 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/5] xfrm: fix disable_xfrm sysctl when used on xfrm interfaces
Date:   Thu, 21 Jan 2021 13:15:55 +0100
Message-ID: <20210121121558.621339-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121121558.621339-1-steffen.klassert@secunet.com>
References: <20210121121558.621339-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

The disable_xfrm flag signals that xfrm should not be performed during
routing towards a device before reaching device xmit.

For xfrm interfaces this is usually desired as they perform the outbound
policy lookup as part of their xmit using their if_id.

Before this change enabling this flag on xfrm interfaces prevented them
from xmitting as xfrm_lookup_with_ifid() would not perform a policy lookup
in case the original dst had the DST_NOXFRM flag.

This optimization is incorrect when the lookup is done by the xfrm
interface xmit logic.

Fix by performing policy lookup when invoked by xfrmi as if_id != 0.

Similarly it's unlikely for the 'no policy exists on net' check to yield
any performance benefits when invoked from xfrmi.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index d622c2548d22..2f84136af48a 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3078,8 +3078,8 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 		xflo.flags = flags;
 
 		/* To accelerate a bit...  */
-		if ((dst_orig->flags & DST_NOXFRM) ||
-		    !net->xfrm.policy_count[XFRM_POLICY_OUT])
+		if (!if_id && ((dst_orig->flags & DST_NOXFRM) ||
+			       !net->xfrm.policy_count[XFRM_POLICY_OUT]))
 			goto nopol;
 
 		xdst = xfrm_bundle_lookup(net, fl, family, dir, &xflo, if_id);
-- 
2.25.1


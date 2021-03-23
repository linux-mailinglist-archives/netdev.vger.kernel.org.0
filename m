Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857C63459AA
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhCWI0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:26:53 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49644 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhCWI0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 04:26:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8D5B4201CF
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 09:26:45 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bHzqpAVuQyNz for <netdev@vger.kernel.org>;
        Tue, 23 Mar 2021 09:26:45 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1F00020184
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 09:26:45 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 23 Mar 2021 09:26:45 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 23 Mar
 2021 09:26:44 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 470433180449; Tue, 23 Mar 2021 09:26:44 +0100 (CET)
Date:   Tue, 23 Mar 2021 09:26:44 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
Subject: [PATCH ipsec] xfrm: Fix NULL pointer dereference on policy lookup
Message-ID: <20210323082644.GP62598@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When xfrm interfaces are used in combination with namespaces
and ESP offload, we get a dst_entry NULL pointer dereference.
This is because we don't have a dst_entry attached in the ESP
offloading case and we need to do a policy lookup before the
namespace transition.

Fix this by expicit checking of skb_dst(skb) before accessing it.

Fixes: f203b76d78092 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b2a06f10b62c..fdb7e40a61e9 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1097,7 +1097,7 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 		return __xfrm_policy_check(sk, ndir, skb, family);
 
 	return	(!net->xfrm.policy_count[dir] && !secpath_exists(skb)) ||
-		(skb_dst(skb)->flags & DST_NOPOLICY) ||
+		(skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
 		__xfrm_policy_check(sk, ndir, skb, family);
 }
 
-- 
2.25.1


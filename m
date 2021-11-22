Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609F8458C50
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 11:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbhKVKg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 05:36:29 -0500
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:56900 "EHLO
        smtpservice.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S236258AbhKVKg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 05:36:28 -0500
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 480A160015;
        Mon, 22 Nov 2021 11:33:20 +0100 (CET)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1mp6dU-0000Li-4i; Mon, 22 Nov 2021 11:33:20 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        antony.antony@secunet.com, netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        stable@vger.kernel.org
Subject: [PATCH ipsec] xfrm: fix dflt policy check when there is no policy configured
Date:   Mon, 22 Nov 2021 11:33:13 +0100
Message-Id: <20211122103313.1331-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When there is no policy configured on the system, the default policy is
checked in xfrm_route_forward. However, it was done with the wrong
direction (XFRM_POLICY_FWD instead of XFRM_POLICY_OUT).
The default policy for XFRM_POLICY_FWD was checked just before, with a call
to xfrm[46]_policy_check().

CC: stable@vger.kernel.org
Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/net/xfrm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 2308210793a0..55e574511af5 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1162,7 +1162,7 @@ static inline int xfrm_route_forward(struct sk_buff *skb, unsigned short family)
 {
 	struct net *net = dev_net(skb->dev);
 
-	if (xfrm_default_allow(net, XFRM_POLICY_FWD))
+	if (xfrm_default_allow(net, XFRM_POLICY_OUT))
 		return !net->xfrm.policy_count[XFRM_POLICY_OUT] ||
 			(skb_dst(skb)->flags & DST_NOXFRM) ||
 			__xfrm_route_forward(skb, family);
-- 
2.33.0


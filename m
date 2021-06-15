Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D8F3A82D6
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhFOOaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhFOOaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:30:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D121C0613A3
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:27:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ltA2J-0000fF-Ut; Tue, 15 Jun 2021 16:27:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next] xfrm: avoid compiler warning when ipv6 is disabled
Date:   Tue, 15 Jun 2021 16:27:20 +0200
Message-Id: <20210615142720.2749-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

with CONFIG_IPV6=n:
xfrm_output.c:140:12: warning: 'xfrm6_hdr_offset' defined but not used

Fixes: 9acf4d3b9ec1 ("xfrm: ipv6: add xfrm6_hdr_offset helper")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/xfrm/xfrm_output.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 3709d3f7c5ce..527da58464f3 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -137,6 +137,7 @@ static int mip6_rthdr_offset(struct sk_buff *skb, u8 **nexthdr, int type)
 }
 #endif
 
+#if IS_ENABLED(CONFIG_IPV6)
 static int xfrm6_hdr_offset(struct xfrm_state *x, struct sk_buff *skb, u8 **prevhdr)
 {
 	switch (x->type->proto) {
@@ -151,6 +152,7 @@ static int xfrm6_hdr_offset(struct xfrm_state *x, struct sk_buff *skb, u8 **prev
 
 	return ip6_find_1stfragopt(skb, prevhdr);
 }
+#endif
 
 /* Add encapsulation header.
  *
-- 
2.31.1


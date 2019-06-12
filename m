Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6A2B42037
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 10:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731317AbfFLI7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 04:59:53 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46924 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729596AbfFLI7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 04:59:52 -0400
X-Greylist: delayed 1307 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2019 04:59:51 EDT
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hayld-0003pP-MZ; Wed, 12 Jun 2019 10:38:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH ipsec-next] xfrm: fix bogus WARN_ON with ipv6
Date:   Wed, 12 Jun 2019 10:30:58 +0200
Message-Id: <20190612083058.22230-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612111144.757a8cea@canb.auug.org.au>
References: <20190612111144.757a8cea@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/xfrm/xfrm_input.c:378:17: warning: this statement may fall through [-Wimplicit-fallthrough=]
skb->protocol = htons(ETH_P_IPV6);

... the fallthrough then causes a bogus WARN_ON().

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 4c203b0454b ("xfrm: remove eth_proto value from xfrm_state_afinfo")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/xfrm/xfrm_input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 8a00cc94c32c..6088bc2dc11e 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -376,6 +376,7 @@ static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 		break;
 	case AF_INET6:
 		skb->protocol = htons(ETH_P_IPV6);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
-- 
2.21.0


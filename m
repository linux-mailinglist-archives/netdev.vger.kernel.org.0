Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1011947050
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfFOOJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:30 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50987 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:30 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6E1A821EAF;
        Sat, 15 Jun 2019 10:09:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=LLkeEezLloJ+QEvXHsMqJ0OOd0++uDuG8cUelH9+L5Q=; b=t/6waXyV
        DEEBMQ6rrnE3GAM9SRvU3G0UpLW0bBhdfrNlWuBxDkBL8FO93Z9XA7f1N/jMFb9M
        CMLvpTmcSpy1YsdxcJFO20vLhXfQma1F0CtUY+dLeWAf/N0lfPZzridx1vRoaY+2
        KOpRdMtazOpAah5R/r/YZDWui9+HfnCeKl15JmFUCK0ZYzIusAIZycTRu6yB1nke
        uPZbBC2w7iECRcTwkceYT/3EilW86fMjGIRPh9Xf/wg7khMgJbwkpbfvQOoJTb/O
        WRvlVjcO3nm5Ci+tHJrU50GnesULjN058i/asY6Mx/gwnPH+hLFpjsVof2m36nCu
        CRz2HCYV1I/rdQ==
X-ME-Sender: <xms:GfwEXbKMYX7aK3hBzYFyxHjKgqn87iyLPBIBK7OGxHHSQxDdn59nvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepie
X-ME-Proxy: <xmx:GfwEXU9rr7NItR-0nR1zLYPngHUCQ99seTi50kolDUChRuEDTmPDBQ>
    <xmx:GfwEXVzAX7C1YieBNuB2X4sA8X-OxJIOWpreDMnpVre4Y9ASUYPHNA>
    <xmx:GfwEXc-lCC-zwKjQoJBXG2sMUz8MfEMUx4OyE8vo4Oqp4wuwKuCXzQ>
    <xmx:GfwEXZfK6twpMQzQ34eGS0OcXDwuaU2fuYf2jnEnEB86e56uyY_PHQ>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46D37380088;
        Sat, 15 Jun 2019 10:09:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/17] ipv6: Add IPv6 multipath notification for route delete
Date:   Sat, 15 Jun 2019 17:07:41 +0300
Message-Id: <20190615140751.17661-8-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

If all the nexthops of a multipath route are being deleted, send one
notification for the entire route, instead of one per-nexthop.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/ipv6/route.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index da504d36ce54..c4d285fe0adc 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3718,6 +3718,12 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 				info->skip_notify = 1;
 		}
 
+		info->skip_notify_kernel = 1;
+		call_fib6_multipath_entry_notifiers(net,
+						    FIB_EVENT_ENTRY_DEL,
+						    rt,
+						    rt->fib6_nsiblings,
+						    NULL);
 		list_for_each_entry_safe(sibling, next_sibling,
 					 &rt->fib6_siblings,
 					 fib6_siblings) {
-- 
2.20.1


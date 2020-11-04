Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78982A653D
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgKDNcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:32:08 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56095 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730015AbgKDNcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:32:01 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BBC3D5C005B;
        Wed,  4 Nov 2020 08:32:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:32:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=hzljWcmG9jsm2w+9coN0Yuh9pDVFsM0CBpdXPgOUQKU=; b=hRdKGtR3
        sS1P+lD6mCb3usELkr8HKES8pj1MYAZ6LK5NepzOj9glhOYy02OOCm8Ox/9t4NkE
        ll3/NvrsvmDj2dWKtJs7/ZIxoNhNscEIhCxE9AepOncLpsh3Z+muwtJyt2C8uw1i
        4ZYwuwR9tl8T20IA+RwYI4mds+2qR3zea5EmsBBI2EllVHzD90P7xKC60ndibDlp
        ssOw1Hw/4iOpfUfDOnLShj/4CmtODMiLm0tZyc6rtDb+7y8oez/bKNOYvI917g/m
        j476nw+Rrc6sfkHjvPZnKyhBLMwf6gWnxK1aRSxxOM0S8Li1Nlz5S5MFXrc0QzYC
        3/FY8Pv24Po5MA==
X-ME-Sender: <xms:UK2iX-wYcRwAnfkL_mHn5Z4tzGJqdCbGy0RgvtwH0FsFBBLSe4E1sw>
    <xme:UK2iX6TAEaLQtmhdDfFLSvRtRyVRgEbMq_9w5j1DzQ8mh9PDEM0hO1-YsisRvybTJ
    PQsD5b2FKb9m9I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedutdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:UK2iXwW2MruWEWyXKvDXxE_znaWL6MWS2r_BEgzvLbaWiycQCyrr6Q>
    <xmx:UK2iX0hqn6vfi6L8M08b0W9JOTphD_UI-z9fngh4dsTOhWsdtOGpug>
    <xmx:UK2iXwC1APPGaO-3edsnpm_OG40OKWxH8qT5k1O7RfSe3oZetCD0Qw>
    <xmx:UK2iXzOrL2z890MU5vrgJgoBl4GtWzI19MT19d4J5xTFWoZUN4hKCA>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 598803064610;
        Wed,  4 Nov 2020 08:31:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 14/18] nexthop: Remove in-kernel route notifications when nexthop changes
Date:   Wed,  4 Nov 2020 15:30:36 +0200
Message-Id: <20201104133040.1125369-15-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Remove in-kernel route notifications when the configuration of their
nexthop changes.

These notifications are unnecessary because the route still uses the
same nexthop ID. A separate notification for the nexthop change itself
is now sent in the nexthop notification chain.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/fib_trie.c | 9 ---------
 net/ipv6/route.c    | 5 -----
 2 files changed, 14 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index ffc5332f1390..28117c05dc35 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2100,15 +2100,6 @@ static void __fib_info_notify_update(struct net *net, struct fib_table *tb,
 			rtmsg_fib(RTM_NEWROUTE, htonl(n->key), fa,
 				  KEYLENGTH - fa->fa_slen, tb->tb_id,
 				  info, NLM_F_REPLACE);
-
-			/* call_fib_entry_notifiers will be removed when
-			 * in-kernel notifier is implemented and supported
-			 * for nexthop objects
-			 */
-			call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_REPLACE,
-						 n->key,
-						 KEYLENGTH - fa->fa_slen, fa,
-						 NULL);
 		}
 	}
 }
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7e0ce7af8234..f91a689edafd 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6039,11 +6039,6 @@ void fib6_rt_update(struct net *net, struct fib6_info *rt,
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
-	/* call_fib6_entry_notifiers will be removed when in-kernel notifier
-	 * is implemented and supported for nexthop objects
-	 */
-	call_fib6_entry_notifiers(net, FIB_EVENT_ENTRY_REPLACE, rt, NULL);
-
 	skb = nlmsg_new(rt6_nlmsg_size(rt), gfp_any());
 	if (!skb)
 		goto errout;
-- 
2.26.2


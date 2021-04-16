Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAD63624B8
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 17:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236203AbhDPP4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 11:56:52 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38675 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235192AbhDPP4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 11:56:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4F5D35C00EC;
        Fri, 16 Apr 2021 11:56:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 16 Apr 2021 11:56:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=r+w4py39nss7IVZBzIJN3ZpC2AyC5HJWOIRQMlYnYJ0=; b=BiRVusSH
        bw4iDKn3Jk2YexvlLGkV5R/UGXAtnWgXtuhEvwfR2xow2ZeiFPit76eJA+zEVAwN
        Ky6BI+sCc0ZoC37JEG4nFhr/uadjq5sJUPYqRqbwHVy/imEzPJOjDmqTTAjfQ29+
        6ZIp1AoAkwCdieOkhk86rwTmXVTsSXZovMZhqu0P9Lh2WzO5KAPIgGtEVAiosH5t
        2fDIlfqIRuX4vJ9v+M+2g2LQH8Wt+zMT7t4w877sPuLYK6E6o95qSIRW7ylaBq/Y
        b2MOsMOka/lP7DI3EDcB5wFaiFPJAcovLNfRewvkd1QN07I9GmCoNhHF3e/B5w2r
        aau1Xn2DXGpUoA==
X-ME-Sender: <xms:qbN5YB2qDpP70UAioMA90RrxQXCehSRSw9K1hT2pc2yJHbL8a4PK6g>
    <xme:qbN5YIGYxgp-MCc1mB7p-ZiGUKW7d4lM9CeT96fPYPrtwmx8ez28regJvoZ2vBbWf
    zIpMiaeGRjTc9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelhedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:qbN5YB4t329voHF21vaq9--wLbxh5SCWGFZi7O9DarPUaYxCW3sYiA>
    <xmx:qbN5YO2VGgVhjzcFG7kheX-YEbAvjWZ-789hGOnIcPXZgOV674ad9w>
    <xmx:qbN5YEGIxAezuYl3WVE0s6j0IsDpOu77Oa3GclJj1hpeGtr619XLTA>
    <xmx:qbN5YICMiPYVqFsVrMyzuLDn9KBRhcBv0HlG8PJkULSHj3kCReoiTg>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6279E1080063;
        Fri, 16 Apr 2021 11:56:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/2] nexthop: Restart nexthop dump based on last dumped nexthop identifier
Date:   Fri, 16 Apr 2021 18:55:34 +0300
Message-Id: <20210416155535.1694714-2-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416155535.1694714-1-idosch@idosch.org>
References: <20210416155535.1694714-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, a multi-part nexthop dump is restarted based on the number of
nexthops that have been dumped so far. This can result in a lot of
nexthops not being dumped when nexthops are simultaneously deleted:

 # ip nexthop | wc -l
 65536
 # ip nexthop flush
 Dump was interrupted and may be inconsistent.
 Flushed 36040 nexthops
 # ip nexthop | wc -l
 29496

Instead, restart the dump based on the nexthop identifier (fixed number)
of the last successfully dumped nexthop:

 # ip nexthop | wc -l
 65536
 # ip nexthop flush
 Dump was interrupted and may be inconsistent.
 Flushed 65536 nexthops
 # ip nexthop | wc -l
 0

Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Tested-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/ipv4/nexthop.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5a2fc8798d20..4075230b14c6 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -3140,26 +3140,24 @@ static int rtm_dump_walk_nexthops(struct sk_buff *skb,
 				  void *data)
 {
 	struct rb_node *node;
-	int idx = 0, s_idx;
+	int s_idx;
 	int err;
 
 	s_idx = ctx->idx;
 	for (node = rb_first(root); node; node = rb_next(node)) {
 		struct nexthop *nh;
 
-		if (idx < s_idx)
-			goto cont;
-
 		nh = rb_entry(node, struct nexthop, rb_node);
-		ctx->idx = idx;
+		if (nh->id < s_idx)
+			continue;
+
+		ctx->idx = nh->id;
 		err = nh_cb(skb, cb, nh, data);
 		if (err)
 			return err;
-cont:
-		idx++;
 	}
 
-	ctx->idx = idx;
+	ctx->idx++;
 	return 0;
 }
 
-- 
2.30.2


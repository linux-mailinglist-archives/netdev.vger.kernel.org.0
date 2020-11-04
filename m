Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55F62A6532
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbgKDNbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:31:45 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36269 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729916AbgKDNbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:43 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D1F5E5C00F8;
        Wed,  4 Nov 2020 08:31:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/1XcpUlCGzuF4VbW81KmJkKm+zVpuDvn+Fl4inxmTJQ=; b=rFwnSjKr
        ZgfLfF3uEfeIw0n5BhFDb3lC6hiYA2EPQWppw4b959v7HjhRjZEvoRHwUKkG2J+3
        +LJotKq88bTOdZoi+63dSFf4BinUVj7DW3TplmW8irH0mo+rRcPP6/gruiGyf47M
        toRq0PFIOYxmyJzmJNrVgDONR6DkNoo1M4mF6jfxU15KWxxCqEOAsE6F1ep9YIYx
        kFzmlw7vdT6B0UZsSSB80iFslK46515AX2lL8PKr+KY1W0UohV1hLLDOcBIdEPfJ
        N5ZRaCAGwfmj7oGFp2Z8ITwKI6rCRxaEpy38bjR0khFHwj7g+5mJwNsf14fd3xI4
        +XTXTfXcOGP6sg==
X-ME-Sender: <xms:Pq2iXwgIa5nSPJODJRVp0mn-Rd1eZDzIxNG9FNx0EekVnb7IvQJ7Pw>
    <xme:Pq2iX5C3Hxvwnv2uI86ejQuDTldlR4r1lTaztJn6nRB8OU1elWCn_n4fzi59Z9rkj
    aIlqkQ2VC0b_6M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Pq2iX4HgjBvcjI_MRRfE27WzBxP4CJa3upfCDwF1JToQ3BYWfZp-AQ>
    <xmx:Pq2iXxTpfmYtHMOwM2W_O-shl7yGaA66ycNCqc2Ccr_pwE1hIDO9mQ>
    <xmx:Pq2iX9z5JByaJNGp8y-caNubJ_bAEj7iYnGRoxq5GWWacKUs2LdgrA>
    <xmx:Pq2iX1-uG5TXylzXpliVrcUS0TislHtsuk38hOp1zOZWDJie2peVVQ>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E1B83064610;
        Wed,  4 Nov 2020 08:31:41 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/18] nexthop: Pass extack to nexthop notifier
Date:   Wed,  4 Nov 2020 15:30:24 +0200
Message-Id: <20201104133040.1125369-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The next patch will add extack to the notification info. This allows
listeners to veto notifications and communicate the reason to user space.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/nexthop.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 0dc43ad28eb9..f677cb12fd56 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -38,7 +38,8 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
 
 static int call_nexthop_notifiers(struct net *net,
 				  enum nexthop_event_type event_type,
-				  struct nexthop *nh)
+				  struct nexthop *nh,
+				  struct netlink_ext_ack *extack)
 {
 	int err;
 
@@ -907,7 +908,7 @@ static void __remove_nexthop(struct net *net, struct nexthop *nh,
 static void remove_nexthop(struct net *net, struct nexthop *nh,
 			   struct nl_info *nlinfo)
 {
-	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
+	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh, NULL);
 
 	/* remove from the tree */
 	rb_erase(&nh->rb_node, &net->nexthop.rb_root);
-- 
2.26.2


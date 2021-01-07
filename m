Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9493E2ED30D
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 15:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbhAGOuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 09:50:20 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:45389 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727327AbhAGOuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 09:50:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C6E7D184E;
        Thu,  7 Jan 2021 09:49:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 07 Jan 2021 09:49:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=3uqolt8wtewxS9weK5oBsNS237SgVSHJCpyxviZjkcA=; b=B0T8dshv
        ifMzLEMOn/nV53FkHUvURrlkjcpj4S4rNrSYkLzdbc/b3JGFzVb/r54YK0Nkf6Ff
        +8FC0CYJZUms/gXL8dIqlMzqpghEfPBOGvVD6IpC8ePcsOUxpGN4dLtqBBtBqWj1
        2Jgq84rHREEpyqPKj145DbESQIyFBJCi/VXOd9t4jI0Ze7Y79LNf46hyPSJ/ZsDh
        Oh9rmPhcbcsEw9AR1THWHygWQpfww0U6StQ9Aov4z6o6za8UhI2ba/ZzrSfvPPiE
        PvSxBNXgPPP268ouHb04yskLPK5dA4VFurJ5ffUydbPSBIsQJHHnUGZmGeSvbLwq
        K83ifRbeh91Yuw==
X-ME-Sender: <xms:aR_3XweIY7XKQi6mDqWHaI4ak4WYPPG7kCCixdhfyjQkkfLPiTuNpg>
    <xme:aR_3XyNRAWi-8FbZLaJu7o_k-f3qQo_ME66uI8dgjFcJjnU7of3ba8ygA5FVFYBeg
    Mosqu6Mx8JPzD8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegvddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:aR_3XxhWGZWFVjrygB4UICIvl1K2chkOBMHX_BEPKoMFxpYR8ErshA>
    <xmx:aR_3X1-kJrIXWkav7ewYOdgOMjrjVjeS72F6wsB27l_vE7j2KotsgA>
    <xmx:aR_3X8sa-bc2ZJzYbMbdfHQA2MIOH6bgK1ANIDkMZZV99-W4YWbCug>
    <xmx:aR_3X2UXUjVQXLRFzo2ws9FVmI1_PEfVuAtE1PBV2HToKPo8T2fxfg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 203DB1080059;
        Thu,  7 Jan 2021 09:49:10 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        dsahern@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 3/4] nexthop: Bounce NHA_GATEWAY in FDB nexthop groups
Date:   Thu,  7 Jan 2021 16:48:23 +0200
Message-Id: <20210107144824.1135691-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107144824.1135691-1-idosch@idosch.org>
References: <20210107144824.1135691-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The function nh_check_attr_group() is called to validate nexthop groups.
The intention of that code seems to have been to bounce all attributes
above NHA_GROUP_TYPE except for NHA_FDB. However instead it bounces all
these attributes except when NHA_FDB attribute is present--then it accepts
them.

NHA_FDB validation that takes place before, in rtm_to_nh_config(), already
bounces NHA_OIF, NHA_BLACKHOLE, NHA_ENCAP and NHA_ENCAP_TYPE. Yet further
back, NHA_GROUPS and NHA_MASTER are bounced unconditionally.

But that still leaves NHA_GATEWAY as an attribute that would be accepted in
FDB nexthop groups (with no meaning), so long as it keeps the address
family as unspecified:

 # ip nexthop add id 1 fdb via 127.0.0.1
 # ip nexthop add id 10 fdb via default group 1

The nexthop code is still relatively new and likely not used very broadly,
and the FDB bits are newer still. Even though there is a reproducer out
there, it relies on an improbable gateway arguments "via default", "via
all" or "via any". Given all this, I believe it is OK to reformulate the
condition to do the right thing and bounce NHA_GATEWAY.

Fixes: 38428d68719c ("nexthop: support for fdb ecmp nexthops")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 712cdc061cde..e53e43aef785 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -627,7 +627,7 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
 	for (i = NHA_GROUP_TYPE + 1; i < __NHA_MAX; ++i) {
 		if (!tb[i])
 			continue;
-		if (tb[NHA_FDB])
+		if (i == NHA_FDB)
 			continue;
 		NL_SET_ERR_MSG(extack,
 			       "No other attributes can be set in nexthop groups");
-- 
2.29.2


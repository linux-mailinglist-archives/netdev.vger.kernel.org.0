Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F72A25ABF3
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 15:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIBNTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 09:19:23 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36119 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726226AbgIBNRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 09:17:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E1CB25C01AC;
        Wed,  2 Sep 2020 09:17:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 02 Sep 2020 09:17:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QG+JN7xsAp6b0PPyR
        OsE4BiY3JyqmQ4XHjcZmtPvdUU=; b=igBG5KpzAZy27g6lhQPJEHIrevKTCpTDT
        Mw+bqJG4tCZQ2LjeWT6DxJAniTe5HOAL/suqERzdbjWAvUI1xQwU+CYiY9NIRdqO
        od3Y7Ov136jsatEqNkf70t4NTKlZK5wTWCZpFmBNE8Zen2QjBmomuAReRQesxxNy
        ScrUhk13vrCkBStNHvSKSjC1Wb1wS/8upq/t4g34Y0NzxUJtGNBa7cncG0xJQrxh
        PoQ6ZfE293Xvi+AePWPTMnhqCnifeoP2EWEw4Dvnlhm5S4zNPTUlI4YSX5YxfVza
        6nRvqrReszf3t9Eu89ZpZIu145CjZclC0/FAyOE8RUrOAAJN692mA==
X-ME-Sender: <xms:aptPX5UInG9HBWNp-BzDUeUKnYTah5yMrMnVppf-Qy1-wlKk2wM6gg>
    <xme:aptPX5mhdxyMQY-lHByAmcMlVqAB7YbTto15jxP76vG9b2xznfsLg7zAO-5Sgj59s
    aqZ39D9a4wcBTM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefledgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrfeeirdejudenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:aptPX1aciziBf_PD2OLCg5jDzhY5lOktVBr-v8lnOGnDDWaq0XJiEw>
    <xmx:aptPX8VAEnr0uGZiA_X57MrvkKBiACSOam-SkhK3cv7iUlEn6ghPvw>
    <xmx:aptPXzlW1if2_JC9JtxW186cpy0_rtB2RpFXxzm3F_HsIiHWv0AM7Q>
    <xmx:aptPX4yRNtxvQE0wby7JJQiitjbbiaL6lRZmdouGtF4PGvv2oNaDNg>
Received: from shredder.mtl.com (igld-84-229-36-71.inter.net.il [84.229.36.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id D409830600A6;
        Wed,  2 Sep 2020 09:17:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ssuryaextr@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] ipv6: Fix sysctl max for fib_multipath_hash_policy
Date:   Wed,  2 Sep 2020 16:16:59 +0300
Message-Id: <20200902131659.2051734-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Cited commit added the possible value of '2', but it cannot be set. Fix
it by adjusting the maximum value to '2'. This is consistent with the
corresponding IPv4 sysctl.

Before:

# sysctl -w net.ipv6.fib_multipath_hash_policy=2
sysctl: setting key "net.ipv6.fib_multipath_hash_policy": Invalid argument
net.ipv6.fib_multipath_hash_policy = 2
# sysctl net.ipv6.fib_multipath_hash_policy
net.ipv6.fib_multipath_hash_policy = 0

After:

# sysctl -w net.ipv6.fib_multipath_hash_policy=2
net.ipv6.fib_multipath_hash_policy = 2
# sysctl net.ipv6.fib_multipath_hash_policy
net.ipv6.fib_multipath_hash_policy = 2

Fixes: d8f74f0975d8 ("ipv6: Support multipath hashing on inner IP pkts")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv6/sysctl_net_ipv6.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index fac2135aa47b..5b60a4bdd36a 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -21,6 +21,7 @@
 #include <net/calipso.h>
 #endif
 
+static int two = 2;
 static int flowlabel_reflect_max = 0x7;
 static int auto_flowlabels_min;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
@@ -150,7 +151,7 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler   = proc_rt6_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "seg6_flowlabel",
-- 
2.26.2


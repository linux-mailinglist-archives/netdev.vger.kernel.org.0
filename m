Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58355F6A48
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 17:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiJFPIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 11:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiJFPIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 11:08:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C626A8A7DD
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 08:08:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64CA4619D7
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 15:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73118C433D6;
        Thu,  6 Oct 2022 15:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665068925;
        bh=2qW+XNIgfVM7t955OqrqlE4po7DIpRtmAJc1p66VPos=;
        h=From:To:Cc:Subject:Date:From;
        b=oaNab+3hRdWGNfGH5CUfOC+Ghcnx9yXrzRLnJCmXqwj1XAGC8xLSAt529oqAE/LdD
         J/Hcj+3oLcmJuWaAOHHb4/ZRY6OUc+YhyB139c/++7XKd9fWeXD1bNApaay4kptWlD
         VF6FA3NJYhfT/OjuoWQVtD//+sKwAA7pGRO5I+pP1jppmvF5x0bZwzKwayxoI0WrmS
         eLP6Ylk7dFY3RwOf0M67Z96RsSN5zhVf59rsFnxEo4KnAGYW2jE1p4mzL55lcAYFDi
         YE8LkYIEcqhaN89Gqo7X6MGExiabf3xRZVP5J6tJtKJul/AcR5X+AthEsbdPWG+cIt
         jgJuFSIOm53IQ==
From:   David Ahern <dsahern@kernel.org>
To:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        David Ahern <dsahern@kernel.org>,
        Gwangun Jung <exsociety@gmail.com>
Subject: [PATCH v2 net] ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference
Date:   Thu,  6 Oct 2022 09:08:42 -0600
Message-Id: <20221006150842.9336-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gwangun Jung reported a slab-out-of-bounds access in fib_nh_match:
    fib_nh_match+0xf98/0x1130 linux-6.0-rc7/net/ipv4/fib_semantics.c:961
    fib_table_delete+0x5f3/0xa40 linux-6.0-rc7/net/ipv4/fib_trie.c:1753
    inet_rtm_delroute+0x2b3/0x380 linux-6.0-rc7/net/ipv4/fib_frontend.c:874

Separate nexthop objects are mutually exclusive with the legacy
multipath spec. Fix fib_nh_match to return if the config for the
to be deleted route contains a multipath spec while the fib_info
is using a nexthop object.

Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
Fixes: 6bf92d70e690 ("net: ipv4: fix route with nexthop object delete warning")
Reported-by: Gwangun Jung <exsociety@gmail.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
v2:
- moved the fi->nh check up and added second Fixes tag (Ido's comments)

 net/ipv4/fib_semantics.c                    | 12 ++++++++----
 tools/testing/selftests/net/fib_nexthops.sh |  5 +++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 2dc97583d279..85fc4afec7fb 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -888,13 +888,13 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		return 1;
 	}
 
+	/* cannot match on nexthop object attributes */
+	if (fi->nh)
+		return 1;
+
 	if (cfg->fc_oif || cfg->fc_gw_family) {
 		struct fib_nh *nh;
 
-		/* cannot match on nexthop object attributes */
-		if (fi->nh)
-			return 1;
-
 		nh = fib_info_nh(fi, 0);
 		if (cfg->fc_encap) {
 			if (fib_encap_match(net, cfg->fc_encap_type,
@@ -926,6 +926,10 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 	if (!cfg->fc_mp)
 		return 0;
 
+	/* multipath spec and nexthop id are mutually exclusive */
+	if (fi->nh)
+		return 1;
+
 	rtnh = cfg->fc_mp;
 	remaining = cfg->fc_mp_len;
 
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index d5a0dd548989..15556138de76 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1223,6 +1223,11 @@ ipv4_fcnal()
 	log_test $rc 0 "Delete nexthop route warning"
 	run_cmd "$IP route delete 172.16.101.1/32 nhid 12"
 	run_cmd "$IP nexthop del id 12"
+
+	run_cmd "$IP nexthop add id 21 via 172.16.1.6 dev veth1"
+	run_cmd "$IP ro add 172.16.101.0/24 nhid 21"
+	run_cmd "$IP ro del 172.16.101.0/24 nexthop via 172.16.1.7 dev veth1 nexthop via 172.16.1.8 dev veth1"
+	log_test $? 1 "Delete multipath route with only nh id based entry"
 }
 
 ipv4_grp_fcnal()
-- 
2.25.1


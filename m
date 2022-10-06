Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C193D5F6BF8
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 18:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiJFQsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 12:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbiJFQsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 12:48:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DE1733E4
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 09:48:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E0CD61A2F
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 16:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52318C433D6;
        Thu,  6 Oct 2022 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665074932;
        bh=lk2Wr45gOyfdR66oU4K/Wx7t8pVZ/hBfBJ219QJ7rKI=;
        h=From:To:Cc:Subject:Date:From;
        b=J7XqPJ273LK0/V5s6rNRst8z9TexwsqVV/Uj1K9Pl0xsydLkFZYWLjvDAMfbdq+KH
         19GDGU7nrcKGasly34X1+/TrjPjn6poqZa8qyS9UM7P0kMC1oVK/xv33FINEU+0tir
         I2NSRVBtQaruwxkM19UZQWOjuo03LjBhK71X3uckS86qDFbjFROv55jn/NvbCF097F
         3XCj2w+NrrFlC+S7zWsPZeiDVFpr7gb8MUBdomnwewoSdF9Exl5kptc4ZpD6ebiCsL
         gkg0yqNR/odp9C5BmmcZcuA1FIjP4Usepug52GUUgcGiRDn/XdW0TZ+Ii1CwjRCGU3
         s161OZBCPv0Bw==
From:   David Ahern <dsahern@kernel.org>
To:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        David Ahern <dsahern@kernel.org>,
        Gwangun Jung <exsociety@gmail.com>
Subject: [PATCH v3 net] ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference
Date:   Thu,  6 Oct 2022 10:48:49 -0600
Message-Id: <20221006164849.9386-1-dsahern@kernel.org>
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
v3:
- removed nh check in multipath; forgot to remove it in v2
- fixed expected return code on selftest

v2:
- moved the fi->nh check up and added second Fixes tag (Ido's comments)

 net/ipv4/fib_semantics.c                    | 8 ++++----
 tools/testing/selftests/net/fib_nexthops.sh | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 2dc97583d279..e9a7f70a54df 100644
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
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index d5a0dd548989..ee5e98204d3d 100755
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
+	log_test $? 2 "Delete multipath route with only nh id based entry"
 }
 
 ipv4_grp_fcnal()
-- 
2.25.1


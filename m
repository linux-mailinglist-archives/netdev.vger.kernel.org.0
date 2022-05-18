Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F385C52BA23
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbiERMdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237024AbiERMb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:31:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E13719C769;
        Wed, 18 May 2022 05:29:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAE52B81FBE;
        Wed, 18 May 2022 12:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AFFC34115;
        Wed, 18 May 2022 12:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876938;
        bh=k7KBepZ8oLQPUjB1SoQPMYCx0dWhM4MpLxwmOih5HSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gitqQhvq+NFTaaHZkv+P3psOjD245MkL6zDPn0wA24UuxDoWRjLQkHHFSgKv3+fdM
         whBF6ezcOnDIsPzEaWN/ktmpOzqSjQqcugW+Zxb2M4Sl6dIBKrhSw73irJY/t7otAD
         Np0j+tnTrhGeY22oXOHRZ+R+H4efvzRT0iwtkrqVCBDvc1mb3QedViSOoDZejwFH7o
         G2LHbt/CPmFoQ1myCa4qRSHADI6MIUr9Nmu/uV8VTo71kBeGadN+fltUr2xiNi2Zb3
         PQDjfB6EsgFAB4geQYxX8DQ9KRET9hPTGMtm7iS4hs1JwcNWUnptUO8r4ab+fpof/9
         00NN7Sf9LGkXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/13] selftests: add ping test with ping_group_range tuned
Date:   Wed, 18 May 2022 08:28:35 -0400
Message-Id: <20220518122844.343220-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122844.343220-1-sashal@kernel.org>
References: <20220518122844.343220-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit e71b7f1f44d3d88c677769c85ef0171caf9fc89f ]

The 'ping' utility is able to manage two kind of sockets (raw or icmp),
depending on the sysctl ping_group_range. By default, ping_group_range is
set to '1 0', which forces ping to use an ip raw socket.

Let's replay the ping tests by allowing 'ping' to use the ip icmp socket.
After the previous patch, ipv4 tests results are the same with both kinds
of socket. For ipv6, there are a lot a new failures (the previous patch
fixes only two cases).

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index ace976d89125..4a11ea2261cb 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -794,10 +794,16 @@ ipv4_ping()
 	setup
 	set_sysctl net.ipv4.raw_l3mdev_accept=1 2>/dev/null
 	ipv4_ping_novrf
+	setup
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
+	ipv4_ping_novrf
 
 	log_subsection "With VRF"
 	setup "yes"
 	ipv4_ping_vrf
+	setup "yes"
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
+	ipv4_ping_vrf
 }
 
 ################################################################################
@@ -2261,10 +2267,16 @@ ipv6_ping()
 	log_subsection "No VRF"
 	setup
 	ipv6_ping_novrf
+	setup
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
+	ipv6_ping_novrf
 
 	log_subsection "With VRF"
 	setup "yes"
 	ipv6_ping_vrf
+	setup "yes"
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
+	ipv6_ping_vrf
 }
 
 ################################################################################
-- 
2.35.1


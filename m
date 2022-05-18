Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EC252BA87
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbiERMeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236992AbiERMdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:33:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FC7170F2E;
        Wed, 18 May 2022 05:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07353615FE;
        Wed, 18 May 2022 12:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F3AC385AA;
        Wed, 18 May 2022 12:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876975;
        bh=Em6VDN095tlB4mBZm4+ai7DDqRwvok4lEQCa+cyHyY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=As08Jclf8S7kvXO14YaUqnkAMmNdoDqFP8sF74c3P82ds+AikGYomnfq3T17VLFoh
         uY5p+K20akGybkhN/SHTqHDCxQ3InrLP7sLUZcVf08W081KWUTy/YjptP02WMTPCVA
         GI4dwd8ptXEh1hHIRs+SBiHJUfrhDmB6VF5qJMUrK3fEVsFmCixlqGKf8R+nOCAVVG
         ILSdGceDPOT5qaAoK1sVhj9MaxZq9fpoDmslyxHX0DDeuHhLeoX0y5q9VhsH3Hfcvv
         FXbIZjz3RGPDj87sSCainGI4XUWOXIs/Y2bs8yerDmon+hYq5U8c79ArTSbC/O1y1O
         Y9vFrt5/l2nBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 3/6] selftests: add ping test with ping_group_range tuned
Date:   Wed, 18 May 2022 08:29:26 -0400
Message-Id: <20220518122929.343615-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122929.343615-1-sashal@kernel.org>
References: <20220518122929.343615-1-sashal@kernel.org>
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
index 157822331954..d2ac09b35dcf 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -757,10 +757,16 @@ ipv4_ping()
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
@@ -2005,10 +2011,16 @@ ipv6_ping()
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


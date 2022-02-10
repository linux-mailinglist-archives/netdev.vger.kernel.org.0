Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D9D4B02C3
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiBJCAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:00:31 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiBJB7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:59:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCEF2E6;
        Wed,  9 Feb 2022 17:56:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88105616DB;
        Thu, 10 Feb 2022 00:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9C7C340EF;
        Thu, 10 Feb 2022 00:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644453418;
        bh=PxIkbyZwGV55G2pEaoZIBXGoY5ZXrks2yxbuhwg1wOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ap5ns3D4pe7Ra/ldu2LPeT0+lP7jpdKNSoAP5aFQSkRTuaxO7Xns0/PxM/1tSVSwG
         89c1sacklkY8PRTImuV+aqKr2+Rn8OnwaLS6PpcSW1DtzvrKwAWfDjYN+ld2tJXvCi
         ZP1lCMafwwmHkLveBhg6kr7JvD7Qk23xqu6ZEyfZy0fOkBGFJvxvONNhy+Q0a5osb4
         WklLBBfAfE13qRwRaD1nLr4gKh84iivg5m/A9ZSGw3tN6fD3HHC2Jp1iAZUWQmB24n
         8HCiF9SwhACqmg1Nhaabb3r0ACiGEm4X6HsWQ91GRvrr9spF2Vdw35OiFCadryeMKD
         89mcqJ3otjT0w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/11] selftests: net: cmsg_so_mark: test ICMP and RAW sockets
Date:   Wed,  9 Feb 2022 16:36:45 -0800
Message-Id: <20220210003649.3120861-8-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210003649.3120861-1-kuba@kernel.org>
References: <20220210003649.3120861-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new capabilities of cmsg_sender to test ICMP and RAW sockets,
previously only UDP was tested.

Before SO_MARK support was added to ICMPv6:

  # ./cmsg_so_mark.sh
   Case ICMP rejection returned 0, expected 1
  FAIL - 1/12 cases failed

After:

  # ./cmsg_so_mark.sh
  OK

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/cmsg_so_mark.sh | 24 ++++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/cmsg_so_mark.sh b/tools/testing/selftests/net/cmsg_so_mark.sh
index 841d706dc91b..925f6b9deee2 100755
--- a/tools/testing/selftests/net/cmsg_so_mark.sh
+++ b/tools/testing/selftests/net/cmsg_so_mark.sh
@@ -18,6 +18,8 @@ trap cleanup EXIT
 # Namespaces
 ip netns add $NS
 
+ip netns exec $NS sysctl -w net.ipv4.ping_group_range='0 2147483647' > /dev/null
+
 # Connectivity
 ip -netns $NS link add type dummy
 ip -netns $NS link set dev dummy0 up
@@ -41,15 +43,21 @@ check_result() {
     fi
 }
 
-ip netns exec $NS ./cmsg_sender -m $((MARK + 1)) $TGT4 1234
-check_result $? 0 "IPv4 pass"
-ip netns exec $NS ./cmsg_sender -m $((MARK + 1)) $TGT6 1234
-check_result $? 0 "IPv6 pass"
+for i in 4 6; do
+    [ $i == 4 ] && TGT=$TGT4 || TGT=$TGT6
+
+    for p in u i r; do
+	[ $p == "u" ] && prot=UDP
+	[ $p == "i" ] && prot=ICMP
+	[ $p == "r" ] && prot=RAW
+
+	ip netns exec $NS ./cmsg_sender -$i -p $p -m $((MARK + 1)) $TGT 1234
+	check_result $? 0 "$prot pass"
 
-ip netns exec $NS ./cmsg_sender -s -m $MARK $TGT4 1234
-check_result $? 1 "IPv4 rejection"
-ip netns exec $NS ./cmsg_sender -s -m $MARK $TGT6 1234
-check_result $? 1 "IPv6 rejection"
+	ip netns exec $NS ./cmsg_sender -$i -p $p -m $MARK -s $TGT 1234
+	check_result $? 1 "$prot rejection"
+    done
+done
 
 # Summary
 if [ $BAD -ne 0 ]; then
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494AA6596AD
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 10:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiL3JTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 04:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbiL3JTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 04:19:48 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EA41A396;
        Fri, 30 Dec 2022 01:19:46 -0800 (PST)
Received: from localhost.localdomain (1.general.phlin.us.vpn [10.172.66.38])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 61FE442825;
        Fri, 30 Dec 2022 09:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1672391985;
        bh=D48BBPH0c/QmnKspFj0lFILjiX0Xqa+/ho/gHK/IkT8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Y8rAPf1C+aGIENKLVCcix9uPn3LEThLTXQanq6pNLY8iS4/kOeM59ENh1FbPadLZO
         NM+ro9sZQWV3n7vgeMCXp2L4HY7by325g41Xoi7+iCRauuHhMdgWMQV+36tg1Ff2rF
         AhyeJFSz/lcgzzx11br7YgYv/Uv76hPNpK1AZ/no17BbGXThypqpzjgY+Mx5UC3BsD
         vrZFQPeJBGl9vEWSDZcVmGYdBCfK3ZJZesryol1O1u+goPVHFzTaGPPD8WYM1WJuOU
         OdnH3MaKUq3QyfXI+QE99Izlk51KzGRRZW62tQsNsdFWgsS38ReZlz5jiNL760wkL2
         VpDQNVetejopg==
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     po-hsu.lin@canonical.com, dsahern@kernel.org, prestwoj@gmail.com,
        shuah@kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net
Subject: [PATCH 1/2] selftests: net: fix cleanup_v6() for arp_ndisc_evict_nocarrier
Date:   Fri, 30 Dec 2022 17:18:28 +0800
Message-Id: <20221230091829.217007-2-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221230091829.217007-1-po-hsu.lin@canonical.com>
References: <20221230091829.217007-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cleanup_v6() will cause the arp_ndisc_evict_nocarrier script exit
with 255 (No such file or directory), even the tests are good:

 # selftests: net: arp_ndisc_evict_nocarrier.sh
 # run arp_evict_nocarrier=1 test
 # RTNETLINK answers: File exists
 # ok
 # run arp_evict_nocarrier=0 test
 # RTNETLINK answers: File exists
 # ok
 # run all.arp_evict_nocarrier=0 test
 # RTNETLINK answers: File exists
 # ok
 # run ndisc_evict_nocarrier=1 test
 # ok
 # run ndisc_evict_nocarrier=0 test
 # ok
 # run all.ndisc_evict_nocarrier=0 test
 # ok
 not ok 1 selftests: net: arp_ndisc_evict_nocarrier.sh # exit=255

This is because it's trying to modify the parameter for ipv4 instead.

Also, tests for ipv6 (run_ndisc_evict_nocarrier_enabled() and
run_ndisc_evict_nocarrier_disabled() are working on veth1, reflect
this fact in cleanup_v6().

Fixes: f86ca07eb531 ("selftests: net: add arp_ndisc_evict_nocarrier")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
index b5af08a..b4ec1ee 100755
--- a/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
+++ b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
@@ -24,8 +24,8 @@ cleanup_v6()
     ip netns del me
     ip netns del peer
 
-    sysctl -w net.ipv4.conf.veth0.ndisc_evict_nocarrier=1 >/dev/null 2>&1
-    sysctl -w net.ipv4.conf.all.ndisc_evict_nocarrier=1 >/dev/null 2>&1
+    sysctl -w net.ipv6.conf.veth1.ndisc_evict_nocarrier=1 >/dev/null 2>&1
+    sysctl -w net.ipv6.conf.all.ndisc_evict_nocarrier=1 >/dev/null 2>&1
 }
 
 create_ns()
-- 
2.7.4


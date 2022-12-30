Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D786596B2
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 10:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbiL3JUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 04:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234836AbiL3JTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 04:19:55 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44181A38A;
        Fri, 30 Dec 2022 01:19:53 -0800 (PST)
Received: from localhost.localdomain (1.general.phlin.us.vpn [10.172.66.38])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 97AD04282F;
        Fri, 30 Dec 2022 09:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1672391992;
        bh=8EctNHcSZJ4z/u91cUEbWtjzKmELejvlmw6JU4LB5p4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Ahm9cPTUtlZpzvmNofU4NJ23p+VRNvc3ISDPyTQYCfDHx7KpxYenur+oST52+9jv2
         1ZH6YwI7GvvVJcSp+B3W7RC6SRsdxHjeCOChedtw7hQEYuN/6D+iLv8Tij7uk1UDyi
         st5zjjS+xP8pZS04CZ9sXqJIgAbA2RCBkGAL3relUuCSKh6xLc+3XOHU+ZLx+weanW
         OdZ4iQRMJorlTs7n6VGMfbFN3N0B8OnJiNnvx8OXAcaQjpaCV2ObdlaRP+RdG4PhNG
         PTGP2W3/gscD/mIbemURjbEOfy1f4Nu5Zwk0lvi1n4Q27keo1jIyhLtMyupeEblE/V
         sVo6nKB4PIddA==
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     po-hsu.lin@canonical.com, dsahern@kernel.org, prestwoj@gmail.com,
        shuah@kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net
Subject: [PATCH 2/2] selftests: net: return non-zero for failures reported in arp_ndisc_evict_nocarrier
Date:   Fri, 30 Dec 2022 17:18:29 +0800
Message-Id: <20221230091829.217007-3-po-hsu.lin@canonical.com>
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

Return non-zero return value if there is any failure reported in this
script during the test. Otherwise it can only reflect the status of
the last command.

Fixes: f86ca07eb531 ("selftests: net: add arp_ndisc_evict_nocarrier")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
index b4ec1ee..4a110bb 100755
--- a/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
+++ b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
@@ -18,6 +18,7 @@ readonly V4_ADDR1=10.0.10.2
 readonly V6_ADDR0=2001:db8:91::1
 readonly V6_ADDR1=2001:db8:91::2
 nsid=100
+ret=0
 
 cleanup_v6()
 {
@@ -61,7 +62,7 @@ setup_v6() {
     if [ $? -ne 0 ]; then
         cleanup_v6
         echo "failed"
-        exit
+        exit 1
     fi
 
     # Set veth2 down, which will put veth1 in NOCARRIER state
@@ -88,7 +89,7 @@ setup_v4() {
     if [ $? -ne 0 ]; then
         cleanup_v4
         echo "failed"
-        exit
+        exit 1
     fi
 
     # Set veth1 down, which will put veth0 in NOCARRIER state
@@ -115,6 +116,7 @@ run_arp_evict_nocarrier_enabled() {
 
     if [ $? -eq 0 ];then
         echo "failed"
+        ret=1
     else
         echo "ok"
     fi
@@ -134,6 +136,7 @@ run_arp_evict_nocarrier_disabled() {
         echo "ok"
     else
         echo "failed"
+        ret=1
     fi
 
     cleanup_v4
@@ -164,6 +167,7 @@ run_ndisc_evict_nocarrier_enabled() {
 
     if [ $? -eq 0 ];then
         echo "failed"
+        ret=1
     else
         echo "ok"
     fi
@@ -182,6 +186,7 @@ run_ndisc_evict_nocarrier_disabled() {
         echo "ok"
     else
         echo "failed"
+        ret=1
     fi
 
     cleanup_v6
@@ -198,6 +203,7 @@ run_ndisc_evict_nocarrier_disabled_all() {
         echo "ok"
     else
         echo "failed"
+        ret=1
     fi
 
     cleanup_v6
@@ -218,3 +224,4 @@ if [ "$(id -u)" -ne 0 ];then
 fi
 
 run_all_tests
+exit $ret
-- 
2.7.4


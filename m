Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C434313688
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhBHPMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbhBHPK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 10:10:56 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400E0C061786;
        Mon,  8 Feb 2021 07:10:17 -0800 (PST)
Received: from localhost ([::1]:57340 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1l98B3-00073M-5y; Mon, 08 Feb 2021 16:10:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Shuah Khan <shuah@kernel.org>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH] selftests: tc-testing: u32: Add tests covering sample option
Date:   Mon,  8 Feb 2021 16:10:04 +0100
Message-Id: <20210208151004.26501-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel's key folding basically consists of shifting away least
significant zero bits in mask and masking the resulting value with
(divisor - 1). Test for u32's 'sample' option to behave identical.

Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
These tests require my iproute2 patch 'tc: u32: Fix key folding in
sample option' in order to pass.
---
 .../tc-testing/tc-tests/filters/u32.json      | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/u32.json b/tools/testing/selftests/tc-testing/tc-tests/filters/u32.json
index e09d3c0e307f6..bd64a4bf11abf 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/u32.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/u32.json
@@ -201,5 +201,51 @@
         "teardown": [
             "$TC qdisc del dev $DEV1 ingress"
         ]
+    },
+    {
+        "id": "0692",
+        "name": "Test u32 sample option, divisor 256",
+        "category": [
+            "filter",
+            "u32"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 ingress prio 99 handle 1: u32 divisor 256"
+        ],
+        "cmdUnderTest": "bash -c \"for mask in ff ffff ffffff ffffffff ff00ff ff0000ff ffff00ff; do $TC filter add dev $DEV1 ingress prio 99 u32 ht 1: sample u32 0x10203040 \\$mask match u8 0 0 classid 1:1; done\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "filter protocol all pref 99 u32( (chain|fh|order) [0-9:]+){3} key ht 1 bkt 40 flowid 1:1",
+        "matchCount": "7",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2478",
+        "name": "Test u32 sample option, divisor 16",
+        "category": [
+            "filter",
+            "u32"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 ingress prio 99 handle 1: u32 divisor 256"
+        ],
+        "cmdUnderTest": "bash -c \"for mask in 70 f0 ff0 fff0 ff00f0; do $TC filter add dev $DEV1 ingress prio 99 u32 ht 1: sample u32 0x10203040 \\$mask match u8 0 0 classid 1:1; done\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "filter protocol all pref 99 u32( (chain|fh|order) [0-9:]+){3} key ht 1 bkt 4 flowid 1:1",
+        "matchCount": "5",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
     }
 ]
-- 
2.28.0


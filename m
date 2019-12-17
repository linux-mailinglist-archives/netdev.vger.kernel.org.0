Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA799123A64
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfLQXAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:00:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40539 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725892AbfLQXAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:00:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576623650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DVz/mB5Hx+usp0QZQeC3/aPENqgheXI82iNBjNxqrhE=;
        b=QFPpg1t5maSN96fCa1Waa0ChGXiSoN5zUNHAIJyqZbZRR25VVsd/vK1z2208NJ940/y/Mw
        PhK0WnpnG5RmfvstKqoDOyBaeJJCuCC+ObyYANvKpGErEX+fE8Kyj/oFZri0FqX35purpS
        45SeecHpjAYpT8YuXmJGza6gD3CtFIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-JKvyKHpCMmmTM0rpiMw73A-1; Tue, 17 Dec 2019 18:00:47 -0500
X-MC-Unique: JKvyKHpCMmmTM0rpiMw73A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 816A5107ACC7;
        Tue, 17 Dec 2019 23:00:45 +0000 (UTC)
Received: from new-host-5.redhat.com (ovpn-204-91.brq.redhat.com [10.40.204.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3CBD60C81;
        Tue, 17 Dec 2019 23:00:43 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Vlad Buslov <vladbu@mellanox.com>, Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net 2/2] tc-testing: initial tdc selftests for cls_u32
Date:   Wed, 18 Dec 2019 00:00:05 +0100
Message-Id: <06c28bf06dfee6abaadb6f4000477a48de9447b2.1576623250.git.dcaratti@redhat.com>
In-Reply-To: <cover.1576623250.git.dcaratti@redhat.com>
References: <cover.1576623250.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- move test "e9a3 - Add u32 with source match" to u32.json, and change th=
e
  match pattern to catch all hnodes
- add testcases for relevant error paths of cls_u32 module

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 .../tc-testing/tc-tests/filters/tests.json    |  22 --
 .../tc-testing/tc-tests/filters/u32.json      | 205 ++++++++++++++++++
 2 files changed, 205 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/u=
32.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.js=
on b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
index 0f89cd50a94b..8877f7b2b809 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
@@ -1,26 +1,4 @@
 [
-    {
-        "id": "e9a3",
-        "name": "Add u32 with source match",
-        "category": [
-            "filter",
-            "u32"
-        ],
-        "plugins": {
-                "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DEV1 ingress"
-        ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: protocol =
ip prio 1 u32 match ip src 127.0.0.1/32 flowid 1:1 action ok",
-        "expExitCode": "0",
-        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
-        "matchPattern": "match 7f000001/ffffffff at 12",
-        "matchCount": "1",
-        "teardown": [
-            "$TC qdisc del dev $DEV1 ingress"
-        ]
-    },
     {
         "id": "2638",
         "name": "Add matchall and try to get it",
diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/u32.json=
 b/tools/testing/selftests/tc-testing/tc-tests/filters/u32.json
new file mode 100644
index 000000000000..e09d3c0e307f
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/u32.json
@@ -0,0 +1,205 @@
+[
+    {
+        "id": "afa9",
+        "name": "Add u32 with source match",
+        "category": [
+            "filter",
+            "u32"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 ingress protocol ip pr=
io 1 u32 match ip src 127.0.0.1/32 flowid 1:1 action ok",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "filter protocol ip pref 1 u32 chain (0[ ]+$|0 f=
h 800: ht divisor 1|0 fh 800::800 order 2048 key ht 800 bkt 0 flowid 1:1.=
*match 7f000001/ffffffff at 12)",
+        "matchCount": "3",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "6aa7",
+        "name": "Add/Replace u32 with source match and invalid indev",
+        "category": [
+            "filter",
+            "u32"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter replace dev $DEV1 ingress protocol i=
p prio 1 u32 match ip src 127.0.0.1/32 indev notexist20 flowid 1:1 action=
 ok",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "filter protocol ip pref 1 u32 chain 0",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "bc4d",
+        "name": "Replace valid u32 with source match and invalid indev",
+        "category": [
+            "filter",
+            "u32"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 1 u32 mat=
ch ip src 127.0.0.3/32 flowid 1:3 action ok"
+        ],
+        "cmdUnderTest": "$TC filter replace dev $DEV1 ingress protocol i=
p prio 1 u32 match ip src 127.0.0.2/32 indev notexist20 flowid 1:2 action=
 ok",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "filter protocol ip pref 1 u32 chain (0[ ]+$|0 f=
h 800: ht divisor 1|0 fh 800::800 order 2048 key ht 800 bkt 0 flowid 1:3.=
*match 7f000003/ffffffff at 12)",
+        "matchCount": "3",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "648b",
+        "name": "Add u32 with custom hash table",
+        "category": [
+            "filter",
+            "u32"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 ingress prio 99 handle=
 42: u32 divisor 256",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "pref 99 u32 chain (0[ ]+$|0 fh 42: ht divisor 2=
56|0 fh 800: ht divisor 1)",
+        "matchCount": "3",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "6658",
+        "name": "Add/Replace u32 with custom hash table and invalid hand=
le",
+        "category": [
+            "filter",
+            "u32"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter replace dev $DEV1 ingress prio 99 ha=
ndle 42:42 u32 divisor 256",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "pref 99 u32 chain 0",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "9d0a",
+        "name": "Replace valid u32 with custom hash table and invalid ha=
ndle",
+        "category": [
+            "filter",
+            "u32"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 ingress prio 99 handle 42: u32 div=
isor 256"
+        ],
+        "cmdUnderTest": "$TC filter replace dev $DEV1 ingress prio 99 ha=
ndle 42:42 u32 divisor 128",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "pref 99 u32 chain (0[ ]+$|0 fh 42: ht divisor 2=
56|0 fh 800: ht divisor 1)",
+        "matchCount": "3",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1644",
+        "name": "Add u32 filter that links to a custom hash table",
+        "category": [
+            "filter",
+            "u32"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 ingress prio 99 handle 43: u32 div=
isor 256"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 ingress protocol ip pr=
io 98 u32 link 43: hashkey mask 0x0000ff00 at 12 match ip src 192.168.0.0=
/16",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "filter protocol ip pref 98 u32 chain (0[ ]+$|0 =
fh 801: ht divisor 1|0 fh 801::800 order 2048 key ht 801 bkt 0 link 43:.*=
match c0a80000/ffff0000 at 12.*hash mask 0000ff00 at 12)",
+        "matchCount": "3",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "74c2",
+        "name": "Add/Replace u32 filter with invalid hash table id",
+        "category": [
+            "filter",
+            "u32"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter replace dev $DEV1 ingress protocol i=
p prio 20 u32 ht 47:47 action drop",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "filter protocol ip pref 20 u32 chain 0",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1fe6",
+        "name": "Replace valid u32 filter with invalid hash table id",
+        "category": [
+            "filter",
+            "u32"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 99 handle=
 43: u32 divisor 1",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 98 u32 ht=
 43: match tcp src 22 FFFF classid 1:3"
+        ],
+        "cmdUnderTest": "$TC filter replace dev $DEV1 ingress protocol i=
p prio 98 u32 ht 43:1 match tcp src 23 FFFF classid 1:4",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter show dev $DEV1 ingress",
+        "matchPattern": "filter protocol ip pref 99 u32 chain (0[ ]+$|0 =
fh (43|800): ht divisor 1|0 fh 43::800 order 2048 key ht 43 bkt 0 flowid =
1:3.*match 00160000/ffff0000 at nexthdr\\+0)",
+        "matchCount": "4",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    }
+]
--=20
2.23.0


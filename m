Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D09EE9D27
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfJ3OJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:09:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55266 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726331AbfJ3OJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:09:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Oct 2019 16:09:16 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9UE9EDi020747;
        Wed, 30 Oct 2019 16:09:15 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        mrv@mojatatu.com, roopa@cumulusnetworks.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next v2 8/8] tc-testing: implement tests for new fast_init action flag
Date:   Wed, 30 Oct 2019 16:09:07 +0200
Message-Id: <20191030140907.18561-9-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030140907.18561-1-vladbu@mellanox.com>
References: <20191030140907.18561-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic tests to verify action creation with new fast_init flag for all
actions that support the flag.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---

Notes:
    Changes V1 -> V2:
    
    - Change flag name to "no_percpu" according to updated kernel UAPI naming.

 .../tc-testing/tc-tests/actions/csum.json     | 24 +++++++++++++++++++
 .../tc-testing/tc-tests/actions/ct.json       | 24 +++++++++++++++++++
 .../tc-testing/tc-tests/actions/gact.json     | 24 +++++++++++++++++++
 .../tc-testing/tc-tests/actions/mirred.json   | 24 +++++++++++++++++++
 .../tc-tests/actions/tunnel_key.json          | 24 +++++++++++++++++++
 .../tc-testing/tc-tests/actions/vlan.json     | 24 +++++++++++++++++++
 6 files changed, 144 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/csum.json b/tools/testing/selftests/tc-testing/tc-tests/actions/csum.json
index ddabb2fbb7c7..88ec134872e4 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/csum.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/csum.json
@@ -525,5 +525,29 @@
         "teardown": [
             "$TC actions flush action csum"
         ]
+    },
+    {
+        "id": "eaf0",
+        "name": "Add csum iph action with no_percpu flag",
+        "category": [
+            "actions",
+            "csum"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action csum",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action csum iph no_percpu",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action csum",
+        "matchPattern": "action order [0-9]*: csum \\(iph\\) action pass.*no_percpu",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action csum"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json b/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
index 62b82fe10c89..79e9bd3d0764 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
@@ -310,5 +310,29 @@
         "teardown": [
             "$TC actions flush action ct"
         ]
+    },
+    {
+        "id": "3991",
+        "name": "Add simple ct action with no_percpu flag",
+        "category": [
+            "actions",
+            "ct"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action ct",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action ct no_percpu",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct zone 0 pipe.*no_percpu",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/gact.json b/tools/testing/selftests/tc-testing/tc-tests/actions/gact.json
index 814b7a8a478b..b24494c6f546 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/gact.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/gact.json
@@ -585,5 +585,29 @@
         "teardown": [
             "$TC actions flush action gact"
         ]
+    },
+    {
+        "id": "95ad",
+        "name": "Add gact pass action with no_percpu flag",
+        "category": [
+            "actions",
+            "gact"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pass no_percpu",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action gact",
+        "matchPattern": "action order [0-9]*: gact action pass.*no_percpu",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action gact"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json b/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json
index 2232b21e2510..12a2fe0e1472 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json
@@ -553,5 +553,29 @@
         "matchPattern": "^[ \t]+index [0-9]+ ref",
         "matchCount": "0",
         "teardown": []
+    },
+    {
+        "id": "31e3",
+        "name": "Add mirred mirror to egress action with no_percpu flag",
+        "category": [
+            "actions",
+            "mirred"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mirred",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mirred egress mirror dev lo no_percpu",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mirred",
+        "matchPattern": "action order [0-9]*: mirred \\(Egress Mirror to device lo\\).*no_percpu",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mirred"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
index 28453a445fdb..fbeb9197697d 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
@@ -909,5 +909,29 @@
         "teardown": [
             "$TC actions flush action tunnel_key"
         ]
+    },
+    {
+        "id": "0cd2",
+        "name": "Add tunnel_key set action with no_percpu flag",
+        "category": [
+            "actions",
+            "tunnel_key"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action tunnel_key",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 10.10.10.1 dst_ip 20.20.20.2 id 1 no_percpu",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action tunnel_key",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 10.10.10.1.*dst_ip 20.20.20.2.*key_id 1.*no_percpu",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action tunnel_key"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json b/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
index 6503b1ce091f..41d783254b08 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
@@ -807,5 +807,29 @@
         "matchPattern": "^[ \t]+index [0-9]+ ref",
         "matchCount": "0",
         "teardown": []
+    },
+    {
+        "id": "1a3d",
+        "name": "Add vlan pop action with no_percpu flag",
+        "category": [
+            "actions",
+            "vlan"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action vlan",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action vlan pop no_percpu",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action vlan",
+        "matchPattern": "action order [0-9]+: vlan.*pop.*no_percpu",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action vlan"
+        ]
     }
 ]
-- 
2.21.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 799B75DC98
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfGCCmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:42:06 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45424 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfGCCmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 22:42:05 -0400
Received: by mail-io1-f67.google.com with SMTP id e3so806477ioc.12
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 19:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jJahf/Nhdlr4bis3ww9XByg+JWqrae1UU14UYmcFxa8=;
        b=ULXshwq8Q+FbmZd/xWdY99ThkDl2cGRHQs7xFLOUB9iLvivEjmzbsidiM5mNtp39g5
         2kUzM8kcF9X1SYWJVn8PAg0DvZG59sRxHJlZKv2InRPg1OW9zGGNfq+mX2Hf3KlSBtbF
         XvGd3bdVCW5DJVhSyc8BCWth2B19fDjyaBUjoIBVw9/v2xlL3kWXFlOD10IoYwDP6zAH
         tMI4R1o3YQEG6QFW8Tb1sKmTj3eDGFeb6ihxlwuy99w3bH23Bi5ZATmHzP3VcE6/6o67
         YXnY1zwUzX0AdtWqmnhRvqF/qYFhXJYRG41VczkayTH0ehBdqg5/bP4BpofiUkcrIhth
         CYIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jJahf/Nhdlr4bis3ww9XByg+JWqrae1UU14UYmcFxa8=;
        b=ZQw35UdRLSeuNDeMm/UTADsaPKy0y5FCblnGryvr5mTZ7y9SnQy3YIt/7zpmZChIT5
         gLFRy4SMYAEBa52cVM68ZAEIZv0dtHr3JP+VBVTtPqyK+ytLwQzlW7PqUlPo8PlJKeHR
         hMirw1Lbeaa+xExQrkvAjZC+6TwiSO3aDJ51yfqO9aL9Zo2KqxgqlIIvbuLh1PCTL8GS
         fUOWZBOyi6rYA6+nCE1ZENNig1mcU2C69TvuaxwM0EfwPs1a3DWBfjKPKJ9bk2lQnFZl
         pjyEhf3fSSsLGiMd8QEF48FmWQsVZCaQcDBliVcoS4J6TSFOPbt9OY0/9A9FBIuvKwQy
         xvNw==
X-Gm-Message-State: APjAAAVKm74OpCyZgw7QmXFC09NNZfvrp2U2i+zMSg1nfOwM85aLNsJP
        ZoA5MTJS+p/1Mult2tx0AGePjA==
X-Google-Smtp-Source: APXvYqyJaCBdeUJ8IAgT3ukKYPs93l94TQvgK4plvSS4X6RDJR8qj6/MQn2y3atOaaoIn9YTvSlYoA==
X-Received: by 2002:a5d:9957:: with SMTP id v23mr10031375ios.117.1562121724203;
        Tue, 02 Jul 2019 19:42:04 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:57:4bb:2258:42f6])
        by smtp.gmail.com with ESMTPSA id w26sm1638114iom.59.2019.07.02.19.42.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 02 Jul 2019 19:42:03 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH net-next 3/3] tc-testing: introduce scapyPlugin for basic traffic
Date:   Tue,  2 Jul 2019 22:41:21 -0400
Message-Id: <1562121681-9365-4-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562121681-9365-1-git-send-email-lucasb@mojatatu.com>
References: <1562121681-9365-1-git-send-email-lucasb@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The scapyPlugin allows for simple traffic generation in tdc to
test various tc features. It was tested with scapy v2.4.2, but
should work with any successive version.

In order to use the plugin's functionality, scapy must be
installed. This can be done with:
   pip3 install scapy

or to install 2.4.2:
   pip3 install scapy==2.4.2

If the plugin is unable to import the scapy module, it will
terminate the tdc run.

The plugin makes use of a new key in the test case data, 'scapy'.
This block contains three other elements: 'iface', 'count', and
'packet':

        "scapy": {
            "iface": "$DEV0",
            "count": 1,
            "packet": "Ether(type=0x800)/IP(src='16.61.16.61')/ICMP()"
        },

* iface is the name of the device on the host machine from which
  the packet(s) will be sent. Values contained within tdc_config.py's
  NAMES dict can be used here - this is useful if paired with
  nsPlugin
* count is the number of copies of this packet to be sent
* packet is a string detailing the different layers of the packet
  to be sent. If a property isn't explicitly set, scapy will set
  default values for you.

Layers in the packet info are separated by slashes. For info about
common TCP and IP properties, see:
https://blogs.sans.org/pen-testing/files/2016/04/ScapyCheatSheet_v0.2.pdf

Caution is advised when running tests using the scapy functionality,
since the plugin blindly sends the packet as defined in the test case
data.

See creating-testcases/scapy-example.json for sample test cases;
the first test is intended to pass while the second is intended to
fail. Consider using the matchJSON functionality for verification
when using scapy.
---
 .../creating-testcases/scapy-example.json          | 98 ++++++++++++++++++++++
 .../selftests/tc-testing/plugin-lib/scapyPlugin.py | 51 +++++++++++
 2 files changed, 149 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/creating-testcases/scapy-example.json
 create mode 100644 tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py

diff --git a/tools/testing/selftests/tc-testing/creating-testcases/scapy-example.json b/tools/testing/selftests/tc-testing/creating-testcases/scapy-example.json
new file mode 100644
index 0000000..5a9377b
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/creating-testcases/scapy-example.json
@@ -0,0 +1,98 @@
+[
+    {
+        "id": "b1e9",
+        "name": "Test matching of source IP",
+        "category": [
+            "actions",
+            "scapy"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            [
+                "$TC qdisc del dev $DEV1 ingress",
+                0,
+                1,
+                2,
+                255
+            ],
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: prio 3 protocol ip flower src_ip 16.61.16.61 flowid 1:1 action ok",
+        "scapy": {
+            "iface": "$DEV0",
+            "count": 1,
+            "packet": "Ether(type=0x800)/IP(src='16.61.16.61')/ICMP()"
+        },
+        "expExitCode": "0",
+        "verifyCmd": "$TC -s -j filter ls dev $DEV1 ingress prio 3",
+        "matchJSON": [
+            {
+                "path": [
+                    1,
+                    "options",
+                    "actions",
+                    0,
+                    "stats",
+                    "packets"
+                ],
+                "value": 1
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "e9c4",
+        "name": "Test matching of source IP with wrong count",
+        "category": [
+            "actions",
+            "scapy"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            [
+                "$TC qdisc del dev $DEV1 ingress",
+                0,
+                1,
+                2,
+                255
+            ],
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: prio 3 protocol ip flower src_ip 16.61.16.61 flowid 1:1 action ok",
+        "scapy": {
+            "iface": "$DEV0",
+            "count": 3,
+            "packet": "Ether(type=0x800)/IP(src='16.61.16.61')/ICMP()"
+        },
+        "expExitCode": "0",
+        "verifyCmd": "$TC -s -j filter ls dev $DEV1 parent ffff:",
+        "matchJSON": [
+            {
+                "path": [
+                    1,
+                    "options",
+                    "actions",
+                    0,
+                    "stats",
+                    "packets"
+                ],
+                "value": 1
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    }
+]
diff --git a/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py b/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
new file mode 100644
index 0000000..db57916
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
@@ -0,0 +1,51 @@
+#!/usr/bin/env python3
+
+import os
+import signal
+from string import Template
+import subprocess
+import time
+from TdcPlugin import TdcPlugin
+
+from tdc_config import *
+
+try:
+    from scapy.all import *
+except ImportError:
+    print("Unable to import the scapy python module.")
+    print("\nIf not already installed, you may do so with:")
+    print("\t\tpip3 install scapy==2.4.2")
+    exit(1)
+
+class SubPlugin(TdcPlugin):
+    def __init__(self):
+        self.sub_class = 'scapy/SubPlugin'
+        super().__init__()
+
+    def post_execute(self):
+        if 'scapy' not in self.args.caseinfo:
+            if self.args.verbose:
+                print('{}.post_execute: no scapy info in test case'.format(self.sub_class))
+            return
+
+        # Check for required fields
+        scapyinfo = self.args.caseinfo['scapy']
+        scapy_keys = ['iface', 'count', 'packet']
+        missing_keys = []
+        keyfail = False
+        for k in scapy_keys:
+            if k not in scapyinfo:
+                keyfail = True
+                missing_keys.add(k)
+        if keyfail:
+            print('{}: Scapy block present in the test, but is missing info:'
+                .format(self.sub_class))
+            print('{}'.format(missing_keys))
+
+        pkt = eval(scapyinfo['packet'])
+        if '$' in scapyinfo['iface']:
+            tpl = Template(scapyinfo['iface'])
+            scapyinfo['iface'] = tpl.safe_substitute(NAMES)
+        for count in range(scapyinfo['count']):
+            sendp(pkt, iface=scapyinfo['iface'])
+
-- 
2.7.4


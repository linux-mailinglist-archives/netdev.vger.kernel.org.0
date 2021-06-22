Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580463B0835
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhFVPHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbhFVPHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:07:32 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15950C06175F
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:05:16 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id bj15so38504883qkb.11
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tIZQm+sStQKdHI1E+mp1ZW+5jKcKVfLb3zXzQiBk2Oc=;
        b=lCKYFoOydkyVZQnHeBb8cdsDgFYUYacfsLAeGmQsfvi2oe2PnynibIFc9qjx7oPoLp
         1rs8M4oxaFGADtcsyYBDde7J+2zdHO+v6UfkEHOhfFwuRk209ABnC9j8bgfs+OZRYGK8
         6XBUvuLURtD738kCKzqFh7MY39vYchdJKI+KlprAIKWPnGyW1VYPqqKU56ULmi0IW+Hp
         WVL8ys7k1lhle7gN01s2APzCt7VK9XnnsQqMiJUrQULlg9++oNt358le5cX1bmbOoV7F
         t8jWkmnTfixLYA9GymGIdi54VSSAXchn8FQ7xetHZnTd9dtIKKiFYWsX/Z8J84GTaf2U
         ei3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tIZQm+sStQKdHI1E+mp1ZW+5jKcKVfLb3zXzQiBk2Oc=;
        b=oTWXnlbITeu1k0jBSjDho1ADO6SaTWAy9cV0LWgSEShRSq4SdF3EStAC1GAEpsh7y4
         F30UHkN+4k4fQ8DllSKkrNdZcfYdYr0HqP9C3HD/jB+B7SSjyGs87k7MH47Qb0/J+oMW
         tQ6E9yMXDWweWUHlakXSU66vhw0iduNWG5vXLn2Tehq9um6a8nt5Y3ODOZ/BNK/KE9oQ
         csPi9zw3ms28VluAzpWhxexavLq8s0C5+ulcZcz0snMEzr72m1uvljPj5LsORsH5s2kE
         CZ2Z1c2R/LeCNsgvGlnPFYB0laQKMfUeq1odSWGri6Ij7Qi0bc5vJjXWOwXQgMnqfL1Q
         +1JQ==
X-Gm-Message-State: AOAM531MOiOhCWvjKxEnhI3C6e2T4H+n3YDolAtM4V3IUoyhPuO1NbwI
        qM8Op6iQKoeoBBQJwTSHfgo=
X-Google-Smtp-Source: ABdhPJzIiaHv4HgYLZQtYI7SgfXAM+xXnPcoCTiyvENWBK7+fox/9zyXSzzBv9QtaWEBhxPyKb0vBA==
X-Received: by 2002:a37:9f51:: with SMTP id i78mr4850871qke.345.1624374313592;
        Tue, 22 Jun 2021 08:05:13 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f016:6106:596a:c2e4:c4f2:9f1e])
        by smtp.gmail.com with ESMTPSA id t15sm1783106qtr.35.2021.06.22.08.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 08:05:13 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id E3E1FC13E5; Tue, 22 Jun 2021 12:05:10 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dcaratti@redhat.com, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 3/3] tc-testing: add test for ct DNAT tuple collision
Date:   Tue, 22 Jun 2021 12:05:02 -0300
Message-Id: <7b045b1a5e62916af135748e629d03e759627655.1624373870.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624373870.git.marcelo.leitner@gmail.com>
References: <cover.1624373870.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When this test fails, /proc/net/nf_conntrack gets only 1 entry:
ipv4     2 tcp      6 119 SYN_SENT src=10.0.0.10 dst=10.0.0.10 sport=5000 dport=10 [UNREPLIED] src=20.0.0.1 dst=10.0.0.10 sport=10 dport=5000 mark=0 secctx=system_u:object_r:unlabeled_t:s0 zone=0 use=2

When it works, it gets 2 entries:
ipv4     2 tcp      6 119 SYN_SENT src=10.0.0.10 dst=10.0.0.20 sport=5000 dport=10 [UNREPLIED] src=20.0.0.1 dst=10.0.0.10 sport=10 dport=58203 mark=0 secctx=system_u:object_r:unlabeled_t:s0 zone=0 use=2
ipv4     2 tcp      6 119 SYN_SENT src=10.0.0.10 dst=10.0.0.10 sport=5000 dport=10 [UNREPLIED] src=20.0.0.1 dst=10.0.0.10 sport=10 dport=5000 mark=0 secctx=system_u:object_r:unlabeled_t:s0 zone=0 use=2

The missing entry is because the 2nd packet hits a tuple collusion and the
conntrack entry doesn't get allocated.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 .../tc-testing/tc-tests/actions/ct.json       | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json b/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
index 4202e95e27b99536491cd8b94e92b07851551616..bd843ab00a58a44af14182fd30d7a4f74b1c63cd 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
@@ -406,5 +406,50 @@
         "teardown": [
             "$TC actions flush action ct"
         ]
+    },
+    {
+        "id": "3992",
+        "name": "Add ct action triggering DNAT tuple conflict",
+        "category": [
+            "actions",
+            "ct",
+	    "scapy"
+        ],
+	"plugins": {
+		"requires": [
+			"nsPlugin",
+			"scapyPlugin"
+		]
+	},
+        "setup": [
+            [
+                "$TC qdisc del dev $DEV1 ingress",
+                0,
+                1,
+		2,
+                255
+            ],
+	    "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 ingress protocol ip prio 1 flower ct_state -trk action ct commit nat dst addr 20.0.0.1 port 10 pipe action drop",
+	"scapy": [
+	    {
+		"iface": "$DEV0",
+		"count": 1,
+		"packet": "Ether(type=0x800)/IP(src='10.0.0.10',dst='10.0.0.10')/TCP(sport=5000,dport=10)"
+	    },
+	    {
+		"iface": "$DEV0",
+		"count": 1,
+		"packet": "Ether(type=0x800)/IP(src='10.0.0.10',dst='10.0.0.20')/TCP(sport=5000,dport=10)"
+	    }
+	],
+        "expExitCode": "0",
+        "verifyCmd": "cat /proc/net/nf_conntrack",
+        "matchPattern": "dst=10.0.0.20",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
     }
 ]
-- 
2.31.1


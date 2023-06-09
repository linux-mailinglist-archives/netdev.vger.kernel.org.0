Return-Path: <netdev+bounces-9731-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A93772A583
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F4F728192E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92784261E2;
	Fri,  9 Jun 2023 21:43:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453D123D6B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAB2C433EF;
	Fri,  9 Jun 2023 21:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347038;
	bh=uPD0tDJ3n6TCnMFJW1AVFU/ZJfK/xAttnGcJitoF0H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/BaD/epHerbaGN3Q6AgaQNbaR06uxyX+FQSLy0K4OCLX760mvGgajqvba//iTBfC
	 QZfrRse6Pp0qWqV409LJ19VPM1OxGdkUn1nxF8t+EPyc0Wu5+qfdFQexOWlMOK8qvQ
	 x7RLVyYq7n7tlcFYTXZy2B2IvIg/pt3JVlDtaaU6+Rm2NzXq2OQ1xPeDmr2XOSAj+D
	 CSAocH3/98k5cJcJScKbOloZmIRp4AemGYcaYetYRcgmL7bR7D5wep4ATb+8b0uHhZ
	 rxv/Z5odhUu8b9Du18LOVZgy0URrmf75QPqYc/t/cf4iwPOjEHvILqt63zx0PwHdEj
	 w6CbsX6sXZ3lQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/12] netlink: specs: ethtool: untangle UDP tunnels and cable test a bit
Date: Fri,  9 Jun 2023 14:43:42 -0700
Message-Id: <20230609214346.1605106-9-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609214346.1605106-1-kuba@kernel.org>
References: <20230609214346.1605106-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

UDP tunnel and cable test messages have a lot of nests,
which do not match the names of the enum entries in C uAPI.
Some of the structure / nesting also looks wrong.

Untangle this a little bit based on the names, comments and
educated guesses, I haven't actually tested the results.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/ethtool.yaml | 82 ++++++++++++++++++------
 1 file changed, 62 insertions(+), 20 deletions(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index d674731629c4..17b7b5028e2b 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -582,7 +582,7 @@ doc: Partial family for Ethtool Netlink.
         name: phc-index
         type: u32
   -
-    name: cable-test-ntf-nest-result
+    name: cable-result
     attributes:
       -
         name: pair
@@ -591,7 +591,7 @@ doc: Partial family for Ethtool Netlink.
         name: code
         type: u8
   -
-    name: cable-test-ntf-nest-fault-length
+    name: cable-fault-length
     attributes:
       -
         name: pair
@@ -600,18 +600,25 @@ doc: Partial family for Ethtool Netlink.
         name: cm
         type: u32
   -
-    name: cable-test-ntf-nest
+    name: cable-nest
     attributes:
       -
         name: result
         type: nest
-        nested-attributes: cable-test-ntf-nest-result
+        nested-attributes: cable-result
       -
         name: fault-length
         type: nest
-        nested-attributes: cable-test-ntf-nest-fault-length
+        nested-attributes: cable-fault-length
   -
     name: cable-test
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+  -
+    name: cable-test-ntf
     attributes:
       -
         name: header
@@ -623,7 +630,7 @@ doc: Partial family for Ethtool Netlink.
       -
         name: nest
         type: nest
-        nested-attributes: cable-test-ntf-nest
+        nested-attributes: cable-nest
   -
     name: cable-test-tdr-cfg
     attributes:
@@ -637,8 +644,22 @@ doc: Partial family for Ethtool Netlink.
         name: step
         type: u32
       -
-        name: pari
+        name: pair
         type: u8
+  -
+    name: cable-test-tdr-ntf
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: status
+        type: u8
+      -
+        name: nest
+        type: nest
+        nested-attributes: cable-nest
   -
     name: cable-test-tdr
     attributes:
@@ -651,7 +672,7 @@ doc: Partial family for Ethtool Netlink.
         type: nest
         nested-attributes: cable-test-tdr-cfg
   -
-    name: tunnel-info-udp-entry
+    name: tunnel-udp-entry
     attributes:
       -
         name: port
@@ -662,7 +683,7 @@ doc: Partial family for Ethtool Netlink.
         type: u32
         enum: udp-tunnel-type
   -
-    name: tunnel-info-udp-table
+    name: tunnel-udp-table
     attributes:
       -
         name: size
@@ -672,9 +693,17 @@ doc: Partial family for Ethtool Netlink.
         type: nest
         nested-attributes: bitset
       -
-        name: udp-ports
+        name: entry
         type: nest
-        nested-attributes: tunnel-info-udp-entry
+        multi-attr: true
+        nested-attributes: tunnel-udp-entry
+  -
+    name: tunnel-udp
+    attributes:
+      -
+        name: table
+        type: nest
+        nested-attributes: tunnel-udp-table
   -
     name: tunnel-info
     attributes:
@@ -685,7 +714,7 @@ doc: Partial family for Ethtool Netlink.
       -
         name: udp-ports
         type: nest
-        nested-attributes: tunnel-info-udp-table
+        nested-attributes: tunnel-udp
   -
     name: fec-stat
     attributes:
@@ -1357,10 +1386,16 @@ doc: Partial family for Ethtool Netlink.
         request:
           attributes:
             - header
-        reply:
-          attributes:
-            - header
-            - cable-test-ntf-nest
+    -
+      name: cable-test-ntf
+      doc: Cable test notification.
+
+      attribute-set: cable-test-ntf
+
+      event:
+        attributes:
+          - header
+          - status
     -
       name: cable-test-tdr-act
       doc: Cable test TDR.
@@ -1371,10 +1406,17 @@ doc: Partial family for Ethtool Netlink.
         request:
           attributes:
             - header
-        reply:
-          attributes:
-            - header
-            - cable-test-tdr-cfg
+    -
+      name: cable-test-tdr-ntf
+      doc: Cable test TDR notification.
+
+      attribute-set: cable-test-tdr-ntf
+
+      event:
+        attributes:
+          - header
+          - status
+          - nest
     -
       name: tunnel-info-get
       doc: Get tsinfo params.
-- 
2.40.1



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0A8672D77
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 01:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjASAgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 19:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjASAgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 19:36:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2159C474F6;
        Wed, 18 Jan 2023 16:36:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 204DC61B09;
        Thu, 19 Jan 2023 00:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF012C433F2;
        Thu, 19 Jan 2023 00:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674088581;
        bh=IVvCR8GKhominXP7rV5W+Yg5UMdBdNWIhfd9Zx13eIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+W4UgHGFXkw0t2CfoCIbAdEG6mEIMv2SGxccbaL3V8WmA+oDp2S50DUtuEiaFd4J
         +RCWGZyNp8YVDY5e/kn2yd/97YZYL2r4W1+uSBFkmJM9/55GjFbKmKgR2DiupcmmpO
         RTo7mzpRvCKQTC3aawZts/LGd21UVv5vm0sY2GkY4RvOCt7Pm/jVwTlzOBBBYZlgnz
         +p2kZhYAehfWppggILL0YG6pTGoNXRcLXPfWprUZRNuHC8Sa1V9nDiNywQCpRBMS1n
         c2eOf1mSq+JyoQ9iPtLj57BYRRZUthNNk6sbeioMRVOxck5qoPpDJr60+vz/vuOM2D
         8sms2uofHNf6w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 4/8] netlink: add a proto specification for FOU
Date:   Wed, 18 Jan 2023 16:36:09 -0800
Message-Id: <20230119003613.111778-5-kuba@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119003613.111778-1-kuba@kernel.org>
References: <20230119003613.111778-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FOU has a reasonably modern Genetlink family. Add a spec.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/fou.yaml | 128 +++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)
 create mode 100644 Documentation/netlink/specs/fou.yaml

diff --git a/Documentation/netlink/specs/fou.yaml b/Documentation/netlink/specs/fou.yaml
new file mode 100644
index 000000000000..266c386eedf3
--- /dev/null
+++ b/Documentation/netlink/specs/fou.yaml
@@ -0,0 +1,128 @@
+name: fou
+
+protocol: genetlink-legacy
+
+doc: |
+  Foo-over-UDP.
+
+c-family-name: fou-genl-name
+c-version-name: fou-genl-version
+max-by-define: true
+kernel-policy: global
+
+definitions:
+  -
+    type: enum
+    name: encap_type
+    name-prefix: fou-encap-
+    enum-name:
+    entries: [ unspec, direct, gue ]
+
+attribute-sets:
+  -
+    name: fou
+    name-prefix: fou-attr-
+    attributes:
+      -
+        name: unspec
+        type: unused
+      -
+        name: port
+        type: u16
+        byte-order: big-endian
+      -
+        name: af
+        type: u8
+      -
+        name: ipproto
+        type: u8
+      -
+        name: type
+        type: u8
+      -
+        name: remcsum_nopartial
+        type: flag
+      -
+        name: local_v4
+        type: u32
+      -
+        name: local_v6
+        type: binary
+        checks:
+          min-len: 16
+      -
+        name: peer_v4
+        type: u32
+      -
+        name: peer_v6
+        type: binary
+        checks:
+          min-len: 16
+      -
+        name: peer_port
+        type: u16
+        byte-order: big-endian
+      -
+        name: ifindex
+        type: s32
+
+operations:
+  list:
+    -
+      name: unspec
+      doc: unused
+
+    -
+      name: add
+      doc: Add port.
+      attribute-set: fou
+
+      dont-validate: [ strict, dump ]
+      flags: [ admin-perm ]
+
+      do:
+        request: &all_attrs
+          attributes:
+            - port
+            - ipproto
+            - type
+            - remcsum_nopartial
+            - local_v4
+            - peer_v4
+            - local_v6
+            - peer_v6
+            - peer_port
+            - ifindex
+
+    -
+      name: del
+      doc: Delete port.
+      attribute-set: fou
+
+      dont-validate: [ strict, dump ]
+      flags: [ admin-perm ]
+
+      do:
+        request:  &select_attrs
+          attributes:
+          - af
+          - ifindex
+          - port
+          - peer_port
+          - local_v4
+          - peer_v4
+          - local_v6
+          - peer_v6
+
+    -
+      name: get
+      doc: Get tunnel info.
+      attribute-set: fou
+      dont-validate: [ strict, dump ]
+
+      do:
+        request: *select_attrs
+        reply: *all_attrs
+
+      dump:
+        reply: *all_attrs
-- 
2.39.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816EA675C11
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjATRvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjATRvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:51:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B3CA2586;
        Fri, 20 Jan 2023 09:50:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D859B829C3;
        Fri, 20 Jan 2023 17:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F286C4339B;
        Fri, 20 Jan 2023 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674237053;
        bh=pRQWh6DBm7gXsTZy7UDbobo/A6jRp0jSVfp6Qm+n2vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riJU5InmdyLNS0Hcq1NQRT3FzjtikGuHDMVmVVoSa1alXseIzbK2ilM72y9SOMVAn
         8cCNFG9DBSZevA3GHZd9zuHSmOg135A9qjVlEPGInqb1C2sdnzrDek3rlTw+pl79Yb
         fT4jIa7QF30JdIV7uppx90b2y5WsBT2yWktBTmzm5UDwUuDK436YlM7LGgkRWbRnLh
         mPrC8GHNzhNt3zub30UF+qzjeiK6yQTZZ+/7gOj4/rOTuUhSuasXPi6OITsyRPDqcG
         7NFFuOejeuCZ4GKIENaFVMccl6s+0OKCFjRYpZ54MiCtnrGzdRE2tMbVDzdyHFdAxV
         kaysWmJkdN+zw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v4 4/8] netlink: add a proto specification for FOU
Date:   Fri, 20 Jan 2023 09:50:37 -0800
Message-Id: <20230120175041.342573-5-kuba@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230120175041.342573-1-kuba@kernel.org>
References: <20230120175041.342573-1-kuba@kernel.org>
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

Acked-by: Stanislav Fomichev <sdf@google.com>
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


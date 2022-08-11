Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2C358F5D2
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 04:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiHKCXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 22:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbiHKCXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 22:23:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC22D8FD5B;
        Wed, 10 Aug 2022 19:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57580B81EFE;
        Thu, 11 Aug 2022 02:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A41C43142;
        Thu, 11 Aug 2022 02:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660184593;
        bh=WIS3juFBNIkI4YzCJrQnWAowOP677MxK2UsLnwMjaaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTCWJwkz4PvadOEiVCJyncRvDAr5dFMEVqfvzkx+9HkY9aOslxIY5bVKCAw1aCeRD
         sIcRNPLFYhoYEAXkWYxzr1b0eLD3M8DZFCo+y0LK0hiZEKjALVVjK2FnwWUq2NAY3w
         8CnMgxBSPjPIdCCBuEuiayPGUB7C1hveg1YyKNmtbAhMdQtE4ewZmCnRM2lyFsa94F
         KkZ4vhVSd7CeBuE/HqrYvXu7J9EQHaXobOp1fC90McOrgRi5hpQw5+XOom+HMGmo2J
         2ng7oup4ZcVGOaznJFyH/4AZb1V22CpcEtEnWD+BttWrTreR7UopJ2AwmDAjkK9xCc
         Ajwgo2mGggBuw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Cc:     sdf@google.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de,
        linux-doc@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 4/4] ynl: add a sample user for ethtool
Date:   Wed, 10 Aug 2022 19:23:04 -0700
Message-Id: <20220811022304.583300-5-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220811022304.583300-1-kuba@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A sample schema describing ethtool channels and a script showing
that it works. The script is called like this:

 ./tools/net/ynl/samples/ethtool.py \
    --spec Documentation/netlink/bindings/ethtool.yaml \
    --device eth0

I have schemas for genetlink, FOU and the proposed DPLL subsystem,
to validate that the concept has wide applicability, but ethtool
feels like the best demo of the 4.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/bindings/ethtool.yaml | 115 ++++++++++++++++++++
 tools/net/ynl/samples/ethtool.py            |  30 +++++
 2 files changed, 145 insertions(+)
 create mode 100644 Documentation/netlink/bindings/ethtool.yaml
 create mode 100755 tools/net/ynl/samples/ethtool.py

diff --git a/Documentation/netlink/bindings/ethtool.yaml b/Documentation/netlink/bindings/ethtool.yaml
new file mode 100644
index 000000000000..b4540d60b4b3
--- /dev/null
+++ b/Documentation/netlink/bindings/ethtool.yaml
@@ -0,0 +1,115 @@
+# SPDX-License-Identifier: BSD-3-Clause
+
+name: ethtool
+
+description: |
+  Ethernet device configuration interface.
+
+attr-cnt-suffix: CNT
+
+attribute-spaces:
+  -
+    name: header
+    name-prefix: ETHTOOL_A_HEADER_
+    attributes:
+      -
+        name: dev_index
+        val: 1
+        type: u32
+      -
+        name: dev_name
+        type: nul-string
+        len: ALTIFNAMSIZ - 1
+      -
+        name: flags
+        type: u32
+  -
+    name: channels
+    name-prefix: ETHTOOL_A_CHANNELS_
+    attributes:
+      -
+        name: header
+        val: 1
+        type: nest
+        nested-attributes: header
+      -
+        name: rx_max
+        type: u32
+      -
+        name: tx_max
+        type: u32
+      -
+        name: other_max
+        type: u32
+      -
+        name: combined_max
+        type: u32
+      -
+        name: rx_count
+        type: u32
+      -
+        name: tx_count
+        type: u32
+      -
+        name: other_count
+        type: u32
+      -
+        name: combined_count
+        type: u32
+
+headers:
+  user: linux/if.h
+  uapi: linux/ethtool_netlink.h
+
+operations:
+  name-prefix: ETHTOOL_MSG_
+  async-prefix: ETHTOOL_MSG_
+  list:
+    -
+      name: channels_get
+      val: 17
+      description: Get current and max supported number of channels.
+      attribute-space: channels
+      do:
+        request:
+          attributes:
+            - header
+        reply: &channel_reply
+          attributes:
+            - header
+            - rx_max
+            - tx_max
+            - other_max
+            - combined_max
+            - rx_count
+            - tx_count
+            - other_count
+            - combined_count
+      dump:
+        reply: *channel_reply
+
+    -
+      name: channels_ntf
+      description: Notification for device changing its number of channels.
+      notify: channels_get
+      mcgrp: monitor
+
+    -
+      name: channels_set
+      description: Set number of channels.
+      attribute-space: channels
+      do:
+        request:
+          attributes:
+            - header
+            - rx_count
+            - tx_count
+            - other_count
+            - combined_count
+
+mcast-groups:
+  name-prefix: ETHTOOL_MCGRP_
+  name-suffix: _NAME
+  list:
+    -
+      name: monitor
diff --git a/tools/net/ynl/samples/ethtool.py b/tools/net/ynl/samples/ethtool.py
new file mode 100755
index 000000000000..63c8e29f8e5d
--- /dev/null
+++ b/tools/net/ynl/samples/ethtool.py
@@ -0,0 +1,30 @@
+#!/usr/bin/env python
+# SPDX-License-Identifier: BSD-3-Clause
+
+import argparse
+
+from ynl import YnlFamily
+
+
+def main():
+    parser = argparse.ArgumentParser(description='YNL ethtool sample')
+    parser.add_argument('--spec', dest='spec', type=str, required=True)
+    parser.add_argument('--schema', dest='schema', type=str)
+    parser.add_argument('--device', dest='dev_name', type=str)
+    parser.add_argument('--ifindex', dest='ifindex', type=str)
+    args = parser.parse_args()
+
+    ynl = YnlFamily(args.spec)
+
+    if args.dev_name:
+        channels = ynl.channels_get({'header': {'dev_name': args.dev_name}})
+    elif args.ifindex:
+        channels = ynl.channels_get({'header': {'dev_index': args.ifindex}})
+    else:
+        return
+    print('Netlink responded with:')
+    print(channels)
+
+
+if __name__ == "__main__":
+    main()
-- 
2.37.1


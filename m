Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA88968223F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjAaCem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjAaCeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5404F366AB;
        Mon, 30 Jan 2023 18:34:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1EC561234;
        Tue, 31 Jan 2023 02:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFD3C433B4;
        Tue, 31 Jan 2023 02:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132446;
        bh=eBarguq2Ue2KIYg17NIXjPPlUytqZ/y2FxdtwAIL3X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8K7GqCmX4RA7Kl/9PGvFhhxXYOCk2yoF0x2fMdAwMvdP1ZJ8v9WddFLl7AKv6oyO
         a0IUbB5Shy1GP6TXzwUMiOEFwkbnPDHByRsa5dWy0MKvOL5+SRnDtJx3GoSsUqNZTy
         A8jOWxFtU3oH79NwGI3wEGvyHK+hUq1+K1fvORRQgAY//L8xqwdyAamT4KTfuBOZdR
         /OFYWCYsPp1pWx+0adyv2oYxxAz6Cso/DCequCb9GMAG1gzx1BtyZE+oj4WM6t/hFn
         q0ZABj8j5SlurT2bvijM1tSIlqzuI17pDs058SABlLsZ7I5IUJWTCDmFo5a51EWase
         BbXMyS3MqH1YA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 12/14] netlink: specs: add partial specification for ethtool
Date:   Mon, 30 Jan 2023 18:33:52 -0800
Message-Id: <20230131023354.1732677-13-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131023354.1732677-1-kuba@kernel.org>
References: <20230131023354.1732677-1-kuba@kernel.org>
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

Ethtool is one of the most actively developed families.
With the changes to the CLI it should be possible to use
the YNL based code for easy prototyping and development.
Add a partial family definition. I've tested the string
set and rings. I don't have any MAC Merge implementation
to test with, but I added the definition for it, anyway,
because it's last. New commands can simply be added at
the end without having to worry about manually providing
IDs / values.

Set (with notification support - None is the response,
the data is from the notification):

$ sudo ./tools/net/ynl/cli.py \
    --spec Documentation/netlink/specs/ethtool.yaml \
    --do rings-set \
    --json '{"header":{"dev-name":"enp0s31f6"}, "rx":129}' \
    --subscribe monitor
None
[{'msg': {'header': {'dev-index': 2, 'dev-name': 'enp0s31f6'},
          'rx': 136,
          'rx-max': 4096,
          'tx': 256,
          'tx-max': 4096,
          'tx-push': 0},
  'name': 'rings-ntf'}]

Do / dump (yes, the kernel requires that even for dump and even
if empty - the "header" nest must be there):

$ ./tools/net/ynl/cli.py \
    --spec Documentation/netlink/specs/ethtool.yaml \
    --do rings-get \
    --json '{"header":{"dev-index": 2}}'
{'header': {'dev-index': 2, 'dev-name': 'enp0s31f6'},
 'rx': 136,
 'rx-max': 4096,
 'tx': 256,
 'tx-max': 4096,
 'tx-push': 0}

$ ./tools/net/ynl/cli.py \
    --spec Documentation/netlink/specs/ethtool.yaml \
    --dump rings-get \
    --json '{"header":{}}'
[{'header': {'dev-index': 2, 'dev-name': 'enp0s31f6'},
  'rx': 136,
  'rx-max': 4096,
  'tx': 256,
  'tx-max': 4096,
  'tx-push': 0},
 {'header': {'dev-index': 3, 'dev-name': 'wlp0s20f3'}, 'tx-push': 0},
 {'header': {'dev-index': 19, 'dev-name': 'enp58s0u1u1'},
  'rx': 100,
  'rx-max': 4096,
  'tx-push': 0}]

And error reporting:

$ ./tools/net/ynl/cli.py \
    --spec Documentation/netlink/specs/ethtool.yaml \
    --dump rings-get \
    --json '{"header":{"flags":5}}'
Netlink error: Invalid argument
nl_len = 68 (52) nl_flags = 0x300 nl_type = 2
	error: -22	extack: {'msg': 'reserved bit set',
	                         'bad-attr-offs': 24,
				 'bad-attr': '.header.flags'}
None

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/ethtool.yaml | 392 +++++++++++++++++++++++
 1 file changed, 392 insertions(+)
 create mode 100644 Documentation/netlink/specs/ethtool.yaml

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
new file mode 100644
index 000000000000..82f4e6f8ddd3
--- /dev/null
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -0,0 +1,392 @@
+name: ethtool
+
+protocol: genetlink-legacy
+
+doc: Partial family for Ethtool Netlink.
+
+attribute-sets:
+  -
+    name: header
+    attributes:
+      -
+        name: dev-index
+        type: u32
+        value: 1
+      -
+        name: dev-name
+        type: string
+      -
+        name: flags
+        type: u32
+
+  -
+    name: bitset-bit
+    attributes:
+      -
+        name: index
+        type: u32
+        value: 1
+      -
+        name: name
+        type: string
+      -
+        name: value
+        type: flag
+  -
+    name: bitset-bits
+    attributes:
+      -
+        name: bit
+        type: nest
+        nested-attributes: bitset-bit
+        value: 1
+  -
+    name: bitset
+    attributes:
+      -
+        name: nomask
+        type: flag
+        value: 1
+      -
+        name: size
+        type: u32
+      -
+        name: bits
+        type: nest
+        nested-attributes: bitset-bits
+
+  -
+    name: string
+    attributes:
+      -
+        name: index
+        type: u32
+        value: 1
+      -
+        name: value
+        type: string
+  -
+    name: strings
+    attributes:
+      -
+        name: string
+        type: nest
+        value: 1
+        multi-attr: true
+        nested-attributes: string
+  -
+    name: stringset
+    attributes:
+      -
+        name: id
+        type: u32
+        value: 1
+      -
+        name: count
+        type: u32
+      -
+        name: strings
+        type: nest
+        multi-attr: true
+        nested-attributes: strings
+  -
+    name: stringsets
+    attributes:
+      -
+        name: stringset
+        type: nest
+        multi-attr: true
+        value: 1
+        nested-attributes: stringset
+  -
+    name: strset
+    attributes:
+      -
+        name: header
+        value: 1
+        type: nest
+        nested-attributes: header
+      -
+        name: stringsets
+        type: nest
+        nested-attributes: stringsets
+      -
+        name: counts-only
+        type: flag
+
+  -
+    name: privflags
+    attributes:
+      -
+        name: header
+        value: 1
+        type: nest
+        nested-attributes: header
+      -
+        name: flags
+        type: nest
+        nested-attributes: bitset
+
+  -
+    name: rings
+    attributes:
+      -
+        name: header
+        value: 1
+        type: nest
+        nested-attributes: header
+      -
+        name: rx-max
+        type: u32
+      -
+        name: rx-mini-max
+        type: u32
+      -
+        name: rx-jumbo-max
+        type: u32
+      -
+        name: tx-max
+        type: u32
+      -
+        name: rx
+        type: u32
+      -
+        name: rx-mini
+        type: u32
+      -
+        name: rx-jumbo
+        type: u32
+      -
+        name: tx
+        type: u32
+      -
+        name: rx-buf-len
+        type: u32
+      -
+        name: tcp-data-split
+        type: u8
+      -
+        name: cqe-size
+        type: u32
+      -
+        name: tx-push
+        type: u8
+
+  -
+    name: mm-stat
+    attributes:
+      -
+        name: pad
+        value: 1
+        type: pad
+      -
+        name: reassembly-errors
+        type: u64
+      -
+        name: smd-errors
+        type: u64
+      -
+        name: reassembly-ok
+        type: u64
+      -
+        name: rx-frag-count
+        type: u64
+      -
+        name: tx-frag-count
+        type: u64
+      -
+        name: hold-count
+        type: u64
+  -
+    name: mm
+    attributes:
+      -
+        name: header
+        value: 1
+        type: nest
+        nested-attributes: header
+      -
+        name: pmac-enabled
+        type: u8
+      -
+        name: tx-enabled
+        type: u8
+      -
+        name: tx-active
+        type: u8
+      -
+        name: tx-min-frag-size
+        type: u32
+      -
+        name: tx-min-frag-size
+        type: u32
+      -
+        name: verify-enabled
+        type: u8
+      -
+        name: verify-status
+        type: u8
+      -
+        name: verify-time
+        type: u32
+      -
+        name: max-verify-time
+        type: u32
+      -
+        name: stats
+        type: nest
+        nested-attributes: mm-stat
+
+operations:
+  enum-model: directional
+  list:
+    -
+      name: strset-get
+      doc: Get string set from the kernel.
+
+      attribute-set: strset
+
+      do: &strset-get-op
+        request:
+          value: 1
+          attributes:
+            - header
+            - stringsets
+            - counts-only
+        reply:
+          value: 1
+          attributes:
+            - header
+            - stringsets
+      dump: *strset-get-op
+
+    # TODO: fill in the requests in between
+
+    -
+      name: privflags-get
+      doc: Get device private flags.
+
+      attribute-set: privflags
+
+      do: &privflag-get-op
+        request:
+          value: 13
+          attributes:
+            - header
+        reply:
+          value: 14
+          attributes:
+            - header
+            - flags
+      dump: *privflag-get-op
+    -
+      name: privflags-set
+      doc: Set device private flags.
+
+      attribute-set: privflags
+
+      do:
+        request:
+          attributes:
+            - header
+            - flags
+    -
+      name: privflags-ntf
+      doc: Notification for change in device private flags.
+      notify: privflags-get
+
+    -
+      name: rings-get
+      doc: Get ring params.
+
+      attribute-set: rings
+
+      do: &ring-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes:
+            - header
+            - rx-max
+            - rx-mini-max
+            - rx-jumbo-max
+            - tx-max
+            - rx
+            - rx-mini
+            - rx-jumbo
+            - tx
+            - rx-buf-len
+            - tcp-data-split
+            - cqe-size
+            - tx-push
+      dump: *ring-get-op
+    -
+      name: rings-set
+      doc: Set ring params.
+
+      attribute-set: rings
+
+      do:
+        request:
+          attributes:
+            - header
+            - rx
+            - rx-mini
+            - rx-jumbo
+            - tx
+            - rx-buf-len
+            - tcp-data-split
+            - cqe-size
+            - tx-push
+    -
+      name: rings-ntf
+      doc: Notification for change in ring params.
+      notify: rings-get
+
+    # TODO: fill in the requests in between
+
+    -
+      name: mm-get
+      doc: Get MAC Merge configuration and state
+
+      attribute-set: mm
+
+      do: &mm-get-op
+        request:
+          value: 42
+          attributes:
+            - header
+        reply:
+          value: 42
+          attributes:
+            - header
+            - pmac-enabled
+            - tx-enabled
+            - tx-active
+            - tx-min-frag-size
+            - rx-min-frag-size
+            - verify-enabled
+            - verify-time
+            - max-verify-time
+            - stats
+      dump: *mm-get-op
+    -
+      name: mm-set
+      doc: Set MAC Merge configuration
+
+      attribute-set: mm
+
+      do:
+        request:
+          attributes:
+            - header
+            - verify-enabled
+            - verify-time
+            - tx-enabled
+            - pmac-enabled
+            - tx-min-frag-size
+    -
+      name: mm-ntf
+      doc: Notification for change in MAC Merge configuration.
+      notify: mm-get
-- 
2.39.1


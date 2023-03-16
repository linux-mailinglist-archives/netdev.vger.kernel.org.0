Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADAF6BC567
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjCPEtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPEtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:49:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202191D919
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 21:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B700E61F11
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A91C433EF;
        Thu, 16 Mar 2023 04:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678942156;
        bh=sUvVhK2OZx1FnnXsWHtvDKzQp3vKuR49beVQ83N0f+o=;
        h=From:To:Cc:Subject:Date:From;
        b=W2RloIPNO8Q4Vr/WXybdx9DBv+XfOimA+sNgP3Pe2BQKnXQFxKdfwKE/CnxAyAynH
         HrX2hKhQd9D/Pmr8zHtFmk7Xy3eLI2xMEzkMNxMCXRJS9V+07enDo2iudp1fOF2LkS
         K3hYFtX7umPUteCSaoipXZBOj9gQP4pehqat5+5plAwu3nZpi+LGDtTkiNkAcAv1a1
         tw8oZ8wmhHsKKmiWqJmpETm7QsD5S1N2L+z8Pstq4SBU/NVXfvkvhEhiSyhNWPmGAp
         NYt1IIPoKPtFAwOJvl+HASzr7iLbGsIbGOzVHqV/NY+sPBPp+3F9/asfTEBvbhpNCC
         xQecphJzgeJ7g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] netlink-specs: add partial specification for devlink
Date:   Wed, 15 Mar 2023 21:49:13 -0700
Message-Id: <20230316044913.528600-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
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

Devlink is quite complex but put in the very basics so we can
incrementally fill in the commands as needed.

$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/devlink.yaml \
    --dump get

[{'bus-name': 'netdevsim',
  'dev-name': 'netdevsim1',
  'dev-stats': {'reload-stats': {'reload-action-info': {'reload-action': 1,
                                                        'reload-action-stats': {'reload-stats-entry': [{'reload-stats-limit': 0,
                                                                                                        'reload-stats-value': 0}]}}},
                'remote-reload-stats': {'reload-action-info': {'reload-action': 2,
                                                               'reload-action-stats': {'reload-stats-entry': [{'reload-stats-limit': 0,
                                                                                                               'reload-stats-value': 0},
                                                                                                              {'reload-stats-limit': 1,
                                                                                                               'reload-stats-value': 0}]}}}},
  'reload-failed': 0}]

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/devlink.yaml | 198 +++++++++++++++++++++++
 1 file changed, 198 insertions(+)
 create mode 100644 Documentation/netlink/specs/devlink.yaml

diff --git a/Documentation/netlink/specs/devlink.yaml b/Documentation/netlink/specs/devlink.yaml
new file mode 100644
index 000000000000..90641668232e
--- /dev/null
+++ b/Documentation/netlink/specs/devlink.yaml
@@ -0,0 +1,198 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+
+name: devlink
+
+protocol: genetlink-legacy
+
+doc: Partial family for Devlink.
+
+attribute-sets:
+  -
+    name: devlink
+    attributes:
+      -
+        name: bus-name
+        type: string
+        value: 1
+      -
+        name: dev-name
+        type: string
+      -
+        name: port-index
+        type: u32
+
+      # TODO: fill in the attributes in between
+
+      -
+        name: info-driver-name
+        type: string
+        value: 98
+      -
+        name: info-serial-number
+        type: string
+      -
+        name: info-version-fixed
+        type: nest
+        multi-attr: true
+        nested-attributes: dl-info-version
+      -
+        name: info-version-running
+        type: nest
+        multi-attr: true
+        nested-attributes: dl-info-version
+      -
+        name: info-version-stored
+        type: nest
+        multi-attr: true
+        nested-attributes: dl-info-version
+      -
+        name: info-version-name
+        type: string
+      -
+        name: info-version-value
+        type: string
+
+      # TODO: fill in the attributes in between
+
+      -
+        name: reload-failed
+        type: u8
+        value: 136
+
+      # TODO: fill in the attributes in between
+
+      -
+        name: reload-action
+        type: u8
+        value: 153
+
+      # TODO: fill in the attributes in between
+
+      -
+        name: dev-stats
+        type: nest
+        value: 156
+        nested-attributes: dl-dev-stats
+      -
+        name: reload-stats
+        type: nest
+        nested-attributes: dl-reload-stats
+      -
+        name: reload-stats-entry
+        type: nest
+        multi-attr: true
+        nested-attributes: dl-reload-stats-entry
+      -
+        name: reload-stats-limit
+        type: u8
+      -
+        name: reload-stats-value
+        type: u32
+      -
+        name: remote-reload-stats
+        type: nest
+        nested-attributes: dl-reload-stats
+      -
+        name: reload-action-info
+        type: nest
+        nested-attributes: dl-reload-act-info
+      -
+        name: reload-action-stats
+        type: nest
+        nested-attributes: dl-reload-act-stats
+  -
+    name: dl-dev-stats
+    subset-of: devlink
+    attributes:
+      -
+        name: reload-stats
+        type: nest
+      -
+        name: remote-reload-stats
+        type: nest
+  -
+    name: dl-reload-stats
+    subset-of: devlink
+    attributes:
+      -
+        name: reload-action-info
+        type: nest
+  -
+    name: dl-reload-act-info
+    subset-of: devlink
+    attributes:
+      -
+        name: reload-action
+        type: u8
+      -
+        name: reload-action-stats
+        type: nest
+  -
+    name: dl-reload-act-stats
+    subset-of: devlink
+    attributes:
+      -
+        name: reload-stats-entry
+        type: nest
+  -
+    name: dl-reload-stats-entry
+    subset-of: devlink
+    attributes:
+      -
+        name: reload-stats-limit
+        type: u8
+      -
+        name: reload-stats-value
+        type: u32
+  -
+    name: dl-info-version
+    subset-of: devlink
+    attributes:
+      -
+        name: info-version-name
+        type: string
+      -
+        name: info-version-value
+        type: string
+
+operations:
+  enum-model: directional
+  list:
+    -
+      name: get
+      doc: Get devlink instances.
+      attribute-set: devlink
+
+      do:
+        request:
+          value: 1
+          attributes: &dev-id-attrs
+            - bus-name
+            - dev-name
+        reply:  &get-reply
+          value: 3
+          attributes:
+            - bus-name
+            - dev-name
+            - reload-failed
+            - reload-action
+            - dev-stats
+      dump:
+        reply: *get-reply
+
+      # TODO: fill in the operations in between
+
+    -
+      name: info-get
+      doc: Get device information, like driver name, hardware and firmware versions etc.
+      attribute-set: devlink
+
+      do:
+        request:
+          value: 51
+          attributes: *dev-id-attrs
+        reply:
+          value: 51
+          attributes:
+            - bus-name
+            - dev-name
-- 
2.39.2


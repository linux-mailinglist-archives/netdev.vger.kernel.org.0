Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB609672D7C
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 01:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjASAgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 19:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjASAgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 19:36:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F26589BA;
        Wed, 18 Jan 2023 16:36:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 281D2B81FB8;
        Thu, 19 Jan 2023 00:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D7DC43392;
        Thu, 19 Jan 2023 00:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674088579;
        bh=NoqjezcTXZL9KT0Wefm+wFcBaGOH1Fo2sYIPd4RbLLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rn+5Dv6j0urtkHBYfNUIQrlwiTzWF4I3UGt6SW98Pn8a5HM/c4+GdcgBfQsq3A9Qc
         uidNmPebEccDMSC6qanCI51OUqB/648fHzCLrIUdRz9BPcv3xCfua8g9vHZtKaFnlK
         CbZ/YU1pO0fxVUzd5YQNnGj0HDSiAyZnl2yaAeaOmi6GWEGOZG20oY53pyOlQgnTDr
         xYeT3jpuKluF5SaqBzeBwLLXll1dLc6bRr99otdSDhwt/KJsk9mY09Vf8UwRKCBWbF
         1blFGK4TJwC/4rEMc4JTufawVeGS+HAFkY75MZLxIQaa7puqCXOgf0Vmj7Ag7j5pPy
         CuvE0HwqoW2sw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 2/8] netlink: add schemas for YAML specs
Date:   Wed, 18 Jan 2023 16:36:07 -0800
Message-Id: <20230119003613.111778-3-kuba@kernel.org>
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

Add schemas for Netlink spec files. As described in the docs
we have 4 "protocols" or compatibility levels, and each one
comes with its own schema, but the more general / legacy
schemas are superset of more modern ones: genetlink is
the smallest followed by genetlink-c and genetlink-legacy.
There is no schema for raw netlink, yet, I haven't found the time..

I don't know enough jsonschema to do inheritance or something
but the repetition is not too bad. I hope.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/genetlink-c.yaml      | 318 ++++++++++++++++++
 Documentation/netlink/genetlink-legacy.yaml | 346 ++++++++++++++++++++
 Documentation/netlink/genetlink.yaml        | 284 ++++++++++++++++
 3 files changed, 948 insertions(+)
 create mode 100644 Documentation/netlink/genetlink-c.yaml
 create mode 100644 Documentation/netlink/genetlink-legacy.yaml
 create mode 100644 Documentation/netlink/genetlink.yaml

diff --git a/Documentation/netlink/genetlink-c.yaml b/Documentation/netlink/genetlink-c.yaml
new file mode 100644
index 000000000000..53a7fe94a47e
--- /dev/null
+++ b/Documentation/netlink/genetlink-c.yaml
@@ -0,0 +1,318 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: "http://kernel.org/schemas/netlink/genetlink-c.yaml#"
+$schema: "http://kernel.org/meta-schemas/netlink/core.yaml#"
+
+title: Protocol
+description: Specification of a genetlink protocol
+type: object
+required: [ name, doc, attribute-sets, operations ]
+additionalProperties: False
+properties:
+  name:
+    description: Name of the genetlink family.
+    type: string
+  doc:
+    type: string
+  version:
+    description: Generic Netlink family version. Default is 1.
+    type: integer
+  protocol:
+    description: Schema compatibility level. Default is "genetlink".
+    enum: [ genetlink, genetlink-c]
+  # Start genetlink-c
+  uapi-header:
+    description: Path to the uAPI header, default is linux/${family-name}.h
+    type: string
+  c-family-name:
+    description: Name of the define for the family name.
+    type: string
+  c-version-name:
+    description: Name of the define for the verion of the family.
+    type: string
+  max-by-define:
+    description: Makes the number of attributes and commands be specified by a define, not an enum value.
+    type: boolean
+  # End genetlink-c
+
+  definitions:
+    description: Array of type and constant definitions.
+    type: array
+    items:
+      type: object
+      required: [ type, name ]
+      additionalProperties: False
+      properties:
+        name:
+          type: string
+        header:
+          description: For C-compatible languages, header which already defines this value.
+          type: string
+        type:
+          enum: [ const, enum, flags ]
+        doc:
+          type: string
+        # For const
+        value:
+          description: For const - the value.
+          type: [ string, integer ]
+        # For enum and flags
+        value-start:
+          description: For enum or flags the literal initializer for the first value.
+          type: [ string, integer ]
+        entries:
+          description: For enum or flags array of values
+          type: array
+          items:
+            oneOf:
+              - type: string
+              - type: object
+                required: [ name ]
+                additionalProperties: False
+                properties:
+                  name:
+                    type: string
+                  value:
+                    type: integer
+                  doc:
+                    type: string
+        render-max:
+          description: Render the max members for this enum.
+          type: boolean
+        # Start genetlink-c
+        enum-name:
+          description: Name for enum, if empty no name will be used.
+          type: [ string, "null" ]
+        name-prefix:
+          description: For enum the prefix of the values, optional.
+          type: string
+        # End genetlink-c
+
+  attribute-sets:
+    description: Definition of attribute spaces for this family.
+    type: array
+    items:
+      description: Definition of a single attribute space.
+      type: object
+      required: [ name, attributes ]
+      additionalProperties: False
+      properties:
+        name:
+          description: |
+            Name used when referring to this space in other definitions, not used outside of YAML.
+          type: string
+        # Strictly speaking 'name-prefix' and 'subset-of' should be mutually exclusive.
+        name-prefix:
+          description: |
+            Prefix for the C enum name of the attributes. Default family[name]-set[name]-a-
+          type: string
+        enum-name:
+          description: Name for the enum type of the attribute.
+          type: string
+        doc:
+          description: Documentation of the space.
+          type: string
+        subset-of:
+          description: |
+            Name of another space which this is a logical part of. Sub-spaces can be used to define
+            a limited group of attributes which are used in a nest.
+          type: string
+        # Start genetlink-c
+        attr-cnt-name:
+          description: The explicit name for constant holding the count of attributes (last attr + 1).
+          type: string
+        attr-max-name:
+          description: The explicit name for last member of attribute enum.
+          type: string
+        # End genetlink-c
+        attributes:
+          description: List of attributes in the space.
+          type: array
+          items:
+            type: object
+            required: [ name, type ]
+            additionalProperties: False
+            properties:
+              name:
+                type: string
+              type: &attr-type
+                enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
+                        string, nest, array-nest, nest-type-value ]
+              doc:
+                description: Documentation of the attribute.
+                type: string
+              value:
+                description: Value for the enum item representing this attribute in the uAPI.
+                type: integer
+              type-value:
+                description: Name of the value extracted from the type of a nest-type-value attribute.
+                type: array
+                items:
+                  type: string
+              byte-order:
+                enum: [little-endian, big-endian]
+              multi-attr:
+                type: boolean
+              nested-attributes:
+                description: Name of the space (sub-space) used inside the attribute.
+                type: string
+              enum:
+                description: Name of the enum type used for the atttribute.
+                type: string
+              enum-as-flags:
+                description: |
+                  Treat the enum as flags. In most cases enum is either used as flags or as values.
+                  Sometimes, however, both forms are necessary, in which case header contains the enum
+                  form while specific attributes may request to convert the values into a bitfield.
+                type: boolean
+              checks:
+                description: Kernel input validation.
+                type: object
+                additionalProperties: False
+                properties:
+                  flags-mask:
+                    description: Name of the flags constant on which to base mask (unsigned scalar types only).
+                    type: string
+                  min:
+                    description: Min value for an integer attribute.
+                    type: integer
+                  min-len:
+                    description: Min length for a binary attribute.
+                    oneOf:
+                      - type: string
+                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
+                      - type: integer
+                  max-len:
+                    description: Max length for a string or a binary attribute.
+                    oneOf:
+                      - type: string
+                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
+                      - type: integer
+              sub-type: *attr-type
+  operations:
+    description: Operations supported by the protocol.
+    type: object
+    required: [ list ]
+    additionalProperties: False
+    properties:
+      enum-model:
+        description: |
+          The model of assigning values to the operations.
+          "unified" is the recommended model where all message types belong
+          to a single enum.
+          "directional" has the messages sent to the kernel and from the kernel
+          enumerated separately.
+          "notify-split" has the notifications and request-response types in
+          different enums.
+        enum: [ unified, directional, notify-split ]
+      name-prefix:
+        description: |
+          Prefix for the C enum name of the command. The name is formed by concatenating
+          the prefix with the upper case name of the command, with dashes replaced by underscores.
+        type: string
+      enum-name:
+        description: Name for the enum type with commands.
+        type: string
+      async-prefix:
+        description: Same as name-prefix but used to render notifications and events to separate enum.
+        type: string
+      async-enum:
+        description: Name for the enum type with notifications/events.
+        type: string
+      list:
+        description: List of commands
+        type: array
+        items:
+          type: object
+          additionalProperties: False
+          required: [ name, doc ]
+          properties:
+            name:
+              description: Name of the operation, also defining its C enum value in uAPI.
+              type: string
+            doc:
+              description: Documentation for the command.
+              type: string
+            value:
+              description: Value for the enum in the uAPI.
+              type: integer
+            attribute-set:
+              description: |
+                Attribute space from which attributes directly in the requests and replies
+                to this command are defined.
+              type: string
+            flags: &cmd_flags
+              description: Command flags.
+              type: array
+              items:
+                enum: [ admin-perm ]
+            dont-validate:
+              description: Kernel attribute validation flags.
+              type: array
+              items:
+                enum: [ strict, dump ]
+            do: &subop-type
+              description: Main command handler.
+              type: object
+              additionalProperties: False
+              properties:
+                request: &subop-attr-list
+                  description: Definition of the request message for a given command.
+                  type: object
+                  additionalProperties: False
+                  properties:
+                    attributes:
+                      description: |
+                        Names of attributes from the attribute-set (not full attribute
+                        definitions, just names).
+                      type: array
+                      items:
+                        type: string
+                reply: *subop-attr-list
+                pre:
+                  description: Hook for a function to run before the main callback (pre_doit or start).
+                  type: string
+                post:
+                  description: Hook for a function to run after the main callback (post_doit or done).
+                  type: string
+            dump: *subop-type
+            notify:
+              description: Name of the command sharing the reply type with this notification.
+              type: string
+            event:
+              type: object
+              additionalProperties: False
+              properties:
+                attributes:
+                  description: Explicit list of the attributes for the notification.
+                  type: array
+                  items:
+                    type: string
+            mcgrp:
+              description: Name of the multicast group generating given notification.
+              type: string
+  mcast-groups:
+    description: List of multicast groups.
+    type: object
+    required: [ list ]
+    additionalProperties: False
+    properties:
+      list:
+        description: List of groups.
+        type: array
+        items:
+          type: object
+          required: [ name ]
+          additionalProperties: False
+          properties:
+            name:
+              description: |
+                The name for the group, used to form the define and the value of the define.
+              type: string
+            # Start genetlink-c
+            c-define-name:
+              description: Override for the name of the define in C uAPI.
+              type: string
+            # End genetlink-c
+            flags: *cmd_flags
diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
new file mode 100644
index 000000000000..5e57453eac1a
--- /dev/null
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -0,0 +1,346 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: "http://kernel.org/schemas/netlink/genetlink-legacy.yaml#"
+$schema: "http://kernel.org/meta-schemas/netlink/core.yaml#"
+
+title: Protocol
+description: Specification of a genetlink protocol
+type: object
+required: [ name, doc, attribute-sets, operations ]
+additionalProperties: False
+properties:
+  name:
+    description: Name of the genetlink family.
+    type: string
+  doc:
+    type: string
+  version:
+    description: Generic Netlink family version. Default is 1.
+    type: integer
+  protocol:
+    description: Schema compatibility level. Default is "genetlink".
+    enum: [ genetlink, genetlink-c, genetlink-legacy, netlink-raw ] # Trim
+  # Start genetlink-c
+  uapi-header:
+    description: Path to the uAPI header, default is linux/${family-name}.h
+    type: string
+  c-family-name:
+    description: Name of the define for the family name.
+    type: string
+  c-version-name:
+    description: Name of the define for the verion of the family.
+    type: string
+  max-by-define:
+    description: Makes the number of attributes and commands be specified by a define, not an enum value.
+    type: boolean
+  # End genetlink-c
+  # Start genetlink-legacy
+  kernel-policy:
+    description: |
+      Defines if the input policy in the kernel is global, per-operation, or split per operation type.
+      Default is split.
+    enum: [split, per-op, global]
+  # End genetlink-legacy
+
+  definitions:
+    description: Array of type and constant definitions.
+    type: array
+    items:
+      type: object
+      required: [ type, name ]
+      additionalProperties: False
+      properties:
+        name:
+          type: string
+        header:
+          description: For C-compatible languages, header which already defines this value.
+          type: string
+        type:
+          enum: [ const, enum, flags, struct ] # Trim
+        doc:
+          type: string
+        # For const
+        value:
+          description: For const - the value.
+          type: [ string, integer ]
+        # For enum and flags
+        value-start:
+          description: For enum or flags the literal initializer for the first value.
+          type: [ string, integer ]
+        entries:
+          description: For enum or flags array of values
+          type: array
+          items:
+            oneOf:
+              - type: string
+              - type: object
+                required: [ name ]
+                additionalProperties: False
+                properties:
+                  name:
+                    type: string
+                  value:
+                    type: integer
+                  doc:
+                    type: string
+        render-max:
+          description: Render the max members for this enum.
+          type: boolean
+        # Start genetlink-c
+        enum-name:
+          description: Name for enum, if empty no name will be used.
+          type: [ string, "null" ]
+        name-prefix:
+          description: For enum the prefix of the values, optional.
+          type: string
+        # End genetlink-c
+        # Start genetlink-legacy
+        members:
+          description: List of struct members. Only scalars and strings members allowed.
+          type: array
+          items:
+            type: object
+            required: [ name, type ]
+            additionalProperties: False
+            properties:
+              name:
+                type: string
+              type:
+                enum: [ u8, u16, u32, u64, s8, s16, s32, s64, string ]
+              len:
+                oneOf:
+                  -
+                    type: string
+                    pattern: ^[0-9A-Za-z_-]*( - 1)?$
+                  -
+                    type: integer
+        # End genetlink-legacy
+
+  attribute-sets:
+    description: Definition of attribute spaces for this family.
+    type: array
+    items:
+      description: Definition of a single attribute space.
+      type: object
+      required: [ name, attributes ]
+      additionalProperties: False
+      properties:
+        name:
+          description: |
+            Name used when referring to this space in other definitions, not used outside of YAML.
+          type: string
+        # Strictly speaking 'name-prefix' and 'subset-of' should be mutually exclusive.
+        name-prefix:
+          description: |
+            Prefix for the C enum name of the attributes. Default family[name]-set[name]-a-
+          type: string
+        enum-name:
+          description: Name for the enum type of the attribute.
+          type: string
+        doc:
+          description: Documentation of the space.
+          type: string
+        subset-of:
+          description: |
+            Name of another space which this is a logical part of. Sub-spaces can be used to define
+            a limited group of attributes which are used in a nest.
+          type: string
+        # Start genetlink-c
+        attr-cnt-name:
+          description: The explicit name for constant holding the count of attributes (last attr + 1).
+          type: string
+        attr-max-name:
+          description: The explicit name for last member of attribute enum.
+          type: string
+        # End genetlink-c
+        attributes:
+          description: List of attributes in the space.
+          type: array
+          items:
+            type: object
+            required: [ name, type ]
+            additionalProperties: False
+            properties:
+              name:
+                type: string
+              type: &attr-type
+                enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
+                        string, nest, array-nest, nest-type-value ]
+              doc:
+                description: Documentation of the attribute.
+                type: string
+              value:
+                description: Value for the enum item representing this attribute in the uAPI.
+                type: integer
+              type-value:
+                description: Name of the value extracted from the type of a nest-type-value attribute.
+                type: array
+                items:
+                  type: string
+              byte-order:
+                enum: [little-endian, big-endian]
+              multi-attr:
+                type: boolean
+              nested-attributes:
+                description: Name of the space (sub-space) used inside the attribute.
+                type: string
+              enum:
+                description: Name of the enum type used for the atttribute.
+                type: string
+              enum-as-flags:
+                description: |
+                  Treat the enum as flags. In most cases enum is either used as flags or as values.
+                  Sometimes, however, both forms are necessary, in which case header contains the enum
+                  form while specific attributes may request to convert the values into a bitfield.
+                type: boolean
+              checks:
+                description: Kernel input validation.
+                type: object
+                additionalProperties: False
+                properties:
+                  flags-mask:
+                    description: Name of the flags constant on which to base mask (unsigned scalar types only).
+                    type: string
+                  min:
+                    description: Min value for an integer attribute.
+                    type: integer
+                  min-len:
+                    description: Min length for a binary attribute.
+                    oneOf:
+                      - type: string
+                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
+                      - type: integer
+                  max-len:
+                    description: Max length for a string or a binary attribute.
+                    oneOf:
+                      - type: string
+                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
+                      - type: integer
+              sub-type: *attr-type
+  operations:
+    description: Operations supported by the protocol.
+    type: object
+    required: [ list ]
+    additionalProperties: False
+    properties:
+      enum-model:
+        description: |
+          The model of assigning values to the operations.
+          "unified" is the recommended model where all message types belong
+          to a single enum.
+          "directional" has the messages sent to the kernel and from the kernel
+          enumerated separately.
+          "notify-split" has the notifications and request-response types in
+          different enums.
+        enum: [ unified, directional, notify-split ]
+      name-prefix:
+        description: |
+          Prefix for the C enum name of the command. The name is formed by concatenating
+          the prefix with the upper case name of the command, with dashes replaced by underscores.
+        type: string
+      enum-name:
+        description: Name for the enum type with commands.
+        type: string
+      async-prefix:
+        description: Same as name-prefix but used to render notifications and events to separate enum.
+        type: string
+      async-enum:
+        description: Name for the enum type with notifications/events.
+        type: string
+      list:
+        description: List of commands
+        type: array
+        items:
+          type: object
+          additionalProperties: False
+          required: [ name, doc ]
+          properties:
+            name:
+              description: Name of the operation, also defining its C enum value in uAPI.
+              type: string
+            doc:
+              description: Documentation for the command.
+              type: string
+            value:
+              description: Value for the enum in the uAPI.
+              type: integer
+            attribute-set:
+              description: |
+                Attribute space from which attributes directly in the requests and replies
+                to this command are defined.
+              type: string
+            flags: &cmd_flags
+              description: Command flags.
+              type: array
+              items:
+                enum: [ admin-perm ]
+            dont-validate:
+              description: Kernel attribute validation flags.
+              type: array
+              items:
+                enum: [ strict, dump ]
+            do: &subop-type
+              description: Main command handler.
+              type: object
+              additionalProperties: False
+              properties:
+                request: &subop-attr-list
+                  description: Definition of the request message for a given command.
+                  type: object
+                  additionalProperties: False
+                  properties:
+                    attributes:
+                      description: |
+                        Names of attributes from the attribute-set (not full attribute
+                        definitions, just names).
+                      type: array
+                      items:
+                        type: string
+                reply: *subop-attr-list
+                pre:
+                  description: Hook for a function to run before the main callback (pre_doit or start).
+                  type: string
+                post:
+                  description: Hook for a function to run after the main callback (post_doit or done).
+                  type: string
+            dump: *subop-type
+            notify:
+              description: Name of the command sharing the reply type with this notification.
+              type: string
+            event:
+              type: object
+              additionalProperties: False
+              properties:
+                attributes:
+                  description: Explicit list of the attributes for the notification.
+                  type: array
+                  items:
+                    type: string
+            mcgrp:
+              description: Name of the multicast group generating given notification.
+              type: string
+  mcast-groups:
+    description: List of multicast groups.
+    type: object
+    required: [ list ]
+    additionalProperties: False
+    properties:
+      list:
+        description: List of groups.
+        type: array
+        items:
+          type: object
+          required: [ name ]
+          additionalProperties: False
+          properties:
+            name:
+              description: |
+                The name for the group, used to form the define and the value of the define.
+              type: string
+            # Start genetlink-c
+            c-define-name:
+              description: Override for the name of the define in C uAPI.
+              type: string
+            # End genetlink-c
+            flags: *cmd_flags
diff --git a/Documentation/netlink/genetlink.yaml b/Documentation/netlink/genetlink.yaml
new file mode 100644
index 000000000000..aafaaaabcfbe
--- /dev/null
+++ b/Documentation/netlink/genetlink.yaml
@@ -0,0 +1,284 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: "http://kernel.org/schemas/netlink/genetlink.yaml#"
+$schema: "http://kernel.org/meta-schemas/netlink/core.yaml#"
+
+title: Protocol
+description: Specification of a genetlink protocol
+type: object
+required: [ name, doc, attribute-sets, operations ]
+additionalProperties: False
+properties:
+  name:
+    description: Name of the genetlink family.
+    type: string
+  doc:
+    type: string
+  version:
+    description: Generic Netlink family version. Default is 1.
+    type: integer
+  protocol:
+    description: Schema compatibility level. Default is "genetlink".
+    enum: [ genetlink ]
+
+  definitions:
+    description: Array of type and constant definitions.
+    type: array
+    items:
+      type: object
+      required: [ type, name ]
+      additionalProperties: False
+      properties:
+        name:
+          type: string
+        header:
+          description: For C-compatible languages, header which already defines this value.
+          type: string
+        type:
+          enum: [ const, enum, flags ]
+        doc:
+          type: string
+        # For const
+        value:
+          description: For const - the value.
+          type: [ string, integer ]
+        # For enum and flags
+        value-start:
+          description: For enum or flags the literal initializer for the first value.
+          type: [ string, integer ]
+        entries:
+          description: For enum or flags array of values
+          type: array
+          items:
+            oneOf:
+              - type: string
+              - type: object
+                required: [ name ]
+                additionalProperties: False
+                properties:
+                  name:
+                    type: string
+                  value:
+                    type: integer
+                  doc:
+                    type: string
+
+        render-max:
+          description: Render the max members for this enum.
+          type: boolean
+
+  attribute-sets:
+    description: Definition of attribute spaces for this family.
+    type: array
+    items:
+      description: Definition of a single attribute space.
+      type: object
+      required: [ name, attributes ]
+      additionalProperties: False
+      properties:
+        name:
+          description: |
+            Name used when referring to this space in other definitions, not used outside of YAML.
+          type: string
+        # Strictly speaking 'name-prefix' and 'subset-of' should be mutually exclusive.
+        name-prefix:
+          description: |
+            Prefix for the C enum name of the attributes. Default family[name]-set[name]-a-
+          type: string
+        enum-name:
+          description: Name for the enum type of the attribute.
+          type: string
+        doc:
+          description: Documentation of the space.
+          type: string
+        subset-of:
+          description: |
+            Name of another space which this is a logical part of. Sub-spaces can be used to define
+            a limited group of attributes which are used in a nest.
+          type: string
+        attributes:
+          description: List of attributes in the space.
+          type: array
+          items:
+            type: object
+            required: [ name, type ]
+            additionalProperties: False
+            properties:
+              name:
+                type: string
+              type: &attr-type
+                enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
+                        string, nest, array-nest, nest-type-value ]
+              doc:
+                description: Documentation of the attribute.
+                type: string
+              value:
+                description: Value for the enum item representing this attribute in the uAPI.
+                type: integer
+              type-value:
+                description: Name of the value extracted from the type of a nest-type-value attribute.
+                type: array
+                items:
+                  type: string
+              byte-order:
+                enum: [little-endian, big-endian]
+              multi-attr:
+                type: boolean
+              nested-attributes:
+                description: Name of the space (sub-space) used inside the attribute.
+                type: string
+              enum:
+                description: Name of the enum type used for the atttribute.
+                type: string
+              enum-as-flags:
+                description: |
+                  Treat the enum as flags. In most cases enum is either used as flags or as values.
+                  Sometimes, however, both forms are necessary, in which case header contains the enum
+                  form while specific attributes may request to convert the values into a bitfield.
+                type: boolean
+              checks:
+                description: Kernel input validation.
+                type: object
+                additionalProperties: False
+                properties:
+                  flags-mask:
+                    description: Name of the flags constant on which to base mask (unsigned scalar types only).
+                    type: string
+                  min:
+                    description: Min value for an integer attribute.
+                    type: integer
+                  min-len:
+                    description: Min length for a binary attribute.
+                    oneOf:
+                      - type: string
+                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
+                      - type: integer
+                  max-len:
+                    description: Max length for a string or a binary attribute.
+                    oneOf:
+                      - type: string
+                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
+                      - type: integer
+              sub-type: *attr-type
+  operations:
+    description: Operations supported by the protocol.
+    type: object
+    required: [ list ]
+    additionalProperties: False
+    properties:
+      enum-model:
+        description: |
+          The model of assigning values to the operations.
+          "unified" is the recommended model where all message types belong
+          to a single enum.
+          "directional" has the messages sent to the kernel and from the kernel
+          enumerated separately.
+          "notify-split" has the notifications and request-response types in
+          different enums.
+        enum: [ unified, directional, notify-split ]
+      name-prefix:
+        description: |
+          Prefix for the C enum name of the command. The name is formed by concatenating
+          the prefix with the upper case name of the command, with dashes replaced by underscores.
+        type: string
+      enum-name:
+        description: Name for the enum type with commands.
+        type: string
+      async-prefix:
+        description: Same as name-prefix but used to render notifications and events to separate enum.
+        type: string
+      async-enum:
+        description: Name for the enum type with notifications/events.
+        type: string
+      list:
+        description: List of commands
+        type: array
+        items:
+          type: object
+          additionalProperties: False
+          required: [ name, doc ]
+          properties:
+            name:
+              description: Name of the operation, also defining its C enum value in uAPI.
+              type: string
+            doc:
+              description: Documentation for the command.
+              type: string
+            value:
+              description: Value for the enum in the uAPI.
+              type: integer
+            attribute-set:
+              description: |
+                Attribute space from which attributes directly in the requests and replies
+                to this command are defined.
+              type: string
+            flags: &cmd_flags
+              description: Command flags.
+              type: array
+              items:
+                enum: [ admin-perm ]
+            dont-validate:
+              description: Kernel attribute validation flags.
+              type: array
+              items:
+                enum: [ strict, dump ]
+            do: &subop-type
+              description: Main command handler.
+              type: object
+              additionalProperties: False
+              properties:
+                request: &subop-attr-list
+                  description: Definition of the request message for a given command.
+                  type: object
+                  additionalProperties: False
+                  properties:
+                    attributes:
+                      description: |
+                        Names of attributes from the attribute-set (not full attribute
+                        definitions, just names).
+                      type: array
+                      items:
+                        type: string
+                reply: *subop-attr-list
+                pre:
+                  description: Hook for a function to run before the main callback (pre_doit or start).
+                  type: string
+                post:
+                  description: Hook for a function to run after the main callback (post_doit or done).
+                  type: string
+            dump: *subop-type
+            notify:
+              description: Name of the command sharing the reply type with this notification.
+              type: string
+            event:
+              type: object
+              additionalProperties: False
+              properties:
+                attributes:
+                  description: Explicit list of the attributes for the notification.
+                  type: array
+                  items:
+                    type: string
+            mcgrp:
+              description: Name of the multicast group generating given notification.
+              type: string
+  mcast-groups:
+    description: List of multicast groups.
+    type: object
+    required: [ list ]
+    additionalProperties: False
+    properties:
+      list:
+        description: List of groups.
+        type: array
+        items:
+          type: object
+          required: [ name ]
+          additionalProperties: False
+          properties:
+            name:
+              description: |
+                The name for the group, used to form the define and the value of the define.
+              type: string
+            flags: *cmd_flags
-- 
2.39.0


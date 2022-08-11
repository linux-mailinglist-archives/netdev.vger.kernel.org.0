Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8322758F5D0
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 04:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbiHKCXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 22:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbiHKCXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 22:23:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E67B8D3E7;
        Wed, 10 Aug 2022 19:23:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A6C2B81EF9;
        Thu, 11 Aug 2022 02:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E561C43140;
        Thu, 11 Aug 2022 02:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660184591;
        bh=PYgZgfaNTkCtdsS+K+LJYulNO+xsMmRhLqrbcsvFk+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvB736LkQVIExdwcR7LeXw9JazEr75wr5VoHKYrbipjvl7/h6kvNB/dpcEVvomfpC
         KzA2ydW1RQ7kVhrGALzT2KtdkFOSWBIiSf2InpSdrT0ZLqwD7o3Q2X1IyAKlmLX22l
         SjrrDgbNlS5yN56wARareJw/XT9itIjg82U1IT+dCEldPr8k5V7KFXukU1EG591OVV
         hPeI1rjxbA5TWEsTe/YaTpYkib3kN/+8R5ZekY2NiO/QBl5L+zVL6VwY5fTRpHVLcz
         /tlxx42TDMkxpJew9XYYQ5q72qSwGmHZANRzbAqfTxhGFnUP7Zya96ZPGBNBppr6bS
         JcGMXEKcNUBKQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Cc:     sdf@google.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de,
        linux-doc@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 2/4] ynl: add the schema for the schemas
Date:   Wed, 10 Aug 2022 19:23:02 -0700
Message-Id: <20220811022304.583300-3-kuba@kernel.org>
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

A schema in jsonschema format which should be familiar
to dt-bindings writers. It looks kinda hard to read, TBH,
I'm not sure how to make it better.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/schema.yaml | 242 ++++++++++++++++++++++++++++++
 1 file changed, 242 insertions(+)
 create mode 100644 Documentation/netlink/schema.yaml

diff --git a/Documentation/netlink/schema.yaml b/Documentation/netlink/schema.yaml
new file mode 100644
index 000000000000..1290aa4794ba
--- /dev/null
+++ b/Documentation/netlink/schema.yaml
@@ -0,0 +1,242 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: "http://kernel.org/schemas/netlink/schema.yaml#"
+$schema: "http://kernel.org/meta-schemas/core.yaml#"
+
+title: Protocol
+description: Specification of a genetlink protocol
+type: object
+required: [ name, description, attribute-spaces, operations ]
+additionalProperties: False
+properties:
+  name:
+    description: Name of the genetlink family
+    type: string
+  description:
+    description: Description of the family
+    type: string
+  version:
+    description: Version of the family as defined by genetlink.
+    type: integer
+  attr-cnt-suffix:
+    description: Suffix for last member of attribute enum, default is "MAX".
+    type: string
+  headers:
+    description: C headers defining the protocol
+    type: object
+    additionalProperties: False
+    properties:
+      uapi:
+        description: Path under include/uapi where protocol definition is placed
+        type: string
+      kernel:
+        description: Additional headers on which the protocol definition depends (kernel side)
+        anyOf: &str-or-arrstr
+          -
+            type: array
+            items:
+              type: string
+          -
+            type: string
+      user:
+        description: Additional headers on which the protocol definition depends (user side)
+        anyOf: *str-or-arrstr
+  constants:
+    description: Enums and defines of the protocol
+    type: array
+    items:
+      type: object
+      required: [ type, name ]
+      additionalProperties: False
+      properties:
+        name:
+          type: string
+        type:
+          enum: [ enum, flags ]
+        value-prefix:
+          description: For enum the prefix of the values, optional.
+          type: string
+        value-start:
+          description: For enum the literal initializer for the first value.
+          oneOf: [ { type: string }, { type: integer }]
+        values:
+          description: For enum array of values
+          type: array
+          items:
+            type: string
+
+  attribute-spaces:
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
+        # Strictly speaking 'name-prefix' and 'subspace-of' should be mutually exclusive.
+        name-prefix:
+          description: Prefix for the C enum name of the attributes.
+          type: string
+        name-enum:
+          description: Name for the enum type of the attribute.
+          type: string
+        description:
+          description: Documentation of the space.
+          type: string
+        subspace-of:
+          description: |
+            Name of another space which this is a logical part of. Sub-spaces can be used to define
+            a limitted group of attributes which are used in a nest.
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
+                enum: [ unused, flag, binary, u8, u16, u32, u64, s32, s64,
+                        nul-string, multi-attr, nest, array-nest, nest-type-value ]
+              description:
+                description: Documentation of the attribute.
+                type: string
+              type-value:
+                description: Name of the value extracted from the type of a nest-type-value attribute.
+                type: array
+                items:
+                  type: string
+              len:
+                oneOf: [ { type: string }, { type: integer }]
+              sub-type: *attr-type
+              nested-attributes:
+                description: Name of the space (sub-space) used inside the attribute.
+                type: string
+              enum:
+                description: Name of the enum used for the atttribute.
+                type: string
+              flags-mask:
+                description: Name of the flags constant on which to base mask (unsigned scalar types only).
+                type: string
+  operations:
+    description: Operations supported by the protocol.
+    type: object
+    required: [ name-prefix, list ]
+    additionalProperties: False
+    properties:
+      name-prefix:
+        description: |
+          Prefix for the C enum name of the command. The name is formed by concatenating
+          the prefix with the upper case name of the command, with dashes replaced by underscores.
+        type: string
+      name-enum:
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
+          required: [ name, description ]
+          properties:
+            name:
+              description: Name of the operation, also defining its C enum value in uAPI.
+              type: string
+            description:
+              description: Documentation for the command.
+              type: string
+            value:
+              description: Value for the enum in the uAPI.
+              type: integer
+            attribute-space:
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
+                        Names of attributes from the attribute-space (not full attribute
+                        definitions, just names).
+                      type: array
+                      items:
+                        type: string
+                reply: *subop-attr-list
+            dump: *subop-type
+            notify:
+              description: Name of the command sharing the reply type with this notification.
+              type: string
+            event:
+              description: Explicit list of the attributes for the notification.
+              type: array
+              items:
+                type: string
+            mcgrp:
+              description: Name of the multicast group generating given notification.
+              type: string
+  mcast-groups:
+    description: List of multicast groups.
+    type: object
+    required: [ name-prefix, list ]
+    additionalProperties: False
+    properties:
+      name-prefix:
+        description: Name prefix for the define associated with the group.
+        type: string
+      name-suffix:
+        description: |
+          Name suffix for the define associated with the group. Multicast group defines seem to be unique
+          in having a name-prefix as well as suffix.
+        type: string
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
+                The name for the group, used to form the define and the value of the define, unless value
+                is specified separately.
+              type: string
+            value:
+              description: String value for the define and group name.
+              type: string
+            flags: *cmd_flags
-- 
2.37.1


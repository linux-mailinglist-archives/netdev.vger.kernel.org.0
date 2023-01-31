Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2822682225
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjAaCee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjAaCeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B094536691;
        Mon, 30 Jan 2023 18:34:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2754961380;
        Tue, 31 Jan 2023 02:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C59C433A1;
        Tue, 31 Jan 2023 02:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132445;
        bh=WS10Pn6R3aiHyiJ9QYASn0oIB1HbqiLMRQmCcfMUD30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IviHMrcwrmDgDFjf12td9OL4XDno4Vec546Ocz4cCz+4v+qNtuJk6XLalY1TqmkAw
         2F5SPI0V+Ny6DBCQuQktey08KD/Hm67nUwfkqXANn9gs1vI1D7txE/6GsQONo1EriP
         9EDEWZpYOcIxzgdOSBxd/DD90bthPCbbJtMtInoiFJmVLxmHgiVqq+llD78K3Pqdbn
         5iyv11fuCgejmyTE0PP5AjJQcGre+6HCyte5+zAdhEeourZkQlD97s/i/fwpN3goJh
         bk5WCdb5CA2Wgeo1A6YExOIB3oc33yTFRAJvfeL2H8KMP5gflH2i346qwTO9w8jSVp
         jIRaGei/9mi+Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 10/14] tools: ynl: load jsonschema on demand
Date:   Mon, 30 Jan 2023 18:33:50 -0800
Message-Id: <20230131023354.1732677-11-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131023354.1732677-1-kuba@kernel.org>
References: <20230131023354.1732677-1-kuba@kernel.org>
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

The CLI script tries to validate jsonschema by default.
It's seems better to validate too many times than too few.
However, when copying the scripts to random servers having
to install jsonschema is tedious. Load jsonschema via
importlib, and let the user opt out.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/cli.py        |  4 ++++
 tools/net/ynl/lib/nlspec.py | 11 ++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/cli.py b/tools/net/ynl/cli.py
index 05d1f4069ce1..e64f1478764f 100755
--- a/tools/net/ynl/cli.py
+++ b/tools/net/ynl/cli.py
@@ -13,6 +13,7 @@ from lib import YnlFamily
     parser = argparse.ArgumentParser(description='YNL CLI sample')
     parser.add_argument('--spec', dest='spec', type=str, required=True)
     parser.add_argument('--schema', dest='schema', type=str)
+    parser.add_argument('--no-schema', action='store_true')
     parser.add_argument('--json', dest='json_text', type=str)
     parser.add_argument('--do', dest='do', type=str)
     parser.add_argument('--dump', dest='dump', type=str)
@@ -20,6 +21,9 @@ from lib import YnlFamily
     parser.add_argument('--subscribe', dest='ntf', type=str)
     args = parser.parse_args()
 
+    if args.no_schema:
+        args.schema = ''
+
     attrs = {}
     if args.json_text:
         attrs = json.loads(args.json_text)
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index 4aa3b1ad97f0..e204679ad8b7 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -1,12 +1,16 @@
 # SPDX-License-Identifier: BSD-3-Clause
 
 import collections
-import jsonschema
+import importlib
 import os
 import traceback
 import yaml
 
 
+# To be loaded dynamically as needed
+jsonschema = None
+
+
 class SpecElement:
     """Netlink spec element.
 
@@ -197,9 +201,14 @@ import yaml
         if schema_path is None:
             schema_path = os.path.dirname(os.path.dirname(spec_path)) + f'/{self.proto}.yaml'
         if schema_path:
+            global jsonschema
+
             with open(schema_path, "r") as stream:
                 schema = yaml.safe_load(stream)
 
+            if jsonschema is None:
+                jsonschema = importlib.import_module("jsonschema")
+
             jsonschema.validate(self.yaml, schema)
 
         self.attr_sets = collections.OrderedDict()
-- 
2.39.1


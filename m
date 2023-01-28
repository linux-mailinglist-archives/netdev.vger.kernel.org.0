Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B150367F4AF
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 05:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjA1Ece (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 23:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjA1EcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 23:32:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BC3790A2
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 20:32:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DDB660277
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5E0C433A1;
        Sat, 28 Jan 2023 04:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674880343;
        bh=WS10Pn6R3aiHyiJ9QYASn0oIB1HbqiLMRQmCcfMUD30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnYVfCQeEEBtcB0ZIbSQ2ufXYe/fXPaAXRWZPdOTvXIA5Lw2Oyxe9FNOWzLAZuOtU
         uTXfAkiswi+vXgOf2+k7HHH1tASwtfrMvbiRcaSC6X+rDCLFou0wIEwmRkDqLfigUL
         QDhlb3PlMY+endPWW02eTvfpxq+UG5n9p+HJ0qzSrKdn7sVRJRgd6qkRWWnAQxI88Y
         OABknym89Hjb8t8ftGZSSpX05ccwkj8MEMBOZhfSca1wyri9O+camcxAK4SbyJ+Px8
         e648nq+zS38v0K4RnB9xNbwVFes8ryxuWZreONDtd5maIIIm+aonMs2g+QbiSnXkAJ
         sx18KOXHSmhaw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/13] tools: ynl: load jsonschema on demand
Date:   Fri, 27 Jan 2023 20:32:14 -0800
Message-Id: <20230128043217.1572362-11-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230128043217.1572362-1-kuba@kernel.org>
References: <20230128043217.1572362-1-kuba@kernel.org>
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


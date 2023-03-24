Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC3F6C83D4
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbjCXRzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjCXRzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:55:23 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208C119F0A
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679680491; x=1711216491;
  h=from:to:cc:subject:date:message-id;
  bh=l6BX5RLfhK02y829HxIhO7roCjrhZ/bnJ/Xq0ok4SL8=;
  b=bnyLggz8ic6XSC2qQ+qdIl1ym90t2vFbtKhK6HZHJ3QHV4yaxcXydC6P
   ejQifcLEtsGfuY1kUKPP7yuj/fcEJa3K7CId/52Rq952iqmpG6hNqawqI
   uu5BmwY278pNocVHBmOalv+4TdPAsHa5jbyyMKrYYr7HB2vTiYR7zrMgN
   AvOALQ2SU6LvW5vr/l2G3ZyfITQ0ksVxvc0dh9AaGsPHSzigcMEc3OmNT
   c99uttU6SAmUZQkkxWtN1bSHO/UFqsBGCB6JgpljjGK89fuXPymbru0bE
   T6vhUodcwWx9tZZv9+9uPkVhGDbokPrPcpIPgJql6K00usPsqoZ6vNSjA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="426111317"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="426111317"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 10:54:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="771976514"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="771976514"
Received: from mmichali-devpc.igk.intel.com ([10.211.235.239])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Mar 2023 10:54:07 -0700
From:   Michal Michalik <michal.michalik@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Michal Michalik <michal.michalik@intel.com>
Subject: [PATCH net-next v4] tools: ynl: Add missing types to encode/decode
Date:   Fri, 24 Mar 2023 18:52:58 +0100
Message-Id: <20230324175258.25145-1-michal.michalik@intel.com>
X-Mailer: git-send-email 2.9.5
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing the tool I noticed we miss the u16 type on payload create.
On the code inspection it turned out we miss also u64 - add them.

We also miss the decoding of u16 despite the fact `NlAttr` class
supports it - add it.

Signed-off-by: Michal Michalik <michal.michalik@intel.com>
--
v4:
- remove `Fixes:` tag since no code is using that now
- rebased to latest tree
v3: change tree `net` -> `net-next`
v2: add a `Fixes:` tag to the commit message
---
 tools/net/ynl/lib/ynl.py | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index bcb798c..788f130 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -336,8 +336,12 @@ class YnlFamily(SpecFamily):
             attr_payload = b''
         elif attr["type"] == 'u8':
             attr_payload = struct.pack("B", int(value))
+        elif attr["type"] == 'u16':
+            attr_payload = struct.pack("H", int(value))
         elif attr["type"] == 'u32':
             attr_payload = struct.pack("I", int(value))
+        elif attr["type"] == 'u64':
+            attr_payload = struct.pack("Q", int(value))
         elif attr["type"] == 'string':
             attr_payload = str(value).encode('ascii') + b'\x00'
         elif attr["type"] == 'binary':
@@ -373,6 +377,8 @@ class YnlFamily(SpecFamily):
                 decoded = subdict
             elif attr_spec['type'] == 'u8':
                 decoded = attr.as_u8()
+            elif attr_spec['type'] == 'u16':
+                decoded = attr.as_u16()
             elif attr_spec['type'] == 'u32':
                 decoded = attr.as_u32()
             elif attr_spec['type'] == 'u64':
-- 
2.9.5

base-commit: 323fe43cf9aef79159ba8937218a3f076bf505af

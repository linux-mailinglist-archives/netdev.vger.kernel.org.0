Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055BD6C6FB0
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjCWRvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjCWRvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:51:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD5826874
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 10:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679593900; x=1711129900;
  h=from:to:cc:subject:date:message-id;
  bh=3hhPjNPNXJlP2n8oMMrL1RTGBinNaY0t02BvlLuBFI0=;
  b=CYDQHLy4kPiTKcm7bpQu4Mfs9UPoldm7gppN849nLTT5uFhDkmktDY60
   hZr1SwpGxRKKbTTgQhvkL6gPWOGbsBzfYlV9ZjNVUbBmSYcQUykFGjYzn
   j9po6hWUWR8qP1nKGyqbOgrNGqvJS6dHilfsjov2/HNkK8O5VVzjkreYN
   GMzzm5FZmVet1PKP8Quzx6TMp3IibJmckbb3zMo55rstTSwMw3RzomXfM
   xxQ2Yl1Hr28VzcAkYhAJg3PS2a7Il1tCQpGE00hXCB/bCbPP9dQMhJoWo
   +JocQr4kouh2r5q+lKkF1kxZySEi2fdNkX95yRscd6wr+0fgYlFe9GFqa
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="425849418"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="425849418"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 10:51:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="684833995"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="684833995"
Received: from mmichali-devpc.igk.intel.com ([10.211.235.239])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2023 10:51:38 -0700
From:   Michal Michalik <michal.michalik@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Michal Michalik <michal.michalik@intel.com>
Subject: [PATCH net-next v3] tools: ynl: Add missing types to encode/decode
Date:   Thu, 23 Mar 2023 18:51:29 +0100
Message-Id: <20230323175129.17122-1-michal.michalik@intel.com>
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
On the code inspection it turned out we miss also u8 and u64 - add them.

We also miss the decoding of u16 despite the fact `NlAttr` class
supports it - add it.

Fixes: e4b48ed460d3 ("tools: ynl: add a completely generic client")
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
--
v3: change tree `net` -> `net-next`
v2: add a `Fixes:` tag to the commit message
---
 tools/net/ynl/lib/ynl.py | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 90764a8..788f130 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -334,8 +334,14 @@ class YnlFamily(SpecFamily):
                 attr_payload += self._add_attr(attr['nested-attributes'], subname, subvalue)
         elif attr["type"] == 'flag':
             attr_payload = b''
+        elif attr["type"] == 'u8':
+            attr_payload = struct.pack("B", int(value))
+        elif attr["type"] == 'u16':
+            attr_payload = struct.pack("H", int(value))
         elif attr["type"] == 'u32':
             attr_payload = struct.pack("I", int(value))
+        elif attr["type"] == 'u64':
+            attr_payload = struct.pack("Q", int(value))
         elif attr["type"] == 'string':
             attr_payload = str(value).encode('ascii') + b'\x00'
         elif attr["type"] == 'binary':
@@ -371,6 +377,8 @@ class YnlFamily(SpecFamily):
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

base-commit: fcb3a4653bc5fb0525d957db0cc8b413252029f8

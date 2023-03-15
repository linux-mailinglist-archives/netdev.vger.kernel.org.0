Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF9E6BAFEE
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCOMJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCOMJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:09:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E09430EAE
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678882144; x=1710418144;
  h=from:to:cc:subject:date:message-id;
  bh=YV2j1FAdRMe6Ubx17qENGjx9xGmiqmS7cFIHluLL2+0=;
  b=FKZU8rzSk0u5mZrjIrmsDvmudmKnk8rDShoRHYXi4GGNugyocPOIHPHK
   AL8/goTn5CIrQ1V38Crb6XpwacI1oE8O5Gf6nq+dN2/yK+EbTjE0i2gXf
   62LySrESqYFnAm85SqtBF10OFZNXVdAO5o+ELjiYBsa+PLGw8K29017SF
   Pl6TOInHS6TaFvfqM7n68kv9ND6OG4NPVscPvGsn31bu2Nt1l0tj6voZ4
   imbDcNpRFzFJLkrOI2e8EN+0lD6/MC+e6EHoDklhOU78INaG8WQ0YL+fS
   qtrb3loWyC67pAEEBDHARN8Jp0MRiMRPTW+1uXIJbeGQQkj+GpyEJAQCC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="337704610"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="337704610"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:09:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="1008813207"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="1008813207"
Received: from mmichali-devpc.igk.intel.com ([10.211.235.239])
  by fmsmga005.fm.intel.com with ESMTP; 15 Mar 2023 05:09:02 -0700
From:   Michal Michalik <michal.michalik@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, arkadiusz.kubalewski@intel.com,
        Michal Michalik <michal.michalik@intel.com>
Subject: [PATCH net v2] tools: ynl: Add missing types to encode/decode
Date:   Wed, 15 Mar 2023 13:08:52 +0100
Message-Id: <20230315120852.19314-1-michal.michalik@intel.com>
X-Mailer: git-send-email 2.9.5
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

---
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

base-commit: bcc858689db5f2e5a8d4d6e8bc5bb9736cd80626

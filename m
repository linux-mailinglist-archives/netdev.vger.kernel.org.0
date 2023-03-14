Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DAA6B9AE5
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjCNQRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCNQRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:17:09 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11C7A2265
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678810612; x=1710346612;
  h=from:to:cc:subject:date:message-id;
  bh=a55Uj28uzlbPqAkH8LstrI4rKsSceh6eMlPYXcxSkaQ=;
  b=Yy8ON/NGTe6wcqOXLF+9nkPAvAVai6Bv9b5CXIqg5WK/CoBMDgnyXUUe
   f9ARbQIcI9AF0hYMwrGfmB8WcjZdQN03TnaeW+RA1l0ZuEv/2ZSmdflmj
   q4/ftpkAHrdHOWm2lij4JQ1zcKNPbx6xwl0S7573WI28T9d7h5bZE6rbv
   n86RwaW3FJ/Vkr15sKdeO/IebkoIBZPN0VaXBPct0f2mSlaSxqwHZBIS9
   fPSvW4OMC/gvmt0ZXaJ9iCVoj0mD7+eyXFBK3Q7Wou4h1tzlOHux7obO2
   EcwzGmJMmcKUtIbFa6G3ugZ1qQHKwVP1/Z+PyTmFxW2Di8FaACGeELPAk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317868108"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317868108"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 09:13:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="822425017"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="822425017"
Received: from mmichali-devpc.igk.intel.com ([10.211.235.239])
  by fmsmga001.fm.intel.com with ESMTP; 14 Mar 2023 09:13:35 -0700
From:   Michal Michalik <michal.michalik@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, arkadiusz.kubalewski@intel.com,
        Michal Michalik <michal.michalik@intel.com>
Subject: [PATCH net] tools: ynl: Add missing types to encode/decode
Date:   Tue, 14 Mar 2023 17:12:49 +0100
Message-Id: <20230314161249.24876-1-michal.michalik@intel.com>
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

Signed-off-by: Michal Michalik <michal.michalik@intel.com>
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

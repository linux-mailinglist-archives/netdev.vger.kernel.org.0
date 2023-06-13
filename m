Return-Path: <netdev+bounces-10551-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6229D72EFE2
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 01:19:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2E5A280C57
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD84030B6B;
	Tue, 13 Jun 2023 23:19:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBC81ED52
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 23:19:14 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C40199E;
	Tue, 13 Jun 2023 16:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686698352; x=1718234352;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kZOlw4gphwa1VPAWeMRE+2+KfgIMF94H652qMBRcUT4=;
  b=OZJiNHYoczYikKwcJMCWrAo/fqnQdSXWZd5E2oHxRuxpMzprGUoKRD0B
   gQYQt6a7nWpLtPuSRZTeRPQS+jkFMQ0zksQfAxsnLWv+gfYe6KKb7mnGC
   ULPGHqn2aqp8FT+y6zvAjOaWjuCqorpT4RVU/9INugZ0RvOLDteBuotIM
   tbGoAP3Uc2D+msPVXtU9d7yJnLzkZk6wwwcK4li6i+UJZCiSVXe1orw9U
   VmxkH8W7QGcpAvsTan+X3LXJzwxKO13pTsx5laP+wC2GoP1WDcb5IwqjF
   8Mu4MHt5LFpp3CESPnHybC8Uk8YJbK/55OV7gzZ9PrE84H2gWS8Q3kHnu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="357352710"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="357352710"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 16:19:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="777011206"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="777011206"
Received: from amlin-018-114.igk.intel.com ([10.102.18.114])
  by fmsmga008.fm.intel.com with ESMTP; 13 Jun 2023 16:19:10 -0700
From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
To: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	chuck.lever@oracle.com
Cc: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Subject: [PATCH net-next] tools: ynl-gen: fix nested policy attribute type
Date: Wed, 14 Jun 2023 01:17:07 +0200
Message-Id: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When nested multi-attribute is used in yaml spec, generated type in
the netlink policy is NLA_NEST, which is wrong as there is no such type.
Fix be adding `ed` sufix for policy generated for 'nest' type attribute
when the attribute is parsed as TypeMultiAttr class.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 tools/net/ynl/ynl-gen-c.py | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 9adcd785db0b..0b5e0802a9a7 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -498,6 +498,16 @@ class TypeArrayNest(Type):
         else:
             raise Exception(f"Sub-type {self.attr['sub-type']} not supported yet")
 
+    def attr_policy(self, cw):
+        t = self.attr['type']
+        if (t == 'nest'):
+            policy = c_upper(f'nla-{t}ed')
+        else:
+            policy = c_upper(f'nla-{t}')
+
+        spec = self._attr_policy(policy)
+        cw.p(f"\t[{self.enum_name}] = {spec},")
+
     def _attr_typol(self):
         return f'.type = YNL_PT_NEST, .nest = &{self.nested_render_name}_nest, '
 
-- 
2.37.3



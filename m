Return-Path: <netdev+bounces-10552-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2074E72EFE5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 01:19:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF8392812A8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 342AC3446C;
	Tue, 13 Jun 2023 23:19:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2908B1ED52
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 23:19:22 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072C219B2;
	Tue, 13 Jun 2023 16:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686698362; x=1718234362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RQIhPr9DYeV1Rj7G2Tqjw0bFG1dfN/NDkAgtWqp7fi4=;
  b=SCW7VtHHNWZpX9Eum7EDW7QqpBJAY0VKNocjIBLXK6exN3ktJyh6wFmk
   VbUNnbCiD0Jfh/uxYuMUycmveyAerN0xGT7lV/KIgrxzlJdoAT1uV+aCY
   VC36BSvCgC2p750+mB77qPCfbtXPGoLogcjXRzv0E7AHCjVn+uU0iX0Wb
   cvb5PY4NHNU9mcJmOi5wlGRHmeoT78HozURupR3yjimtFolOJmQWi6FXT
   CutHKf07e4U3Me50BLYMD95mOKp61288oKUWKnEcrjYXYQHKiNfqGse9V
   YzK0zZbO7bLO7RKUqRsnchRuZvPfO7grlW/JS1OrlgwSb0QOlmn71iadM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="357352727"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="357352727"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 16:19:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="777011241"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="777011241"
Received: from amlin-018-114.igk.intel.com ([10.102.18.114])
  by fmsmga008.fm.intel.com with ESMTP; 13 Jun 2023 16:19:19 -0700
From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
To: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	chuck.lever@oracle.com
Cc: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Subject: [PATCH net-next] tools: ynl-gen: fix NLA_POLICY_MAX on enums with value
Date: Wed, 14 Jun 2023 01:17:08 +0200
Message-Id: <20230613231709.150622-2-arkadiusz.kubalewski@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
References: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
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

Policy defines max as length of enum list, if enum attribute is
defined with a value, generated netlink policy max value is wrong.
Calculate proper max value for policy where enums that are given
explicit value.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 tools/net/ynl/ynl-gen-c.py | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 4c12c6f8968e..9adcd785db0b 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -279,7 +279,16 @@ class TypeScalar(Type):
         elif 'enum' in self.attr:
             enum = self.family.consts[self.attr['enum']]
             cnt = len(enum['entries'])
-            return f"NLA_POLICY_MAX({policy}, {cnt - 1})"
+            values = [0] * cnt
+            for i in range(cnt):
+                if 'value' in enum['entries'][i]:
+                    values[i] = enum['entries'][i]['value']
+                else:
+                    if i == 0:
+                        values[i] = 0;
+                    else:
+                        values[i] = values[i - 1] + 1
+            return f"NLA_POLICY_MAX({policy}, {max(values)})"
         return super()._attr_policy(policy)
 
     def _attr_typol(self):
-- 
2.37.3



Return-Path: <netdev+bounces-9046-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0555D726B7C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B521028140D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA40F3B8B5;
	Wed,  7 Jun 2023 20:24:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADAE3AE68
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CD1C433B0;
	Wed,  7 Jun 2023 20:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686169450;
	bh=bNR0wLGf409/sRRjZv0igbBuw9snLnChBCexjn7iXbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8lM+gtLpuyj9ObVZp5BNVEZqmp6rnMn5uqWOhccdTHWQtzpdaIHv4Q8NRr5gr8xG
	 bhjhZz10sm9b6pAyfFPSgQvIVNNYFGDHe4jcnM01lv9cLqeonyfaHsLL4Fv8vm73R4
	 LXWF/l6EmsZllGhyX2+4HQgRd1NxLncJbrRoLgnAOBOXZlmMXLqOKKRr9qBwzWcNcn
	 KzjP8F/jmOJYd8i/dQS229h27ejSKArfF3xt8E97P23f3+sUF9H0zKxpthBnzGmZxE
	 BjZ/1BavBfhefviS81ad0NLNHXbHsK3wwqeaHGLPo1iyHjPghSPa/2YOcWU6j2dUkb
	 rFPXC4RdplasQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	jiri@resnulli.us,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/11] tools: ynl-gen: inherit struct use info
Date: Wed,  7 Jun 2023 13:23:58 -0700
Message-Id: <20230607202403.1089925-7-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607202403.1089925-1-kuba@kernel.org>
References: <20230607202403.1089925-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We only render parse and netlink generation helpers as needed,
to avoid generating dead code. Propagate the information from
first- and second-layer attribute sets onto all children.
Otherwise devlink won't work, it has a lot more levels of nesting.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index d9c74a678df8..1a97cd517116 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -896,6 +896,14 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
                 pns_key_seen.add(name)
             else:
                 pns_key_list.append(name)
+        # Propagate the request / reply
+        for attr_set, struct in reversed(self.pure_nested_structs.items()):
+            for _, spec in self.attr_sets[attr_set].items():
+                if 'nested-attributes' in spec:
+                    child = self.pure_nested_structs.get(spec['nested-attributes'])
+                    if child:
+                        child.request |= struct.request
+                        child.reply |= struct.reply
 
     def _load_all_notify(self):
         for op_name, op in self.ops.items():
-- 
2.40.1



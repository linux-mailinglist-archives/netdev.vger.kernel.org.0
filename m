Return-Path: <netdev+bounces-9733-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A02CA72A585
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BD88281AD1
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EDDE27218;
	Fri,  9 Jun 2023 21:44:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3B323D77
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A3CC433A8;
	Fri,  9 Jun 2023 21:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347038;
	bh=Nu+UgcticBmAXjUwDdlmC6YgZXHtSrweKH3jl8QoXI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHRtcuRcFUPZ0Zizv64xGwpgfAmpDJJGfGHastsJOG5w+8Z07I0iYinL0mqDGx/jk
	 PxCoAeBJHpiBs9xHwtpPVhdHED4aqk5WRx0wYRSfLDreOfW+QNjBDJc+RzPmNt8R+6
	 DTcBeen2PVbejPpWe7A/cHL0FOJCteAc+Vg7Ky1/W6UBQ9HPgTo+NbqwxJEm2gd6Gh
	 zoLaMvQZ4ut0d6Ir7Iy19t0ffMC5TPdZOeiNHRYO+Kb0N4cqQ2bFJ4WbyqGcloGOqd
	 68zjQDgHxD8X8mZVu8ybVISuGOS2up4cqRUC6bpbOL1hR+a7irIqeb6Ho6ghYAADiU
	 xdpF6IbmTFgnA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 09/12] netlink: specs: ethtool: untangle stats-get
Date: Fri,  9 Jun 2023 14:43:43 -0700
Message-Id: <20230609214346.1605106-10-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609214346.1605106-1-kuba@kernel.org>
References: <20230609214346.1605106-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Code gen for stats is a bit of a challenge, but from looking
at the attrs I think that the format isn't quite right.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/ethtool.yaml | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 17b7b5028e2b..00c1ab04b857 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -793,16 +793,29 @@ doc: Partial family for Ethtool Netlink.
         type: u32
       -
         name: stat
-        type: nest
-        nested-attributes: u64
+        type: u64
+        type-value: [ id ]
       -
         name: hist-rx
         type: nest
-        nested-attributes: u64
+        nested-attributes: stats-grp-hist
       -
         name: hist-tx
         type: nest
-        nested-attributes: u64
+        nested-attributes: stats-grp-hist
+      -
+        name: hist-bkt-low
+        type: u32
+      -
+        name: hist-bkt-hi
+        type: u32
+      -
+        name: hist-val
+        type: u64
+  -
+    name: stats-grp-hist
+    subset-of: stats-grp
+    attributes:
       -
         name: hist-bkt-low
         type: u32
-- 
2.40.1



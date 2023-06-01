Return-Path: <netdev+bounces-7201-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE27A71F0C2
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:29:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4184D1C2111F
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2946A4701B;
	Thu,  1 Jun 2023 17:28:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5F042501
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:28:41 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D83189
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685640519; x=1717176519;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wfld8HBPAN4YfQnm37Uca9k2heqbjSZjp8Dpmd3Evvc=;
  b=eMpdC/z8uzfvbago1DhZOP2Kb1jJDnRKsD7RArUzaln+LkCUDvWuSiPO
   BYXbafg76mowuI58l0AP2cN+ENhUeQM3tGoQBBu4fDmrM9E93QEHawi2X
   dKXSxQhUb6iPQNJ0MLUoa8hDAMTT77CWdiYZDJZMjzlp3jbWUH5EOgcW4
   6r3br+9SOB4hC2TEGnw2zpmM/mYuXx6B/RluOJEyblPv17xBMBlDIZzfr
   RbRmfHnn7Vah/phDKxH8lz3Xj4GCe47vsVNlNrL90SPVz9xM+ERYtaa7T
   8pbLt11NOsMtjzACNov+Ujii58FseQCQODIlC5NZDWgrFnYzJlEiOBhft
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="355647500"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="355647500"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 10:28:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="701638222"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="701638222"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2023 10:28:39 -0700
Subject: [net-next/RFC PATCH v1 3/4] netdev-genl: Introduce netdev dump ctx
From: Amritha Nambiar <amritha.nambiar@intel.com>
To: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc: sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date: Thu, 01 Jun 2023 10:42:36 -0700
Message-ID: <168564135607.7284.13867080215910148101.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
References: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A comment in the definition of struct netlink_callback states
"args is deprecated. Cast a struct over ctx instead for proper
type safety." Introduce netdev_nl_dump_ctx structure and replace
'args' with netdev_nl_dump_ctx fields.


Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 net/core/netdev-genl.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index a4270fafdf11..8d6a840821c7 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -8,6 +8,19 @@
 
 #include "netdev-genl-gen.h"
 
+struct netdev_nl_dump_ctx {
+	int dev_entry_hash;
+	int dev_entry_idx;
+};
+
+static inline struct netdev_nl_dump_ctx *
+netdev_dump_ctx(struct netlink_callback *cb)
+{
+	NL_ASSERT_DUMP_CTX_FITS(struct netdev_nl_dump_ctx);
+
+	return (struct netdev_nl_dump_ctx *)cb->ctx;
+}
+
 static int
 netdev_nl_dev_fill(struct net_device *netdev, struct sk_buff *rsp,
 		   u32 portid, u32 seq, int flags, u32 cmd)
@@ -91,14 +104,15 @@ int netdev_nl_dev_get_doit(struct sk_buff *skb, struct genl_info *info)
 
 int netdev_nl_dev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct netdev_nl_dump_ctx *ctx = netdev_dump_ctx(cb);
 	struct net *net = sock_net(skb->sk);
 	struct net_device *netdev;
 	int idx = 0, s_idx;
 	int h, s_h;
 	int err;
 
-	s_h = cb->args[0];
-	s_idx = cb->args[1];
+	s_h = ctx->dev_entry_hash;
+	s_idx = ctx->dev_entry_idx;
 
 	rtnl_lock();
 
@@ -126,8 +140,8 @@ int netdev_nl_dev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 	if (err != -EMSGSIZE)
 		return err;
 
-	cb->args[1] = idx;
-	cb->args[0] = h;
+	ctx->dev_entry_idx = idx;
+	ctx->dev_entry_hash = h;
 	cb->seq = net->dev_base_seq;
 
 	return skb->len;



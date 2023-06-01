Return-Path: <netdev+bounces-7202-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE7771F0C6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 264831C210AD
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E074D47009;
	Thu,  1 Jun 2023 17:28:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C5642501
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:28:48 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B265119A
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685640525; x=1717176525;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gZoobYWWUqykqjdxQJnGc7p5go/a7UXLz0bCEGpFHrw=;
  b=LN6MNzKpd1KkmSvEQh7GgQIIS4W+jpNd1cwARHDCt5lQLh9/WufjBgxO
   5JGSrwY5hB8POIQzjY0F3ygtKFTr92CWqiOwSOlVy2YPBEaEw4VzBfAHk
   Y35XPjy8QRcjL611Rpk3cx+MAnAmQ4l3+zzjy1X8sUZRVDo2yPxtGBMz0
   gLqfX5yq8tarmv1wc7YJOmUeonX+nqjLJCUIMfueAlHsKF+QWfbmXmJiu
   qhJWUhibUewF+w3hWcCeldKwlSHWqV5BS8hAWGmynEBtis3ZqdrCQmnkQ
   WHNzY8+0VKwsA4EW717uBrFwcHqO7YHTBcP1B2IyorF18IrGCtj09bnRj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="353123433"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="353123433"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 10:28:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="954128983"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="954128983"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by fmsmga006.fm.intel.com with ESMTP; 01 Jun 2023 10:28:44 -0700
Subject: [net-next/RFC PATCH v1 4/4] netdev-genl: Add support for exposing
 napi info from netdev
From: Amritha Nambiar <amritha.nambiar@intel.com>
To: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc: sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date: Thu, 01 Jun 2023 10:42:41 -0700
Message-ID: <168564136118.7284.18138054610456895287.stgit@anambiarhost.jf.intel.com>
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

Add support in ynl/netdev.yaml for napi related information. The
netdev structure tracks all the napi instances and napi fields.
The napi instances and associated queue[s] can be retrieved this way.

Refactored netdev-genl to support exposing napi<->queue[s] mapping
that is retained in a netdev.

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 Documentation/netlink/specs/netdev.yaml |   39 +++++
 include/uapi/linux/netdev.h             |    4 +
 net/core/netdev-genl.c                  |  239 ++++++++++++++++++++++++++-----
 tools/include/uapi/linux/netdev.h       |    4 +
 4 files changed, 247 insertions(+), 39 deletions(-)

diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index b99e7ffef7a1..8d0edb529563 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -62,6 +62,44 @@ attribute-sets:
         type: u64
         enum: xdp-act
         enum-as-flags: true
+      -
+        name: napi-info
+        doc: napi information such as napi-id, napi queues etc.
+        type: nest
+        multi-attr: true
+        nested-attributes: dev-napi-info
+      -
+        name: napi-id
+        doc: napi id
+        type: u32
+      -
+        name: rx-queues
+        doc: list of rx queues associated with a napi
+        type: u16
+        multi-attr: true
+      -
+        name: tx-queues
+        doc: list of tx queues associated with a napi
+        type: u16
+        multi-attr: true
+  -
+    name: dev-napi-info
+    subset-of: dev
+    attributes:
+      -
+        name: napi-id
+        doc: napi id
+        type: u32
+      -
+        name: rx-queues
+        doc: list rx of queues associated with a napi
+        type: u16
+        multi-attr: true
+      -
+        name: tx-queues
+        doc: list tx of queues associated with a napi
+        type: u16
+        multi-attr: true
 
 operations:
   list:
@@ -77,6 +115,7 @@ operations:
           attributes:
             - ifindex
             - xdp-features
+            - napi-info
       dump:
         reply: *dev-all
     -
diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 639524b59930..16538fb1406a 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -41,6 +41,10 @@ enum {
 	NETDEV_A_DEV_IFINDEX = 1,
 	NETDEV_A_DEV_PAD,
 	NETDEV_A_DEV_XDP_FEATURES,
+	NETDEV_A_DEV_NAPI_INFO,
+	NETDEV_A_DEV_NAPI_ID,
+	NETDEV_A_DEV_RX_QUEUES,
+	NETDEV_A_DEV_TX_QUEUES,
 
 	__NETDEV_A_DEV_MAX,
 	NETDEV_A_DEV_MAX = (__NETDEV_A_DEV_MAX - 1)
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 8d6a840821c7..fdaa67f53b22 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -11,6 +11,7 @@
 struct netdev_nl_dump_ctx {
 	int dev_entry_hash;
 	int dev_entry_idx;
+	int napi_idx;
 };
 
 static inline struct netdev_nl_dump_ctx *
@@ -21,54 +22,187 @@ netdev_dump_ctx(struct netlink_callback *cb)
 	return (struct netdev_nl_dump_ctx *)cb->ctx;
 }
 
+enum netdev_nl_type {
+	NETDEV_NL_DO,
+	NETDEV_NL_NOTIFY,
+};
+
+static int netdev_nl_send_func(struct net_device *netdev, struct sk_buff *skb,
+			       u32 portid, enum netdev_nl_type type)
+{
+	switch (type) {
+	case NETDEV_NL_DO:
+		return genlmsg_unicast(dev_net(netdev), skb, portid);
+	case NETDEV_NL_NOTIFY:
+		return genlmsg_multicast_netns(&netdev_nl_family,
+					       dev_net(netdev), skb, 0,
+					       NETDEV_NLGRP_MGMT, GFP_KERNEL);
+	default:
+		return -EINVAL;
+	}
+}
+
 static int
-netdev_nl_dev_fill(struct net_device *netdev, struct sk_buff *rsp,
-		   u32 portid, u32 seq, int flags, u32 cmd)
+netdev_nl_dev_napi_fill_one(struct sk_buff *msg, struct napi_struct *napi)
 {
-	void *hdr;
+	struct nlattr *napi_info;
+	struct napi_queue *q, *n;
 
-	hdr = genlmsg_put(rsp, portid, seq, &netdev_nl_family, flags, cmd);
-	if (!hdr)
+	napi_info = nla_nest_start(msg, NETDEV_A_DEV_NAPI_INFO);
+	if (!napi_info)
 		return -EMSGSIZE;
 
+	if (nla_put_u32(msg, NETDEV_A_DEV_NAPI_ID, napi->napi_id))
+		goto nla_put_failure;
+
+	list_for_each_entry_safe(q, n, &napi->napi_rxq_list, q_list) {
+		if (nla_put_u16(msg, NETDEV_A_DEV_RX_QUEUES, q->queue_index))
+			goto nla_put_failure;
+	}
+
+	list_for_each_entry_safe(q, n, &napi->napi_txq_list, q_list) {
+		if (nla_put_u16(msg, NETDEV_A_DEV_TX_QUEUES, q->queue_index))
+			goto nla_put_failure;
+	}
+	nla_nest_end(msg, napi_info);
+	return 0;
+nla_put_failure:
+	nla_nest_cancel(msg, napi_info);
+	return -EMSGSIZE;
+}
+
+static int
+netdev_nl_dev_napi_fill(struct net_device *netdev, struct sk_buff *msg, int *start)
+{
+	struct napi_struct *napi, *n;
+	int i = 0;
+
+	list_for_each_entry_safe(napi, n, &netdev->napi_list, dev_list) {
+		if (i < *start) {
+			i++;
+			continue;
+		}
+		if (netdev_nl_dev_napi_fill_one(msg, napi))
+			return -EMSGSIZE;
+		*start = ++i;
+	}
+	return 0;
+}
+
+static int
+netdev_nl_dev_napi_prepare_fill(struct net_device *netdev,
+				struct sk_buff **pskb, u32 portid, u32 seq,
+				int flags, u32 cmd, enum netdev_nl_type type)
+{
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb = *pskb;
+	bool last = false;
+	int index = 0;
+	void *hdr;
+	int err;
+
+	while (!last) {
+		int tmp_index = index;
+
+		skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+		if (!skb)
+			return -ENOMEM;
+
+		hdr = genlmsg_put(skb, portid, seq, &netdev_nl_family,
+				  flags | NLM_F_MULTI, cmd);
+		if (!hdr) {
+			err = -EMSGSIZE;
+			goto nla_put_failure;
+		}
+		err = netdev_nl_dev_napi_fill(netdev, skb, &index);
+		if (!err)
+			last = true;
+		else if (err != -EMSGSIZE || tmp_index == index)
+			goto nla_put_failure;
+
+		genlmsg_end(skb, hdr);
+		err = netdev_nl_send_func(netdev, skb, portid, type);
+		if (err)
+			return err;
+	}
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+	nlh = nlmsg_put(skb, portid, seq, NLMSG_DONE, 0, flags | NLM_F_MULTI);
+	if (!nlh) {
+		err = -EMSGSIZE;
+		goto nla_put_failure;
+	}
+
+	return netdev_nl_send_func(netdev, skb, portid, type);
+
+nla_put_failure:
+	nlmsg_free(skb);
+	return err;
+}
+
+static int
+netdev_nl_dev_info_fill(struct net_device *netdev, struct sk_buff *rsp)
+{
 	if (nla_put_u32(rsp, NETDEV_A_DEV_IFINDEX, netdev->ifindex) ||
 	    nla_put_u64_64bit(rsp, NETDEV_A_DEV_XDP_FEATURES,
-			      netdev->xdp_features, NETDEV_A_DEV_PAD)) {
-		genlmsg_cancel(rsp, hdr);
-		return -EINVAL;
+			      netdev->xdp_features, NETDEV_A_DEV_PAD))
+		return -EMSGSIZE;
+	return 0;
+}
+
+static int
+netdev_nl_dev_fill(struct net_device *netdev, u32 portid, u32 seq, int flags,
+		   u32 cmd, enum netdev_nl_type type)
+{
+	struct sk_buff *skb;
+	void *hdr;
+	int err;
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(skb, portid, seq, &netdev_nl_family, flags, cmd);
+	if (!hdr) {
+		err = -EMSGSIZE;
+		goto err_free_msg;
+	}
+	err = netdev_nl_dev_info_fill(netdev, skb);
+	if (err) {
+		genlmsg_cancel(skb, hdr);
+		goto err_free_msg;
 	}
 
-	genlmsg_end(rsp, hdr);
+	genlmsg_end(skb, hdr);
 
-	return 0;
+	err = netdev_nl_send_func(netdev, skb, portid, type);
+	if (err)
+		return err;
+
+	return netdev_nl_dev_napi_prepare_fill(netdev, &skb, portid, seq, flags,
+					       cmd, type);
+
+err_free_msg:
+	nlmsg_free(skb);
+	return err;
 }
 
 static void
 netdev_genl_dev_notify(struct net_device *netdev, int cmd)
 {
-	struct sk_buff *ntf;
-
 	if (!genl_has_listeners(&netdev_nl_family, dev_net(netdev),
 				NETDEV_NLGRP_MGMT))
 		return;
 
-	ntf = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!ntf)
-		return;
-
-	if (netdev_nl_dev_fill(netdev, ntf, 0, 0, 0, cmd)) {
-		nlmsg_free(ntf);
-		return;
-	}
+	netdev_nl_dev_fill(netdev, 0, 0, 0, cmd, NETDEV_NL_NOTIFY);
 
-	genlmsg_multicast_netns(&netdev_nl_family, dev_net(netdev), ntf,
-				0, NETDEV_NLGRP_MGMT, GFP_KERNEL);
 }
 
 int netdev_nl_dev_get_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net_device *netdev;
-	struct sk_buff *rsp;
 	u32 ifindex;
 	int err;
 
@@ -77,29 +211,53 @@ int netdev_nl_dev_get_doit(struct sk_buff *skb, struct genl_info *info)
 
 	ifindex = nla_get_u32(info->attrs[NETDEV_A_DEV_IFINDEX]);
 
-	rsp = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!rsp)
-		return -ENOMEM;
-
 	rtnl_lock();
 
 	netdev = __dev_get_by_index(genl_info_net(info), ifindex);
 	if (netdev)
-		err = netdev_nl_dev_fill(netdev, rsp, info->snd_portid,
-					 info->snd_seq, 0, info->genlhdr->cmd);
+		err = netdev_nl_dev_fill(netdev, info->snd_portid,
+					 info->snd_seq, 0, info->genlhdr->cmd,
+					 NETDEV_NL_DO);
 	else
 		err = -ENODEV;
 
 	rtnl_unlock();
-
 	if (err)
-		goto err_free_msg;
+		return err;
 
-	return genlmsg_reply(rsp, info);
+	return 0;
+}
+
+static int
+netdev_nl_dev_dump_entry(struct net_device *netdev, struct sk_buff *rsp,
+			 struct netlink_callback *cb, int *start)
+{
+	int index = *start;
+	int tmp_index = index;
+	void *hdr;
+	int err;
+
+	hdr = genlmsg_put(rsp, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &netdev_nl_family, NLM_F_MULTI, NETDEV_CMD_DEV_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (netdev_nl_dev_info_fill(netdev, rsp))
+		goto nla_put_failure;
+
+	err =  netdev_nl_dev_napi_fill(netdev, rsp, &index);
+	if (err) {
+		if (err != -EMSGSIZE || tmp_index == index)
+			goto nla_put_failure;
+	}
+	*start = index;
+	genlmsg_end(rsp, hdr);
 
-err_free_msg:
-	nlmsg_free(rsp);
 	return err;
+
+nla_put_failure:
+	genlmsg_cancel(rsp, hdr);
+	return -EINVAL;
 }
 
 int netdev_nl_dev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
@@ -107,12 +265,13 @@ int netdev_nl_dev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 	struct netdev_nl_dump_ctx *ctx = netdev_dump_ctx(cb);
 	struct net *net = sock_net(skb->sk);
 	struct net_device *netdev;
-	int idx = 0, s_idx;
+	int idx = 0, s_idx, n_idx;
 	int h, s_h;
 	int err;
 
 	s_h = ctx->dev_entry_hash;
 	s_idx = ctx->dev_entry_idx;
+	n_idx = ctx->napi_idx;
 
 	rtnl_lock();
 
@@ -124,10 +283,10 @@ int netdev_nl_dev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 		hlist_for_each_entry(netdev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
-			err = netdev_nl_dev_fill(netdev, skb,
-						 NETLINK_CB(cb->skb).portid,
-						 cb->nlh->nlmsg_seq, 0,
-						 NETDEV_CMD_DEV_GET);
+			err = netdev_nl_dev_dump_entry(netdev, skb, cb, &n_idx);
+			if (err == -EMSGSIZE)
+				goto out;
+			n_idx = 0;
 			if (err < 0)
 				break;
 cont:
@@ -135,6 +294,7 @@ int netdev_nl_dev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 		}
 	}
 
+out:
 	rtnl_unlock();
 
 	if (err != -EMSGSIZE)
@@ -142,6 +302,7 @@ int netdev_nl_dev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 
 	ctx->dev_entry_idx = idx;
 	ctx->dev_entry_hash = h;
+	ctx->napi_idx = n_idx;
 	cb->seq = net->dev_base_seq;
 
 	return skb->len;
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index 639524b59930..16538fb1406a 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -41,6 +41,10 @@ enum {
 	NETDEV_A_DEV_IFINDEX = 1,
 	NETDEV_A_DEV_PAD,
 	NETDEV_A_DEV_XDP_FEATURES,
+	NETDEV_A_DEV_NAPI_INFO,
+	NETDEV_A_DEV_NAPI_ID,
+	NETDEV_A_DEV_RX_QUEUES,
+	NETDEV_A_DEV_TX_QUEUES,
 
 	__NETDEV_A_DEV_MAX,
 	NETDEV_A_DEV_MAX = (__NETDEV_A_DEV_MAX - 1)



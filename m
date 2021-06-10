Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE713A2997
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 12:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFJKso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 06:48:44 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:35589 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhFJKsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 06:48:43 -0400
Received: by mail-ej1-f47.google.com with SMTP id h24so43443300ejy.2
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 03:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OHs+5yapG1eHIgZGuzyj7K/JjrXGKBa3D/k+j6h/h8k=;
        b=bzshpus1Tg6X0zN0cY6Fa23oCQq8kf/CmBfNQgHl+CWbazGST9PmfBqX1tlV4zc6Xf
         1W3uO3bebMb9PqtCVMpo6KUtl0MDSJ8UGHZiEplDapH2JLGt3BbjS3FCqxyLKcA63ma0
         AN7/gxLXP+rTgWWmLEzsrIUXkmagqUc3g44KyzkVrZDQLXuAcaLZ/9otMUQnkZm7ZsfA
         84rgd6WZZA3s1jSXW7JBsHVnOHsejmd/oK+DV4liQIhuwJxreTmCL9/m75UeKPxeKPP5
         IjrfOKCiuhfxciBi/02Jn1thKuOu1nMQ8Vpysnuk9U76Ud1u2G/hutcqYpmgA4K8uCxV
         tgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OHs+5yapG1eHIgZGuzyj7K/JjrXGKBa3D/k+j6h/h8k=;
        b=CF/GUY+w0nu+0Q2OBO7eNtHJQ06V83cxwEeZkCGxWLfC28T4EozC+8e+RBnywb8Kj8
         QKpKk0H4W+NPsd0U80d0sa68pUoDjtX3yvx8GyEJbEKBuqfoLSadGYt74fSXQgfjcFpP
         8xw0FhyfQ/ev+x34CPiEG8wow5jfIZYET4I64uist/DYZIrbAY4UbrZXYGosAu0328h0
         YJ7U4T3S+AP5AXHMNj9Ox7Qzaqms/TFNM7/PJXR0QELD0mT1QJ4bHojSxUfgJ+E3JWC3
         gRo5rXfGixoDb9bCZIfMDvxDW1wnJn/Qj50Dfca4CUm8tG9LZAC+5SSwW40HIHykc+5k
         u83A==
X-Gm-Message-State: AOAM531v5ZS/1t7xSPGNBo4OaPaxyt9DJnXmIL+Iog104Pb5L89kZQkq
        intRPTv3hsnXKOk46jU4PswoFV5ihK+6TerbuBs=
X-Google-Smtp-Source: ABdhPJzj+VvmRfwnYXmVqS+uA82hQa6Bq5zcWe8gnJgIbFcHl+aw57ZmZXX1ZrF6hToTHWBK0Nl3fA==
X-Received: by 2002:a17:906:3888:: with SMTP id q8mr3820063ejd.15.1623321946521;
        Thu, 10 Jun 2021 03:45:46 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id y1sm866526ejl.7.2021.06.10.03.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 03:45:46 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 1/2] net: bridge: fix vlan tunnel dst null pointer dereference
Date:   Thu, 10 Jun 2021 13:45:36 +0300
Message-Id: <20210610104537.119538-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610104537.119538-1-razor@blackwall.org>
References: <20210610104537.119538-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

This patch fixes a tunnel_dst null pointer dereference due to lockless
access in the tunnel egress path. When deleting a vlan tunnel the
tunnel_dst pointer is set to NULL without waiting a grace period (i.e.
while it's still usable) and packets egressing are dereferencing it
without checking. Use READ/WRITE_ONCE to annotate the lockless use of
tunnel_id, use RCU for accessing tunnel_dst and make sure it is read
only once and checked in the egress path. The dst is already properly RCU
protected so we don't need to do anything fancy than to make sure
tunnel_id and tunnel_dst are read only once and checked in the egress path.

Fixes: 11538d039ac6 ("bridge: vlan dst_metadata hooks in ingress and egress paths")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_private.h     |  4 ++--
 net/bridge/br_vlan_tunnel.c | 38 +++++++++++++++++++++++--------------
 2 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7ce8a77cc6b6..e013d33f1c7c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -90,8 +90,8 @@ struct bridge_mcast_stats {
 #endif
 
 struct br_tunnel_info {
-	__be64			tunnel_id;
-	struct metadata_dst	*tunnel_dst;
+	__be64				tunnel_id;
+	struct metadata_dst __rcu	*tunnel_dst;
 };
 
 /* private vlan flags */
diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index 0d3a8c01552e..03de461a0d44 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -41,26 +41,33 @@ static struct net_bridge_vlan *br_vlan_tunnel_lookup(struct rhashtable *tbl,
 				      br_vlan_tunnel_rht_params);
 }
 
+static void vlan_tunnel_info_release(struct net_bridge_vlan *vlan)
+{
+	struct metadata_dst *tdst = rtnl_dereference(vlan->tinfo.tunnel_dst);
+
+	WRITE_ONCE(vlan->tinfo.tunnel_id, 0);
+	RCU_INIT_POINTER(vlan->tinfo.tunnel_dst, NULL);
+	dst_release(&tdst->dst);
+}
+
 void vlan_tunnel_info_del(struct net_bridge_vlan_group *vg,
 			  struct net_bridge_vlan *vlan)
 {
-	if (!vlan->tinfo.tunnel_dst)
+	if (!rcu_access_pointer(vlan->tinfo.tunnel_dst))
 		return;
 	rhashtable_remove_fast(&vg->tunnel_hash, &vlan->tnode,
 			       br_vlan_tunnel_rht_params);
-	vlan->tinfo.tunnel_id = 0;
-	dst_release(&vlan->tinfo.tunnel_dst->dst);
-	vlan->tinfo.tunnel_dst = NULL;
+	vlan_tunnel_info_release(vlan);
 }
 
 static int __vlan_tunnel_info_add(struct net_bridge_vlan_group *vg,
 				  struct net_bridge_vlan *vlan, u32 tun_id)
 {
-	struct metadata_dst *metadata = NULL;
+	struct metadata_dst *metadata = rtnl_dereference(vlan->tinfo.tunnel_dst);
 	__be64 key = key32_to_tunnel_id(cpu_to_be32(tun_id));
 	int err;
 
-	if (vlan->tinfo.tunnel_dst)
+	if (metadata)
 		return -EEXIST;
 
 	metadata = __ip_tun_set_dst(0, 0, 0, 0, 0, TUNNEL_KEY,
@@ -69,8 +76,8 @@ static int __vlan_tunnel_info_add(struct net_bridge_vlan_group *vg,
 		return -EINVAL;
 
 	metadata->u.tun_info.mode |= IP_TUNNEL_INFO_TX | IP_TUNNEL_INFO_BRIDGE;
-	vlan->tinfo.tunnel_dst = metadata;
-	vlan->tinfo.tunnel_id = key;
+	rcu_assign_pointer(vlan->tinfo.tunnel_dst, metadata);
+	WRITE_ONCE(vlan->tinfo.tunnel_id, key);
 
 	err = rhashtable_lookup_insert_fast(&vg->tunnel_hash, &vlan->tnode,
 					    br_vlan_tunnel_rht_params);
@@ -79,9 +86,7 @@ static int __vlan_tunnel_info_add(struct net_bridge_vlan_group *vg,
 
 	return 0;
 out:
-	dst_release(&vlan->tinfo.tunnel_dst->dst);
-	vlan->tinfo.tunnel_dst = NULL;
-	vlan->tinfo.tunnel_id = 0;
+	vlan_tunnel_info_release(vlan);
 
 	return err;
 }
@@ -182,12 +187,15 @@ int br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
 int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 				 struct net_bridge_vlan *vlan)
 {
+	struct metadata_dst *tunnel_dst;
+	__be64 tunnel_id;
 	int err;
 
-	if (!vlan || !vlan->tinfo.tunnel_id)
+	if (!vlan)
 		return 0;
 
-	if (unlikely(!skb_vlan_tag_present(skb)))
+	tunnel_id = READ_ONCE(vlan->tinfo.tunnel_id);
+	if (!tunnel_id || unlikely(!skb_vlan_tag_present(skb)))
 		return 0;
 
 	skb_dst_drop(skb);
@@ -195,7 +203,9 @@ int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_dst_set(skb, dst_clone(&vlan->tinfo.tunnel_dst->dst));
+	tunnel_dst = rcu_dereference(vlan->tinfo.tunnel_dst);
+	if (tunnel_dst)
+		skb_dst_set(skb, dst_clone(&tunnel_dst->dst));
 
 	return 0;
 }
-- 
2.31.1


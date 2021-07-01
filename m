Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CA23B95FF
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbhGASP0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Jul 2021 14:15:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39481 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbhGASPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 14:15:25 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lz1BA-0006Mv-Tt; Thu, 01 Jul 2021 18:12:49 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 44C795FDD5; Thu,  1 Jul 2021 11:12:47 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 3F78AA040B;
        Thu,  1 Jul 2021 11:12:47 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     joamaki@gmail.com
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com
Subject: Re: [PATCH bpf-next v2 4/4] devmap: Exclude XDP broadcast to master device
In-reply-to: <20210624091843.5151-5-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210624091843.5151-1-joamaki@gmail.com> <20210624091843.5151-5-joamaki@gmail.com>
Comments: In-reply-to joamaki@gmail.com
   message dated "Thu, 24 Jun 2021 09:18:43 -0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31209.1625163167.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Thu, 01 Jul 2021 11:12:47 -0700
Message-ID: <31210.1625163167@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

joamaki@gmail.com wrote:

>From: Jussi Maki <joamaki@gmail.com>
>
>If the ingress device is bond slave, do not broadcast back
>through it or the bond master.
>
>Signed-off-by: Jussi Maki <joamaki@gmail.com>
>---
> kernel/bpf/devmap.c | 34 ++++++++++++++++++++++++++++------
> 1 file changed, 28 insertions(+), 6 deletions(-)
>
>diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>index 2a75e6c2d27d..0864fb28c8b5 100644
>--- a/kernel/bpf/devmap.c
>+++ b/kernel/bpf/devmap.c
>@@ -514,9 +514,11 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
> }
> 
> static bool is_valid_dst(struct bpf_dtab_netdev *obj, struct xdp_buff *xdp,
>-			 int exclude_ifindex)
>+			 int exclude_ifindex, int exclude_ifindex_master)
> {
>-	if (!obj || obj->dev->ifindex == exclude_ifindex ||
>+	if (!obj ||
>+	    obj->dev->ifindex == exclude_ifindex ||
>+	    obj->dev->ifindex == exclude_ifindex_master ||
> 	    !obj->dev->netdev_ops->ndo_xdp_xmit)
> 		return false;
> 
>@@ -546,12 +548,19 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> {
> 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> 	int exclude_ifindex = exclude_ingress ? dev_rx->ifindex : 0;
>+	int exclude_ifindex_master = 0;
> 	struct bpf_dtab_netdev *dst, *last_dst = NULL;
> 	struct hlist_head *head;
> 	struct xdp_frame *xdpf;
> 	unsigned int i;
> 	int err;
> 
>+	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
>+		struct net_device *master = netdev_master_upper_dev_get_rcu(dev_rx);
>+
>+		exclude_ifindex_master = (master && exclude_ingress) ? master->ifindex : 0;
>+	}
>+

	Will the above logic do what is intended if the device stacking
isn't a simple bond -> ethX arrangement?  I.e., bond -> VLAN.?? -> ethX
or perhaps even bondA -> VLAN.?? -> bondB -> ethX ?

	-J

> 	xdpf = xdp_convert_buff_to_frame(xdp);
> 	if (unlikely(!xdpf))
> 		return -EOVERFLOW;
>@@ -559,7 +568,7 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
> 		for (i = 0; i < map->max_entries; i++) {
> 			dst = READ_ONCE(dtab->netdev_map[i]);
>-			if (!is_valid_dst(dst, xdp, exclude_ifindex))
>+			if (!is_valid_dst(dst, xdp, exclude_ifindex, exclude_ifindex_master))
> 				continue;
> 
> 			/* we only need n-1 clones; last_dst enqueued below */
>@@ -579,7 +588,9 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> 			head = dev_map_index_hash(dtab, i);
> 			hlist_for_each_entry_rcu(dst, head, index_hlist,
> 						 lockdep_is_held(&dtab->index_lock)) {
>-				if (!is_valid_dst(dst, xdp, exclude_ifindex))
>+				if (!is_valid_dst(dst, xdp,
>+						  exclude_ifindex,
>+						  exclude_ifindex_master))
> 					continue;
> 
> 				/* we only need n-1 clones; last_dst enqueued below */
>@@ -646,16 +657,25 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
> {
> 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> 	int exclude_ifindex = exclude_ingress ? dev->ifindex : 0;
>+	int exclude_ifindex_master = 0;
> 	struct bpf_dtab_netdev *dst, *last_dst = NULL;
> 	struct hlist_head *head;
> 	struct hlist_node *next;
> 	unsigned int i;
> 	int err;
> 
>+	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
>+		struct net_device *master = netdev_master_upper_dev_get_rcu(dev);
>+
>+		exclude_ifindex_master = (master && exclude_ingress) ? master->ifindex : 0;
>+	}
>+
> 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
> 		for (i = 0; i < map->max_entries; i++) {
> 			dst = READ_ONCE(dtab->netdev_map[i]);
>-			if (!dst || dst->dev->ifindex == exclude_ifindex)
>+			if (!dst ||
>+			    dst->dev->ifindex == exclude_ifindex ||
>+			    dst->dev->ifindex == exclude_ifindex_master)
> 				continue;
> 
> 			/* we only need n-1 clones; last_dst enqueued below */
>@@ -674,7 +694,9 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
> 		for (i = 0; i < dtab->n_buckets; i++) {
> 			head = dev_map_index_hash(dtab, i);
> 			hlist_for_each_entry_safe(dst, next, head, index_hlist) {
>-				if (!dst || dst->dev->ifindex == exclude_ifindex)
>+				if (!dst ||
>+				    dst->dev->ifindex == exclude_ifindex ||
>+				    dst->dev->ifindex == exclude_ifindex_master)
> 					continue;
> 
> 				/* we only need n-1 clones; last_dst enqueued below */
>-- 
>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

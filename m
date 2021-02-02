Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B9030C650
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbhBBQoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:44:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236342AbhBBQcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 11:32:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612283434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GlWyJZFPLvZd2uOv7XebixcLIn4+3bgaof6lmFszE7I=;
        b=dRh8tM8iIIT4WKYRUl8EOSxGZrLVAHSbswBa0AiQKK3IxqJ+wbTjMmIfWpavdVKch9eilu
        kWKdjSkFpQb+51IFwVsV0vayh+N4/dRaEnb688OUnmnARIfnbO57oFYPe703QwXLYSj3To
        UK3Sp89M8PBy9epYzphFE5mkIUv4co8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-zz5-B5VeOGWGwcDMaPabIw-1; Tue, 02 Feb 2021 11:27:04 -0500
X-MC-Unique: zz5-B5VeOGWGwcDMaPabIw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81218DF8A9;
        Tue,  2 Feb 2021 16:27:01 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9A215C224;
        Tue,  2 Feb 2021 16:26:57 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id DCEE730736C74;
        Tue,  2 Feb 2021 17:26:56 +0100 (CET)
Subject: [PATCH bpf-next V15 3/7] bpf: bpf_fib_lookup return MTU value as
 output when looked up
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Date:   Tue, 02 Feb 2021 17:26:56 +0100
Message-ID: <161228321684.576669.10873647164254991996.stgit@firesoul>
In-Reply-To: <161228314075.576669.15427172810948915572.stgit@firesoul>
References: <161228314075.576669.15427172810948915572.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF-helpers for FIB lookup (bpf_xdp_fib_lookup and bpf_skb_fib_lookup)
can perform MTU check and return BPF_FIB_LKUP_RET_FRAG_NEEDED. The BPF-prog
don't know the MTU value that caused this rejection.

If the BPF-prog wants to implement PMTU (Path MTU Discovery) (rfc1191) it
need to know this MTU value for the ICMP packet.

Patch change lookup and result struct bpf_fib_lookup, to contain this MTU
value as output via a union with 'tot_len' as this is the value used for
the MTU lookup.

V5:
 - Fixed uninit value spotted by Dan Carpenter.
 - Name struct output member mtu_result

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 include/uapi/linux/bpf.h       |   11 +++++++++--
 net/core/filter.c              |   22 +++++++++++++++-------
 tools/include/uapi/linux/bpf.h |   11 +++++++++--
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c001766adcbc..05bfc8c843dc 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2231,6 +2231,9 @@ union bpf_attr {
  *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
  *		  packet is not forwarded or needs assist from full stack
  *
+ *		If lookup fails with BPF_FIB_LKUP_RET_FRAG_NEEDED, then the MTU
+ *		was exceeded and output params->mtu_result contains the MTU.
+ *
  * long bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map *map, void *key, u64 flags)
  *	Description
  *		Add an entry to, or update a sockhash *map* referencing sockets.
@@ -4981,9 +4984,13 @@ struct bpf_fib_lookup {
 	__be16	sport;
 	__be16	dport;
 
-	/* total length of packet from network header - used for MTU check */
-	__u16	tot_len;
+	union {	/* used for MTU check */
+		/* input to lookup */
+		__u16	tot_len; /* L3 length from network hdr (iph->tot_len) */
 
+		/* output: MTU value */
+		__u16	mtu_result;
+	};
 	/* input: L3 device index for lookup
 	 * output: device index from FIB lookup
 	 */
diff --git a/net/core/filter.c b/net/core/filter.c
index 252fbb294001..7b1b9baaabd5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5289,12 +5289,14 @@ static const struct bpf_func_proto bpf_skb_get_xfrm_state_proto = {
 #if IS_ENABLED(CONFIG_INET) || IS_ENABLED(CONFIG_IPV6)
 static int bpf_fib_set_fwd_params(struct bpf_fib_lookup *params,
 				  const struct neighbour *neigh,
-				  const struct net_device *dev)
+				  const struct net_device *dev, u32 mtu)
 {
 	memcpy(params->dmac, neigh->ha, ETH_ALEN);
 	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
 	params->h_vlan_TCI = 0;
 	params->h_vlan_proto = 0;
+	if (mtu)
+		params->mtu_result = mtu; /* union with tot_len */
 
 	return 0;
 }
@@ -5310,8 +5312,8 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct net_device *dev,
 	struct neighbour *neigh;
 	struct fib_result res;
 	struct flowi4 fl4;
+	u32 mtu = 0;
 	int err;
-	u32 mtu;
 
 	/* verify forwarding is enabled on this interface */
 	in_dev = __in_dev_get_rcu(dev);
@@ -5374,8 +5376,10 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct net_device *dev,
 
 	if (check_mtu) {
 		mtu = ip_mtu_from_fib_result(&res, params->ipv4_dst);
-		if (params->tot_len > mtu)
+		if (params->tot_len > mtu) {
+			params->mtu_result = mtu; /* union with tot_len */
 			return BPF_FIB_LKUP_RET_FRAG_NEEDED;
+		}
 	}
 
 	nhc = res.nhc;
@@ -5409,7 +5413,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct net_device *dev,
 	if (!neigh)
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 
-	return bpf_fib_set_fwd_params(params, neigh, dev);
+	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
 }
 #endif
 
@@ -5426,7 +5430,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct net_device *dev,
 	struct flowi6 fl6;
 	int strict = 0;
 	int oif, err;
-	u32 mtu;
+	u32 mtu = 0;
 
 	/* link local addresses are never forwarded */
 	if (rt6_need_strict(dst) || rt6_need_strict(src))
@@ -5497,8 +5501,10 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct net_device *dev,
 
 	if (check_mtu) {
 		mtu = ipv6_stub->ip6_mtu_from_fib6(&res, dst, src);
-		if (params->tot_len > mtu)
+		if (params->tot_len > mtu) {
+			params->mtu_result = mtu; /* union with tot_len */
 			return BPF_FIB_LKUP_RET_FRAG_NEEDED;
+		}
 	}
 
 	if (res.nh->fib_nh_lws)
@@ -5518,7 +5524,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct net_device *dev,
 	if (!neigh)
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 
-	return bpf_fib_set_fwd_params(params, neigh, dev);
+	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
 }
 #endif
 
@@ -5601,6 +5607,8 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
 		 */
 		if (!is_skb_forwardable(dev, skb))
 			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
+
+		params->mtu_result = dev->mtu; /* union with tot_len */
 	}
 
 	return rc;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c001766adcbc..05bfc8c843dc 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2231,6 +2231,9 @@ union bpf_attr {
  *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
  *		  packet is not forwarded or needs assist from full stack
  *
+ *		If lookup fails with BPF_FIB_LKUP_RET_FRAG_NEEDED, then the MTU
+ *		was exceeded and output params->mtu_result contains the MTU.
+ *
  * long bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map *map, void *key, u64 flags)
  *	Description
  *		Add an entry to, or update a sockhash *map* referencing sockets.
@@ -4981,9 +4984,13 @@ struct bpf_fib_lookup {
 	__be16	sport;
 	__be16	dport;
 
-	/* total length of packet from network header - used for MTU check */
-	__u16	tot_len;
+	union {	/* used for MTU check */
+		/* input to lookup */
+		__u16	tot_len; /* L3 length from network hdr (iph->tot_len) */
 
+		/* output: MTU value */
+		__u16	mtu_result;
+	};
 	/* input: L3 device index for lookup
 	 * output: device index from FIB lookup
 	 */



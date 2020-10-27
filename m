Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333F029BBD8
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760791AbgJ0Q2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:28:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1809612AbgJ0Q1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 12:27:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603816026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0mu3rh5ii9+fgIYGbdiygzeKE8efzwH749qvkjDd7jk=;
        b=J0njnsVC/cF56QTpS1WaGxX6ihw8pkzEsHG8TI2gv5fUoo3YD+qfRa/HxaBIWMBYBZIMFT
        CRWSkT0iDDX8J4sGgUy/cWVna9hE76yM8jq36ETbedWel0OGjQDPDyVt+f0BE3z/jAiLXQ
        B10TbMgpKdjbP8ZIZ+3AZRmegz57yKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-7gZ1fkFxOi-8dbTE4eYdYw-1; Tue, 27 Oct 2020 12:27:02 -0400
X-MC-Unique: 7gZ1fkFxOi-8dbTE4eYdYw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E158F809DDD;
        Tue, 27 Oct 2020 16:26:59 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46C1560C11;
        Tue, 27 Oct 2020 16:26:56 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 4BC6F30736C8B;
        Tue, 27 Oct 2020 17:26:55 +0100 (CET)
Subject: [PATCH bpf-next V4 2/5] bpf: bpf_fib_lookup return MTU value as
 output when looked up
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Date:   Tue, 27 Oct 2020 17:26:55 +0100
Message-ID: <160381601522.1435097.11103677488984953095.stgit@firesoul>
In-Reply-To: <160381592923.1435097.2008820753108719855.stgit@firesoul>
References: <160381592923.1435097.2008820753108719855.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF-helpers for FIB lookup (bpf_xdp_fib_lookup and bpf_skb_fib_lookup)
can perform MTU check and return BPF_FIB_LKUP_RET_FRAG_NEEDED.  The BPF-prog
don't know the MTU value that caused this rejection.

If the BPF-prog wants to implement PMTU (Path MTU Discovery) (rfc1191) it
need to know this MTU value for the ICMP packet.

Patch change lookup and result struct bpf_fib_lookup, to contain this MTU
value as output via a union with 'tot_len' as this is the value used for
the MTU lookup.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/uapi/linux/bpf.h       |   11 +++++++++--
 net/core/filter.c              |   17 ++++++++++++-----
 tools/include/uapi/linux/bpf.h |   11 +++++++++--
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e6ceac3f7d62..03c042e3a34c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2219,6 +2219,9 @@ union bpf_attr {
  *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
  *		  packet is not forwarded or needs assist from full stack
  *
+ *		If lookup fails with BPF_FIB_LKUP_RET_FRAG_NEEDED, then the MTU
+ *		was exceeded and result params->mtu contains the MTU.
+ *
  * long bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map *map, void *key, u64 flags)
  *	Description
  *		Add an entry to, or update a sockhash *map* referencing sockets.
@@ -4872,9 +4875,13 @@ struct bpf_fib_lookup {
 	__be16	sport;
 	__be16	dport;
 
-	/* total length of packet from network header - used for MTU check */
-	__u16	tot_len;
+	union {	/* used for MTU check */
+		/* input to lookup */
+		__u16	tot_len; /* total length of packet from network hdr */
 
+		/* output: MTU value (if requested check_mtu) */
+		__u16	mtu;
+	};
 	/* input: L3 device index for lookup
 	 * output: device index from FIB lookup
 	 */
diff --git a/net/core/filter.c b/net/core/filter.c
index 1ee97fdeea64..caa427edc563 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5265,12 +5265,13 @@ static const struct bpf_func_proto bpf_skb_get_xfrm_state_proto = {
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
+	params->mtu = mtu;
 
 	return 0;
 }
@@ -5354,8 +5355,10 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 
 	if (check_mtu) {
 		mtu = ip_mtu_from_fib_result(&res, params->ipv4_dst);
-		if (params->tot_len > mtu)
+		if (params->tot_len > mtu) {
+			params->mtu = mtu; /* union with tot_len */
 			return BPF_FIB_LKUP_RET_FRAG_NEEDED;
+		}
 	}
 
 	nhc = res.nhc;
@@ -5389,7 +5392,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	if (!neigh)
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 
-	return bpf_fib_set_fwd_params(params, neigh, dev);
+	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
 }
 #endif
 
@@ -5481,8 +5484,10 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 
 	if (check_mtu) {
 		mtu = ipv6_stub->ip6_mtu_from_fib6(&res, dst, src);
-		if (params->tot_len > mtu)
+		if (params->tot_len > mtu) {
+			params->mtu = mtu; /* union with tot_len */
 			return BPF_FIB_LKUP_RET_FRAG_NEEDED;
+		}
 	}
 
 	if (res.nh->fib_nh_lws)
@@ -5502,7 +5507,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	if (!neigh)
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 
-	return bpf_fib_set_fwd_params(params, neigh, dev);
+	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
 }
 #endif
 
@@ -5571,6 +5576,8 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
 		dev = dev_get_by_index_rcu(net, params->ifindex);
 		if (!is_skb_forwardable(dev, skb))
 			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
+
+		params->mtu = dev->mtu; /* union with tot_len */
 	}
 
 	return rc;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index e6ceac3f7d62..03c042e3a34c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2219,6 +2219,9 @@ union bpf_attr {
  *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
  *		  packet is not forwarded or needs assist from full stack
  *
+ *		If lookup fails with BPF_FIB_LKUP_RET_FRAG_NEEDED, then the MTU
+ *		was exceeded and result params->mtu contains the MTU.
+ *
  * long bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map *map, void *key, u64 flags)
  *	Description
  *		Add an entry to, or update a sockhash *map* referencing sockets.
@@ -4872,9 +4875,13 @@ struct bpf_fib_lookup {
 	__be16	sport;
 	__be16	dport;
 
-	/* total length of packet from network header - used for MTU check */
-	__u16	tot_len;
+	union {	/* used for MTU check */
+		/* input to lookup */
+		__u16	tot_len; /* total length of packet from network hdr */
 
+		/* output: MTU value (if requested check_mtu) */
+		__u16	mtu;
+	};
 	/* input: L3 device index for lookup
 	 * output: device index from FIB lookup
 	 */



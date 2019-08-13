Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29118B80A
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfHMMHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:07:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36292 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbfHMMHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:07:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id w2so682105pfi.3;
        Tue, 13 Aug 2019 05:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Tz0gD0fN7lfmTT1cRoBEztbwc847PpvO+BtdiAc5R4=;
        b=JJtdbqzIrih7fa4JRsBVVyxVOEnZ3DyPngz9UVsOCZJ38FixdPTVmUZg3eCP0v4N1E
         hNGvQLslDDYp7h1Q16+29vYhyajzDLoI9VUk8z5PqMhErmfxYJoa+qClLslydPeMzL+U
         CzZI50WDwBTp7smvz10g8EsxH/4cLOrxPsHY9+1VGSzf2YFxjbJK6yMv89R0CSoB5Hwz
         3plDLQ63RnklQ0+DYDVRV/poQhPaRetH45wD5VHJvQhXJCFBCKaQeHTUOG87RKgCWhpr
         3AyBHqPBOlREUUFxcR4fTAkCLAqHCZv+/W62a5xaJYUnP7N85A2gL1TkEK82ac7sm+pA
         whwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Tz0gD0fN7lfmTT1cRoBEztbwc847PpvO+BtdiAc5R4=;
        b=Wq2LTmZAvsXhpCkmSZU9yq5zviykeiKZx5MIHlsXdp4SfCZlJGmgfqiUQeYcG7bs/W
         z/1RANZXUo4DdAOmPCg7FGblUzBtiMTJSBr3eNbI4Ie/YsWspbRpjPNqXBaxn2hL1VWA
         DNdMER7hUcrknxz04OvzO7M258mUpnGhKg54RZ8hh16FIW0w/jBwd35ybKg0YDCUSDuH
         +qxrJWkOHDoIoXnYvgMhsl/m9daoozMup/uBuEihaXfFuNe0+KDx1nidVd3OPwGiZmXc
         aKdPAhQaSXQYfHH85IqkFzkpG+qSAFygsvXs7C7s7yDDnFQR3Mroup8iPNMABMraAhkn
         jLbw==
X-Gm-Message-State: APjAAAXskI0ZBLk3zqwSAw+Dcm02Xjj4WB/mMryBB52sc/nQr+Ivil+N
        gzTK2WHCHbq/XzD9DYijGd0=
X-Google-Smtp-Source: APXvYqzxwC8wkT3Grx8FcmM4fmbExdjgF3kr4WneNDMq64CsoUQnIMaXuLdAeiyLz9q+nm4Qqo+dTQ==
X-Received: by 2002:a63:4a20:: with SMTP id x32mr25886128pga.357.1565698066473;
        Tue, 13 Aug 2019 05:07:46 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.07.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:07:45 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: [RFC PATCH bpf-next 07/14] xdp_flow: Add flow handling and basic actions in bpf prog
Date:   Tue, 13 Aug 2019 21:05:51 +0900
Message-Id: <20190813120558.6151-8-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF prog for XDP parses the packet and extracts the flow key. Then find
an entry from flow tables.
Only "accept" and "drop" actions are implemented at this point.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 net/xdp_flow/xdp_flow_kern_bpf.c | 297 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 296 insertions(+), 1 deletion(-)

diff --git a/net/xdp_flow/xdp_flow_kern_bpf.c b/net/xdp_flow/xdp_flow_kern_bpf.c
index c101156..ceb8a92 100644
--- a/net/xdp_flow/xdp_flow_kern_bpf.c
+++ b/net/xdp_flow/xdp_flow_kern_bpf.c
@@ -1,9 +1,27 @@
 // SPDX-License-Identifier: GPL-2.0
 #define KBUILD_MODNAME "foo"
 #include <uapi/linux/bpf.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/if_vlan.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
+#include <net/dsfield.h>
 #include <bpf_helpers.h>
 #include "umh_bpf.h"
 
+/* Used when the action only modifies the packet */
+#define _XDP_CONTINUE -1
+
+struct bpf_map_def SEC("maps") debug_stats = {
+	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(long),
+	.max_entries = 256,
+};
+
 struct bpf_map_def SEC("maps") flow_masks_head = {
 	.type = BPF_MAP_TYPE_ARRAY,
 	.key_size = sizeof(u32),
@@ -25,10 +43,287 @@ struct bpf_map_def SEC("maps") flow_tables = {
 	.max_entries = MAX_FLOW_MASKS,
 };
 
+static inline void account_debug(int idx)
+{
+	long *cnt;
+
+	cnt = bpf_map_lookup_elem(&debug_stats, &idx);
+	if (cnt)
+		*cnt += 1;
+}
+
+static inline void account_action(int act)
+{
+	account_debug(act + 1);
+}
+
+static inline int action_accept(void)
+{
+	account_action(XDP_FLOW_ACTION_ACCEPT);
+	return XDP_PASS;
+}
+
+static inline int action_drop(void)
+{
+	account_action(XDP_FLOW_ACTION_DROP);
+	return XDP_DROP;
+}
+
+static inline int action_redirect(struct xdp_flow_action *action)
+{
+	account_action(XDP_FLOW_ACTION_REDIRECT);
+
+	// TODO: implement this
+	return XDP_ABORTED;
+}
+
+static inline int action_vlan_push(struct xdp_md *ctx,
+				   struct xdp_flow_action *action)
+{
+	account_action(XDP_FLOW_ACTION_VLAN_PUSH);
+
+	// TODO: implement this
+	return XDP_ABORTED;
+}
+
+static inline int action_vlan_pop(struct xdp_md *ctx,
+				  struct xdp_flow_action *action)
+{
+	account_action(XDP_FLOW_ACTION_VLAN_POP);
+
+	// TODO: implement this
+	return XDP_ABORTED;
+}
+
+static inline int action_vlan_mangle(struct xdp_md *ctx,
+				     struct xdp_flow_action *action)
+{
+	account_action(XDP_FLOW_ACTION_VLAN_MANGLE);
+
+	// TODO: implement this
+	return XDP_ABORTED;
+}
+
+static inline int action_mangle(struct xdp_md *ctx,
+				struct xdp_flow_action *action)
+{
+	account_action(XDP_FLOW_ACTION_MANGLE);
+
+	// TODO: implement this
+	return XDP_ABORTED;
+}
+
+static inline int action_csum(struct xdp_md *ctx,
+			      struct xdp_flow_action *action)
+{
+	account_action(XDP_FLOW_ACTION_CSUM);
+
+	// TODO: implement this
+	return XDP_ABORTED;
+}
+
+static inline void __ether_addr_copy(u8 *dst, const u8 *src)
+{
+	u16 *a = (u16 *)dst;
+	const u16 *b = (const u16 *)src;
+
+	a[0] = b[0];
+	a[1] = b[1];
+	a[2] = b[2];
+}
+
+static inline int parse_ipv4(void *data, u64 *nh_off, void *data_end,
+			     struct xdp_flow_key *key)
+{
+	struct iphdr *iph = data + *nh_off;
+
+	if (iph + 1 > data_end)
+		return -1;
+
+	key->ipv4.src = iph->saddr;
+	key->ipv4.dst = iph->daddr;
+	key->ip.ttl = iph->ttl;
+	key->ip.tos = iph->tos;
+	*nh_off += iph->ihl * 4;
+
+	return iph->protocol;
+}
+
+static inline int parse_ipv6(void *data, u64 *nh_off, void *data_end,
+			     struct xdp_flow_key *key)
+{
+	struct ipv6hdr *ip6h = data + *nh_off;
+
+	if (ip6h + 1 > data_end)
+		return -1;
+
+	key->ipv6.src = ip6h->saddr;
+	key->ipv6.dst = ip6h->daddr;
+	key->ip.ttl = ip6h->hop_limit;
+	key->ip.tos = ipv6_get_dsfield(ip6h);
+	*nh_off += sizeof(*ip6h);
+
+	if (ip6h->nexthdr == NEXTHDR_HOP ||
+	    ip6h->nexthdr == NEXTHDR_ROUTING ||
+	    ip6h->nexthdr == NEXTHDR_FRAGMENT ||
+	    ip6h->nexthdr == NEXTHDR_AUTH ||
+	    ip6h->nexthdr == NEXTHDR_NONE ||
+	    ip6h->nexthdr == NEXTHDR_DEST)
+		return 0;
+
+	return ip6h->nexthdr;
+}
+
+#define for_each_flow_mask(entry, head, idx, cnt) \
+	for (entry = bpf_map_lookup_elem(&flow_masks, (head)), \
+	     idx = *(head), cnt = 0; \
+	     entry != NULL && cnt < MAX_FLOW_MASKS; \
+	     idx = entry->next, \
+	     entry = bpf_map_lookup_elem(&flow_masks, &idx), cnt++)
+
+static inline void flow_mask(struct xdp_flow_key *mkey,
+			     const struct xdp_flow_key *key,
+			     const struct xdp_flow_key *mask)
+{
+	long *lmkey = (long *)mkey;
+	long *lmask = (long *)mask;
+	long *lkey = (long *)key;
+	int i;
+
+	for (i = 0; i < sizeof(*mkey); i += sizeof(long))
+		*lmkey++ = *lkey++ & *lmask++;
+}
+
 SEC("xdp_flow")
 int xdp_flow_prog(struct xdp_md *ctx)
 {
-	return XDP_PASS;
+	void *data_end = (void *)(long)ctx->data_end;
+	struct xdp_flow_actions *actions = NULL;
+	void *data = (void *)(long)ctx->data;
+	int cnt, idx, action_idx, zero = 0;
+	struct xdp_flow_mask_entry *entry;
+	struct ethhdr *eth = data;
+	struct xdp_flow_key key;
+	int rc = XDP_DROP;
+	long *value;
+	u16 h_proto;
+	u32 ipproto;
+	u64 nh_off;
+	int *head;
+
+	account_debug(0);
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	__builtin_memset(&key, 0, sizeof(key));
+	h_proto = eth->h_proto;
+	__ether_addr_copy(key.eth.dst, eth->h_dest);
+	__ether_addr_copy(key.eth.src, eth->h_source);
+
+	if (eth_type_vlan(h_proto)) {
+		struct vlan_hdr *vhdr;
+
+		vhdr = data + nh_off;
+		nh_off += sizeof(*vhdr);
+		if (data + nh_off > data_end)
+			return XDP_DROP;
+		key.vlan.tpid = h_proto;
+		key.vlan.tci = vhdr->h_vlan_TCI;
+		h_proto = vhdr->h_vlan_encapsulated_proto;
+	}
+	key.eth.type = h_proto;
+
+	if (h_proto == htons(ETH_P_IP))
+		ipproto = parse_ipv4(data, &nh_off, data_end, &key);
+	else if (h_proto == htons(ETH_P_IPV6))
+		ipproto = parse_ipv6(data, &nh_off, data_end, &key);
+	else
+		ipproto = 0;
+	if (ipproto < 0)
+		return XDP_DROP;
+	key.ip.proto = ipproto;
+
+	if (ipproto == IPPROTO_TCP) {
+		struct tcphdr *th = data + nh_off;
+
+		if (th + 1 > data_end)
+			return XDP_DROP;
+
+		key.l4port.src = th->source;
+		key.l4port.dst = th->dest;
+		key.tcp.flags = (*(__be16 *)&tcp_flag_word(th) & htons(0x0FFF));
+	} else if (ipproto == IPPROTO_UDP) {
+		struct udphdr *uh = data + nh_off;
+
+		if (uh + 1 > data_end)
+			return XDP_DROP;
+
+		key.l4port.src = uh->source;
+		key.l4port.dst = uh->dest;
+	}
+
+	head = bpf_map_lookup_elem(&flow_masks_head, &zero);
+	if (!head)
+		return XDP_PASS;
+
+	for_each_flow_mask(entry, head, idx, cnt) {
+		struct xdp_flow_key mkey;
+		void *flow_table;
+
+		flow_table = bpf_map_lookup_elem(&flow_tables, &idx);
+		if (!flow_table)
+			return XDP_ABORTED;
+
+		flow_mask(&mkey, &key, &entry->mask);
+		actions = bpf_map_lookup_elem(flow_table, &mkey);
+		if (actions)
+			break;
+	}
+
+	if (!actions)
+		return XDP_PASS;
+
+	for (action_idx = 0;
+	     action_idx < actions->num_actions &&
+	     action_idx < MAX_XDP_FLOW_ACTIONS;
+	     action_idx++) {
+		struct xdp_flow_action *action;
+		int act;
+
+		action = &actions->actions[action_idx];
+
+		switch (action->id) {
+		case XDP_FLOW_ACTION_ACCEPT:
+			return action_accept();
+		case XDP_FLOW_ACTION_DROP:
+			return action_drop();
+		case XDP_FLOW_ACTION_REDIRECT:
+			return action_redirect(action);
+		case XDP_FLOW_ACTION_VLAN_PUSH:
+			act = action_vlan_push(ctx, action);
+			break;
+		case XDP_FLOW_ACTION_VLAN_POP:
+			act = action_vlan_pop(ctx, action);
+			break;
+		case XDP_FLOW_ACTION_VLAN_MANGLE:
+			act = action_vlan_mangle(ctx, action);
+			break;
+		case XDP_FLOW_ACTION_MANGLE:
+			act = action_mangle(ctx, action);
+			break;
+		case XDP_FLOW_ACTION_CSUM:
+			act = action_csum(ctx, action);
+			break;
+		default:
+			return XDP_ABORTED;
+		}
+		if (act != _XDP_CONTINUE)
+			return act;
+	}
+
+	return XDP_ABORTED;
 }
 
 char _license[] SEC("license") = "GPL";
-- 
1.8.3.1


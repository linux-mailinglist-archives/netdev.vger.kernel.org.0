Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3028D4F7A
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 13:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbfJLL5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 07:57:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbfJLLzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 07:55:33 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4D0EC10C0935;
        Sat, 12 Oct 2019 11:55:32 +0000 (UTC)
Received: from new-host.redhat.com (ovpn-204-41.brq.redhat.com [10.40.204.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 090686017E;
        Sat, 12 Oct 2019 11:55:29 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     lkp@intel.com
Cc:     davem@davemloft.net, dcaratti@redhat.com,
        john.hurley@netronome.com, kbuild-all@01.org, lorenzo@kernel.org,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net v2 2/2] net/sched: fix corrupted L2 header with MPLS 'push' and 'pop' actions
Date:   Sat, 12 Oct 2019 13:55:07 +0200
Message-Id: <e70f78e70bc071984aa17081878eae525c7bc64e.1570878412.git.dcaratti@redhat.com>
In-Reply-To: <cover.1570878412.git.dcaratti@redhat.com>
References: <cover.1570878412.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Sat, 12 Oct 2019 11:55:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the following script:

 # tc qdisc add dev eth0 clsact
 # tc filter add dev eth0 egress protocol ip matchall \
 > action mpls push protocol mpls_uc label 0x355aa bos 1

causes corruption of all IP packets transmitted by eth0. On TC egress, we
can't rely on the value of skb->mac_len, because it's 0 and a MPLS 'push'
operation will result in an overwrite of the first 4 octets in the packet
L2 header (e.g. the Destination Address if eth0 is an Ethernet); the same
error pattern is present also in the MPLS 'pop' operation. Fix this error
in act_mpls data plane, computing 'mac_len' as the difference between the
network header and the mac header (when not at TC ingress), and use it in
MPLS 'push'/'pop' core functions.

v2: unbreak 'make htmldocs' because of missing documentation of 'mac_len'
    in skb_mpls_pop(), reported by kbuild test robot

CC: Lorenzo Bianconi <lorenzo@kernel.org>
Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: John Hurley <john.hurley@netronome.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/linux/skbuff.h    |  5 +++--
 net/core/skbuff.c         | 19 +++++++++++--------
 net/openvswitch/actions.c |  5 +++--
 net/sched/act_mpls.c      | 12 ++++++++----
 4 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4351577b14d7..7914fdaf4226 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3510,8 +3510,9 @@ int skb_ensure_writable(struct sk_buff *skb, int write_len);
 int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci);
 int skb_vlan_pop(struct sk_buff *skb);
 int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
-int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto);
-int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto);
+int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
+		  int mac_len);
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len);
 int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse);
 int skb_mpls_dec_ttl(struct sk_buff *skb);
 struct sk_buff *pskb_extract(struct sk_buff *skb, int off, int to_copy,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index cd59ccd6da57..c81b59177859 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5477,12 +5477,14 @@ static void skb_mod_eth_type(struct sk_buff *skb, struct ethhdr *hdr,
  * @skb: buffer
  * @mpls_lse: MPLS label stack entry to push
  * @mpls_proto: ethertype of the new MPLS header (expects 0x8847 or 0x8848)
+ * @mac_len: length of the MAC header
  *
  * Expects skb->data at mac header.
  *
  * Returns 0 on success, -errno otherwise.
  */
-int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto)
+int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
+		  int mac_len)
 {
 	struct mpls_shim_hdr *lse;
 	int err;
@@ -5499,15 +5501,15 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto)
 		return err;
 
 	if (!skb->inner_protocol) {
-		skb_set_inner_network_header(skb, skb->mac_len);
+		skb_set_inner_network_header(skb, mac_len);
 		skb_set_inner_protocol(skb, skb->protocol);
 	}
 
 	skb_push(skb, MPLS_HLEN);
 	memmove(skb_mac_header(skb) - MPLS_HLEN, skb_mac_header(skb),
-		skb->mac_len);
+		mac_len);
 	skb_reset_mac_header(skb);
-	skb_set_network_header(skb, skb->mac_len);
+	skb_set_network_header(skb, mac_len);
 
 	lse = mpls_hdr(skb);
 	lse->label_stack_entry = mpls_lse;
@@ -5526,29 +5528,30 @@ EXPORT_SYMBOL_GPL(skb_mpls_push);
  *
  * @skb: buffer
  * @next_proto: ethertype of header after popped MPLS header
+ * @mac_len: length of the MAC header
  *
  * Expects skb->data at mac header.
  *
  * Returns 0 on success, -errno otherwise.
  */
-int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto)
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
 {
 	int err;
 
 	if (unlikely(!eth_p_mpls(skb->protocol)))
 		return 0;
 
-	err = skb_ensure_writable(skb, skb->mac_len + MPLS_HLEN);
+	err = skb_ensure_writable(skb, mac_len + MPLS_HLEN);
 	if (unlikely(err))
 		return err;
 
 	skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
 	memmove(skb_mac_header(skb) + MPLS_HLEN, skb_mac_header(skb),
-		skb->mac_len);
+		mac_len);
 
 	__skb_pull(skb, MPLS_HLEN);
 	skb_reset_mac_header(skb);
-	skb_set_network_header(skb, skb->mac_len);
+	skb_set_network_header(skb, mac_len);
 
 	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
 		struct ethhdr *hdr;
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 3572e11b6f21..1c77f520f474 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -165,7 +165,8 @@ static int push_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 {
 	int err;
 
-	err = skb_mpls_push(skb, mpls->mpls_lse, mpls->mpls_ethertype);
+	err = skb_mpls_push(skb, mpls->mpls_lse, mpls->mpls_ethertype,
+			    skb->mac_len);
 	if (err)
 		return err;
 
@@ -178,7 +179,7 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 {
 	int err;
 
-	err = skb_mpls_pop(skb, ethertype);
+	err = skb_mpls_pop(skb, ethertype, skb->mac_len);
 	if (err)
 		return err;
 
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index e168df0e008a..4cf6c553bb0b 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -55,7 +55,7 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
 	struct tcf_mpls *m = to_mpls(a);
 	struct tcf_mpls_params *p;
 	__be32 new_lse;
-	int ret;
+	int ret, mac_len;
 
 	tcf_lastuse_update(&m->tcf_tm);
 	bstats_cpu_update(this_cpu_ptr(m->common.cpu_bstats), skb);
@@ -63,8 +63,12 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
 	/* Ensure 'data' points at mac_header prior calling mpls manipulating
 	 * functions.
 	 */
-	if (skb_at_tc_ingress(skb))
+	if (skb_at_tc_ingress(skb)) {
 		skb_push_rcsum(skb, skb->mac_len);
+		mac_len = skb->mac_len;
+	} else {
+		mac_len = skb_network_header(skb) - skb_mac_header(skb);
+	}
 
 	ret = READ_ONCE(m->tcf_action);
 
@@ -72,12 +76,12 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
 
 	switch (p->tcfm_action) {
 	case TCA_MPLS_ACT_POP:
-		if (skb_mpls_pop(skb, p->tcfm_proto))
+		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len))
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_PUSH:
 		new_lse = tcf_mpls_get_lse(NULL, p, !eth_p_mpls(skb->protocol));
-		if (skb_mpls_push(skb, new_lse, p->tcfm_proto))
+		if (skb_mpls_push(skb, new_lse, p->tcfm_proto, mac_len))
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_MODIFY:
-- 
2.21.0


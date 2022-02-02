Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB3B4A72F1
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbiBBO0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:26:11 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:57162 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344909AbiBBO0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:26:09 -0500
Received: from ubuntu.home (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id C2783200F82F;
        Wed,  2 Feb 2022 15:26:07 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be C2783200F82F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1643811967;
        bh=gE31Qz4OjJ4aq5YcZ03ZktYYvRdjIO5JLWPZTMHntbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwgLQ+Q/aI8scmpnYd3KaAxO+Y9qCTOsNfXuCd30s3qxBg412qLR5TPGeoET3YhUm
         6gcc8RokFON+vX5Oiu8AEtiRmAo9skgJDBS19cqTwxwUKkf+RJrlvozgSp5WEyOP2o
         t7u/MOhxJiMC98sGHZt7KVje0PKuXRTZjA+lGrFyqn12/2/nwABy/ti1+DlSdrFB8J
         Bni6hqNF21hIHXpshF1eesRw5oPZ3k+VJ3WIlW4z2gQx8YTN3CjXJ4tTN7g0eLvRk6
         w4A1xarUAiRHGxruF8xtV1VArbQjTCeYmZy3rtaTFT+jCiIdbvG/hFhzTfA9OvVGNz
         2p9281RJXNsOA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next v2 2/2] ipv6: ioam: Insertion frequency in lwtunnel output
Date:   Wed,  2 Feb 2022 15:25:54 +0100
Message-Id: <20220202142554.9691-3-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220202142554.9691-1-justin.iurman@uliege.be>
References: <20220202142554.9691-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the IOAM insertion frequency inside its lwtunnel output
function. This patch introduces a new (atomic) counter for packets,
based on which the algorithm will decide if IOAM should be added or not.

Default frequency is "1/1" (i.e., applied to all packets) for backward
compatibility. The iproute2 patch is ready and will be submitted as soon
as this one is accepted.

Previous iproute2 command:
ip -6 ro ad fc00::1/128 encap ioam6 [ mode ... ] ...

New iproute2 command:
ip -6 ro ad fc00::1/128 encap ioam6 [ freq k/n ] [ mode ... ] ...

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 net/ipv6/ioam6_iptunnel.c | 59 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index f90a87389fcc..f6f5b83dd954 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -32,13 +32,25 @@ struct ioam6_lwt_encap {
 	struct ioam6_trace_hdr traceh;
 } __packed;
 
+struct ioam6_lwt_freq {
+	u32 k;
+	u32 n;
+};
+
 struct ioam6_lwt {
 	struct dst_cache cache;
+	struct ioam6_lwt_freq freq;
+	atomic_t pkt_cnt;
 	u8 mode;
 	struct in6_addr tundst;
 	struct ioam6_lwt_encap	tuninfo;
 };
 
+static struct netlink_range_validation freq_range = {
+	.min = IOAM6_IPTUNNEL_FREQ_MIN,
+	.max = IOAM6_IPTUNNEL_FREQ_MAX,
+};
+
 static struct ioam6_lwt *ioam6_lwt_state(struct lwtunnel_state *lwt)
 {
 	return (struct ioam6_lwt *)lwt->data;
@@ -55,6 +67,8 @@ static struct ioam6_trace_hdr *ioam6_lwt_trace(struct lwtunnel_state *lwt)
 }
 
 static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
+	[IOAM6_IPTUNNEL_FREQ_K] = NLA_POLICY_FULL_RANGE(NLA_U32, &freq_range),
+	[IOAM6_IPTUNNEL_FREQ_N] = NLA_POLICY_FULL_RANGE(NLA_U32, &freq_range),
 	[IOAM6_IPTUNNEL_MODE]	= NLA_POLICY_RANGE(NLA_U8,
 						   IOAM6_IPTUNNEL_MODE_MIN,
 						   IOAM6_IPTUNNEL_MODE_MAX),
@@ -96,6 +110,7 @@ static int ioam6_build_state(struct net *net, struct nlattr *nla,
 	struct lwtunnel_state *lwt;
 	struct ioam6_lwt *ilwt;
 	int len_aligned, err;
+	u32 freq_k, freq_n;
 	u8 mode;
 
 	if (family != AF_INET6)
@@ -106,6 +121,23 @@ static int ioam6_build_state(struct net *net, struct nlattr *nla,
 	if (err < 0)
 		return err;
 
+	if ((!tb[IOAM6_IPTUNNEL_FREQ_K] && tb[IOAM6_IPTUNNEL_FREQ_N]) ||
+	    (tb[IOAM6_IPTUNNEL_FREQ_K] && !tb[IOAM6_IPTUNNEL_FREQ_N])) {
+		NL_SET_ERR_MSG(extack, "freq: missing parameter");
+		return -EINVAL;
+	} else if (!tb[IOAM6_IPTUNNEL_FREQ_K] && !tb[IOAM6_IPTUNNEL_FREQ_N]) {
+		freq_k = IOAM6_IPTUNNEL_FREQ_MIN;
+		freq_n = IOAM6_IPTUNNEL_FREQ_MIN;
+	} else {
+		freq_k = nla_get_u32(tb[IOAM6_IPTUNNEL_FREQ_K]);
+		freq_n = nla_get_u32(tb[IOAM6_IPTUNNEL_FREQ_N]);
+
+		if (freq_k > freq_n) {
+			NL_SET_ERR_MSG(extack, "freq: k > n is forbidden");
+			return -EINVAL;
+		}
+	}
+
 	if (!tb[IOAM6_IPTUNNEL_MODE])
 		mode = IOAM6_IPTUNNEL_MODE_INLINE;
 	else
@@ -140,6 +172,10 @@ static int ioam6_build_state(struct net *net, struct nlattr *nla,
 		return err;
 	}
 
+	atomic_set(&ilwt->pkt_cnt, 0);
+	ilwt->freq.k = freq_k;
+	ilwt->freq.n = freq_n;
+
 	ilwt->mode = mode;
 	if (tb[IOAM6_IPTUNNEL_DST])
 		ilwt->tundst = nla_get_in6_addr(tb[IOAM6_IPTUNNEL_DST]);
@@ -263,11 +299,18 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	struct in6_addr orig_daddr;
 	struct ioam6_lwt *ilwt;
 	int err = -EINVAL;
+	u32 pkt_cnt;
 
 	if (skb->protocol != htons(ETH_P_IPV6))
 		goto drop;
 
 	ilwt = ioam6_lwt_state(dst->lwtstate);
+
+	/* Check for insertion frequency (i.e., "k over n" insertions) */
+	pkt_cnt = atomic_fetch_inc(&ilwt->pkt_cnt);
+	if (pkt_cnt % ilwt->freq.n >= ilwt->freq.k)
+		goto out;
+
 	orig_daddr = ipv6_hdr(skb)->daddr;
 
 	switch (ilwt->mode) {
@@ -358,6 +401,14 @@ static int ioam6_fill_encap_info(struct sk_buff *skb,
 	struct ioam6_lwt *ilwt = ioam6_lwt_state(lwtstate);
 	int err;
 
+	err = nla_put_u32(skb, IOAM6_IPTUNNEL_FREQ_K, ilwt->freq.k);
+	if (err)
+		goto ret;
+
+	err = nla_put_u32(skb, IOAM6_IPTUNNEL_FREQ_N, ilwt->freq.n);
+	if (err)
+		goto ret;
+
 	err = nla_put_u8(skb, IOAM6_IPTUNNEL_MODE, ilwt->mode);
 	if (err)
 		goto ret;
@@ -379,7 +430,9 @@ static int ioam6_encap_nlsize(struct lwtunnel_state *lwtstate)
 	struct ioam6_lwt *ilwt = ioam6_lwt_state(lwtstate);
 	int nlsize;
 
-	nlsize = nla_total_size(sizeof(ilwt->mode)) +
+	nlsize = nla_total_size(sizeof(ilwt->freq.k)) +
+		  nla_total_size(sizeof(ilwt->freq.n)) +
+		  nla_total_size(sizeof(ilwt->mode)) +
 		  nla_total_size(sizeof(ilwt->tuninfo.traceh));
 
 	if (ilwt->mode != IOAM6_IPTUNNEL_MODE_INLINE)
@@ -395,7 +448,9 @@ static int ioam6_encap_cmp(struct lwtunnel_state *a, struct lwtunnel_state *b)
 	struct ioam6_lwt *ilwt_a = ioam6_lwt_state(a);
 	struct ioam6_lwt *ilwt_b = ioam6_lwt_state(b);
 
-	return (ilwt_a->mode != ilwt_b->mode ||
+	return (ilwt_a->freq.k != ilwt_b->freq.k ||
+		ilwt_a->freq.n != ilwt_b->freq.n ||
+		ilwt_a->mode != ilwt_b->mode ||
 		(ilwt_a->mode != IOAM6_IPTUNNEL_MODE_INLINE &&
 		 !ipv6_addr_equal(&ilwt_a->tundst, &ilwt_b->tundst)) ||
 		trace_a->namespace_id != trace_b->namespace_id);
-- 
2.25.1


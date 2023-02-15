Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDF0697E10
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 15:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjBOOKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 09:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjBOOKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 09:10:03 -0500
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E289D38E94;
        Wed, 15 Feb 2023 06:09:56 -0800 (PST)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 31FDlD5L003217
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Feb 2023 14:47:14 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next 2/3] seg6: add PSP flavor support for SRv6 End behavior
Date:   Wed, 15 Feb 2023 14:46:58 +0100
Message-Id: <20230215134659.7613-3-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230215134659.7613-1-andrea.mayer@uniroma2.it>
References: <20230215134659.7613-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "flavors" framework defined in RFC8986 [1] represents additional
operations that can modify or extend a subset of existing behaviors such as
SRv6 End, End.X and End.T. We report these flavors hereafter:
 - Penultimate Segment Pop (PSP);
 - Ultimate Segment Pop (USP);
 - Ultimate Segment Decapsulation (USD).

Depending on how the Segment Routing Header (SRH) has to be handled, an
SRv6 End* behavior can support these flavors either individually or in
combinations.
In this patch, we only consider the PSP flavor for the SRv6 End behavior.

A PSP enabled SRv6 End behavior is used by the Source/Ingress SR node
(i.e., the one applying the SRv6 Policy) when it needs to instruct the
penultimate SR Endpoint node listed in the SID List (carried by the SRH) to
remove the SRH from the IPv6 header.

Specifically, a PSP enabled SRv6 End behavior processes the SRH by:
   i) decreasing the Segment Left (SL) from 1 to 0;
  ii) copying the Last Segment IDentifier (SID) into the IPv6 Destination
      Address (DA);
 iii) removing (i.e., popping) the outer SRH from the extension headers
      following the IPv6 header.

It is important to note that PSP operation (steps i, ii, iii) takes place
only at a penultimate SR Segment Endpoint node (i.e., when the SL=1) and
does not happen at non-penultimate Endpoint nodes. Indeed, when a SID of
PSP flavor is processed at a non-penultimate SR Segment Endpoint node, the
PSP operation is not performed because it would not be possible to decrease
the SL from 1 to 0.

                                                 SL=2 SL=1 SL=0
                                                   |    |    |
For example, given the SRv6 policy (SID List := <  X,   Y,   Z  >):
 - a PSP enabled SRv6 End behavior bound to SID "Y" will apply the PSP
   operation as Segment Left (SL) is 1, corresponding to the Penultimate
   Segment of the SID List;
 - a PSP enabled SRv6 End behavior bound to SID "X" will *NOT* apply the
   PSP operation as the Segment Left is 2. This behavior instance will
   apply the "standard" End packet processing, ignoring the configured PSP
   flavor at all.

[1] - RFC8986: https://datatracker.ietf.org/doc/html/rfc8986

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 336 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 333 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 765e89a24bc2..dd433cc265c8 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -109,8 +109,15 @@ struct bpf_lwt_prog {
 #define next_csid_chk_lcnode_fn_bits(flen)		\
 	next_csid_chk_lcblock_bits(flen)
 
+#define SEG6_F_LOCAL_FLV_OP(flvname)	BIT(SEG6_LOCAL_FLV_OP_##flvname)
+#define SEG6_F_LOCAL_FLV_PSP		SEG6_F_LOCAL_FLV_OP(PSP)
+
+/* Supported RFC8986 Flavor operations are reported in this bitmask */
+#define SEG6_LOCAL_FLV8986_SUPP_OPS	SEG6_F_LOCAL_FLV_PSP
+
 /* Supported Flavor operations are reported in this bitmask */
-#define SEG6_LOCAL_FLV_SUPP_OPS	(BIT(SEG6_LOCAL_FLV_OP_NEXT_CSID))
+#define SEG6_LOCAL_FLV_SUPP_OPS		(SEG6_F_LOCAL_FLV_OP(NEXT_CSID) | \
+					 SEG6_LOCAL_FLV8986_SUPP_OPS)
 
 struct seg6_flavors_info {
 	/* Flavor operations */
@@ -409,15 +416,331 @@ static bool seg6_next_csid_enabled(__u32 fops)
 	return fops & BIT(SEG6_LOCAL_FLV_OP_NEXT_CSID);
 }
 
+/* We describe the packet state in relation to the absence/presence of the SRH
+ * and the Segment Left (SL) field.
+ * For our purposes, it is not necessary to record the exact value of the SL
+ * when the SID List consists of two or more segments.
+ */
+enum seg6_local_pktinfo {
+	/* the order really matters! */
+	SEG6_LOCAL_PKTINFO_NOHDR	= 0,
+	SEG6_LOCAL_PKTINFO_SL_ZERO,
+	SEG6_LOCAL_PKTINFO_SL_ONE,
+	SEG6_LOCAL_PKTINFO_SL_MORE,
+	__SEG6_LOCAL_PKTINFO_MAX,
+};
+
+#define SEG6_LOCAL_PKTINFO_MAX (__SEG6_LOCAL_PKTINFO_MAX - 1)
+
+static enum seg6_local_pktinfo seg6_get_srh_pktinfo(struct ipv6_sr_hdr *srh)
+{
+	__u8 sgl;
+
+	if (!srh)
+		return SEG6_LOCAL_PKTINFO_NOHDR;
+
+	sgl = srh->segments_left;
+	if (sgl < 2)
+		return SEG6_LOCAL_PKTINFO_SL_ZERO + sgl;
+
+	return SEG6_LOCAL_PKTINFO_SL_MORE;
+}
+
+enum seg6_local_flv_action {
+	SEG6_LOCAL_FLV_ACT_UNSPEC	= 0,
+	SEG6_LOCAL_FLV_ACT_END,
+	SEG6_LOCAL_FLV_ACT_PSP,
+	SEG6_LOCAL_FLV_ACT_USP,
+	SEG6_LOCAL_FLV_ACT_USD,
+	__SEG6_LOCAL_FLV_ACT_MAX
+};
+
+#define SEG6_LOCAL_FLV_ACT_MAX (__SEG6_LOCAL_FLV_ACT_MAX - 1)
+
+/* The action table for RFC8986 flavors (see the flv8986_act_tbl below)
+ * contains the actions (i.e. processing operations) to be applied on packets
+ * when flavors are configured for an End* behavior.
+ * By combining the pkinfo data and from the flavors mask, the macro
+ * computes the index used to access the elements (actions) stored in the
+ * action table. The index is structured as follows:
+ *
+ *                     index
+ *       _______________/\________________
+ *      /                                 \
+ *      +----------------+----------------+
+ *      |        pf      |      afm       |
+ *      +----------------+----------------+
+ *        ph-1 ... p1 p0   fk-1 ... f1 f0
+ *     MSB                               LSB
+ *
+ * where:
+ *  - 'afm' (adjusted flavor mask) is the mask containing a combination of the
+ *     RFC8986 flavors currently supported. 'afm' corresponds to the @fm
+ *     argument of the macro whose value is righ-shifted by 1 bit. By doing so,
+ *     we discard the SEG6_LOCAL_FLV_OP_UNSPEC flag (bit 0 in @fm) which is
+ *     never used here;
+ *  - 'pf' encodes the packet info (pktinfo) regarding the presence/absence of
+ *    the SRH, SL = 0, etc. 'pf' is set with the value of @pf provided as
+ *    argument to the macro.
+ */
+#define flv8986_act_tbl_idx(pf, fm)					\
+	((((pf) << bits_per(SEG6_LOCAL_FLV8986_SUPP_OPS)) |		\
+	  ((fm) & SEG6_LOCAL_FLV8986_SUPP_OPS)) >> SEG6_LOCAL_FLV_OP_PSP)
+
+/* We compute the size of the action table by considering the RFC8986 flavors
+ * actually supported by the kernel. In this way, the size is automatically
+ * adjusted when new flavors are supported.
+ */
+#define FLV8986_ACT_TBL_SIZE						\
+	roundup_pow_of_two(flv8986_act_tbl_idx(SEG6_LOCAL_PKTINFO_MAX,	\
+					       SEG6_LOCAL_FLV8986_SUPP_OPS))
+
+/* tbl_cfg(act, pf, fm) macro is used to easily configure the action
+ * table; it accepts 3 arguments:
+ *     i) @act, the suffix from SEG6_LOCAL_FLV_ACT_{act} representing
+ *        the action that should be applied on the packet;
+ *    ii) @pf, the suffix from SEG6_LOCAL_PKTINFO_{pf} reporting the packet
+ *        info about the lack/presence of SRH, SRH with SL = 0, etc;
+ *   iii) @fm, the mask of flavors.
+ */
+#define tbl_cfg(act, pf, fm)						\
+	[flv8986_act_tbl_idx(SEG6_LOCAL_PKTINFO_##pf,			\
+			     (fm))] = SEG6_LOCAL_FLV_ACT_##act
+
+/* shorthand for improving readability */
+#define F_PSP	SEG6_F_LOCAL_FLV_PSP
+
+/* The table contains, for each combination of the pktinfo data and
+ * flavors, the action that should be taken on a packet (e.g.
+ * "standard" Endpoint processing, Penultimate Segment Pop, etc).
+ *
+ * By default, table entries not explicitly configured are initialized with the
+ * SEG6_LOCAL_FLV_ACT_UNSPEC action, which generally has the effect of
+ * discarding the processed packet.
+ */
+static const u8 flv8986_act_tbl[FLV8986_ACT_TBL_SIZE] = {
+	/* PSP variant for packet where SRH with SL = 1 */
+	tbl_cfg(PSP, SL_ONE, F_PSP),
+	/* End for packet where the SRH with SL > 1*/
+	tbl_cfg(END, SL_MORE, F_PSP),
+};
+
+#undef F_PSP
+#undef tbl_cfg
+
+/* For each flavor defined in RFC8986 (or a combination of them) an action is
+ * performed on the packet. The specific action depends on:
+ *  - info extracted from the packet (i.e. pktinfo data) regarding the
+ *    lack/presence of the SRH, and if the SRH is available, on the value of
+ *    Segment Left field;
+ *  - the mask of flavors configured for the specific SRv6 End* behavior.
+ *
+ * The function combines both the pkinfo and the flavors mask to evaluate the
+ * corresponding action to be taken on the packet.
+ */
+static enum seg6_local_flv_action
+seg6_local_flv8986_act_lookup(enum seg6_local_pktinfo pinfo, __u32 flvmask)
+{
+	unsigned long index;
+
+	/* check if the provided mask of flavors is supported */
+	if (unlikely(flvmask & ~SEG6_LOCAL_FLV8986_SUPP_OPS))
+		return SEG6_LOCAL_FLV_ACT_UNSPEC;
+
+	index = flv8986_act_tbl_idx(pinfo, flvmask);
+	if (unlikely(index >= FLV8986_ACT_TBL_SIZE))
+		return SEG6_LOCAL_FLV_ACT_UNSPEC;
+
+	return flv8986_act_tbl[index];
+}
+
+/* skb->data must be aligned with skb->network_header */
+static bool seg6_pop_srh(struct sk_buff *skb, int srhoff)
+{
+	struct ipv6_sr_hdr *srh;
+	struct ipv6hdr *iph;
+	__u8 srh_nexthdr;
+	int thoff = -1;
+	int srhlen;
+	int nhlen;
+
+	if (unlikely(srhoff < sizeof(*iph) ||
+		     !pskb_may_pull(skb, srhoff + sizeof(*srh))))
+		return false;
+
+	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
+	srhlen = ipv6_optlen(srh);
+
+	/* we are about to mangle the pkt, let's check if we can write on it */
+	if (unlikely(skb_ensure_writable(skb, srhoff + srhlen)))
+		return false;
+
+	/* skb_ensure_writable() may change skb pointers; evaluate srh again */
+	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
+	srh_nexthdr = srh->nexthdr;
+
+	if (unlikely(!skb_transport_header_was_set(skb)))
+		goto pull;
+
+	nhlen = skb_network_header_len(skb);
+	/* we have to deal with the transport header: it could be set before
+	 * the SRH, after the SRH, or within it (which is considered wrong,
+	 * however).
+	 */
+	if (likely(nhlen <= srhoff))
+		thoff = nhlen;
+	else if (nhlen >= srhoff + srhlen)
+		/* transport_header is set after the SRH */
+		thoff = nhlen - srhlen;
+	else
+		/* transport_header falls inside the SRH; hence, we can't
+		 * restore the transport_header pointer properly after
+		 * SRH removing operation.
+		 */
+		return false;
+pull:
+	/* we need to pop the SRH:
+	 *  1) first of all, we pull out everything from IPv6 header up to SRH
+	 *     (included) evaluating also the rcsum;
+	 *  2) we overwrite (and then remove) the SRH by properly moving the
+	 *     IPv6 along with any extension header that precedes the SRH;
+	 *  3) At the end, we push back the pulled headers (except for SRH,
+	 *     obviously).
+	 */
+	skb_pull_rcsum(skb, srhoff + srhlen);
+	memmove(skb_network_header(skb) + srhlen, skb_network_header(skb),
+		srhoff);
+	skb_push(skb, srhoff);
+
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+	if (likely(thoff >= 0))
+		skb_set_transport_header(skb, thoff);
+
+	iph = ipv6_hdr(skb);
+	if (iph->nexthdr == NEXTHDR_ROUTING) {
+		iph->nexthdr = srh_nexthdr;
+	} else {
+		/* we must look for the extension header (EXTH, for short) that
+		 * immediately precedes the SRH we have just removed.
+		 * Then, we update the value of the EXTH nexthdr with the one
+		 * contained in the SRH nexthdr.
+		 */
+		unsigned int off = sizeof(*iph);
+		struct ipv6_opt_hdr *hp, _hdr;
+		__u8 nexthdr = iph->nexthdr;
+
+		for (;;) {
+			if (unlikely(!ipv6_ext_hdr(nexthdr) ||
+				     nexthdr == NEXTHDR_NONE))
+				return false;
+
+			hp = skb_header_pointer(skb, off, sizeof(_hdr), &_hdr);
+			if (unlikely(!hp))
+				return false;
+
+			if (hp->nexthdr == NEXTHDR_ROUTING) {
+				hp->nexthdr = srh_nexthdr;
+				break;
+			}
+
+			switch (nexthdr) {
+			case NEXTHDR_FRAGMENT:
+				fallthrough;
+			case NEXTHDR_AUTH:
+				/* we expect SRH before FRAG and AUTH */
+				return false;
+			default:
+				off += ipv6_optlen(hp);
+				break;
+			}
+
+			nexthdr = hp->nexthdr;
+		}
+	}
+
+	iph->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
+
+	skb_postpush_rcsum(skb, iph, srhoff);
+
+	return true;
+}
+
+/* process the packet on the basis of the RFC8986 flavors set for the given
+ * SRv6 End behavior instance.
+ */
+static int end_flv8986_core(struct sk_buff *skb, struct seg6_local_lwt *slwt)
+{
+	const struct seg6_flavors_info *finfo = &slwt->flv_info;
+	enum seg6_local_flv_action action;
+	enum seg6_local_pktinfo pinfo;
+	struct ipv6_sr_hdr *srh;
+	__u32 flvmask;
+	int srhoff;
+
+	srh = seg6_get_srh(skb, 0);
+	srhoff = srh ? ((unsigned char *)srh - skb->data) : 0;
+	pinfo = seg6_get_srh_pktinfo(srh);
+#ifdef CONFIG_IPV6_SEG6_HMAC
+	if (srh && !seg6_hmac_validate_skb(skb))
+		goto drop;
+#endif
+	flvmask = finfo->flv_ops;
+	if (unlikely(flvmask & ~SEG6_LOCAL_FLV8986_SUPP_OPS)) {
+		pr_warn_once("seg6local: invalid RFC8986 flavors\n");
+		goto drop;
+	}
+
+	/* retrieve the action triggered by the combination of pktinfo data and
+	 * the flavors mask.
+	 */
+	action = seg6_local_flv8986_act_lookup(pinfo, flvmask);
+	switch (action) {
+	case SEG6_LOCAL_FLV_ACT_END:
+		/* process the packet as the "standard" End behavior */
+		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+		break;
+	case SEG6_LOCAL_FLV_ACT_PSP:
+		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+
+		if (unlikely(!seg6_pop_srh(skb, srhoff)))
+			goto drop;
+		break;
+	case SEG6_LOCAL_FLV_ACT_UNSPEC:
+		fallthrough;
+	default:
+		/* by default, we drop the packet since we could not find a
+		 * suitable action.
+		 */
+		goto drop;
+	}
+
+	return input_action_end_finish(skb, slwt);
+
+drop:
+	kfree_skb(skb);
+	return -EINVAL;
+}
+
 /* regular endpoint function */
 static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
 	const struct seg6_flavors_info *finfo = &slwt->flv_info;
+	__u32 fops = finfo->flv_ops;
 
-	if (seg6_next_csid_enabled(finfo->flv_ops))
+	if (!fops)
+		return input_action_end_core(skb, slwt);
+
+	/* check for the presence of NEXT-C-SID since it applies first */
+	if (seg6_next_csid_enabled(fops))
 		return end_next_csid_core(skb, slwt);
 
-	return input_action_end_core(skb, slwt);
+	/* the specific processing function to be performed on the packet
+	 * depends on the combination of flavors defined in RFC8986 and some
+	 * information extracted from the packet, e.g. presence/absence of SRH,
+	 * Segment Left = 0, etc.
+	 */
+	return end_flv8986_core(skb, slwt);
 }
 
 /* regular endpoint, and forward to specified nexthop */
@@ -2304,6 +2627,13 @@ int __init seg6_local_init(void)
 	BUILD_BUG_ON(next_csid_chk_lcblock_bits(SEG6_LOCAL_LCBLOCK_DBITS));
 	BUILD_BUG_ON(next_csid_chk_lcnode_fn_bits(SEG6_LOCAL_LCNODE_FN_DBITS));
 
+	/* To be memory efficient, we use 'u8' to represent the different
+	 * actions related to RFC8986 flavors. If the kernel build stops here,
+	 * it means that it is not possible to correctly encode these actions
+	 * with the data type chosen for the action table.
+	 */
+	BUILD_BUG_ON(SEG6_LOCAL_FLV_ACT_MAX > (typeof(flv8986_act_tbl[0]))~0U);
+
 	return lwtunnel_encap_add_ops(&seg6_local_ops,
 				      LWTUNNEL_ENCAP_SEG6_LOCAL);
 }
-- 
2.20.1


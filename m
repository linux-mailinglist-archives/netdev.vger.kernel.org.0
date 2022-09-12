Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B8D5B5FCB
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiILSFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiILSF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:05:29 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662BC2DAB5;
        Mon, 12 Sep 2022 11:05:27 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 28CHGubW031029
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 12 Sep 2022 19:16:57 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next v2 2/3] seg6: add NEXT-C-SID support for SRv6 End behavior
Date:   Mon, 12 Sep 2022 19:16:18 +0200
Message-Id: <20220912171619.16943-3-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220912171619.16943-1-andrea.mayer@uniroma2.it>
References: <20220912171619.16943-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NEXT-C-SID mechanism described in [1] offers the possibility of
encoding several SRv6 segments within a single 128 bit SID address. Such
a SID address is called a Compressed SID (C-SID) container. In this way,
the length of the SID List can be drastically reduced.

A SID instantiated with the NEXT-C-SID flavor considers an IPv6 address
logically structured in three main blocks: i) Locator-Block; ii)
Locator-Node Function; iii) Argument.

                        C-SID container
+------------------------------------------------------------------+
|     Locator-Block      |Loc-Node|            Argument            |
|                        |Function|                                |
+------------------------------------------------------------------+
<--------- B -----------> <- NF -> <------------- A --------------->

   (i) The Locator-Block can be any IPv6 prefix available to the provider;

  (ii) The Locator-Node Function represents the node and the function to
       be triggered when a packet is received on the node;

 (iii) The Argument carries the remaining C-SIDs in the current C-SID
       container.

The NEXT-C-SID mechanism relies on the "flavors" framework defined in
[2]. The flavors represent additional operations that can modify or
extend a subset of the existing behaviors.

This patch introduces the support for flavors in SRv6 End behavior
implementing the NEXT-C-SID one. An SRv6 End behavior with NEXT-C-SID
flavor works as an End behavior but it is capable of processing the
compressed SID List encoded in C-SID containers.

An SRv6 End behavior with NEXT-C-SID flavor can be configured to support
user-provided Locator-Block and Locator-Node Function lengths. In this
implementation, such lengths must be evenly divisible by 8 (i.e. must be
byte-aligned), otherwise the kernel informs the user about invalid
values with a meaningful error code and message through netlink_ext_ack.

If Locator-Block and/or Locator-Node Function lengths are not provided
by the user during configuration of an SRv6 End behavior instance with
NEXT-C-SID flavor, the kernel will choose their default values i.e.,
32-bit Locator-Block and 16-bit Locator-Node Function.

[1] - https://datatracker.ietf.org/doc/html/draft-ietf-spring-srv6-srh-compression
[2] - https://datatracker.ietf.org/doc/html/rfc8986

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 include/uapi/linux/seg6_local.h |  24 +++
 net/ipv6/seg6_local.c           | 335 +++++++++++++++++++++++++++++++-
 2 files changed, 356 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
index 332b18f318f8..4fdc424c9cb3 100644
--- a/include/uapi/linux/seg6_local.h
+++ b/include/uapi/linux/seg6_local.h
@@ -28,6 +28,7 @@ enum {
 	SEG6_LOCAL_BPF,
 	SEG6_LOCAL_VRFTABLE,
 	SEG6_LOCAL_COUNTERS,
+	SEG6_LOCAL_FLAVORS,
 	__SEG6_LOCAL_MAX,
 };
 #define SEG6_LOCAL_MAX (__SEG6_LOCAL_MAX - 1)
@@ -110,4 +111,27 @@ enum {
 
 #define SEG6_LOCAL_CNT_MAX (__SEG6_LOCAL_CNT_MAX - 1)
 
+/* SRv6 End* Flavor attributes */
+enum {
+	SEG6_LOCAL_FLV_UNSPEC,
+	SEG6_LOCAL_FLV_OPERATION,
+	SEG6_LOCAL_FLV_LCBLOCK_BITS,
+	SEG6_LOCAL_FLV_LCNODE_FN_BITS,
+	__SEG6_LOCAL_FLV_MAX,
+};
+
+#define SEG6_LOCAL_FLV_MAX (__SEG6_LOCAL_FLV_MAX - 1)
+
+/* Designed flavor operations for SRv6 End* Behavior */
+enum {
+	SEG6_LOCAL_FLV_OP_UNSPEC,
+	SEG6_LOCAL_FLV_OP_PSP,
+	SEG6_LOCAL_FLV_OP_USP,
+	SEG6_LOCAL_FLV_OP_USD,
+	SEG6_LOCAL_FLV_OP_NEXT_CSID,
+	__SEG6_LOCAL_FLV_OP_MAX
+};
+
+#define SEG6_LOCAL_FLV_OP_MAX (__SEG6_LOCAL_FLV_OP_MAX - 1)
+
 #endif
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index f43e6f0baac1..8370726ae7bf 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -73,6 +73,55 @@ struct bpf_lwt_prog {
 	char *name;
 };
 
+/* default length values (expressed in bits) for both Locator-Block and
+ * Locator-Node Function.
+ *
+ * Both SEG6_LOCAL_LCBLOCK_DBITS and SEG6_LOCAL_LCNODE_FN_DBITS *must* be:
+ *    i) greater than 0;
+ *   ii) evenly divisible by 8. In other terms, the lengths of the
+ *	 Locator-Block and Locator-Node Function must be byte-aligned (we can
+ *	 relax this constraint in the future if really needed).
+ *
+ * Moreover, a third condition must hold:
+ *  iii) SEG6_LOCAL_LCBLOCK_DBITS + SEG6_LOCAL_LCNODE_FN_DBITS <= 128.
+ *
+ * The correctness of SEG6_LOCAL_LCBLOCK_DBITS and SEG6_LOCAL_LCNODE_FN_DBITS
+ * values are checked during the kernel compilation. If the compilation stops,
+ * check the value of these parameters to see if they meet conditions (i), (ii)
+ * and (iii).
+ */
+#define SEG6_LOCAL_LCBLOCK_DBITS	32
+#define SEG6_LOCAL_LCNODE_FN_DBITS	16
+
+/* The following next_csid_chk_{cntr,lcblock,lcblock_fn}_bits macros can be
+ * used directly to check whether the lengths (in bits) of Locator-Block and
+ * Locator-Node Function are valid according to (i), (ii), (iii).
+ */
+#define next_csid_chk_cntr_bits(blen, flen)		\
+	((blen) + (flen) > 128)
+
+#define next_csid_chk_lcblock_bits(blen)		\
+({							\
+	typeof(blen) __tmp = blen;			\
+	(!__tmp || __tmp > 120 || (__tmp & 0x07));	\
+})
+
+#define next_csid_chk_lcnode_fn_bits(flen)		\
+	next_csid_chk_lcblock_bits(flen)
+
+/* Supported Flavor operations are reported in this bitmask */
+#define SEG6_LOCAL_FLV_SUPP_OPS	(BIT(SEG6_LOCAL_FLV_OP_NEXT_CSID))
+
+struct seg6_flavors_info {
+	/* Flavor operations */
+	__u32 flv_ops;
+
+	/* Locator-Block length, expressed in bits */
+	__u8 lcblock_bits;
+	/* Locator-Node Function length, expressed in bits*/
+	__u8 lcnode_func_bits;
+};
+
 enum seg6_end_dt_mode {
 	DT_INVALID_MODE	= -EINVAL,
 	DT_LEGACY_MODE	= 0,
@@ -136,6 +185,8 @@ struct seg6_local_lwt {
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	struct seg6_end_dt_info dt_info;
 #endif
+	struct seg6_flavors_info flv_info;
+
 	struct pcpu_seg6_local_counters __percpu *pcpu_counters;
 
 	int headroom;
@@ -271,8 +322,50 @@ int seg6_lookup_nexthop(struct sk_buff *skb,
 	return seg6_lookup_any_nexthop(skb, nhaddr, tbl_id, false);
 }
 
-/* regular endpoint function */
-static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
+static __u8 seg6_flv_lcblock_octects(const struct seg6_flavors_info *finfo)
+{
+	return finfo->lcblock_bits >> 3;
+}
+
+static __u8 seg6_flv_lcnode_func_octects(const struct seg6_flavors_info *finfo)
+{
+	return finfo->lcnode_func_bits >> 3;
+}
+
+static bool seg6_next_csid_is_arg_zero(const struct in6_addr *addr,
+				       const struct seg6_flavors_info *finfo)
+{
+	__u8 fnc_octects = seg6_flv_lcnode_func_octects(finfo);
+	__u8 blk_octects = seg6_flv_lcblock_octects(finfo);
+	__u8 arg_octects;
+	int i;
+
+	arg_octects = 16 - blk_octects - fnc_octects;
+	for (i = 0; i < arg_octects; ++i) {
+		if (addr->s6_addr[blk_octects + fnc_octects + i] != 0x00)
+			return false;
+	}
+
+	return true;
+}
+
+/* assume that DA.Argument length > 0 */
+static void seg6_next_csid_advance_arg(struct in6_addr *addr,
+				       const struct seg6_flavors_info *finfo)
+{
+	__u8 fnc_octects = seg6_flv_lcnode_func_octects(finfo);
+	__u8 blk_octects = seg6_flv_lcblock_octects(finfo);
+
+	/* advance DA.Argument */
+	memmove(&addr->s6_addr[blk_octects],
+		&addr->s6_addr[blk_octects + fnc_octects],
+		16 - blk_octects - fnc_octects);
+
+	memset(&addr->s6_addr[16 - fnc_octects], 0x00, fnc_octects);
+}
+
+static int input_action_end_core(struct sk_buff *skb,
+				 struct seg6_local_lwt *slwt)
 {
 	struct ipv6_sr_hdr *srh;
 
@@ -291,6 +384,38 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	return -EINVAL;
 }
 
+static int end_next_csid_core(struct sk_buff *skb, struct seg6_local_lwt *slwt)
+{
+	const struct seg6_flavors_info *finfo = &slwt->flv_info;
+	struct in6_addr *daddr = &ipv6_hdr(skb)->daddr;
+
+	if (seg6_next_csid_is_arg_zero(daddr, finfo))
+		return input_action_end_core(skb, slwt);
+
+	/* update DA */
+	seg6_next_csid_advance_arg(daddr, finfo);
+
+	seg6_lookup_nexthop(skb, NULL, 0);
+
+	return dst_input(skb);
+}
+
+static bool seg6_next_csid_enabled(__u32 fops)
+{
+	return fops & BIT(SEG6_LOCAL_FLV_OP_NEXT_CSID);
+}
+
+/* regular endpoint function */
+static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
+{
+	const struct seg6_flavors_info *finfo = &slwt->flv_info;
+
+	if (seg6_next_csid_enabled(finfo->flv_ops))
+		return end_next_csid_core(skb, slwt);
+
+	return input_action_end_core(skb, slwt);
+}
+
 /* regular endpoint, and forward to specified nexthop */
 static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
@@ -951,7 +1076,8 @@ static struct seg6_action_desc seg6_action_table[] = {
 	{
 		.action		= SEG6_LOCAL_ACTION_END,
 		.attrs		= 0,
-		.optattrs	= SEG6_F_LOCAL_COUNTERS,
+		.optattrs	= SEG6_F_LOCAL_COUNTERS |
+				  SEG6_F_ATTR(SEG6_LOCAL_FLAVORS),
 		.input		= input_action_end,
 	},
 	{
@@ -1132,6 +1258,7 @@ static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
 	[SEG6_LOCAL_OIF]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_BPF]	= { .type = NLA_NESTED },
 	[SEG6_LOCAL_COUNTERS]	= { .type = NLA_NESTED },
+	[SEG6_LOCAL_FLAVORS]	= { .type = NLA_NESTED },
 };
 
 static int parse_nla_srh(struct nlattr **attrs, struct seg6_local_lwt *slwt,
@@ -1551,6 +1678,192 @@ static void destroy_attr_counters(struct seg6_local_lwt *slwt)
 	free_percpu(slwt->pcpu_counters);
 }
 
+static const
+struct nla_policy seg6_local_flavors_policy[SEG6_LOCAL_FLV_MAX + 1] = {
+	[SEG6_LOCAL_FLV_OPERATION]	= { .type = NLA_U32 },
+	[SEG6_LOCAL_FLV_LCBLOCK_BITS]	= { .type = NLA_U8 },
+	[SEG6_LOCAL_FLV_LCNODE_FN_BITS]	= { .type = NLA_U8 },
+};
+
+/* check whether the lengths of the Locator-Block and Locator-Node Function
+ * are compatible with the dimension of a C-SID container.
+ */
+static int seg6_chk_next_csid_cfg(__u8 block_len, __u8 func_len)
+{
+	/* Locator-Block and Locator-Node Function cannot exceed 128 bits
+	 * (i.e. C-SID container lenghts).
+	 */
+	if (next_csid_chk_cntr_bits(block_len, func_len))
+		return -EINVAL;
+
+	/* Locator-Block length must be greater than zero and evenly divisible
+	 * by 8. There must be room for a Locator-Node Function, at least.
+	 */
+	if (next_csid_chk_lcblock_bits(block_len))
+		return -EINVAL;
+
+	/* Locator-Node Function length must be greater than zero and evenly
+	 * divisible by 8. There must be room for the Locator-Block.
+	 */
+	if (next_csid_chk_lcnode_fn_bits(func_len))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int seg6_parse_nla_next_csid_cfg(struct nlattr **tb,
+					struct seg6_flavors_info *finfo,
+					struct netlink_ext_ack *extack)
+{
+	__u8 func_len = SEG6_LOCAL_LCNODE_FN_DBITS;
+	__u8 block_len = SEG6_LOCAL_LCBLOCK_DBITS;
+	int rc;
+
+	if (tb[SEG6_LOCAL_FLV_LCBLOCK_BITS])
+		block_len = nla_get_u8(tb[SEG6_LOCAL_FLV_LCBLOCK_BITS]);
+
+	if (tb[SEG6_LOCAL_FLV_LCNODE_FN_BITS])
+		func_len = nla_get_u8(tb[SEG6_LOCAL_FLV_LCNODE_FN_BITS]);
+
+	rc = seg6_chk_next_csid_cfg(block_len, func_len);
+	if (rc < 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Invalid Locator Block/Node Function lengths");
+		return rc;
+	}
+
+	finfo->lcblock_bits = block_len;
+	finfo->lcnode_func_bits = func_len;
+
+	return 0;
+}
+
+static int parse_nla_flavors(struct nlattr **attrs, struct seg6_local_lwt *slwt,
+			     struct netlink_ext_ack *extack)
+{
+	struct seg6_flavors_info *finfo = &slwt->flv_info;
+	struct nlattr *tb[SEG6_LOCAL_FLV_MAX + 1];
+	unsigned long fops;
+	int rc;
+
+	rc = nla_parse_nested_deprecated(tb, SEG6_LOCAL_FLV_MAX,
+					 attrs[SEG6_LOCAL_FLAVORS],
+					 seg6_local_flavors_policy, NULL);
+	if (rc < 0)
+		return rc;
+
+	/* this attribute MUST always be present since it represents the Flavor
+	 * operation(s) to be carried out.
+	 */
+	if (!tb[SEG6_LOCAL_FLV_OPERATION])
+		return -EINVAL;
+
+	fops = nla_get_u32(tb[SEG6_LOCAL_FLV_OPERATION]);
+	if (fops & ~SEG6_LOCAL_FLV_SUPP_OPS) {
+		NL_SET_ERR_MSG(extack, "Unsupported Flavor operation(s)");
+		return -EOPNOTSUPP;
+	}
+
+	finfo->flv_ops = fops;
+
+	if (seg6_next_csid_enabled(fops)) {
+		/* Locator-Block and Locator-Node Function lengths can be
+		 * provided by the user space. Otherwise, default values are
+		 * applied.
+		 */
+		rc = seg6_parse_nla_next_csid_cfg(tb, finfo, extack);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
+
+static int seg6_fill_nla_next_csid_cfg(struct sk_buff *skb,
+				       struct seg6_flavors_info *finfo)
+{
+	if (nla_put_u8(skb, SEG6_LOCAL_FLV_LCBLOCK_BITS, finfo->lcblock_bits))
+		return -EMSGSIZE;
+
+	if (nla_put_u8(skb, SEG6_LOCAL_FLV_LCNODE_FN_BITS,
+		       finfo->lcnode_func_bits))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int put_nla_flavors(struct sk_buff *skb, struct seg6_local_lwt *slwt)
+{
+	struct seg6_flavors_info *finfo = &slwt->flv_info;
+	__u32 fops = finfo->flv_ops;
+	struct nlattr *nest;
+	int rc;
+
+	nest = nla_nest_start(skb, SEG6_LOCAL_FLAVORS);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, SEG6_LOCAL_FLV_OPERATION, fops)) {
+		rc = -EMSGSIZE;
+		goto err;
+	}
+
+	if (seg6_next_csid_enabled(fops)) {
+		rc = seg6_fill_nla_next_csid_cfg(skb, finfo);
+		if (rc < 0)
+			goto err;
+	}
+
+	return nla_nest_end(skb, nest);
+
+err:
+	nla_nest_cancel(skb, nest);
+	return rc;
+}
+
+static int seg6_cmp_nla_next_csid_cfg(struct seg6_flavors_info *finfo_a,
+				      struct seg6_flavors_info *finfo_b)
+{
+	if (finfo_a->lcblock_bits != finfo_b->lcblock_bits)
+		return 1;
+
+	if (finfo_a->lcnode_func_bits != finfo_b->lcnode_func_bits)
+		return 1;
+
+	return 0;
+}
+
+static int cmp_nla_flavors(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
+{
+	struct seg6_flavors_info *finfo_a = &a->flv_info;
+	struct seg6_flavors_info *finfo_b = &b->flv_info;
+
+	if (finfo_a->flv_ops != finfo_b->flv_ops)
+		return 1;
+
+	if (seg6_next_csid_enabled(finfo_a->flv_ops)) {
+		if (seg6_cmp_nla_next_csid_cfg(finfo_a, finfo_b))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int encap_size_flavors(struct seg6_local_lwt *slwt)
+{
+	struct seg6_flavors_info *finfo = &slwt->flv_info;
+	int nlsize;
+
+	nlsize = nla_total_size(0) +	/* nest SEG6_LOCAL_FLAVORS */
+		 nla_total_size(4);	/* SEG6_LOCAL_FLV_OPERATION */
+
+	if (seg6_next_csid_enabled(finfo->flv_ops))
+		nlsize += nla_total_size(1) + /* SEG6_LOCAL_FLV_LCBLOCK_BITS */
+			  nla_total_size(1); /* SEG6_LOCAL_FLV_LCNODE_FN_BITS */
+
+	return nlsize;
+}
+
 struct seg6_action_param {
 	int (*parse)(struct nlattr **attrs, struct seg6_local_lwt *slwt,
 		     struct netlink_ext_ack *extack);
@@ -1603,6 +1916,10 @@ static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
 				    .put = put_nla_counters,
 				    .cmp = cmp_nla_counters,
 				    .destroy = destroy_attr_counters },
+
+	[SEG6_LOCAL_FLAVORS]	= { .parse = parse_nla_flavors,
+				    .put = put_nla_flavors,
+				    .cmp = cmp_nla_flavors },
 };
 
 /* call the destroy() callback (if available) for each set attribute in
@@ -1916,6 +2233,9 @@ static int seg6_local_get_encap_size(struct lwtunnel_state *lwt)
 			  /* SEG6_LOCAL_CNT_ERRORS */
 			  nla_total_size_64bit(sizeof(__u64));
 
+	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_FLAVORS))
+		nlsize += encap_size_flavors(slwt);
+
 	return nlsize;
 }
 
@@ -1971,6 +2291,15 @@ int __init seg6_local_init(void)
 	 */
 	BUILD_BUG_ON(SEG6_LOCAL_MAX + 1 > BITS_PER_TYPE(unsigned long));
 
+	/* If the default NEXT-C-SID Locator-Block/Node Function lengths (in
+	 * bits) have been changed with invalid values, kernel build stops
+	 * here.
+	 */
+	BUILD_BUG_ON(next_csid_chk_cntr_bits(SEG6_LOCAL_LCBLOCK_DBITS,
+					     SEG6_LOCAL_LCNODE_FN_DBITS));
+	BUILD_BUG_ON(next_csid_chk_lcblock_bits(SEG6_LOCAL_LCBLOCK_DBITS));
+	BUILD_BUG_ON(next_csid_chk_lcnode_fn_bits(SEG6_LOCAL_LCNODE_FN_DBITS));
+
 	return lwtunnel_encap_add_ops(&seg6_local_ops,
 				      LWTUNNEL_ENCAP_SEG6_LOCAL);
 }
-- 
2.20.1


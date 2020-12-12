Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00842D83B6
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 02:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437954AbgLLBDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 20:03:31 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:38082 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbgLLBDD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 20:03:03 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0BC10qke023115
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 12 Dec 2020 02:00:53 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Lebrun <david.lebrun@uclouvain.be>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [PATCH net-next] seg6: fix the max number of supported SRv6 behavior attributes
Date:   Sat, 12 Dec 2020 02:00:05 +0100
Message-Id: <20201212010005.7338-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The set of required attributes for a given SRv6 behavior is identified
using a bitmap stored in an unsigned long, since the initial design of
SRv6 networking in Linux. Recently the same approach has been used for
identifying the optional attributes.

We realized that choosing an unsigned long to store a bitmap is not a
proper design choice considering that new attributes can be defined in the
future. The problem is that the size of an unsigned long can be 32 or 64
bits depending on the architecture. Therefore the maximum number of
attributes that can be defined currently is 32 or 64 depending on the
architecture. This issue has not caused any harm so far, because new
attributes are defined statically in the kernel code, and currently only 10
attributes have been defined.

With this patch, we set the maximum number of attributes that can be
supported by the SRv6 networking in Linux to be 64 regardless of the
architecture.

We changed the unsigned long type of the bitmaps to the u64 type and
adapted the code accordingly. In particular:

 - We replaced all patterns (1 << i) with the macro SEG6_F_ATTR(i) in order
   to address overflow issues caused by 32-bit signed arithmetic.

   Many thanks to Colin Ian King for catching the overflow problem and
   inspiring this patch;

 - At compile time we verify that the total number of attributes does not
   exceed the fixed value of 64. Otherwise, kernel build fails forcing
   developers to reconsider adding a new attribute or extending the
   total number of supported attributes by the SRv6 networking.

Fixes: d1df6fd8a1d2 ("ipv6: sr: define core operations for seg6local lightweight tunnel")
Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")
Fixes: 891ef8dd2a8d ("ipv6: sr: implement additional seg6local actions")
Fixes: 004d4b274e2a ("ipv6: sr: Add seg6local action End.BPF")
Fixes: 964adce526a4 ("seg6: improve management of behavior attributes")
Fixes: 0a3021f1d4e5 ("seg6: add support for optional attributes in SRv6 behaviors")
Fixes: 664d6f86868b ("seg6: add support for the SRv6 End.DT4 behavior")
Fixes: 20a081b7984c ("seg6: add VRF support for SRv6 End.DT6 behavior")
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 include/uapi/linux/seg6_local.h | 10 ++++
 net/ipv6/seg6_local.c           | 89 ++++++++++++++++++---------------
 2 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
index 3b39ef1dbb46..81b3ac430670 100644
--- a/include/uapi/linux/seg6_local.h
+++ b/include/uapi/linux/seg6_local.h
@@ -27,9 +27,19 @@ enum {
 	SEG6_LOCAL_OIF,
 	SEG6_LOCAL_BPF,
 	SEG6_LOCAL_VRFTABLE,
+	/* new attributes go here */
 	__SEG6_LOCAL_MAX,
+
+	/* Support up to 64 different types of attributes.
+	 *
+	 * If you need to add a new attribute, please make sure that it DOES
+	 * NOT violate the constraint of having a maximum of 64 possible
+	 * attributes.
+	 */
+	__SEG6_LOCAL_MAX_SUPP = 64,
 };
 #define SEG6_LOCAL_MAX (__SEG6_LOCAL_MAX - 1)
+#define SEG6_LOCAL_MAX_SUPP (__SEG6_LOCAL_MAX_SUPP)
 
 enum {
 	SEG6_LOCAL_ACTION_UNSPEC	= 0,
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index b07f7c1c82a4..4e657c48e24d 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -31,6 +31,8 @@
 #include <linux/etherdevice.h>
 #include <linux/bpf.h>
 
+#define SEG6_F_ATTR(i) (((u64)1) << (i))
+
 struct seg6_local_lwt;
 
 /* callbacks used for customizing the creation and destruction of a behavior */
@@ -42,7 +44,7 @@ struct seg6_local_lwtunnel_ops {
 
 struct seg6_action_desc {
 	int action;
-	unsigned long attrs;
+	u64 attrs;
 
 	/* The optattrs field is used for specifying all the optional
 	 * attributes supported by a specific behavior.
@@ -56,7 +58,7 @@ struct seg6_action_desc {
 	 * required the same attribute CANNOT be set as optional and vice
 	 * versa.
 	 */
-	unsigned long optattrs;
+	u64 optattrs;
 
 	int (*input)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
 	int static_headroom;
@@ -109,7 +111,7 @@ struct seg6_local_lwt {
 	/* unlike the required attrs, we have to track the optional attributes
 	 * that have been effectively parsed.
 	 */
-	unsigned long parsed_optattrs;
+	u64 parsed_optattrs;
 };
 
 static struct seg6_local_lwt *seg6_local_lwtunnel(struct lwtunnel_state *lwt)
@@ -657,11 +659,11 @@ static int seg6_end_dt4_build(struct seg6_local_lwt *slwt, const void *cfg,
 static enum
 seg6_end_dt_mode seg6_end_dt6_parse_mode(struct seg6_local_lwt *slwt)
 {
-	unsigned long parsed_optattrs = slwt->parsed_optattrs;
+	u64 parsed_optattrs = slwt->parsed_optattrs;
 	bool legacy, vrfmode;
 
-	legacy	= !!(parsed_optattrs & (1 << SEG6_LOCAL_TABLE));
-	vrfmode	= !!(parsed_optattrs & (1 << SEG6_LOCAL_VRFTABLE));
+	legacy	= !!(parsed_optattrs & SEG6_F_ATTR(SEG6_LOCAL_TABLE));
+	vrfmode	= !!(parsed_optattrs & SEG6_F_ATTR(SEG6_LOCAL_VRFTABLE));
 
 	if (!(legacy ^ vrfmode))
 		/* both are absent or present: invalid DT6 mode */
@@ -883,32 +885,32 @@ static struct seg6_action_desc seg6_action_table[] = {
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_X,
-		.attrs		= (1 << SEG6_LOCAL_NH6),
+		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_NH6),
 		.input		= input_action_end_x,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_T,
-		.attrs		= (1 << SEG6_LOCAL_TABLE),
+		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_TABLE),
 		.input		= input_action_end_t,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DX2,
-		.attrs		= (1 << SEG6_LOCAL_OIF),
+		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_OIF),
 		.input		= input_action_end_dx2,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DX6,
-		.attrs		= (1 << SEG6_LOCAL_NH6),
+		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_NH6),
 		.input		= input_action_end_dx6,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DX4,
-		.attrs		= (1 << SEG6_LOCAL_NH4),
+		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_NH4),
 		.input		= input_action_end_dx4,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DT4,
-		.attrs		= (1 << SEG6_LOCAL_VRFTABLE),
+		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_VRFTABLE),
 #ifdef CONFIG_NET_L3_MASTER_DEV
 		.input		= input_action_end_dt4,
 		.slwt_ops	= {
@@ -920,30 +922,30 @@ static struct seg6_action_desc seg6_action_table[] = {
 		.action		= SEG6_LOCAL_ACTION_END_DT6,
 #ifdef CONFIG_NET_L3_MASTER_DEV
 		.attrs		= 0,
-		.optattrs	= (1 << SEG6_LOCAL_TABLE) |
-				  (1 << SEG6_LOCAL_VRFTABLE),
+		.optattrs	= SEG6_F_ATTR(SEG6_LOCAL_TABLE) |
+				  SEG6_F_ATTR(SEG6_LOCAL_VRFTABLE),
 		.slwt_ops	= {
 					.build_state = seg6_end_dt6_build,
 				  },
 #else
-		.attrs		= (1 << SEG6_LOCAL_TABLE),
+		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_TABLE),
 #endif
 		.input		= input_action_end_dt6,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_B6,
-		.attrs		= (1 << SEG6_LOCAL_SRH),
+		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_SRH),
 		.input		= input_action_end_b6,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_B6_ENCAP,
-		.attrs		= (1 << SEG6_LOCAL_SRH),
+		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_SRH),
 		.input		= input_action_end_b6_encap,
 		.static_headroom	= sizeof(struct ipv6hdr),
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_BPF,
-		.attrs		= (1 << SEG6_LOCAL_BPF),
+		.attrs		= SEG6_F_ATTR(SEG6_LOCAL_BPF),
 		.input		= input_action_end_bpf,
 	},
 
@@ -1350,7 +1352,7 @@ static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
  * @parsed_attrs, starting from the first attribute up to the @max_parsed
  * (excluded) attribute.
  */
-static void __destroy_attrs(unsigned long parsed_attrs, int max_parsed,
+static void __destroy_attrs(u64 parsed_attrs, int max_parsed,
 			    struct seg6_local_lwt *slwt)
 {
 	struct seg6_action_param *param;
@@ -1366,7 +1368,7 @@ static void __destroy_attrs(unsigned long parsed_attrs, int max_parsed,
 	 * attribute; otherwise, we call the destroy() callback.
 	 */
 	for (i = 0; i < max_parsed; ++i) {
-		if (!(parsed_attrs & (1 << i)))
+		if (!(parsed_attrs & SEG6_F_ATTR(i)))
 			continue;
 
 		param = &seg6_action_params[i];
@@ -1381,7 +1383,7 @@ static void __destroy_attrs(unsigned long parsed_attrs, int max_parsed,
  */
 static void destroy_attrs(struct seg6_local_lwt *slwt)
 {
-	unsigned long attrs = slwt->desc->attrs | slwt->parsed_optattrs;
+	u64 attrs = slwt->desc->attrs | slwt->parsed_optattrs;
 
 	__destroy_attrs(attrs, SEG6_LOCAL_MAX + 1, slwt);
 }
@@ -1390,12 +1392,12 @@ static int parse_nla_optional_attrs(struct nlattr **attrs,
 				    struct seg6_local_lwt *slwt)
 {
 	struct seg6_action_desc *desc = slwt->desc;
-	unsigned long parsed_optattrs = 0;
 	struct seg6_action_param *param;
+	u64 parsed_optattrs = 0;
 	int err, i;
 
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; ++i) {
-		if (!(desc->optattrs & (1 << i)) || !attrs[i])
+		if (!(desc->optattrs & SEG6_F_ATTR(i)) || !attrs[i])
 			continue;
 
 		/* once here, the i-th attribute is provided by the
@@ -1408,7 +1410,7 @@ static int parse_nla_optional_attrs(struct nlattr **attrs,
 			goto parse_optattrs_err;
 
 		/* current attribute has been correctly parsed */
-		parsed_optattrs |= (1 << i);
+		parsed_optattrs |= SEG6_F_ATTR(i);
 	}
 
 	/* store in the tunnel state all the optional attributed successfully
@@ -1460,7 +1462,7 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 {
 	struct seg6_action_param *param;
 	struct seg6_action_desc *desc;
-	unsigned long invalid_attrs;
+	u64 invalid_attrs;
 	int i, err;
 
 	desc = __get_action_desc(slwt->action);
@@ -1494,7 +1496,7 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 
 	/* parse the required attributes */
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
-		if (desc->attrs & (1 << i)) {
+		if (desc->attrs & SEG6_F_ATTR(i)) {
 			if (!attrs[i])
 				return -EINVAL;
 
@@ -1590,8 +1592,8 @@ static int seg6_local_fill_encap(struct sk_buff *skb,
 {
 	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(lwt);
 	struct seg6_action_param *param;
-	unsigned long attrs;
 	int i, err;
+	u64 attrs;
 
 	if (nla_put_u32(skb, SEG6_LOCAL_ACTION, slwt->action))
 		return -EMSGSIZE;
@@ -1599,7 +1601,7 @@ static int seg6_local_fill_encap(struct sk_buff *skb,
 	attrs = slwt->desc->attrs | slwt->parsed_optattrs;
 
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
-		if (attrs & (1 << i)) {
+		if (attrs & SEG6_F_ATTR(i)) {
 			param = &seg6_action_params[i];
 			err = param->put(skb, slwt);
 			if (err < 0)
@@ -1613,37 +1615,37 @@ static int seg6_local_fill_encap(struct sk_buff *skb,
 static int seg6_local_get_encap_size(struct lwtunnel_state *lwt)
 {
 	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(lwt);
-	unsigned long attrs;
 	int nlsize;
+	u64 attrs;
 
 	nlsize = nla_total_size(4); /* action */
 
 	attrs = slwt->desc->attrs | slwt->parsed_optattrs;
 
-	if (attrs & (1 << SEG6_LOCAL_SRH))
+	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_SRH))
 		nlsize += nla_total_size((slwt->srh->hdrlen + 1) << 3);
 
-	if (attrs & (1 << SEG6_LOCAL_TABLE))
+	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_TABLE))
 		nlsize += nla_total_size(4);
 
-	if (attrs & (1 << SEG6_LOCAL_NH4))
+	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_NH4))
 		nlsize += nla_total_size(4);
 
-	if (attrs & (1 << SEG6_LOCAL_NH6))
+	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_NH6))
 		nlsize += nla_total_size(16);
 
-	if (attrs & (1 << SEG6_LOCAL_IIF))
+	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_IIF))
 		nlsize += nla_total_size(4);
 
-	if (attrs & (1 << SEG6_LOCAL_OIF))
+	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_OIF))
 		nlsize += nla_total_size(4);
 
-	if (attrs & (1 << SEG6_LOCAL_BPF))
+	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_BPF))
 		nlsize += nla_total_size(sizeof(struct nlattr)) +
 		       nla_total_size(MAX_PROG_NAME) +
 		       nla_total_size(4);
 
-	if (attrs & (1 << SEG6_LOCAL_VRFTABLE))
+	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_VRFTABLE))
 		nlsize += nla_total_size(4);
 
 	return nlsize;
@@ -1654,7 +1656,7 @@ static int seg6_local_cmp_encap(struct lwtunnel_state *a,
 {
 	struct seg6_local_lwt *slwt_a, *slwt_b;
 	struct seg6_action_param *param;
-	unsigned long attrs_a, attrs_b;
+	u64 attrs_a, attrs_b;
 	int i;
 
 	slwt_a = seg6_local_lwtunnel(a);
@@ -1670,7 +1672,7 @@ static int seg6_local_cmp_encap(struct lwtunnel_state *a,
 		return 1;
 
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
-		if (attrs_a & (1 << i)) {
+		if (attrs_a & SEG6_F_ATTR(i)) {
 			param = &seg6_action_params[i];
 			if (param->cmp(slwt_a, slwt_b))
 				return 1;
@@ -1692,6 +1694,15 @@ static const struct lwtunnel_encap_ops seg6_local_ops = {
 
 int __init seg6_local_init(void)
 {
+	/* If the max total number of defined attributes is reached, then your
+	 * kernel build stops here.
+	 *
+	 * This check is required to avoid arithmetic overflows when processing
+	 * behavior attributes and the maximum number of defined attributes
+	 * exceeds the allowed value.
+	 */
+	BUILD_BUG_ON(SEG6_LOCAL_MAX + 1 > SEG6_LOCAL_MAX_SUPP);
+
 	return lwtunnel_encap_add_ops(&seg6_local_ops,
 				      LWTUNNEL_ENCAP_SEG6_LOCAL);
 }
-- 
2.20.1


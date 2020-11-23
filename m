Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720D92C132B
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgKWSbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 13:31:21 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:41911 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbgKWSa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 13:30:56 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0ANITqgh016939
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Nov 2020 19:29:55 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next v3 3/8] seg6: add support for optional attributes in SRv6 behaviors
Date:   Mon, 23 Nov 2020 19:28:51 +0100
Message-Id: <20201123182857.4640-4-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
References: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this patch, each SRv6 behavior specifies a set of required
attributes that must be provided by the userspace application when such
behavior is going to be instantiated. If at least one of the required
attributes is not provided, the creation of the behavior fails.

The SRv6 behavior framework lacks a way to manage optional attributes.
By definition, an optional attribute for a SRv6 behavior consists of an
attribute which may or may not be provided by the userspace. Therefore,
if an optional attribute is missing (and thus not supplied by the user)
the creation of the behavior goes ahead without any issue.

This patch explicitly differentiates the required attributes from the
optional attributes. In particular, each behavior can declare a set of
required attributes and a set of optional ones.

The semantic of the required attributes remains *totally* unaffected by
this patch. The introduction of the optional attributes does NOT impact
on the backward compatibility of the existing SRv6 behaviors.

It is essential to note that if an (optional or required) attribute is
supplied to a SRv6 behavior which does not expect it, the behavior
simply discards such attribute without generating any error or warning.
This operating mode remained unchanged both before and after the
introduction of the optional attributes extension.

The optional attributes are one of the key components used to implement
the SRv6 End.DT6 behavior based on the Virtual Routing and Forwarding
(VRF) framework. The optional attributes make possible the coexistence
of the already existing SRv6 End.DT6 implementation with the new SRv6
End.DT6 VRF-based implementation without breaking any backward
compatibility. Further details on the SRv6 End.DT6 behavior (VRF mode)
are reported in subsequent patches.

From the userspace point of view, the support for optional attributes DO
NOT require any changes to the userspace applications, i.e: iproute2
unless new attributes (required or optional) are needed.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 120 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 106 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index aef39eab9be2..3b5657c622a0 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -36,6 +36,21 @@ struct seg6_local_lwt;
 struct seg6_action_desc {
 	int action;
 	unsigned long attrs;
+
+	/* The optattrs field is used for specifying all the optional
+	 * attributes supported by a specific behavior.
+	 * It means that if one of these attributes is not provided in the
+	 * netlink message during the behavior creation, no errors will be
+	 * returned to the userspace.
+	 *
+	 * Each attribute can be only of two types (mutually exclusive):
+	 * 1) required or 2) optional.
+	 * Every user MUST obey to this rule! If you set an attribute as
+	 * required the same attribute CANNOT be set as optional and vice
+	 * versa.
+	 */
+	unsigned long optattrs;
+
 	int (*input)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
 	int static_headroom;
 };
@@ -57,6 +72,10 @@ struct seg6_local_lwt {
 
 	int headroom;
 	struct seg6_action_desc *desc;
+	/* unlike the required attrs, we have to track the optional attributes
+	 * that have been effectively parsed.
+	 */
+	unsigned long parsed_optattrs;
 };
 
 static struct seg6_local_lwt *seg6_local_lwtunnel(struct lwtunnel_state *lwt)
@@ -959,26 +978,26 @@ static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
 };
 
 /* call the destroy() callback (if available) for each set attribute in
- * @slwt, starting from the first attribute up to the @max_parsed (excluded)
- * attribute.
+ * @parsed_attrs, starting from the first attribute up to the @max_parsed
+ * (excluded) attribute.
  */
-static void __destroy_attrs(int max_parsed, struct seg6_local_lwt *slwt)
+static void __destroy_attrs(unsigned long parsed_attrs, int max_parsed,
+			    struct seg6_local_lwt *slwt)
 {
-	unsigned long attrs = slwt->desc->attrs;
 	struct seg6_action_param *param;
 	int i;
 
 	/* Every required seg6local attribute is identified by an ID which is
 	 * encoded as a flag (i.e: 1 << ID) in the 'attrs' bitmask;
 	 *
-	 * We scan the 'attrs' bitmask, starting from the first attribute
+	 * We scan the 'parsed_attrs' bitmask, starting from the first attribute
 	 * up to the @max_parsed (excluded) attribute.
 	 * For each set attribute, we retrieve the corresponding destroy()
 	 * callback. If the callback is not available, then we skip to the next
 	 * attribute; otherwise, we call the destroy() callback.
 	 */
 	for (i = 0; i < max_parsed; ++i) {
-		if (!(attrs & (1 << i)))
+		if (!(parsed_attrs & (1 << i)))
 			continue;
 
 		param = &seg6_action_params[i];
@@ -993,13 +1012,54 @@ static void __destroy_attrs(int max_parsed, struct seg6_local_lwt *slwt)
  */
 static void destroy_attrs(struct seg6_local_lwt *slwt)
 {
-	__destroy_attrs(SEG6_LOCAL_MAX + 1, slwt);
+	unsigned long attrs = slwt->desc->attrs | slwt->parsed_optattrs;
+
+	__destroy_attrs(attrs, SEG6_LOCAL_MAX + 1, slwt);
+}
+
+static int parse_nla_optional_attrs(struct nlattr **attrs,
+				    struct seg6_local_lwt *slwt)
+{
+	struct seg6_action_desc *desc = slwt->desc;
+	unsigned long parsed_optattrs = 0;
+	struct seg6_action_param *param;
+	int err, i;
+
+	for (i = 0; i < SEG6_LOCAL_MAX + 1; ++i) {
+		if (!(desc->optattrs & (1 << i)) || !attrs[i])
+			continue;
+
+		/* once here, the i-th attribute is provided by the
+		 * userspace AND it is identified optional as well.
+		 */
+		param = &seg6_action_params[i];
+
+		err = param->parse(attrs, slwt);
+		if (err < 0)
+			goto parse_optattrs_err;
+
+		/* current attribute has been correctly parsed */
+		parsed_optattrs |= (1 << i);
+	}
+
+	/* store in the tunnel state all the optional attributed successfully
+	 * parsed.
+	 */
+	slwt->parsed_optattrs = parsed_optattrs;
+
+	return 0;
+
+parse_optattrs_err:
+	__destroy_attrs(parsed_optattrs, i, slwt);
+
+	return err;
 }
 
 static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 {
 	struct seg6_action_param *param;
 	struct seg6_action_desc *desc;
+	unsigned long invalid_attrs;
 	int i, err;
 
 	desc = __get_action_desc(slwt->action);
@@ -1012,6 +1072,26 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 	slwt->desc = desc;
 	slwt->headroom += desc->static_headroom;
 
+	/* Forcing the desc->optattrs *set* and the desc->attrs *set* to be
+	 * disjoined, this allow us to release acquired resources by optional
+	 * attributes and by required attributes independently from each other
+	 * without any interfarence.
+	 * In other terms, we are sure that we do not release some the acquired
+	 * resources twice.
+	 *
+	 * Note that if an attribute is configured both as required and as
+	 * optional, it means that the user has messed something up in the
+	 * seg6_action_table. Therefore, this check is required for SRv6
+	 * behaviors to work properly.
+	 */
+	invalid_attrs = desc->attrs & desc->optattrs;
+	if (invalid_attrs) {
+		WARN_ONCE(1,
+			  "An attribute cannot be both required AND optional");
+		return -EINVAL;
+	}
+
+	/* parse the required attributes */
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
 		if (desc->attrs & (1 << i)) {
 			if (!attrs[i])
@@ -1021,17 +1101,22 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 
 			err = param->parse(attrs, slwt);
 			if (err < 0)
-				goto parse_err;
+				goto parse_attrs_err;
 		}
 	}
 
+	/* parse the optional attributes, if any */
+	err = parse_nla_optional_attrs(attrs, slwt);
+	if (err < 0)
+		goto parse_attrs_err;
+
 	return 0;
 
-parse_err:
+parse_attrs_err:
 	/* release any resource that may have been acquired during the i-1
 	 * parse() operations.
 	 */
-	__destroy_attrs(i, slwt);
+	__destroy_attrs(desc->attrs, i, slwt);
 
 	return err;
 }
@@ -1096,13 +1181,16 @@ static int seg6_local_fill_encap(struct sk_buff *skb,
 {
 	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(lwt);
 	struct seg6_action_param *param;
+	unsigned long attrs;
 	int i, err;
 
 	if (nla_put_u32(skb, SEG6_LOCAL_ACTION, slwt->action))
 		return -EMSGSIZE;
 
+	attrs = slwt->desc->attrs | slwt->parsed_optattrs;
+
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
-		if (slwt->desc->attrs & (1 << i)) {
+		if (attrs & (1 << i)) {
 			param = &seg6_action_params[i];
 			err = param->put(skb, slwt);
 			if (err < 0)
@@ -1121,7 +1209,7 @@ static int seg6_local_get_encap_size(struct lwtunnel_state *lwt)
 
 	nlsize = nla_total_size(4); /* action */
 
-	attrs = slwt->desc->attrs;
+	attrs = slwt->desc->attrs | slwt->parsed_optattrs;
 
 	if (attrs & (1 << SEG6_LOCAL_SRH))
 		nlsize += nla_total_size((slwt->srh->hdrlen + 1) << 3);
@@ -1154,6 +1242,7 @@ static int seg6_local_cmp_encap(struct lwtunnel_state *a,
 {
 	struct seg6_local_lwt *slwt_a, *slwt_b;
 	struct seg6_action_param *param;
+	unsigned long attrs_a, attrs_b;
 	int i;
 
 	slwt_a = seg6_local_lwtunnel(a);
@@ -1162,11 +1251,14 @@ static int seg6_local_cmp_encap(struct lwtunnel_state *a,
 	if (slwt_a->action != slwt_b->action)
 		return 1;
 
-	if (slwt_a->desc->attrs != slwt_b->desc->attrs)
+	attrs_a = slwt_a->desc->attrs | slwt_a->parsed_optattrs;
+	attrs_b = slwt_b->desc->attrs | slwt_b->parsed_optattrs;
+
+	if (attrs_a != attrs_b)
 		return 1;
 
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
-		if (slwt_a->desc->attrs & (1 << i)) {
+		if (attrs_a & (1 << i)) {
 			param = &seg6_action_params[i];
 			if (param->cmp(slwt_a, slwt_b))
 				return 1;
-- 
2.20.1


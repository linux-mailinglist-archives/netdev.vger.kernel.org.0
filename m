Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F0218BFA1
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 19:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgCSStU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 14:49:20 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:34044 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCSStU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 14:49:20 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2020 14:49:17 EDT
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 02JIcCBo018393
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Mar 2020 19:38:12 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Lebrun <dav.lebrun@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahmed.abdelsalam@gssi.it>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next] seg6: add support for optional attributes during behavior construction
Date:   Thu, 19 Mar 2020 19:36:41 +0100
Message-Id: <20200319183641.29608-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

before this patch, each SRv6 behavior specifies a set of required
attributes that must be provided by the userspace application when the
behavior is created. If an attribute is not supplied, the creation
operation fails.
As a workaround, if an attribute is not needed by a behavior, it requires
to be set by the userspace application to a conventional skip-value. The
kernel side, that processes the creation request of a behavior, reads the
supplied attribute values and checks if it has been set to the
conventional skip-value or not. Hence, each optional attribute must have a
conventional skip-value which is known a priori and shared between
userspace applications and kernel.

Messy code and complicated tricks may arise from this approach.
On the other hand, this patch explicitly differentiates the required
mandatory attributes from the optional ones. Now, each behavior can declare
a set of required attributes and a set of optional ones. The behavior
creation fails in case a required attribute is missing, while it goes on
without generating any issue if an optional attribute is not supplied by
the userspace application.

To properly combine the required and optional attributes, a new callback
function called destroy() is used for releasing resources that have been
acquired, during the parse() operation, by a given attribute.
However, the destroy() function is optional and if an attribute does not
require resources that have to be later released, the callback can be
omitted.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Acked-by: Paolo Lungaroni <paolo.lungaroni@cnit.it>
---
 net/ipv6/seg6_local.c | 217 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 189 insertions(+), 28 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 7cbc19731997..d165743eeda2 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -35,7 +35,21 @@ struct seg6_local_lwt;
 
 struct seg6_action_desc {
 	int action;
-	unsigned long attrs;
+	unsigned long required_attrs;
+
+	/* optional_attrs is used to specify attributes which can be defined
+	 * as optional attributes (also called optional parameters). If one of
+	 * these attributes is not present in the netlink msg during the
+	 * behavior creation, no errors will be returned to the userland (as
+	 * opposed to a missing required_attrs, where indeed a -EINVAL error
+	 * is returned to userland).
+	 *
+	 * Each attribute can be 1) required or 2) optional. Anyway, if the
+	 * attribute is set in both ways then it is considered to be only
+	 * required.
+	 */
+	unsigned long optional_attrs;
+
 	int (*input)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
 	int static_headroom;
 };
@@ -57,6 +71,9 @@ struct seg6_local_lwt {
 
 	int headroom;
 	struct seg6_action_desc *desc;
+
+	/* parsed optional attributes */
+	unsigned long parsed_optional_attrs;
 };
 
 static struct seg6_local_lwt *seg6_local_lwtunnel(struct lwtunnel_state *lwt)
@@ -561,53 +578,53 @@ static int input_action_end_bpf(struct sk_buff *skb,
 static struct seg6_action_desc seg6_action_table[] = {
 	{
 		.action		= SEG6_LOCAL_ACTION_END,
-		.attrs		= 0,
+		.required_attrs	= 0,
 		.input		= input_action_end,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_X,
-		.attrs		= (1 << SEG6_LOCAL_NH6),
+		.required_attrs	= (1 << SEG6_LOCAL_NH6),
 		.input		= input_action_end_x,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_T,
-		.attrs		= (1 << SEG6_LOCAL_TABLE),
+		.required_attrs	= (1 << SEG6_LOCAL_TABLE),
 		.input		= input_action_end_t,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DX2,
-		.attrs		= (1 << SEG6_LOCAL_OIF),
+		.required_attrs	= (1 << SEG6_LOCAL_OIF),
 		.input		= input_action_end_dx2,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DX6,
-		.attrs		= (1 << SEG6_LOCAL_NH6),
+		.required_attrs	= (1 << SEG6_LOCAL_NH6),
 		.input		= input_action_end_dx6,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DX4,
-		.attrs		= (1 << SEG6_LOCAL_NH4),
+		.required_attrs	= (1 << SEG6_LOCAL_NH4),
 		.input		= input_action_end_dx4,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_DT6,
-		.attrs		= (1 << SEG6_LOCAL_TABLE),
+		.required_attrs	= (1 << SEG6_LOCAL_TABLE),
 		.input		= input_action_end_dt6,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_B6,
-		.attrs		= (1 << SEG6_LOCAL_SRH),
+		.required_attrs	= (1 << SEG6_LOCAL_SRH),
 		.input		= input_action_end_b6,
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_B6_ENCAP,
-		.attrs		= (1 << SEG6_LOCAL_SRH),
+		.required_attrs	= (1 << SEG6_LOCAL_SRH),
 		.input		= input_action_end_b6_encap,
 		.static_headroom	= sizeof(struct ipv6hdr),
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_BPF,
-		.attrs		= (1 << SEG6_LOCAL_BPF),
+		.required_attrs	= (1 << SEG6_LOCAL_BPF),
 		.input		= input_action_end_bpf,
 	},
 
@@ -710,6 +727,12 @@ static int cmp_nla_srh(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
 	return memcmp(a->srh, b->srh, len);
 }
 
+static void destroy_attr_srh(struct seg6_local_lwt *slwt)
+{
+	kfree(slwt->srh);
+	slwt->srh = NULL;
+}
+
 static int parse_nla_table(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 {
 	slwt->table = nla_get_u32(attrs[SEG6_LOCAL_TABLE]);
@@ -901,16 +924,36 @@ static int cmp_nla_bpf(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
 	return strcmp(a->bpf.name, b->bpf.name);
 }
 
+static void destroy_attr_bpf(struct seg6_local_lwt *slwt)
+{
+	kfree(slwt->bpf.name);
+	if (slwt->bpf.prog)
+		bpf_prog_put(slwt->bpf.prog);
+
+	/* avoid to mess up everything if the function is called more
+	 * than once.
+	 */
+	slwt->bpf.name = NULL;
+	slwt->bpf.prog = NULL;
+}
+
 struct seg6_action_param {
 	int (*parse)(struct nlattr **attrs, struct seg6_local_lwt *slwt);
 	int (*put)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
 	int (*cmp)(struct seg6_local_lwt *a, struct seg6_local_lwt *b);
+
+	/* optional destroy() callback useful for releasing resources that
+	 * have been previously allocated in the corresponding parse()
+	 * function.
+	 */
+	void (*destroy)(struct seg6_local_lwt *slwt);
 };
 
 static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
 	[SEG6_LOCAL_SRH]	= { .parse = parse_nla_srh,
 				    .put = put_nla_srh,
-				    .cmp = cmp_nla_srh },
+				    .cmp = cmp_nla_srh,
+				    .destroy = destroy_attr_srh },
 
 	[SEG6_LOCAL_TABLE]	= { .parse = parse_nla_table,
 				    .put = put_nla_table,
@@ -934,12 +977,96 @@ static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
 
 	[SEG6_LOCAL_BPF]	= { .parse = parse_nla_bpf,
 				    .put = put_nla_bpf,
-				    .cmp = cmp_nla_bpf },
+				    .cmp = cmp_nla_bpf,
+				    .destroy = destroy_attr_bpf	},
 
 };
 
+/* call the destroy() callback, if any, for each attribute set in
+ * @parsed_attrs, starting from attribute index @start up to @end excluded.
+ */
+static void __destroy_attrs(unsigned long parsed_attrs, int start, int end,
+			    struct seg6_local_lwt *slwt)
+{
+	struct seg6_action_param *param;
+	int i;
+
+	for (i = start; i < end; i++) {
+		if (!(parsed_attrs & (1 << i)))
+			continue;
+
+		param = &seg6_action_params[i];
+
+		if (param->destroy)
+			param->destroy(slwt);
+	}
+}
+
+/* release all the resources that have been possibly taken by attributes
+ * during parsing operations.
+ */
+static void destroy_attrs(struct seg6_local_lwt *slwt)
+{
+	unsigned long attrs;
+
+	attrs = slwt->desc->required_attrs | slwt->parsed_optional_attrs;
+
+	__destroy_attrs(attrs, 0, SEG6_LOCAL_MAX + 1, slwt);
+}
+
+/* optional attributes differ from the required (mandatory) ones because they
+ * can be or they cannot be present at all. If an attribute is declared but is
+ * not given then it will simply be discarded without generating any error.
+ */
+static int parse_nla_optional_attrs(struct nlattr **attrs,
+				    struct seg6_local_lwt *slwt)
+{
+	unsigned long optional_attrs, parsed_optional_attrs;
+	struct seg6_action_param *param;
+	struct seg6_action_desc *desc;
+	int i, err;
+
+	desc = slwt->desc;
+	parsed_optional_attrs = 0;
+	optional_attrs = desc->optional_attrs;
+
+	if (!optional_attrs)
+		goto out;
+
+	/* we call the parse() function for each optional attribute.
+	 * note: required attributes have already been parsed.
+	 */
+	for (i = 0; i < SEG6_LOCAL_MAX + 1; ++i) {
+		if (!(optional_attrs & (1 << i)) || !attrs[i])
+			continue;
+
+		param = &seg6_action_params[i];
+
+		err = param->parse(attrs, slwt);
+		if (err < 0)
+			goto parse_err;
+
+		/* current attribute has been correctly parsed */
+		parsed_optional_attrs |= (1 << i);
+	}
+
+out:
+	slwt->parsed_optional_attrs = parsed_optional_attrs;
+
+	return 0;
+
+parse_err:
+	/* release any resource that has been possibly allocated during
+	 * successful parse() operations.
+	 */
+	__destroy_attrs(parsed_optional_attrs, 0, i, slwt);
+
+	return err;
+}
+
 static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 {
+	unsigned long parsed_required_attrs;
 	struct seg6_action_param *param;
 	struct seg6_action_desc *desc;
 	int i, err;
@@ -952,10 +1079,16 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 		return -EOPNOTSUPP;
 
 	slwt->desc = desc;
+	parsed_required_attrs = 0;
 	slwt->headroom += desc->static_headroom;
 
+	/* if an attribute is set both optional and required, then we consider
+	 * it only as a required one.
+	 */
+	desc->optional_attrs &= ~desc->required_attrs;
+
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
-		if (desc->attrs & (1 << i)) {
+		if (desc->required_attrs & (1 << i)) {
 			if (!attrs[i])
 				return -EINVAL;
 
@@ -963,11 +1096,27 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 
 			err = param->parse(attrs, slwt);
 			if (err < 0)
-				return err;
+				goto parse_err;
+
+			/* current attribute has been correctly parsed */
+			parsed_required_attrs |= (1 << i);
 		}
 	}
 
+	/* if we support optional attributes, then we parse all of them */
+	err = parse_nla_optional_attrs(attrs, slwt);
+	if (err < 0)
+		goto parse_err;
+
 	return 0;
+
+parse_err:
+	/* release any resource that has been possibly allocated during
+	 * successful parse() operations.
+	 */
+	__destroy_attrs(parsed_required_attrs, 0, i, slwt);
+
+	return err;
 }
 
 static int seg6_local_build_state(struct nlattr *nla, unsigned int family,
@@ -1011,8 +1160,16 @@ static int seg6_local_build_state(struct nlattr *nla, unsigned int family,
 	return 0;
 
 out_free:
-	kfree(slwt->srh);
+	/* parse_nla_action() is in charge of calling destroy_attrs() if,
+	 * during the parsing operation, something went wrong. However, if the
+	 * creation of the behavior fails after the parse_nla_action()
+	 * successfully returned, then destroy_attrs() MUST be called.
+	 *
+	 * Please, keep that in mind if you need to add more logic here after
+	 * the parse_nla_action().
+	 */
 	kfree(newts);
+
 	return err;
 }
 
@@ -1020,14 +1177,7 @@ static void seg6_local_destroy_state(struct lwtunnel_state *lwt)
 {
 	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(lwt);
 
-	kfree(slwt->srh);
-
-	if (slwt->desc->attrs & (1 << SEG6_LOCAL_BPF)) {
-		kfree(slwt->bpf.name);
-		bpf_prog_put(slwt->bpf.prog);
-	}
-
-	return;
+	destroy_attrs(slwt);
 }
 
 static int seg6_local_fill_encap(struct sk_buff *skb,
@@ -1035,13 +1185,20 @@ static int seg6_local_fill_encap(struct sk_buff *skb,
 {
 	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(lwt);
 	struct seg6_action_param *param;
+	unsigned long attrs;
 	int i, err;
 
 	if (nla_put_u32(skb, SEG6_LOCAL_ACTION, slwt->action))
 		return -EMSGSIZE;
 
+	/* the set of attributes is now made of two parts:
+	 *  1) required_attrs (the default attributes);
+	 *  2) a variable number of parsed optional_attrs.
+	 */
+	attrs = slwt->desc->required_attrs | slwt->parsed_optional_attrs;
+
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
-		if (slwt->desc->attrs & (1 << i)) {
+		if (attrs & (1 << i)) {
 			param = &seg6_action_params[i];
 			err = param->put(skb, slwt);
 			if (err < 0)
@@ -1060,7 +1217,7 @@ static int seg6_local_get_encap_size(struct lwtunnel_state *lwt)
 
 	nlsize = nla_total_size(4); /* action */
 
-	attrs = slwt->desc->attrs;
+	attrs = slwt->desc->required_attrs | slwt->parsed_optional_attrs;
 
 	if (attrs & (1 << SEG6_LOCAL_SRH))
 		nlsize += nla_total_size((slwt->srh->hdrlen + 1) << 3);
@@ -1093,6 +1250,7 @@ static int seg6_local_cmp_encap(struct lwtunnel_state *a,
 {
 	struct seg6_local_lwt *slwt_a, *slwt_b;
 	struct seg6_action_param *param;
+	unsigned long attrs_a, attrs_b;
 	int i;
 
 	slwt_a = seg6_local_lwtunnel(a);
@@ -1101,11 +1259,14 @@ static int seg6_local_cmp_encap(struct lwtunnel_state *a,
 	if (slwt_a->action != slwt_b->action)
 		return 1;
 
-	if (slwt_a->desc->attrs != slwt_b->desc->attrs)
+	attrs_a = slwt_a->desc->required_attrs | slwt_a->parsed_optional_attrs;
+	attrs_b = slwt_b->desc->required_attrs | slwt_b->parsed_optional_attrs;
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


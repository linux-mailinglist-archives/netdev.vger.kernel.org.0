Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFD830CB08
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 20:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239467AbhBBTKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 14:10:32 -0500
Received: from smtp.uniroma2.it ([160.80.6.16]:60991 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239414AbhBBTIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 14:08:04 -0500
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2021 14:07:59 EST
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 112IvMQa000423
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 2 Feb 2021 19:57:23 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [PATCH net-next] seg6: fool-proof the processing of SRv6 behavior attributes
Date:   Tue,  2 Feb 2021 19:56:48 +0100
Message-Id: <20210202185648.11654-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The set of required attributes for a given SRv6 behavior is identified
using a bitmap stored in an unsigned long, since the initial design of SRv6
networking in Linux. Recently the same approach has been used for
identifying the optional attributes.

However, the number of attributes supported by SRv6 behaviors depends on
the size of the unsigned long type which changes with the architecture.
Indeed, on a 64-bit architecture, an SRv6 behavior can support up to 64
attributes while on a 32-bit architecture it can support at most 32
attributes.

To fool-proof the processing of SRv6 behaviors we will support at most 32
attributes independently from the reference architecture.

Consequently, this patch aims to:

 - verify, at compile time, that the total number of attributes does not
   exceed the fixed value of 32. Otherwise, kernel build fails forcing
   developers to reconsider adding a new attribute or extend the total
   number of supported attributes by the SRv6 behaviors.

 - replace all patterns (1 << i) with the macro SEG6_F_ATTR(i) in order to
   address potential overflow issues caused by 32-bit signed arithmetic.

Thanks to Colin Ian King for catching the overflow problem, providing a
solution and inspiring this patch.
Thanks to Jakub Kicinski for his useful suggestions during the design of
this patch.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 68 +++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 28 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index b07f7c1c82a4..7cc50d506902 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -31,6 +31,9 @@
 #include <linux/etherdevice.h>
 #include <linux/bpf.h>
 
+#define SEG6_F_ATTR(i)		BIT(i)
+#define SEG6_LOCAL_MAX_SUPP	32
+
 struct seg6_local_lwt;
 
 /* callbacks used for customizing the creation and destruction of a behavior */
@@ -660,8 +663,8 @@ seg6_end_dt_mode seg6_end_dt6_parse_mode(struct seg6_local_lwt *slwt)
 	unsigned long parsed_optattrs = slwt->parsed_optattrs;
 	bool legacy, vrfmode;
 
-	legacy	= !!(parsed_optattrs & (1 << SEG6_LOCAL_TABLE));
-	vrfmode	= !!(parsed_optattrs & (1 << SEG6_LOCAL_VRFTABLE));
+	legacy	= !!(parsed_optattrs & SEG6_F_ATTR(SEG6_LOCAL_TABLE));
+	vrfmode	= !!(parsed_optattrs & SEG6_F_ATTR(SEG6_LOCAL_VRFTABLE));
 
 	if (!(legacy ^ vrfmode))
 		/* both are absent or present: invalid DT6 mode */
@@ -883,32 +886,32 @@ static struct seg6_action_desc seg6_action_table[] = {
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
@@ -920,30 +923,30 @@ static struct seg6_action_desc seg6_action_table[] = {
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
 
@@ -1366,7 +1369,7 @@ static void __destroy_attrs(unsigned long parsed_attrs, int max_parsed,
 	 * attribute; otherwise, we call the destroy() callback.
 	 */
 	for (i = 0; i < max_parsed; ++i) {
-		if (!(parsed_attrs & (1 << i)))
+		if (!(parsed_attrs & SEG6_F_ATTR(i)))
 			continue;
 
 		param = &seg6_action_params[i];
@@ -1395,7 +1398,7 @@ static int parse_nla_optional_attrs(struct nlattr **attrs,
 	int err, i;
 
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; ++i) {
-		if (!(desc->optattrs & (1 << i)) || !attrs[i])
+		if (!(desc->optattrs & SEG6_F_ATTR(i)) || !attrs[i])
 			continue;
 
 		/* once here, the i-th attribute is provided by the
@@ -1408,7 +1411,7 @@ static int parse_nla_optional_attrs(struct nlattr **attrs,
 			goto parse_optattrs_err;
 
 		/* current attribute has been correctly parsed */
-		parsed_optattrs |= (1 << i);
+		parsed_optattrs |= SEG6_F_ATTR(i);
 	}
 
 	/* store in the tunnel state all the optional attributed successfully
@@ -1494,7 +1497,7 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 
 	/* parse the required attributes */
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
-		if (desc->attrs & (1 << i)) {
+		if (desc->attrs & SEG6_F_ATTR(i)) {
 			if (!attrs[i])
 				return -EINVAL;
 
@@ -1599,7 +1602,7 @@ static int seg6_local_fill_encap(struct sk_buff *skb,
 	attrs = slwt->desc->attrs | slwt->parsed_optattrs;
 
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
-		if (attrs & (1 << i)) {
+		if (attrs & SEG6_F_ATTR(i)) {
 			param = &seg6_action_params[i];
 			err = param->put(skb, slwt);
 			if (err < 0)
@@ -1620,30 +1623,30 @@ static int seg6_local_get_encap_size(struct lwtunnel_state *lwt)
 
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
@@ -1670,7 +1673,7 @@ static int seg6_local_cmp_encap(struct lwtunnel_state *a,
 		return 1;
 
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
-		if (attrs_a & (1 << i)) {
+		if (attrs_a & SEG6_F_ATTR(i)) {
 			param = &seg6_action_params[i];
 			if (param->cmp(slwt_a, slwt_b))
 				return 1;
@@ -1692,6 +1695,15 @@ static const struct lwtunnel_encap_ops seg6_local_ops = {
 
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


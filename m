Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C105B5FC6
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiILSF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiILSF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:05:27 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7976427DE1;
        Mon, 12 Sep 2022 11:05:25 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 28CHGubV031029
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
Subject: [net-next v2 1/3] seg6: add netlink_ext_ack support in parsing SRv6 behavior attributes
Date:   Mon, 12 Sep 2022 19:16:17 +0200
Message-Id: <20220912171619.16943-2-andrea.mayer@uniroma2.it>
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

An SRv6 behavior instance can be set up using mandatory and/or optional
attributes.
In the setup phase, each supplied attribute is parsed and processed. If
the parsing operation fails, the creation of the behavior instance stops
and an error number/code is reported to the user.  In many cases, it is
challenging for the user to figure out exactly what happened by relying
only on the error code.

For this reason, we add the support for netlink_ext_ack in parsing SRv6
behavior attributes. In this way, when an SRv6 behavior attribute is
parsed and an error occurs, the kernel can send a message to the
userspace describing the error through a meaningful text message in
addition to the classic error code.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 44 +++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index b7de5e46fdd8..f43e6f0baac1 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -1134,7 +1134,8 @@ static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
 	[SEG6_LOCAL_COUNTERS]	= { .type = NLA_NESTED },
 };
 
-static int parse_nla_srh(struct nlattr **attrs, struct seg6_local_lwt *slwt)
+static int parse_nla_srh(struct nlattr **attrs, struct seg6_local_lwt *slwt,
+			 struct netlink_ext_ack *extack)
 {
 	struct ipv6_sr_hdr *srh;
 	int len;
@@ -1191,7 +1192,8 @@ static void destroy_attr_srh(struct seg6_local_lwt *slwt)
 	kfree(slwt->srh);
 }
 
-static int parse_nla_table(struct nlattr **attrs, struct seg6_local_lwt *slwt)
+static int parse_nla_table(struct nlattr **attrs, struct seg6_local_lwt *slwt,
+			   struct netlink_ext_ack *extack)
 {
 	slwt->table = nla_get_u32(attrs[SEG6_LOCAL_TABLE]);
 
@@ -1225,7 +1227,8 @@ seg6_end_dt_info *seg6_possible_end_dt_info(struct seg6_local_lwt *slwt)
 }
 
 static int parse_nla_vrftable(struct nlattr **attrs,
-			      struct seg6_local_lwt *slwt)
+			      struct seg6_local_lwt *slwt,
+			      struct netlink_ext_ack *extack)
 {
 	struct seg6_end_dt_info *info = seg6_possible_end_dt_info(slwt);
 
@@ -1261,7 +1264,8 @@ static int cmp_nla_vrftable(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
 	return 0;
 }
 
-static int parse_nla_nh4(struct nlattr **attrs, struct seg6_local_lwt *slwt)
+static int parse_nla_nh4(struct nlattr **attrs, struct seg6_local_lwt *slwt,
+			 struct netlink_ext_ack *extack)
 {
 	memcpy(&slwt->nh4, nla_data(attrs[SEG6_LOCAL_NH4]),
 	       sizeof(struct in_addr));
@@ -1287,7 +1291,8 @@ static int cmp_nla_nh4(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
 	return memcmp(&a->nh4, &b->nh4, sizeof(struct in_addr));
 }
 
-static int parse_nla_nh6(struct nlattr **attrs, struct seg6_local_lwt *slwt)
+static int parse_nla_nh6(struct nlattr **attrs, struct seg6_local_lwt *slwt,
+			 struct netlink_ext_ack *extack)
 {
 	memcpy(&slwt->nh6, nla_data(attrs[SEG6_LOCAL_NH6]),
 	       sizeof(struct in6_addr));
@@ -1313,7 +1318,8 @@ static int cmp_nla_nh6(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
 	return memcmp(&a->nh6, &b->nh6, sizeof(struct in6_addr));
 }
 
-static int parse_nla_iif(struct nlattr **attrs, struct seg6_local_lwt *slwt)
+static int parse_nla_iif(struct nlattr **attrs, struct seg6_local_lwt *slwt,
+			 struct netlink_ext_ack *extack)
 {
 	slwt->iif = nla_get_u32(attrs[SEG6_LOCAL_IIF]);
 
@@ -1336,7 +1342,8 @@ static int cmp_nla_iif(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
 	return 0;
 }
 
-static int parse_nla_oif(struct nlattr **attrs, struct seg6_local_lwt *slwt)
+static int parse_nla_oif(struct nlattr **attrs, struct seg6_local_lwt *slwt,
+			 struct netlink_ext_ack *extack)
 {
 	slwt->oif = nla_get_u32(attrs[SEG6_LOCAL_OIF]);
 
@@ -1366,7 +1373,8 @@ static const struct nla_policy bpf_prog_policy[SEG6_LOCAL_BPF_PROG_MAX + 1] = {
 				       .len = MAX_PROG_NAME },
 };
 
-static int parse_nla_bpf(struct nlattr **attrs, struct seg6_local_lwt *slwt)
+static int parse_nla_bpf(struct nlattr **attrs, struct seg6_local_lwt *slwt,
+			 struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[SEG6_LOCAL_BPF_PROG_MAX + 1];
 	struct bpf_prog *p;
@@ -1444,7 +1452,8 @@ nla_policy seg6_local_counters_policy[SEG6_LOCAL_CNT_MAX + 1] = {
 };
 
 static int parse_nla_counters(struct nlattr **attrs,
-			      struct seg6_local_lwt *slwt)
+			      struct seg6_local_lwt *slwt,
+			      struct netlink_ext_ack *extack)
 {
 	struct pcpu_seg6_local_counters __percpu *pcounters;
 	struct nlattr *tb[SEG6_LOCAL_CNT_MAX + 1];
@@ -1543,7 +1552,8 @@ static void destroy_attr_counters(struct seg6_local_lwt *slwt)
 }
 
 struct seg6_action_param {
-	int (*parse)(struct nlattr **attrs, struct seg6_local_lwt *slwt);
+	int (*parse)(struct nlattr **attrs, struct seg6_local_lwt *slwt,
+		     struct netlink_ext_ack *extack);
 	int (*put)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
 	int (*cmp)(struct seg6_local_lwt *a, struct seg6_local_lwt *b);
 
@@ -1636,7 +1646,8 @@ static void destroy_attrs(struct seg6_local_lwt *slwt)
 }
 
 static int parse_nla_optional_attrs(struct nlattr **attrs,
-				    struct seg6_local_lwt *slwt)
+				    struct seg6_local_lwt *slwt,
+				    struct netlink_ext_ack *extack)
 {
 	struct seg6_action_desc *desc = slwt->desc;
 	unsigned long parsed_optattrs = 0;
@@ -1652,7 +1663,7 @@ static int parse_nla_optional_attrs(struct nlattr **attrs,
 		 */
 		param = &seg6_action_params[i];
 
-		err = param->parse(attrs, slwt);
+		err = param->parse(attrs, slwt, extack);
 		if (err < 0)
 			goto parse_optattrs_err;
 
@@ -1705,7 +1716,8 @@ static void seg6_local_lwtunnel_destroy_state(struct seg6_local_lwt *slwt)
 	ops->destroy_state(slwt);
 }
 
-static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
+static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt,
+			    struct netlink_ext_ack *extack)
 {
 	struct seg6_action_param *param;
 	struct seg6_action_desc *desc;
@@ -1749,14 +1761,14 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 
 			param = &seg6_action_params[i];
 
-			err = param->parse(attrs, slwt);
+			err = param->parse(attrs, slwt, extack);
 			if (err < 0)
 				goto parse_attrs_err;
 		}
 	}
 
 	/* parse the optional attributes, if any */
-	err = parse_nla_optional_attrs(attrs, slwt);
+	err = parse_nla_optional_attrs(attrs, slwt, extack);
 	if (err < 0)
 		goto parse_attrs_err;
 
@@ -1800,7 +1812,7 @@ static int seg6_local_build_state(struct net *net, struct nlattr *nla,
 	slwt = seg6_local_lwtunnel(newts);
 	slwt->action = nla_get_u32(tb[SEG6_LOCAL_ACTION]);
 
-	err = parse_nla_action(tb, slwt);
+	err = parse_nla_action(tb, slwt, extack);
 	if (err < 0)
 		goto out_free;
 
-- 
2.20.1


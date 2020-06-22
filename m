Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DED9203D86
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 19:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbgFVRKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 13:10:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729789AbgFVRKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 13:10:37 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MH3wKG132765;
        Mon, 22 Jun 2020 13:10:32 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tyspaae7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 13:10:32 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MGjdQB008731;
        Mon, 22 Jun 2020 17:10:31 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 31sa38h7hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 17:10:30 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MHASDX12386720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 17:10:28 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08B316A04F;
        Mon, 22 Jun 2020 17:10:30 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CA186A047;
        Mon, 22 Jun 2020 17:10:28 +0000 (GMT)
Received: from oc8377887825.ibm.com (unknown [9.160.23.249])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 22 Jun 2020 17:10:28 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de, wilder@us.ibm.com,
        mkubecek@suse.com
Subject: [PATCH v1 2/4] netfilter: Add a .pre_exit hook in all iptable_foo.c.
Date:   Mon, 22 Jun 2020 10:10:12 -0700
Message-Id: <20200622171014.975-3-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200622171014.975-1-dwilder@us.ibm.com>
References: <20200622171014.975-1-dwilder@us.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_10:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 cotscore=-2147483648 impostorscore=0
 phishscore=0 mlxlogscore=865 priorityscore=1501 bulkscore=0 suspectscore=1
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006220119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using new helpers ipt_unregister_table_pre_exit() and
ipt_unregister_table_exit().

Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 net/ipv4/netfilter/iptable_filter.c   | 10 +++++++++-
 net/ipv4/netfilter/iptable_mangle.c   | 10 +++++++++-
 net/ipv4/netfilter/iptable_nat.c      | 10 ++++++++--
 net/ipv4/netfilter/iptable_raw.c      | 10 +++++++++-
 net/ipv4/netfilter/iptable_security.c | 11 +++++++++--
 5 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 9d54b40..8f7bc1e 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -72,16 +72,24 @@ static int __net_init iptable_filter_net_init(struct net *net)
 	return 0;
 }
 
+static void __net_exit iptable_filter_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.iptable_filter)
+		ipt_unregister_table_pre_exit(net, net->ipv4.iptable_filter,
+					      filter_ops);
+}
+
 static void __net_exit iptable_filter_net_exit(struct net *net)
 {
 	if (!net->ipv4.iptable_filter)
 		return;
-	ipt_unregister_table(net, net->ipv4.iptable_filter, filter_ops);
+	ipt_unregister_table_exit(net, net->ipv4.iptable_filter);
 	net->ipv4.iptable_filter = NULL;
 }
 
 static struct pernet_operations iptable_filter_net_ops = {
 	.init = iptable_filter_net_init,
+	.pre_exit = iptable_filter_net_pre_exit,
 	.exit = iptable_filter_net_exit,
 };
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index bb9266e..f703a71 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -100,15 +100,23 @@ static int __net_init iptable_mangle_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit iptable_mangle_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.iptable_mangle)
+		ipt_unregister_table_pre_exit(net, net->ipv4.iptable_mangle,
+					      mangle_ops);
+}
+
 static void __net_exit iptable_mangle_net_exit(struct net *net)
 {
 	if (!net->ipv4.iptable_mangle)
 		return;
-	ipt_unregister_table(net, net->ipv4.iptable_mangle, mangle_ops);
+	ipt_unregister_table_exit(net, net->ipv4.iptable_mangle);
 	net->ipv4.iptable_mangle = NULL;
 }
 
 static struct pernet_operations iptable_mangle_net_ops = {
+	.pre_exit = iptable_mangle_net_pre_exit,
 	.exit = iptable_mangle_net_exit,
 };
 
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index ad33687..b0143b1 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -113,16 +113,22 @@ static int __net_init iptable_nat_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit iptable_nat_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.nat_table)
+		ipt_nat_unregister_lookups(net);
+}
+
 static void __net_exit iptable_nat_net_exit(struct net *net)
 {
 	if (!net->ipv4.nat_table)
 		return;
-	ipt_nat_unregister_lookups(net);
-	ipt_unregister_table(net, net->ipv4.nat_table, NULL);
+	ipt_unregister_table_exit(net, net->ipv4.nat_table);
 	net->ipv4.nat_table = NULL;
 }
 
 static struct pernet_operations iptable_nat_net_ops = {
+	.pre_exit = iptable_nat_net_pre_exit,
 	.exit	= iptable_nat_net_exit,
 };
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 69697eb..9abfe6b 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -67,15 +67,23 @@ static int __net_init iptable_raw_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit iptable_raw_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.iptable_raw)
+		ipt_unregister_table_pre_exit(net, net->ipv4.iptable_raw,
+					      rawtable_ops);
+}
+
 static void __net_exit iptable_raw_net_exit(struct net *net)
 {
 	if (!net->ipv4.iptable_raw)
 		return;
-	ipt_unregister_table(net, net->ipv4.iptable_raw, rawtable_ops);
+	ipt_unregister_table_exit(net, net->ipv4.iptable_raw);
 	net->ipv4.iptable_raw = NULL;
 }
 
 static struct pernet_operations iptable_raw_net_ops = {
+	.pre_exit = iptable_raw_net_pre_exit,
 	.exit = iptable_raw_net_exit,
 };
 
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index ac633c1..415c197 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -62,16 +62,23 @@ static int __net_init iptable_security_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit iptable_security_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.iptable_security)
+		ipt_unregister_table_pre_exit(net, net->ipv4.iptable_security,
+					      sectbl_ops);
+}
+
 static void __net_exit iptable_security_net_exit(struct net *net)
 {
 	if (!net->ipv4.iptable_security)
 		return;
-
-	ipt_unregister_table(net, net->ipv4.iptable_security, sectbl_ops);
+	ipt_unregister_table_exit(net, net->ipv4.iptable_security);
 	net->ipv4.iptable_security = NULL;
 }
 
 static struct pernet_operations iptable_security_net_ops = {
+	.pre_exit = iptable_security_net_pre_exit,
 	.exit = iptable_security_net_exit,
 };
 
-- 
1.8.3.1


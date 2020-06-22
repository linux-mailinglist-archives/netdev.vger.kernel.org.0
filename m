Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E288E203D81
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 19:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgFVRKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 13:10:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729789AbgFVRKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 13:10:36 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MH5Fsu026526;
        Mon, 22 Jun 2020 13:10:30 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysva2he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 13:10:30 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MGjbLp008707;
        Mon, 22 Jun 2020 17:10:29 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01wdc.us.ibm.com with ESMTP id 31sa38h7hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 17:10:29 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MHARIY19530172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 17:10:27 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BD4B6A051;
        Mon, 22 Jun 2020 17:10:28 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B69986A047;
        Mon, 22 Jun 2020 17:10:26 +0000 (GMT)
Received: from oc8377887825.ibm.com (unknown [9.160.23.249])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 22 Jun 2020 17:10:26 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de, wilder@us.ibm.com,
        mkubecek@suse.com
Subject: [PATCH v1 1/4] netfilter: Split ipt_unregister_table() into pre_exit and exit helpers.
Date:   Mon, 22 Jun 2020 10:10:11 -0700
Message-Id: <20200622171014.975-2-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200622171014.975-1-dwilder@us.ibm.com>
References: <20200622171014.975-1-dwilder@us.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_10:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1
 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 cotscore=-2147483648 mlxlogscore=994 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pre_exit will un-register the underlying hook and .exit will do the
table freeing. The netns core does an unconditional synchronize_rcu after
the pre_exit hooks insuring no packets are in flight that have picked up
the pointer before completing the un-register.

Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 include/linux/netfilter_ipv4/ip_tables.h |  6 ++++++
 net/ipv4/netfilter/ip_tables.c           | 15 ++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index b394bd4..c4676d6 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -25,6 +25,12 @@
 int ipt_register_table(struct net *net, const struct xt_table *table,
 		       const struct ipt_replace *repl,
 		       const struct nf_hook_ops *ops, struct xt_table **res);
+
+void ipt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+		       const struct nf_hook_ops *ops);
+
+void ipt_unregister_table_exit(struct net *net, struct xt_table *table);
+
 void ipt_unregister_table(struct net *net, struct xt_table *table,
 			  const struct nf_hook_ops *ops);
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c2670ea..5bf9fa0 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1797,11 +1797,22 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 	return ret;
 }
 
+void ipt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+				   const struct nf_hook_ops *ops)
+{
+	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+}
+
+void ipt_unregister_table_exit(struct net *net, struct xt_table *table)
+{
+	__ipt_unregister_table(net, table);
+}
+
 void ipt_unregister_table(struct net *net, struct xt_table *table,
 			  const struct nf_hook_ops *ops)
 {
 	if (ops)
-		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+		ipt_unregister_table_pre_exit(net, table, ops);
 	__ipt_unregister_table(net, table);
 }
 
@@ -1958,6 +1969,8 @@ static void __exit ip_tables_fini(void)
 
 EXPORT_SYMBOL(ipt_register_table);
 EXPORT_SYMBOL(ipt_unregister_table);
+EXPORT_SYMBOL(ipt_unregister_table_pre_exit);
+EXPORT_SYMBOL(ipt_unregister_table_exit);
 EXPORT_SYMBOL(ipt_do_table);
 module_init(ip_tables_init);
 module_exit(ip_tables_fini);
-- 
1.8.3.1


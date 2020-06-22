Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36FA203D85
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 19:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbgFVRKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 13:10:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30240 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730003AbgFVRKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 13:10:38 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MH4IOR002338;
        Mon, 22 Jun 2020 13:10:34 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31tys21wvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 13:10:33 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MGje1v007622;
        Mon, 22 Jun 2020 17:10:33 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 31t35bm3e3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 17:10:33 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MHAUQ68782542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 17:10:30 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0F846A04F;
        Mon, 22 Jun 2020 17:10:31 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75ADA6A051;
        Mon, 22 Jun 2020 17:10:30 +0000 (GMT)
Received: from oc8377887825.ibm.com (unknown [9.160.23.249])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 22 Jun 2020 17:10:30 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de, wilder@us.ibm.com,
        mkubecek@suse.com
Subject: [PATCH v1 3/4] netfilter: Split ip6t_unregister_table() into pre_exit and exit helpers.
Date:   Mon, 22 Jun 2020 10:10:13 -0700
Message-Id: <20200622171014.975-4-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200622171014.975-1-dwilder@us.ibm.com>
References: <20200622171014.975-1-dwilder@us.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_10:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 suspectscore=1 impostorscore=0 cotscore=-2147483648 phishscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pre_exit will un-register the underlying hook and .exit will do
the table freeing. The netns core does an unconditional synchronize_rcu
after the pre_exit hooks insuring no packets are in flight that have
picked up the pointer before completing the un-register.

Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 include/linux/netfilter_ipv6/ip6_tables.h |  3 +++
 net/ipv6/netfilter/ip6_tables.c           | 15 ++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 8225f78..1547d5f 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -29,6 +29,9 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct nf_hook_ops *ops, struct xt_table **res);
 void ip6t_unregister_table(struct net *net, struct xt_table *table,
 			   const struct nf_hook_ops *ops);
+void ip6t_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+				    const struct nf_hook_ops *ops);
+void ip6t_unregister_table_exit(struct net *net, struct xt_table *table);
 extern unsigned int ip6t_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e273934..e96a431 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1807,11 +1807,22 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 	return ret;
 }
 
+void ip6t_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+				    const struct nf_hook_ops *ops)
+{
+	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+}
+
+void ip6t_unregister_table_exit(struct net *net, struct xt_table *table)
+{
+	__ip6t_unregister_table(net, table);
+}
+
 void ip6t_unregister_table(struct net *net, struct xt_table *table,
 			   const struct nf_hook_ops *ops)
 {
 	if (ops)
-		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+		ip6t_unregister_table_pre_exit(net, table, ops);
 	__ip6t_unregister_table(net, table);
 }
 
@@ -1969,6 +1980,8 @@ static void __exit ip6_tables_fini(void)
 
 EXPORT_SYMBOL(ip6t_register_table);
 EXPORT_SYMBOL(ip6t_unregister_table);
+EXPORT_SYMBOL(ip6t_unregister_table_pre_exit);
+EXPORT_SYMBOL(ip6t_unregister_table_exit);
 EXPORT_SYMBOL(ip6t_do_table);
 
 module_init(ip6_tables_init);
-- 
1.8.3.1


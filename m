Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4519F2E2
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 21:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbfH0TCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 15:02:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726871AbfH0TCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 15:02:54 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7RIxcWJ050616;
        Tue, 27 Aug 2019 15:02:09 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2un90xk84d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Aug 2019 15:02:09 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7RJ1A4Y027212;
        Tue, 27 Aug 2019 19:02:08 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 2ujvv75vwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Aug 2019 19:02:08 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7RJ27mr46924278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 19:02:07 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E8ACAE060;
        Tue, 27 Aug 2019 19:02:07 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3669AE05F;
        Tue, 27 Aug 2019 19:02:05 +0000 (GMT)
Received: from LeoBras.aus.stglabs.ibm.com (unknown [9.18.235.216])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 27 Aug 2019 19:02:05 +0000 (GMT)
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Leonardo Bras <leonardo@linux.ibm.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v3 1/1] netfilter: nf_tables: fib: Drop IPV6 packets if IPv6 is disabled on boot
Date:   Tue, 27 Aug 2019 15:57:49 -0300
Message-Id: <20190827185748.19148-1-leonardo@linux.ibm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-27_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908270180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If IPv6 is disabled on boot (ipv6.disable=1), but nft_fib_inet ends up
dealing with a IPv6 packet, it causes a kernel panic in
fib6_node_lookup_1(), crashing in bad_page_fault.

The panic is caused by trying to deference a very low address (0x38
in ppc64le), due to ipv6.fib6_main_tbl = NULL.
BUG: Kernel NULL pointer dereference at 0x00000038

Fix this behavior by dropping IPv6 packets if !ipv6_mod_enabled().

Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
---
Changes from v2:
- Replace veredict.code from NF_DROP to NFT_BREAK
- Updated commit message (s/package/packet)

Changes from v1:
- Move drop logic from nft_fib_inet_eval() to nft_fib6_eval{,_type}
so it can affect other usages of these functions.

 net/ipv6/netfilter/nft_fib_ipv6.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 7ece86afd079..8496e43b73bd 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -125,6 +125,11 @@ void nft_fib6_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 	u32 *dest = &regs->data[priv->dreg];
 	struct ipv6hdr *iph, _iph;
 
+	if (!ipv6_mod_enabled()) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
 	iph = skb_header_pointer(pkt->skb, noff, sizeof(_iph), &_iph);
 	if (!iph) {
 		regs->verdict.code = NFT_BREAK;
@@ -150,6 +155,11 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct rt6_info *rt;
 	int lookup_flags;
 
+	if (!ipv6_mod_enabled()) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
 	if (priv->flags & NFTA_FIB_F_IIF)
 		oif = nft_in(pkt);
 	else if (priv->flags & NFTA_FIB_F_OIF)
-- 
2.20.1


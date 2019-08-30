Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32DE2A3D7F
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 20:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfH3SOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 14:14:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727959AbfH3SOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 14:14:30 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7UI3IH1016923;
        Fri, 30 Aug 2019 14:14:21 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uq7vqhwsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 14:14:21 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7UI4s0t012126;
        Fri, 30 Aug 2019 18:14:20 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 2ujvv7dh0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 18:14:20 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7UIEJtD36045086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 18:14:19 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4897AC05E;
        Fri, 30 Aug 2019 18:14:19 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41DDAAC059;
        Fri, 30 Aug 2019 18:14:16 +0000 (GMT)
Received: from LeoBras.ibmuc.com (unknown [9.85.151.141])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Aug 2019 18:14:16 +0000 (GMT)
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Leonardo Bras <leonardo@linux.ibm.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v4 1/2] netfilter: Terminate rule eval if protocol=IPv6 and ipv6 module is disabled
Date:   Fri, 30 Aug 2019 15:13:53 -0300
Message-Id: <20190830181354.26279-2-leonardo@linux.ibm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190830181354.26279-1-leonardo@linux.ibm.com>
References: <20190830181354.26279-1-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908300176
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

The kernel panic was reproduced in a host that disabled IPv6 on boot and
have to process guest packets (coming from a bridge) using it's ip6tables.

Terminate rule evaluation when packet protocol is IPv6 but the ipv6 module
is not loaded.

Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
---
 net/netfilter/nft_fib_netdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_fib_netdev.c b/net/netfilter/nft_fib_netdev.c
index 2cf3f32fe6d2..a2e726ae7f07 100644
--- a/net/netfilter/nft_fib_netdev.c
+++ b/net/netfilter/nft_fib_netdev.c
@@ -14,6 +14,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/ipv6.h>
 
 #include <net/netfilter/nft_fib.h>
 
@@ -34,6 +35,8 @@ static void nft_fib_netdev_eval(const struct nft_expr *expr,
 		}
 		break;
 	case ETH_P_IPV6:
+		if (!ipv6_mod_enabled())
+			break;
 		switch (priv->result) {
 		case NFT_FIB_RESULT_OIF:
 		case NFT_FIB_RESULT_OIFNAME:
-- 
2.20.1


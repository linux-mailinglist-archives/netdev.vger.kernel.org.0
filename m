Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE78A4242
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 06:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfHaElP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 00:41:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbfHaElO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 00:41:14 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7V4bC3t010070;
        Sat, 31 Aug 2019 00:41:01 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uqc4pgtgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 31 Aug 2019 00:41:01 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7V4eTfb004166;
        Sat, 31 Aug 2019 04:41:00 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 2uqgh68fpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 31 Aug 2019 04:41:00 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7V4exjP22544856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Aug 2019 04:40:59 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E5EFAC059;
        Sat, 31 Aug 2019 04:40:59 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60978AC05B;
        Sat, 31 Aug 2019 04:40:56 +0000 (GMT)
Received: from LeoBras.ibmuc.com (unknown [9.80.210.156])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 31 Aug 2019 04:40:56 +0000 (GMT)
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
Subject: [PATCH v5 1/1] net: br_netfiler_hooks: Drops IPv6 packets if IPv6 module is not loaded
Date:   Sat, 31 Aug 2019 01:40:33 -0300
Message-Id: <20190831044032.31931-1-leonardo@linux.ibm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-31_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908310051
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A kernel panic can happen if a host has disabled IPv6 on boot and have to
process guest packets (coming from a bridge) using it's ip6tables.

IPv6 packets need to be dropped if the IPv6 module is not loaded, and the
host ip6tables will be used.

Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
---
Changes from v4:
- Check if the host ip6tables is going to be used before testing 
  ipv6 module presence 
- Adds a warning about ipv6 module disabled.


 net/bridge/br_netfilter_hooks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index d3f9592f4ff8..af7800103e51 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -496,6 +496,10 @@ static unsigned int br_nf_pre_routing(void *priv,
 		if (!brnet->call_ip6tables &&
 		    !br_opt_get(br, BROPT_NF_CALL_IP6TABLES))
 			return NF_ACCEPT;
+		if (!ipv6_mod_enabled()) {
+			pr_warn_once("Module ipv6 is disabled, so call_ip6tables is not supported.");
+			return NF_DROP;
+		}
 
 		nf_bridge_pull_encap_header_rcsum(skb);
 		return br_nf_pre_routing_ipv6(priv, skb, state);
-- 
2.20.1


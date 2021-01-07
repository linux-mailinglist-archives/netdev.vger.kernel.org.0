Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34E82ED2EB
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 15:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbhAGOla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 09:41:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21626 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726165AbhAGOl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 09:41:29 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 107EagpV044981;
        Thu, 7 Jan 2021 09:40:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=W/RGf7/XcxQ0EiuGDdN+jDftaLzTc7/dKQ2ygemXd1U=;
 b=ETEuery+MofzlIG+Jd52WPyVX0wIa+N0NgC8rs6TujMc4KIag+9O+4JZHSIoPpyWzTW2
 FueFhOYUQBSHms0XT2H8NP0sQIKHoWHkBvV2UNo7X5F+r37ewoioNIz479j4K0NGysLi
 5SCeXFCVFLcCojymY1Ng2latJyGn2H+VMN12UetJ0MCmC+2yBpITqJjrW2s0ICxvwLix
 46LlsUMhV1jUnxaY1DedLBhOD51FgPNjs8sHryJaEDIHM3TWYieqzJrUGKP2eV9Kzen8
 fMf6XGqUjn53IT7vSUnI/62FA3Hz3wgezfPcQxTftBnQC62TdcOnaxc1kQ5h7vwrSy0V zw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35x391j3q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 09:40:21 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 107Ec1Ps029092;
        Thu, 7 Jan 2021 14:40:19 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 35wd3792v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 14:40:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 107EeHXG44433906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jan 2021 14:40:17 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 515684204D;
        Thu,  7 Jan 2021 14:40:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1217042041;
        Thu,  7 Jan 2021 14:40:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jan 2021 14:40:17 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net-next] net: ip_tunnel: clean up endianness conversions
Date:   Thu,  7 Jan 2021 15:40:08 +0100
Message-Id: <20210107144008.25777-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_06:2021-01-07,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1011 bulkscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sparse complains about some harmless endianness issues:

> net/ipv4/ip_tunnel_core.c:225:43: warning: cast to restricted __be16
> net/ipv4/ip_tunnel_core.c:225:43: warning: incorrect type in initializer (different base types)
> net/ipv4/ip_tunnel_core.c:225:43:    expected restricted __be16 [usertype] mtu
> net/ipv4/ip_tunnel_core.c:225:43:    got unsigned short [usertype]

iptunnel_pmtud_build_icmp() uses the wrong flavour of byte-order conversion
when storing the MTU into the ICMPv4 packet. Use htons(), just like
iptunnel_pmtud_build_icmpv6() does.

> net/ipv4/ip_tunnel_core.c:248:35: warning: cast from restricted __be16
> net/ipv4/ip_tunnel_core.c:248:35: warning: incorrect type in argument 3 (different base types)
> net/ipv4/ip_tunnel_core.c:248:35:    expected unsigned short type
> net/ipv4/ip_tunnel_core.c:248:35:    got restricted __be16 [usertype]
> net/ipv4/ip_tunnel_core.c:341:35: warning: cast from restricted __be16
> net/ipv4/ip_tunnel_core.c:341:35: warning: incorrect type in argument 3 (different base types)
> net/ipv4/ip_tunnel_core.c:341:35:    expected unsigned short type
> net/ipv4/ip_tunnel_core.c:341:35:    got restricted __be16 [usertype]

eth_header() wants the Ethertype in host-order, use the correct flavour of
byte-order conversion.

> net/ipv4/ip_tunnel_core.c:600:45: warning: restricted __be16 degrades to integer
> net/ipv4/ip_tunnel_core.c:609:30: warning: incorrect type in assignment (different base types)
> net/ipv4/ip_tunnel_core.c:609:30:    expected int type
> net/ipv4/ip_tunnel_core.c:609:30:    got restricted __be16 [usertype]
> net/ipv4/ip_tunnel_core.c:619:30: warning: incorrect type in assignment (different base types)
> net/ipv4/ip_tunnel_core.c:619:30:    expected int type
> net/ipv4/ip_tunnel_core.c:619:30:    got restricted __be16 [usertype]
> net/ipv4/ip_tunnel_core.c:629:30: warning: incorrect type in assignment (different base types)
> net/ipv4/ip_tunnel_core.c:629:30:    expected int type
> net/ipv4/ip_tunnel_core.c:629:30:    got restricted __be16 [usertype]

The TUNNEL_* types are big-endian, so adjust the type of the local
variable in ip_tun_parse_opts().

Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/ipv4/ip_tunnel_core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 7ca338fbe8ba..6b2dc7b2b612 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -222,7 +222,7 @@ static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
 		.code			= ICMP_FRAG_NEEDED,
 		.checksum		= 0,
 		.un.frag.__unused	= 0,
-		.un.frag.mtu		= ntohs(mtu),
+		.un.frag.mtu		= htons(mtu),
 	};
 	icmph->checksum = ip_compute_csum(icmph, len);
 	skb_reset_transport_header(skb);
@@ -245,7 +245,7 @@ static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	eth_header(skb, skb->dev, htons(eh.h_proto), eh.h_source, eh.h_dest, 0);
+	eth_header(skb, skb->dev, ntohs(eh.h_proto), eh.h_source, eh.h_dest, 0);
 	skb_reset_mac_header(skb);
 
 	return skb->len;
@@ -338,7 +338,7 @@ static int iptunnel_pmtud_build_icmpv6(struct sk_buff *skb, int mtu)
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	eth_header(skb, skb->dev, htons(eh.h_proto), eh.h_source, eh.h_dest, 0);
+	eth_header(skb, skb->dev, ntohs(eh.h_proto), eh.h_source, eh.h_dest, 0);
 	skb_reset_mac_header(skb);
 
 	return skb->len;
@@ -583,8 +583,9 @@ static int ip_tun_parse_opts_erspan(struct nlattr *attr,
 static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 			     struct netlink_ext_ack *extack)
 {
-	int err, rem, opt_len, opts_len = 0, type = 0;
+	int err, rem, opt_len, opts_len = 0;
 	struct nlattr *nla;
+	__be16 type = 0;
 
 	if (!attr)
 		return 0;
-- 
2.17.1


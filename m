Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6258C0DA
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfHMSjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:39:40 -0400
Received: from mx0a-00191d01.pphosted.com ([67.231.149.140]:26658 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726427AbfHMSjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:39:40 -0400
X-Greylist: delayed 15674 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Aug 2019 14:39:39 EDT
Received: from pps.filterd (m0048589.ppops.net [127.0.0.1])
        by m0048589.ppops.net-00191d01. (8.16.0.27/8.16.0.27) with SMTP id x7DEHu2p018882
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 10:18:25 -0400
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by m0048589.ppops.net-00191d01. with ESMTP id 2ubuw0w332-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 10:18:24 -0400
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x7DEIKmr009971
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 09:18:21 -0500
Received: from zlp30495.vci.att.com (zlp30495.vci.att.com [135.46.181.158])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x7DEIGZX009782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 09:18:16 -0500
Received: from zlp30495.vci.att.com (zlp30495.vci.att.com [127.0.0.1])
        by zlp30495.vci.att.com (Service) with ESMTP id 4FCF2400A0A7
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 14:18:16 +0000 (GMT)
Received: from clpi183.sldc.sbc.com (unknown [135.41.1.46])
        by zlp30495.vci.att.com (Service) with ESMTP id 3365F400A0A6
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 14:18:16 +0000 (GMT)
Received: from sldc.sbc.com (localhost [127.0.0.1])
        by clpi183.sldc.sbc.com (8.14.5/8.14.5) with ESMTP id x7DEIGNY030158
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 09:18:16 -0500
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by clpi183.sldc.sbc.com (8.14.5/8.14.5) with ESMTP id x7DEIB3s029785
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 09:18:12 -0500
Received: from pruddy-Precision-7520.edi.vyatta.net (unknown [10.156.17.46])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id 13FD93601AB
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 07:18:10 -0700 (PDT)
From:   Patrick Ruddy <pruddy@vyatta.att-mail.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next] mcast: ensure L-L IPv6 packets are accepted by bridge
Date:   Tue, 13 Aug 2019 15:18:04 +0100
Message-Id: <20190813141804.20515-1-pruddy@vyatta.att-mail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 priorityscore=1501 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present only all-nodes IPv6 multicast packets are accepted by
a bridge interface that is not in multicast router mode. Since
other protocols can be running in the absense of multicast
forwarding e.g. OSPFv3 IPv6 ND. Change the test to allow
all of the FFx2::/16 range to be accepted when not in multicast
router mode. This aligns the code with IPv4 link-local reception
and RFC4291

Signed-off-by: Patrick Ruddy <pruddy@vyatta.att-mail.com>
---
 include/net/addrconf.h    | 15 +++++++++++++++
 net/bridge/br_multicast.c |  2 +-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index becdad576859..05b42867e969 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -434,6 +434,21 @@ static inline void addrconf_addr_solict_mult(const struct in6_addr *addr,
 		      htonl(0xFF000000) | addr->s6_addr32[3]);
 }
 
+/*
+ *      link local multicast address range ffx2::/16 rfc4291
+ */
+static inline bool ipv6_addr_is_ll_mcast(const struct in6_addr *addr)
+{
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
+	__be64 *p = (__be64 *)addr;
+	return ((p[0] & cpu_to_be64(0xff0f000000000000UL))
+		^ cpu_to_be64(0xff02000000000000UL)) == 0UL;
+#else
+	return ((addr->s6_addr32[0] & htonl(0xff0f0000)) ^
+		htonl(0xff020000)) == 0;
+#endif
+}
+
 static inline bool ipv6_addr_is_ll_all_nodes(const struct in6_addr *addr)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 9b379e110129..ed3957381fa2 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1664,7 +1664,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 	err = ipv6_mc_check_mld(skb);
 
 	if (err == -ENOMSG) {
-		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
+		if (!ipv6_addr_is_ll_mcast(&ipv6_hdr(skb)->daddr))
 			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
 
 		if (ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr)) {
-- 
2.20.1


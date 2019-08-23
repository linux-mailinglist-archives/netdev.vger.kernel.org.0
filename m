Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A99F29B5CF
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 19:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390006AbfHWRtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 13:49:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42524 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfHWRtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 13:49:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NHiEpv067531;
        Fri, 23 Aug 2019 17:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=cxwR1HYssuE+tbGfNYguDdTe1V72+VLibJxc0ec4Q1I=;
 b=cwIUBex5IlptCeGOvQPQXiRIqpufEMnXvGj82MnhZoq3msV9eTtSE1cUvAmhHicL9GhQ
 JDyNA17ELZ4klloVS25gUBczZGSoPP9FzdUS5LDC9JnlezxptUmNpgE1EL9HstOi84BG
 rSEMWWVggoOOTX3Oq4OTJ7yazzb4HCaSpVdBLVW2YtYluguHfkx/9Z1wivb1YWdrfMKD
 /3OM/GwX4ulzvfgjMwvM/SwR6BUZhW84i2FlfX4HGZCDb1RXRyT70icag1GBgM+7AkC5
 KvL9iS5xHyqHM0xqxGzPcyqfEx/jy/QhvcVafjhDrzZhLxHxxN4Bqg5i55/kSISvjSUi eA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ue90u6aqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 17:49:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NHhfeB102035;
        Fri, 23 Aug 2019 17:49:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ujhvcerqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 17:49:17 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7NHnFSA031897;
        Fri, 23 Aug 2019 17:49:16 GMT
Received: from ak.ru.oracle.com (/10.162.80.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 10:49:15 -0700
From:   Alexey Kodanev <alexey.kodanev@oracle.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kodanev <alexey.kodanev@oracle.com>
Subject: [PATCH net] ipv4: mpls: fix mpls_xmit for iptunnel
Date:   Fri, 23 Aug 2019 20:51:43 +0300
Message-Id: <1566582703-26567-1-git-send-email-alexey.kodanev@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using mpls over gre/gre6 setup, rt->rt_gw4 address is not set, the
same for rt->rt_gw_family.  Therefore, when rt->rt_gw_family is checked
in mpls_xmit(), neigh_xmit() call is skipped. As a result, such setup
doesn't work anymore.

This issue was found with LTP mpls03 tests.

Fixes: 1550c171935d ("ipv4: Prepare rtable for IPv6 gateway")
Signed-off-by: Alexey Kodanev <alexey.kodanev@oracle.com>
---
 net/mpls/mpls_iptunnel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
index d25e91d..44b6750 100644
--- a/net/mpls/mpls_iptunnel.c
+++ b/net/mpls/mpls_iptunnel.c
@@ -133,12 +133,12 @@ static int mpls_xmit(struct sk_buff *skb)
 	mpls_stats_inc_outucastpkts(out_dev, skb);
 
 	if (rt) {
-		if (rt->rt_gw_family == AF_INET)
-			err = neigh_xmit(NEIGH_ARP_TABLE, out_dev, &rt->rt_gw4,
-					 skb);
-		else if (rt->rt_gw_family == AF_INET6)
+		if (rt->rt_gw_family == AF_INET6)
 			err = neigh_xmit(NEIGH_ND_TABLE, out_dev, &rt->rt_gw6,
 					 skb);
+		else
+			err = neigh_xmit(NEIGH_ARP_TABLE, out_dev, &rt->rt_gw4,
+					 skb);
 	} else if (rt6) {
 		if (ipv6_addr_v4mapped(&rt6->rt6i_gateway)) {
 			/* 6PE (RFC 4798) */
-- 
1.8.3.1


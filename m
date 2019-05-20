Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4CD22F1D
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 10:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731300AbfETIlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 04:41:39 -0400
Received: from mx0a-00191d01.pphosted.com ([67.231.149.140]:40498 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728889AbfETIlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 04:41:39 -0400
Received: from pps.filterd (m0049287.ppops.net [127.0.0.1])
        by m0049287.ppops.net-00191d01. (8.16.0.27/8.16.0.27) with SMTP id x4K8ZYlf007937;
        Mon, 20 May 2019 04:41:37 -0400
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by m0049287.ppops.net-00191d01. with ESMTP id 2skdnykyq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 May 2019 04:41:37 -0400
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4K8fahT106680;
        Mon, 20 May 2019 03:41:36 -0500
Received: from zlp30494.vci.att.com (zlp30494.vci.att.com [135.46.181.159])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4K8fUWu106605
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 20 May 2019 03:41:30 -0500
Received: from zlp30494.vci.att.com (zlp30494.vci.att.com [127.0.0.1])
        by zlp30494.vci.att.com (Service) with ESMTP id C55864009E86;
        Mon, 20 May 2019 08:41:30 +0000 (GMT)
Received: from tlpd252.dadc.sbc.com (unknown [135.31.184.157])
        by zlp30494.vci.att.com (Service) with ESMTP id B2A1D4009E83;
        Mon, 20 May 2019 08:41:30 +0000 (GMT)
Received: from dadc.sbc.com (localhost [127.0.0.1])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4K8fUiS063829;
        Mon, 20 May 2019 03:41:30 -0500
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4K8fNDi063634;
        Mon, 20 May 2019 03:41:23 -0500
Received: from MM-7520.vyatta.net (unknown [10.156.47.136])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id C115C360088;
        Mon, 20 May 2019 01:41:21 -0700 (PDT)
From:   Mike Manning <mmanning@vyatta.att-mail.com>
To:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: [PATCH net] net/ipv6: Reinstate ping/traceroute use with source address in VRF
Date:   Mon, 20 May 2019 09:40:41 +0100
Message-Id: <20190520084041.10393-1-mmanning@vyatta.att-mail.com>
X-Mailer: git-send-email 2.11.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-20_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905200063
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the commit 1893ff20275b ("net/ipv6: Add l3mdev check to
ipv6_chk_addr_and_flags"), traceroute using TCP SYN or ICMP ECHO option
and ping fail when specifying a source address typically on a loopback
/dummy interface in the same VRF, e.g.:

    # ip vrf exec vrfgreen ping 3000::1 -I 2222::2
    ping: bind icmp socket: Cannot assign requested address
    # ip vrf exec vrfgreen traceroute 3000::1 -s 2222::2 -T
    bind: Cannot assign requested address

IPv6 traceroute using default UDP and IPv4 ping & traceroute continue
to work inside a VRF using a source address.

The reason is that the source address is provided via bind without a
device given by these applications in this case. The call to
ipv6_check_addr() in rawv6_bind() returns false as the default VRF is
assumed if no dev was given, but the src addr is in a non-default VRF.

The solution is to check that the address exists in the L3 domain that
the dev is part of only if the dev has been specified.

Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
---
 net/ipv6/addrconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f96d1de79509..3963306ec27f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1908,6 +1908,7 @@ int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
 			    int strict, u32 banned_flags)
 {
 	unsigned int hash = inet6_addr_hash(net, addr);
+	const struct net_device *orig_dev = dev;
 	const struct net_device *l3mdev;
 	struct inet6_ifaddr *ifp;
 	u32 ifp_flags;
@@ -1922,7 +1923,7 @@ int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
 		if (!net_eq(dev_net(ifp->idev->dev), net))
 			continue;
 
-		if (l3mdev_master_dev_rcu(ifp->idev->dev) != l3mdev)
+		if (orig_dev && l3mdev_master_dev_rcu(ifp->idev->dev) != l3mdev)
 			continue;
 
 		/* Decouple optimistic from tentative for evaluation here.
-- 
2.11.0


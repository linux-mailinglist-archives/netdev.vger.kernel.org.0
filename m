Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE29B2ADCD3
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKJRYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgKJRYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 12:24:13 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52423C0613CF
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 09:24:13 -0800 (PST)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 0AAHLaG4032029;
        Tue, 10 Nov 2020 17:24:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=jan2016.eng;
 bh=EkUqW9vc7taGhkegnrREai2qGG9O/hiJKG0oQqKPQ0M=;
 b=ndLopy5d1dcHyTCuca1UpTeM0T/rGz0231WqM5wOcAAOsqiWbgwWxPttvlBdgdsaIQ7C
 strfZ9BG6kuDDYTmgEon69xnwWB/F0cXkMwbE3zVKZOT/KVK9TAo21VYRgOQgBQQcvWI
 R0w8iC2IobeGbvEzrxqBqovutCiVBEWU5ucLhta2V/4qrUlgk/I5PwshoOtS2/RVhCB5
 Wx/9MxDzaYmHcPlUBH3SZ7D16EqHPhA9sVpahYM7/mkxkCFR2sC/T9gWELBCG0xyKYJO
 ZfPamgp/unZr6hd9vCIwZp++Zn8g+HLjyk5uipKPSz8lLx6LoWr7BWZU+qsL+UnOiWn7 rg== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 34nhhrv89d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 17:24:09 +0000
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 0AAHJCZi023502;
        Tue, 10 Nov 2020 12:24:09 -0500
Received: from email.msg.corp.akamai.com ([172.27.123.34])
        by prod-mail-ppoint2.akamai.com with ESMTP id 34nqt2eky0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 12:24:09 -0500
Received: from USMA1EX-CAS2.msg.corp.akamai.com (172.27.123.31) by
 usma1ex-dag3mb6.msg.corp.akamai.com (172.27.123.54) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 10 Nov 2020 12:24:08 -0500
Received: from bos-lp1yy.kendall.corp.akamai.com (172.28.3.205) by
 USMA1EX-CAS2.msg.corp.akamai.com (172.27.123.31) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Tue, 10 Nov 2020 12:24:08 -0500
Received: by bos-lp1yy.kendall.corp.akamai.com (Postfix, from userid 45189)
        id EB5C815F991; Tue, 10 Nov 2020 12:23:14 -0500 (EST)
From:   Jeff Dike <jdike@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Jeff Dike <jdike@akamai.com>
Subject: [PATCH net V3] Exempt multicast addresses from five-second neighbor lifetime
Date:   Tue, 10 Nov 2020 12:23:05 -0500
Message-ID: <20201110172305.28056-1-jdike@akamai.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_07:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxlogscore=950 suspectscore=1 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100122
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_07:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 mlxlogscore=939 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=1 adultscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011100122
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.19)
 smtp.mailfrom=jdike@akamai.com smtp.helo=prod-mail-ppoint2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 58956317c8de ("neighbor: Improve garbage collection")
guarantees neighbour table entries a five-second lifetime.  Processes
which make heavy use of multicast can fill the neighour table with
multicast addresses in five seconds.  At that point, neighbour entries
can't be GC-ed because they aren't five seconds old yet, the kernel
log starts to fill up with "neighbor table overflow!" messages, and
sends start to fail.

This patch allows multicast addresses to be thrown out before they've
lived out their five seconds.  This makes room for non-multicast
addresses and makes messages to all addresses more reliable in these
circumstances.

Signed-off-by: Jeff Dike <jdike@akamai.com>
---
 include/net/neighbour.h | 1 +
 net/core/neighbour.c    | 2 ++
 net/ipv4/arp.c          | 6 ++++++
 net/ipv6/ndisc.c        | 7 +++++++
 4 files changed, 16 insertions(+)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 81ee17594c32..22ced1381ede 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -204,6 +204,7 @@ struct neigh_table {
 	int			(*pconstructor)(struct pneigh_entry *);
 	void			(*pdestructor)(struct pneigh_entry *);
 	void			(*proxy_redo)(struct sk_buff *skb);
+	int			(*is_multicast)(const void *pkey);
 	bool			(*allow_add)(const struct net_device *dev,
 					     struct netlink_ext_ack *extack);
 	char			*id;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 8e39e28b0a8d..9500d28a43b0 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -235,6 +235,8 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 
 			write_lock(&n->lock);
 			if ((n->nud_state == NUD_FAILED) ||
+			    (tbl->is_multicast &&
+			     tbl->is_multicast(n->primary_key)) ||
 			    time_after(tref, n->updated))
 				remove = true;
 			write_unlock(&n->lock);
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 687971d83b4e..097aa8bf07ee 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -125,6 +125,7 @@ static int arp_constructor(struct neighbour *neigh);
 static void arp_solicit(struct neighbour *neigh, struct sk_buff *skb);
 static void arp_error_report(struct neighbour *neigh, struct sk_buff *skb);
 static void parp_redo(struct sk_buff *skb);
+static int arp_is_multicast(const void *pkey);
 
 static const struct neigh_ops arp_generic_ops = {
 	.family =		AF_INET,
@@ -156,6 +157,7 @@ struct neigh_table arp_tbl = {
 	.key_eq		= arp_key_eq,
 	.constructor	= arp_constructor,
 	.proxy_redo	= parp_redo,
+	.is_multicast   = arp_is_multicast,
 	.id		= "arp_cache",
 	.parms		= {
 		.tbl			= &arp_tbl,
@@ -928,6 +930,10 @@ static void parp_redo(struct sk_buff *skb)
 	arp_process(dev_net(skb->dev), NULL, skb);
 }
 
+static int arp_is_multicast(const void *pkey)
+{
+	return ipv4_is_multicast(*((__be32 *)pkey));
+}
 
 /*
  *	Receive an arp request from the device layer.
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 27f29b957ee7..67457cfadcd2 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -81,6 +81,7 @@ static void ndisc_error_report(struct neighbour *neigh, struct sk_buff *skb);
 static int pndisc_constructor(struct pneigh_entry *n);
 static void pndisc_destructor(struct pneigh_entry *n);
 static void pndisc_redo(struct sk_buff *skb);
+static int ndisc_is_multicast(const void *pkey);
 
 static const struct neigh_ops ndisc_generic_ops = {
 	.family =		AF_INET6,
@@ -115,6 +116,7 @@ struct neigh_table nd_tbl = {
 	.pconstructor =	pndisc_constructor,
 	.pdestructor =	pndisc_destructor,
 	.proxy_redo =	pndisc_redo,
+	.is_multicast = ndisc_is_multicast,
 	.allow_add  =   ndisc_allow_add,
 	.id =		"ndisc_cache",
 	.parms = {
@@ -1706,6 +1708,11 @@ static void pndisc_redo(struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
+static int ndisc_is_multicast(const void *pkey)
+{
+	return ipv6_addr_is_multicast((struct in6_addr *)pkey);
+}
+
 static bool ndisc_suppress_frag_ndisc(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
-- 
2.17.1


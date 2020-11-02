Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3A52A31FC
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbgKBRtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgKBRtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 12:49:05 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAA4C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 09:49:05 -0800 (PST)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 0A2Hmjaq032169;
        Mon, 2 Nov 2020 17:49:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=jan2016.eng;
 bh=aZY9wJWy2uEpourqLsBNzXOugKw+u6TthBLuakoHEhc=;
 b=T6IfAwOCmxv1YQghZRgyfoF+xXjNzUe6gqmPDwjMJhiD2N2igFVBYisGC+O+ptu8zlVf
 DQm/7B4DU+K+iU2DkzeObeM2TTN4g7h0Jnjvp9OdbZoXxd2CDXEZE00aJxA61D6FtSua
 FQC4p7h4uf6hCKUB2wEscW6MZ3aFviUXzmFWWNia5yKThqHo5v+l1FlMUAS/ns2GbMJW
 JRt5aNb4ahE+a80bXRUbQV9SqulOQUEJNd6jVlLRupPdQc5gDWmiQwsTGmcuHtxf+cME
 coSX8C3kdY90vCvJsdfk+WxwhY/emS+rLFPJN/D05z3ZNZMK/2Wa1KPSy1N0/XAjrgxZ fw== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 34jamm4wrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 17:49:03 +0000
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 0A2Ha0VH015674;
        Mon, 2 Nov 2020 09:49:03 -0800
Received: from email.msg.corp.akamai.com ([172.27.123.34])
        by prod-mail-ppoint5.akamai.com with ESMTP id 34h5wancrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 09:49:03 -0800
Received: from usma1ex-cas5.msg.corp.akamai.com (172.27.123.53) by
 usma1ex-dag3mb3.msg.corp.akamai.com (172.27.123.58) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 2 Nov 2020 12:49:02 -0500
Received: from bos-lp1yy.kendall.corp.akamai.com (172.28.3.205) by
 usma1ex-cas5.msg.corp.akamai.com (172.27.123.53) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Mon, 2 Nov 2020 12:49:02 -0500
Received: by bos-lp1yy.kendall.corp.akamai.com (Postfix, from userid 45189)
        id 13EDB15F7E0; Mon,  2 Nov 2020 12:48:17 -0500 (EST)
From:   Jeff Dike <jdike@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Jeff Dike <jdike@akamai.com>
Subject: [PATCH net-next] Exempt multicast addresses from five-second neighbor lifetime
Date:   Mon, 2 Nov 2020 12:47:56 -0500
Message-ID: <20201102174756.6933-1-jdike@akamai.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_12:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=1
 mlxlogscore=991 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020134
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_12:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=981 mlxscore=0 suspectscore=1 bulkscore=0
 clxscore=1011 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020136
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.60)
 smtp.mailfrom=jdike@akamai.com smtp.helo=prod-mail-ppoint5
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
 net/ipv4/arp.c          | 8 ++++++++
 net/ipv6/ndisc.c        | 7 +++++++
 4 files changed, 18 insertions(+)

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
index 687971d83b4e..1032ad76a3f5 100644
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
@@ -928,6 +930,12 @@ static void parp_redo(struct sk_buff *skb)
 	arp_process(dev_net(skb->dev), NULL, skb);
 }
 
+#define IN_MULTICAST(a) ((((long)(a)) & 0xf0000000) == 0xe0000000)
+
+static int arp_is_multicast(const void *pkey)
+{
+	return IN_MULTICAST(htonl(*((u32 *)pkey)));
+}
 
 /*
  *	Receive an arp request from the device layer.
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 27f29b957ee7..6aed5536fc5c 100644
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
+	return (((struct in6_addr *)pkey)->in6_u.u6_addr8[0] & 0xf0) == 0xf0;
+}
+
 static bool ndisc_suppress_frag_ndisc(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
-- 
2.17.1


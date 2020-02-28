Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 240BC173E9F
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgB1Rfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:35:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbgB1Rfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:35:44 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SHKhsM029852
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 12:35:43 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yepxfxx3k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 12:35:43 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <bmt@zurich.ibm.com>;
        Fri, 28 Feb 2020 17:35:40 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 28 Feb 2020 17:35:38 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01SHZbol59572306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 17:35:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 430154C040;
        Fri, 28 Feb 2020 17:35:37 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6A604C046;
        Fri, 28 Feb 2020 17:35:36 +0000 (GMT)
Received: from spoke.zurich.ibm.com (unknown [9.4.69.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Feb 2020 17:35:36 +0000 (GMT)
From:   Bernard Metzler <bmt@zurich.ibm.com>
To:     chuck.lever@oracle.com, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        parav@mellanox.com, syzkaller-bugs@googlegroups.com,
        willy@infradead.org
Cc:     Bernard Metzler <bmt@zurich.ibm.com>
Subject: [PATCH for-rc] RDMA/siw: Fix passive connection establishment
Date:   Fri, 28 Feb 2020 18:35:34 +0100
X-Mailer: git-send-email 2.17.2
X-TM-AS-GCONF: 00
x-cbid: 20022817-0028-0000-0000-000003DEF0E1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022817-0029-0000-0000-000024A41497
Message-Id: <20200228173534.26815-1-bmt@zurich.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_05:2020-02-28,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002280134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Holding the rtnl_lock while iterating a devices interface
address list potentially causes deadlocks with the
cma_netdev_callback. While this was implemented to
limit the scope of a wildcard listen to addresses
of the current device only, a better solution limits
the scope of the socket to the device. This completely
avoiding locking, and also results in significant code
simplification.

Reported-by: syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
---
 drivers/infiniband/sw/siw/siw_cm.c | 137 +++++++----------------------
 1 file changed, 31 insertions(+), 106 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index c5651a96b196..559e5fd3bad8 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1769,14 +1769,23 @@ int siw_reject(struct iw_cm_id *id, const void *pdata, u8 pd_len)
 	return 0;
 }
 
-static int siw_listen_address(struct iw_cm_id *id, int backlog,
-			      struct sockaddr *laddr, int addr_family)
+/*
+ * siw_create_listen - Create resources for a listener's IWCM ID @id
+ *
+ * Starts listen on the socket address id->local_addr.
+ *
+ */
+int siw_create_listen(struct iw_cm_id *id, int backlog)
 {
 	struct socket *s;
 	struct siw_cep *cep = NULL;
 	struct siw_device *sdev = to_siw_dev(id->device);
+	int addr_family = id->local_addr.ss_family;
 	int rv = 0, s_val;
 
+	if (addr_family != AF_INET && addr_family != AF_INET6)
+		return -EAFNOSUPPORT;
+
 	rv = sock_create(addr_family, SOCK_STREAM, IPPROTO_TCP, &s);
 	if (rv < 0)
 		return rv;
@@ -1791,9 +1800,25 @@ static int siw_listen_address(struct iw_cm_id *id, int backlog,
 		siw_dbg(id->device, "setsockopt error: %d\n", rv);
 		goto error;
 	}
-	rv = s->ops->bind(s, laddr, addr_family == AF_INET ?
-				    sizeof(struct sockaddr_in) :
-				    sizeof(struct sockaddr_in6));
+	if (addr_family == AF_INET) {
+		struct sockaddr_in *laddr = &to_sockaddr_in(id->local_addr);
+
+		/* For wildcard addr, limit binding to current device only */
+		if (ipv4_is_zeronet(laddr->sin_addr.s_addr))
+			s->sk->sk_bound_dev_if = sdev->netdev->ifindex;
+
+		rv = s->ops->bind(s, (struct sockaddr *)laddr,
+				  sizeof(struct sockaddr_in));
+	} else {
+		struct sockaddr_in6 *laddr = &to_sockaddr_in6(id->local_addr);
+
+		/* For wildcard addr, limit binding to current device only */
+		if (ipv6_addr_any(&laddr->sin6_addr))
+			s->sk->sk_bound_dev_if = sdev->netdev->ifindex;
+
+		rv = s->ops->bind(s, (struct sockaddr *)laddr,
+				  sizeof(struct sockaddr_in6));
+	}
 	if (rv) {
 		siw_dbg(id->device, "socket bind error: %d\n", rv);
 		goto error;
@@ -1852,7 +1877,7 @@ static int siw_listen_address(struct iw_cm_id *id, int backlog,
 	list_add_tail(&cep->listenq, (struct list_head *)id->provider_data);
 	cep->state = SIW_EPSTATE_LISTENING;
 
-	siw_dbg(id->device, "Listen at laddr %pISp\n", laddr);
+	siw_dbg(id->device, "Listen at laddr %pISp\n", &id->local_addr);
 
 	return 0;
 
@@ -1910,106 +1935,6 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 	}
 }
 
-/*
- * siw_create_listen - Create resources for a listener's IWCM ID @id
- *
- * Listens on the socket address id->local_addr.
- *
- * If the listener's @id provides a specific local IP address, at most one
- * listening socket is created and associated with @id.
- *
- * If the listener's @id provides the wildcard (zero) local IP address,
- * a separate listen is performed for each local IP address of the device
- * by creating a listening socket and binding to that local IP address.
- *
- */
-int siw_create_listen(struct iw_cm_id *id, int backlog)
-{
-	struct net_device *dev = to_siw_dev(id->device)->netdev;
-	int rv = 0, listeners = 0;
-
-	siw_dbg(id->device, "backlog %d\n", backlog);
-
-	/*
-	 * For each attached address of the interface, create a
-	 * listening socket, if id->local_addr is the wildcard
-	 * IP address or matches the IP address.
-	 */
-	if (id->local_addr.ss_family == AF_INET) {
-		struct in_device *in_dev = in_dev_get(dev);
-		struct sockaddr_in s_laddr;
-		const struct in_ifaddr *ifa;
-
-		if (!in_dev) {
-			rv = -ENODEV;
-			goto out;
-		}
-		memcpy(&s_laddr, &id->local_addr, sizeof(s_laddr));
-
-		siw_dbg(id->device, "laddr %pISp\n", &s_laddr);
-
-		rtnl_lock();
-		in_dev_for_each_ifa_rtnl(ifa, in_dev) {
-			if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) ||
-			    s_laddr.sin_addr.s_addr == ifa->ifa_address) {
-				s_laddr.sin_addr.s_addr = ifa->ifa_address;
-
-				rv = siw_listen_address(id, backlog,
-						(struct sockaddr *)&s_laddr,
-						AF_INET);
-				if (!rv)
-					listeners++;
-			}
-		}
-		rtnl_unlock();
-		in_dev_put(in_dev);
-	} else if (id->local_addr.ss_family == AF_INET6) {
-		struct inet6_dev *in6_dev = in6_dev_get(dev);
-		struct inet6_ifaddr *ifp;
-		struct sockaddr_in6 *s_laddr = &to_sockaddr_in6(id->local_addr);
-
-		if (!in6_dev) {
-			rv = -ENODEV;
-			goto out;
-		}
-		siw_dbg(id->device, "laddr %pISp\n", &s_laddr);
-
-		rtnl_lock();
-		list_for_each_entry(ifp, &in6_dev->addr_list, if_list) {
-			if (ifp->flags & (IFA_F_TENTATIVE | IFA_F_DEPRECATED))
-				continue;
-			if (ipv6_addr_any(&s_laddr->sin6_addr) ||
-			    ipv6_addr_equal(&s_laddr->sin6_addr, &ifp->addr)) {
-				struct sockaddr_in6 bind_addr  = {
-					.sin6_family = AF_INET6,
-					.sin6_port = s_laddr->sin6_port,
-					.sin6_flowinfo = 0,
-					.sin6_addr = ifp->addr,
-					.sin6_scope_id = dev->ifindex };
-
-				rv = siw_listen_address(id, backlog,
-						(struct sockaddr *)&bind_addr,
-						AF_INET6);
-				if (!rv)
-					listeners++;
-			}
-		}
-		rtnl_unlock();
-		in6_dev_put(in6_dev);
-	} else {
-		rv = -EAFNOSUPPORT;
-	}
-out:
-	if (listeners)
-		rv = 0;
-	else if (!rv)
-		rv = -EINVAL;
-
-	siw_dbg(id->device, "%s\n", rv ? "FAIL" : "OK");
-
-	return rv;
-}
-
 int siw_destroy_listen(struct iw_cm_id *id)
 {
 	if (!id->provider_data) {
-- 
2.17.2


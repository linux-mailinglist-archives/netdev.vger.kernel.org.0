Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555246D2BDB
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 01:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbjCaXzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 19:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbjCaXzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 19:55:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841B11C1F0;
        Fri, 31 Mar 2023 16:55:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32VKrUEs001102;
        Fri, 31 Mar 2023 23:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=TszhWmDYp9cCLCMmtvEMQJZjTmyEI4o5qzJKzuAb25o=;
 b=2fOiOegY4xI01Zv4OiY32YRr1mOu50/wYWpNFe2EoLnYX/mg+tMwHzTX1MxhSDQ2PbBy
 OAZ4h+8CRjArlrPhL/6UtKjQTZc0kwbaX156ERUdHqUPQiEGyDlqnEdsHesDMQ7j+5gd
 qZ/r+hk9ufkggWq0CKmKe/m2wUbwDBnMYXWO46RE8aFlAbb08jh5aGkZvcCEUPRQTmIu
 8s7Yfkaf6P+R4JlMdA8qLzSSsKLnc1QtaoQUJBmubXbpNmmd6gqIdUqvz+1kPDVmnLep
 cysW30Hfd1AkbEP3waA4zz4irGPu5x8kvEMUgvzbC04jxWe9LOkquV1kOPuykIulBCzJ RQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmpb4yebm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 23:55:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32VLmCxr023570;
        Fri, 31 Mar 2023 23:55:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdkm2r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 23:55:35 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32VNtUId019347;
        Fri, 31 Mar 2023 23:55:34 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3phqdkm2p9-3;
        Fri, 31 Mar 2023 23:55:34 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v4 2/6] netlink: Add new netlink_release function
Date:   Fri, 31 Mar 2023 16:55:24 -0700
Message-Id: <20230331235528.1106675-3-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303310196
X-Proofpoint-GUID: FmtVzUYO91Byx0pOSzeky0gl5YTQcqXk
X-Proofpoint-ORIG-GUID: FmtVzUYO91Byx0pOSzeky0gl5YTQcqXk
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new function netlink_release is added in netlink_sock to store the
protocol's release function. This is called when the socket is deleted.
This can be supplied by the protocol via the release function in
netlink_kernel_cfg. This is being added for the NETLINK_CONNECTOR
protocol, so it can free it's data when socket is deleted.

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 include/linux/netlink.h  | 1 +
 net/netlink/af_netlink.c | 6 ++++++
 net/netlink/af_netlink.h | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 866bbc5a4c8d..05a316aa93b4 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -51,6 +51,7 @@ struct netlink_kernel_cfg {
 	int		(*bind)(struct net *net, int group);
 	void		(*unbind)(struct net *net, int group);
 	bool		(*compare)(struct net *net, struct sock *sk);
+	void		(*release) (struct sock *sk, unsigned long *groups);
 };
 
 struct sock *__netlink_kernel_create(struct net *net, int unit,
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 003c7e6ec9be..dc7880055705 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -677,6 +677,7 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol,
 	struct netlink_sock *nlk;
 	int (*bind)(struct net *net, int group);
 	void (*unbind)(struct net *net, int group);
+	void (*release)(struct sock *sock, unsigned long *groups);
 	int err = 0;
 
 	sock->state = SS_UNCONNECTED;
@@ -704,6 +705,7 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol,
 	cb_mutex = nl_table[protocol].cb_mutex;
 	bind = nl_table[protocol].bind;
 	unbind = nl_table[protocol].unbind;
+	release = nl_table[protocol].release;
 	netlink_unlock_table();
 
 	if (err < 0)
@@ -719,6 +721,7 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol,
 	nlk->module = module;
 	nlk->netlink_bind = bind;
 	nlk->netlink_unbind = unbind;
+	nlk->netlink_release = release;
 out:
 	return err;
 
@@ -763,6 +766,8 @@ static int netlink_release(struct socket *sock)
 	 * OK. Socket is unlinked, any packets that arrive now
 	 * will be purged.
 	 */
+	if (nlk->netlink_release)
+		nlk->netlink_release(sk, nlk->groups);
 
 	/* must not acquire netlink_table_lock in any way again before unbind
 	 * and notifying genetlink is done as otherwise it might deadlock
@@ -2117,6 +2122,7 @@ __netlink_kernel_create(struct net *net, int unit, struct module *module,
 		if (cfg) {
 			nl_table[unit].bind = cfg->bind;
 			nl_table[unit].unbind = cfg->unbind;
+			nl_table[unit].release = cfg->release;
 			nl_table[unit].flags = cfg->flags;
 			if (cfg->compare)
 				nl_table[unit].compare = cfg->compare;
diff --git a/net/netlink/af_netlink.h b/net/netlink/af_netlink.h
index 5f454c8de6a4..054335a34804 100644
--- a/net/netlink/af_netlink.h
+++ b/net/netlink/af_netlink.h
@@ -42,6 +42,8 @@ struct netlink_sock {
 	void			(*netlink_rcv)(struct sk_buff *skb);
 	int			(*netlink_bind)(struct net *net, int group);
 	void			(*netlink_unbind)(struct net *net, int group);
+	void			(*netlink_release)(struct sock *sk,
+						   unsigned long *groups);
 	struct module		*module;
 
 	struct rhash_head	node;
@@ -65,6 +67,8 @@ struct netlink_table {
 	int			(*bind)(struct net *net, int group);
 	void			(*unbind)(struct net *net, int group);
 	bool			(*compare)(struct net *net, struct sock *sock);
+	void			(*release)(struct sock *sk,
+					   unsigned long *groups);
 	int			registered;
 };
 
-- 
2.40.0


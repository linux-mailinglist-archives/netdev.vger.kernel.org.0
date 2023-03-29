Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E674F6CF21C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjC2S0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjC2S0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:26:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6223959F8;
        Wed, 29 Mar 2023 11:26:14 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TEU4De018538;
        Wed, 29 Mar 2023 18:25:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=GC5M1AAloAsnc32WLbYzM+8yiNovVYWfuPZvnbW1NS0=;
 b=qg9Ko3pz6PLHJmXn8yAHWYa4pefrMF7KjOc9htBPLdxiekL/XkWBoh/9uwkAa4Xkri8V
 7/f6JWZrzgy6zd2j5q6WqDRSffYjp+n3YzuVVRwcU0EbeZYapCnjVC9imc2E/+u/JaRl
 NNcUCcqMj6DNe8x3Ptbj/VXdn0P+wGPRigQb9JlgwxXXKTGIOB8R3DjarSorWEJ5b4FY
 c7+xxGHlxCgDbEI1WMZ2RMXX5B9IzW6b7DiUN4gXSmQfnKwnSfKvAfFmkSylfdcuzaUx
 D+QynXVVeW6E2kHeaeLs+TXF2jlp8yIuir0l+WGDUubWjm4OyL+v8/rVXaNMceFl/do6 Dw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmq538pb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 18:25:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32THUQSK010926;
        Wed, 29 Mar 2023 18:25:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqder9xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 18:25:56 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32TIPQeD004473;
        Wed, 29 Mar 2023 18:25:55 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3phqder9hg-7;
        Wed, 29 Mar 2023 18:25:55 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v3 6/7] netlink: Add multicast group level permissions
Date:   Wed, 29 Mar 2023 11:25:42 -0700
Message-Id: <20230329182543.1161480-7-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230329182543.1161480-1-anjali.k.kulkarni@oracle.com>
References: <20230329182543.1161480-1-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_12,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290141
X-Proofpoint-GUID: rMPjqdIr9HYarEqkGttuexANfBhM82vf
X-Proofpoint-ORIG-GUID: rMPjqdIr9HYarEqkGttuexANfBhM82vf
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new field perm_groups is added in netlink_sock to store the protocol's
multicast group access permissions. This is to allow for a more fine
grained access control than just at the protocol level. These
permissions can be supplied by the protocol via the netlink_kernel_cfg.
A new function netlink_multicast_allowed() is added, which checks if
the protocol's multicast group has non-root access before allowing bind.

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 include/linux/netlink.h  |  1 +
 net/netlink/af_netlink.c | 25 +++++++++++++++++++++++--
 net/netlink/af_netlink.h |  2 ++
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 05a316aa93b4..253cbcd7a290 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -46,6 +46,7 @@ void netlink_table_ungrab(void);
 struct netlink_kernel_cfg {
 	unsigned int	groups;
 	unsigned int	flags;
+	long unsigned 	perm_groups;
 	void		(*input)(struct sk_buff *skb);
 	struct mutex	*cb_mutex;
 	int		(*bind)(struct net *net, int group);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index dc7880055705..f31173d28dd0 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -679,6 +679,7 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol,
 	void (*unbind)(struct net *net, int group);
 	void (*release)(struct sock *sock, unsigned long *groups);
 	int err = 0;
+	unsigned long perm_groups;
 
 	sock->state = SS_UNCONNECTED;
 
@@ -706,6 +707,7 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol,
 	bind = nl_table[protocol].bind;
 	unbind = nl_table[protocol].unbind;
 	release = nl_table[protocol].release;
+	perm_groups = nl_table[protocol].perm_groups;
 	netlink_unlock_table();
 
 	if (err < 0)
@@ -722,6 +724,7 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol,
 	nlk->netlink_bind = bind;
 	nlk->netlink_unbind = unbind;
 	nlk->netlink_release = release;
+	nlk->perm_groups = perm_groups;
 out:
 	return err;
 
@@ -938,6 +941,20 @@ bool netlink_net_capable(const struct sk_buff *skb, int cap)
 }
 EXPORT_SYMBOL(netlink_net_capable);
 
+static inline bool netlink_multicast_allowed(unsigned long perm_groups,
+					     unsigned long groups)
+{
+	int group;
+
+	for (group = 0; group < BITS_PER_TYPE(u32); group++) {
+		if (test_bit(group, &groups)) {
+			if (!test_bit(group, &perm_groups))
+				return false;
+		}
+	}
+	return true;
+}
+
 static inline int netlink_allowed(const struct socket *sock, unsigned int flag)
 {
 	return (nl_table[sock->sk->sk_protocol].flags & flag) ||
@@ -1023,8 +1040,11 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 
 	/* Only superuser is allowed to listen multicasts */
 	if (groups) {
-		if (!netlink_allowed(sock, NL_CFG_F_NONROOT_RECV))
-			return -EPERM;
+		if (!netlink_allowed(sock, NL_CFG_F_NONROOT_RECV)) {
+			if (!netlink_multicast_allowed(nlk->perm_groups,
+						       groups))
+				return -EPERM;
+		}
 		err = netlink_realloc_groups(sk);
 		if (err)
 			return err;
@@ -2124,6 +2144,7 @@ __netlink_kernel_create(struct net *net, int unit, struct module *module,
 			nl_table[unit].unbind = cfg->unbind;
 			nl_table[unit].release = cfg->release;
 			nl_table[unit].flags = cfg->flags;
+			nl_table[unit].perm_groups = cfg->perm_groups;
 			if (cfg->compare)
 				nl_table[unit].compare = cfg->compare;
 		}
diff --git a/net/netlink/af_netlink.h b/net/netlink/af_netlink.h
index 054335a34804..b7880254c716 100644
--- a/net/netlink/af_netlink.h
+++ b/net/netlink/af_netlink.h
@@ -29,6 +29,7 @@ struct netlink_sock {
 	u32			flags;
 	u32			subscriptions;
 	u32			ngroups;
+	unsigned long		perm_groups;
 	unsigned long		*groups;
 	unsigned long		state;
 	size_t			max_recvmsg_len;
@@ -62,6 +63,7 @@ struct netlink_table {
 	struct listeners __rcu	*listeners;
 	unsigned int		flags;
 	unsigned int		groups;
+	unsigned long		perm_groups;
 	struct mutex		*cb_mutex;
 	struct module		*module;
 	int			(*bind)(struct net *net, int group);
-- 
2.40.0


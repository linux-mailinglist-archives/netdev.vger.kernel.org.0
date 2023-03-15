Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB90E6BA520
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 03:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjCOCUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 22:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjCOCT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 22:19:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C453E2FCD8;
        Tue, 14 Mar 2023 19:19:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32F0E9cu003666;
        Wed, 15 Mar 2023 02:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=LlK5uxPTxbIRWQNiOLGGwy+WjZSPnYFJWNzhTN2bS9Q=;
 b=1Z2EPr//vvNK/lV6/xoo4IKOoBaCGcukaTNEMST8NZrTDQm+iF5d/mxrZ9zhiYXiQpxy
 REZhUaMdhQiznOSiZdu6kZmzBt1ON+m5xta+Xw8IS6C3pXA0fIfAIqzKVROJrQwLcxps
 1vMy+OYilx8eH46mVOmvgoClyU5CkrLtK/7OC0bRwszoa3KSVq+UW8VvlLlhVvUed8zw
 uRre0klTUgDk2gZ21ofB6Ax4RXP76gqeadq5ol9TwLnTyQkYyiNWrJDs6JqlDaJNbgaz
 nZPcawUAIbOwd1gT6Ue6jhuZAQ4B6rzejV9pS16WoyaRbp+OGgsaFWBog77ayJaQt0t5 aQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pb2xpg838-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 02:19:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32F1qMCr001320;
        Wed, 15 Mar 2023 02:19:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pb2m2n6wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 02:19:00 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32F2Gh2K030879;
        Wed, 15 Mar 2023 02:19:00 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pb2m2n6p2-6;
        Wed, 15 Mar 2023 02:19:00 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v2 5/5] connector/cn_proc: Allow non-root users access
Date:   Tue, 14 Mar 2023 19:18:50 -0700
Message-Id: <20230315021850.2788946-6-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315021850.2788946-1-anjali.k.kulkarni@oracle.com>
References: <20230315021850.2788946-1-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_16,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2302240000
 definitions=main-2303150018
X-Proofpoint-ORIG-GUID: dmbdYdlU6NMHOyKNQUg-NTGtJ-Fjx2YL
X-Proofpoint-GUID: dmbdYdlU6NMHOyKNQUg-NTGtJ-Fjx2YL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There were a couple of reasons for not allowing non-root users access
initially  - one is there was some point no proper receive buffer
management in place for netlink multicast. But that should be long
fixed. See link below for more context.

Second is that some of the messages may contain data that is root only. But
this should be handled with a finer granularity, which is being done at the
protocol layer.  The only problematic protocols are nf_queue and the
firewall netlink. Hence, this restriction for non-root access was relaxed
for NETLINK_ROUTE initially:
https://lore.kernel.org/all/20020612013101.A22399@wotan.suse.de/

This restriction has also been removed for following protocols:
NETLINK_KOBJECT_UEVENT, NETLINK_AUDIT, NETLINK_SOCK_DIAG,
NETLINK_GENERIC, NETLINK_SELINUX.

Since process connector messages are not sensitive (process fork, exit
notifications etc.), and anyone can read /proc data, we can allow non-root
access here. However, since process event notification is not the only
consumer of NETLINK_CONNECTOR, we can make this change even more
fine grained than the protocol level, by checking for multicast group
within the protocol.

Added a new function netlink_multicast_allowed(), which checks if the
protocol is NETLINK_CONNECTOR, and if multicast group is CN_IDX_PROC
(process event notification) - if so, then allow non-root acceess. For
other multicast groups of NETLINK_CONNECTOR, do not allow non-root
access.

Reason we need this change is we cannot run our DB application as root.

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 drivers/connector/cn_proc.c |  7 -------
 net/netlink/af_netlink.c    | 13 ++++++++++++-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 465c9c7a8f8b..d8e2f111da80 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -409,12 +409,6 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 	    !task_is_in_init_pid_ns(current))
 		return;
 
-	/* Can only change if privileged. */
-	if (!__netlink_ns_capable(nsp, &init_user_ns, CAP_NET_ADMIN)) {
-		err = EPERM;
-		goto out;
-	}
-
 	if (msg->len == sizeof(*pinput)) {
 		pinput = (struct proc_input *)msg->data;
 		mc_op = pinput->mcast_op;
@@ -461,7 +455,6 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 		break;
 	}
 
-out:
 	cn_proc_ack(err, msg->seq, msg->ack);
 }
 
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index ad8ec18152cd..e4f5a1241a5d 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -938,6 +938,16 @@ bool netlink_net_capable(const struct sk_buff *skb, int cap)
 }
 EXPORT_SYMBOL(netlink_net_capable);
 
+static inline bool netlink_multicast_allowed(const struct socket *sock,
+					     unsigned long groups)
+{
+	if (sock->sk->sk_protocol == NETLINK_CONNECTOR) {
+		if (test_bit(CN_IDX_PROC - 1, &groups))
+			return true;
+	}
+	return false;
+}
+
 static inline int netlink_allowed(const struct socket *sock, unsigned int flag)
 {
 	return (nl_table[sock->sk->sk_protocol].flags & flag) ||
@@ -1024,7 +1034,8 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 	/* Only superuser is allowed to listen multicasts */
 	if (groups) {
 		if (!netlink_allowed(sock, NL_CFG_F_NONROOT_RECV))
-			return -EPERM;
+			if (!netlink_multicast_allowed(sock, groups))
+				return -EPERM;
 		err = netlink_realloc_groups(sk);
 		if (err)
 			return err;
-- 
2.39.2


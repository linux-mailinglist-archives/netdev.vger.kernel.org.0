Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AA96B541A
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 23:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjCJWQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 17:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjCJWQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 17:16:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DCE13F559;
        Fri, 10 Mar 2023 14:16:15 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32ALhqcu029130;
        Fri, 10 Mar 2023 22:15:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=ypj3LZpaUEhvKq+LBBjXBZ9woTF6MaJioqO/9Jg/ZvY=;
 b=qRlMRLReg8sAL4yfs6I9XoggL+490xRr/2WxuY4gLC0Yik/UNRvV+0o0einYDyJ5key8
 XOI2QhcTvlulYNh3127qvQ6JRmvau+Pckk5lELsmJNEn6ey5dIprRUx22FE5QjY2o6mH
 AZ9JpLTAq2lJqpXBGgAoVNMd5iBYbuw32fXeX0oa4HrWc9eqwjMqhk08TH/u2oOk7vvR
 Lw4Dq2eDQQRWR1skaibt0MJAWO5Ev7o7nyE2X2zeeG7VB0Y0t9kXVsJ7peyvgZEpEHgV
 IbIuTgQO4t+OZazdkXZwJg7WMCiGaM2ADwkKwT5rI9gRZyxtgmClTvr/hEFpzm/4rQQP fQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415j6e1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 22:15:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32AM171E031512;
        Fri, 10 Mar 2023 22:15:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6feqs9tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 22:15:57 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32AMFrP3028711;
        Fri, 10 Mar 2023 22:15:57 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p6feqs9nh-5;
        Fri, 10 Mar 2023 22:15:57 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v1 4/5] connector/cn_proc: Allow non-root users access
Date:   Fri, 10 Mar 2023 14:15:46 -0800
Message-Id: <20230310221547.3656194-5-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_10,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100177
X-Proofpoint-GUID: 18CqOHN4I79nNDFsZo9-0PNpUfCloFI7
X-Proofpoint-ORIG-GUID: 18CqOHN4I79nNDFsZo9-0PNpUfCloFI7
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
consumer of NETWORK_CONNECTOR, we can make this change even more
fine grained than the protocol level, by checking for multicast group
within the protocol.

Added a new function netlink_multicast_allowed(), which checks if the
protocol is NETWORK_CONNECTOR, and if multicast group is CN_IDX_PROC
(process event notification) - if so, then allow non-root acceess. For
other multicast groups of NETWORK_CONNECTOR, do not allow non-root
access.

Reason we need this change is we cannot run our DB application as root.

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 drivers/connector/cn_proc.c |  7 -------
 net/netlink/af_netlink.c    | 13 ++++++++++++-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 84f38d2bd4b9..4ff7f8635a6b 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -375,12 +375,6 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 	    !task_is_in_init_pid_ns(current))
 		return;
 
-	/* Can only change if privileged. */
-	if (!__netlink_ns_capable(nsp, &init_user_ns, CAP_NET_ADMIN)) {
-		err = EPERM;
-		goto out;
-	}
-
 	if (msg->len == sizeof(mc_op))
 		mc_op = *((enum proc_cn_mcast_op *)msg->data);
 	else
@@ -413,7 +407,6 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 		break;
 	}
 
-out:
 	cn_proc_ack(err, msg->seq, msg->ack);
 }
 
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index b311375b8c4c..ae30ec678ad9 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -939,6 +939,16 @@ bool netlink_net_capable(const struct sk_buff *skb, int cap)
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
@@ -1025,7 +1035,8 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
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
2.31.1


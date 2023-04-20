Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9AB6E9D35
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjDTU2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjDTU1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:27:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB97940CE;
        Thu, 20 Apr 2023 13:27:38 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33KKFDA8002097;
        Thu, 20 Apr 2023 20:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=gXl2kPXJPf/jSKBw0vAfbHVROAJisKoHzvhm0NlxHu4=;
 b=s4bH2Aov8vHggEV1QQXJHyu/WJDOOUVYZFkGExIgkwurw3zP97upL15oioxwirfJqM6f
 FsuNFFjLbfvJ7/mzbL1buGB6lrx/D97YpLJR1SiqdODk2fFp4/qldGl/8KXsIqHTmMAC
 44Z1+SFPClI3x+zIauwsq7weWUSPni6qlBQ3I3xzOag+1auCvIQQYM8e/brmga1iIDSl
 xKDLsLz6katwli0FenSsrjFVnExFPcHrQEwwza8sG9eDN2zzVT1RJxRWsW7z1shFzQwG
 QrEj8k4z0zFi8IYuaXSsZHoSGMLoPuJJqLC3ePH9ER1+iwpSeUonHsLbXjUJ/0LeOdKr gA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pykhu3v7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 20:27:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33KJ6bHs026349;
        Thu, 20 Apr 2023 20:27:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcf2ecv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 20:27:24 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33KKRCYi027077;
        Thu, 20 Apr 2023 20:27:23 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pyjcf2e4y-7;
        Thu, 20 Apr 2023 20:27:23 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     david@fries.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, zbr@ioremap.net, brauner@kernel.org,
        johannes@sipsolutions.net, ecree.xilinx@gmail.com, leon@kernel.org,
        keescook@chromium.org, socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v5 6/6] connector/cn_proc: Allow non-root users access
Date:   Thu, 20 Apr 2023 13:27:09 -0700
Message-Id: <20230420202709.3207243-7-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230420202709.3207243-1-anjali.k.kulkarni@oracle.com>
References: <20230420202709.3207243-1-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_15,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304200171
X-Proofpoint-GUID: 3b8dCK71HrXf8vU5h-QkROO1YAmgi2Hf
X-Proofpoint-ORIG-GUID: 3b8dCK71HrXf8vU5h-QkROO1YAmgi2Hf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Allow non-root access for NETLINK_CONNECTOR via NL_CFG_F_NONROOT_RECV
but add new bind function cn_bind(), which allows non-root access only
for CN_IDX_PROC multicast group.

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 drivers/connector/cn_proc.c   |  7 -------
 drivers/connector/connector.c | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 35bec1fd7ee0..046a8c1d8577 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -408,12 +408,6 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
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
@@ -460,7 +454,6 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 		break;
 	}
 
-out:
 	cn_proc_ack(err, msg->seq, msg->ack);
 }
 
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index d1179df2b0ba..193d3056de64 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -166,6 +166,18 @@ static int cn_call_callback(struct sk_buff *skb)
 	return err;
 }
 
+static int cn_bind(struct net *net, int group)
+{
+	unsigned long groups = 0;
+	groups = (unsigned long) group;
+
+	if (ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return 0;
+	if (test_bit(CN_IDX_PROC - 1, &groups))
+		return 0;
+	return -EPERM;
+}
+
 static void cn_release(struct sock *sk, unsigned long *groups)
 {
 	if (groups && test_bit(CN_IDX_PROC - 1, groups)) {
@@ -261,6 +273,8 @@ static int cn_init(void)
 	struct netlink_kernel_cfg cfg = {
 		.groups	= CN_NETLINK_USERS + 0xf,
 		.input	= cn_rx_skb,
+		.flags  = NL_CFG_F_NONROOT_RECV,
+		.bind   = cn_bind,
 		.release = cn_release,
 	};
 
-- 
2.40.0


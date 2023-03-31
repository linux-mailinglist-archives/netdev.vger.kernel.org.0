Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EE56D2BE3
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 01:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbjCaX4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 19:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbjCaXz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 19:55:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCA61D2DA;
        Fri, 31 Mar 2023 16:55:56 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32VKsDls018070;
        Fri, 31 Mar 2023 23:55:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=MLNwEFR7K7V5sMs9qtcWmzpWamzsQdShllerji99pNM=;
 b=DkwVRlqqWX0oQIQ16Mhe1yL0lfwVCn681NPr8UCOfx5uCtDXY5T1haz/IhUfFZQDZi4V
 vj7YBz1ZUSA8P8aqGb6ML+5gX4IRifPSSO4o9poMksLJFcUeHZpxdhLjU/uaXwXqtFmr
 R1d2mQoWfUBMSwlrAf3nK0zaMWG2SZ27q4Jw2X1R/cTYNUJTiZrvH2xmi+WwcgdzbwwC
 9Pu2bmK8P1Ix/HRCfy20bmFzGIHfGd4pdsBF5YvQl1qd/iu7Nfv9O+NZVcjxmCG9Zisn
 BfIp6KzEde8uVTk9hj6IrtCZ74xMpNX1FiNloOw0OmnHv4nuJMgL5Lz3letETiqiGQdZ hw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmpmpf8bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 23:55:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32VMNgYM023539;
        Fri, 31 Mar 2023 23:55:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdkm2rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 23:55:36 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32VNtUIf019347;
        Fri, 31 Mar 2023 23:55:36 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3phqdkm2p9-4;
        Fri, 31 Mar 2023 23:55:36 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v4 3/6] connector/cn_proc: Add filtering to fix some bugs
Date:   Fri, 31 Mar 2023 16:55:25 -0700
Message-Id: <20230331235528.1106675-4-anjali.k.kulkarni@oracle.com>
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
X-Proofpoint-GUID: l1rWhCIct0_wY_zZawX-sheb6RnNMLUZ
X-Proofpoint-ORIG-GUID: l1rWhCIct0_wY_zZawX-sheb6RnNMLUZ
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current proc connector code has the foll. bugs - if there are more
than one listeners for the proc connector messages, and one of them
deregisters for listening using PROC_CN_MCAST_IGNORE, they will still get
all proc connector messages, as long as there is another listener.

Another issue is if one client calls PROC_CN_MCAST_LISTEN, and another one
calls PROC_CN_MCAST_IGNORE, then both will end up not getting any messages.

This patch adds filtering and drops packet if client has sent
PROC_CN_MCAST_IGNORE. This data is stored in the client socket's
sk_user_data. In addition, we only increment or decrement
proc_event_num_listeners once per client. This fixes the above issues.

cn_release is the release function added for NETLINK_CONNECTOR. It uses
the newly added netlink_release function added to netlink_sock. It will
free sk_user_data.

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 drivers/connector/cn_proc.c   | 53 ++++++++++++++++++++++++++++-------
 drivers/connector/connector.c | 21 +++++++++++---
 drivers/w1/w1_netlink.c       |  6 ++--
 include/linux/connector.h     |  8 +++++-
 include/uapi/linux/cn_proc.h  | 43 ++++++++++++++++------------
 5 files changed, 96 insertions(+), 35 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index ccac1c453080..84f38d2bd4b9 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -48,6 +48,21 @@ static DEFINE_PER_CPU(struct local_event, local_event) = {
 	.lock = INIT_LOCAL_LOCK(lock),
 };
 
+static int cn_filter(struct sock *dsk, struct sk_buff *skb, void *data)
+{
+	enum proc_cn_mcast_op mc_op;
+
+	if (!dsk)
+		return 0;
+
+	mc_op = ((struct proc_input *)(dsk->sk_user_data))->mcast_op;
+
+	if (mc_op == PROC_CN_MCAST_IGNORE)
+		return 1;
+
+	return 0;
+}
+
 static inline void send_msg(struct cn_msg *msg)
 {
 	local_lock(&local_event.lock);
@@ -61,7 +76,8 @@ static inline void send_msg(struct cn_msg *msg)
 	 *
 	 * If cn_netlink_send() fails, the data is not sent.
 	 */
-	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_NOWAIT);
+	cn_netlink_send_mult(msg, msg->len, 0, CN_IDX_PROC, GFP_NOWAIT,
+			     cn_filter, NULL);
 
 	local_unlock(&local_event.lock);
 }
@@ -346,11 +362,9 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 static void cn_proc_mcast_ctl(struct cn_msg *msg,
 			      struct netlink_skb_parms *nsp)
 {
-	enum proc_cn_mcast_op *mc_op = NULL;
-	int err = 0;
-
-	if (msg->len != sizeof(*mc_op))
-		return;
+	enum proc_cn_mcast_op mc_op = 0, prev_mc_op = 0;
+	int err = 0, initial = 0;
+	struct sock *sk = NULL;
 
 	/* 
 	 * Events are reported with respect to the initial pid
@@ -367,13 +381,32 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 		goto out;
 	}
 
-	mc_op = (enum proc_cn_mcast_op *)msg->data;
-	switch (*mc_op) {
+	if (msg->len == sizeof(mc_op))
+		mc_op = *((enum proc_cn_mcast_op *)msg->data);
+	else
+		return;
+
+	if (nsp->sk) {
+		sk = nsp->sk;
+		if (sk->sk_user_data == NULL) {
+			sk->sk_user_data = kzalloc(sizeof(struct proc_input),
+						   GFP_KERNEL);
+			initial = 1;
+		} else {
+			prev_mc_op =
+			((struct proc_input *)(sk->sk_user_data))->mcast_op;
+		}
+		((struct proc_input *)(sk->sk_user_data))->mcast_op = mc_op;
+	}
+
+	switch (mc_op) {
 	case PROC_CN_MCAST_LISTEN:
-		atomic_inc(&proc_event_num_listeners);
+		if (initial || (prev_mc_op != PROC_CN_MCAST_LISTEN))
+			atomic_inc(&proc_event_num_listeners);
 		break;
 	case PROC_CN_MCAST_IGNORE:
-		atomic_dec(&proc_event_num_listeners);
+		if (!initial && (prev_mc_op != PROC_CN_MCAST_IGNORE))
+			atomic_dec(&proc_event_num_listeners);
 		break;
 	default:
 		err = EINVAL;
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 48ec7ce6ecac..d1179df2b0ba 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -59,7 +59,9 @@ static int cn_already_initialized;
  * both, or if both are zero then the group is looked up and sent there.
  */
 int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 __group,
-	gfp_t gfp_mask)
+	gfp_t gfp_mask,
+	int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
+	void *filter_data)
 {
 	struct cn_callback_entry *__cbq;
 	unsigned int size;
@@ -110,8 +112,9 @@ int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 __group,
 	NETLINK_CB(skb).dst_group = group;
 
 	if (group)
-		return netlink_broadcast(dev->nls, skb, portid, group,
-					 gfp_mask);
+		return netlink_broadcast_filtered(dev->nls, skb, portid, group,
+						  gfp_mask, filter,
+						  (void *)filter_data);
 	return netlink_unicast(dev->nls, skb, portid,
 			!gfpflags_allow_blocking(gfp_mask));
 }
@@ -121,7 +124,8 @@ EXPORT_SYMBOL_GPL(cn_netlink_send_mult);
 int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group,
 	gfp_t gfp_mask)
 {
-	return cn_netlink_send_mult(msg, msg->len, portid, __group, gfp_mask);
+	return cn_netlink_send_mult(msg, msg->len, portid, __group, gfp_mask,
+				    NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(cn_netlink_send);
 
@@ -162,6 +166,14 @@ static int cn_call_callback(struct sk_buff *skb)
 	return err;
 }
 
+static void cn_release(struct sock *sk, unsigned long *groups)
+{
+	if (groups && test_bit(CN_IDX_PROC - 1, groups)) {
+		kfree(sk->sk_user_data);
+		sk->sk_user_data = NULL;
+	}
+}
+
 /*
  * Main netlink receiving function.
  *
@@ -249,6 +261,7 @@ static int cn_init(void)
 	struct netlink_kernel_cfg cfg = {
 		.groups	= CN_NETLINK_USERS + 0xf,
 		.input	= cn_rx_skb,
+		.release = cn_release,
 	};
 
 	dev->nls = netlink_kernel_create(&init_net, NETLINK_CONNECTOR, &cfg);
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index db110cc442b1..691978cddab7 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -65,7 +65,8 @@ static void w1_unref_block(struct w1_cb_block *block)
 		u16 len = w1_reply_len(block);
 		if (len) {
 			cn_netlink_send_mult(block->first_cn, len,
-				block->portid, 0, GFP_KERNEL);
+					     block->portid, 0,
+					     GFP_KERNEL, NULL, NULL);
 		}
 		kfree(block);
 	}
@@ -83,7 +84,8 @@ static void w1_reply_make_space(struct w1_cb_block *block, u16 space)
 {
 	u16 len = w1_reply_len(block);
 	if (len + space >= block->maxlen) {
-		cn_netlink_send_mult(block->first_cn, len, block->portid, 0, GFP_KERNEL);
+		cn_netlink_send_mult(block->first_cn, len, block->portid,
+				     0, GFP_KERNEL, NULL, NULL);
 		block->first_cn->len = 0;
 		block->cn = NULL;
 		block->msg = NULL;
diff --git a/include/linux/connector.h b/include/linux/connector.h
index 487350bb19c3..cec2d99ae902 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -90,13 +90,19 @@ void cn_del_callback(const struct cb_id *id);
  *		If @group is not zero, then message will be delivered
  *		to the specified group.
  * @gfp_mask:	GFP mask.
+ * @filter:     Filter function to be used at netlink layer.
+ * @filter_data:Filter data to be supplied to the filter function
  *
  * It can be safely called from softirq context, but may silently
  * fail under strong memory pressure.
  *
  * If there are no listeners for given group %-ESRCH can be returned.
  */
-int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 group, gfp_t gfp_mask);
+int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid,
+			 u32 group, gfp_t gfp_mask,
+			 int (*filter)(struct sock *dsk, struct sk_buff *skb,
+				       void *data),
+			 void *filter_data);
 
 /**
  * cn_netlink_send - Sends message to the specified groups.
diff --git a/include/uapi/linux/cn_proc.h b/include/uapi/linux/cn_proc.h
index db210625cee8..6a06fb424313 100644
--- a/include/uapi/linux/cn_proc.h
+++ b/include/uapi/linux/cn_proc.h
@@ -30,6 +30,30 @@ enum proc_cn_mcast_op {
 	PROC_CN_MCAST_IGNORE = 2
 };
 
+enum proc_cn_event {
+	/* Use successive bits so the enums can be used to record
+	 * sets of events as well
+	 */
+	PROC_EVENT_NONE = 0x00000000,
+	PROC_EVENT_FORK = 0x00000001,
+	PROC_EVENT_EXEC = 0x00000002,
+	PROC_EVENT_UID  = 0x00000004,
+	PROC_EVENT_GID  = 0x00000040,
+	PROC_EVENT_SID  = 0x00000080,
+	PROC_EVENT_PTRACE = 0x00000100,
+	PROC_EVENT_COMM = 0x00000200,
+	/* "next" should be 0x00000400 */
+	/* "last" is the last process event: exit,
+	 * while "next to last" is coredumping event
+	 */
+	PROC_EVENT_COREDUMP = 0x40000000,
+	PROC_EVENT_EXIT = 0x80000000
+};
+
+struct proc_input {
+	enum proc_cn_mcast_op mcast_op;
+};
+
 /*
  * From the user's point of view, the process
  * ID is the thread group ID and thread ID is the internal
@@ -44,24 +68,7 @@ enum proc_cn_mcast_op {
  */
 
 struct proc_event {
-	enum what {
-		/* Use successive bits so the enums can be used to record
-		 * sets of events as well
-		 */
-		PROC_EVENT_NONE = 0x00000000,
-		PROC_EVENT_FORK = 0x00000001,
-		PROC_EVENT_EXEC = 0x00000002,
-		PROC_EVENT_UID  = 0x00000004,
-		PROC_EVENT_GID  = 0x00000040,
-		PROC_EVENT_SID  = 0x00000080,
-		PROC_EVENT_PTRACE = 0x00000100,
-		PROC_EVENT_COMM = 0x00000200,
-		/* "next" should be 0x00000400 */
-		/* "last" is the last process event: exit,
-		 * while "next to last" is coredumping event */
-		PROC_EVENT_COREDUMP = 0x40000000,
-		PROC_EVENT_EXIT = 0x80000000
-	} what;
+	enum proc_cn_event what;
 	__u32 cpu;
 	__u64 __attribute__((aligned(8))) timestamp_ns;
 		/* Number of nano seconds since system boot */
-- 
2.40.0


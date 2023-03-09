Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037F06B19EF
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 04:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCIDVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 22:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjCIDUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 22:20:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29247EA04;
        Wed,  8 Mar 2023 19:20:32 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328N48Vx021425;
        Thu, 9 Mar 2023 03:20:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=cctBbQWEDkgLA6hKbfYTWr3NUvCem1a18mBJ5GxPbUA=;
 b=SPDy8TYvXOttIYahMAIIa/Lbv1rYD9wEM4uTtt8l57YS71MvqCOJd/EwhKQRxdusTOTo
 gVwLj7YPIWLZOkG16Z3bdk0EO1IRPYzHBF46Y5gpqOyOGnMLe1+xNhyNc4WPKLEw55Vq
 UrtwADTs3Z0e/gxtajPqIx1L/lztppYFd7VO3fP28jTkQfxvRpy+myDQaA6NpCcVJi3t
 VpxuR75yxf28V3xhCbfRCjQboLQLeDO/7kn7/WSL5SJZcd5yWJ2G1atNxmpeb0oJUiSG
 m/G7qQyz04vjsf+EezwuhMT6dT7cFUysJ/LKj05ametVMPSPRXCXEdXf3ekgCruobor7 Lg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4168sqfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 03:20:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329319SS021712;
        Thu, 9 Mar 2023 03:20:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fr9p50t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 03:20:15 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3293IwmG022200;
        Thu, 9 Mar 2023 03:20:15 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3p6fr9p4pq-6;
        Thu, 09 Mar 2023 03:20:14 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH 5/5] connector/cn_proc: Performance improvements
Date:   Wed,  8 Mar 2023 19:19:53 -0800
Message-Id: <20230309031953.2350213-6-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309031953.2350213-1-anjali.k.kulkarni@oracle.com>
References: <20230309031953.2350213-1-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090025
X-Proofpoint-GUID: 71Xt33UEJiidHBd6MFW0t98Wx3jI_nY9
X-Proofpoint-ORIG-GUID: 71Xt33UEJiidHBd6MFW0t98Wx3jI_nY9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the capability to filter messages sent by the proc
connector on the event type supplied in the message from the client
to the connector. The client can register to listen for an event type
given in struct proc_input. 

The event type supplied by client is stored in the client socket's
sk_user_data field, along with the multicast LISTEN or IGNORE message.

cn_filter function checks to see if the event type being notified via
proc connector matches the event type requested by client, before
sending(matches) or dropping(does not match) a packet.

The patch takes care that existing clients using old mechanism of not
sending the event type work without any changes.

We also add a new event PROC_EVENT_NONZERO_EXIT, which is only sent
by kernel to a listening application when any process exiting has a
non-zero exit status. 

The proc_filter.c test file is updated to reflect the new filtering.

Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
---
 drivers/connector/cn_proc.c     | 56 ++++++++++++++++++++++++++++++---
 include/uapi/linux/cn_proc.h    | 19 +++++++++++
 samples/connector/proc_filter.c | 47 ++++++++++++++++++++++++---
 3 files changed, 113 insertions(+), 9 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 03ba70f07113..d5b2e6f26385 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -50,22 +50,45 @@ static DEFINE_PER_CPU(struct local_event, local_event) = {
 
 int cn_filter(struct sock *dsk, struct sk_buff *skb, void *data)
 {
+	uintptr_t val;
+	__u32 what, exit_code, *ptr;
 	enum proc_cn_mcast_op mc_op;
 
-	if (!dsk)
+	if (!dsk || !data)
 		return 0;
 
+	ptr = (__u32 *)data;
+	what = *ptr++;
+	exit_code = *ptr;
+	val = ((struct proc_input *)(dsk->sk_user_data))->event_type;
 	mc_op = ((struct proc_input *)(dsk->sk_user_data))->mcast_op;
 
 	if (mc_op == PROC_CN_MCAST_IGNORE)
 		return 1;
 
-	return 0;
+	if ((__u32)val == PROC_EVENT_ALL)
+		return 0;
+	/*
+	 * Drop packet if we have to report only non-zero exit status
+	 * (PROC_EVENT_NONZERO_EXIT) and exit status is 0
+	 */
+	if (((__u32)val & PROC_EVENT_NONZERO_EXIT) &&
+	    (what == PROC_EVENT_EXIT)) {
+		if (exit_code)
+			return 0;
+		else
+			return 1;
+	}
+	if ((__u32)val & what)
+		return 0;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(cn_filter);
 
 static inline void send_msg(struct cn_msg *msg)
 {
+	__u32 filter_data[2];
+
 	local_lock(&local_event.lock);
 
 	msg->seq = __this_cpu_inc_return(local_event.count) - 1;
@@ -77,8 +100,15 @@ static inline void send_msg(struct cn_msg *msg)
 	 *
 	 * If cn_netlink_send() fails, the data is not sent.
 	 */
+	filter_data[0] = ((struct proc_event *)msg->data)->what;
+	if (filter_data[0] == PROC_EVENT_EXIT) {
+		filter_data[1] =
+		((struct proc_event *)msg->data)->event_data.exit.exit_code;
+	} else {
+		filter_data[1] = 0;
+	}
 	cn_netlink_send_mult(msg, msg->len, 0, CN_IDX_PROC, GFP_NOWAIT,
-			     cn_filter, NULL);
+			     cn_filter, (void *)filter_data);
 
 	local_unlock(&local_event.lock);
 }
@@ -364,6 +394,8 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 			      struct netlink_skb_parms *nsp)
 {
 	enum proc_cn_mcast_op mc_op = 0, prev_mc_op = 0;
+	struct proc_input *pinput = NULL;
+	enum proc_cn_event ev_type = 0;
 	int err = 0, initial = 0;
 	struct sock *sk = NULL;
 
@@ -376,11 +408,21 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 	    !task_is_in_init_pid_ns(current))
 		return;
 
-	if (msg->len == sizeof(mc_op))
+	if (msg->len == sizeof(*pinput)) {
+		pinput = (struct proc_input *)msg->data;
+		mc_op = pinput->mcast_op;
+		ev_type = pinput->event_type;
+	} else if (msg->len == sizeof(mc_op)) {
 		mc_op = *((enum proc_cn_mcast_op *)msg->data);
-	else
+		ev_type = PROC_EVENT_ALL;
+	} else
 		return;
 
+	ev_type = valid_event((enum proc_cn_event)ev_type);
+
+	if (ev_type == PROC_EVENT_NONE)
+		ev_type = PROC_EVENT_ALL;
+
 	if (nsp->sk) {
 		sk = nsp->sk;
 		if (sk->sk_user_data == NULL) {
@@ -391,6 +433,8 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 			prev_mc_op =
 			((struct proc_input *)(sk->sk_user_data))->mcast_op;
 		}
+		((struct proc_input *)(sk->sk_user_data))->event_type =
+			ev_type;
 		((struct proc_input *)(sk->sk_user_data))->mcast_op = mc_op;
 	}
 
@@ -402,6 +446,8 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 	case PROC_CN_MCAST_IGNORE:
 		if (!initial && (prev_mc_op != PROC_CN_MCAST_IGNORE))
 			atomic_dec(&proc_event_num_listeners);
+		((struct proc_input *)(sk->sk_user_data))->event_type =
+			PROC_EVENT_NONE;
 		break;
 	default:
 		err = EINVAL;
diff --git a/include/uapi/linux/cn_proc.h b/include/uapi/linux/cn_proc.h
index 6a06fb424313..f2afb7cc4926 100644
--- a/include/uapi/linux/cn_proc.h
+++ b/include/uapi/linux/cn_proc.h
@@ -30,6 +30,15 @@ enum proc_cn_mcast_op {
 	PROC_CN_MCAST_IGNORE = 2
 };
 
+#define PROC_EVENT_ALL (PROC_EVENT_FORK | PROC_EVENT_EXEC | PROC_EVENT_UID |  \
+			PROC_EVENT_GID | PROC_EVENT_SID | PROC_EVENT_PTRACE | \
+			PROC_EVENT_COMM | PROC_EVENT_NONZERO_EXIT |           \
+			PROC_EVENT_COREDUMP | PROC_EVENT_EXIT)
+
+/*
+ * If you add an entry in proc_cn_event, make sure you add it in
+ * PROC_EVENT_ALL above as well.
+ */
 enum proc_cn_event {
 	/* Use successive bits so the enums can be used to record
 	 * sets of events as well
@@ -45,15 +54,25 @@ enum proc_cn_event {
 	/* "next" should be 0x00000400 */
 	/* "last" is the last process event: exit,
 	 * while "next to last" is coredumping event
+	 * before that is report only if process dies
+	 * with non-zero exit status
 	 */
+	PROC_EVENT_NONZERO_EXIT = 0x20000000,
 	PROC_EVENT_COREDUMP = 0x40000000,
 	PROC_EVENT_EXIT = 0x80000000
 };
 
 struct proc_input {
 	enum proc_cn_mcast_op mcast_op;
+	enum proc_cn_event event_type;
 };
 
+static inline enum proc_cn_event valid_event(enum proc_cn_event ev_type)
+{
+	ev_type &= PROC_EVENT_ALL;
+	return ev_type;
+}
+
 /*
  * From the user's point of view, the process
  * ID is the thread group ID and thread ID is the internal
diff --git a/samples/connector/proc_filter.c b/samples/connector/proc_filter.c
index 25202f5bc126..63504fc5f002 100644
--- a/samples/connector/proc_filter.c
+++ b/samples/connector/proc_filter.c
@@ -15,22 +15,33 @@
 #include <errno.h>
 #include <signal.h>
 
+#define FILTER
+
+#ifdef FILTER
+#define NL_MESSAGE_SIZE (sizeof(struct nlmsghdr) + sizeof(struct cn_msg) + \
+			 sizeof(struct proc_input))
+#else
 #define NL_MESSAGE_SIZE (sizeof(struct nlmsghdr) + sizeof(struct cn_msg) + \
 			 sizeof(int))
+#endif
 
 #define MAX_EVENTS 1
 
+volatile static int interrupted;
+static int nl_sock, ret_errno, tcount;
+static struct epoll_event evn;
+
 #ifdef ENABLE_PRINTS
 #define Printf printf
 #else
 #define Printf
 #endif
 
-volatile static int interrupted;
-static int nl_sock, ret_errno, tcount;
-static struct epoll_event evn;
-
+#ifdef FILTER
+int send_message(struct proc_input *pinp)
+#else
 int send_message(enum proc_cn_mcast_op mcast_op)
+#endif
 {
 	char buff[NL_MESSAGE_SIZE];
 	struct nlmsghdr *hdr;
@@ -50,8 +61,14 @@ int send_message(enum proc_cn_mcast_op mcast_op)
 	msg->ack = 0;
 	msg->flags = 0;
 
+#ifdef FILTER
+	msg->len = sizeof(struct proc_input);
+	((struct proc_input *)msg->data)->mcast_op = pinp->mcast_op;
+	((struct proc_input *)msg->data)->event_type = pinp->event_type;
+#else
 	msg->len = sizeof(int);
 	*(int *)msg->data = mcast_op;
+#endif
 
 	if (send(nl_sock, hdr, hdr->nlmsg_len, 0) == -1) {
 		ret_errno = errno;
@@ -61,7 +78,11 @@ int send_message(enum proc_cn_mcast_op mcast_op)
 	return 0;
 }
 
+#ifdef FILTER
+int register_proc_netlink(int *efd, struct proc_input *input)
+#else
 int register_proc_netlink(int *efd, enum proc_cn_mcast_op mcast_op)
+#endif
 {
 	struct sockaddr_nl sa_nl;
 	int err = 0, epoll_fd;
@@ -92,7 +113,11 @@ int register_proc_netlink(int *efd, enum proc_cn_mcast_op mcast_op)
 		return -2;
 	}
 
+#ifdef FILTER
+	err = send_message(input);
+#else
 	err = send_message(mcast_op);
+#endif
 	if (err < 0)
 		return err;
 
@@ -223,10 +248,19 @@ int main(int argc, char *argv[])
 {
 	int epoll_fd, err;
 	struct proc_event proc_ev;
+#ifdef FILTER
+	struct proc_input input;
+#endif
 
 	signal(SIGINT, sigint);
 
+#ifdef FILTER
+	input.event_type = PROC_EVENT_NONZERO_EXIT;
+	input.mcast_op = PROC_CN_MCAST_LISTEN;
+	err = register_proc_netlink(&epoll_fd, &input);
+#else
 	err = register_proc_netlink(&epoll_fd, PROC_CN_MCAST_LISTEN);
+#endif
 	if (err < 0) {
 		if (err == -2)
 			close(nl_sock);
@@ -252,7 +286,12 @@ int main(int argc, char *argv[])
 		}
 	}
 
+#ifdef FILTER
+	input.mcast_op = PROC_CN_MCAST_IGNORE;
+	send_message(&input);
+#else
 	send_message(PROC_CN_MCAST_IGNORE);
+#endif
 
 	close(epoll_fd);
 	close(nl_sock);
-- 
2.39.2


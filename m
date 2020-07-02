Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4E621172A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgGBA1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:27:54 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:47387 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbgGBA1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:27:52 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 7E74A891B2;
        Thu,  2 Jul 2020 12:27:48 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1593649668;
        bh=PbG3zai94Ohizr4Q4kemkoNqTWs/ORC9UHU6HKJkVfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=wJqyiUuDNPsQ4b1Lqz1FZRIO0RzVYJXvS2qsiv5ZD+TNSSrZZVrJVdpKMsNah4ioV
         rEqhAdj1fCP1rPV9JjdYUtkY9b6jBLmHQnWbcqq6JqBqGG2y/IkjUwHj5EJchos1cO
         4zbSCUqm9FiYKBzCruHi9R0oV56L4IChRf2Kel8CXImN8JTs6a6XBEoyIUoDMf/Bit
         jfJo2QcGF3aLhU9ErMpOy4RIsWmsiQKJYqPJwgoVhx+GSJAnG5KBJ2P17VINj9L/LM
         K4UeGWX1nGeD724G7A5aGrCTDiIpyKsBBXBXvtygqQWggW8rLSwexDbVstlWLtXtY3
         dRLAFvG1AV3NA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5efd2a030001>; Thu, 02 Jul 2020 12:27:47 +1200
Received: from mattb-dl.ws.atlnz.lc (mattb-dl.ws.atlnz.lc [10.33.25.34])
        by smtp (Postfix) with ESMTP id 4419B13EDDC;
        Thu,  2 Jul 2020 12:27:46 +1200 (NZST)
Received: by mattb-dl.ws.atlnz.lc (Postfix, from userid 1672)
        id C1D7D4A02A3; Thu,  2 Jul 2020 12:27:47 +1200 (NZST)
From:   Matt Bennett <matt.bennett@alliedtelesis.co.nz>
To:     netdev@vger.kernel.org
Cc:     zbr@ioremap.net, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org,
        Matt Bennett <matt.bennett@alliedtelesis.co.nz>
Subject: [PATCH 4/5] connector: Prepare for supporting multiple namespaces
Date:   Thu,  2 Jul 2020 12:26:34 +1200
Message-Id: <20200702002635.8169-5-matt.bennett@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the existing function definitions / call sites to start
passing the network namespace. For now we still only pass the
default namespace.

Signed-off-by: Matt Bennett <matt.bennett@alliedtelesis.co.nz>
---
 Documentation/driver-api/connector.rst |  6 +++---
 drivers/connector/cn_proc.c            |  5 +++--
 drivers/connector/cn_queue.c           |  5 +++--
 drivers/connector/connector.c          | 21 ++++++++++++---------
 drivers/hv/hv_utils_transport.c        |  6 ++++--
 drivers/md/dm-log-userspace-transfer.c |  6 ++++--
 drivers/video/fbdev/uvesafb.c          |  8 +++++---
 drivers/w1/w1_netlink.c                | 19 +++++++++++--------
 include/linux/connector.h              | 24 ++++++++++++++++--------
 samples/connector/cn_test.c            |  6 ++++--
 10 files changed, 65 insertions(+), 41 deletions(-)

diff --git a/Documentation/driver-api/connector.rst b/Documentation/drive=
r-api/connector.rst
index c100c7482289..4fb1f73d76ad 100644
--- a/Documentation/driver-api/connector.rst
+++ b/Documentation/driver-api/connector.rst
@@ -25,9 +25,9 @@ handling, etc...  The Connector driver allows any kerne=
lspace agents to use
 netlink based networking for inter-process communication in a significan=
tly
 easier way::
=20
-  int cn_add_callback(struct cb_id *id, char *name, void (*callback) (st=
ruct cn_msg *, struct netlink_skb_parms *));
-  void cn_netlink_send_multi(struct cn_msg *msg, u16 len, u32 portid, u3=
2 __group, int gfp_mask);
-  void cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group, int =
gfp_mask);
+  int cn_add_callback(struct cb_id *id, char *name, void (*callback) (st=
ruct net *, struct cn_msg *, struct netlink_skb_parms *));
+  void cn_netlink_send_multi(struct net *net, struct cn_msg *msg, u16 le=
n, u32 portid, u32 __group, int gfp_mask);
+  void cn_netlink_send(struct net *net, struct cn_msg *msg, u32 portid, =
u32 __group, int gfp_mask);
=20
   struct cb_id
   {
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index d90aea555a21..9202be177a30 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -16,6 +16,7 @@
 #include <linux/ptrace.h>
 #include <linux/atomic.h>
 #include <linux/pid_namespace.h>
+#include <net/net_namespace.h>
=20
 #include <linux/cn_proc.h>
 #include <linux/local_lock.h>
@@ -61,7 +62,7 @@ static inline void send_msg(struct cn_msg *msg)
 	 *
 	 * If cn_netlink_send() fails, the data is not sent.
 	 */
-	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_NOWAIT);
+	cn_netlink_send(&init_net, msg, 0, CN_IDX_PROC, GFP_NOWAIT);
=20
 	local_unlock(&local_event.lock);
 }
@@ -343,7 +344,7 @@ static void cn_proc_ack(int err, int rcvd_seq, int rc=
vd_ack)
  * cn_proc_mcast_ctl
  * @data: message sent from userspace via the connector
  */
-static void cn_proc_mcast_ctl(struct cn_msg *msg,
+static void cn_proc_mcast_ctl(struct net *net, struct cn_msg *msg,
 			      struct netlink_skb_parms *nsp)
 {
 	enum proc_cn_mcast_op *mc_op =3D NULL;
diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index a82ceeb37f26..22fdd2b149af 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -16,11 +16,12 @@
 #include <linux/suspend.h>
 #include <linux/connector.h>
 #include <linux/delay.h>
+#include <net/net_namespace.h>
=20
 static struct cn_callback_entry *
 cn_queue_alloc_callback_entry(struct cn_queue_dev *dev, const char *name=
,
 			      struct cb_id *id,
-			      void (*callback)(struct cn_msg *,
+			      void (*callback)(struct net *, struct cn_msg *,
 					       struct netlink_skb_parms *))
 {
 	struct cn_callback_entry *cbq;
@@ -58,7 +59,7 @@ int cn_cb_equal(struct cb_id *i1, struct cb_id *i2)
=20
 int cn_queue_add_callback(struct cn_queue_dev *dev, const char *name,
 			  struct cb_id *id,
-			  void (*callback)(struct cn_msg *,
+			  void (*callback)(struct net *, struct cn_msg *,
 					   struct netlink_skb_parms *))
 {
 	struct cn_callback_entry *cbq, *__cbq;
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.=
c
index 2d22d6bf52f2..82fcaa4d8be3 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -58,8 +58,8 @@ static int cn_already_initialized;
  * The message is sent to, the portid if given, the group if given, both=
 if
  * both, or if both are zero then the group is looked up and sent there.
  */
-int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 __=
group,
-	gfp_t gfp_mask)
+int cn_netlink_send_mult(struct net *net, struct cn_msg *msg, u16 len,
+			 u32 portid, u32 __group, gfp_t gfp_mask)
 {
 	struct cn_callback_entry *__cbq;
 	unsigned int size;
@@ -118,17 +118,18 @@ int cn_netlink_send_mult(struct cn_msg *msg, u16 le=
n, u32 portid, u32 __group,
 EXPORT_SYMBOL_GPL(cn_netlink_send_mult);
=20
 /* same as cn_netlink_send_mult except msg->len is used for len */
-int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group,
-	gfp_t gfp_mask)
+int cn_netlink_send(struct net *net, struct cn_msg *msg, u32 portid,
+		    u32 __group, gfp_t gfp_mask)
 {
-	return cn_netlink_send_mult(msg, msg->len, portid, __group, gfp_mask);
+	return cn_netlink_send_mult(net, msg, msg->len, portid, __group,
+				    gfp_mask);
 }
 EXPORT_SYMBOL_GPL(cn_netlink_send);
=20
 /*
  * Callback helper - queues work and setup destructor for given data.
  */
-static int cn_call_callback(struct sk_buff *skb)
+static int cn_call_callback(struct net *net, struct sk_buff *skb)
 {
 	struct nlmsghdr *nlh;
 	struct cn_callback_entry *i, *cbq =3D NULL;
@@ -153,7 +154,7 @@ static int cn_call_callback(struct sk_buff *skb)
 	spin_unlock_bh(&dev->cbdev->queue_lock);
=20
 	if (cbq !=3D NULL) {
-		cbq->callback(msg, nsp);
+		cbq->callback(net, msg, nsp);
 		kfree_skb(skb);
 		cn_queue_release_callback(cbq);
 		err =3D 0;
@@ -172,6 +173,8 @@ static void cn_rx_skb(struct sk_buff *skb)
 	struct nlmsghdr *nlh;
 	int len, err;
=20
+	struct net *net =3D sock_net(skb->sk);
+
 	if (skb->len >=3D NLMSG_HDRLEN) {
 		nlh =3D nlmsg_hdr(skb);
 		len =3D nlmsg_len(nlh);
@@ -181,7 +184,7 @@ static void cn_rx_skb(struct sk_buff *skb)
 		    len > CONNECTOR_MAX_MSG_SIZE)
 			return;
=20
-		err =3D cn_call_callback(skb_get(skb));
+		err =3D cn_call_callback(net, skb_get(skb));
 		if (err < 0)
 			kfree_skb(skb);
 	}
@@ -194,7 +197,7 @@ static void cn_rx_skb(struct sk_buff *skb)
  * May sleep.
  */
 int cn_add_callback(struct cb_id *id, const char *name,
-		    void (*callback)(struct cn_msg *,
+		    void (*callback)(struct net *, struct cn_msg *,
 				     struct netlink_skb_parms *))
 {
 	int err;
diff --git a/drivers/hv/hv_utils_transport.c b/drivers/hv/hv_utils_transp=
ort.c
index eb2833d2b5d0..1a67efe59e91 100644
--- a/drivers/hv/hv_utils_transport.c
+++ b/drivers/hv/hv_utils_transport.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/poll.h>
+#include <net/net_namespace.h>
=20
 #include "hyperv_vmbus.h"
 #include "hv_utils_transport.h"
@@ -181,7 +182,8 @@ static int hvt_op_release(struct inode *inode, struct=
 file *file)
 	return 0;
 }
=20
-static void hvt_cn_callback(struct cn_msg *msg, struct netlink_skb_parms=
 *nsp)
+static void hvt_cn_callback(struct net *net, struct cn_msg *msg,
+			    struct netlink_skb_parms *nsp)
 {
 	struct hvutil_transport *hvt, *hvt_found =3D NULL;
=20
@@ -231,7 +233,7 @@ int hvutil_transport_send(struct hvutil_transport *hv=
t, void *msg, int len,
 		cn_msg->id.val =3D hvt->cn_id.val;
 		cn_msg->len =3D len;
 		memcpy(cn_msg->data, msg, len);
-		ret =3D cn_netlink_send(cn_msg, 0, 0, GFP_ATOMIC);
+		ret =3D cn_netlink_send(&init_net, cn_msg, 0, 0, GFP_ATOMIC);
 		kfree(cn_msg);
 		/*
 		 * We don't know when netlink messages are delivered but unlike
diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-u=
serspace-transfer.c
index fdf8ec304f8d..0e835acf14da 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -12,6 +12,7 @@
 #include <linux/connector.h>
 #include <linux/device-mapper.h>
 #include <linux/dm-log-userspace.h>
+#include <net/net_namespace.h>
=20
 #include "dm-log-userspace-transfer.h"
=20
@@ -66,7 +67,7 @@ static int dm_ulog_sendto_server(struct dm_ulog_request=
 *tfr)
 	msg->seq =3D tfr->seq;
 	msg->len =3D sizeof(struct dm_ulog_request) + tfr->data_size;
=20
-	r =3D cn_netlink_send(msg, 0, 0, gfp_any());
+	r =3D cn_netlink_send(&init_net, msg, 0, 0, gfp_any());
=20
 	return r;
 }
@@ -130,7 +131,8 @@ static int fill_pkg(struct cn_msg *msg, struct dm_ulo=
g_request *tfr)
  * This is the connector callback that delivers data
  * that was sent from userspace.
  */
-static void cn_ulog_callback(struct cn_msg *msg, struct netlink_skb_parm=
s *nsp)
+static void cn_ulog_callback(struct net *net, struct cn_msg *msg,
+			     struct netlink_skb_parms *nsp)
 {
 	struct dm_ulog_request *tfr =3D (struct dm_ulog_request *)(msg + 1);
=20
diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.=
c
index def14ac0ebe1..f9b6ed7b97f2 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <video/edid.h>
 #include <video/uvesafb.h>
+#include <net/net_namespace.h>
 #ifdef CONFIG_X86
 #include <video/vga.h>
 #endif
@@ -69,7 +70,8 @@ static DEFINE_MUTEX(uvfb_lock);
  * find the kernel part of the task struct, copy the registers and
  * the buffer contents and then complete the task.
  */
-static void uvesafb_cn_callback(struct cn_msg *msg, struct netlink_skb_p=
arms *nsp)
+static void uvesafb_cn_callback(struct net *net, struct cn_msg *msg,
+				struct netlink_skb_parms *nsp)
 {
 	struct uvesafb_task *utask;
 	struct uvesafb_ktask *task;
@@ -194,7 +196,7 @@ static int uvesafb_exec(struct uvesafb_ktask *task)
 	uvfb_tasks[seq] =3D task;
 	mutex_unlock(&uvfb_lock);
=20
-	err =3D cn_netlink_send(m, 0, 0, GFP_KERNEL);
+	err =3D cn_netlink_send(&init_net, m, 0, 0, GFP_KERNEL);
 	if (err =3D=3D -ESRCH) {
 		/*
 		 * Try to start the userspace helper if sending
@@ -206,7 +208,7 @@ static int uvesafb_exec(struct uvesafb_ktask *task)
 			pr_err("make sure that the v86d helper is installed and executable\n"=
);
 		} else {
 			v86d_started =3D 1;
-			err =3D cn_netlink_send(m, 0, 0, gfp_any());
+			err =3D cn_netlink_send(&init_net, m, 0, 0, gfp_any());
 			if (err =3D=3D -ENOBUFS)
 				err =3D 0;
 		}
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index fa490aa4407c..246844b61613 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -7,6 +7,7 @@
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
 #include <linux/connector.h>
+#include <net/net_namespace.h>
=20
 #include "w1_internal.h"
 #include "w1_netlink.h"
@@ -64,8 +65,8 @@ static void w1_unref_block(struct w1_cb_block *block)
 	if (atomic_sub_return(1, &block->refcnt) =3D=3D 0) {
 		u16 len =3D w1_reply_len(block);
 		if (len) {
-			cn_netlink_send_mult(block->first_cn, len,
-				block->portid, 0, GFP_KERNEL);
+			cn_netlink_send_mult(&init_net, block->first_cn, len,
+					     block->portid, 0, GFP_KERNEL);
 		}
 		kfree(block);
 	}
@@ -83,7 +84,8 @@ static void w1_reply_make_space(struct w1_cb_block *blo=
ck, u16 space)
 {
 	u16 len =3D w1_reply_len(block);
 	if (len + space >=3D block->maxlen) {
-		cn_netlink_send_mult(block->first_cn, len, block->portid, 0, GFP_KERNE=
L);
+		cn_netlink_send_mult(&init_net, block->first_cn, len,
+				     block->portid, 0, GFP_KERNEL);
 		block->first_cn->len =3D 0;
 		block->cn =3D NULL;
 		block->msg =3D NULL;
@@ -201,7 +203,7 @@ static void w1_netlink_send_error(struct cn_msg *cn, =
struct w1_netlink_msg *msg,
 	packet.cn.len =3D sizeof(packet.msg);
 	packet.msg.len =3D 0;
 	packet.msg.status =3D (u8)-error;
-	cn_netlink_send(&packet.cn, portid, 0, GFP_KERNEL);
+	cn_netlink_send(&init_net, &packet.cn, portid, 0, GFP_KERNEL);
 }
=20
 /**
@@ -228,7 +230,7 @@ void w1_netlink_send(struct w1_master *dev, struct w1=
_netlink_msg *msg)
 	memcpy(&packet.msg, msg, sizeof(*msg));
 	packet.msg.len =3D 0;
=20
-	cn_netlink_send(&packet.cn, 0, 0, GFP_KERNEL);
+	cn_netlink_send(&init_net, &packet.cn, 0, 0, GFP_KERNEL);
 }
=20
 static void w1_send_slave(struct w1_master *dev, u64 rn)
@@ -421,7 +423,7 @@ static int w1_process_command_root(struct cn_msg *req=
_cn, u32 portid)
 	mutex_lock(&w1_mlock);
 	list_for_each_entry(dev, &w1_masters, w1_master_entry) {
 		if (cn->len + sizeof(*id) > PAGE_SIZE - sizeof(struct cn_msg)) {
-			cn_netlink_send(cn, portid, 0, GFP_KERNEL);
+			cn_netlink_send(&init_net, cn, portid, 0, GFP_KERNEL);
 			cn->len =3D sizeof(struct w1_netlink_msg);
 			msg->len =3D 0;
 			id =3D (u32 *)msg->data;
@@ -432,7 +434,7 @@ static int w1_process_command_root(struct cn_msg *req=
_cn, u32 portid)
 		cn->len +=3D sizeof(*id);
 		id++;
 	}
-	cn_netlink_send(cn, portid, 0, GFP_KERNEL);
+	cn_netlink_send(&init_net, cn, portid, 0, GFP_KERNEL);
 	mutex_unlock(&w1_mlock);
=20
 	kfree(cn);
@@ -532,7 +534,8 @@ static void w1_list_count_cmds(struct w1_netlink_msg =
*msg, int *cmd_count,
 	}
 }
=20
-static void w1_cn_callback(struct cn_msg *cn, struct netlink_skb_parms *=
nsp)
+static void w1_cn_callback(struct net *net, struct cn_msg *cn,
+			   struct netlink_skb_parms *nsp)
 {
 	struct w1_netlink_msg *msg =3D (struct w1_netlink_msg *)(cn + 1);
 	struct w1_slave *sl;
diff --git a/include/linux/connector.h b/include/linux/connector.h
index cb732643471b..8e9385eb18f8 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -40,7 +40,8 @@ struct cn_callback_entry {
 	struct cn_queue_dev *pdev;
=20
 	struct cn_callback_id id;
-	void (*callback) (struct cn_msg *, struct netlink_skb_parms *);
+	void (*callback)(struct net *, struct cn_msg *,
+			 struct netlink_skb_parms *);
=20
 	u32 seq, group;
 };
@@ -62,10 +63,12 @@ struct cn_dev {
  *		in-kernel users.
  * @name:	connector's callback symbolic name.
  * @callback:	connector's callback.
- * 		parameters are %cn_msg and the sender's credentials
+ *		parameters are network namespace, %cn_msg and
+ *		the sender's credentials
  */
 int cn_add_callback(struct cb_id *id, const char *name,
-		    void (*callback)(struct cn_msg *, struct netlink_skb_parms *));
+		    void (*callback)(struct net *, struct cn_msg *,
+				     struct netlink_skb_parms *));
 /**
  * cn_del_callback() - Unregisters new callback with connector core.
  *
@@ -75,8 +78,9 @@ void cn_del_callback(struct cb_id *id);
=20
=20
 /**
- * cn_netlink_send_mult - Sends message to the specified groups.
+ * cn_netlink_send_mult - Sends messages to the specified groups.
  *
+ * @net:	network namespace
  * @msg: 	message header(with attached data).
  * @len:	Number of @msg to be sent.
  * @portid:	destination port.
@@ -96,11 +100,13 @@ void cn_del_callback(struct cb_id *id);
  *
  * If there are no listeners for given group %-ESRCH can be returned.
  */
-int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 gr=
oup, gfp_t gfp_mask);
+int cn_netlink_send_mult(struct net *net, struct cn_msg *msg, u16 len,
+			 u32 portid, u32 group, gfp_t gfp_mask);
=20
 /**
- * cn_netlink_send_mult - Sends message to the specified groups.
+ * cn_netlink_send - Sends message to the specified groups.
  *
+ * @net:	network namespace
  * @msg:	message header(with attached data).
  * @portid:	destination port.
  *		If non-zero the message will be sent to the given port,
@@ -119,11 +125,13 @@ int cn_netlink_send_mult(struct cn_msg *msg, u16 le=
n, u32 portid, u32 group, gfp
  *
  * If there are no listeners for given group %-ESRCH can be returned.
  */
-int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 group, gfp_t gfp=
_mask);
+int cn_netlink_send(struct net *net, struct cn_msg *msg, u32 portid, u32=
 group,
+		    gfp_t gfp_mask);
=20
 int cn_queue_add_callback(struct cn_queue_dev *dev, const char *name,
 			  struct cb_id *id,
-			  void (*callback)(struct cn_msg *, struct netlink_skb_parms *));
+			  void (*callback)(struct net *, struct cn_msg *,
+					   struct netlink_skb_parms *));
 void cn_queue_del_callback(struct cn_queue_dev *dev, struct cb_id *id);
 void cn_queue_release_callback(struct cn_callback_entry *);
=20
diff --git a/samples/connector/cn_test.c b/samples/connector/cn_test.c
index 0958a171d048..9eaf40bbd714 100644
--- a/samples/connector/cn_test.c
+++ b/samples/connector/cn_test.c
@@ -16,13 +16,15 @@
 #include <linux/timer.h>
=20
 #include <linux/connector.h>
+#include <net/net_namespace.h>
=20
 static struct cb_id cn_test_id =3D { CN_NETLINK_USERS + 3, 0x456 };
 static char cn_test_name[] =3D "cn_test";
 static struct sock *nls;
 static struct timer_list cn_test_timer;
=20
-static void cn_test_callback(struct cn_msg *msg, struct netlink_skb_parm=
s *nsp)
+static void cn_test_callback(struct net *net, struct cn_msg *msg,
+			     struct netlink_skb_parms *nsp)
 {
 	pr_info("%s: %lu: idx=3D%x, val=3D%x, seq=3D%u, ack=3D%u, len=3D%d: %s.=
\n",
 	        __func__, jiffies, msg->id.idx, msg->id.val,
@@ -132,7 +134,7 @@ static void cn_test_timer_func(struct timer_list *unu=
sed)
=20
 		memcpy(m + 1, data, m->len);
=20
-		cn_netlink_send(m, 0, 0, GFP_ATOMIC);
+		cn_netlink_send(&init_net, m, 0, 0, GFP_ATOMIC);
 		kfree(m);
 	}
=20
--=20
2.27.0


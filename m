Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798CD211728
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgGBA15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:27:57 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:47390 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbgGBA1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:27:55 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 71F9D891B1;
        Thu,  2 Jul 2020 12:27:48 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1593649668;
        bh=cKZK0oZ+9VJXdiISqhSuGIRNylTJNp79SGvvvDuiK4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=NsJMGjkCgUOE6SQ34PJpQwERX8fZYMX+HyPsndQUQhQrHrulmIrRNI6SEAGMjU0fO
         QysjQ/TUSTbJjKtVduWc4KNql8bCOULftj7o2Tpd/EsUXVpSvFy2GnoOtDuaGNsAKw
         r/7Bo/i0tE+LeYLvD4lvRJmFSotrCf3v9IYq28ParTw8rpzoE18gljCuOXP4BOXKD5
         hfTeVUNdxR9v8SDP01HT2SsWvtGtv4jMkLQP3fAnUyXidfA9T2wZ6J5GyNJdGwz0Su
         w+cFIgdNTcJH0UatPVdj6AyHPCJgCGp1S4Q77xESVIriHlR+aqrsMwWXVPREEwwdgp
         nnTeqy7akIg6w==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5efd2a040000>; Thu, 02 Jul 2020 12:27:48 +1200
Received: from mattb-dl.ws.atlnz.lc (mattb-dl.ws.atlnz.lc [10.33.25.34])
        by smtp (Postfix) with ESMTP id BF6D913EDDC;
        Thu,  2 Jul 2020 12:27:46 +1200 (NZST)
Received: by mattb-dl.ws.atlnz.lc (Postfix, from userid 1672)
        id 493534A02A3; Thu,  2 Jul 2020 12:27:48 +1200 (NZST)
From:   Matt Bennett <matt.bennett@alliedtelesis.co.nz>
To:     netdev@vger.kernel.org
Cc:     zbr@ioremap.net, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org,
        Matt Bennett <matt.bennett@alliedtelesis.co.nz>
Subject: [PATCH 5/5] connector: Create connector per namespace
Date:   Thu,  2 Jul 2020 12:26:35 +1200
Message-Id: <20200702002635.8169-6-matt.bennett@alliedtelesis.co.nz>
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

Move to storing the connector instance per network namespace. In doing
so the ability to use the connector functionality outside the default
namespace is now available.

Signed-off-by: Matt Bennett <matt.bennett@alliedtelesis.co.nz>
---
 drivers/connector/cn_proc.c   |  49 ++++++----
 drivers/connector/connector.c | 171 ++++++++++++++++++++++++++++------
 drivers/hv/hv_fcopy.c         |   1 +
 include/linux/connector.h     |  14 ++-
 include/net/net_namespace.h   |   4 +
 kernel/exit.c                 |   2 +-
 6 files changed, 190 insertions(+), 51 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 9202be177a30..661d921fd146 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -17,6 +17,7 @@
 #include <linux/atomic.h>
 #include <linux/pid_namespace.h>
 #include <net/net_namespace.h>
+#include <linux/netlink.h>
=20
 #include <linux/cn_proc.h>
 #include <linux/local_lock.h>
@@ -37,7 +38,6 @@ static inline struct cn_msg *buffer_to_cn_msg(__u8 *buf=
fer)
 	return (struct cn_msg *)(buffer + 4);
 }
=20
-static atomic_t proc_event_num_listeners =3D ATOMIC_INIT(0);
 static struct cb_id cn_proc_event_id =3D { CN_IDX_PROC, CN_VAL_PROC };
=20
 /* local_event.count is used as the sequence number of the netlink messa=
ge */
@@ -51,6 +51,9 @@ static DEFINE_PER_CPU(struct local_event, local_event) =
=3D {
=20
 static inline void send_msg(struct cn_msg *msg)
 {
+	int ret =3D 0;
+	struct net *net =3D current->nsproxy->net_ns;
+
 	local_lock(&local_event.lock);
=20
 	msg->seq =3D __this_cpu_inc_return(local_event.count) - 1;
@@ -62,7 +65,9 @@ static inline void send_msg(struct cn_msg *msg)
 	 *
 	 * If cn_netlink_send() fails, the data is not sent.
 	 */
-	cn_netlink_send(&init_net, msg, 0, CN_IDX_PROC, GFP_NOWAIT);
+	ret =3D cn_netlink_send(net, msg, 0, CN_IDX_PROC, GFP_NOWAIT);
+	if (ret =3D=3D -ESRCH && netlink_has_listeners(net->cdev.nls, CN_IDX_PR=
OC) =3D=3D 0)
+		atomic_set(&(net->cdev.proc_event_num_listeners), 0);
=20
 	local_unlock(&local_event.lock);
 }
@@ -73,8 +78,9 @@ void proc_fork_connector(struct task_struct *task)
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 	struct task_struct *parent;
+	struct net *net =3D current->nsproxy->net_ns;
=20
-	if (atomic_read(&proc_event_num_listeners) < 1)
+	if (atomic_read(&(net->cdev.proc_event_num_listeners)) < 1)
 		return;
=20
 	msg =3D buffer_to_cn_msg(buffer);
@@ -102,8 +108,9 @@ void proc_exec_connector(struct task_struct *task)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
+	struct net *net =3D current->nsproxy->net_ns;
=20
-	if (atomic_read(&proc_event_num_listeners) < 1)
+	if (atomic_read(&(net->cdev.proc_event_num_listeners)) < 1)
 		return;
=20
 	msg =3D buffer_to_cn_msg(buffer);
@@ -127,8 +134,9 @@ void proc_id_connector(struct task_struct *task, int =
which_id)
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 	const struct cred *cred;
+	struct net *net =3D current->nsproxy->net_ns;
=20
-	if (atomic_read(&proc_event_num_listeners) < 1)
+	if (atomic_read(&(net->cdev.proc_event_num_listeners)) < 1)
 		return;
=20
 	msg =3D buffer_to_cn_msg(buffer);
@@ -164,8 +172,9 @@ void proc_sid_connector(struct task_struct *task)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
+	struct net *net =3D current->nsproxy->net_ns;
=20
-	if (atomic_read(&proc_event_num_listeners) < 1)
+	if (atomic_read(&(net->cdev.proc_event_num_listeners)) < 1)
 		return;
=20
 	msg =3D buffer_to_cn_msg(buffer);
@@ -188,8 +197,9 @@ void proc_ptrace_connector(struct task_struct *task, =
int ptrace_id)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
+	struct net *net =3D current->nsproxy->net_ns;
=20
-	if (atomic_read(&proc_event_num_listeners) < 1)
+	if (atomic_read(&(net->cdev.proc_event_num_listeners)) < 1)
 		return;
=20
 	msg =3D buffer_to_cn_msg(buffer);
@@ -220,8 +230,9 @@ void proc_comm_connector(struct task_struct *task)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
+	struct net *net =3D current->nsproxy->net_ns;
=20
-	if (atomic_read(&proc_event_num_listeners) < 1)
+	if (atomic_read(&(net->cdev.proc_event_num_listeners)) < 1)
 		return;
=20
 	msg =3D buffer_to_cn_msg(buffer);
@@ -246,8 +257,9 @@ void proc_coredump_connector(struct task_struct *task=
)
 	struct proc_event *ev;
 	struct task_struct *parent;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
+	struct net *net =3D current->nsproxy->net_ns;
=20
-	if (atomic_read(&proc_event_num_listeners) < 1)
+	if (atomic_read(&(net->cdev.proc_event_num_listeners)) < 1)
 		return;
=20
 	msg =3D buffer_to_cn_msg(buffer);
@@ -279,8 +291,9 @@ void proc_exit_connector(struct task_struct *task)
 	struct proc_event *ev;
 	struct task_struct *parent;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
+	struct net *net =3D current->nsproxy->net_ns;
=20
-	if (atomic_read(&proc_event_num_listeners) < 1)
+	if (atomic_read(&(net->cdev.proc_event_num_listeners)) < 1)
 		return;
=20
 	msg =3D buffer_to_cn_msg(buffer);
@@ -321,8 +334,9 @@ static void cn_proc_ack(int err, int rcvd_seq, int rc=
vd_ack)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
+	struct net *net =3D current->nsproxy->net_ns;
=20
-	if (atomic_read(&proc_event_num_listeners) < 1)
+	if (atomic_read(&(net->cdev.proc_event_num_listeners)) < 1)
 		return;
=20
 	msg =3D buffer_to_cn_msg(buffer);
@@ -353,13 +367,10 @@ static void cn_proc_mcast_ctl(struct net *net, stru=
ct cn_msg *msg,
 	if (msg->len !=3D sizeof(*mc_op))
 		return;
=20
-	/*=20
-	 * Events are reported with respect to the initial pid
-	 * and user namespaces so ignore requestors from
-	 * other namespaces.
+	/*
+	 * Events are reported with respect to network namespaces.
 	 */
-	if ((current_user_ns() !=3D &init_user_ns) ||
-	    (task_active_pid_ns(current) !=3D &init_pid_ns))
+	if (current->nsproxy->net_ns !=3D net)
 		return;
=20
 	/* Can only change if privileged. */
@@ -371,10 +382,10 @@ static void cn_proc_mcast_ctl(struct net *net, stru=
ct cn_msg *msg,
 	mc_op =3D (enum proc_cn_mcast_op *)msg->data;
 	switch (*mc_op) {
 	case PROC_CN_MCAST_LISTEN:
-		atomic_inc(&proc_event_num_listeners);
+		atomic_inc(&(net->cdev.proc_event_num_listeners));
 		break;
 	case PROC_CN_MCAST_IGNORE:
-		atomic_dec(&proc_event_num_listeners);
+		atomic_dec(&(net->cdev.proc_event_num_listeners));
 		break;
 	default:
 		err =3D EINVAL;
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.=
c
index 82fcaa4d8be3..30efcf39751f 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -26,9 +26,7 @@ MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Generic userspace <-> kernelspace connector.");
 MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_CONNECTOR);
=20
-static struct cn_dev cdev;
-
-static int cn_already_initialized;
+static DEFINE_MUTEX(cn_mutex);
=20
 /*
  * Sends mult (multiple) cn_msg at a time.
@@ -66,10 +64,13 @@ int cn_netlink_send_mult(struct net *net, struct cn_m=
sg *msg, u16 len,
 	struct sk_buff *skb;
 	struct nlmsghdr *nlh;
 	struct cn_msg *data;
-	struct cn_dev *dev =3D &cdev;
+	struct cn_dev *dev =3D &(net->cdev);
 	u32 group =3D 0;
 	int found =3D 0;
=20
+	if (!msg || len < 0)
+		return -EINVAL;
+
 	if (portid || __group) {
 		group =3D __group;
 	} else {
@@ -133,7 +134,7 @@ static int cn_call_callback(struct net *net, struct s=
k_buff *skb)
 {
 	struct nlmsghdr *nlh;
 	struct cn_callback_entry *i, *cbq =3D NULL;
-	struct cn_dev *dev =3D &cdev;
+	struct cn_dev *dev =3D &net->cdev;
 	struct cn_msg *msg =3D nlmsg_data(nlmsg_hdr(skb));
 	struct netlink_skb_parms *nsp =3D &NETLINK_CB(skb);
 	int err =3D -ENODEV;
@@ -168,7 +169,7 @@ static int cn_call_callback(struct net *net, struct s=
k_buff *skb)
  *
  * It checks skb, netlink header and msg sizes, and calls callback helpe=
r.
  */
-static void cn_rx_skb(struct sk_buff *skb)
+static void __cn_rx_skb(struct sk_buff *skb)
 {
 	struct nlmsghdr *nlh;
 	int len, err;
@@ -190,6 +191,13 @@ static void cn_rx_skb(struct sk_buff *skb)
 	}
 }
=20
+static void cn_rx_skb(struct sk_buff *skb)
+{
+	mutex_lock(&cn_mutex);
+	__cn_rx_skb(skb);
+	mutex_unlock(&cn_mutex);
+}
+
 /*
  * Callback add routing - adds callback with given ID and name.
  * If there is registered callback with the same ID it will not be added=
.
@@ -200,20 +208,47 @@ int cn_add_callback(struct cb_id *id, const char *n=
ame,
 		    void (*callback)(struct net *, struct cn_msg *,
 				     struct netlink_skb_parms *))
 {
-	int err;
-	struct cn_dev *dev =3D &cdev;
-
-	if (!cn_already_initialized)
-		return -EAGAIN;
+	int err =3D -EINVAL;
+	struct net *net =3D NULL;
+	struct cn_dev *dev =3D NULL;
=20
-	err =3D cn_queue_add_callback(dev->cbdev, name, id, callback);
-	if (err)
+	if (!id || !name || !callback)
 		return err;
=20
-	return 0;
+	down_read(&net_rwsem);
+	for_each_net(net) {
+		dev =3D &net->cdev;
+		err =3D cn_queue_add_callback(dev->cbdev, name, id, callback);
+		if (err)
+			break;
+	}
+
+	if (err) {
+		for_each_net(net) {
+			dev =3D &net->cdev;
+			cn_queue_del_callback(dev->cbdev, id);
+		}
+	}
+	up_read(&net_rwsem);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(cn_add_callback);
=20
+int cn_add_callback_one(struct net *net, struct cb_id *id, const char *n=
ame,
+			void (*callback)(struct net *, struct cn_msg *,
+					 struct netlink_skb_parms *))
+{
+	struct cn_dev *dev =3D NULL;
+
+	if (!net || !id || !name || !callback)
+		return -EINVAL;
+
+	dev =3D &(net->cdev);
+	return cn_queue_add_callback(dev->cbdev, name, id, callback);
+}
+EXPORT_SYMBOL_GPL(cn_add_callback_one);
+
 /*
  * Callback remove routing - removes callback
  * with given ID.
@@ -224,15 +259,25 @@ EXPORT_SYMBOL_GPL(cn_add_callback);
  */
 void cn_del_callback(struct cb_id *id)
 {
-	struct cn_dev *dev =3D &cdev;
+	struct net *net =3D NULL;
+	struct cn_dev *dev =3D NULL;
+
+	if (!id)
+		return;
=20
-	cn_queue_del_callback(dev->cbdev, id);
+	down_read(&net_rwsem);
+	for_each_net(net) {
+		dev =3D &net->cdev;
+		cn_queue_del_callback(dev->cbdev, id);
+	}
+	up_read(&net_rwsem);
 }
 EXPORT_SYMBOL_GPL(cn_del_callback);
=20
 static int __maybe_unused cn_proc_show(struct seq_file *m, void *v)
 {
-	struct cn_queue_dev *dev =3D cdev.cbdev;
+	struct net *net =3D seq_file_single_net(m);
+	struct cn_queue_dev *dev =3D net->cdev.cbdev;
 	struct cn_callback_entry *cbq;
=20
 	seq_printf(m, "Name            ID\n");
@@ -251,15 +296,62 @@ static int __maybe_unused cn_proc_show(struct seq_f=
ile *m, void *v)
 	return 0;
 }
=20
-static int cn_init(void)
+static int init_cn_net(struct net *net)
+{
+	int ret =3D 0;
+	struct cn_dev *init_dev =3D &(init_net.cdev);
+	struct cn_queue_dev *cbdev =3D init_dev->cbdev;
+
+	struct cn_callback_entry *cbq =3D NULL;
+	struct cn_callback_entry_ex *cbq_ex =3D NULL;
+	struct cn_callback_entry_ex *tmp =3D NULL;
+	LIST_HEAD(head);
+
+	if (!net)
+		return -EINVAL;
+
+	spin_lock_bh(&cbdev->queue_lock);
+	list_for_each_entry(cbq, &cbdev->queue_list, callback_entry) {
+		cbq_ex =3D kmalloc(sizeof(*cbq_ex), GFP_ATOMIC);
+		if (!cbq_ex) {
+			ret =3D -ENOMEM;
+			break;
+		}
+		INIT_LIST_HEAD(&(cbq_ex->list));
+
+		memcpy(&cbq_ex->id, &(cbq->id.id), sizeof(struct cb_id));
+		memcpy(cbq_ex->name, &(cbq->id.name), CN_CBQ_NAMELEN);
+		cbq_ex->callback =3D  cbq->callback;
+
+		list_add_tail(&(cbq_ex->list), &head);
+	}
+	spin_unlock_bh(&cbdev->queue_lock);
+
+	if (ret < 0) {
+		list_for_each_entry_safe(cbq_ex, tmp, &head, list) {
+			kfree(cbq_ex);
+		}
+	} else {
+		list_for_each_entry_safe(cbq_ex, tmp, &head, list) {
+			cn_add_callback_one(net, &(cbq_ex->id), cbq_ex->name,
+					    cbq_ex->callback);
+			kfree(cbq_ex);
+		}
+	}
+
+	return ret;
+}
+
+static int __net_init cn_init(struct net *net)
 {
-	struct cn_dev *dev =3D &cdev;
+	int ret =3D 0;
+	struct cn_dev *dev =3D &net->cdev;
 	struct netlink_kernel_cfg cfg =3D {
 		.groups	=3D CN_NETLINK_USERS + 0xf,
 		.input	=3D cn_rx_skb,
 	};
=20
-	dev->nls =3D netlink_kernel_create(&init_net, NETLINK_CONNECTOR, &cfg);
+	dev->nls =3D netlink_kernel_create(net, NETLINK_CONNECTOR, &cfg);
 	if (!dev->nls)
 		return -EIO;
=20
@@ -268,25 +360,44 @@ static int cn_init(void)
 		netlink_kernel_release(dev->nls);
 		return -EINVAL;
 	}
+	atomic_set(&(dev->proc_event_num_listeners), 0);
=20
-	cn_already_initialized =3D 1;
+	ret =3D init_cn_net(net);
+	if (ret < 0) {
+		cn_queue_free_dev(dev->cbdev);
+		netlink_kernel_release(dev->nls);
+		return ret;
+	}
=20
-	proc_create_single("connector", S_IRUGO, init_net.proc_net, cn_proc_sho=
w);
+	proc_create_net_single("connector", 0444, net->proc_net, cn_proc_show,
+			       NULL);
=20
 	return 0;
 }
=20
-static void cn_fini(void)
+static void __net_exit cn_fini(struct net *net)
 {
-	struct cn_dev *dev =3D &cdev;
-
-	cn_already_initialized =3D 0;
-
-	remove_proc_entry("connector", init_net.proc_net);
+	struct cn_dev *dev =3D &net->cdev;
=20
+	remove_proc_entry("connector", net->proc_net);
 	cn_queue_free_dev(dev->cbdev);
 	netlink_kernel_release(dev->nls);
 }
=20
-subsys_initcall(cn_init);
-module_exit(cn_fini);
+static struct pernet_operations cn_netlink_net_ops =3D {
+	.init =3D cn_init,
+	.exit =3D cn_fini,
+};
+
+static int __init connector_init(void)
+{
+	return register_pernet_subsys(&cn_netlink_net_ops);
+}
+
+static void __exit connector_exit(void)
+{
+	unregister_pernet_subsys(&cn_netlink_net_ops);
+}
+
+subsys_initcall(connector_init);
+module_exit(connector_exit);
diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index 5040d7e0cd9e..a7151296af5c 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -13,6 +13,7 @@
 #include <linux/workqueue.h>
 #include <linux/hyperv.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <asm/hyperv-tlfs.h>
=20
 #include "hyperv_vmbus.h"
diff --git a/include/linux/connector.h b/include/linux/connector.h
index 8e9385eb18f8..17febd6946ce 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -14,11 +14,14 @@
 #include <linux/list.h>
 #include <linux/workqueue.h>
=20
-#include <net/sock.h>
 #include <uapi/linux/connector.h>
=20
 #define CN_CBQ_NAMELEN		32
=20
+struct net;
+struct sock;
+struct netlink_skb_parms;
+
 struct cn_queue_dev {
 	atomic_t refcnt;
 	unsigned char name[CN_CBQ_NAMELEN];
@@ -46,11 +49,20 @@ struct cn_callback_entry {
 	u32 seq, group;
 };
=20
+struct cn_callback_entry_ex {
+	struct list_head list;
+	struct cb_id id;
+	unsigned char name[CN_CBQ_NAMELEN];
+	void (*callback)(struct net *net, struct cn_msg *cn_msg,
+			 struct netlink_skb_parms *nsp);
+};
+
 struct cn_dev {
 	struct cb_id id;
=20
 	u32 seq, groups;
 	struct sock *nls;
+	atomic_t proc_event_num_listeners;
=20
 	struct cn_queue_dev *cbdev;
 };
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 2ee5901bec7a..312972fb2dcc 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -38,6 +38,7 @@
 #include <linux/idr.h>
 #include <linux/skbuff.h>
 #include <linux/notifier.h>
+#include <linux/connector.h>
=20
 struct user_namespace;
 struct proc_dir_entry;
@@ -187,6 +188,9 @@ struct net {
 #endif
 #if IS_ENABLED(CONFIG_CRYPTO_USER)
 	struct sock		*crypto_nlsk;
+#endif
+#if IS_ENABLED(CONFIG_CONNECTOR)
+	struct cn_dev		cdev;
 #endif
 	struct sock		*diag_nlsk;
 } __randomize_layout;
diff --git a/kernel/exit.c b/kernel/exit.c
index 727150f28103..976fd6032024 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -788,6 +788,7 @@ void __noreturn do_exit(long code)
=20
 	tsk->exit_code =3D code;
 	taskstats_exit(tsk, group_dead);
+	proc_exit_connector(tsk);
=20
 	exit_mm();
=20
@@ -824,7 +825,6 @@ void __noreturn do_exit(long code)
=20
 	exit_tasks_rcu_start();
 	exit_notify(tsk, group_dead);
-	proc_exit_connector(tsk);
 	mpol_put_task_policy(tsk);
 #ifdef CONFIG_FUTEX
 	if (unlikely(current->pi_state_cache))
--=20
2.27.0


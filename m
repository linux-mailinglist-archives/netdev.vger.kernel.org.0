Return-Path: <netdev+bounces-4945-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2244B70F4DE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:13:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96AC31C20C6F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B5B21775C;
	Wed, 24 May 2023 11:13:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2FE17733
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:13:09 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A932A3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:13:06 -0700 (PDT)
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1684926784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0U++m2wnsvOk4YDQpmR9+Knq0bWaSQveUiDUEzBuzj8=;
	b=mt71gkS+4rF8cvhTodF39he582MNWG9r2UkWh4Z/b167qNJmHi07GXnaYRWcXApFco6yEb
	jDL8smveC5n7NuUucB3pQi79hgF5UGtg3qb8jTbKCmv4yDFTNquzTbp11SH8VBCIPoDKIp
	FwbhpDrrigO6Mdz1KYh8a3tCtkMGP7bqszevAU8KG/9SqV5ovQ+PL3TpN26C9GhawZLvK4
	5bQzbY2GR9LkqIL9tB+JgI3i0Pn/BaIt/eMZYK+VJ2xarCu4kZ9n3wsOG/y7LuQfRz3gII
	UeTuB0gvNag+9v6O7HPQdq0FTeUydO/f1dsgJHslBCJqxP9g/6KGQboWxSVeYw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1684926784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0U++m2wnsvOk4YDQpmR9+Knq0bWaSQveUiDUEzBuzj8=;
	b=pLUbN+hSIvGpK1Id2rFrzBoTh36zlzEBOqsiPGayle81phzi2he44vz2DWlCOEmKGTY5I8
	cacYSKuXdIq3L1BQ==
To: netdev@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC PATCH 1/2] net: Add sysfs files for threaded NAPI.
Date: Wed, 24 May 2023 13:12:58 +0200
Message-Id: <20230524111259.1323415-2-bigeasy@linutronix.de>
In-Reply-To: <20230524111259.1323415-1-bigeasy@linutronix.de>
References: <20230524111259.1323415-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I've been looking into threaded NAPI. One awkward thing to do is
to figure out the thread names, pids in order to adjust the thread
priorities and SMP affinity.
On PREEMPT_RT the NAPI thread is treated (by the user) the same way as
the threaded interrupt which means a dedicate CPU affinity for the
thread and a higher task priority to be favoured over other tasks on the
CPU. Otherwise the NAPI thread can be preempted by other threads leading
to delays in packet delivery.
Having to run ps/ grep is awkward to get the PID right. It is not easy
to match the interrupt since there is no obvious relation between the
IRQ and the NAPI thread.
NAPI threads are enabled often to mitigate the problems caused by a
"pending" ksoftirqd (which has been mitigated recently by doing softiqrs
regardless of ksoftirqd status). There is still the part that the NAPI
thread does not use softnet_data::poll_list.

To make things easier to setup NAPI threads here is a sysfs interfaces.
It provides for each NAPI instance a folder containing the name and PID
of the NAPI thread and an interrupt number of the interrupt scheduling
the NAPI thread. The latter requires support from the driver.
The name of the napi-instance can also be set by driver so it does not
fallback to the NAPI-id.

I've been thinking to wire up task affinity to follow the affinity of
the interrupt thread. While this would require some extra work, it
shouldn't be needed since the PID of the NAPI thread and interrupt
number is exposed so the user may use chrt/ taskset to adjust the
priority accordingly and the interrupt affinity does not change
magically.

Having said all that, there is still no generic solution to the
"overload" problem. Part of the problem is lack of policy since the
offload to ksoftirqd is not welcomed by everyone. Also "better" cards
support filtering by ether type which allows to filter the problematic
part to another NAPI instance avoiding the prbolem.

This is what the structure looks with the igb driver after adding the
name/ irq hints (second patch).

| root@box:/sys/class/net# cd eno0
| root@box:/sys/class/net/eno0# ls -l napi
| total 0

Empty before threaded NAPI is enabled.

| root@box:/sys/class/net/eno0# echo 1 > threaded
| root@box:/sys/class/net/eno0# ls -l napi
| total 0
| drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-0
| drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-1
| drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-2
| drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-3
| drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-4
| drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-5
| drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-6
| drwxr-xr-x 2 root root 0 May 24 09:42 eno0-TxRx-7

Deployed using names supplied by the driver which map the names which
are used for the IRQ.

| root@box:/sys/class/net/eno0# grep . napi/*/*
| napi/eno0-TxRx-0/interrupt:37
| napi/eno0-TxRx-0/name:napi/eno0-8193
| napi/eno0-TxRx-0/pid:2253
| napi/eno0-TxRx-1/interrupt:38
| napi/eno0-TxRx-1/name:napi/eno0-8194
| napi/eno0-TxRx-1/pid:2252
| napi/eno0-TxRx-2/interrupt:39
| napi/eno0-TxRx-2/name:napi/eno0-8195
| napi/eno0-TxRx-2/pid:2251
| napi/eno0-TxRx-3/interrupt:40
| napi/eno0-TxRx-3/name:napi/eno0-8196
| napi/eno0-TxRx-3/pid:2250
| napi/eno0-TxRx-4/interrupt:41
| napi/eno0-TxRx-4/name:napi/eno0-8197
| napi/eno0-TxRx-4/pid:2249
| napi/eno0-TxRx-5/interrupt:42
| napi/eno0-TxRx-5/name:napi/eno0-8198
| napi/eno0-TxRx-5/pid:2248
| napi/eno0-TxRx-6/interrupt:43
| napi/eno0-TxRx-6/name:napi/eno0-8199
| napi/eno0-TxRx-6/pid:2247
| napi/eno0-TxRx-7/interrupt:44
| napi/eno0-TxRx-7/name:napi/eno0-8200
| napi/eno0-TxRx-7/pid:2246

Thread name, pid and interrupt number as provided by the driver.

| root@box:/sys/class/net/eno0# grep eno0-TxRx-7 /proc/interrupts | sed 's@=
 \+@ @g'
|  44: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 123 0 0 0 0 0 0 0 0 0 0 0 0 0 IR=
-PCI-MSIX-0000:07:00.0 8-edge eno0-TxRx-7
| root@box:/sys/class/net/eno0# cat /proc/irq/44/smp_affinity_list
| 0-7,16-23
| root@box:/sys/class/net/eno0# cat /proc/irq/44/effective_affinity_list
| 18

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/netdevice.h |   6 ++
 net/core/dev.c            |  13 ++++
 net/core/net-sysfs.c      | 137 ++++++++++++++++++++++++++++++++++++++
 net/core/net-sysfs.h      |  12 ++++
 4 files changed, 168 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a937b9329af52..34b584b4d5d94 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -376,6 +376,9 @@ struct napi_struct {
 	/* control-path-only fields follow */
 	struct list_head	dev_list;
 	struct hlist_node	napi_hash_node;
+	struct kobject		kobj;
+	const char		*napi_name;
+	int			interrupt_num;
 };
=20
 enum {
@@ -2411,6 +2414,7 @@ struct net_device {
 	struct rtnl_hw_stats64	*offload_xstats_l3;
=20
 	struct devlink_port	*devlink_port;
+	struct kset		*napi_kset;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
=20
@@ -2688,6 +2692,8 @@ static inline void netif_napi_del(struct napi_struct =
*napi)
 	synchronize_net();
 }
=20
+void netif_napi_add_hints(struct napi_struct *napi, const char *name, unsi=
gned int interrupt);
+
 struct packet_type {
 	__be16			type;	/* This is really htons(ether_type). */
 	bool			ignore_outgoing;
diff --git a/net/core/dev.c b/net/core/dev.c
index 318ae441df1f5..79789dbc1c521 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1375,7 +1375,10 @@ static int napi_kthread_create(struct napi_struct *n)
 		pr_err("kthread_run failed with err %d\n", err);
 		n->thread =3D NULL;
 	}
+	if (err)
+		return err;
=20
+	err =3D napi_thread_add_kobj(n);
 	return err;
 }
=20
@@ -6383,6 +6386,7 @@ void netif_napi_add_weight(struct net_device *dev, st=
ruct napi_struct *napi,
 	list_add_rcu(&napi->dev_list, &dev->napi_list);
 	napi_hash_add(napi);
 	napi_get_frags_check(napi);
+	napi->interrupt_num =3D -1;
 	/* Create kthread for this napi if dev->threaded is set.
 	 * Clear dev->threaded if kthread creation failed so that
 	 * threaded mode will not be enabled in napi_enable().
@@ -6392,6 +6396,14 @@ void netif_napi_add_weight(struct net_device *dev, s=
truct napi_struct *napi,
 }
 EXPORT_SYMBOL(netif_napi_add_weight);
=20
+void netif_napi_add_hints(struct napi_struct *napi, const char *name,
+			  unsigned int interrupt)
+{
+	napi->napi_name =3D name;
+	napi->interrupt_num =3D interrupt;
+}
+EXPORT_SYMBOL_GPL(netif_napi_add_hints);
+
 void napi_disable(struct napi_struct *n)
 {
 	unsigned long val, new;
@@ -6464,6 +6476,7 @@ void __netif_napi_del(struct napi_struct *napi)
 	napi->gro_bitmask =3D 0;
=20
 	if (napi->thread) {
+		napi_thread_remove_kobj(napi);
 		kthread_stop(napi->thread);
 		napi->thread =3D NULL;
 	}
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 15e3f4606b5f9..a050f8cd4913c 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1820,6 +1820,136 @@ static int register_queue_kobjects(struct net_devic=
e *dev)
 	return error;
 }
=20
+#ifdef CONFIG_SYSFS
+
+struct napi_thread_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct napi_struct *n, char *buf);
+	ssize_t (*store)(struct napi_struct *n, const char *buf, size_t len);
+};
+
+static ssize_t napi_thread_interrupt_show(struct napi_struct *n, char *buf)
+{
+	if (n->interrupt_num < 0)
+		return -EINVAL;
+	return sysfs_emit(buf, "%u\n", n->interrupt_num);
+}
+
+static ssize_t napi_thread_name_show(struct napi_struct *n, char *buf)
+{
+	char comm_buf[TASK_COMM_LEN];
+
+	get_task_comm(comm_buf, n->thread);
+	return sysfs_emit(buf, "%s\n", comm_buf);
+}
+
+static ssize_t napi_thread_pid_show(struct napi_struct *n, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", task_pid_nr(n->thread));
+}
+
+#define NAPI_THREAD_ATTR(__name)	\
+	static struct napi_thread_attribute thread_napi_##__name##_attribute __ro=
_after_init =3D	\
+	__ATTR(__name, 0444, napi_thread_##__name##_show, NULL)
+
+NAPI_THREAD_ATTR(interrupt);
+NAPI_THREAD_ATTR(name);
+NAPI_THREAD_ATTR(pid);
+
+static struct attribute *napi_thread_default_attrs[] __ro_after_init =3D {
+	&thread_napi_interrupt_attribute.attr,
+	&thread_napi_name_attribute.attr,
+	&thread_napi_pid_attribute.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(napi_thread_default);
+
+#define to_napi_struct_attr(_attr) \
+	container_of(_attr, struct napi_thread_attribute, attr)
+
+#define to_napi_struct(obj) container_of(obj, struct napi_struct, kobj)
+
+static ssize_t napi_thread_attr_show(struct kobject *kobj, struct attribut=
e *attr,
+				     char *buf)
+{
+	const struct napi_thread_attribute *attribute =3D to_napi_struct_attr(att=
r);
+	struct napi_struct *n =3D to_napi_struct(kobj);
+	ssize_t ret =3D -EINVAL;
+
+	if (!attribute->show)
+		return -EIO;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+	if (dev_isalive(n->dev))
+		ret =3D attribute->show(n, buf);
+
+	rtnl_unlock();
+	return ret;
+}
+
+static const struct sysfs_ops napi_thread_sysfs_ops =3D {
+	.show =3D napi_thread_attr_show,
+};
+
+static void napi_thread_release(struct kobject *kobj)
+{
+	memset(kobj, 0, sizeof(*kobj));
+}
+
+static const struct kobj_type napi_ktype =3D {
+	.sysfs_ops =3D &napi_thread_sysfs_ops,
+	.release =3D napi_thread_release,
+	.default_groups =3D napi_thread_default_groups,
+};
+
+int napi_thread_add_kobj(struct napi_struct *n)
+{
+	struct kobject *kobj;
+	char napi_name[32];
+	const char *name_ptr;
+	int ret;
+
+	if (n->napi_name) {
+		name_ptr =3D n->napi_name;
+	} else {
+		name_ptr =3D napi_name;
+		scnprintf(napi_name, sizeof(napi_name), "napi_id-%d", n->napi_id);
+	}
+	kobj =3D &n->kobj;
+	kobj->kset =3D n->dev->napi_kset;
+	ret =3D kobject_init_and_add(kobj, &napi_ktype, NULL,
+				   name_ptr);
+	return ret;
+}
+
+void napi_thread_remove_kobj(struct napi_struct *n)
+{
+	kobject_put(&n->kobj);
+}
+
+static int register_napi_kobjects(struct net_device *dev)
+{
+	dev->napi_kset =3D kset_create_and_add("napi",
+					     NULL, &dev->dev.kobj);
+	if (!dev->napi_kset)
+		return -ENOMEM;
+	return 0;
+}
+
+static int unregister_napi_kobjects(struct net_device *dev)
+{
+	kset_unregister(dev->napi_kset);
+	return 0;
+}
+
+#else /* !CONFIG_SYSFS */
+
+static int register_napi_kobjects(struct net_device *dev) { return 0; }
+static void unregister_napi_kobjects(struct net_device *dev) { }
+
+#endif
+
 static int queue_change_owner(struct net_device *ndev, kuid_t kuid, kgid_t=
 kgid)
 {
 	int error =3D 0, real_rx =3D 0, real_tx =3D 0;
@@ -2009,6 +2139,7 @@ void netdev_unregister_kobject(struct net_device *nde=
v)
 	kobject_get(&dev->kobj);
=20
 	remove_queue_kobjects(ndev);
+	unregister_napi_kobjects(ndev);
=20
 	pm_runtime_set_memalloc_noio(dev, false);
=20
@@ -2050,6 +2181,12 @@ int netdev_register_kobject(struct net_device *ndev)
 		return error;
 	}
=20
+	error =3D register_napi_kobjects(ndev);
+	if (error) {
+		remove_queue_kobjects(ndev);
+		device_del(dev);
+		return -ENOMEM;
+	}
 	pm_runtime_set_memalloc_noio(dev, true);
=20
 	return error;
diff --git a/net/core/net-sysfs.h b/net/core/net-sysfs.h
index 8a5b04c2699aa..6b185a309290d 100644
--- a/net/core/net-sysfs.h
+++ b/net/core/net-sysfs.h
@@ -11,4 +11,16 @@ int netdev_queue_update_kobjects(struct net_device *net,
 int netdev_change_owner(struct net_device *, const struct net *net_old,
 			const struct net *net_new);
=20
+#ifdef CONFIG_SYSFS
+
+int napi_thread_add_kobj(struct napi_struct *n);
+void napi_thread_remove_kobj(struct napi_struct *n);
+
+#else
+
+static inline int napi_thread_add_kobj(struct napi_struct *n) { return 0; }
+static inline void napi_thread_remove_kobj(struct napi_struct *n) { }
+
+#endif
+
 #endif
--=20
2.40.1



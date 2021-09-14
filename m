Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033DC40AC27
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 13:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhINLCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 07:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbhINLB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 07:01:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C6FC061574
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 04:00:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mQ6B4-0006b0-H1; Tue, 14 Sep 2021 13:00:38 +0200
Date:   Tue, 14 Sep 2021 13:00:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Guillaume Nault <gnault@redhat.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
Message-ID: <20210914110038.GA25110@breakpoint.cc>
References: <20210809151529.ymbq53f633253loz@pali>
 <FFD368DF-4C89-494B-8E7B-35C2A139E277@gmail.com>
 <20210811164835.GB15488@pc-32.home>
 <81FD1346-8CE6-4080-84C9-705E2E5E69C0@gmail.com>
 <6A3B4C11-EF48-4CE9-9EC7-5882E330D7EA@gmail.com>
 <A16DCD3E-43AA-4D50-97FC-EBB776481840@gmail.com>
 <E95FDB1D-488B-4780-96A1-A2D5C9616A7A@gmail.com>
 <20210914080206.GA20454@pc-4.home>
 <20210914095015.GA9076@breakpoint.cc>
 <1724F1B4-5048-4625-88A5-1193D4445D5A@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <1724F1B4-5048-4625-88A5-1193D4445D5A@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Martin Zaharinov <micron10@gmail.com> wrote:

[ Trimming CC list ]

> Florian: 
> 
> If you make patch send to test please.

Attached.  No idea if it helps, but 'ip' should stay responsive
even when masquerade processes netdevice events.

--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="defer_masq_work.diff"

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 8e8a65d46345..50c6d6992ed6 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -9,8 +9,19 @@
 
 #include <net/netfilter/nf_nat_masquerade.h>
 
+struct masq_dev_work {
+	struct work_struct work;
+	struct net *net;
+	union nf_inet_addr addr;
+	int ifindex;
+	int (*iter)(struct nf_conn *i, void *data);
+};
+
+#define MAX_MASQ_WORKER_COUNT	16
+
 static DEFINE_MUTEX(masq_mutex);
 static unsigned int masq_refcnt __read_mostly;
+static atomic_t masq_worker_count __read_mostly;
 
 unsigned int
 nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
@@ -63,13 +74,68 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4);
 
-static int device_cmp(struct nf_conn *i, void *ifindex)
+static void iterate_cleanup_work(struct work_struct *work)
+{
+	struct masq_dev_work *w;
+
+	w = container_of(work, struct masq_dev_work, work);
+
+	nf_ct_iterate_cleanup_net(w->net, w->iter, (void *)w, 0, 0);
+
+	put_net(w->net);
+	kfree(w);
+	atomic_dec(&masq_worker_count);
+	module_put(THIS_MODULE);
+}
+
+/* Iterate conntrack table in the background and remove conntrack entries
+ * that use the device/address being removed.
+ *
+ * In case too many work items have been queued already or memory allocation
+ * fails iteration is skipped, conntrack entries will time out eventually.
+ */
+static void nf_nat_masq_schedule(struct net *net, union nf_inet_addr *addr,
+				 int ifindex,
+				 int (*iter)(struct nf_conn *i, void *data),
+				 gfp_t gfp_flags)
+{
+	struct masq_dev_work *w;
+
+	net = maybe_get_net(net);
+	if (!net)
+		return;
+
+	if (!try_module_get(THIS_MODULE))
+		goto err_module;
+
+	w = kzalloc(sizeof(*w), gfp_flags);
+	if (w) {
+		/* We can overshoot MAX_MASQ_WORKER_COUNT, no big deal */
+		atomic_inc(&masq_worker_count);
+
+		INIT_WORK(&w->work, iterate_cleanup_work);
+		w->ifindex = ifindex;
+		w->net = net;
+		w->iter = iter;
+		if (addr)
+			w->addr = *addr;
+		schedule_work(&w->work);
+		return;
+	}
+
+	module_put(THIS_MODULE);
+ err_module:
+	put_net(net);
+}
+
+static int device_cmp(struct nf_conn *i, void *arg)
 {
 	const struct nf_conn_nat *nat = nfct_nat(i);
+	const struct masq_dev_work *w = arg;
 
 	if (!nat)
 		return 0;
-	return nat->masq_index == (int)(long)ifindex;
+	return nat->masq_index == w->ifindex;
 }
 
 static int masq_device_event(struct notifier_block *this,
@@ -85,8 +151,8 @@ static int masq_device_event(struct notifier_block *this,
 		 * and forget them.
 		 */
 
-		nf_ct_iterate_cleanup_net(net, device_cmp,
-					  (void *)(long)dev->ifindex, 0, 0);
+		nf_nat_masq_schedule(net, NULL, dev->ifindex,
+				     device_cmp, GFP_KERNEL);
 	}
 
 	return NOTIFY_DONE;
@@ -94,35 +160,45 @@ static int masq_device_event(struct notifier_block *this,
 
 static int inet_cmp(struct nf_conn *ct, void *ptr)
 {
-	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
-	struct net_device *dev = ifa->ifa_dev->dev;
 	struct nf_conntrack_tuple *tuple;
+	struct masq_dev_work *w = ptr;
 
-	if (!device_cmp(ct, (void *)(long)dev->ifindex))
+	if (!device_cmp(ct, ptr))
 		return 0;
 
 	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 
-	return ifa->ifa_address == tuple->dst.u3.ip;
+	return nf_inet_addr_cmp(&w->addr, &tuple->dst.u3);
 }
 
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
 {
-	struct in_device *idev = ((struct in_ifaddr *)ptr)->ifa_dev;
-	struct net *net = dev_net(idev->dev);
+	const struct in_ifaddr *ifa = ptr;
+	const struct in_device *idev;
+	const struct net_device *dev;
+	union nf_inet_addr addr;
+
+	if (event != NETDEV_DOWN)
+		return NOTIFY_DONE;
 
 	/* The masq_dev_notifier will catch the case of the device going
 	 * down.  So if the inetdev is dead and being destroyed we have
 	 * no work to do.  Otherwise this is an individual address removal
 	 * and we have to perform the flush.
 	 */
+	idev = ifa->ifa_dev;
 	if (idev->dead)
 		return NOTIFY_DONE;
 
-	if (event == NETDEV_DOWN)
-		nf_ct_iterate_cleanup_net(net, inet_cmp, ptr, 0, 0);
+	memset(&addr, 0, sizeof(addr));
+
+	addr.ip = ifa->ifa_address;
+
+	dev = idev->dev;
+	nf_nat_masq_schedule(dev_net(idev->dev), &addr, dev->ifindex,
+			     inet_cmp, GFP_KERNEL);
 
 	return NOTIFY_DONE;
 }
@@ -136,8 +212,6 @@ static struct notifier_block masq_inet_notifier = {
 };
 
 #if IS_ENABLED(CONFIG_IPV6)
-static atomic_t v6_worker_count __read_mostly;
-
 static int
 nat_ipv6_dev_get_saddr(struct net *net, const struct net_device *dev,
 		       const struct in6_addr *daddr, unsigned int srcprefs,
@@ -187,40 +261,6 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6);
 
-struct masq_dev_work {
-	struct work_struct work;
-	struct net *net;
-	struct in6_addr addr;
-	int ifindex;
-};
-
-static int inet6_cmp(struct nf_conn *ct, void *work)
-{
-	struct masq_dev_work *w = (struct masq_dev_work *)work;
-	struct nf_conntrack_tuple *tuple;
-
-	if (!device_cmp(ct, (void *)(long)w->ifindex))
-		return 0;
-
-	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-
-	return ipv6_addr_equal(&w->addr, &tuple->dst.u3.in6);
-}
-
-static void iterate_cleanup_work(struct work_struct *work)
-{
-	struct masq_dev_work *w;
-
-	w = container_of(work, struct masq_dev_work, work);
-
-	nf_ct_iterate_cleanup_net(w->net, inet6_cmp, (void *)w, 0, 0);
-
-	put_net(w->net);
-	kfree(w);
-	atomic_dec(&v6_worker_count);
-	module_put(THIS_MODULE);
-}
-
 /* atomic notifier; can't call nf_ct_iterate_cleanup_net (it can sleep).
  *
  * Defer it to the system workqueue.
@@ -233,36 +273,19 @@ static int masq_inet6_event(struct notifier_block *this,
 {
 	struct inet6_ifaddr *ifa = ptr;
 	const struct net_device *dev;
-	struct masq_dev_work *w;
-	struct net *net;
+	union nf_inet_addr addr;
 
-	if (event != NETDEV_DOWN || atomic_read(&v6_worker_count) >= 16)
+	if (event != NETDEV_DOWN)
 		return NOTIFY_DONE;
 
 	dev = ifa->idev->dev;
-	net = maybe_get_net(dev_net(dev));
-	if (!net)
-		return NOTIFY_DONE;
-
-	if (!try_module_get(THIS_MODULE))
-		goto err_module;
 
-	w = kmalloc(sizeof(*w), GFP_ATOMIC);
-	if (w) {
-		atomic_inc(&v6_worker_count);
+	memset(&addr, 0, sizeof(addr));
 
-		INIT_WORK(&w->work, iterate_cleanup_work);
-		w->ifindex = dev->ifindex;
-		w->net = net;
-		w->addr = ifa->addr;
-		schedule_work(&w->work);
+	addr.in6 = ifa->addr;
 
-		return NOTIFY_DONE;
-	}
-
-	module_put(THIS_MODULE);
- err_module:
-	put_net(net);
+	nf_nat_masq_schedule(dev_net(dev), &addr, dev->ifindex, inet_cmp,
+				 GFP_ATOMIC);
 	return NOTIFY_DONE;
 }
 

--cNdxnHkX5QqsyA0e--

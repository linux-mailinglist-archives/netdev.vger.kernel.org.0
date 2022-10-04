Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13ACE5F4C7D
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 01:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJDXMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 19:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJDXML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 19:12:11 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0255056033;
        Tue,  4 Oct 2022 16:12:09 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ofr55-000AJ3-Gx; Wed, 05 Oct 2022 01:12:07 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 02/10] bpf: Implement BPF link handling for tc BPF programs
Date:   Wed,  5 Oct 2022 01:11:35 +0200
Message-Id: <20221004231143.19190-3-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221004231143.19190-1-daniel@iogearbox.net>
References: <20221004231143.19190-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26679/Tue Oct  4 09:56:50 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This work adds BPF links for tc. As a recap, a BPF link represents the attachment
of a BPF program to a BPF hook point. The BPF link holds a single reference to
keep BPF program alive. Moreover, hook points do not reference a BPF link, only
the application's fd or pinning does. A BPF link holds meta-data specific to
attachment and implements operations for link creation, (atomic) BPF program
update, detachment and introspection.

The motivation for BPF links for tc BPF programs is multi-fold, for example:

- "It's especially important for applications that are deployed fleet-wide
   and that don't "control" hosts they are deployed to. If such application
   crashes and no one notices and does anything about that, BPF program will
   keep running draining resources or even just, say, dropping packets. We
   at FB had outages due to such permanent BPF attachment semantics. With
   fd-based BPF link we are getting a framework, which allows safe, auto-
   detachable behavior by default, unless application explicitly opts in by
   pinning the BPF link." [0]

-  From Cilium-side the tc BPF programs we attach to host-facing veth devices
   and phys devices build the core datapath for Kubernetes Pods, and they
   implement forwarding, load-balancing, policy, EDT-management, etc, within
   BPF. Currently there is no concept of 'safe' ownership, e.g. we've recently
   experienced hard-to-debug issues in a user's staging environment where
   another Kubernetes application using tc BPF attached to the same prio/handle
   of cls_bpf, wiping all Cilium-based BPF programs from underneath it. The
   goal is to establish a clear/safe ownership model via links which cannot
   accidentally be overridden. [1]

BPF links for tc can co-exist with non-link attachments, and the semantics are
in line also with XDP links: BPF links cannot replace other BPF links, BPF
links cannot replace non-BPF links, non-BPF links cannot replace BPF links and
lastly only non-BPF links can replace non-BPF links. In case of Cilium, this
would solve mentioned issue of safe ownership model as 3rd party applications
would not be able to accidentally wipe Cilium programs, even if they are not
BPF link aware.

Earlier attempts [2] have tried to integrate BPF links into core tc machinery
to solve cls_bpf, which has been intrusive to the generic tc kernel API with
extensions only specific to cls_bpf and suboptimal/complex since cls_bpf could
be wiped from the qdisc also. Locking a tc BPF program in place this way, is
getting into layering hacks given the two object models are vastly different.
We chose to implement a prerequisite of the fd-based tc BPF attach API, so
that the BPF link implementation fits in naturally similar to other link types
which are fd-based and without the need for changing core tc internal APIs.

BPF programs for tc can then be successively migrated from cls_bpf to the new
tc BPF link without needing to change the program's source code, just the BPF
loader mechanics for attaching.

  [0] https://lore.kernel.org/bpf/CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com/
  [1] https://lpc.events/event/16/contributions/1353/
  [2] https://lore.kernel.org/bpf/20210604063116.234316-1-memxor@gmail.com/

Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/bpf.h            |   5 +-
 include/net/xtc.h              |  14 ++++
 include/uapi/linux/bpf.h       |   5 ++
 kernel/bpf/net.c               | 116 ++++++++++++++++++++++++++++++---
 kernel/bpf/syscall.c           |   3 +
 tools/include/uapi/linux/bpf.h |   5 ++
 6 files changed, 139 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 71e5f43db378..226a74f65704 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1473,7 +1473,10 @@ struct bpf_prog_array_item {
 	union {
 		struct bpf_cgroup_storage *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 		u64 bpf_cookie;
-		u32 bpf_priority;
+		struct {
+			u32 bpf_priority;
+			u32 bpf_id;
+		};
 	};
 };
 
diff --git a/include/net/xtc.h b/include/net/xtc.h
index 627dc18aa433..e4a8cee09490 100644
--- a/include/net/xtc.h
+++ b/include/net/xtc.h
@@ -27,6 +27,13 @@ struct xtc_entry_pair {
 	struct xtc_entry	b;
 };
 
+struct bpf_tc_link {
+	struct bpf_link link;
+	struct net_device *dev;
+	u32 priority;
+	u32 location;
+};
+
 static inline void xtc_set_ingress(struct sk_buff *skb, bool ingress)
 {
 #ifdef CONFIG_NET_XGRESS
@@ -155,6 +162,7 @@ int xtc_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog);
 int xtc_prog_detach(const union bpf_attr *attr);
 int xtc_prog_query(const union bpf_attr *attr,
 		   union bpf_attr __user *uattr);
+int xtc_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
 void dev_xtc_uninstall(struct net_device *dev);
 #else
 static inline int xtc_prog_attach(const union bpf_attr *attr,
@@ -174,6 +182,12 @@ static inline int xtc_prog_query(const union bpf_attr *attr,
 	return -EINVAL;
 }
 
+static inline int xtc_link_attach(const union bpf_attr *attr,
+				  struct bpf_prog *prog)
+{
+	return -EINVAL;
+}
+
 static inline void dev_xtc_uninstall(struct net_device *dev)
 {
 }
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index de1f5546bcfe..c006f561648e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1043,6 +1043,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_PERF_EVENT = 7,
 	BPF_LINK_TYPE_KPROBE_MULTI = 8,
 	BPF_LINK_TYPE_STRUCT_OPS = 9,
+	BPF_LINK_TYPE_TC = 10,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1541,6 +1542,9 @@ union bpf_attr {
 				 */
 				__u64		cookie;
 			} tracing;
+			struct {
+				__u32		priority;
+			} tc;
 		};
 	} link_create;
 
@@ -6830,6 +6834,7 @@ struct bpf_flow_keys {
 
 struct bpf_query_info {
 	__u32 prog_id;
+	__u32 link_id;
 	__u32 prio;
 };
 
diff --git a/kernel/bpf/net.c b/kernel/bpf/net.c
index ab9a9dee615b..22b7a9b05483 100644
--- a/kernel/bpf/net.c
+++ b/kernel/bpf/net.c
@@ -8,7 +8,7 @@
 #include <net/xtc.h>
 
 static int __xtc_prog_attach(struct net_device *dev, bool ingress, u32 limit,
-			     struct bpf_prog *nprog, u32 prio, u32 flags)
+			     u32 id, struct bpf_prog *nprog, u32 prio, u32 flags)
 {
 	struct bpf_prog_array_item *item, *tmp;
 	struct xtc_entry *entry, *peer;
@@ -27,10 +27,13 @@ static int __xtc_prog_attach(struct net_device *dev, bool ingress, u32 limit,
 		if (!oprog)
 			break;
 		if (item->bpf_priority == prio) {
-			if (flags & BPF_F_REPLACE) {
+			if (item->bpf_id == id &&
+			    (flags & BPF_F_REPLACE)) {
 				/* Pairs with READ_ONCE() in xtc_run_progs(). */
 				WRITE_ONCE(item->prog, nprog);
-				bpf_prog_put(oprog);
+				item->bpf_id = id;
+				if (!id)
+					bpf_prog_put(oprog);
 				dev_xtc_entry_prio_set(entry, prio, nprog);
 				return prio;
 			}
@@ -55,19 +58,23 @@ static int __xtc_prog_attach(struct net_device *dev, bool ingress, u32 limit,
 			if (i == j) {
 				tmp->prog = nprog;
 				tmp->bpf_priority = prio;
+				tmp->bpf_id = id;
 			}
 			break;
 		} else if (item->bpf_priority < prio) {
 			tmp->prog = oprog;
 			tmp->bpf_priority = item->bpf_priority;
+			tmp->bpf_id = item->bpf_id;
 		} else if (item->bpf_priority > prio) {
 			if (i == j) {
 				tmp->prog = nprog;
 				tmp->bpf_priority = prio;
+				tmp->bpf_id = id;
 				tmp = &peer->items[++j];
 			}
 			tmp->prog = oprog;
 			tmp->bpf_priority = item->bpf_priority;
+			tmp->bpf_id = item->bpf_id;
 		}
 	}
 	dev_xtc_entry_update(dev, peer, ingress);
@@ -94,14 +101,14 @@ int xtc_prog_attach(const union bpf_attr *attr, struct bpf_prog *nprog)
 		rtnl_unlock();
 		return -EINVAL;
 	}
-	ret = __xtc_prog_attach(dev, ingress, XTC_MAX_ENTRIES, nprog,
+	ret = __xtc_prog_attach(dev, ingress, XTC_MAX_ENTRIES, 0, nprog,
 				attr->attach_priority, attr->attach_flags);
 	rtnl_unlock();
 	return ret;
 }
 
 static int __xtc_prog_detach(struct net_device *dev, bool ingress, u32 limit,
-			     u32 prio)
+			     u32 id, u32 prio)
 {
 	struct bpf_prog_array_item *item, *tmp;
 	struct bpf_prog *oprog, *fprog = NULL;
@@ -126,8 +133,11 @@ static int __xtc_prog_detach(struct net_device *dev, bool ingress, u32 limit,
 		if (item->bpf_priority != prio) {
 			tmp->prog = oprog;
 			tmp->bpf_priority = item->bpf_priority;
+			tmp->bpf_id = item->bpf_id;
 			j++;
 		} else {
+			if (item->bpf_id != id)
+				return -EBUSY;
 			fprog = oprog;
 		}
 	}
@@ -136,7 +146,8 @@ static int __xtc_prog_detach(struct net_device *dev, bool ingress, u32 limit,
 		if (dev_xtc_entry_total(peer) == 0 && !entry->parent->miniq)
 			peer = NULL;
 		dev_xtc_entry_update(dev, peer, ingress);
-		bpf_prog_put(fprog);
+		if (!id)
+			bpf_prog_put(fprog);
 		if (!peer)
 			dev_xtc_entry_free(entry);
 		if (ingress)
@@ -164,7 +175,7 @@ int xtc_prog_detach(const union bpf_attr *attr)
 		rtnl_unlock();
 		return -EINVAL;
 	}
-	ret = __xtc_prog_detach(dev, ingress, XTC_MAX_ENTRIES,
+	ret = __xtc_prog_detach(dev, ingress, XTC_MAX_ENTRIES, 0,
 				attr->attach_priority);
 	rtnl_unlock();
 	return ret;
@@ -191,7 +202,8 @@ static void __xtc_prog_detach_all(struct net_device *dev, bool ingress, u32 limi
 		if (!prog)
 			break;
 		dev_xtc_entry_prio_del(entry, item->bpf_priority);
-		bpf_prog_put(prog);
+		if (!item->bpf_id)
+			bpf_prog_put(prog);
 		if (ingress)
 			net_dec_ingress_queue();
 		else
@@ -244,6 +256,7 @@ __xtc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr,
 		if (!prog)
 			break;
 		info.prog_id = prog->aux->id;
+		info.link_id = item->bpf_id;
 		info.prio = item->bpf_priority;
 		if (copy_to_user(uinfo + i, &info, sizeof(info)))
 			return -EFAULT;
@@ -272,3 +285,90 @@ int xtc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
 	rtnl_unlock();
 	return ret;
 }
+
+static int __xtc_link_attach(struct bpf_link *l, u32 id)
+{
+	struct bpf_tc_link *link = container_of(l, struct bpf_tc_link, link);
+	int ret;
+
+	rtnl_lock();
+	ret = __xtc_prog_attach(link->dev, link->location == BPF_NET_INGRESS,
+				XTC_MAX_ENTRIES, id, l->prog, link->priority,
+				0);
+	if (ret > 0) {
+		link->priority = ret;
+		ret = 0;
+	}
+	rtnl_unlock();
+	return ret;
+}
+
+static void xtc_link_release(struct bpf_link *l)
+{
+	struct bpf_tc_link *link = container_of(l, struct bpf_tc_link, link);
+
+	rtnl_lock();
+	if (link->dev) {
+		WARN_ON(__xtc_prog_detach(link->dev,
+					  link->location == BPF_NET_INGRESS,
+					  XTC_MAX_ENTRIES, l->id, link->priority));
+		link->dev = NULL;
+	}
+	rtnl_unlock();
+}
+
+static void xtc_link_dealloc(struct bpf_link *l)
+{
+	struct bpf_tc_link *link = container_of(l, struct bpf_tc_link, link);
+
+	kfree(link);
+}
+
+static const struct bpf_link_ops bpf_tc_link_lops = {
+	.release	= xtc_link_release,
+	.dealloc	= xtc_link_dealloc,
+};
+
+int xtc_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct bpf_link_primer link_primer;
+	struct bpf_tc_link *link;
+	struct net_device *dev;
+	int fd, err;
+
+	if (attr->link_create.flags)
+		return -EINVAL;
+	dev = dev_get_by_index(net, attr->link_create.target_ifindex);
+	if (!dev)
+		return -EINVAL;
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link) {
+		err = -ENOMEM;
+		goto out_put;
+	}
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_TC, &bpf_tc_link_lops, prog);
+	link->priority = attr->link_create.tc.priority;
+	link->location = attr->link_create.attach_type;
+	link->dev = dev;
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err) {
+		kfree(link);
+		goto out_put;
+	}
+	err = __xtc_link_attach(&link->link, link_primer.id);
+	if (err) {
+		link->dev = NULL;
+		bpf_link_cleanup(&link_primer);
+		goto out_put;
+	}
+
+	fd = bpf_link_settle(&link_primer);
+	dev_put(dev);
+	return fd;
+out_put:
+	dev_put(dev);
+	return err;
+}
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a0a670b964bb..4456df481381 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4613,6 +4613,9 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 	case BPF_PROG_TYPE_XDP:
 		ret = bpf_xdp_link_attach(attr, prog);
 		break;
+	case BPF_PROG_TYPE_SCHED_CLS:
+		ret = xtc_link_attach(attr, prog);
+		break;
 #endif
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_TRACEPOINT:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index de1f5546bcfe..c006f561648e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1043,6 +1043,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_PERF_EVENT = 7,
 	BPF_LINK_TYPE_KPROBE_MULTI = 8,
 	BPF_LINK_TYPE_STRUCT_OPS = 9,
+	BPF_LINK_TYPE_TC = 10,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1541,6 +1542,9 @@ union bpf_attr {
 				 */
 				__u64		cookie;
 			} tracing;
+			struct {
+				__u32		priority;
+			} tc;
 		};
 	} link_create;
 
@@ -6830,6 +6834,7 @@ struct bpf_flow_keys {
 
 struct bpf_query_info {
 	__u32 prog_id;
+	__u32 link_id;
 	__u32 prio;
 };
 
-- 
2.34.1


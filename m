Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CECC30E1C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfEaM3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:29:35 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60476 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbfEaM3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 08:29:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hWgf6-0004JB-KS; Fri, 31 May 2019 14:29:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org
Subject: [PATCH net-next v2 1/7] afs: do not send list of client addresses
Date:   Fri, 31 May 2019 14:22:08 +0200
Message-Id: <20190531122214.18616-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531122214.18616-1-fw@strlen.de>
References: <20190531122214.18616-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howell says:
  I'm told that there's not really any point populating the list.
  Current OpenAFS ignores it, as does AuriStor - and IBM AFS 3.6 will
  do the right thing.
  The list is actually useless as it's the client's view of the world,
  not the servers, so if there's any NAT in the way its contents are
  invalid.  Further, it doesn't support IPv6 addresses.

  On that basis, feel free to make it an empty list and remove all the
  interface enumeration.

V1 of this patch reworked the function to use a new helper for the
ifa_list iteration to avoid sparse warnings once the proper __rcu
annotations get added in struct in_device later.

But, in light of the above, just remove afs_get_ipv4_interfaces.

Compile tested only.

Cc: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 fs/afs/Makefile     |  1 -
 fs/afs/cmservice.c  | 24 +----------------------
 fs/afs/internal.h   | 15 --------------
 fs/afs/netdevices.c | 48 ---------------------------------------------
 4 files changed, 1 insertion(+), 87 deletions(-)
 delete mode 100644 fs/afs/netdevices.c

diff --git a/fs/afs/Makefile b/fs/afs/Makefile
index cbf31f6cd177..10359bea7070 100644
--- a/fs/afs/Makefile
+++ b/fs/afs/Makefile
@@ -29,7 +29,6 @@ kafs-y := \
 	server.o \
 	server_list.o \
 	super.o \
-	netdevices.o \
 	vlclient.o \
 	vl_list.o \
 	vl_probe.o \
diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index 01437cfe5432..a61d2058c468 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -584,9 +584,8 @@ static int afs_deliver_cb_probe_uuid(struct afs_call *call)
  */
 static void SRXAFSCB_TellMeAboutYourself(struct work_struct *work)
 {
-	struct afs_interface *ifs;
 	struct afs_call *call = container_of(work, struct afs_call, work);
-	int loop, nifs;
+	int loop;
 
 	struct {
 		struct /* InterfaceAddr */ {
@@ -604,19 +603,7 @@ static void SRXAFSCB_TellMeAboutYourself(struct work_struct *work)
 
 	_enter("");
 
-	nifs = 0;
-	ifs = kcalloc(32, sizeof(*ifs), GFP_KERNEL);
-	if (ifs) {
-		nifs = afs_get_ipv4_interfaces(call->net, ifs, 32, false);
-		if (nifs < 0) {
-			kfree(ifs);
-			ifs = NULL;
-			nifs = 0;
-		}
-	}
-
 	memset(&reply, 0, sizeof(reply));
-	reply.ia.nifs = htonl(nifs);
 
 	reply.ia.uuid[0] = call->net->uuid.time_low;
 	reply.ia.uuid[1] = htonl(ntohs(call->net->uuid.time_mid));
@@ -626,15 +613,6 @@ static void SRXAFSCB_TellMeAboutYourself(struct work_struct *work)
 	for (loop = 0; loop < 6; loop++)
 		reply.ia.uuid[loop + 5] = htonl((s8) call->net->uuid.node[loop]);
 
-	if (ifs) {
-		for (loop = 0; loop < nifs; loop++) {
-			reply.ia.ifaddr[loop] = ifs[loop].address.s_addr;
-			reply.ia.netmask[loop] = ifs[loop].netmask.s_addr;
-			reply.ia.mtu[loop] = htonl(ifs[loop].mtu);
-		}
-		kfree(ifs);
-	}
-
 	reply.cap.capcount = htonl(1);
 	reply.cap.caps[0] = htonl(AFS_CAP_ERROR_TRANSLATION);
 	afs_send_simple_reply(call, &reply, sizeof(reply));
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 2073c1a3ab4b..a22fa3b77b3c 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -724,15 +724,6 @@ struct afs_permits {
 	struct afs_permit	permits[];	/* List of permits sorted by key pointer */
 };
 
-/*
- * record of one of a system's set of network interfaces
- */
-struct afs_interface {
-	struct in_addr	address;	/* IPv4 address bound to interface */
-	struct in_addr	netmask;	/* netmask applied to address */
-	unsigned	mtu;		/* MTU of interface */
-};
-
 /*
  * Error prioritisation and accumulation.
  */
@@ -1095,12 +1086,6 @@ extern const struct file_operations afs_mntpt_file_operations;
 extern struct vfsmount *afs_d_automount(struct path *);
 extern void afs_mntpt_kill_timer(void);
 
-/*
- * netdevices.c
- */
-extern int afs_get_ipv4_interfaces(struct afs_net *, struct afs_interface *,
-				   size_t, bool);
-
 /*
  * proc.c
  */
diff --git a/fs/afs/netdevices.c b/fs/afs/netdevices.c
deleted file mode 100644
index 2a009d1939d7..000000000000
--- a/fs/afs/netdevices.c
+++ /dev/null
@@ -1,48 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* AFS network device helpers
- *
- * Copyright (c) 2007 Patrick McHardy <kaber@trash.net>
- */
-
-#include <linux/string.h>
-#include <linux/rtnetlink.h>
-#include <linux/inetdevice.h>
-#include <linux/netdevice.h>
-#include <linux/if_arp.h>
-#include <net/net_namespace.h>
-#include "internal.h"
-
-/*
- * get a list of this system's interface IPv4 addresses, netmasks and MTUs
- * - maxbufs must be at least 1
- * - returns the number of interface records in the buffer
- */
-int afs_get_ipv4_interfaces(struct afs_net *net, struct afs_interface *bufs,
-			    size_t maxbufs, bool wantloopback)
-{
-	struct net_device *dev;
-	struct in_device *idev;
-	int n = 0;
-
-	ASSERT(maxbufs > 0);
-
-	rtnl_lock();
-	for_each_netdev(net->net, dev) {
-		if (dev->type == ARPHRD_LOOPBACK && !wantloopback)
-			continue;
-		idev = __in_dev_get_rtnl(dev);
-		if (!idev)
-			continue;
-		for_primary_ifa(idev) {
-			bufs[n].address.s_addr = ifa->ifa_address;
-			bufs[n].netmask.s_addr = ifa->ifa_mask;
-			bufs[n].mtu = dev->mtu;
-			n++;
-			if (n >= maxbufs)
-				goto out;
-		} endfor_ifa(idev);
-	}
-out:
-	rtnl_unlock();
-	return n;
-}
-- 
2.21.0


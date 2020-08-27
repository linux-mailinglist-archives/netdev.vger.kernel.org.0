Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00F9254856
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgH0PFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:05:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54855 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbgH0PEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 11:04:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598540688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZIzacdceQxyAsGSFM69AcScMy959DgBMC/5cYnsNrX8=;
        b=HaJy2Ft9DXQg6goOT5kCRV7eg7E5Z8O0AEZ4dfo6M1lS1/O/3GKzSAaNG+AUdjc839rkkN
        eSt3q2ulVQEqR2AE/NP2l34vrONrK6JI3MnX6jv4+Ta5AZtohQxuIifP2X9W3Z/4fxKvLF
        EoQFI+0Fv0c81tDirx2WtjNEvl9xs9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-K1KKrW_XPD2PXuRr1mASdA-1; Thu, 27 Aug 2020 11:04:44 -0400
X-MC-Unique: K1KKrW_XPD2PXuRr1mASdA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE5C41934C42;
        Thu, 27 Aug 2020 15:04:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-127.rdu2.redhat.com [10.10.120.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07EF461100;
        Thu, 27 Aug 2020 15:04:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 6/7] afs: Don't use VL probe running state to make
 decisions outside probe code
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 27 Aug 2020 16:04:15 +0100
Message-ID: <159854065521.1382667.40876289707173767.stgit@warthog.procyon.org.uk>
In-Reply-To: <159854061331.1382667.9693163318506702951.stgit@warthog.procyon.org.uk>
References: <159854061331.1382667.9693163318506702951.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't use the running state for VL server probes to make decisions about
which server to use as the state is cleared at the start of a probe and
intermediate values might also be misleading.

Instead, add a separate 'latest known' rtt in the afs_vlserver struct and a
flag to indicate if the server is known to be responding and update these
as and when we know what to change them to.

Fixes: 3bf0fb6f33dd ("afs: Probe multiple fileservers simultaneously")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/internal.h  |    4 +++-
 fs/afs/proc.c      |    2 +-
 fs/afs/vl_list.c   |    1 +
 fs/afs/vl_probe.c  |   57 ++++++++++++++++++++++++++++++++++++----------------
 fs/afs/vl_rotate.c |    2 +-
 5 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index b29dfcfe5fc2..18042b7dab6a 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -401,15 +401,17 @@ struct afs_vlserver {
 #define AFS_VLSERVER_FL_PROBED	0		/* The VL server has been probed */
 #define AFS_VLSERVER_FL_PROBING	1		/* VL server is being probed */
 #define AFS_VLSERVER_FL_IS_YFS	2		/* Server is YFS not AFS */
+#define AFS_VLSERVER_FL_RESPONDING 3		/* VL server is responding */
 	rwlock_t		lock;		/* Lock on addresses */
 	atomic_t		usage;
+	unsigned int		rtt;		/* Server's current RTT in uS */
 
 	/* Probe state */
 	wait_queue_head_t	probe_wq;
 	atomic_t		probe_outstanding;
 	spinlock_t		probe_lock;
 	struct {
-		unsigned int	rtt;		/* RTT as ktime/64 */
+		unsigned int	rtt;		/* RTT in uS */
 		u32		abort_code;
 		short		error;
 		unsigned short	flags;
diff --git a/fs/afs/proc.c b/fs/afs/proc.c
index 5e837155f1a0..e8babb62ed44 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -310,7 +310,7 @@ static int afs_proc_cell_vlservers_show(struct seq_file *m, void *v)
 				   alist->preferred == i ? '>' : '-',
 				   &alist->addrs[i].transport);
 	}
-	seq_printf(m, " info: fl=%lx rtt=%d\n", vlserver->flags, vlserver->probe.rtt);
+	seq_printf(m, " info: fl=%lx rtt=%d\n", vlserver->flags, vlserver->rtt);
 	seq_printf(m, " probe: fl=%x e=%d ac=%d out=%d\n",
 		   vlserver->probe.flags, vlserver->probe.error,
 		   vlserver->probe.abort_code,
diff --git a/fs/afs/vl_list.c b/fs/afs/vl_list.c
index 8fea54eba0c2..38b2ba1d9ec0 100644
--- a/fs/afs/vl_list.c
+++ b/fs/afs/vl_list.c
@@ -21,6 +21,7 @@ struct afs_vlserver *afs_alloc_vlserver(const char *name, size_t name_len,
 		rwlock_init(&vlserver->lock);
 		init_waitqueue_head(&vlserver->probe_wq);
 		spin_lock_init(&vlserver->probe_lock);
+		vlserver->rtt = UINT_MAX;
 		vlserver->name_len = name_len;
 		vlserver->port = port;
 		memcpy(vlserver->name, name, name_len);
diff --git a/fs/afs/vl_probe.c b/fs/afs/vl_probe.c
index a6d04b4fbf56..d1c7068b4346 100644
--- a/fs/afs/vl_probe.c
+++ b/fs/afs/vl_probe.c
@@ -11,15 +11,33 @@
 #include "internal.h"
 #include "protocol_yfs.h"
 
-static bool afs_vl_probe_done(struct afs_vlserver *server)
+
+/*
+ * Handle the completion of a set of probes.
+ */
+static void afs_finished_vl_probe(struct afs_vlserver *server)
 {
-	if (!atomic_dec_and_test(&server->probe_outstanding))
-		return false;
+	if (!(server->probe.flags & AFS_VLSERVER_PROBE_RESPONDED)) {
+		server->rtt = UINT_MAX;
+		clear_bit(AFS_VLSERVER_FL_RESPONDING, &server->flags);
+	}
 
-	wake_up_var(&server->probe_outstanding);
 	clear_bit_unlock(AFS_VLSERVER_FL_PROBING, &server->flags);
 	wake_up_bit(&server->flags, AFS_VLSERVER_FL_PROBING);
-	return true;
+}
+
+/*
+ * Handle the completion of a probe RPC call.
+ */
+static void afs_done_one_vl_probe(struct afs_vlserver *server, bool wake_up)
+{
+	if (atomic_dec_and_test(&server->probe_outstanding)) {
+		afs_finished_vl_probe(server);
+		wake_up = true;
+	}
+
+	if (wake_up)
+		wake_up_all(&server->probe_wq);
 }
 
 /*
@@ -52,8 +70,13 @@ void afs_vlserver_probe_result(struct afs_call *call)
 		goto responded;
 	case -ENOMEM:
 	case -ENONET:
+	case -EKEYEXPIRED:
+	case -EKEYREVOKED:
+	case -EKEYREJECTED:
 		server->probe.flags |= AFS_VLSERVER_PROBE_LOCAL_FAILURE;
-		afs_io_error(call, afs_io_error_vl_probe_fail);
+		if (server->probe.error == 0)
+			server->probe.error = ret;
+		trace_afs_io_error(call->debug_id, ret, afs_io_error_vl_probe_fail);
 		goto out;
 	case -ECONNRESET: /* Responded, but call expired. */
 	case -ERFKILL:
@@ -72,7 +95,7 @@ void afs_vlserver_probe_result(struct afs_call *call)
 		     server->probe.error == -ETIMEDOUT ||
 		     server->probe.error == -ETIME))
 			server->probe.error = ret;
-		afs_io_error(call, afs_io_error_vl_probe_fail);
+		trace_afs_io_error(call->debug_id, ret, afs_io_error_vl_probe_fail);
 		goto out;
 	}
 
@@ -95,22 +118,22 @@ void afs_vlserver_probe_result(struct afs_call *call)
 	if (rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us) &&
 	    rtt_us < server->probe.rtt) {
 		server->probe.rtt = rtt_us;
+		server->rtt = rtt_us;
 		alist->preferred = index;
-		have_result = true;
 	}
 
 	smp_wmb(); /* Set rtt before responded. */
 	server->probe.flags |= AFS_VLSERVER_PROBE_RESPONDED;
 	set_bit(AFS_VLSERVER_FL_PROBED, &server->flags);
+	set_bit(AFS_VLSERVER_FL_RESPONDING, &server->flags);
+	have_result = true;
 out:
 	spin_unlock(&server->probe_lock);
 
 	_debug("probe [%u][%u] %pISpc rtt=%u ret=%d",
 	       server_index, index, &alist->addrs[index].transport, rtt_us, ret);
 
-	have_result |= afs_vl_probe_done(server);
-	if (have_result)
-		wake_up_all(&server->probe_wq);
+	afs_done_one_vl_probe(server, have_result);
 }
 
 /*
@@ -148,11 +171,10 @@ static bool afs_do_probe_vlserver(struct afs_net *net,
 			in_progress = true;
 		} else {
 			afs_prioritise_error(_e, PTR_ERR(call), ac.abort_code);
+			afs_done_one_vl_probe(server, false);
 		}
 	}
 
-	if (!in_progress)
-		afs_vl_probe_done(server);
 	return in_progress;
 }
 
@@ -190,7 +212,7 @@ int afs_wait_for_vl_probes(struct afs_vlserver_list *vllist,
 {
 	struct wait_queue_entry *waits;
 	struct afs_vlserver *server;
-	unsigned int rtt = UINT_MAX;
+	unsigned int rtt = UINT_MAX, rtt_s;
 	bool have_responders = false;
 	int pref = -1, i;
 
@@ -246,10 +268,11 @@ int afs_wait_for_vl_probes(struct afs_vlserver_list *vllist,
 	for (i = 0; i < vllist->nr_servers; i++) {
 		if (test_bit(i, &untried)) {
 			server = vllist->servers[i].server;
-			if ((server->probe.flags & AFS_VLSERVER_PROBE_RESPONDED) &&
-			    server->probe.rtt < rtt) {
+			rtt_s = READ_ONCE(server->rtt);
+			if (test_bit(AFS_VLSERVER_FL_RESPONDING, &server->flags) &&
+			    rtt_s < rtt) {
 				pref = i;
-				rtt = server->probe.rtt;
+				rtt = rtt_s;
 			}
 
 			remove_wait_queue(&server->probe_wq, &waits[i]);
diff --git a/fs/afs/vl_rotate.c b/fs/afs/vl_rotate.c
index ed2609e82695..ab2beb4ba20e 100644
--- a/fs/afs/vl_rotate.c
+++ b/fs/afs/vl_rotate.c
@@ -193,7 +193,7 @@ bool afs_select_vlserver(struct afs_vl_cursor *vc)
 		struct afs_vlserver *s = vc->server_list->servers[i].server;
 
 		if (!test_bit(i, &vc->untried) ||
-		    !(s->probe.flags & AFS_VLSERVER_PROBE_RESPONDED))
+		    !test_bit(AFS_VLSERVER_FL_RESPONDING, &s->flags))
 			continue;
 		if (s->probe.rtt < rtt) {
 			vc->index = i;



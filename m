Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5744C25485D
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgH0PGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:06:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21287 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728085AbgH0PEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 11:04:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598540676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=srJBFaXGiETnnPKliXer9E/cTLFGWxQi5XoK97RhbGs=;
        b=YrYFt0ZmqUh6ZqdxH3Kj/hEvaJ7NMHyG0hkJvEpmxMrlVrvKMw0IqmZwQFqoRBqIupo5A/
        0ZnJNjhIPUX+Ub2qLfAuDFSsbIox/5f6Rvsk+LuveUsM5mNzvQYGrSJJguaaQjdRGDNtEQ
        grYxwrYhJMfdhpg86QkR0gW2a4ehVyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-LRTHlvAuNB6t4CWuUEeSrw-1; Thu, 27 Aug 2020 11:04:33 -0400
X-MC-Unique: LRTHlvAuNB6t4CWuUEeSrw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F20948B068F;
        Thu, 27 Aug 2020 15:04:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-127.rdu2.redhat.com [10.10.120.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DACA610AF;
        Thu, 27 Aug 2020 15:04:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 5/7] afs: Expose information from afs_vlserver through
 /proc for debugging
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 27 Aug 2020 16:04:08 +0100
Message-ID: <159854064824.1382667.3944758084897466812.stgit@warthog.procyon.org.uk>
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

Convert various bitfields in afs_vlserver::probe to a mask and then expose
this and some other bits of information through /proc/net/afs/<cell>/vlservers
to make it easier to debug VL server communication issues.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/internal.h  |    9 +++++----
 fs/afs/proc.c      |    5 +++++
 fs/afs/vl_probe.c  |   20 ++++++++++----------
 fs/afs/vl_rotate.c |    3 ++-
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 2e6ae6388c72..b29dfcfe5fc2 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -412,10 +412,11 @@ struct afs_vlserver {
 		unsigned int	rtt;		/* RTT as ktime/64 */
 		u32		abort_code;
 		short		error;
-		bool		responded:1;
-		bool		is_yfs:1;
-		bool		not_yfs:1;
-		bool		local_failure:1;
+		unsigned short	flags;
+#define AFS_VLSERVER_PROBE_RESPONDED		0x01 /* At least once response (may be abort) */
+#define AFS_VLSERVER_PROBE_IS_YFS		0x02 /* The peer appears to be YFS */
+#define AFS_VLSERVER_PROBE_NOT_YFS		0x04 /* The peer appears not to be YFS */
+#define AFS_VLSERVER_PROBE_LOCAL_FAILURE	0x08 /* A local failure prevented a probe */
 	} probe;
 
 	u16			port;
diff --git a/fs/afs/proc.c b/fs/afs/proc.c
index e817fc740ba0..5e837155f1a0 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -310,6 +310,11 @@ static int afs_proc_cell_vlservers_show(struct seq_file *m, void *v)
 				   alist->preferred == i ? '>' : '-',
 				   &alist->addrs[i].transport);
 	}
+	seq_printf(m, " info: fl=%lx rtt=%d\n", vlserver->flags, vlserver->probe.rtt);
+	seq_printf(m, " probe: fl=%x e=%d ac=%d out=%d\n",
+		   vlserver->probe.flags, vlserver->probe.error,
+		   vlserver->probe.abort_code,
+		   atomic_read(&vlserver->probe_outstanding));
 	return 0;
 }
 
diff --git a/fs/afs/vl_probe.c b/fs/afs/vl_probe.c
index ee59188433b9..a6d04b4fbf56 100644
--- a/fs/afs/vl_probe.c
+++ b/fs/afs/vl_probe.c
@@ -45,14 +45,14 @@ void afs_vlserver_probe_result(struct afs_call *call)
 		server->probe.error = 0;
 		goto responded;
 	case -ECONNABORTED:
-		if (!server->probe.responded) {
+		if (!(server->probe.flags & AFS_VLSERVER_PROBE_RESPONDED)) {
 			server->probe.abort_code = call->abort_code;
 			server->probe.error = ret;
 		}
 		goto responded;
 	case -ENOMEM:
 	case -ENONET:
-		server->probe.local_failure = true;
+		server->probe.flags |= AFS_VLSERVER_PROBE_LOCAL_FAILURE;
 		afs_io_error(call, afs_io_error_vl_probe_fail);
 		goto out;
 	case -ECONNRESET: /* Responded, but call expired. */
@@ -67,7 +67,7 @@ void afs_vlserver_probe_result(struct afs_call *call)
 	default:
 		clear_bit(index, &alist->responded);
 		set_bit(index, &alist->failed);
-		if (!server->probe.responded &&
+		if (!(server->probe.flags & AFS_VLSERVER_PROBE_RESPONDED) &&
 		    (server->probe.error == 0 ||
 		     server->probe.error == -ETIMEDOUT ||
 		     server->probe.error == -ETIME))
@@ -81,12 +81,12 @@ void afs_vlserver_probe_result(struct afs_call *call)
 	clear_bit(index, &alist->failed);
 
 	if (call->service_id == YFS_VL_SERVICE) {
-		server->probe.is_yfs = true;
+		server->probe.flags |= AFS_VLSERVER_PROBE_IS_YFS;
 		set_bit(AFS_VLSERVER_FL_IS_YFS, &server->flags);
 		alist->addrs[index].srx_service = call->service_id;
 	} else {
-		server->probe.not_yfs = true;
-		if (!server->probe.is_yfs) {
+		server->probe.flags |= AFS_VLSERVER_PROBE_NOT_YFS;
+		if (!(server->probe.flags & AFS_VLSERVER_PROBE_IS_YFS)) {
 			clear_bit(AFS_VLSERVER_FL_IS_YFS, &server->flags);
 			alist->addrs[index].srx_service = call->service_id;
 		}
@@ -100,7 +100,7 @@ void afs_vlserver_probe_result(struct afs_call *call)
 	}
 
 	smp_wmb(); /* Set rtt before responded. */
-	server->probe.responded = true;
+	server->probe.flags |= AFS_VLSERVER_PROBE_RESPONDED;
 	set_bit(AFS_VLSERVER_FL_PROBED, &server->flags);
 out:
 	spin_unlock(&server->probe_lock);
@@ -202,7 +202,7 @@ int afs_wait_for_vl_probes(struct afs_vlserver_list *vllist,
 			server = vllist->servers[i].server;
 			if (!test_bit(AFS_VLSERVER_FL_PROBING, &server->flags))
 				__clear_bit(i, &untried);
-			if (server->probe.responded)
+			if (server->probe.flags & AFS_VLSERVER_PROBE_RESPONDED)
 				have_responders = true;
 		}
 	}
@@ -228,7 +228,7 @@ int afs_wait_for_vl_probes(struct afs_vlserver_list *vllist,
 		for (i = 0; i < vllist->nr_servers; i++) {
 			if (test_bit(i, &untried)) {
 				server = vllist->servers[i].server;
-				if (server->probe.responded)
+				if (server->probe.flags & AFS_VLSERVER_PROBE_RESPONDED)
 					goto stop;
 				if (test_bit(AFS_VLSERVER_FL_PROBING, &server->flags))
 					still_probing = true;
@@ -246,7 +246,7 @@ int afs_wait_for_vl_probes(struct afs_vlserver_list *vllist,
 	for (i = 0; i < vllist->nr_servers; i++) {
 		if (test_bit(i, &untried)) {
 			server = vllist->servers[i].server;
-			if (server->probe.responded &&
+			if ((server->probe.flags & AFS_VLSERVER_PROBE_RESPONDED) &&
 			    server->probe.rtt < rtt) {
 				pref = i;
 				rtt = server->probe.rtt;
diff --git a/fs/afs/vl_rotate.c b/fs/afs/vl_rotate.c
index f405ca8b240a..ed2609e82695 100644
--- a/fs/afs/vl_rotate.c
+++ b/fs/afs/vl_rotate.c
@@ -192,7 +192,8 @@ bool afs_select_vlserver(struct afs_vl_cursor *vc)
 	for (i = 0; i < vc->server_list->nr_servers; i++) {
 		struct afs_vlserver *s = vc->server_list->servers[i].server;
 
-		if (!test_bit(i, &vc->untried) || !s->probe.responded)
+		if (!test_bit(i, &vc->untried) ||
+		    !(s->probe.flags & AFS_VLSERVER_PROBE_RESPONDED))
 			continue;
 		if (s->probe.rtt < rtt) {
 			vc->index = i;



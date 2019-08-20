Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2D096C48
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbfHTWdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37002 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731019AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jDclIThSgBOsZNs2p2vTHcleRank21BP0iRlpVH7o5A=; b=tMWvCkw8uv4yV3+uG4vJGufBsA
        hbdihTdlgVllhyvKkHChJRMYUbDwPBUoCxwaabn9IW0ZjYhZR3OVemdDSDB2jOUUBFyjuQavpHcxE
        CjYKp2hk+rXMjS7254huNcNy6QhpT6ofrPKJm7m1amSzM2ngPP7LbuaCujzxnCo/JyuKDlFaX+7Zp
        NMNS+qs57f73G0azqS2Y9ws8czKkRw+AUboIaM2BbtZi8Rtf76Vui99KaJOn01n1yuTa1hsTCy3P3
        X+nYWfgxshvvKg8lGB+bfvsuVCIle/LpTrcdcYj1fPHj4xzofvnrbUYaFUR6uQaCVsj0LKG6y9sUZ
        2UW8HQnQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005re-Rr; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 22/38] sctp: Convert sctp_assocs_id to XArray
Date:   Tue, 20 Aug 2019 15:32:43 -0700
Message-Id: <20190820223259.22348-23-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

This is a fairly straightforward conversion.  The load side could be
converted to RCU by appropriate handling of races between delete and
lookup (eg RCU-freeing the sctp_association).  One point to note is
that sctp_assoc_set_id() will now return 1 if the allocation wrapped;
I have converted the callers to check for an error using '< 0' instead
of '!= 0'.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/sctp/sctp.h  |  5 ++---
 net/sctp/associola.c     | 34 +++++++++-------------------------
 net/sctp/protocol.c      |  6 ------
 net/sctp/sm_make_chunk.c |  2 +-
 net/sctp/socket.c        |  6 +++---
 5 files changed, 15 insertions(+), 38 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 5d60f13d2347..4bcce5d052d1 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -47,7 +47,7 @@
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
-#include <linux/idr.h>
+#include <linux/xarray.h>
 
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6.h>
@@ -462,8 +462,7 @@ extern struct proto sctp_prot;
 extern struct proto sctpv6_prot;
 void sctp_put_port(struct sock *sk);
 
-extern struct idr sctp_assocs_id;
-extern spinlock_t sctp_assocs_id_lock;
+extern struct xarray sctp_assocs_id;
 
 /* Static inline functions. */
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 5010cce52c93..4d6baecbdb99 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -39,6 +39,9 @@
 #include <net/sctp/sctp.h>
 #include <net/sctp/sm.h>
 
+DEFINE_XARRAY_FLAGS(sctp_assocs_id, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);
+static u32 sctp_assocs_next_id;
+
 /* Forward declarations for internal functions. */
 static void sctp_select_active_and_retran_path(struct sctp_association *asoc);
 static void sctp_assoc_bh_rcv(struct work_struct *work);
@@ -412,11 +415,8 @@ static void sctp_association_destroy(struct sctp_association *asoc)
 	sctp_endpoint_put(asoc->ep);
 	sock_put(asoc->base.sk);
 
-	if (asoc->assoc_id != 0) {
-		spin_lock_bh(&sctp_assocs_id_lock);
-		idr_remove(&sctp_assocs_id, asoc->assoc_id);
-		spin_unlock_bh(&sctp_assocs_id_lock);
-	}
+	if (asoc->assoc_id != 0)
+		xa_erase_bh(&sctp_assocs_id, asoc->assoc_id);
 
 	WARN_ON(atomic_read(&asoc->rmem_alloc));
 
@@ -1177,7 +1177,7 @@ int sctp_assoc_update(struct sctp_association *asoc,
 			sctp_stream_update(&asoc->stream, &new->stream);
 
 		/* get a new assoc id if we don't have one yet. */
-		if (sctp_assoc_set_id(asoc, GFP_ATOMIC))
+		if (sctp_assoc_set_id(asoc, GFP_ATOMIC) < 0)
 			return -ENOMEM;
 	}
 
@@ -1624,29 +1624,13 @@ int sctp_assoc_lookup_laddr(struct sctp_association *asoc,
 /* Set an association id for a given association */
 int sctp_assoc_set_id(struct sctp_association *asoc, gfp_t gfp)
 {
-	bool preload = gfpflags_allow_blocking(gfp);
-	int ret;
-
 	/* If the id is already assigned, keep it. */
 	if (asoc->assoc_id)
 		return 0;
 
-	if (preload)
-		idr_preload(gfp);
-	spin_lock_bh(&sctp_assocs_id_lock);
-	/* 0, 1, 2 are used as SCTP_FUTURE_ASSOC, SCTP_CURRENT_ASSOC and
-	 * SCTP_ALL_ASSOC, so an available id must be > SCTP_ALL_ASSOC.
-	 */
-	ret = idr_alloc_cyclic(&sctp_assocs_id, asoc, SCTP_ALL_ASSOC + 1, 0,
-			       GFP_NOWAIT);
-	spin_unlock_bh(&sctp_assocs_id_lock);
-	if (preload)
-		idr_preload_end();
-	if (ret < 0)
-		return ret;
-
-	asoc->assoc_id = (sctp_assoc_t)ret;
-	return 0;
+	return xa_alloc_cyclic_bh(&sctp_assocs_id, &asoc->assoc_id, asoc,
+			XA_LIMIT(SCTP_ALL_ASSOC + 1, INT_MAX),
+			&sctp_assocs_next_id, gfp);
 }
 
 /* Free the ASCONF queue */
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 2d47adcb4cbe..79ccc786e5c9 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -50,9 +50,6 @@
 /* Global data structures. */
 struct sctp_globals sctp_globals __read_mostly;
 
-struct idr sctp_assocs_id;
-DEFINE_SPINLOCK(sctp_assocs_id_lock);
-
 static struct sctp_pf *sctp_pf_inet6_specific;
 static struct sctp_pf *sctp_pf_inet_specific;
 static struct sctp_af *sctp_af_v4_specific;
@@ -1388,9 +1385,6 @@ static __init int sctp_init(void)
 	sctp_max_instreams    		= SCTP_DEFAULT_INSTREAMS;
 	sctp_max_outstreams   		= SCTP_DEFAULT_OUTSTREAMS;
 
-	/* Initialize handle used for association ids. */
-	idr_init(&sctp_assocs_id);
-
 	limit = nr_free_buffer_pages() / 8;
 	limit = max(limit, 128UL);
 	sysctl_sctp_mem[0] = limit / 4 * 3;
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 36bd8a6e82df..f049cfad6cf8 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2443,7 +2443,7 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 	/* Update frag_point when stream_interleave may get changed. */
 	sctp_assoc_update_frag_point(asoc);
 
-	if (!asoc->temp && sctp_assoc_set_id(asoc, gfp))
+	if (!asoc->temp && sctp_assoc_set_id(asoc, gfp) < 0)
 		goto clean_up;
 
 	/* ADDIP Section 4.1 ASCONF Chunk Procedures
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 12503e16fa96..0df05adfd033 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -236,11 +236,11 @@ struct sctp_association *sctp_id2assoc(struct sock *sk, sctp_assoc_t id)
 	if (id <= SCTP_ALL_ASSOC)
 		return NULL;
 
-	spin_lock_bh(&sctp_assocs_id_lock);
-	asoc = (struct sctp_association *)idr_find(&sctp_assocs_id, (int)id);
+	xa_lock_bh(&sctp_assocs_id);
+	asoc = xa_load(&sctp_assocs_id, id);
 	if (asoc && (asoc->base.sk != sk || asoc->base.dead))
 		asoc = NULL;
-	spin_unlock_bh(&sctp_assocs_id_lock);
+	xa_unlock_bh(&sctp_assocs_id);
 
 	return asoc;
 }
-- 
2.23.0.rc1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912A7547CF9
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 01:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbiFLXqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 19:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbiFLXqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 19:46:47 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E5733E90;
        Sun, 12 Jun 2022 16:46:46 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 59219C021; Mon, 13 Jun 2022 01:46:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655077604; bh=2pvlijFDTdPy9Af9WUD9+Wbr74cNH9134iAYt88GOw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuXZzdMpCQ09shJr9vF+fojJQ74BKY8yQzfvnxH5xDnKW3clFGVUummVSi5sRDfyZ
         olP6thlDBnF1d/9N3dZiJdZ3z9ZUGj5/rbfCgKSYUzpf7AnFtN/ysDcEhuWzMtD0HG
         PsDRke7ctH+zolmky3t55uC5qjegTeSzo9E498LIBp91Kprlx0/KaZLAEKU+MzrlBM
         GEgbmDB+Zb5REleAZUH2nmgrtN+OYjN86UNNQ/L+I+IBeo33WOlBmlq2WdcvlP2anF
         qg8c5+WVgYX+LdVLWsSSYy4meN0+59BxuQ235DGPEj4QJUj8ZWuWJ0VApyLriUYmVX
         crh+OW+OZ1hbA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 356DDC009;
        Mon, 13 Jun 2022 01:46:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655077602; bh=2pvlijFDTdPy9Af9WUD9+Wbr74cNH9134iAYt88GOw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhUREBEUmhaehV0h9eJmC0PfubUWASYQ1mb+vGrNXfqTugLMZJyxa4dYrnhApTfsN
         P0DoTY4aeZ/QIs9zSUe4FIvFWcM/moUAPmeSBAxldYHzQ0zqd+cV/mk4f9rkQKbRbK
         iVx3T3n4RkadZa0CnpwcHuegv3Dz/5fWBT6aILy5LM3ATs8Q5uO5TS3zSpX+y/aI5F
         O6i6KVSYr+faQNACtHlctsmyn+U0bAE1oAg9Pzru1PUPKrznfNYlpU/In62PNrguRL
         0BIzmjj0F+y/Zdi+RVg+YlCfhl6pfXnjjr3FDgFg9gcmuBnwfiM8c7MhlYswb5reaT
         wrYeOOIl6QEEw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 498e4e6d;
        Sun, 12 Jun 2022 23:46:36 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 05/06] 9p fid refcount: add a 9p_fid_ref tracepoint
Date:   Mon, 13 Jun 2022 08:46:34 +0900
Message-Id: <20220612234634.1559778-1-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220612184659.6dff5107@rorschach.local.home>
References: <20220612184659.6dff5107@rorschach.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a tracepoint event for 9p fid lifecycle tracing: when a fid
is created, its reference count increased/decreased, and freed.
The new 9p_fid_ref tracepoint should help anyone wishing to debug any
fid problem such as missing clunk (destroy) or use-after-free.

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---

Steven, thank you for the review!

By changelog, is the commit message enough?

I've applied your suggestion to use DECLARE_TRACEPOINT + enable checks,
it doesn't seem to have many users but it looks good to me.

v1-v2:
 - added rationale to commit message
 - adjusted to use DECLARE_TRACEPOINT + tracepoint_enable() in header

 include/net/9p/client.h   | 13 +++++++++++
 include/trace/events/9p.h | 48 +++++++++++++++++++++++++++++++++++++++
 net/9p/client.c           | 17 +++++++++++++-
 3 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 9fd38d674057..6f347983705d 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -11,6 +11,7 @@
 
 #include <linux/utsname.h>
 #include <linux/idr.h>
+#include <linux/tracepoint-defs.h>
 
 /* Number of requests per row */
 #define P9_ROW_MAXTAG 255
@@ -237,8 +238,17 @@ static inline int p9_req_try_get(struct p9_req_t *r)
 
 int p9_req_put(struct p9_req_t *r);
 
+/* We cannot have the real tracepoints in header files,
+ * use a wrapper function */
+DECLARE_TRACEPOINT(9p_fid_ref);
+void do_trace_9p_fid_get(struct p9_fid *fid);
+void do_trace_9p_fid_put(struct p9_fid *fid);
+
 static inline struct p9_fid *p9_fid_get(struct p9_fid *fid)
 {
+	if (tracepoint_enabled(9p_fid_ref))
+		do_trace_9p_fid_get(fid);
+
 	refcount_inc(&fid->count);
 
 	return fid;
@@ -249,6 +259,9 @@ static inline int p9_fid_put(struct p9_fid *fid)
 	if (!fid || IS_ERR(fid))
 		return 0;
 
+	if (tracepoint_enabled(9p_fid_ref))
+		do_trace_9p_fid_put(fid);
+
 	if (!refcount_dec_and_test(&fid->count))
 		return 0;
 
diff --git a/include/trace/events/9p.h b/include/trace/events/9p.h
index 78c5608a1648..4dfa6d7f83ba 100644
--- a/include/trace/events/9p.h
+++ b/include/trace/events/9p.h
@@ -77,6 +77,13 @@
 		EM( P9_TWSTAT,		"P9_TWSTAT" )			\
 		EMe(P9_RWSTAT,		"P9_RWSTAT" )
 
+
+#define P9_FID_REFTYPE							\
+		EM( P9_FID_REF_CREATE,	"create " )			\
+		EM( P9_FID_REF_GET,	"get    " )			\
+		EM( P9_FID_REF_PUT,	"put    " )			\
+		EMe(P9_FID_REF_DESTROY,	"destroy" )
+
 /* Define EM() to export the enums to userspace via TRACE_DEFINE_ENUM() */
 #undef EM
 #undef EMe
@@ -84,6 +91,21 @@
 #define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
 P9_MSG_T
+P9_FID_REFTYPE
+
+/* And also use EM/EMe to define helper enums -- once */
+#ifndef __9P_DECLARE_TRACE_ENUMS_ONLY_ONCE
+#define __9P_DECLARE_TRACE_ENUMS_ONLY_ONCE
+#undef EM
+#undef EMe
+#define EM(a, b)	a,
+#define EMe(a, b)	a
+
+enum p9_fid_reftype {
+	P9_FID_REFTYPE
+} __mode(byte);
+
+#endif
 
 /*
  * Now redefine the EM() and EMe() macros to map the enums to the strings
@@ -96,6 +118,8 @@ P9_MSG_T
 
 #define show_9p_op(type)						\
 	__print_symbolic(type, P9_MSG_T)
+#define show_9p_fid_reftype(type)					\
+	__print_symbolic(type, P9_FID_REFTYPE)
 
 TRACE_EVENT(9p_client_req,
 	    TP_PROTO(struct p9_client *clnt, int8_t type, int tag),
@@ -168,6 +192,30 @@ TRACE_EVENT(9p_protocol_dump,
 		      __entry->tag, 0, __entry->line, 16, __entry->line + 16)
  );
 
+
+TRACE_EVENT(9p_fid_ref,
+	    TP_PROTO(struct p9_fid *fid, __u8 type),
+
+	    TP_ARGS(fid, type),
+
+	    TP_STRUCT__entry(
+		    __field(	int,	fid		)
+		    __field(	int,	refcount	)
+		    __field(	__u8, type	)
+		    ),
+
+	    TP_fast_assign(
+		    __entry->fid = fid->fid;
+		    __entry->refcount = refcount_read(&fid->count);
+		    __entry->type = type;
+		    ),
+
+	    TP_printk("%s fid %d, refcount %d",
+		      show_9p_fid_reftype(__entry->type),
+		      __entry->fid, __entry->refcount)
+);
+
+
 #endif /* _TRACE_9P_H */
 
 /* This part must be outside protection */
diff --git a/net/9p/client.c b/net/9p/client.c
index f3eb280c7d9d..06d67a02d431 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -907,8 +907,10 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
 			    GFP_NOWAIT);
 	spin_unlock_irq(&clnt->lock);
 	idr_preload_end();
-	if (!ret)
+	if (!ret) {
+		trace_9p_fid_ref(fid, P9_FID_REF_CREATE);
 		return fid;
+	}
 
 	kfree(fid);
 	return NULL;
@@ -920,6 +922,7 @@ static void p9_fid_destroy(struct p9_fid *fid)
 	unsigned long flags;
 
 	p9_debug(P9_DEBUG_FID, "fid %d\n", fid->fid);
+	trace_9p_fid_ref(fid, P9_FID_REF_DESTROY);
 	clnt = fid->clnt;
 	spin_lock_irqsave(&clnt->lock, flags);
 	idr_remove(&clnt->fids, fid->fid);
@@ -928,6 +931,18 @@ static void p9_fid_destroy(struct p9_fid *fid)
 	kfree(fid);
 }
 
+void do_trace_9p_fid_get(struct p9_fid *fid)
+{
+	trace_9p_fid_ref(fid, P9_FID_REF_GET);
+}
+EXPORT_SYMBOL(do_trace_9p_fid_get);
+
+void do_trace_9p_fid_put(struct p9_fid *fid)
+{
+	trace_9p_fid_ref(fid, P9_FID_REF_PUT);
+}
+EXPORT_SYMBOL(do_trace_9p_fid_put);
+
 static int p9_client_version(struct p9_client *c)
 {
 	int err = 0;
-- 
2.35.1


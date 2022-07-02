Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7F5563F7A
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 12:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiGBKan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 06:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiGBKam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 06:30:42 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5A2E08C;
        Sat,  2 Jul 2022 03:30:40 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 63EF5C01B; Sat,  2 Jul 2022 12:30:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1656757838; bh=1lvkdSCyaOdC8y9a9ToTo+fuywFSxMu4CL9YLxCzz9U=;
        h=From:To:Cc:Subject:Date:From;
        b=bDGC7bSFCBO6Z7S2x/mbEYaOHk36xpAgzg/FhiiUshicKw0wOc37TvDImLMjfiWYY
         AURV6dSffe8+0B7wcTiVzwsUI+i/UN04ekylrVBDSQYcvB1dP1kwGPfbk/iHhrsnDk
         E8ObgOOrCOWCsMzhDeGhQAVRQKEXFv4bQMTex3CPisere5LgzclglKeRZPGTdD9HQz
         5qK+l/Y9ay9phVNsgU8S8MgfOvt5ukli/DjMUAH4AQu8UfQiPVsK8QBiVgMNhkVVor
         XLTCnt/gX8WzMYZEXun1tUHW80phJFVIUHLaA+nExUeUNn2L2kf3H/qg1YmZo2y705
         O+W9ltgOz86RA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 48608C009;
        Sat,  2 Jul 2022 12:30:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1656757837; bh=1lvkdSCyaOdC8y9a9ToTo+fuywFSxMu4CL9YLxCzz9U=;
        h=From:To:Cc:Subject:Date:From;
        b=l+L5hQqC9nwzlYkfp4AIT3VA2iScmNXVLM4B1lkDUr2apIjeO12ZgqonqC9yA809M
         OkIYJL2/zPX3kOBCvS7G0E1hPQs9o2IvaWuk7Wy9QIV7uswS3OAEuZlaIxh7GV1Uy6
         PU2gF6C5DV7EeJtcifOUGRtcNbX8Z6HAmyttKIp6BR3vcwL+rAZOrYT7AVbeoy3WOg
         uebfweJgllIMPb25MfabOjDSIyzbNfTBJTw0/3shH7qEls34oB3FhGXYUap1NHgc9f
         KU5Q0MGvqe1afcqr4gdTRgXETigTLR0SP/oQXHEI3Ad2hfNFj9gzgL4d4cH7P+dd0G
         QoBURDP0diNlQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 671de57d;
        Sat, 2 Jul 2022 10:30:32 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH v3] 9p fid refcount: add a 9p_fid_ref tracepoint
Date:   Sat,  2 Jul 2022 19:29:14 +0900
Message-Id: <20220702102913.2164800-1-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a tracepoint event for 9p fid lifecycle tracing: when a fid
is created, its reference count increased/decreased, and freed.
The new 9p_fid_ref tracepoint should help anyone wishing to debug any
fid problem such as missing clunk (destroy) or use-after-free.

Link: https://lkml.kernel.org/r/20220612085330.1451496-6-asmadeus@codewreck.org
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---

Just resending this single patch of the series as it's the only one
without a review tag.

Steven, is it ok to carry it in my tree as is or do I need blessings
from you or Ingo?
(it depends on the previous patch so I'd carry it in my tree anyway,
but would be more comfortable with a reviewed-by tag)


v2 -> v3:
 - added EXPORT_TRACEPOINT_SYMBOL(9p_fid_ref) to have this work when
   built as module

v1 -> v2:
 - added rationale to commit message
 - adjusted to use DECLARE_TRACEPOINT + tracepoint_enable() in header

 include/net/9p/client.h   | 13 +++++++++++
 include/trace/events/9p.h | 48 +++++++++++++++++++++++++++++++++++++++
 net/9p/client.c           | 20 +++++++++++++++-
 3 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index eabb53992350..8f629f1df865 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -11,6 +11,7 @@
 
 #include <linux/utsname.h>
 #include <linux/idr.h>
+#include <linux/tracepoint-defs.h>
 
 /* Number of requests per row */
 #define P9_ROW_MAXTAG 255
@@ -237,6 +238,12 @@ static inline int p9_req_try_get(struct p9_req_t *r)
 
 int p9_req_put(struct p9_req_t *r);
 
+/* We cannot have the real tracepoints in header files,
+ * use a wrapper function */
+DECLARE_TRACEPOINT(9p_fid_ref);
+void do_trace_9p_fid_get(struct p9_fid *fid);
+void do_trace_9p_fid_put(struct p9_fid *fid);
+
 /* fid reference counting helpers:
  *  - fids used for any length of time should always be referenced through
  *    p9_fid_get(), and released with p9_fid_put()
@@ -249,6 +256,9 @@ int p9_req_put(struct p9_req_t *r);
  */
 static inline struct p9_fid *p9_fid_get(struct p9_fid *fid)
 {
+	if (tracepoint_enabled(9p_fid_ref))
+		do_trace_9p_fid_get(fid);
+
 	refcount_inc(&fid->count);
 
 	return fid;
@@ -259,6 +269,9 @@ static inline int p9_fid_put(struct p9_fid *fid)
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
index f3eb280c7d9d..dfe8beb864fc 100644
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
@@ -928,6 +931,21 @@ static void p9_fid_destroy(struct p9_fid *fid)
 	kfree(fid);
 }
 
+/* We also need to export tracepoint symbols for tracepoint_enabled() */
+EXPORT_TRACEPOINT_SYMBOL(9p_fid_ref);
+
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


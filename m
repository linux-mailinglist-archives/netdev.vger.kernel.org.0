Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A699754796E
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 11:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbiFLJBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 05:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbiFLJBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 05:01:36 -0400
X-Greylist: delayed 409 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Jun 2022 02:01:20 PDT
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8D261628
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 02:01:19 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 6CB61C021; Sun, 12 Jun 2022 10:54:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655024070; bh=x1O5qqBGdLbV11NrLo/L1WajTuYUw+Z9SA9TZyNmXB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBe6l9uiXewZxUguj74t9srkVgkJoavvgVwUYu+CQlbYuHm90aU9n+LUAQj+J2Jdz
         t1kAHiq4dCfiqLgjwJ/8zlID1ozuVMaxX+6QHjeD21lQpeLN8+vSiD7h78W1g6gnPx
         dKJW6uQta+KjdHiaQAj3NJG20ZY/gQpAlFPImBrCvupsFOPqz+UF+4ibwnz8getD0V
         FABgntxpNj4D0D+bzll1yahcemS4Y8cacZdhnIkFpW0d+2MTcmoDexF7gcLjrDtP3g
         gmWA38hynbYL82o7OcVznZ7jkh1g6mq4LFG5irGN+XQi/kiW78K4XIT8L3NRMklESl
         rpD+BGFEPJ3TQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 37E66C01A;
        Sun, 12 Jun 2022 10:54:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655024067; bh=x1O5qqBGdLbV11NrLo/L1WajTuYUw+Z9SA9TZyNmXB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKwtyPZbH48gZKKLRhrY1oLsgi3HyFwfb8+GRYpgMe3gWn88kQZUqOsaem6OOj6Jd
         LJHc9nQhHHtsu4RHo1fQIFEIVxJHDgafYc0kZreG9Pw0aHWfZSW5KfQ5AESiloXzd8
         NMjoe04t0W62MagYvQSBiPhnRUyxgszjm3zoK20poW+mWYJGn+9Ch4y8qA2IZFeFjq
         Kt7mDcfQwKBr0YmMwmyhEQTPSC6NmN0VYN4V1bw5s2dsPay72Y0OTyDX51RfkC9g2b
         fVijnNsAGojeFaciH+2ciDmms7T0I+qd7tIsT9+26WpAJqlJTj3zJcjRqHLca/spkH
         HGpXhQE5+JhkA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 6828ecd5;
        Sun, 12 Jun 2022 08:54:14 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 05/06] 9p fid refcount: add a 9p_fid_ref tracepoint
Date:   Sun, 12 Jun 2022 17:53:28 +0900
Message-Id: <20220612085330.1451496-6-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220612085330.1451496-1-asmadeus@codewreck.org>
References: <20220612085330.1451496-1-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---

This is the first time I add a tracepoint, so if anyone has time to
check I didn't make something too stupid please have a look.
I've mostly copied from netfs'.

Also, a question if someone has time: I'd have liked to use the
tracepoint in static inline wrappers for getref/putref, but it's not
good to add the tracepoints to a .h, right?
Especially with the CREATE_TRACE_POINTS macro...
How do people usually go about that, just bite the bullet and make it
a real function?


 include/trace/events/9p.h | 48 +++++++++++++++++++++++++++++++++++++++
 net/9p/client.c           |  9 +++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

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
index 5531b31e0fb2..fdeeda0a811d 100644
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
@@ -932,6 +935,8 @@ static void p9_fid_destroy(struct p9_fid *fid)
  * because trace_* functions can't be used there easily
  */
 struct p9_fid *p9_fid_get(struct p9_fid *fid) {
+	trace_9p_fid_ref(fid, P9_FID_REF_GET);
+
 	refcount_inc(&fid->count);
 
 	return fid;
@@ -941,6 +946,8 @@ int p9_fid_put(struct p9_fid *fid) {
 	if (!fid || IS_ERR(fid))
 		return 0;
 
+	trace_9p_fid_ref(fid, P9_FID_REF_PUT);
+
         if (!refcount_dec_and_test(&fid->count))
                 return 0;
 
-- 
2.35.1


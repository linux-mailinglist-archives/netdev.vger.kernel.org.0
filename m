Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3F7635A90
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbiKWKwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbiKWKvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:51:43 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABB125FF
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:37:32 -0800 (PST)
Received: from fsav111.sakura.ne.jp (fsav111.sakura.ne.jp [27.133.134.238])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2ANAa7LC003433;
        Wed, 23 Nov 2022 19:36:07 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav111.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp);
 Wed, 23 Nov 2022 19:36:07 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2ANAa5pi003425
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 23 Nov 2022 19:36:06 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <c5ba2194-dbb6-586d-992d-9dfcd27062e7@I-love.SAKURA.ne.jp>
Date:   Wed, 23 Nov 2022 19:36:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: [PATCH] sctp: relese sctp_stream_priorities at
 sctp_stream_outq_migrate()
Content-Language: en-US
To:     syzbot <syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
References: <000000000000e99e2705edb7d6cf@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <000000000000e99e2705edb7d6cf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting memory leak on sctp_stream_priorities [1], for
sctp_stream_outq_migrate() is resetting SCTP_SO(stream, i)->ext to NULL
without clearing SCTP_SO(new, i)->ext->prio_head list allocated by
sctp_sched_prio_new_head(). Since sctp_sched_prio_free() is too late to
clear if stream->outcnt was already shrunk or SCTP_SO(stream, i)->ext
was already NULL, add a callback for clearing that list before shrinking
stream->outcnt and/or resetting SCTP_SO(stream, i)->ext.

Link: https://syzkaller.appspot.com/bug?exrid=29c402e56c4760763cc0 [1]
Reported-by: syzbot <syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
I can observe that the reproducer no longer reports memory leak. But
is this change correct and sufficient? Are there similar locations?

 include/net/sctp/stream_sched.h |  2 ++
 net/sctp/stream.c               |  3 +++
 net/sctp/stream_sched_prio.c    | 20 ++++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/net/sctp/stream_sched.h b/include/net/sctp/stream_sched.h
index 01a70b27e026..1a59d0f8ad79 100644
--- a/include/net/sctp/stream_sched.h
+++ b/include/net/sctp/stream_sched.h
@@ -28,6 +28,8 @@ struct sctp_sched_ops {
 	int (*init_sid)(struct sctp_stream *stream, __u16 sid, gfp_t gfp);
 	/* Frees the entire thing */
 	void (*free)(struct sctp_stream *stream);
+	/* Free one sid */
+	void (*free_sid)(struct sctp_stream *stream, __u16 sid);
 
 	/* Enqueue a chunk */
 	void (*enqueue)(struct sctp_outq *q, struct sctp_datamsg *msg);
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index ef9fceadef8d..845a8173181e 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -60,6 +60,7 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 				     struct sctp_stream *new, __u16 outcnt)
 {
 	int i;
+	struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
 
 	if (stream->outcnt > outcnt)
 		sctp_stream_shrink_out(stream, outcnt);
@@ -77,6 +78,8 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 	}
 
 	for (i = outcnt; i < stream->outcnt; i++) {
+		if (sched->free_sid)
+			sched->free_sid(stream, i);
 		kfree(SCTP_SO(stream, i)->ext);
 		SCTP_SO(stream, i)->ext = NULL;
 	}
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 80b5a2c4cbc7..bde5537984a9 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -230,6 +230,25 @@ static void sctp_sched_prio_free(struct sctp_stream *stream)
 	}
 }
 
+static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+	struct sctp_stream_priorities *prio, *n;
+	struct sctp_stream_out *sout = SCTP_SO(stream, sid);
+	struct sctp_stream_out_ext *soute = sout->ext;
+	LIST_HEAD(list);
+
+	if (!soute)
+		return;
+	prio = soute->prio_head;
+	if (!prio || !list_empty(&prio->prio_sched))
+		return;
+	list_add(&prio->prio_sched, &list);
+	list_for_each_entry_safe(prio, n, &list, prio_sched) {
+		list_del_init(&prio->prio_sched);
+		kfree(prio);
+	}
+}
+
 static void sctp_sched_prio_enqueue(struct sctp_outq *q,
 				    struct sctp_datamsg *msg)
 {
@@ -323,6 +342,7 @@ static struct sctp_sched_ops sctp_sched_prio = {
 	.get = sctp_sched_prio_get,
 	.init = sctp_sched_prio_init,
 	.init_sid = sctp_sched_prio_init_sid,
+	.free_sid = sctp_sched_prio_free_sid,
 	.free = sctp_sched_prio_free,
 	.enqueue = sctp_sched_prio_enqueue,
 	.dequeue = sctp_sched_prio_dequeue,
-- 
2.34.1


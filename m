Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8003E6379A7
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 14:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiKXNEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 08:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiKXNEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 08:04:45 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3FBC6548;
        Thu, 24 Nov 2022 05:04:43 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NHymh29h9zJnjC;
        Thu, 24 Nov 2022 21:01:24 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 24 Nov
 2022 21:04:41 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <syzkaller-bugs@googlegroups.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net v2] sctp: fix memory leak in sctp_stream_outq_migrate()
Date:   Thu, 24 Nov 2022 21:11:00 +0800
Message-ID: <20221124131100.369106-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sctp_stream_outq_migrate() is called to release stream out resources,
the memory pointed to by prio_head in stream out is not released.

The memory leak information is as follows:
 unreferenced object 0xffff88801fe79f80 (size 64):
   comm "sctp_repo", pid 7957, jiffies 4294951704 (age 36.480s)
   hex dump (first 32 bytes):
     80 9f e7 1f 80 88 ff ff 80 9f e7 1f 80 88 ff ff  ................
     90 9f e7 1f 80 88 ff ff 90 9f e7 1f 80 88 ff ff  ................
   backtrace:
     [<ffffffff81b215c6>] kmalloc_trace+0x26/0x60
     [<ffffffff88ae517c>] sctp_sched_prio_set+0x4cc/0x770
     [<ffffffff88ad64f2>] sctp_stream_init_ext+0xd2/0x1b0
     [<ffffffff88aa2604>] sctp_sendmsg_to_asoc+0x1614/0x1a30
     [<ffffffff88ab7ff1>] sctp_sendmsg+0xda1/0x1ef0
     [<ffffffff87f765ed>] inet_sendmsg+0x9d/0xe0
     [<ffffffff8754b5b3>] sock_sendmsg+0xd3/0x120
     [<ffffffff8755446a>] __sys_sendto+0x23a/0x340
     [<ffffffff87554651>] __x64_sys_sendto+0xe1/0x1b0
     [<ffffffff89978b49>] do_syscall_64+0x39/0xb0
     [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Link: https://syzkaller.appspot.com/bug?exrid=29c402e56c4760763cc0
Fixes: Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v2: add .free_sid hook function and use it to free a stream
---
 include/net/sctp/stream_sched.h |  2 ++
 net/sctp/stream.c               | 15 +++++++++++----
 net/sctp/stream_sched_prio.c    | 20 ++++++++++++++++++++
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/include/net/sctp/stream_sched.h b/include/net/sctp/stream_sched.h
index 01a70b27e026..65058faea4db 100644
--- a/include/net/sctp/stream_sched.h
+++ b/include/net/sctp/stream_sched.h
@@ -26,6 +26,8 @@ struct sctp_sched_ops {
 	int (*init)(struct sctp_stream *stream);
 	/* Init a stream */
 	int (*init_sid)(struct sctp_stream *stream, __u16 sid, gfp_t gfp);
+	/* free a stream */
+	void (*free_sid)(struct sctp_stream *stream, __u16 sid);
 	/* Frees the entire thing */
 	void (*free)(struct sctp_stream *stream);
 
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index ef9fceadef8d..0a704bbf1155 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -52,6 +52,15 @@ static void sctp_stream_shrink_out(struct sctp_stream *stream, __u16 outcnt)
 	}
 }
 
+static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
+{
+	struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
+
+	sched->free_sid(stream, sid);
+	kfree(SCTP_SO(stream, sid)->ext);
+	SCTP_SO(stream, sid)->ext = NULL;
+}
+
 /* Migrates chunks from stream queues to new stream queues if needed,
  * but not across associations. Also, removes those chunks to streams
  * higher than the new max.
@@ -76,10 +85,8 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 		}
 	}
 
-	for (i = outcnt; i < stream->outcnt; i++) {
-		kfree(SCTP_SO(stream, i)->ext);
-		SCTP_SO(stream, i)->ext = NULL;
-	}
+	for (i = outcnt; i < stream->outcnt; i++)
+		sctp_stream_free_ext(stream, i);
 }
 
 static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 80b5a2c4cbc7..e9cc71b93e90 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -204,6 +204,25 @@ static int sctp_sched_prio_init_sid(struct sctp_stream *stream, __u16 sid,
 	return sctp_sched_prio_set(stream, sid, 0, gfp);
 }
 
+static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+	struct sctp_stream_priorities *prio;
+	int i;
+
+	if (!SCTP_SO(stream, sid)->ext || !SCTP_SO(stream, sid)->ext->prio_head)
+		return;
+
+	prio = SCTP_SO(stream, sid)->ext->prio_head;
+	SCTP_SO(stream, sid)->ext->prio_head = NULL;
+	for (i = 0; i < stream->outcnt; i++) {
+		if (SCTP_SO(stream, i)->ext &&
+		    SCTP_SO(stream, i)->ext->prio_head == prio)
+			return;
+	}
+
+	kfree(prio);
+}
+
 static void sctp_sched_prio_free(struct sctp_stream *stream)
 {
 	struct sctp_stream_priorities *prio, *n;
@@ -323,6 +342,7 @@ static struct sctp_sched_ops sctp_sched_prio = {
 	.get = sctp_sched_prio_get,
 	.init = sctp_sched_prio_init,
 	.init_sid = sctp_sched_prio_init_sid,
+	.free_sid = sctp_sched_prio_free_sid,
 	.free = sctp_sched_prio_free,
 	.enqueue = sctp_sched_prio_enqueue,
 	.dequeue = sctp_sched_prio_dequeue,
-- 
2.17.1


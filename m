Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01E3698528
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 21:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBOUEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 15:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjBOUEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 15:04:48 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C151A3A842;
        Wed, 15 Feb 2023 12:04:47 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id c2so23078708qtw.5;
        Wed, 15 Feb 2023 12:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lG4fGIV8AIlfhuwCv1tymETzVncYuHGN/WMjsfwddmo=;
        b=WfnkNz/bfdom7tG6gBO3GLru8pyD5cTpwmwDKsCsTIvdwxWNEWmR/7tcHFyoykyUSV
         kQC9yFt4yw1hTgsxV6NLOcChuuV60MNJOl29rRRtpixjzwp2Z0e7jCVYgVwRb39BVyZa
         ZgOSWvkXfnoI1mui6nPwqLlgKCKly0UKRJraCq+aYm6qucXBbVIDroUJQfkfwIZgFK1T
         yZ5RpkWkKOP1wZee9B3dYbhCsgd6JsosUXWHjom/GbTQAMJEmLesB/5I0WT6vuxDMsWg
         aX64czWtrTValN2hR/0BQ4bOAAFq9u8jFJFIGqArgGzLhLOfFa5m5C0HjpMT70pbTgBl
         VXuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lG4fGIV8AIlfhuwCv1tymETzVncYuHGN/WMjsfwddmo=;
        b=zfP4hwkk+vd/OXIAMGAXQu8MQjxberpAmpDQd3DxuNSaLbqh7CQwnJhOv1HKtM9d6e
         ZMIs+PLTl+A3WrG7tApKiL9Hl6oZKUlD/poB+rf0x9gxTGhCK5wTQYnvDtFxUJmkIZmr
         DURjtOJESxEqfQJoNvB8bLws6OX1tt/FjEzRBOiAzkl+84DyaFcstZ2Rti21u1H2NtdD
         BNF9TpzPTog8BJHI+Ehc5vyx8RRifE7QQzPYBt3NY0Pku/hUD/UmZ+40LYUragwFSwCl
         +e2+rn22G+/5c5gTpbzFXOZd2+mFbiYGlIU0Jtmfx86EH/sEubWqh0PEro+KPvS7tcI7
         7NGA==
X-Gm-Message-State: AO0yUKU9US15/xZywb7mKXP7bAEleqpalnncbEW0t2FT+HqPCvc4PtHk
        UX2JdojVH92EesTYYZSTIGhjzDx4/nwl5w==
X-Google-Smtp-Source: AK7set9MywLKTjK81qDkZzTTJ+a20VCmoLekbvWkDGVQrRwprg6bImij06reXmUHqEn/1NCcQzmz2Q==
X-Received: by 2002:ac8:5b08:0:b0:3b9:173e:45de with SMTP id m8-20020ac85b08000000b003b9173e45demr5834954qtw.6.1676491486309;
        Wed, 15 Feb 2023 12:04:46 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id h7-20020ac85047000000b003b9a50c8fa1sm13493069qtm.87.2023.02.15.12.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 12:04:45 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>
Subject: [PATCH net] sctp: add a refcnt in sctp_stream_priorities to avoid a nested loop
Date:   Wed, 15 Feb 2023 15:04:44 -0500
Message-Id: <06ac4e517bff69c23646594d3b404b9ffb51001c.1676491484.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this refcnt added in sctp_stream_priorities, we don't need to
traverse all streams to check if the prio is used by other streams
when freeing one stream's prio in sctp_sched_prio_free_sid(). This
can avoid a nested loop (up to 65535 * 65535), which may cause a
stuck as Ying reported:

    watchdog: BUG: soft lockup - CPU#23 stuck for 26s! [ksoftirqd/23:136]
    Call Trace:
     <TASK>
     sctp_sched_prio_free_sid+0xab/0x100 [sctp]
     sctp_stream_free_ext+0x64/0xa0 [sctp]
     sctp_stream_free+0x31/0x50 [sctp]
     sctp_association_free+0xa5/0x200 [sctp]

Note that it doesn't need to use refcount_t type for this counter,
as its accessing is always protected under the sock lock.

Fixes: 9ed7bfc79542 ("sctp: fix memory leak in sctp_stream_outq_migrate()")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h   |  1 +
 net/sctp/stream_sched_prio.c | 47 +++++++++++++-----------------------
 2 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index afa3781e3ca2..e1f6e7fc2b11 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1412,6 +1412,7 @@ struct sctp_stream_priorities {
 	/* The next stream in line */
 	struct sctp_stream_out_ext *next;
 	__u16 prio;
+	__u16 users;
 };
 
 struct sctp_stream_out_ext {
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 42d4800f263d..66404a101b25 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -25,6 +25,18 @@
 
 static void sctp_sched_prio_unsched_all(struct sctp_stream *stream);
 
+static struct sctp_stream_priorities *sctp_sched_prio_head_get(struct sctp_stream_priorities *p)
+{
+	p->users++;
+	return p;
+}
+
+static void sctp_sched_prio_head_put(struct sctp_stream_priorities *p)
+{
+	if (p && --p->users == 0)
+		kfree(p);
+}
+
 static struct sctp_stream_priorities *sctp_sched_prio_new_head(
 			struct sctp_stream *stream, int prio, gfp_t gfp)
 {
@@ -38,6 +50,7 @@ static struct sctp_stream_priorities *sctp_sched_prio_new_head(
 	INIT_LIST_HEAD(&p->active);
 	p->next = NULL;
 	p->prio = prio;
+	p->users = 1;
 
 	return p;
 }
@@ -53,7 +66,7 @@ static struct sctp_stream_priorities *sctp_sched_prio_get_head(
 	 */
 	list_for_each_entry(p, &stream->prio_list, prio_sched) {
 		if (p->prio == prio)
-			return p;
+			return sctp_sched_prio_head_get(p);
 		if (p->prio > prio)
 			break;
 	}
@@ -70,7 +83,7 @@ static struct sctp_stream_priorities *sctp_sched_prio_get_head(
 			 */
 			break;
 		if (p->prio == prio)
-			return p;
+			return sctp_sched_prio_head_get(p);
 	}
 
 	/* If not even there, allocate a new one. */
@@ -154,7 +167,6 @@ static int sctp_sched_prio_set(struct sctp_stream *stream, __u16 sid,
 	struct sctp_stream_out_ext *soute = sout->ext;
 	struct sctp_stream_priorities *prio_head, *old;
 	bool reschedule = false;
-	int i;
 
 	prio_head = sctp_sched_prio_get_head(stream, prio, gfp);
 	if (!prio_head)
@@ -166,20 +178,7 @@ static int sctp_sched_prio_set(struct sctp_stream *stream, __u16 sid,
 	if (reschedule)
 		sctp_sched_prio_sched(stream, soute);
 
-	if (!old)
-		/* Happens when we set the priority for the first time */
-		return 0;
-
-	for (i = 0; i < stream->outcnt; i++) {
-		soute = SCTP_SO(stream, i)->ext;
-		if (soute && soute->prio_head == old)
-			/* It's still in use, nothing else to do here. */
-			return 0;
-	}
-
-	/* No hits, we are good to free it. */
-	kfree(old);
-
+	sctp_sched_prio_head_put(old);
 	return 0;
 }
 
@@ -206,20 +205,8 @@ static int sctp_sched_prio_init_sid(struct sctp_stream *stream, __u16 sid,
 
 static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
 {
-	struct sctp_stream_priorities *prio = SCTP_SO(stream, sid)->ext->prio_head;
-	int i;
-
-	if (!prio)
-		return;
-
+	sctp_sched_prio_head_put(SCTP_SO(stream, sid)->ext->prio_head);
 	SCTP_SO(stream, sid)->ext->prio_head = NULL;
-	for (i = 0; i < stream->outcnt; i++) {
-		if (SCTP_SO(stream, i)->ext &&
-		    SCTP_SO(stream, i)->ext->prio_head == prio)
-			return;
-	}
-
-	kfree(prio);
 }
 
 static void sctp_sched_prio_enqueue(struct sctp_outq *q,
-- 
2.39.1


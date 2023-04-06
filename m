Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E006D8C4C
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbjDFBBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbjDFBBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:01:07 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B94B7DB9;
        Wed,  5 Apr 2023 18:00:40 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id ix20so36080654plb.3;
        Wed, 05 Apr 2023 18:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680742839; x=1683334839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xONlFwVRLI4ELB/ejl1E4uUj36etSqy4lWn6gdwTo6Y=;
        b=Xl/Dl28LoJ2G8o3yE8tbSd96J4rZkGRqoa7i09l0qQEBgdX98/hqByYs97PTWPqxHG
         jcfio3Z+nEmdnLkFWbTqsbQm1gktxNXCXQ0VgZ9zKcRJgp1TjNMBl9mPZIy9ZU1YyrqX
         sE2qvRJEgyuusBLcOp3jta4PiIJjlnWmSKqGr7xxMciJYH2x5UPcT1jQgrYGSjreLgfo
         +XcR/eYuFiunUWcBTy2ksCPG5LISQ0ljQaE1lASiiWnHy1xuyOUd2+caoeiLwxnHO35I
         sw1+PQb6nz2w7IyQXLJ0t+hbUIszHMkk2SforglXpQDJDwRXTAJM79pgjNptrzZc2Lnt
         RN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680742839; x=1683334839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xONlFwVRLI4ELB/ejl1E4uUj36etSqy4lWn6gdwTo6Y=;
        b=oDUoOg+Y/qrp9CVBHB2R4lSoLOaq7oAJiNLrUmJN6W9vr5ngWNoPnata8HIYh0X25n
         /nF5Sfsvams+WHjD3M8dMr3KAubBkktSkp3Jaym4othlWoMhKMacf6iKv/Js0rMq5V+x
         ON3YDh/F1S1xBGIS9AMX0hZgYs5SrqE6I6E5xH+aIigUTd0B/TAwj3Ds+KZCfs5diRjC
         UZGDAPMoIs1xxno3DGl5gHCtIRVb5MpdTgNZTQeY9xbQgvnIPlOTkO8ACkCpveWJZUp5
         n8I+q/7pxmKaBC1VKA1jRa6cS5wQNWtBizSBNmygWKvkqZzd/oOWPWpWZmusWVVAUDPD
         CLqg==
X-Gm-Message-State: AAQBX9dlvewko0/F7TzF26Kxv4f448c8UNc62luC9xyEMNnpvKZ1zaB/
        clrRRzEGDiQjnOYLzuxXt50=
X-Google-Smtp-Source: AKy350bht/dSUksOAULnYU4vC6V8qqxxAUMeFiZqhmfHHpda2KWt0cDUv2LpYbte8vDmGMSOR7ZJcw==
X-Received: by 2002:a05:6a20:c28a:b0:d9:e6a9:d3e2 with SMTP id bs10-20020a056a20c28a00b000d9e6a9d3e2mr1097945pzb.3.1680742839205;
        Wed, 05 Apr 2023 18:00:39 -0700 (PDT)
Received: from john.lan ([98.97.117.85])
        by smtp.gmail.com with ESMTPSA id c14-20020aa78c0e000000b0062c0c3da6b8sm35377pfd.13.2023.04.05.18.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 18:00:38 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v5 02/12] bpf: sockmap, convert schedule_work into delayed_work
Date:   Wed,  5 Apr 2023 18:00:21 -0700
Message-Id: <20230406010031.3354-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230406010031.3354-1-john.fastabend@gmail.com>
References: <20230406010031.3354-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sk_buffs are fed into sockmap verdict programs either from a strparser
(when the user might want to decide how framing of skb is done by attaching
another parser program) or directly through tcp_read_sock. The
tcp_read_sock is the preferred method for performance when the BPF logic is
a stream parser.

The flow for Cilium's common use case with a stream parser is,

 tcp_read_sock()
  sk_psock_verdict_recv
    ret = bpf_prog_run_pin_on_cpu()
    sk_psock_verdict_apply(sock, skb, ret)
     // if system is under memory pressure or app is slow we may
     // need to queue skb. Do this queuing through ingress_skb and
     // then kick timer to wake up handler
     skb_queue_tail(ingress_skb, skb)
     schedule_work(work);


The work queue is wired up to sk_psock_backlog(). This will then walk the
ingress_skb skb list that holds our sk_buffs that could not be handled,
but should be OK to run at some later point. However, its possible that
the workqueue doing this work still hits an error when sending the skb.
When this happens the skbuff is requeued on a temporary 'state' struct
kept with the workqueue. This is necessary because its possible to
partially send an skbuff before hitting an error and we need to know how
and where to restart when the workqueue runs next.

Now for the trouble, we don't rekick the workqueue. This can cause a
stall where the skbuff we just cached on the state variable might never
be sent. This happens when its the last packet in a flow and no further
packets come along that would cause the system to kick the workqueue from
that side.

To fix we could do simple schedule_work(), but while under memory pressure
it makes sense to back off some instead of continue to retry repeatedly. So
instead to fix convert schedule_work to schedule_delayed_work and add
backoff logic to reschedule from backlog queue on errors. Its not obvious
though what a good backoff is so use '1'.

To test we observed some flakes whil running NGINX compliance test with
sockmap we attributed these failed test to this bug and subsequent issue.

From on list discussion. This commit

 bec217197b41("skmsg: Schedule psock work if the cached skb exists on the psock")

was intended to address similar race, but had a couple cases it missed.
Most obvious it only accounted for receiving traffic on the local socket
so if redirecting into another socket we could still get an sk_buff stuck
here. Next it missed the case where copied=0 in the recv() handler and
then we wouldn't kick the scheduler. Also its sub-optimal to require
userspace to kick the internal mechanisms of sockmap to wake it up and
copy data to user. It results in an extra syscall and requires the app
to actual handle the EAGAIN correctly.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Tested-by: William Findlay <will@isovalent.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h |  2 +-
 net/core/skmsg.c      | 20 +++++++++++++-------
 net/core/sock_map.c   |  3 ++-
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 84f787416a54..904ff9a32ad6 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -105,7 +105,7 @@ struct sk_psock {
 	struct proto			*sk_proto;
 	struct mutex			work_mutex;
 	struct sk_psock_work_state	work_state;
-	struct work_struct		work;
+	struct delayed_work		work;
 	struct rcu_work			rwork;
 };
 
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 4a3dc8d27295..198bed303c51 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -482,7 +482,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 	}
 out:
 	if (psock->work_state.skb && copied > 0)
-		schedule_work(&psock->work);
+		schedule_delayed_work(&psock->work, 0);
 	return copied;
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
@@ -640,7 +640,8 @@ static void sk_psock_skb_state(struct sk_psock *psock,
 
 static void sk_psock_backlog(struct work_struct *work)
 {
-	struct sk_psock *psock = container_of(work, struct sk_psock, work);
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct sk_psock *psock = container_of(dwork, struct sk_psock, work);
 	struct sk_psock_work_state *state = &psock->work_state;
 	struct sk_buff *skb = NULL;
 	bool ingress;
@@ -680,6 +681,11 @@ static void sk_psock_backlog(struct work_struct *work)
 				if (ret == -EAGAIN) {
 					sk_psock_skb_state(psock, state, skb,
 							   len, off);
+
+					/* Delay slightly to prioritize any
+					 * other work that might be here.
+					 */
+					schedule_delayed_work(&psock->work, 1);
 					goto end;
 				}
 				/* Hard errors break pipe and stop xmit. */
@@ -734,7 +740,7 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 	INIT_LIST_HEAD(&psock->link);
 	spin_lock_init(&psock->link_lock);
 
-	INIT_WORK(&psock->work, sk_psock_backlog);
+	INIT_DELAYED_WORK(&psock->work, sk_psock_backlog);
 	mutex_init(&psock->work_mutex);
 	INIT_LIST_HEAD(&psock->ingress_msg);
 	spin_lock_init(&psock->ingress_lock);
@@ -823,7 +829,7 @@ static void sk_psock_destroy(struct work_struct *work)
 
 	sk_psock_done_strp(psock);
 
-	cancel_work_sync(&psock->work);
+	cancel_delayed_work_sync(&psock->work);
 	mutex_destroy(&psock->work_mutex);
 
 	psock_progs_drop(&psock->progs);
@@ -938,7 +944,7 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 	}
 
 	skb_queue_tail(&psock_other->ingress_skb, skb);
-	schedule_work(&psock_other->work);
+	schedule_delayed_work(&psock_other->work, 0);
 	spin_unlock_bh(&psock_other->ingress_lock);
 	return 0;
 }
@@ -1018,7 +1024,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 			spin_lock_bh(&psock->ingress_lock);
 			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 				skb_queue_tail(&psock->ingress_skb, skb);
-				schedule_work(&psock->work);
+				schedule_delayed_work(&psock->work, 0);
 				err = 0;
 			}
 			spin_unlock_bh(&psock->ingress_lock);
@@ -1049,7 +1055,7 @@ static void sk_psock_write_space(struct sock *sk)
 	psock = sk_psock(sk);
 	if (likely(psock)) {
 		if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
-			schedule_work(&psock->work);
+			schedule_delayed_work(&psock->work, 0);
 		write_space = psock->saved_write_space;
 	}
 	rcu_read_unlock();
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index a68a7290a3b2..d38267201892 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1624,9 +1624,10 @@ void sock_map_close(struct sock *sk, long timeout)
 		rcu_read_unlock();
 		sk_psock_stop(psock);
 		release_sock(sk);
-		cancel_work_sync(&psock->work);
+		cancel_delayed_work_sync(&psock->work);
 		sk_psock_put(sk, psock);
 	}
+
 	/* Make sure we do not recurse. This is a bug.
 	 * Leak the socket instead of crashing on a stack overflow.
 	 */
-- 
2.33.0


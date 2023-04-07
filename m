Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618E36DB160
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjDGRRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjDGRRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:17:03 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB33AF30;
        Fri,  7 Apr 2023 10:17:01 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id kq3so40462915plb.13;
        Fri, 07 Apr 2023 10:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680887821; x=1683479821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xONlFwVRLI4ELB/ejl1E4uUj36etSqy4lWn6gdwTo6Y=;
        b=e8lf5UBF+/uxCWOUhBnHhEylDrJUioolO+iiqcclGycd3FCu8v934d5KW+479zoU7w
         i8/wS3jbCIVYNeAu5ntYTHJDPPmn2TSdnyemQJD0pSO1y4d+QWnEbyGDlsnrdfK1Iqz5
         NZuC5So1iyHJo+7Od84F1xtItVcGGSFxmbDdiN9xzLcwBs0A3ZmWWWGwVEPJAenmdHep
         PU0OB4VPZH6sU4jQZklbB+SZNGo8fWRAz2XqKyxOwszKQbWJg9h7DypZqduS+0fhHW6M
         78A+P5kfeX5zPlYCYFdR3k3bN0wR9AMcqsNMNNBvQ2VOTMwDwcRfHwsmzc+O4vx/kp7p
         pSwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680887821; x=1683479821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xONlFwVRLI4ELB/ejl1E4uUj36etSqy4lWn6gdwTo6Y=;
        b=AbyqZlDh+FcQlTB2Q3o7aE0gftQjb3sd8VpW+nb30lb6+wA/iHuZtFkhU4hA5EvoO7
         GzbjuTkf2Bcy2niEn8BfLQx4Hc4ZPN7MeWLdtQallHqCiYWRYw2klLMh7qbYVrC/Cp7h
         rctl/j2iQKfHg5SmSw0hT366m/VnP1dlTyGUYPN+UGya9B08lw6bVJXhyUQr2c5BxImx
         KeSKz4bZ46JcuWyA9cD1iMTXtc9clwD/vm3eNXoa+JO5MjtlGMqYLAMnqKOC8BcmVfLE
         KpCfZ6jhx+iGdS1T5ba43mCogNfVQa2tPLyNEP39Gr+N4csHzwFB6ShojG41l/+2kc+V
         mZew==
X-Gm-Message-State: AAQBX9czkAA5yW2f0Bvehkis3Cgo8JEw+mj3QWdfOuF8z/ouG+E1fVXB
        S3GmSTRh9dlNv121LPGVpfl5sxkyKW4=
X-Google-Smtp-Source: AKy350Y3b9ANd5d9LgwSSj5BzDSCPOjBqmXUmBkWKM3KU9CD/eLrT0c4v8+b6pWc9Iwm34vZ/P296g==
X-Received: by 2002:a17:903:10b:b0:1a0:65d3:bae4 with SMTP id y11-20020a170903010b00b001a065d3bae4mr3018803plc.38.1680887820859;
        Fri, 07 Apr 2023 10:17:00 -0700 (PDT)
Received: from john.lan ([98.97.116.126])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709028a8100b0019b0937003esm3185425plo.150.2023.04.07.10.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 10:17:00 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v6 02/12] bpf: sockmap, convert schedule_work into delayed_work
Date:   Fri,  7 Apr 2023 10:16:44 -0700
Message-Id: <20230407171654.107311-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230407171654.107311-1-john.fastabend@gmail.com>
References: <20230407171654.107311-1-john.fastabend@gmail.com>
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


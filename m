Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7886CAC60
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbjC0RzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjC0Ryy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:54:54 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6F02681;
        Mon, 27 Mar 2023 10:54:53 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id u38so6231303pfg.10;
        Mon, 27 Mar 2023 10:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679939692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C16N4t/yebwnWEt3up1L0bcXG9FtrfIrB+7RyncYbw4=;
        b=Rx+8aMu1S5OCokhgOjj9VcKAd6xcTAfr5TEZ7fMDXcdINXcSceXeRtFpbZpW/miWdW
         L399WIgI0n/JpnazBmQVwb/TvJcSCo4EOFryfeETVAnQuHLFhkFFf2546nh67FMRs8KW
         LU41acMfN+kDpFmTdQlTNHlDXMOWX9LdErGZ3hv7lTkF9M35Ts64XFIGPh+lpExgf3WL
         WAu09kZ/O8/qc/ES5zuEqwpVXvmjxCr9n770yMmvQBx47lOfikOeft6BwCsXoTcSCsPA
         seuwM4dgecw79Pc6UaH+v+Y2GLc0jPevbpT559hSbX1bfmK1z+18FshJyUkaNuX83a+l
         HA7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679939692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C16N4t/yebwnWEt3up1L0bcXG9FtrfIrB+7RyncYbw4=;
        b=ydJ1v6y7J35HSis6WESo3W8hxL0Ux+E/AzOw5lshch82kiocDZjtW/vbfF8CsnaJ5n
         z/VFHU35T98I9ylMXSFchbgAEkcNv7EsZFMoYXrtE1ZeVmO0OM5kBLzdZ/WaTPxF/rdR
         F+9r2/N/V2VEDmaWN4Lzj3tgK7yypduU96exGeISht9GHET22KOM/ThzaT+XNJ0qTOTC
         EDTBuyOyLkfGjqAVh/F/qNFohxR3kfTAnXkq1ky143X8zCbXLuOab/+hdtwSXgVM2qr0
         iIXh8Lg5qCtHsc9amWq+B/D5UX1Kbf3gQr7OF+i3+bB+8ZBgVhDOoFhFnd/pnLARPr6R
         /xfg==
X-Gm-Message-State: AO0yUKUPnZ14CXv1AG8dOM2vZBb5Tm+ZIrfW0qDJQvrAIBAjBnVju/6a
        f+cR14zD9n0xx5hsdZM2cDzNv9DQeD8eOA==
X-Google-Smtp-Source: AK7set+0QVnVDWf74ydnur5p6Xcm5H8+m01tD0sceNb0GvGWdGBIW4O395t06etQ17KMFQc6MtHqaA==
X-Received: by 2002:a05:6a00:309e:b0:625:5403:cd87 with SMTP id bh30-20020a056a00309e00b006255403cd87mr15948601pfb.11.1679939692398;
        Mon, 27 Mar 2023 10:54:52 -0700 (PDT)
Received: from john.lan ([98.97.117.131])
        by smtp.gmail.com with ESMTPSA id r1-20020a62e401000000b005a8ba70315bsm19408316pfh.6.2023.03.27.10.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 10:54:52 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v2 02/12] bpf: sockmap, convert schedule_work into delayed_work
Date:   Mon, 27 Mar 2023 10:54:36 -0700
Message-Id: <20230327175446.98151-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230327175446.98151-1-john.fastabend@gmail.com>
References: <20230327175446.98151-1-john.fastabend@gmail.com>
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

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Tested-by: William Findlay <will@isovalent.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h |  2 +-
 net/core/skmsg.c      | 19 ++++++++++++-------
 net/core/sock_map.c   |  3 ++-
 3 files changed, 15 insertions(+), 9 deletions(-)

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
index 2b6d9519ff29..96a6a3a74a67 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -481,7 +481,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 	}
 out:
 	if (psock->work_state.skb && copied > 0)
-		schedule_work(&psock->work);
+		schedule_delayed_work(&psock->work, 0);
 	return copied;
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
@@ -639,7 +639,8 @@ static void sk_psock_skb_state(struct sk_psock *psock,
 
 static void sk_psock_backlog(struct work_struct *work)
 {
-	struct sk_psock *psock = container_of(work, struct sk_psock, work);
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct sk_psock *psock = container_of(dwork, struct sk_psock, work);
 	struct sk_psock_work_state *state = &psock->work_state;
 	struct sk_buff *skb = NULL;
 	bool ingress;
@@ -679,6 +680,10 @@ static void sk_psock_backlog(struct work_struct *work)
 				if (ret == -EAGAIN) {
 					sk_psock_skb_state(psock, state, skb,
 							   len, off);
+
+					// Delay slightly to prioritize any
+					// other work that might be here.
+					schedule_delayed_work(&psock->work, 1);
 					goto end;
 				}
 				/* Hard errors break pipe and stop xmit. */
@@ -733,7 +738,7 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 	INIT_LIST_HEAD(&psock->link);
 	spin_lock_init(&psock->link_lock);
 
-	INIT_WORK(&psock->work, sk_psock_backlog);
+	INIT_DELAYED_WORK(&psock->work, sk_psock_backlog);
 	mutex_init(&psock->work_mutex);
 	INIT_LIST_HEAD(&psock->ingress_msg);
 	spin_lock_init(&psock->ingress_lock);
@@ -822,7 +827,7 @@ static void sk_psock_destroy(struct work_struct *work)
 
 	sk_psock_done_strp(psock);
 
-	cancel_work_sync(&psock->work);
+	cancel_delayed_work_sync(&psock->work);
 	mutex_destroy(&psock->work_mutex);
 
 	psock_progs_drop(&psock->progs);
@@ -937,7 +942,7 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 	}
 
 	skb_queue_tail(&psock_other->ingress_skb, skb);
-	schedule_work(&psock_other->work);
+	schedule_delayed_work(&psock_other->work, 0);
 	spin_unlock_bh(&psock_other->ingress_lock);
 	return 0;
 }
@@ -1017,7 +1022,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 			spin_lock_bh(&psock->ingress_lock);
 			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 				skb_queue_tail(&psock->ingress_skb, skb);
-				schedule_work(&psock->work);
+				schedule_delayed_work(&psock->work, 0);
 				err = 0;
 			}
 			spin_unlock_bh(&psock->ingress_lock);
@@ -1048,7 +1053,7 @@ static void sk_psock_write_space(struct sock *sk)
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C969E6C3D05
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCUVw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCUVwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:52:24 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4803E0B1;
        Tue, 21 Mar 2023 14:52:22 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so21759067pjv.5;
        Tue, 21 Mar 2023 14:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679435541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AfTerV6/U69AI92CPlAfsf8FX5XYFtSurKpJkvd75cI=;
        b=WNdgta6YjiNwjEBjC/bv0c0IqnXah8zvAwSq1pNgel4usiKoeZ/J6mAM5To2I03j9y
         8zCm4kGqd1xzJ+l18wlU79QJz5gGbFyM6kmrbjXxT762w94qNWe1p+YFcI7HncPMw1uw
         KvkfbRDoHJ0NrHL7R8kuj+d/HIauU+wmfPLfzR25tE+xvWLuXcbzc9uvJNQwikxrLLHo
         BqU+DgXYOUh2iFyVnedP+syJs5itmSMDbYAhDa+owUYWuhJ3Z4lcRi/MiAdGTjJwg0s8
         V8xFn5Ana/DlbuYoHlvwUZxLBafuGood+uSveD0Wj0zQl/cQTufALNB+GpJhlVS5eYoD
         WVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679435541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AfTerV6/U69AI92CPlAfsf8FX5XYFtSurKpJkvd75cI=;
        b=KhG0EqD1HJzIx2mJNovui/fq/yX9uWekQYbz8zV3A+5ICa6PqP8DlQ5nwxe9q70IYr
         v5YdT53M+VCS2V4rxr/6IKmgpjNTIIGpy43zDKOJOP1/3x47M7bS/qXXYEaqHGAf5Mvt
         L3LSaobJiXayfquVwHu+8rDsXiP6H3ODC0FFIlleMCAUgKnjLgkDoOT+fecWYRmLeg09
         EVFJ2xld+m0XNV9GsN38Q5R0BfKOwfg4XxdGqC0xJF6UBNzblT8y+ugytTDDnWMuj5Nr
         j7+xnzftBx4mg/+sYKkKYZNZfgivu1X6C5q+4ZEC9/io59LKcQBLs9zm7/p+dVrM9j+t
         IX6w==
X-Gm-Message-State: AO0yUKXJOTb/iweJpEqIlfIL0zL7eaGKqqUe9nkCHp48rLjqlx2w5Ymu
        EZk5ZSsJ7RbHOwhDbt90cs0=
X-Google-Smtp-Source: AK7set9LOtuuD2cOlOwPe1GlYKCpQ0iCgULMMddx5ZnobY7tUbKSZ+hHwS8Jxk4A7hMzVEihE9SxSw==
X-Received: by 2002:a17:902:e0d1:b0:19d:1bc1:ce22 with SMTP id e17-20020a170902e0d100b0019d1bc1ce22mr433082pla.5.1679435541705;
        Tue, 21 Mar 2023 14:52:21 -0700 (PDT)
Received: from john.lan ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id m3-20020a63fd43000000b004facdf070d6sm8661331pgj.39.2023.03.21.14.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:52:21 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: [PATCH bpf 03/11] bpf: sockmap, improved check for empty queue
Date:   Tue, 21 Mar 2023 14:52:04 -0700
Message-Id: <20230321215212.525630-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230321215212.525630-1-john.fastabend@gmail.com>
References: <20230321215212.525630-1-john.fastabend@gmail.com>
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

We noticed some rare sk_buffs were stepping past the queue when system was
under memory pressure. The general theory is to skip enqueueing
sk_buffs when its not necessary which is the normal case with a system
that is properly provisioned for the task, no memory pressure and enough
cpu assigned.

But, if we can't allocate memory due to an ENOMEM error when enqueueing
the sk_buff into the sockmap receive queue we push it onto a delayed
workqueue to retry later. When a new sk_buff is received we then check
if that queue is empty. However, there is a problem with simply checking
the queue length. When a sk_buff is being processed from the ingress queue
but not yet on the sockmap msg receive queue its possible to also recv
a sk_buff through normal path. It will check the ingress queue which is
zero and then skip ahead of the pkt being processed.

Previously we used sock lock from both contexts which made the problem
harder to hit, but not impossible.

To fix also check the 'state' variable where we would cache partially
processed sk_buff. This catches the majority of cases. But, we also
need to use the mutex lock around this check because we can't have both
codes running and check sensibly. We could perhaps do this with atomic
bit checks, but we are already here due to memory pressure so slowing
things down a bit seems OK and simpler to just grab a lock.

To reproduce issue we run NGINX compliance test with sockmap running and
observe some flakes in our testing that we attributed to this issue.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Tested-by: William Findlay <will@isovalent.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 96a6a3a74a67..34de0605694e 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -985,6 +985,7 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 				  int verdict)
 {
+	struct sk_psock_work_state *state;
 	struct sock *sk_other;
 	int err = 0;
 	u32 len, off;
@@ -1001,13 +1002,28 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 
 		skb_bpf_set_ingress(skb);
 
+		/* We need to grab mutex here because in-flight skb is in one of
+		 * the following states: either on ingress_skb, in psock->state
+		 * or being processed by backlog and neither in state->skb and
+		 * ingress_skb may be also empty. The troublesome case is when
+		 * the skb has been dequeued from ingress_skb list or taken from
+		 * state->skb because we can not easily test this case. Maybe we
+		 * could be clever with flags and resolve this but being clever
+		 * got us here in the first place and we note this is done under
+		 * sock lock and backlog conditions mean we are already running
+		 * into ENOMEM or other performance hindering cases so lets do
+		 * the obvious thing and grab the mutex.
+		 */
+		mutex_lock(&psock->work_mutex);
+		state = &psock->work_state;
+
 		/* If the queue is empty then we can submit directly
 		 * into the msg queue. If its not empty we have to
 		 * queue work otherwise we may get OOO data. Otherwise,
 		 * if sk_psock_skb_ingress errors will be handled by
 		 * retrying later from workqueue.
 		 */
-		if (skb_queue_empty(&psock->ingress_skb)) {
+		if (skb_queue_empty(&psock->ingress_skb) && likely(!state->skb)) {
 			len = skb->len;
 			off = 0;
 			if (skb_bpf_strparser(skb)) {
@@ -1028,9 +1044,11 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 			spin_unlock_bh(&psock->ingress_lock);
 			if (err < 0) {
 				skb_bpf_redirect_clear(skb);
+				mutex_unlock(&psock->work_mutex);
 				goto out_free;
 			}
 		}
+		mutex_unlock(&psock->work_mutex);
 		break;
 	case __SK_REDIRECT:
 		err = sk_psock_skb_redirect(psock, skb);
-- 
2.33.0


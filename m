Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3BE6D51BE
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbjDCUB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbjDCUBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:01:53 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08863AB9;
        Mon,  3 Apr 2023 13:01:46 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id ix20so29190487plb.3;
        Mon, 03 Apr 2023 13:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680552106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1SkSwJ+B3plp80uNFxZv+C5LrwCVTyzF6SA03WoEAY=;
        b=mPpALjIHoVAlHYYJz9V+osK1qDtyiwh2MvS81J/8Q27eIxcnawjFXJyxJTz58yXKqA
         nYu+xtAdl9XJrA2M2HgWYW88iwaXCz7UonvyLlRGWWaZuyAe+6AeERnwyxdjsdcvlPw8
         11LhDPC3LZNfxtmUxM8wgyUFAr/qYLQPdceohQ1tIDn2wCb1n4/PfEnVXAZnZ/TpGoA9
         22c50Qul+eW97VqEw1fuC1ZLWlETe1VOnnUHOCqpG1d4QI/ft+KjuFukLXRYOgYU6aG5
         QbsfcAO/m6UUfMr3HDSa84DAHui32Cl5RpT5rw9UGWZpk2/jZN5PYeo2MZ/FHB1lpw5y
         tZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680552106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z1SkSwJ+B3plp80uNFxZv+C5LrwCVTyzF6SA03WoEAY=;
        b=6PKHtn/yN1Ajwk6p1gV1QCiK+dabUNKXcHJbnqnDW/5wiBvnYSBhwFAAETCU/+tu7Z
         K7sT1GnarJXrefLY+aFjzaniqJ0ZLhe5Pzds8MPn+z5AbXcL7vfn/ABqqYqhqXPL8zJk
         mCltc3RpTKkOhE7cvdPTg1Dz5FtopgS1qPpLGdx90Xuchpfe174LqAB9D5es+7LhcJvJ
         6b1S1RjygmouccoB9z1V+Ii748qgZYHp1sI1Irb/BBkatyHBc6RBp02NG13kTbZax3dh
         VolpcPTApUobH1lboTKdPTWr1mN56jww6RUC7k6FZ9tX7VsG+UObI/vxwWl/dnKnoe+h
         C40g==
X-Gm-Message-State: AAQBX9cKZFVH+5dMV6BpkyjmvvGkrYwL6Vx6eDIoRJVupIqQJOw8Aww0
        X19iKljC4+b3qH8nr7VSwsY=
X-Google-Smtp-Source: AKy350YGG2PbXJhXJ0pqtPObm+44Ohq7MTFvNlrOxj7Q6tJLA8qgeyL3r8ZUz1vWjZ4VZLx+ExZE7A==
X-Received: by 2002:a17:90a:bc85:b0:23d:816:faa9 with SMTP id x5-20020a17090abc8500b0023d0816faa9mr134361pjr.12.1680552106102;
        Mon, 03 Apr 2023 13:01:46 -0700 (PDT)
Received: from localhost.localdomain ([2605:59c8:4c5:7110:3da7:5d97:f465:5e01])
        by smtp.gmail.com with ESMTPSA id t18-20020a1709028c9200b0019c2b1c4db1sm6948835plo.239.2023.04.03.13.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:01:45 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v3 03/12] bpf: sockmap, improved check for empty queue
Date:   Mon,  3 Apr 2023 13:01:29 -0700
Message-Id: <20230403200138.937569-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230403200138.937569-1-john.fastabend@gmail.com>
References: <20230403200138.937569-1-john.fastabend@gmail.com>
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
index 198bed303c51..f8731818b5c3 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -987,6 +987,7 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 				  int verdict)
 {
+	struct sk_psock_work_state *state;
 	struct sock *sk_other;
 	int err = 0;
 	u32 len, off;
@@ -1003,13 +1004,28 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 
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
@@ -1030,9 +1046,11 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
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


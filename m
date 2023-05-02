Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0F46F47B3
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbjEBPwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbjEBPwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:52:13 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EC430C0;
        Tue,  2 May 2023 08:52:10 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1aaed87d8bdso20820195ad.3;
        Tue, 02 May 2023 08:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683042730; x=1685634730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R7DJwzYL5w5i+ufJACiL7UDmRNxJUi8dTGWXWXs5Uuc=;
        b=hbHyrsOXEnQEiKg37wFZkQd5PiaQpUEn1MzNhGSwRGRMJg17sBrCJ6CcXw0dqxrneG
         8wFJKciiDRm/WitXrxnfKMVKSIcXCCQZWeXjEGNyN5tVeHA8CD6/47PPjWwTNDjf+ZPr
         94Q6Oh2ygmGUqm5GVU9Lr2zKz2D/t3YIoAPhn4pCWN1+FvU/RxblYqb2lKweCfN6MCzU
         th//PpXSF65Qr/ou4nsP6M8bjuiLUADxOffm4yjyEGjcTKl5haSeIiOjYo5BpZQyfUMr
         1dTivwbS4d1oVmj296NQq/w9CoRBD+IIiNmug6R1MNczX0VsXRrDeNkT5I53zHZ1yaVQ
         Rulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683042730; x=1685634730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R7DJwzYL5w5i+ufJACiL7UDmRNxJUi8dTGWXWXs5Uuc=;
        b=A27Y2DJra6sO4NwVOemIl88rs5/PVN3D0LwnLL8R5T+ln1Ay/jErto6sc+RsdGEpxH
         aTXZXXYMJgroIUDJ6MZRx/5ojK5xk3yCcd3SI3QyiynuU654w3LH5acOZywTJEbrl1OA
         fP6b0OsKrxcjPmaDczHqf7aeZ97f3dCjxOwqT1WNXw/vMKdeEwe39l6Jt102N+/FbMAT
         myDGhuMg1LcEHDfoYZ0lTgNanAOvHbOv6va5J9FSU4xyFaooO9hJCp0+zLYomHfeq5Pb
         tRBCV/Niw9Nkzpt/mHX/STqTdu6PccBV4rEXZT7LsgaVo1IaeYJ9pqTl36VABlO+/+9P
         ee/Q==
X-Gm-Message-State: AC+VfDy4mRj5VY+0RZ5aBpIvqlECphKFDBjJkOVsEX06lkVdJsACLHVh
        Os2Obw5EJHqIaLIUCxiC4SA=
X-Google-Smtp-Source: ACHHUZ5sXafgC+OqnMDAOtgSC/VYmhUoZPPuIyBiN8BnNj6gnVUtZ0wz/1yhbybDEoQBJRLjeeOTeQ==
X-Received: by 2002:a17:902:e543:b0:1a9:5dfb:11c5 with SMTP id n3-20020a170902e54300b001a95dfb11c5mr20541376plf.35.1683042729800;
        Tue, 02 May 2023 08:52:09 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:62ab:a7fd:a4e3:bd70])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902778300b001a1a07d04e6sm19917212pll.77.2023.05.02.08.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 08:52:09 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v7 04/13] bpf: sockmap, improved check for empty queue
Date:   Tue,  2 May 2023 08:51:50 -0700
Message-Id: <20230502155159.305437-5-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230502155159.305437-1-john.fastabend@gmail.com>
References: <20230502155159.305437-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

To fix instead of popping the skb from the queue entirely we peek the
skb from the queue and do the copy there. This ensures checks to the
queue length are non-zero while skb is being processed. Then finally
when the entire skb has been copied to user space queue or another
socket we pop it off the queue. This way the queue length check allows
bypassing the queue only after the list has been completely processed.

To reproduce issue we run NGINX compliance test with sockmap running and
observe some flakes in our testing that we attributed to this issue.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Tested-by: William Findlay <will@isovalent.com>
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h |  1 -
 net/core/skmsg.c      | 32 ++++++++------------------------
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 904ff9a32ad6..054d7911bfc9 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -71,7 +71,6 @@ struct sk_psock_link {
 };
 
 struct sk_psock_work_state {
-	struct sk_buff			*skb;
 	u32				len;
 	u32				off;
 };
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 3f95c460c261..bc5ca973400c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -622,16 +622,12 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 
 static void sk_psock_skb_state(struct sk_psock *psock,
 			       struct sk_psock_work_state *state,
-			       struct sk_buff *skb,
 			       int len, int off)
 {
 	spin_lock_bh(&psock->ingress_lock);
 	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
-		state->skb = skb;
 		state->len = len;
 		state->off = off;
-	} else {
-		sock_drop(psock->sk, skb);
 	}
 	spin_unlock_bh(&psock->ingress_lock);
 }
@@ -642,23 +638,17 @@ static void sk_psock_backlog(struct work_struct *work)
 	struct sk_psock *psock = container_of(dwork, struct sk_psock, work);
 	struct sk_psock_work_state *state = &psock->work_state;
 	struct sk_buff *skb = NULL;
+	u32 len = 0, off = 0;
 	bool ingress;
-	u32 len, off;
 	int ret;
 
 	mutex_lock(&psock->work_mutex);
-	if (unlikely(state->skb)) {
-		spin_lock_bh(&psock->ingress_lock);
-		skb = state->skb;
+	if (unlikely(state->len)) {
 		len = state->len;
 		off = state->off;
-		state->skb = NULL;
-		spin_unlock_bh(&psock->ingress_lock);
 	}
-	if (skb)
-		goto start;
 
-	while ((skb = skb_dequeue(&psock->ingress_skb))) {
+	while ((skb = skb_peek(&psock->ingress_skb))) {
 		len = skb->len;
 		off = 0;
 		if (skb_bpf_strparser(skb)) {
@@ -667,7 +657,6 @@ static void sk_psock_backlog(struct work_struct *work)
 			off = stm->offset;
 			len = stm->full_len;
 		}
-start:
 		ingress = skb_bpf_ingress(skb);
 		skb_bpf_redirect_clear(skb);
 		do {
@@ -677,8 +666,7 @@ static void sk_psock_backlog(struct work_struct *work)
 							  len, ingress);
 			if (ret <= 0) {
 				if (ret == -EAGAIN) {
-					sk_psock_skb_state(psock, state, skb,
-							   len, off);
+					sk_psock_skb_state(psock, state, len, off);
 
 					/* Delay slightly to prioritize any
 					 * other work that might be here.
@@ -689,15 +677,16 @@ static void sk_psock_backlog(struct work_struct *work)
 				/* Hard errors break pipe and stop xmit. */
 				sk_psock_report_error(psock, ret ? -ret : EPIPE);
 				sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
-				sock_drop(psock->sk, skb);
 				goto end;
 			}
 			off += ret;
 			len -= ret;
 		} while (len);
 
-		if (!ingress)
+		skb = skb_dequeue(&psock->ingress_skb);
+		if (!ingress) {
 			kfree_skb(skb);
+		}
 	}
 end:
 	mutex_unlock(&psock->work_mutex);
@@ -790,11 +779,6 @@ static void __sk_psock_zap_ingress(struct sk_psock *psock)
 		skb_bpf_redirect_clear(skb);
 		sock_drop(psock->sk, skb);
 	}
-	kfree_skb(psock->work_state.skb);
-	/* We null the skb here to ensure that calls to sk_psock_backlog
-	 * do not pick up the free'd skb.
-	 */
-	psock->work_state.skb = NULL;
 	__sk_psock_purge_ingress_msg(psock);
 }
 
@@ -813,7 +797,6 @@ void sk_psock_stop(struct sk_psock *psock)
 	spin_lock_bh(&psock->ingress_lock);
 	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
 	sk_psock_cork_free(psock);
-	__sk_psock_zap_ingress(psock);
 	spin_unlock_bh(&psock->ingress_lock);
 }
 
@@ -828,6 +811,7 @@ static void sk_psock_destroy(struct work_struct *work)
 	sk_psock_done_strp(psock);
 
 	cancel_delayed_work_sync(&psock->work);
+	__sk_psock_zap_ingress(psock);
 	mutex_destroy(&psock->work_mutex);
 
 	psock_progs_drop(&psock->progs);
-- 
2.33.0


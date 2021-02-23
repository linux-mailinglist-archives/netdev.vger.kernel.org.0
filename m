Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009AA323467
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 00:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbhBWXsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 18:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbhBWXma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 18:42:30 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF6EC06174A
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 15:41:32 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id t3so259985pjw.1
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 15:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=qVRZCptOiqpdrJRUel6wccvI7Yn5b2bHXxCQt2S6qiM=;
        b=YBPcoPLJOAI1eh3WRGe49B6Sb55qhx/1oBG2QPoBS2fo/aQ+/IKs91eyQQr5y4CXAU
         EcdV8SMjmKHYlC6nAxodA0EvOKp+t5eHW7Id1AztQNsHLHj5taxwfzVCF1YdSCVPUqiR
         1mc53B+0WZOGX9ws083liMDSNmQsAOK0ko6XSCP2twAM/sAucuDqo5b3X+PYy28wBUpt
         rPRww5pjsCBiC+AC1V/Lk3jOtoV96K5PPtdolqsI8bTWha3G5xjFxRQkFWoXYJ1IPrEG
         DssJWfM6WXf32eVQMJy3EnS0EJvqSt6PVoISj+hnLYF2626sx9rJsxCUk52lgikAFxEr
         xyuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=qVRZCptOiqpdrJRUel6wccvI7Yn5b2bHXxCQt2S6qiM=;
        b=quSDB/8kzsNp+09ypDzAwapnis/ijuLEwIsq+tEiM135t1tVFxVvKirDwaURFKFIZr
         01Req3WP5K7jOhbgtMKd7fMcvIPhBmwnVyxZc4Y9TrG8V8EI2gS6HvSqRYSYD6EGE04U
         Tu7BE/XgPfzE1mmiyEUbKBBjAXPfTjNY4eHufUcocmEjxRDGsNmdum+zyAXbQVyNsK6k
         qe2ZPCeIvj2PpubIPXTJ/hHfSURz62QXccYSdb/8MJdgGr5MsSRenmVh4HiHt2UKCqFX
         vyDxavT0s7sxdvLgxkvK5PVnaidnmdBMlWhRkONdMWT4PHkxVzYgijXK4I4FndpbMhKW
         q/IA==
X-Gm-Message-State: AOAM532IjSeWaEesPJGmHO8hazAyfwZK9ASkvs4zsh1MN1+WEVKTa8n/
        YrFDJEFCNVNg42B3tsObedoGHPGMOKA=
X-Google-Smtp-Source: ABdhPJzem40D6IAG3Eo2XOtN4+zb+rvB4c5AUodifKcRvbO2RIf8kXQdmxmLEpvkyYKfmIOyqTlufxFAq5g=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:715d:9305:b941:b7c6])
 (user=weiwan job=sendgmr) by 2002:a05:6a00:7cf:b029:1ec:d659:e55c with SMTP
 id n15-20020a056a0007cfb02901ecd659e55cmr27826924pfu.69.1614123692159; Tue,
 23 Feb 2021 15:41:32 -0800 (PST)
Date:   Tue, 23 Feb 2021 15:41:30 -0800
Message-Id: <20210223234130.437831-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH net] net: fix race between napi kthread mode and busy poll
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
determine if the kthread owns this napi and could call napi->poll() on
it. However, if socket busy poll is enabled, it is possible that the
busy poll thread grabs this SCHED bit (after the previous napi->poll()
invokes napi_complete_done() and clears SCHED bit) and tries to poll
on the same napi.
This patch tries to fix this race by adding a new bit
NAPI_STATE_SCHED_BUSY_POLL in napi->state. This bit gets set in
napi_busy_loop() togther with NAPI_STATE_SCHED, and gets cleared in
napi_complete_done() together with NAPI_STATE_SCHED. This helps
distinguish the ownership of the napi between kthread and the busy poll
thread, and prevents the kthread from polling on the napi when this napi
is still owned by the busy poll thread.

Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
Reported-by: Martin Zaharinov <micron10@gmail.com>
Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Eric Dumazet <edumazet@google.come>
Signed-off-by: Wei Wang <weiwan@google.com>
---
 include/linux/netdevice.h |  4 +++-
 net/core/dev.c            | 10 ++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ddf4cfc12615..9ed0f89ccdd5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -357,9 +357,10 @@ enum {
 	NAPI_STATE_NPSVC,		/* Netpoll - don't dequeue from poll_list */
 	NAPI_STATE_LISTED,		/* NAPI added to system lists */
 	NAPI_STATE_NO_BUSY_POLL,	/* Do not add in napi_hash, no busy polling */
-	NAPI_STATE_IN_BUSY_POLL,	/* sk_busy_loop() owns this NAPI */
+	NAPI_STATE_IN_BUSY_POLL,	/* sk_busy_loop() grabs SHED bit and could busy poll */
 	NAPI_STATE_PREFER_BUSY_POLL,	/* prefer busy-polling over softirq processing*/
 	NAPI_STATE_THREADED,		/* The poll is performed inside its own thread*/
+	NAPI_STATE_SCHED_BUSY_POLL,	/* Napi is currently scheduled in busy poll mode */
 };
 
 enum {
@@ -372,6 +373,7 @@ enum {
 	NAPIF_STATE_IN_BUSY_POLL	= BIT(NAPI_STATE_IN_BUSY_POLL),
 	NAPIF_STATE_PREFER_BUSY_POLL	= BIT(NAPI_STATE_PREFER_BUSY_POLL),
 	NAPIF_STATE_THREADED		= BIT(NAPI_STATE_THREADED),
+	NAPIF_STATE_SCHED_BUSY_POLL	= BIT(NAPI_STATE_SCHED_BUSY_POLL),
 };
 
 enum gro_result {
diff --git a/net/core/dev.c b/net/core/dev.c
index 6c5967e80132..ec1a30d95d8b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6486,6 +6486,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
 
 		new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
+			      NAPIF_STATE_SCHED_BUSY_POLL |
 			      NAPIF_STATE_PREFER_BUSY_POLL);
 
 		/* If STATE_MISSED was set, leave STATE_SCHED set,
@@ -6525,6 +6526,7 @@ static struct napi_struct *napi_by_id(unsigned int napi_id)
 
 static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
 {
+	clear_bit(NAPI_STATE_SCHED_BUSY_POLL, &napi->state);
 	if (!skip_schedule) {
 		gro_normal_list(napi);
 		__napi_schedule(napi);
@@ -6624,7 +6626,8 @@ void napi_busy_loop(unsigned int napi_id,
 			}
 			if (cmpxchg(&napi->state, val,
 				    val | NAPIF_STATE_IN_BUSY_POLL |
-					  NAPIF_STATE_SCHED) != val) {
+					  NAPIF_STATE_SCHED |
+					  NAPIF_STATE_SCHED_BUSY_POLL) != val) {
 				if (prefer_busy_poll)
 					set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
 				goto count;
@@ -6971,7 +6974,10 @@ static int napi_thread_wait(struct napi_struct *napi)
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop() && !napi_disable_pending(napi)) {
-		if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
+		unsigned long val = READ_ONCE(napi->state);
+
+		if (val & NAPIF_STATE_SCHED &&
+		    !(val & NAPIF_STATE_SCHED_BUSY_POLL)) {
 			WARN_ON(!list_empty(&napi->poll_list));
 			__set_current_state(TASK_RUNNING);
 			return 0;
-- 
2.30.0.617.g56c4b15f3c-goog


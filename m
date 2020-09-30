Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8777927F285
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbgI3TWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgI3TWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:22:34 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59756C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 12:22:32 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id b18so1950371qto.4
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 12:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=nxuoKptH0MeJm9Vqvc43LnSUpndmev/qZqbAMJlzA3Y=;
        b=PeR3PmeLSlw51GNzI58WUjBFaCLv9BpTA2Jwlgf68TB8MUv6vbRxSxgBfD/bBi5wJE
         rnmkDfWodkSt56r87gk6XLP82fQihaRY/dw7PNggBRAh3J0GrRqOZHlk2EbmNMjCvUXh
         ToR6J8kRlxFrBmtl4EJs7UiBXv6IjH4uMmWTnQ+EQzgNKFaKm33ZOmdvhQz/hrttpQN0
         bcamAoHJBat2ZgM9+hTlAoEyKeoxouYKLm2+NkMxcbZ/Gm881cc6zwHduSNB1nFbEpCZ
         Cw/vkPmGIWZnaX27At6yorCk50tNwi0p5SJY8o0xsN/qxg9VkAuez8jW7TArfO6c06lb
         ltzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nxuoKptH0MeJm9Vqvc43LnSUpndmev/qZqbAMJlzA3Y=;
        b=qhXhlohxbiMVhU0CKA5P6R/nCDBopY0QgH2S/Se/DbzH6ZYAEmpx7oMEwD8UggEgyi
         Tczr3iLNex0GS6spN6TMmvdO2EI3Fk5UAyhpTn81grDK3vCf7wcSCqiE6Gxyt5IivXgl
         fs0DoSL+6G/0zNuByAgqhbkBsmJG1/ItPLGh/g0rYHSzP6YLB/TZy0YIVz7dVRWBuoCU
         M4dTTeyGEZAUBALedQtI3cdisP4B8uKqt/rABKtNimgJZqsuaLBRBwqg0Hs6ax/JFOC8
         iLumHZ9m/LhEG6iLfgxRIXe/ChGFURq8XTtHOm7R+9rXesD/HbFgyX/xZYUZElVIVlFS
         Em7A==
X-Gm-Message-State: AOAM530hV6GrUURiC2WteIApI3ezytW9lEEUiQ/YmIqFEbQW+63ZDt1Y
        XSH+4gdqlihZAEvmbJJ79ApeBJEiBW0=
X-Google-Smtp-Source: ABdhPJx7C/SaT8OPNRV5C9uc+cZAuZeTasU441768UWQZFd9ikIouk8Zd1UcPAIyOlIgf0MVV2JNwhizpzI=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a05:6214:a03:: with SMTP id
 dw3mr3722158qvb.44.1601493751484; Wed, 30 Sep 2020 12:22:31 -0700 (PDT)
Date:   Wed, 30 Sep 2020 12:21:38 -0700
In-Reply-To: <20200930192140.4192859-1-weiwan@google.com>
Message-Id: <20200930192140.4192859-4-weiwan@google.com>
Mime-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH net-next 3/5] net: extract napi poll functionality to __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name> 

This commit introduces a new function __napi_poll() which does the main
logic of the existing napi_poll() function, and will be called by other
functions in later commits.
This idea and implementation is done by Felix Fietkau <nbd@nbd.name> and
is proposed as part of the patch to move napi work to work_queue
context.
This commit by itself is a code restructure.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Wei Wang <weiwan@google.com>
---
 net/core/dev.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 259cd7f3434f..c82522262ca8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6783,15 +6783,10 @@ void __netif_napi_del(struct napi_struct *napi)
 }
 EXPORT_SYMBOL(__netif_napi_del);
 
-static int napi_poll(struct napi_struct *n, struct list_head *repoll)
+static int __napi_poll(struct napi_struct *n, bool *repoll)
 {
-	void *have;
 	int work, weight;
 
-	list_del_init(&n->poll_list);
-
-	have = netpoll_poll_lock(n);
-
 	weight = n->weight;
 
 	/* This NAPI_STATE_SCHED test is for avoiding a race
@@ -6811,7 +6806,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			    n->poll, work, weight);
 
 	if (likely(work < weight))
-		goto out_unlock;
+		return work;
 
 	/* Drivers must not modify the NAPI state if they
 	 * consume the entire weight.  In such cases this code
@@ -6820,7 +6815,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	 */
 	if (unlikely(napi_disable_pending(n))) {
 		napi_complete(n);
-		goto out_unlock;
+		return work;
 	}
 
 	if (n->gro_bitmask) {
@@ -6832,6 +6827,26 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 
 	gro_normal_list(n);
 
+	*repoll = true;
+
+	return work;
+}
+
+static int napi_poll(struct napi_struct *n, struct list_head *repoll)
+{
+	bool do_repoll = false;
+	void *have;
+	int work;
+
+	list_del_init(&n->poll_list);
+
+	have = netpoll_poll_lock(n);
+
+	work = __napi_poll(n, &do_repoll);
+
+	if (!do_repoll)
+		goto out_unlock;
+
 	/* Some drivers may have called napi_schedule
 	 * prior to exhausting their budget.
 	 */
-- 
2.28.0.709.gb0816b6eb0-goog


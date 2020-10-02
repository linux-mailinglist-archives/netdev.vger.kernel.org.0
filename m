Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6DA281E45
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgJBWZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgJBWZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:25:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EDCC0613E2
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 15:25:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u64so3179754ybb.8
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 15:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=+/Y13zHFtQa/zSznIFcvahVMTAlYDeryTWEPgZln9ko=;
        b=kPD0QaR55PRUjryQ9DkDw1e3MA+qYzV23mfiOIsLsC7YwxsLflYQvHK6i2w7M3pimf
         +qfP+scRRy3m9/NoheejEw6/FmVA8qIoPOJ1RMnk7cEq/nKM+R1vb1dfmi8TgG9PoBJQ
         5eoJgzSQcqArLN8uySwIuNbI7JPnHPfBgaE3N+MzEHJvvaZffVO6wKlBHQXLasbwoHae
         hbdReBCw+k9sEyCb7AmUVJhhGLDRde0fL3skspOLnQ7HLQtFQGdDwPZbPjfpnXDvkA7R
         2IonxNxqvxm1dIP6cEhuava3T44/0br6o+tXuCsSaOfjcuGrgBUumOhpkt8uhg0iAW2k
         13GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+/Y13zHFtQa/zSznIFcvahVMTAlYDeryTWEPgZln9ko=;
        b=mXFW/6QTM7MNoUwkkRiT5qLJiscX3dX3/3BWbyhrwL0c2DNCYEdTJs+TheW8JxwomM
         aLHp5X7dSmFkP/TR50qWRJmI/sB53jLDtDSfHxt+/GnasY2qDra8ew15zQP4iBf2Z4TI
         lvEwgBhHfe/E43SJhgReMjegV+AmaOiwnlanpHoKzxd/+wv/UCsJ/cC9YPoRamIdiXzk
         YoCJDZSQuk2p1A+PkQ4dmzBFrfs1OQQWeECKKhczMLMHA6bno4OcViDLAB9YSSxahdgy
         JlaVGyYwHA5cH8emYSqo+t4EpJ/uMdzahy/i3lzaL72HKKcy8/d+ajCE9PbBA+KOTOHw
         Pp8A==
X-Gm-Message-State: AOAM533PVPt1WZMIubX/cAkWDHG1S+drIGw1PxAtWY/cgpmkozzaSgu+
        2gtQ9ejB9ZgrNU3Ni/6moXlX5ZlaL2s=
X-Google-Smtp-Source: ABdhPJy7tpzGYt4zncwzOmFQUqg0OjaqAnthWZW649Bh3jszsoCizpyRTGPn0VIol8RFs7Opw10ZC3mPPBQ=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:4e55:: with SMTP id c82mr5715101ybb.416.1601677539345;
 Fri, 02 Oct 2020 15:25:39 -0700 (PDT)
Date:   Fri,  2 Oct 2020 15:25:12 -0700
In-Reply-To: <20201002222514.1159492-1-weiwan@google.com>
Message-Id: <20201002222514.1159492-4-weiwan@google.com>
Mime-Version: 1.0
References: <20201002222514.1159492-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH net-next v2 3/5] net: extract napi poll functionality to __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Wei Wang <weiwan@google.com>
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
2.28.0.806.g8561365e88-goog


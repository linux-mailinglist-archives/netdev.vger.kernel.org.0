Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFC6269336
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgINR1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgINR0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:26:20 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC9FC06178B
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:26:19 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id f4so280945qvw.15
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=BYFSDnsZ7CuyDxsknJLPnmb95P0RzbVeR4SkBJzlkVA=;
        b=lctbWoGOpEsl+BNavcOA1GcDL2htg6vhGxsTtZ7XDhsDTuA0MzKWBWZTTJ9aejTGN0
         k7O14lk2EPG9I9PWSbbMGrIu9J29CltGhy/tYmKbvaFiFzVORxavfn4M2UsR96LdKhrG
         D2LNXtI8sVoUAtEsRWxpFKC3/Tnw4WiLyxpNaHL9qg2y3siZSG9ACXwMP0JP4PjCqRmE
         SDlPDpSK+/HeTyooUHMZBCUz/tjIhYk+sPiWYuAfLUvSLRWosYsCzi+AexNjplWiJ5Aq
         midNsks4mQc0ohlcohX2b4KcQey7DAi87tkokRf69rgjFPPyghYyTqXT04OK95DUuH2c
         1rtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BYFSDnsZ7CuyDxsknJLPnmb95P0RzbVeR4SkBJzlkVA=;
        b=WBDQ9ChXWjNk5PT/ev3YZB2te4HKxWwJGVtMVlZBGgI2GTrII4RXgMoaX5oH6uYfdb
         N2jyOZbFVYaiYq85jHT7OpNMDililhr3BIVHSQXcwwYzMZLauEEbBo9iWrnqndwzneSt
         Ls6nqOeKl7NiGLJUnWgqr71aGhGt5dWE3ePLG7qi+CWpi1c6QoZWmRvOiar18u8sM//G
         kHoVI5zDiZCNDSPfuJEEETdNLEUcngQNVPBIz4YUWqfqXmkg3FNprw8PsSYelvjsDI4I
         Xzst9o2Ztj29UA4MntK53a/Z4ML3ynukriGHb1xtVt6TakYb2OR7BtBzAxl9R+Fe9V1m
         /4OA==
X-Gm-Message-State: AOAM531h95W8Q9m6xVrek/Pig9ZS0UVo1meOliTuvec22BTYRmcy00OS
        t8I570p09ZXpzyN1h8g+XGNtCy896BI=
X-Google-Smtp-Source: ABdhPJw+KfQCn3FQSFLrXBvQa9e6HjajYy/kMe2SX9WQJMBOcgaLQShXWkJ6goWbp0bov21Tz4K0L1oJO+M=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:ad4:5a53:: with SMTP id ej19mr14402811qvb.54.1600104376172;
 Mon, 14 Sep 2020 10:26:16 -0700 (PDT)
Date:   Mon, 14 Sep 2020 10:24:50 -0700
In-Reply-To: <20200914172453.1833883-1-weiwan@google.com>
Message-Id: <20200914172453.1833883-4-weiwan@google.com>
Mime-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [RFC PATCH net-next 3/6] net: extract napi poll functionality to __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
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
index 0fe4c531b682..bc2a7681b239 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6719,15 +6719,10 @@ void __netif_napi_del(struct napi_struct *napi)
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
@@ -6747,7 +6742,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 			    n->poll, work, weight);
 
 	if (likely(work < weight))
-		goto out_unlock;
+		return work;
 
 	/* Drivers must not modify the NAPI state if they
 	 * consume the entire weight.  In such cases this code
@@ -6756,7 +6751,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	 */
 	if (unlikely(napi_disable_pending(n))) {
 		napi_complete(n);
-		goto out_unlock;
+		return work;
 	}
 
 	if (n->gro_bitmask) {
@@ -6768,6 +6763,26 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 
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
2.28.0.618.gf4bc123cb7-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567242803C9
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732415AbgJAQXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730534AbgJAQW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 12:22:58 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DB9C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 09:22:57 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id l126so5002451pfd.5
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 09:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YMPvlDFGFLQUs5HYTrj8gBRL0o3MHNTx28Yg7XSPyjs=;
        b=D28G+adQrkE50XOgYE3cDtG4tAXGcCdxftoZMpc6iHYbp144r6Vj88evCa90MytwPO
         ApfA6p2tLI9bE2nTh7RRYWi3roTcdFEGyYtlZghUxv7hJ0ORvJgyveVtYUjs+7qUbpJR
         UzSiBrvUUgyI3s3602RgHzcv7Z3jsf+AbHi3j8wwfTZLWGAK7c7C1+SvVZDD/GdrDOld
         kyLMQBn9WQlAlogwmq12IhMF/NlVNwSowZGk03/xv1KTQnO5FRXst80uHnps0fJZc28j
         c4Y5GPptlVHTEs0WGiE/frKJexp2YymCPy3BQdniXLWDfdRIrQwULqTakNMrIzLVH26C
         EXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YMPvlDFGFLQUs5HYTrj8gBRL0o3MHNTx28Yg7XSPyjs=;
        b=APxu3YA40mQ5Cp68GBCjhXTG2JhUQHXqSWqdKCdSb5ae+XyhuROmJWMzArslmXiJeZ
         mu1WWom2q3Lda710KlHI/Tiv+mOxcjeFNxch9y4Rg6Y72WnVPbsv+cCeIGHWC0cCsrp2
         2J99kiFunDm9gPZZhshDPoCQ+8IwTkeA4Nbd9ML4TF0ex0uNqtioUCjioQx9S3GmNrmg
         DvabX+43j9rUv+mbdJ+vcyDB12R3J1sx3i7h2gwyLR3imJ7E8PliWeD8pthjNcwDtNIG
         EyEKQzUyMua1BYg9Mo942oq76bLIT+QGJ6lVshbiv4trfrBluRQ0IDl7qLg+kuVpURbd
         kHIg==
X-Gm-Message-State: AOAM531sOT06jdcW0Ew+MEq2lZrtJsH2d5zLNVX6kgUnmOPjE3bwKzqU
        Z9cI82JRuqh6/U54wDJ94GFbrrQSGVgTzA==
X-Google-Smtp-Source: ABdhPJzrvNFrH0BWWCBKS35UhWrszY1naOKT3VdgVCdRa4E+EbwgHnPl2HJxn4Z7D+ALU0cd/RL+rA==
X-Received: by 2002:a62:1dcb:0:b029:13e:d13d:a131 with SMTP id d194-20020a621dcb0000b029013ed13da131mr7896922pfd.25.1601569377156;
        Thu, 01 Oct 2020 09:22:57 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k2sm6380066pfi.169.2020.10.01.09.22.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Oct 2020 09:22:56 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/8] ionic: drain the work queue
Date:   Thu,  1 Oct 2020 09:22:40 -0700
Message-Id: <20201001162246.18508-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001162246.18508-1-snelson@pensando.io>
References: <20201001162246.18508-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check through our work list for additional items.  This normally
will only have one item, but occasionally may have another
job waiting.  There really is no need reschedule ourself here.

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 969979b31e93..53ac0e4402e7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -62,15 +62,18 @@ static void ionic_lif_deferred_work(struct work_struct *work)
 	struct ionic_deferred *def = &lif->deferred;
 	struct ionic_deferred_work *w = NULL;
 
-	spin_lock_bh(&def->lock);
-	if (!list_empty(&def->list)) {
-		w = list_first_entry(&def->list,
-				     struct ionic_deferred_work, list);
-		list_del(&w->list);
-	}
-	spin_unlock_bh(&def->lock);
+	do {
+		spin_lock_bh(&def->lock);
+		if (!list_empty(&def->list)) {
+			w = list_first_entry(&def->list,
+					     struct ionic_deferred_work, list);
+			list_del(&w->list);
+		}
+		spin_unlock_bh(&def->lock);
+
+		if (!w)
+			break;
 
-	if (w) {
 		switch (w->type) {
 		case IONIC_DW_TYPE_RX_MODE:
 			ionic_lif_rx_mode(lif, w->rx_mode);
@@ -94,8 +97,8 @@ static void ionic_lif_deferred_work(struct work_struct *work)
 			break;
 		}
 		kfree(w);
-		schedule_work(&def->work);
-	}
+		w = NULL;
+	} while (true);
 }
 
 void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
-- 
2.17.1


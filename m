Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55BB4989BD
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344141AbiAXS6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344525AbiAXSyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:46 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACABDC061796
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:34 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d18so3962445plg.2
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vL1qGSXsPep8AFh0pLtJDwX+8jYU1IJ9Z1/HMykJPtI=;
        b=n2M0h0wtqhWd8M89HoOZ0HP41CssQj6Vo7dEaBAwjPyVa+yTW2YtM9yVQ20cJ8LMhS
         zhrBebZ0v8ViP8tr5aNbYv7QRkad8yr9UIWI5Go7Z3RZjXWFFUlkmA3R8gNLAdf6S1UB
         /1zbx7yV84KqCYvs8eaulTa+Bq7mbflVxGy0KBNbzvTe+u+wB/vKEsRIpfN86W3auGAy
         mC06IsquHtZOGau3Ws4DPsFBAdMViYOBvTAYfDo1vAexTWbjAytMd6cxvbhR37NAqXno
         HZEoyw1r+PSvtqsBHKKMdEeYMffGaw1mSGEA9HsKPvMEtyy3PegROmPKrXxdONm/dPmr
         ZodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vL1qGSXsPep8AFh0pLtJDwX+8jYU1IJ9Z1/HMykJPtI=;
        b=S3i9LYXowd1+QLx8NA2G8cnPUT6O5TPmF3XIGSjheE6nzekbziw2oo/3s0H4d5Seo9
         SkXdxiTksQaXwT8qLc6/YJTsSUggao25ogr6qMzJJX3ZOpdCHUWErFJz0pYlOvXn7ks/
         59r9N0IUu8K8tE4oZ7aMRwLf/1x5nHxmdkllp0YVQgaszFAf4G4PzDgR/NJfYCPwwrNP
         9JAdWmIHLU9MmBHs61BdZMqsj1rB2bjZbpsJ3rSxvYUBg95/Vy3NW7vOJ8MUeswbe0wu
         rfqtw2h2lT5bBt14dsyDqDGEhRMsrTINJ8IrYLHb1eoGjF49O7pacSwOrWnQqhkPAI5b
         XzdQ==
X-Gm-Message-State: AOAM533sPCkfLHxBn9kJCvhDFSRNR+8iPh4vcXVbPBKTeGvxHYL/VS/H
        uwUQ7g2gTzTr0AXrxHIQqobNGg==
X-Google-Smtp-Source: ABdhPJyL9uEjVwDIrd4Y11Z9roQmlNsOJQUAsk+SxZkv/RU0M9rVJ4BIFumkDjdjppUBLiZArrcPgQ==
X-Received: by 2002:a17:90b:3503:: with SMTP id ls3mr3207244pjb.186.1643050414200;
        Mon, 24 Jan 2022 10:53:34 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:33 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 07/16] ionic: fix up printing of timeout error
Date:   Mon, 24 Jan 2022 10:53:03 -0800
Message-Id: <20220124185312.72646-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure we print the TIMEOUT string if we had a timeout
error, rather than printing the wrong status.

Fixes: 8c9d956ab6fb ("ionic: allow adminq requests to override default error message")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 449e9ee2acf0..04fc2342b055 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -215,9 +215,13 @@ static void ionic_adminq_flush(struct ionic_lif *lif)
 void ionic_adminq_netdev_err_print(struct ionic_lif *lif, u8 opcode,
 				   u8 status, int err)
 {
+	const char *stat_str;
+
+	stat_str = (err == -ETIMEDOUT) ? "TIMEOUT" :
+					 ionic_error_to_str(status);
+
 	netdev_err(lif->netdev, "%s (%d) failed: %s (%d)\n",
-		   ionic_opcode_to_str(opcode), opcode,
-		   ionic_error_to_str(status), err);
+		   ionic_opcode_to_str(opcode), opcode, stat_str, err);
 }
 
 static int ionic_adminq_check_err(struct ionic_lif *lif,
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC1C3D7C69
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhG0Rnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhG0Rnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:43:46 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E208EC061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:45 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b6so330557pji.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bFcozBPtisyVv7oPMFidPiZ9thZ5dcWN7BZBC2wzhEw=;
        b=QnFe1xSFSZQeVFyyyUOE2/pIjKZ0v+jOnV46EA3LEDqrFGBV1/Lp9uY7nBfh9Tkkob
         a9p5YRPPJ5Px9QfCyWFZSUVu6PsZqUWRNeMT6FFTm8PsI9fCypmdKQQyF+6EinHFWhtG
         f5sAaPQeOvhvdyH+/gwa7z2TRvOZ3ywqSGeMGP2Ix1X/t3i9jmU3TJE4tRoZjZrOpG3p
         xTYLVI5p+m2UrtwhudzL4Bncy1QLwAFOFMoO0s2AO6KobGPSIGcLebmbTqhunMgRFBA9
         V3ZcAslKkDDHYYXnTLns+fwKATqugmpZ1ixN/D6tnU3HS81RZ2jFN2NlLlH6H2RT0H4N
         sB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bFcozBPtisyVv7oPMFidPiZ9thZ5dcWN7BZBC2wzhEw=;
        b=KpFFbXfJ0b7zUkB9zdT3zLscG62BwfedgBkT5bINAIURNcVN66pH8HMSszDwcJz9oe
         NMJxbuh5bmjQqRzax+GYI4J0fPf5e9Yi5pubiCorwNEvBWnpQtYX98sgNKY1Z3pZ603H
         /F936ZLCssm6dfMXCKGyLF8ffqo5BH9nq1guYTQgbwzXGC7nAtc4KYopVHpMnZzR6syw
         Q/ZB1UVyzNpdl7yy5/64zJHcgbfsbVu4DMm9fA7NXsPnCB7yqGhNeZycuTFUzhL/ShoV
         00KuXeDXmsC40G6my98ggFi58SdyG4QDiw6MYrrHXaRJPDsow27UBPU/iXcPKweKnCnO
         0XKw==
X-Gm-Message-State: AOAM532mWmfVo3mQ6nw1HA6Fo/wBRGQlLgQVof8nk+Rnkv9Pce+AX3Nj
        7AEA28FiHrkPbiPcukvalvfX/Q==
X-Google-Smtp-Source: ABdhPJzQ0i8e2NEgUWXh/pJqN+rnWc4ia9BvgZGW6GnGiyZl+l1iyYjvRxGRe9oby/p9jjv+LeyBaw==
X-Received: by 2002:a63:110c:: with SMTP id g12mr24347428pgl.139.1627407825503;
        Tue, 27 Jul 2021 10:43:45 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t9sm4671944pgc.81.2021.07.27.10.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:43:45 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 03/10] ionic: print firmware version on identify
Date:   Tue, 27 Jul 2021 10:43:27 -0700
Message-Id: <20210727174334.67931-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727174334.67931-1-snelson@pensando.io>
References: <20210727174334.67931-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print the version of the DSC firmware seen when we do a fresh
ident check.  Because the FW can be updated by the external
orchestration system, this helps us track that FW has been
updated on the DSC.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 61cfe2120817..5f1e5b6e85c3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -450,6 +450,8 @@ int ionic_identify(struct ionic *ionic)
 	}
 	mutex_unlock(&ionic->dev_cmd_lock);
 
+	dev_info(ionic->dev, "FW: %s\n", idev->dev_info.fw_version);
+
 	if (err) {
 		dev_err(ionic->dev, "Cannot identify ionic: %dn", err);
 		goto err_out;
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C8C1F89BF
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 19:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgFNQ7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 12:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgFNQ7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 12:59:44 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725BAC05BD43;
        Sun, 14 Jun 2020 09:59:43 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id g7so6695229qvx.11;
        Sun, 14 Jun 2020 09:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=F7zCqDPAcFeQ1dIJ8uLyY4RFFP0+JS+chzWpOQZqqwQ=;
        b=Z+OSw4DLQoCsoz7od7iAIVoLNNmtINNUW/X7wIstEbNuji2fVZ0G8qqpcF1JbV1CZo
         oJQGYqDPX7LQRODhuVjM1cO6rllEDHDq3MtU14emBs8chHXnbADaTAo68GftqLoEj8Pe
         XHIoBaQ7KU0Uk+IH/GEUdOpYP6EsYbSF8AICK4fX650hBU1qrFWNhbs9myiTZGzD/dAm
         cpC8yRjW1zKKi5R4d4XZZQFBj0A3sgf0A6LfOSb3JbV6yO09wSN4ZywAPyJzDPRL6obz
         eePywyAqLJjcpdpvmTajA47tVOrHFtFcFyMHY3Unra03IkM1IEPJmT2tft4Dy/fB78dj
         qIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F7zCqDPAcFeQ1dIJ8uLyY4RFFP0+JS+chzWpOQZqqwQ=;
        b=scUeZu52xmLcZsQZQ42xTI9uFRCFbs0Ej/CZ6uFzVIAhd4dBpNsVrNenj03x1txhRM
         HSCZBIv4UCOQLSYpjMN2/YdisG3bIvBpJsrXbovnkJVqNmZD0FLj9piZr5s1bDXA68X7
         5iEShvyJAkpjMXe/6DGBby+1DueeKfyoXyNK7TqFJXVJ4EkYvhDv+4FNGCduw6GxH876
         s6UJjJ0C9cC5bf/ZUipAoxBgR9djBNHcRcWF2dV8cvIEjDBP2CP5cRyg9th5aG/qVDFa
         2T1bAUXELTOMqx50Qocx4m0lH2wsMdo0pgqSlAlQbXGGhdppjQpmSRssWQ2DWG1P4dvo
         1VDA==
X-Gm-Message-State: AOAM533l2I4GVOlC3OkUOgkqSOvDxJaQ9auPeTFvViI3dlDOOgQasKhr
        GVbk4+hNSq0bJmHO3kktu9A=
X-Google-Smtp-Source: ABdhPJyUqBWzPw5iGPWHWpX0+2uLzH97Q/LOC+TST8CX5VADUz3AVCQugKzCBaI312GEIJlrgeQUdw==
X-Received: by 2002:a0c:8145:: with SMTP id 63mr2436076qvc.60.1592153982266;
        Sun, 14 Jun 2020 09:59:42 -0700 (PDT)
Received: from buszk-y710.fios-router.home (pool-108-54-206-188.nycmny.fios.verizon.net. [108.54.206.188])
        by smtp.googlemail.com with ESMTPSA id k26sm10571827qtk.55.2020.06.14.09.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 09:59:41 -0700 (PDT)
From:   Zekun Shen <bruceshenzk@gmail.com>
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: alx: fix race condition in alx_remove
Date:   Sun, 14 Jun 2020 12:59:12 -0400
Message-Id: <20200614165912.25622-1-bruceshenzk@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a race condition exist during termination. The path is
alx_stop and then alx_remove. An alx_schedule_link_check could be called
before alx_stop and invoke alx_link_check later. Alx_stop frees the
napis, and alx_remove cancels any pending works. If any of the work is
scheduled before termination and invoked before alx_remove, a
null-ptr-deref occurs because both expect alx->napis[i].

This patch fix the race condition by moving cancel_work_sync functions
before alx_free_napis inside alx_stop.

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 drivers/net/ethernet/atheros/alx/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index b9b4edb91..1487d6765 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1249,6 +1249,9 @@ static int __alx_open(struct alx_priv *alx, bool resume)
 
 static void __alx_stop(struct alx_priv *alx)
 {
+	cancel_work_sync(&alx->link_check_wk);
+	cancel_work_sync(&alx->reset_wk);
+
 	alx_halt(alx);
 	alx_free_irq(alx);
 	alx_free_rings(alx);
@@ -1855,9 +1858,6 @@ static void alx_remove(struct pci_dev *pdev)
 	struct alx_priv *alx = pci_get_drvdata(pdev);
 	struct alx_hw *hw = &alx->hw;
 
-	cancel_work_sync(&alx->link_check_wk);
-	cancel_work_sync(&alx->reset_wk);
-
 	/* restore permanent mac address */
 	alx_set_macaddr(hw, hw->perm_addr);
 
-- 
2.17.1


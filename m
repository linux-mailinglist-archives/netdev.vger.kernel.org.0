Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686F21F9C42
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 17:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbgFOPvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 11:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgFOPvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 11:51:01 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021E8C061A0E;
        Mon, 15 Jun 2020 08:51:01 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id dp10so7945017qvb.10;
        Mon, 15 Jun 2020 08:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N9MFjwIDkU/fRqTGThssGDIRUjhg7G4jDT1glvQytko=;
        b=X6/gFRBEJqbq4+cK0EGmbFrgwomFmfr5VkoFKsDNSFrhhdfoslSRjoM7gQ42xcICsG
         U/wljtL5OhFb8BZ0LZ48hCmYesemEBxVgbZPauTA9XPY1VUy4KEdyts95yq9dFN1OMeO
         7gFqWfdIMqRv+mpONsnRV8MCNb/abPPIjyMYThcTOoK8hRcl0oukJZJV2Ql1xbdzzCZq
         uPayhqVctr9ekAn1upOhXqEwEEpNwbII/kgrSAjd6DYfo4OlZ1PDpuupzqWJ/4C7LQ4Q
         uJY9GfUIvEWEXUKS25KcAhaq/MLcmyJQNNrpjBYfcN+A3pmxwon1fcdwpbEUWUHUmzou
         53eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N9MFjwIDkU/fRqTGThssGDIRUjhg7G4jDT1glvQytko=;
        b=CLmJ56AIRUFLcx+1MD0S3c9uqJyhZuKj66AMA3Vp/91H1/AihWnHZDuAAmoWMuP5bh
         m/pesHKUi9vmIuiMvqhOzjlnF+iWlgqLaAzhigeA90YEZht69MYea1F4Rss+HGxG+4d0
         l6mcyPNmn2iw0xUNyZ4Z4OyrCIFNePIdhPSU5YInegU0eRIZXWBjmeVW9A9u4crdvkr7
         T5S3Q248OICq/MxzFks4qW9LioglmG9qMw9XlTrO0SPDol2Y8YEe+OstwLhfWotAMTAa
         dofe8ejbTGx74LGQYp7FHSgEcNX7zmscsD1pKvEVvPBv2iO9f9aF9i50FqtMLhfZ6hDW
         Ow2Q==
X-Gm-Message-State: AOAM531CFqgTSQgw/U+v86ua00VUnYyeesE/AgjCYSbJyK0wvtfAFoCQ
        31kqgvjno49Zs6QOh/4lIFA=
X-Google-Smtp-Source: ABdhPJwS5pLhv+GpLxbnPFbPnNMz5u4jKgJdKqPDGY5OlRkFbGA76E8NSp8H1Sa6R8xxkGGx8TDq9Q==
X-Received: by 2002:a0c:c303:: with SMTP id f3mr25899662qvi.240.1592236260121;
        Mon, 15 Jun 2020 08:51:00 -0700 (PDT)
Received: from buszk-y710.fios-router.home (pool-108-54-206-188.nycmny.fios.verizon.net. [108.54.206.188])
        by smtp.googlemail.com with ESMTPSA id 185sm11757262qke.92.2020.06.15.08.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 08:50:59 -0700 (PDT)
From:   Zekun Shen <bruceshenzk@gmail.com>
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: alx: fix race condition in alx_remove
Date:   Mon, 15 Jun 2020 11:50:29 -0400
Message-Id: <20200615155029.21002-1-bruceshenzk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200614165912.25622-1-bruceshenzk@gmail.com>
References: <20200614165912.25622-1-bruceshenzk@gmail.com>
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a race condition exist during termination. The path is
alx_stop and then alx_remove. An alx_schedule_link_check could be called
before alx_stop by interrupt handler and invoke alx_link_check later.
Alx_stop frees the napis, and alx_remove cancels any pending works.
If any of the work is scheduled before termination and invoked before
alx_remove, a null-ptr-deref occurs because both expect alx->napis[i].

This patch fix the race condition by moving cancel_work_sync functions
before alx_free_napis inside alx_stop. Because interrupt handler can call
alx_schedule_link_check again, alx_free_irq is moved before
cancel_work_sync calls too.

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
Changes in v2:
- move alx_free_irq before cancel_work_sync calls
- prevent another interrupt to cause race condition

 drivers/net/ethernet/atheros/alx/main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index b9b4edb91..9b7f1af5f 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1249,8 +1249,12 @@ static int __alx_open(struct alx_priv *alx, bool resume)
 
 static void __alx_stop(struct alx_priv *alx)
 {
-	alx_halt(alx);
 	alx_free_irq(alx);
+
+	cancel_work_sync(&alx->link_check_wk);
+	cancel_work_sync(&alx->reset_wk);
+
+	alx_halt(alx);
 	alx_free_rings(alx);
 	alx_free_napis(alx);
 }
@@ -1855,9 +1859,6 @@ static void alx_remove(struct pci_dev *pdev)
 	struct alx_priv *alx = pci_get_drvdata(pdev);
 	struct alx_hw *hw = &alx->hw;
 
-	cancel_work_sync(&alx->link_check_wk);
-	cancel_work_sync(&alx->reset_wk);
-
 	/* restore permanent mac address */
 	alx_set_macaddr(hw, hw->perm_addr);
 
-- 
2.17.1


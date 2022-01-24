Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5397849898A
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245519AbiAXS46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344564AbiAXSys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:48 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D410C061776
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:42 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id l17so10456983plg.1
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bz5OSIhu8tiUBZ2woPncS24gjC0NBZkHI9Xptd2J15Y=;
        b=oGbCyt/2eQJkSETc6yVa0XvS2hDM5VjAQRijEKP6rEDMmKGVzqO8coiuXjON/SPeSG
         etKGzgf0hJrCcC4ap/Iwo5WlGR2jL/XTnRvoIvhECUhlFDk45YJNn71a1pLdNRVCxEXK
         f6EpdeIlfhR70gpM7i9g6c5ggIVaWw1F+U9hfEW9A7ymampwUY6Zh08cZSFnEvVCSPPo
         H2nQnXe4DAnFMTq5/eJj6Xq/0FWFcb6LbqAr1qT76XLX1xwD+B0NJ3JP1XbdiFcQDZ3u
         l7ApuTZ9i8LY+ID7l2NQwFVhY6bl8oaWrFM7Pedn5z3mQw3KMRGi0sWceJoJP+uw6wSI
         5ujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bz5OSIhu8tiUBZ2woPncS24gjC0NBZkHI9Xptd2J15Y=;
        b=rLmcbaPPNOielkbh5NjmYz4TmIJdFDGN6pboD3IW3wvRUUTAgTodRyeo5lRFxZADHc
         Gmd2ecoDXcPn09M4vTtfdO58I9PByRADxxOTxu+4SEK8OXvpuo4EQb1j5dQ1AAIK+sNN
         ZJMGMvjSzaO5jux5aWDicu3y2o245YxRCRp98zr/ik149iiB3elBEHgwGsKsvk2qerAJ
         ArW8IH//xtx24ES7NUacMv4dg+40PLRQw8weiLMNEss3IZk1Pz9HndfJ0vIWcoVk0E+k
         wyYUsd5NwQMWoyqz83Qc2qhPGSdBAEZp6uckSyuAFtWtagjGE7xiHJd3QUkJc5k97/rb
         af4w==
X-Gm-Message-State: AOAM531rciNMNHzoAPkirmFETHQjonqG/M3HOTgD1u0ZXA/DZykZVbVy
        UUf/iCp53Oef5YELHaF2bcY1tfNHdW+P1A==
X-Google-Smtp-Source: ABdhPJwa6ojTNQ/rZtP8/PpYUXu8H9JTi3+uJx6rLU9V2e8rgDgg4TZW3AXM93NCPxiW7x2wLW13qw==
X-Received: by 2002:a17:902:be08:b0:14a:ef2e:60e2 with SMTP id r8-20020a170902be0800b0014aef2e60e2mr15164204pls.128.1643050422056;
        Mon, 24 Jan 2022 10:53:42 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:41 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 14/16] ionic: remove the dbid_inuse bitmap
Date:   Mon, 24 Jan 2022 10:53:10 -0800
Message-Id: <20220124185312.72646-15-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dbid_inuse bitmap is not useful in this driver so remove it.

Fixes: 6461b446f2a0 ("ionic: Add interrupts and doorbells")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 17 +----------------
 drivers/net/ethernet/pensando/ionic/ionic_lif.h |  1 -
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index c9535f4863ba..e84a01edc4e4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3014,8 +3014,6 @@ void ionic_lif_free(struct ionic_lif *lif)
 	/* unmap doorbell page */
 	ionic_bus_unmap_dbpage(lif->ionic, lif->kern_dbpage);
 	lif->kern_dbpage = NULL;
-	kfree(lif->dbid_inuse);
-	lif->dbid_inuse = NULL;
 
 	mutex_destroy(&lif->config_lock);
 	mutex_destroy(&lif->queue_lock);
@@ -3215,22 +3213,12 @@ int ionic_lif_init(struct ionic_lif *lif)
 		return -EINVAL;
 	}
 
-	lif->dbid_inuse = bitmap_zalloc(lif->dbid_count, GFP_KERNEL);
-	if (!lif->dbid_inuse) {
-		dev_err(dev, "Failed alloc doorbell id bitmap, aborting\n");
-		return -ENOMEM;
-	}
-
-	/* first doorbell id reserved for kernel (dbid aka pid == zero) */
-	set_bit(0, lif->dbid_inuse);
 	lif->kern_pid = 0;
-
 	dbpage_num = ionic_db_page_num(lif, lif->kern_pid);
 	lif->kern_dbpage = ionic_bus_map_dbpage(lif->ionic, dbpage_num);
 	if (!lif->kern_dbpage) {
 		dev_err(dev, "Cannot map dbpage, aborting\n");
-		err = -ENOMEM;
-		goto err_out_free_dbid;
+		return -ENOMEM;
 	}
 
 	err = ionic_lif_adminq_init(lif);
@@ -3273,9 +3261,6 @@ int ionic_lif_init(struct ionic_lif *lif)
 	ionic_lif_reset(lif);
 	ionic_bus_unmap_dbpage(lif->ionic, lif->kern_dbpage);
 	lif->kern_dbpage = NULL;
-err_out_free_dbid:
-	kfree(lif->dbid_inuse);
-	lif->dbid_inuse = NULL;
 
 	return err;
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 2db708df6b55..a53984bf3544 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -214,7 +214,6 @@ struct ionic_lif {
 	u32 rx_coalesce_hw;		/* what the hw is using */
 	u32 tx_coalesce_usecs;		/* what the user asked for */
 	u32 tx_coalesce_hw;		/* what the hw is using */
-	unsigned long *dbid_inuse;
 	unsigned int dbid_count;
 
 	struct ionic_phc *phc;
-- 
2.17.1


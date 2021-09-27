Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDA241A128
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 23:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbhI0VJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 17:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236743AbhI0VJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 17:09:10 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF71C061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 14:07:32 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id n18so18929018pgm.12
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 14:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=jL9gs8PyRni5gQOtA/dx+AbE2fvFgmsIAtXLbtPXF8I=;
        b=IwFuPDXW25Bx12sV91oBJ6bK3Gw+eH4OfwaIVvxSYH70lH4V0DyYtnrSYSwiwRX/LU
         6J42Ok038QVd2rdphpoTkHIcpPtDRF8+1AJ2B44jZ7X2vowMQlKrieu+xy6AIwwtngt7
         w+rz8CFDwXPcmMxw3b4/h2nAGV8ta49t46dWMh4JCW7NoKT+iCRsxpQZv7qoYwVhgXAD
         LzFMih9jesoIv4RS0Uu6l4Ehnf52A/FBheDDL/HsmBKslnJGSinzfv+txbzujtBfF6ex
         f9iDbYQKaCnRuw1dmvts3qHIEYc67X2dQwhcHJX4wX6jLKxbGtUJjUv09hmQYIZ8NUc8
         xnUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jL9gs8PyRni5gQOtA/dx+AbE2fvFgmsIAtXLbtPXF8I=;
        b=uvezKwwODrlxbulU34TuGnvHJJlL+0FotmtGDSZs2U3QdRr2WywTyghU4bBoLkFimy
         vgDpThHVGcGKPTd6d24H23xKlA1VOzZkXEgXhse4A8iB15RycrmQr/HJHdqFXYKh/VLa
         OdpVZAimz58mQSjKCyrSkps7o4LxAHtJWUZN+vhW7boDN1mkF5xFZwJEqewb/yHbjjzs
         k9g12qa4mST+jkAG0O2sqA1hlMCuksPVSTEBnSFlyJnNrWgNzdg+qYCB4l9jdTCjyzbp
         8vEKU3fno8hXI83WHZIO0X6pbYS+cvZi5t83Mxg46q0v1GHJUmGcKpaAoE7j0f1PCwJB
         lafw==
X-Gm-Message-State: AOAM5302mNvWRmhbwTS2u1+igAs8ifCHLalskOTizXNKFsUa1yfT0kww
        BHjdDcwQM+sUb9wkKW/PQL0BMC0hW5bikg==
X-Google-Smtp-Source: ABdhPJzzz/9SLYb3Cyc4QcIitv1nHwxCpCH1pnBs4Gkh4neJIcuhRNVTTwdGy9YlvU5qWNYu1SOz4g==
X-Received: by 2002:a63:df49:: with SMTP id h9mr1452176pgj.198.1632776851621;
        Mon, 27 Sep 2021 14:07:31 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id x7sm18609406pfc.71.2021.09.27.14.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 14:07:31 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: fix gathering of debug stats
Date:   Mon, 27 Sep 2021 14:07:18 -0700
Message-Id: <20210927210718.56769-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't print stats for which we haven't reserved space as it can
cause nasty memory bashing and related bad behaviors.

Fixes: aa620993b1e5 ("ionic: pull per-q stats work out of queue loops")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_stats.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index 58a854666c62..c14de5fcedea 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -380,15 +380,6 @@ static void ionic_sw_stats_get_txq_values(struct ionic_lif *lif, u64 **buf,
 					  &ionic_dbg_intr_stats_desc[i]);
 		(*buf)++;
 	}
-	for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
-		**buf = IONIC_READ_STAT64(&txqcq->napi_stats,
-					  &ionic_dbg_napi_stats_desc[i]);
-		(*buf)++;
-	}
-	for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
-		**buf = txqcq->napi_stats.work_done_cntr[i];
-		(*buf)++;
-	}
 	for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++) {
 		**buf = txstats->sg_cntr[i];
 		(*buf)++;
-- 
2.17.1


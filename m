Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624C82E3382
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 02:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgL1BrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 20:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgL1BrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 20:47:10 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15037C061794;
        Sun, 27 Dec 2020 17:46:45 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n3so4216240pjm.1;
        Sun, 27 Dec 2020 17:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=M7WvI72wl4WUEMHOhb+lrKhfdYvvrF6GMV1dg1VMpQc=;
        b=d27FTPDqa40m8Gq0jAM0JQ21hyBIelFtGhpLuyYUu3Un4u30e5R7gBFiCVfb0n0E/N
         +3lw67S6Ztfi5pDuQjaB5MeLNnidR1bUWtX9bWln+Q1yH+5yo9DlKhKiVMr+Tsy4GhIP
         f4O7RwPnp2We+Iq38rrpr5A4Njo/R2DnYNAl/HOWKqhXN90xnmpDHpH0n0t9ponbKZSk
         tQsZpX517b2fNx5vYUgQOM47Z1HJO2TVd5K0N57KHQcY1U/SQ/e96l4WI44ft9bkOJ7u
         Qmtl1qA8O8wMYkA136FfPp+9DmxPOANrs1KJNUGVPPxovMB/Y+xuVCpR980uKMIpP8/v
         rpJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=M7WvI72wl4WUEMHOhb+lrKhfdYvvrF6GMV1dg1VMpQc=;
        b=ttuiDI2WwYPc1gzqy6tnaWr8z9jCnn+gNy0q0baG9Q8fPseUKHUWgn7zF+5mRdjWlN
         MICzXzZi9t413SQdKbiNVKrwzEVHpSmDgZKqAXorvhZoWLjc4ZEAlrg3osiNdEhK8/Ue
         Hz5x8r5R3eKw51LI1hzyufipBlPH4xqAg4Ibwlex2tOWrAa73EP6qVjRb2eNUYbNfpX4
         /FZ3q32kiBv5hvMZj/ky71LR3pSCbgMIVMPOHe/0EYOk8Iu26mICxJDUhroxRA9gXMVC
         Xs1cu6dccEZZ8/IoaJoZi3WVjuGxGsUyIVPoEcbYbQYrbtq5CBxeLEwbcT5OdrpBxEP/
         XAEA==
X-Gm-Message-State: AOAM530GQhPeD41z09wVk9rYJVJMo4PJZFZcNIrEJCvfZFN3UMynLkYu
        NPel6rTymdUqZxIZdFVQPgA=
X-Google-Smtp-Source: ABdhPJzXnMa13lXrovP0yhARfbP6Y1l2a0JaHzpYO7B2/f2mEt/w9mo26TYEkenv4zix1BXI+y65cA==
X-Received: by 2002:a17:90a:1bc7:: with SMTP id r7mr19379497pjr.33.1609120004569;
        Sun, 27 Dec 2020 17:46:44 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id q4sm10145896pgr.39.2020.12.27.17.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 17:46:43 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next] net: nfc: nci: Change the NCI close sequence
Date:   Mon, 28 Dec 2020 10:46:31 +0900
Message-Id: <20201228014631.5557-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Change the NCI close sequence because the NCI Command timer should be
deleted after flushing the NCI command work queue.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 net/nfc/nci/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index e64727e1a72f..79bebf4b0796 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -579,11 +579,11 @@ static int nci_close_device(struct nci_dev *ndev)
 
 	clear_bit(NCI_INIT, &ndev->flags);
 
-	del_timer_sync(&ndev->cmd_timer);
-
 	/* Flush cmd wq */
 	flush_workqueue(ndev->cmd_wq);
 
+	del_timer_sync(&ndev->cmd_timer);
+
 	/* Clear flags */
 	ndev->flags = 0;
 
-- 
2.17.1


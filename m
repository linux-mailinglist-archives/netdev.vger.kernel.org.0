Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CB54989A8
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242475AbiAXS5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344565AbiAXSys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:48 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2663CC06135B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:41 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id c3so16654835pls.5
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G+QrDu8pRdRC9MbHC3CaoWKFwfJNJuGA8iAzraMDrGg=;
        b=v+x0QPoWKJGB9YoyU2Ht9fvUvmvUEPkM/B6p12XSuPmJTtOBIx5KaJky6UddP3wyml
         k5KVwoOuJNUoSKKkxG63hOTIuqhlZUkBxTXHk3yDwW/nm7m1DWRejJg9qoiQoczQYQiC
         Ay3uLpS/6TVI0nU8s7L+IWqOn0CiTqMDDwt0jNvis22OULRyVq1onSNZTLz3TcC/PLrC
         jhCvz482oBIWryYNddPWNhv2EuUtf7643xNO206imMWOBV7MH2ZsaIhqdvAE7u0Cxvcj
         4xROm/e8qxKDovPI0NX9EscTrmzJUW/rVXq5QiB/PCwx4KJHT+1WuWs6rtgaaTXVwL+0
         FbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G+QrDu8pRdRC9MbHC3CaoWKFwfJNJuGA8iAzraMDrGg=;
        b=lvoWWHkXun49+vXH4f2Mh2KFCa5DPlaYv4mQr6hGAQ+IWYXUVasBQWQSIXKKbYBIFa
         UgynOe4d/KeD/kCH1IW4hWRGly15DpjT1omwjzLg0Piu7Z2Zu+ES/hIsZEvnPiO1BKu8
         x/QJ3myjE2dOQoL8KDfN5AtspmjiggZnlLFvTihwntO4ZdtQwSYMwiQ+fgR4MeirGgOs
         lP62DkB6laR8MdJHtGzw7k8Clv1d0WoZdrCi4/mLZTjxB2Yd0TdTVPCgF1pTmN1TjzpL
         GtNqTfqktyHXIJt6v3oS3nt54EtkNU/R59mvfC0mFGcJ6zuwoQGkVdaOnVgDp0Zl6Vte
         s7Fg==
X-Gm-Message-State: AOAM531+tMRxJ/GqhG0310ywHBA3SX1PtKQmcerJRtFEFtmsMgc5eZ2w
        Ll5vE6TzUP0qdxKZ5/tHa1JYFw==
X-Google-Smtp-Source: ABdhPJwT82ZGRukHhKFrN3fsZEK2q2PMldOQojx6oIfP6C7p5fSpJ9vcUViI6oTTyd1d7HTy/k6GNg==
X-Received: by 2002:a17:90a:77c6:: with SMTP id e6mr3262385pjs.115.1643050420701;
        Mon, 24 Jan 2022 10:53:40 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:40 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Brett Creeley <brett@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 13/16] ionic: disable napi when ionic_lif_init() fails
Date:   Mon, 24 Jan 2022 10:53:09 -0800
Message-Id: <20220124185312.72646-14-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett@pensando.io>

When the driver is going through reset, it will eventually call
ionic_lif_init(), which does a lot of re-initialization. One
of the re-initialization steps is to setup the adminq and
enable napi for it.  If something breaks after this point
we can end up with a kernel NULL pointer dereference through
ionic_adminq_napi.

Fix this by making sure to call napi_disable() in the cleanup
path of ionic_lif_init().  This forces any pending napi contexts
to finish and prevents them from being recalled before deleting
the napi context.

Fixes: 77ceb68e29cc ("ionic: Add notifyq support")
Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index adee1b129e92..c9535f4863ba 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3266,6 +3266,7 @@ int ionic_lif_init(struct ionic_lif *lif)
 	return 0;
 
 err_out_notifyq_deinit:
+	napi_disable(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 err_out_adminq_deinit:
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
-- 
2.17.1


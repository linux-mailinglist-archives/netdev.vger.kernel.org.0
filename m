Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CC62460ED
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgHQIqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728210AbgHQIql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:46:41 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC4CC061388;
        Mon, 17 Aug 2020 01:46:41 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m34so7780539pgl.11;
        Mon, 17 Aug 2020 01:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JsoJWF3qfQafSSNV5K67N8ZQJjFS6LyMxgQTIoIwZ4E=;
        b=sXcISvazjIO8ysa6wN18Wo42/doFu1SWVrQIRBDsICBHprjam5Q7LSkx2t6FPfTYdA
         JCk1QifejB5MbeZ1oa2Qp1wnrNTVZRV6PpQ8ArwmvyPI2+zR3yPjKxV8KS6RX1+ILNoe
         +D8SLjteJo4+YgF9fj7Wm8KEDfAdRv32m2y+zC4/jZU6pF+fyFsHAaz6bwxBqubZ+OzG
         gCCovtVpk4aL1X93xNPh96R6dMeh/TEFQrO5SNOrySeSAkJnHpYfxUl6XeQPuFDN8VOy
         SGFjN5XVMtRO7LnGNuzYNWtZs+Ah7mqUkKH7xcT1ASqwkYlUFb2ZGLS6hhwzRtbW2qM+
         Z2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JsoJWF3qfQafSSNV5K67N8ZQJjFS6LyMxgQTIoIwZ4E=;
        b=ehNdY03S/d8XPZDGXdDrzJR5K4POBEBc+3NyLuOt5mDELeKLEDL3h11OXe2pIqtez8
         P2IrTysaiLBTKveKZx/IKwzDgQIPGqtIM4NL1EDQOnHYOhKFQYfHu0zub/WBs0e3Ga9e
         JvE2TY87uB46alIvRM17NKdvqS2UJNHlb2upTWHhBLinuGP2M3Ufauk32IkquOwLuHzQ
         RdqJKWAowuWU5DQLKCX7wA6cjStcIO9ou9eEP87YVP54NVIbUtmn9wBsILqZzmiTycCX
         EZUsqbj0v5/iqMeaJE/Sd+X6gHmS8CsiKjHv4X9Ynk66kgczGPxhfQf+Cgj4VEB8vRB9
         Supw==
X-Gm-Message-State: AOAM533W7asCJGzdt+3t1eTvu8HvSF2Ek3F2J7xis2GhMR7LBW/RgOTm
        f3g9UsXR7enEfD9UPeL2PPQ=
X-Google-Smtp-Source: ABdhPJy0MvpSNtO+I2gcioLWEGSx0tcxCwFQB4BUoUp21BIAH7ttx+k10WJWbsMrhWUXmwiFNe72HQ==
X-Received: by 2002:a62:144b:: with SMTP id 72mr10485247pfu.111.1597654001358;
        Mon, 17 Aug 2020 01:46:41 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:46:40 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Romain Perier <romain.perier@viveris.fr>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH] net: mvpp2: Prepare to use the new tasklet API
Date:   Mon, 17 Aug 2020 14:16:05 +0530
Message-Id: <20200817084614.24263-4-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817084614.24263-1-allen.cryptic@gmail.com>
References: <20200817084614.24263-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Romain Perier <romain.perier@viveris.fr>

The future tasklet API will no longer allow to pass an arbitrary
"unsigned long" data parameter. The tasklet data structure will need to
be embedded into a data structure that will be retrieved from the tasklet
handler. Currently, there are no ways to retrieve the "struct mvpp2_port
*" from a given "struct mvpp2_port_pcpu *". This commit adds a new field
to get the address of the main port for each pcpu context.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 32753cc771bf..198860a4527d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -861,6 +861,7 @@ struct mvpp2_port_pcpu {
 	struct hrtimer tx_done_timer;
 	struct net_device *dev;
 	bool timer_scheduled;
+	struct mvpp2_port *port;
 };
 
 struct mvpp2_queue_vector {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 2a8a5842eaef..fb45f86dcb12 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6025,6 +6025,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		err = -ENOMEM;
 		goto err_free_txq_pcpu;
 	}
+	port->pcpu->port = port;
 
 	if (!port->has_tx_irqs) {
 		for (thread = 0; thread < priv->nthreads; thread++) {
-- 
2.17.1


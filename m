Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01606187819
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 04:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgCQDW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 23:22:28 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39434 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgCQDW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 23:22:26 -0400
Received: by mail-pf1-f195.google.com with SMTP id d25so3122008pfn.6
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 20:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aOHArtyyCSR0pXyrFJ4sZvmpPZLW125U9f5d+4rorm8=;
        b=EKkax2XmuRPJ9adHOJHkAW4BXlATkfvI4j4mkRxOCi/gcvxIwzc6GNPWgo5PekmJXA
         yWouwlv96YO8RZcroQh1tC9/OgKzfuJwrISz62kuMrlfcV09aAUWYIqI6evlHAJlo2y7
         EAq8ERrdgXukewT1xkUIhfDKli+UFbn9DzfpFBkMPWidSEZAymbNR8tdtgxX9cSOHrpD
         +IYgl7LJbXZKS/q1O1I2yWAnjMwUnIZQ7o/EcH31fCx971HVs7pzR5aztWNisg84iArA
         c5yl3TEHSWs04DwXFTYl8ivMxG6ixAXM3IcPolmb/mXsLEmDqMPPdfqZNEryRleKMMZi
         jXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aOHArtyyCSR0pXyrFJ4sZvmpPZLW125U9f5d+4rorm8=;
        b=mIlKFIOo9tJmqSzc0+b9KEWLbVA0eNvJFxXqaX67cqk/afd8X6k7RIwCWbRiVeHvu8
         CtY8RPruvMBMcMEuSLQ3dROkgt8GA9MmcwpNJ2/sMJDqagewvMtDaJWqDfjK6PXDXq5m
         O4Jqyb/+qouSvv/m+s6wCGUOHpItgaDWCrCEyHUjZDtPy9+IDes/d97ts7k1jYAjdwBj
         G2hsv4TyqMsadGIDXb4u3nNwQQk6Bii3ZErJ6KZOxebCj29F8z4yj/8nGEBxYINi/MhL
         BWRz2SPnogfnjWTC8ILAHEngdFRpBUzRR/QMLNyNFQnmX9v+84BDSE7DbjRGKk/RvCy7
         8oCA==
X-Gm-Message-State: ANhLgQ3RiNMsL1hsqN5Gsc3CjosskC+zc6uXvg+iHJ4Atrc9kih2rmle
        ksamk0O7ykEWuBICOsto+WZcexFFPes=
X-Google-Smtp-Source: ADFU+vuVz6TkyGYc+ljBTywpn07d3f/uYdFFhNDK8muxMY1WXTdiXQmUeBt9aYwBreSWbcgdfCNO4Q==
X-Received: by 2002:a63:3712:: with SMTP id e18mr2705835pga.401.1584415345333;
        Mon, 16 Mar 2020 20:22:25 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f8sm1185639pfq.178.2020.03.16.20.22.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 20:22:24 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 2/5] ionic: deinit rss only if selected
Date:   Mon, 16 Mar 2020 20:22:07 -0700
Message-Id: <20200317032210.7996-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317032210.7996-1-snelson@pensando.io>
References: <20200317032210.7996-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't bother de-initing RSS if it wasn't selected.

Fixes: aa3198819bea ("ionic: Add RSS support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index b903016193df..19fd7cc36f28 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2066,7 +2066,8 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 	clear_bit(IONIC_LIF_F_INITED, lif->state);
 
 	ionic_rx_filters_deinit(lif);
-	ionic_lif_rss_deinit(lif);
+	if (lif->netdev->features & NETIF_F_RXHASH)
+		ionic_lif_rss_deinit(lif);
 
 	napi_disable(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
-- 
2.17.1


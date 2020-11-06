Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD422A8B2C
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732656AbgKFAMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732727AbgKFAMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 19:12:39 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966DDC0613D2
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 16:12:39 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t14so2551650pgg.1
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 16:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vtqZ54Xnh7Hf162UYOKk1fQAxTBQbfeuc5lOS2wJEnc=;
        b=l1F18genOzu5ESIlpYkQRjLTpiN09IZ+mMRcTkpRSeBl0titZWnVHN/ohIzeCWfV5/
         wESTR8E128NTRW2Um4aF7qC8s+DVKltn8e9irN1zZi34xg8RvtczYfADJTWe0phsNPFU
         OyXLz9LbjR5c8FeiYnCxG5b8tPwykTxvP+BJNIWJzXEYRQQFzuVi3nIEGZxQGbP1fUcT
         97nl91pKr/3pZY4IquQoMPurqVTQAfy/EC//InzwLBikXtY4sjOEurSGGD7k0h2cjT1J
         At1eBuI74f5UUdSCCKSnsMDPDYoosbUoNQq1Muy/tCx44Awak9B03uqocf2N9vH4OOhg
         bP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vtqZ54Xnh7Hf162UYOKk1fQAxTBQbfeuc5lOS2wJEnc=;
        b=jgMVcg/6rbs1MatdYUzTLHZVes1D8EtRRCvVFGadu8PTdioqgK4Oa/93K5gxjCBPef
         4YrKuciCj9nsk5rTJh+nIxBKLproFel9fdDflMyjynMhXcjCxFLdldGPdot5mebh3Mr4
         RQO5SV6jXEo+aLogS3Z/NfU2x0YE0GGxxM1uloO1txfH2z4FcpobK4nPvDlPxFgBbFKE
         FLVuBZDLEbGnYuZ48hGtErawpfUgIX16o1XCj+Axu4ko61ZV8EZLq9LdC6LrKFJCnRgy
         WuRDsBFANkwR8nYO1/+F7zC6W5EedU2vKyfGsYdzUHK68K/n6qrr8Tt6jOSy0f0x2fgd
         vELA==
X-Gm-Message-State: AOAM532PmryjJjhaGWwT+3qxSeBTreZWnFHQFTmFWvPcMlLYw6VaK6RU
        Ard6e9KX2/Zg2ZuRhFCmyu7dE1pkQm4b1A==
X-Google-Smtp-Source: ABdhPJzvstcLbWO3MZLp2y5XzrdwLxM4j2HMHhKBKzYYp/f147hscWDbq6eIFhSGYQcrHgKOi5XGUQ==
X-Received: by 2002:a17:90b:ecf:: with SMTP id gz15mr344705pjb.152.1604621558914;
        Thu, 05 Nov 2020 16:12:38 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 22sm3236009pjb.40.2020.11.05.16.12.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 16:12:38 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 6/8] ionic: flatten calls to ionic_lif_rx_mode
Date:   Thu,  5 Nov 2020 16:12:18 -0800
Message-Id: <20201106001220.68130-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106001220.68130-1-snelson@pensando.io>
References: <20201106001220.68130-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The _ionic_lif_rx_mode() is only used once and really doesn't
need to be broken out.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 38 ++++++++-----------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index a0d26fe4cbc3..ef092ee33e59 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1129,29 +1129,10 @@ static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
 		lif->rx_mode = rx_mode;
 }
 
-static void _ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode,
-			       bool from_ndo)
-{
-	struct ionic_deferred_work *work;
-
-	if (from_ndo) {
-		work = kzalloc(sizeof(*work), GFP_ATOMIC);
-		if (!work) {
-			netdev_err(lif->netdev, "%s OOM\n", __func__);
-			return;
-		}
-		work->type = IONIC_DW_TYPE_RX_MODE;
-		work->rx_mode = rx_mode;
-		netdev_dbg(lif->netdev, "deferred: rx_mode\n");
-		ionic_lif_deferred_enqueue(&lif->deferred, work);
-	} else {
-		ionic_lif_rx_mode(lif, rx_mode);
-	}
-}
-
 static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_deferred_work *work;
 	unsigned int nfilters;
 	unsigned int rx_mode;
 
@@ -1197,8 +1178,21 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 			rx_mode &= ~IONIC_RX_MODE_F_ALLMULTI;
 	}
 
-	if (lif->rx_mode != rx_mode)
-		_ionic_lif_rx_mode(lif, rx_mode, from_ndo);
+	if (lif->rx_mode != rx_mode) {
+		if (from_ndo) {
+			work = kzalloc(sizeof(*work), GFP_ATOMIC);
+			if (!work) {
+				netdev_err(lif->netdev, "%s OOM\n", __func__);
+				return;
+			}
+			work->type = IONIC_DW_TYPE_RX_MODE;
+			work->rx_mode = rx_mode;
+			netdev_dbg(lif->netdev, "deferred: rx_mode\n");
+			ionic_lif_deferred_enqueue(&lif->deferred, work);
+		} else {
+			ionic_lif_rx_mode(lif, rx_mode);
+		}
+	}
 }
 
 static void ionic_ndo_set_rx_mode(struct net_device *netdev)
-- 
2.17.1


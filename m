Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40EE2B0C7C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgKLSWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgKLSWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:22:24 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D362CC0613D6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:23 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id a18so5318276pfl.3
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MeBoxtiy7UQQAtKqXbJb0p281xYuzD0efEauVvi9iEw=;
        b=aWG4VCwv/7lKtHb3lkplRHzJ8e3uISL+ESOfryNjBVlgAcHsSrnxFjxpwWgiDJugor
         /UZB1wjcgCDmMANGJKb6VKaaFUg8nkeF0KBRMPa8WnM7e9Ny0UGJMVOhrrPeE0L+SGsK
         IyDqXcMbOCs1/uo1tfR/AvmFpLXWPlX2ahdRE++jbaAgTyW0VDNg733lu6mQdhwKBMd7
         7ZNqEJxZJxnXfhmEX1nrWAiNZ7krdG9BA8SSZVj6RuFS+avC2QNLw4pdG6rbiHGrtSQs
         0NpVEmH7UMpH803q76LKoEzv092kQvlFOK31GSt51o3EkQRuTqklJZQSvIOrxccO6t4G
         /88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MeBoxtiy7UQQAtKqXbJb0p281xYuzD0efEauVvi9iEw=;
        b=GU2BzRc/KOTb0h1DA/xXn8BjeX5p4Tp7bYjAhZwsY0XtfZN4WAsg1sLOFn+1gW+uS0
         tTGsc3I3Dj7XkwA6A2TjoaLyDEYOYHT0X6/hk9wLwdC+D4vmBPG7+rKfRMK3OLmWsTwp
         0FWbjb1+N70utdJKakVJXxTzhD1WA8sA6Bj9zukp7qeMMRFNQOcWx2KhEtGbNXoWmpiz
         R9Eyq5SEHaKHHwRf2GgV17yhBMCR+HI6eNI0BL00v/QrLq/6tUshSiCZaM9L2JVAve/e
         uL41AzUuQ2CbGR0KGbq7THHHW7kmbqhkFLIF50M4JIYG7OfAXFJ/7kzhwTpMTP+0yqUk
         2bVA==
X-Gm-Message-State: AOAM531HaHrW5uFXJ1ADGBBvaYHsin8pefiELMpzF0S68e/GbCTx5OVN
        ZE0cL/pOnAKcSl25k7mkn6ne6w5ET4QlDA==
X-Google-Smtp-Source: ABdhPJwGUETmeBtKzzmtr7vYU3lEouyxrgFbMbem/+EdrQbCEPciNl/mfhLVF+IqCki9BhAMU/lUHg==
X-Received: by 2002:a63:4f26:: with SMTP id d38mr671738pgb.220.1605205343187;
        Thu, 12 Nov 2020 10:22:23 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id m6sm7152292pfa.61.2020.11.12.10.22.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2020 10:22:22 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 6/8] ionic: flatten calls to ionic_lif_rx_mode
Date:   Thu, 12 Nov 2020 10:22:06 -0800
Message-Id: <20201112182208.46770-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201112182208.46770-1-snelson@pensando.io>
References: <20201112182208.46770-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The _ionic_lif_rx_mode() is only used once and really doesn't
need to be broken out.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 38 ++++++++-----------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 13c7ac904611..58bf6e9314bb 100644
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


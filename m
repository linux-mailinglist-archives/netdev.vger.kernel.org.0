Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894A41A2708
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 18:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbgDHQT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 12:19:28 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45598 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgDHQT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 12:19:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id 128so917046pge.12
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 09:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WZXZU3gRx+dsdrniJKIuh1ypsevLSlIAVOQSYlzkJf4=;
        b=eBvlTQiVG1Eywd5AqtTYW+SLITHmENhe9am4oczingYB58jBLaK1rTRfiQuPxADz0x
         zHz1clvTp1U3hAKEz6B9kN8hO3oLfT6tt8G6XynxoWHT4kEjn8DgOJdw5snrzpZQ+Tzy
         NHyWgVT1cyV32eErQo7qGKd+JX/fvyWgOPZZPrVZypy0av1ltfEF9Z4C4tuPcRikyPto
         z/0QQeP3FpXGlMfwuUDqDPjC+4rYSPvAkmnp5k3zCzMMEn2/Spa52seFvls2oGMjekYx
         fg1tH9Sw5nghuo/u9UMGh5L4nI+d8FApef+zbixA3aIIPFH6uq2E5uqrr/CsroTpRuDG
         mK6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WZXZU3gRx+dsdrniJKIuh1ypsevLSlIAVOQSYlzkJf4=;
        b=jUGEzJ7RIOLa4+j0Uu6DQpsIsZvIybgAT0b9fr35ZouZz2w88Ulo1kHNV7yLNs3zQt
         HQLL/g7ERq9oeN91trqdu9A/gvx8sFHtP6Qydo+q9NAAl0MruMQdn7qBkR/F7cHST1or
         ImNTp4Hm5f0RvHMHhAW6hrc1g8ZUttTxOWyzoAvRqZ1dRTzsDGKN8QwmbseRlgBudtih
         XAfVoEvy/wX/BOB8In+EU3Tj/kUnIPytmlzP8zWcLcdUWVbSRvAUFw85GS9rR3nHWph8
         4IOZD3Uhaeikud/OvXrZBOz+OhGjEIElvM/qXDKV0nynhbe5hE6O2CkQvsn2/NpQnyjb
         NrMg==
X-Gm-Message-State: AGi0PuaqoXKs7+yYaYlSwDfK9Mw8WDYltATMVbKQAzztiI6vxSWjBeT4
        tQpCTqqilgChBPnBstmYkVEqYAazu3Q=
X-Google-Smtp-Source: APiQypJEgs3EuHxPzy6K+Pdq/53WiIx56OwFIV20XlOfDvytT2XrDn9SomKK8GG1xja9/IB+vwP+Sw==
X-Received: by 2002:a63:c149:: with SMTP id p9mr7506959pgi.389.1586362765711;
        Wed, 08 Apr 2020 09:19:25 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s12sm16021693pgi.38.2020.04.08.09.19.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Apr 2020 09:19:24 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 2/2] ionic: set station addr only if needed
Date:   Wed,  8 Apr 2020 09:19:12 -0700
Message-Id: <20200408161912.17153-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200408161912.17153-1-snelson@pensando.io>
References: <20200408161912.17153-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code was working too hard and in some cases was trying to
delete filters that weren't there, generating a potentially
misleading error message.
    IONIC_CMD_RX_FILTER_DEL (32) failed: IONIC_RC_ENOENT (-2)

Fixes: 2a654540be10 ("ionic: Add Rx filter and rx_mode ndo support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 32 +++++++++++--------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index f8f437aec027..5acf4f46c268 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2341,24 +2341,30 @@ static int ionic_station_set(struct ionic_lif *lif)
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
 		return err;
-
+	netdev_dbg(lif->netdev, "found initial MAC addr %pM\n",
+		   ctx.comp.lif_getattr.mac);
 	if (is_zero_ether_addr(ctx.comp.lif_getattr.mac))
 		return 0;
 
-	memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
-	addr.sa_family = AF_INET;
-	err = eth_prepare_mac_addr_change(netdev, &addr);
-	if (err) {
-		netdev_warn(lif->netdev, "ignoring bad MAC addr from NIC %pM - err %d\n",
-			    addr.sa_data, err);
-		return 0;
-	}
+	if (!ether_addr_equal(ctx.comp.lif_getattr.mac, netdev->dev_addr)) {
+		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
+		addr.sa_family = AF_INET;
+		err = eth_prepare_mac_addr_change(netdev, &addr);
+		if (err) {
+			netdev_warn(lif->netdev, "ignoring bad MAC addr from NIC %pM - err %d\n",
+				    addr.sa_data, err);
+			return 0;
+		}
 
-	netdev_dbg(lif->netdev, "deleting station MAC addr %pM\n",
-		   netdev->dev_addr);
-	ionic_lif_addr(lif, netdev->dev_addr, false);
+		if (!is_zero_ether_addr(netdev->dev_addr)) {
+			netdev_dbg(lif->netdev, "deleting station MAC addr %pM\n",
+				   netdev->dev_addr);
+			ionic_lif_addr(lif, netdev->dev_addr, false);
+		}
+
+		eth_commit_mac_addr_change(netdev, &addr);
+	}
 
-	eth_commit_mac_addr_change(netdev, &addr);
 	netdev_dbg(lif->netdev, "adding station MAC addr %pM\n",
 		   netdev->dev_addr);
 	ionic_lif_addr(lif, netdev->dev_addr, true);
-- 
2.17.1


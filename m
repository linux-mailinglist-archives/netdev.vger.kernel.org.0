Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A7B1FFA3D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732304AbgFRR3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732180AbgFRR3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 13:29:13 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD84C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 10:29:14 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u8so2832252pje.4
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 10:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=+TTzVy8a4tz/Ds9ckU3vgXiIdDOLS+utRDmIwAmwlXo=;
        b=w9nE8krZTJXtLKn/J0Jo0Qjj/lfV/sbUsnHfxYbUW1AwphQSoPoS3WT4A59MS1YkGM
         Ko5IAihaNEcSkpuJ2Q+E04m68CKwCWN2OYOZTSw/qvX02+vxaf7OI/2/K2wrUI18e6Tx
         zlr2VcGOdl2jw1G8D/Gj0Wa9/POes8IP7+kMItAH6nbcZ2ZjcLCq+Yc6Qn16TsQ+qUvM
         uzU2Bj0VmdS1KiP8JhXxrM9QZNXXHOUtIvvCJh0eFgVYpHyDqqrIW5qLzFzYxyNQuz/i
         naJKimYn57kyAIUO0r4tZJBMFIcppBsh7Dtwm5G1i1N5CIdUpyQGot0lTUy6i7OwKbA/
         EmUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+TTzVy8a4tz/Ds9ckU3vgXiIdDOLS+utRDmIwAmwlXo=;
        b=DyowBGeDA35gB+nEy7DECmionGtK4RDbSbApQ+DeVicOQs/vVqxURS0wD3Kh0uifue
         1XzhxIxcO4OjOMC7wPqCJXni8n+Vl2sz/jLTP6s+HQeTvwvynDhFX02Ehy05G6S2zeRk
         b2AzeYIdcGN30maAyolYxrfHwtjeUzj40YqES3JG6/ZW8TpCNYYp8AfaTqK54Zf/TZki
         TtX5aoaGtjAytIk6RH2foLL4rPw4+OsSjozZ5BMtuLwsDMx4cO3WrHMsBxzzHHVXPh3w
         rS6yOcX65rofmS1IkK4At06JnM8eafG0jxhdu9AZK2IGI9D5gLe3dE8EuU5hCnDgwGXE
         LjGA==
X-Gm-Message-State: AOAM533sgPDqScWd9Nz0nDAHSEiCv3Nk7HPda+jR5TU3J4SOoXNFP4qk
        NJ7RE1wwNrw1gKRnMyqGB3Jh1w1eUvZUqA==
X-Google-Smtp-Source: ABdhPJxCtsVl3Uh2INF7UEWSzqYFusLKeBR6/EmoFWI5eCdTE51TaNYF+AX7xnpjw/NHOSMRM5mJFg==
X-Received: by 2002:a17:90a:d3d6:: with SMTP id d22mr5252293pjw.184.1592501352486;
        Thu, 18 Jun 2020 10:29:12 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s188sm3352921pfb.118.2020.06.18.10.29.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jun 2020 10:29:11 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: tame the watchdog timer on reconfig
Date:   Thu, 18 Jun 2020 10:29:04 -0700
Message-Id: <20200618172904.53814-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even with moving netif_tx_disable() to an earlier point when
taking down the queues for a reconfiguration, we still end
up with the occasional netdev watchdog Tx Timeout complaint.
The old method of using netif_trans_update() works fine for
queue 0, but has no effect on the remaining queues.  Using
netif_device_detach() allows us to signal to the watchdog to
ignore us for the moment.

Fixes: beead698b173 ("ionic: Add the basic NDO callbacks for netdev support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 8f29ef133743..aaa00edd9d5b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1694,15 +1694,15 @@ static void ionic_stop_queues(struct ionic_lif *lif)
 	if (!test_and_clear_bit(IONIC_LIF_F_UP, lif->state))
 		return;
 
-	ionic_txrx_disable(lif);
 	netif_tx_disable(lif->netdev);
+	ionic_txrx_disable(lif);
 }
 
 int ionic_stop(struct net_device *netdev)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
-	if (!netif_device_present(netdev))
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
 		return 0;
 
 	ionic_stop_queues(lif);
@@ -1985,18 +1985,19 @@ int ionic_reset_queues(struct ionic_lif *lif)
 	bool running;
 	int err = 0;
 
-	/* Put off the next watchdog timeout */
-	netif_trans_update(lif->netdev);
-
 	err = ionic_wait_for_bit(lif, IONIC_LIF_F_QUEUE_RESET);
 	if (err)
 		return err;
 
 	running = netif_running(lif->netdev);
-	if (running)
+	if (running) {
+		netif_device_detach(lif->netdev);
 		err = ionic_stop(lif->netdev);
-	if (!err && running)
+	}
+	if (!err && running) {
 		ionic_open(lif->netdev);
+		netif_device_attach(lif->netdev);
+	}
 
 	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
 
-- 
2.17.1


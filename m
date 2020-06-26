Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD6820ABFE
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 07:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgFZF6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 01:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgFZF6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 01:58:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A01AC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 22:58:46 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id l6so1459379pjq.1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 22:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=mtNHl6c4gNx+zusOC189/QTDNwkLZ35OEepzblXlze8=;
        b=T6lLxOADS5T4CgiV+T086BZSNZQ0mhppZoqeI+eqiRNbvA36zQGcnThCrqCtEMoPuP
         b3DaITkoV8uMDA33I5UP37yHSOc0uucR9L2O4ogv8qjKTiuCWJ6YCsbt7PASNdix+tcZ
         cJnamm789bAEwh2GS1Srxo6dtKKEybVV2kThIMESmaUMB21dIEEPB7FfR71vnH7wDXL+
         OPVuz/W/di2Nf2kzdTxUep5FGuK3Q9JFXHR8+H3x/zCQQ/HfLud6BR54tICTm7Ka+Y2m
         gr04lgS/nypA8mF/N0/2/4DWHbsZ/Wk3jeip0UCnHAX247Mq5X9CBJEDHJ6g5PT4xMfw
         pT/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mtNHl6c4gNx+zusOC189/QTDNwkLZ35OEepzblXlze8=;
        b=lJACSnoiHnFfXQPfu9CJPXD+FsesKqda5J8/YjZIV3Dsy2a4qvjdU1MaVrgMZHH+Sl
         5YaImS/kVGcSBchY7qEAE3AtF3++CTwqdW//g/HuQVVU9Pf5X8dW5NL9lIHwi3tb7oFw
         w97/Zad/1x+ECq/FtaV/6VHeTqv2vW8YBdWkAHYW3f8vfS1oLjArmVOOPP5T8YNeN/Qo
         RoRlzmXRnpUpkQXgtGj4zkhJ0li8BUpsh8D/iNss5xIWeDIeEeUn8I+8eD6OXh0uUjXL
         3yY2MorZvzR0N0JNZRD71Tf4pC+VtbRratimJj8k76hlOBS8WTLMtgB0MsHr3I0KYo08
         U5EA==
X-Gm-Message-State: AOAM531KbYL2hueESfRML9vhxU5f+OwywxJajpwKcqHcDjFquz4xF5W9
        E2KSRYhoMY7a1WeOC86ZO8r67XNshFa9fQ==
X-Google-Smtp-Source: ABdhPJxHsVptyE7xSChHzmU2Kr62mSdz83KGYWDTgc7MU2yN9JWSknxMe3I7Poz4OvDksalyhZpBUQ==
X-Received: by 2002:a17:90b:1997:: with SMTP id mv23mr1685584pjb.194.1593151125694;
        Thu, 25 Jun 2020 22:58:45 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p189sm6963541pfb.217.2020.06.25.22.58.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jun 2020 22:58:45 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net] ionic: update the queue count on open
Date:   Thu, 25 Jun 2020 22:58:37 -0700
Message-Id: <20200626055837.3304-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the network stack know the real number of queues that
we are using.

v2: added error checking

Fixes: 49d3b493673a ("ionic: disable the queues on link down")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index aaa00edd9d5b..3c9dde31f3fa 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1673,6 +1673,14 @@ int ionic_open(struct net_device *netdev)
 	if (err)
 		goto err_out;
 
+	err = netif_set_real_num_tx_queues(netdev, lif->nxqs);
+	if (err)
+		goto err_txrx_deinit;
+
+	err = netif_set_real_num_rx_queues(netdev, lif->nxqs);
+	if (err)
+		goto err_txrx_deinit;
+
 	/* don't start the queues until we have link */
 	if (netif_carrier_ok(netdev)) {
 		err = ionic_start_queues(lif);
-- 
2.17.1


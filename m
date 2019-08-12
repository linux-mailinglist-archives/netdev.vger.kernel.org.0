Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34DA89707
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 07:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfHLF72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 01:59:28 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45055 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfHLF72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 01:59:28 -0400
Received: by mail-yb1-f195.google.com with SMTP id y21so1760951ybi.11;
        Sun, 11 Aug 2019 22:59:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=N6oSMRPpHGkQ7E+kK6e4vXB5ZZOBX+MrIVovGvsXigg=;
        b=IzzNYvEb8kl4xf3lmvM5GQCAsQXvIFOWUmV/0R/Ox4sOR6YrMw7ZChyK9K4/WDfXEB
         YUAG1nsD+HGryy3UHFh5aq7/fNcgtUw3aMKMA9MiTW4+R8mvCipMSB7K9M3Va5cBjaYe
         Ls51oAq+5HwH/FlkqgqA+ZsEW7n0U6M0ZJrd3cHFYY3XMTb0d6u9l8/l5zL+0Ms+XFQ/
         IYf5xEQ8+GHUFgwMGldjNgaOd4dAJ/MPK2SviD/xHMlqiBhwA+Ree4tBIYlwaMz8F3gA
         d+OEGX1x6xwqvqRhG3dftyei/pKopqLgKPzv2cFB9eO9wwXw/5EoeYeE1SGcnpCxxsjl
         oYyg==
X-Gm-Message-State: APjAAAUlr1dhzUGanSgqmoLib8PRiqqs4tbfA8mqskWnxUz55yTbyH8Z
        GuXiZZQCPCOveHOFk/ekx9U=
X-Google-Smtp-Source: APXvYqyH7bGaVBWLSU8sEzfL/N45LAWNBbDKUHxF98WHxf0lYev6I/BUIG/ZR/mT8bKm9nE2BGn1Zw==
X-Received: by 2002:a25:d794:: with SMTP id o142mr9107179ybg.384.1565589567579;
        Sun, 11 Aug 2019 22:59:27 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id e12sm24721471ywe.85.2019.08.11.22.59.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 11 Aug 2019 22:59:26 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] e1000: fix memory leaks
Date:   Mon, 12 Aug 2019 00:59:21 -0500
Message-Id: <1565589561-5910-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In e1000_set_ringparam(), 'tx_old' and 'rx_old' are not deallocated if
e1000_up() fails, leading to memory leaks. Refactor the code to fix this
issue.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index a410085..2e07ffa 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -607,6 +607,7 @@ static int e1000_set_ringparam(struct net_device *netdev,
 	for (i = 0; i < adapter->num_rx_queues; i++)
 		rxdr[i].count = rxdr->count;
 
+	err = 0;
 	if (netif_running(adapter->netdev)) {
 		/* Try to get new resources before deleting old */
 		err = e1000_setup_all_rx_resources(adapter);
@@ -627,14 +628,13 @@ static int e1000_set_ringparam(struct net_device *netdev,
 		adapter->rx_ring = rxdr;
 		adapter->tx_ring = txdr;
 		err = e1000_up(adapter);
-		if (err)
-			goto err_setup;
 	}
 	kfree(tx_old);
 	kfree(rx_old);
 
 	clear_bit(__E1000_RESETTING, &adapter->flags);
-	return 0;
+	return err;
+
 err_setup_tx:
 	e1000_free_all_rx_resources(adapter);
 err_setup_rx:
@@ -646,7 +646,6 @@ static int e1000_set_ringparam(struct net_device *netdev,
 err_alloc_tx:
 	if (netif_running(adapter->netdev))
 		e1000_up(adapter);
-err_setup:
 	clear_bit(__E1000_RESETTING, &adapter->flags);
 	return err;
 }
-- 
2.7.4


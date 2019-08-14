Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFCA8C58E
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 03:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfHNBdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 21:33:54 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:42296 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfHNBdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 21:33:54 -0400
Received: by mail-yb1-f195.google.com with SMTP id h8so1870047ybq.9;
        Tue, 13 Aug 2019 18:33:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7CuXXwlvBZ4dD2S3Pu/3bidV2iYvzmejPU7LB/4HQdo=;
        b=DtUa5u15Ar0hNUbBGQtp2qJt5ImBHG6LLRjtBtbZ1jJ5mJQeTeK+9BVTwKl2oTt86C
         E0HKbxU9MV5ji9UIrxfuBVNFxjj9J+Utucl136pTz1YM9lu78fbF4VVjD7Vo3H97WTTv
         0yo2yUITfSurEx68L6hRBsaKLLTSBytSHEVDbEWUBYGWGockEuRl9AdJPVQLHFbv672n
         DaT7jROI+P2LI/+71KY38IVyQFKOodJUM7OeoGRPmSUXxyADqND6E42Wi1/HKNwmmczC
         d6zqlR9XY5JS1E2rRtFojjybi7ZXaTM2TiYbW44LxOSKfuXXIh32xuUyH6WPlOu3s9BS
         bTYg==
X-Gm-Message-State: APjAAAVutFB/XtYEudk/glYDEKUHN9gGG6Iwxa2FV5jVARstHJ+urUML
        pxvDUMsieJWSyhdAV+asWT8=
X-Google-Smtp-Source: APXvYqy25a9R2H/+ARGmSHUJg7neMCJ+kuGpFwqGmkL3jNqijcUC1ov4CMwSPFL3AIlz5YYdLjZE2Q==
X-Received: by 2002:a25:e70c:: with SMTP id e12mr8541928ybh.133.1565746433326;
        Tue, 13 Aug 2019 18:33:53 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id l4sm23527919ywa.58.2019.08.13.18.33.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 13 Aug 2019 18:33:52 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: pch_gbe: Fix memory leaks
Date:   Tue, 13 Aug 2019 20:33:45 -0500
Message-Id: <1565746427-5366-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In pch_gbe_set_ringparam(), if netif_running() returns false, 'tx_old' and
'rx_old' are not deallocated, leading to memory leaks. To fix this issue,
move the free statements after the if branch.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
index 1a3008e..ef6311cd 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
@@ -340,12 +340,12 @@ static int pch_gbe_set_ringparam(struct net_device *netdev,
 			goto err_setup_tx;
 		pch_gbe_free_rx_resources(adapter, rx_old);
 		pch_gbe_free_tx_resources(adapter, tx_old);
-		kfree(tx_old);
-		kfree(rx_old);
 		adapter->rx_ring = rxdr;
 		adapter->tx_ring = txdr;
 		err = pch_gbe_up(adapter);
 	}
+	kfree(tx_old);
+	kfree(rx_old);
 	return err;
 
 err_setup_tx:
-- 
2.7.4


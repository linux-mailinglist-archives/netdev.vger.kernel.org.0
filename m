Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2347970F6
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 06:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfHUEUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 00:20:19 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:38127 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfHUEUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 00:20:19 -0400
Received: by mail-yb1-f195.google.com with SMTP id j199so484515ybg.5;
        Tue, 20 Aug 2019 21:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8jzbFnGqA4KnJX6O7FP/a3aKVv5OO1v3gxYw/j1lg60=;
        b=iDlZQ//6KpE0M+iWsT9xArjmVRFoTK46DHXiReyuasjY32uJ370sDvfRv/FJogPKeH
         E/WRxVTK8+1Mj2zq46fvYIixZKt5FSdr1pXmfPpNqsNX+vLzFjSLdfkdfKcuzTxieLhd
         a1D/l8IQNcmYt1jEtYNxK2PPZXIprbI0Ev1EQU4+YpERaurQ8RWGQHrwZGK1WFbHv1MB
         SBf2oh0UfYj5kYhCRMPJ2pMPVxzj3Lh88DOsAnFcYhowkT/ozxB64qvZcU0sgXQBA9tS
         TBOCtZpBHCyfLkEcKrHOIfp47fTzaw6tXTt4WV4WEKOHU3tZbJiGtCUstIlSmb0HtGfX
         JCWw==
X-Gm-Message-State: APjAAAUeYQi/ZfD/cwPjAQ680gNFgU7QyaPXb1pjfPcT1A8p/+Wqz5kU
        luItFILeWGQn/2NXZGr326E=
X-Google-Smtp-Source: APXvYqxun6o1suBbDORbO+zSvvMYatMn9aSR2ovHcJ0dyD5Oh4HzSXLAYlD1NEKEjOubMkMMLvs4Jg==
X-Received: by 2002:a25:4212:: with SMTP id p18mr22478312yba.194.1566361218158;
        Tue, 20 Aug 2019 21:20:18 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id c203sm4034239ywb.9.2019.08.20.21.20.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 20 Aug 2019 21:20:17 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Richard Fontana <rfontana@redhat.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] net: pch_gbe: Fix memory leaks
Date:   Tue, 20 Aug 2019 23:20:05 -0500
Message-Id: <1566361206-5135-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In pch_gbe_set_ringparam(), if netif_running() returns false, 'tx_old' and
'rx_old' are not deallocated, leading to memory leaks. To fix this issue,
move the free statements to the outside of the if() statement.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
index 1a3008e..cb43919 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
@@ -340,12 +340,10 @@ static int pch_gbe_set_ringparam(struct net_device *netdev,
 			goto err_setup_tx;
 		pch_gbe_free_rx_resources(adapter, rx_old);
 		pch_gbe_free_tx_resources(adapter, tx_old);
-		kfree(tx_old);
-		kfree(rx_old);
-		adapter->rx_ring = rxdr;
-		adapter->tx_ring = txdr;
 		err = pch_gbe_up(adapter);
 	}
+	kfree(tx_old);
+	kfree(rx_old);
 	return err;
 
 err_setup_tx:
-- 
2.7.4


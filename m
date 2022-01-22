Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A077496DAC
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 20:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiAVTky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 14:40:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48990 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbiAVTkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jan 2022 14:40:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lAIRb2yFrGM1AimEPq55mT1OWXrfZf42PyUiKDImuf8=; b=uo8BtnqffXHD/X1NueAg/3YWNa
        dMEigiJI+Mp2tolRZruE+gt46lWwWirhi+lMEsKWi9cMQcQb1lqaoxq+jSMFgs9oc1MnGJBfNEoR7
        H1GpqA4ib7Zm4Bbf7IbFFRZ3TQRg7+SXGEYgg9ASsih2BklzW1nJ30CO2eOSBcZk4Mrw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nBMFn-002JiB-7J; Sat, 22 Jan 2022 20:40:51 +0100
Date:   Sat, 22 Jan 2022 20:40:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Trofimovich <slyich@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: atl1c drivers run 'napi/eth%d-385' named threads with
 unsubstituted %d
Message-ID: <Yexdw8JSiTXtn2Bg@lunn.ch>
References: <YessW5YR285JeLf5@nz>
 <YetFsbw6885xUwSg@lunn.ch>
 <20220121170313.1d6ccf4d@hermes.local>
 <YetjpvBgQFApTRu0@lunn.ch>
 <20220122121228.3b73db2a@nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122121228.3b73db2a@nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Oh, yes. I looked at some of the users. And some do take rtnl before
> > calling it. And some don't!
> > 
> > Looking at register_netdev(), it seems we need something like:
> > 
> > 	if (rtnl_lock_killable()) {
> > 	       err = -EINTR;
> > 	       goto err_init_netdev;
> > 	}
> > 	err = dev_alloc_name(netdev, netdev->name);
> > 	rtnl_unlock();
> > 	if (err < 0)
> > 		goto err_init_netdev;
> > 
> > 
> > It might also be a good idea to put a ASSERT_RTNL() in
> > __dev_alloc_name() to catch any driver doing this wrong.

I looked at it some more, and some of the current users. And this does
not really work. There is a race condition.

Taking rtnl means you at least get a valid name, while you hold
rtnl. But it does not keep track of the name it just gave out. As a
result, you can release rtnl, and another device can jump in and be
given the same name in register_netdev(). When this driver then calls
register_netdev() the core will notice the clash and return -EEXISTS,
causing the probe to fail.

There are some drivers which take rtnl and keep it until after calling
register_netdevice(), rather than register_netdev(), but this is
rather ugly. And there are some drivers which don't take the lock, and
just hope they don't hit the race.

Maybe a better fix for this driver is:

From a5fc0e127bdc4b6ba4fb923012729cbf3d529996 Mon Sep 17 00:00:00 2001
From: Andrew Lunn <andrew@lunn.ch>
Date: Sat, 22 Jan 2022 13:33:58 -0600
Subject: [PATCH] net: ethernet: atl1c: Move dev_set_threaded() after
 register_netdev()

dev_set_threaded() creates new kernel threads to perform napi. The
threads are given a name based on the interface name. However, the
interface is not allocated a name until register_netdev() is called.
By moving the call to dev_set_threaded() to later in the probe
function, odd thread names like napi/eth%d-385 are avoided.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index da595242bc13..9b8088905946 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2728,7 +2728,7 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
        adapter->mii.mdio_write = atl1c_mdio_write;
        adapter->mii.phy_id_mask = 0x1f;
        adapter->mii.reg_num_mask = MDIO_CTRL_REG_MASK;
-       dev_set_threaded(netdev, true);
+
        for (i = 0; i < adapter->rx_queue_count; ++i)
                netif_napi_add(netdev, &adapter->rrd_ring[i].napi,
                               atl1c_clean_rx, 64);
@@ -2781,6 +2781,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
                goto err_register;
        }
 
+       dev_set_threaded(netdev, true);
+
        cards_found++;
        return 0;
 
-- 
2.34.1

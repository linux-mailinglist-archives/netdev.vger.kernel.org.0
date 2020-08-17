Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C384245FE9
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgHQI1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbgHQI04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:26:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99A7C061388;
        Mon, 17 Aug 2020 01:26:55 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u128so7871609pfb.6;
        Mon, 17 Aug 2020 01:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lVv9KH9OHYQxfiTtM7sr/yrxc3VHJHaRO2GRJfzHnA0=;
        b=tdpwarCYYV8gEQ5ZksyKAt24uXKiAXb9mffYCIfGOHo6XRdKn3E/4d0a7jNVUxQglq
         SV6/7fuATPb///IcuEDDTQy3TJ09Q1W87uRD8n3gBQVMDEY+AhZVua01ADz8gmMn4X6i
         nfm9It6IQbwseLhnOfwPJUrm1lyCdalOqlvSZVMv0KDkIDIe3qq850RJhPZX578LBRk3
         JOWeQLhC13jRH9ekm9SPnhrPyqSRYvPEVa8c8KfC1fyiaQebuzhJeeCTmaDDyw7hnXW7
         3sd06wpWx4FeZO9QIEMGU9dvOliR2qloKLNMr/vJ1TEZEJxwBBUuWHb/5Cro85mZTxbd
         o4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lVv9KH9OHYQxfiTtM7sr/yrxc3VHJHaRO2GRJfzHnA0=;
        b=tN0Izqryc8O/LRMyDMffTokJAp367WEnE2twMKsNrxaf6F1gsZVnvKX45kFh14bf/H
         ATPmqigs4CpkEYQhdMLagHT3a/ZniIxgKFJfHXQ9BtirmUZkHPd2g88B4F2pH8b522/U
         xbus5LILGkDdEuGM15ng1srXAJx13R4Uki6gbVjGz1g2XMYM2+L20JfQSSAO/VW3Q2C0
         yIRPg4jfabaeVoc6LxfRsob73z7yEaGu4po5H0XqgMajSEYb7rFjdGvg404JiH0QrOwH
         BdGapTHwqvr071zhQW8Tj4/7o++ru1N1syLvO/+gA6kQ2wNowYTVLe0B6olA+n+90Jfg
         spVQ==
X-Gm-Message-State: AOAM532WZwOKN8HMLdymEsnT/STxspUGxKI8X9iUac0dk4Fd3tq15sYK
        RcOZSCg23dytQ/mk3QCjBjQ=
X-Google-Smtp-Source: ABdhPJwxI7njVddj/NNf3D82oUgJzonLqIGa7AYU/tTYlx3E4MoM1tP++tr/dbSigeWK25H0FtOm/g==
X-Received: by 2002:a63:ee12:: with SMTP id e18mr8908728pgi.1.1597652814950;
        Mon, 17 Aug 2020 01:26:54 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:26:54 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 20/20] ethernet: smsc: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:34 +0530
Message-Id: <20200817082434.21176-22-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817082434.21176-1-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/smsc/smc91x.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 1c4fea9c3ec4..7e585aa3031c 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -535,10 +535,10 @@ static inline void  smc_rcv(struct net_device *dev)
 /*
  * This is called to actually send a packet to the chip.
  */
-static void smc_hardware_send_pkt(unsigned long data)
+static void smc_hardware_send_pkt(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *)data;
-	struct smc_local *lp = netdev_priv(dev);
+	struct smc_local *lp = from_tasklet(lp, t, tx_task);
+	struct net_device *dev = lp->dev;
 	void __iomem *ioaddr = lp->base;
 	struct sk_buff *skb;
 	unsigned int packet_no, len;
@@ -688,7 +688,7 @@ smc_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		 * Allocation succeeded: push packet to the chip's own memory
 		 * immediately.
 		 */
-		smc_hardware_send_pkt((unsigned long)dev);
+		smc_hardware_send_pkt(&lp->tx_task);
 	}
 
 	return NETDEV_TX_OK;
@@ -1965,7 +1965,7 @@ static int smc_probe(struct net_device *dev, void __iomem *ioaddr,
 	dev->netdev_ops = &smc_netdev_ops;
 	dev->ethtool_ops = &smc_ethtool_ops;
 
-	tasklet_init(&lp->tx_task, smc_hardware_send_pkt, (unsigned long)dev);
+	tasklet_setup(&lp->tx_task, smc_hardware_send_pkt);
 	INIT_WORK(&lp->phy_configure, smc_phy_configure);
 	lp->dev = dev;
 	lp->mii.phy_id_mask = 0x1f;
-- 
2.17.1


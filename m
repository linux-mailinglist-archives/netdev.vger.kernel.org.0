Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A172685F4
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgINHbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgINHbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:31:14 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FFCC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:31:10 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u13so10853197pgh.1
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L8c5AXStNe687nRDosmsTqhQY6wvDsSDeLTv0bL8ci8=;
        b=HEiXkWLTnBuYJIKkhVIyz367t29/tXCH9Q7u2BSfGHFak5YaAJ+W1iN/DOoJdyKG2m
         Wjn271sXG4sVNZp43eu5D/xQw6pESCMP97sc0SiJtW7ozU4wnpWF8cXhmcIylGQE4G+L
         b+oossZRdhpx5wd8xZO7hdrDyw1Awzb8ub3bdJ+gr7+FS1ixTquct52C5XlYy9SZkWUZ
         p87mY2wSSprUkiUB2Zsu22mvnKIlCt4JoHNx5TLCYgRG3Anlgi7++HwxVG06MHd6r1Pf
         vXoOflc7BS/9cz9jq85ymWwAuGfXlqR732SWsStwB6CsIid+c0GGGo4T6raFsf/jCnnK
         PKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L8c5AXStNe687nRDosmsTqhQY6wvDsSDeLTv0bL8ci8=;
        b=fb2MS/1ShDs2BkkQBl3c3X8F12hnRDWNB7oB1eFckQIJSN5mJqo+l7huSK55hRDA9+
         pcyVYqgkEkMxc382j4PnbI8SEJRSjqjMDH14XaLc+QjPI+KHPQwvQuCdVCf55K36sf0R
         z4yIJaUe/5HRW/7bC1bfWbxlndJRBMfyG4b92LweRQj+jYxXRiUFIHKIrvgo+wZKe80t
         XajkvP0LeKHEb9d0wodpyukK6uQvWVBUj/bpac58BYe3fokE21iIh1+2EMdWQ7RorYEm
         I3Hw3EstpUdSgi//atiKjg8A2RYHLAf33bDt6pHV8ho3OPQ8rpVYkCi/7RUvqPzYzf4W
         pwYg==
X-Gm-Message-State: AOAM533G2778llzbZ0RfA/IaqwSX4WsykR8j/95duOHwOEdkQUzOCjnB
        m7s4AT6rSpkaxMVZ269SQ7ZeTNhJaVFtRQ==
X-Google-Smtp-Source: ABdhPJybntRH2z5HVizbtluDaKOjhlph3GHl7kI82VAZ2z9yltgUELgM9VIbDjPY1eLrL8jBlAPd0w==
X-Received: by 2002:a63:5e01:: with SMTP id s1mr5494476pgb.421.1600068670510;
        Mon, 14 Sep 2020 00:31:10 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:31:10 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 20/20] net: smc91x: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:39 +0530
Message-Id: <20200914072939.803280-21-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
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
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D4E262ACC
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730174AbgIIIqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730104AbgIIIqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:46:36 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4E2C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:46:35 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b124so1522856pfg.13
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/7Lo0Zq19j3NrPlc5d1RuKodohY5I8pKUv1aJVGLWfo=;
        b=kWuWcYjn9OteFZzsj+svqPV7VHwMfLMz9ILf6rQVl3ISGsTLH0fbua61BDxoITwXtq
         FDsu9oeWwr8mXDAC7oYQr+BF9+Ud41HSSpqPNLHSKKWg0jTSiKUIoJO4lLiqiVuL3CnQ
         bQXvWMnCLIBdflEaNWCmbfDLxmhnVCoqRj9fnhXjAoEphOoArBGSc+25ET69iYrXCA/Q
         6DJyqkKbUdrLJrwadrTVf66a1FnlnrAmCnBozVY563IDAVeox8dMcWwk5bhRiuo7gMv8
         qBbVQhi7SqIcl96efMVUt4tManHfNnfogszgUqE/OKlxQXOoKQvHeYFlIfRSOaSZZ9/A
         P3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/7Lo0Zq19j3NrPlc5d1RuKodohY5I8pKUv1aJVGLWfo=;
        b=DSN7gchs0o+yu4YX0xf2tOVQP7CZvLl7jXts4alYIad9iVHLzQuV3hdN8FRjZ0vB9+
         EvYW15qKxA7t4dw1jN6+9jr9xgxwCwh2Un+dElK+0B1ayv/v0vnGLbeJsiFsqNpmkU0i
         AsSYQ29oCEUEd97ByaOOSZdiMh1HIzc/q8oiAqFZbfRW2jlIntCaJMGE3BobFIG6nI7J
         n2qwSbzthK8KanBHGbIaMgEw5MZAi5qckk6u50exyQ8fH6LPoXgJBxWfe7nSKtQ0xSS4
         +it6PHvinTqF3DjQGs1BW5OJlDPKTGY21kCnEiNSv4dSIC2TM77ra9e8Pc7hEyKKNtGQ
         nsZQ==
X-Gm-Message-State: AOAM533d/nu9TimsPf205okzotj0neC3JlXlKoAJFdlY1sBscY9wUlKG
        fK6v4eWC1oqWcPbhPjax/1Q=
X-Google-Smtp-Source: ABdhPJwsALSdFvB0YVF3SyCp/WB6lBThSLtxqN6kYvgICJSYHcdIjKOpPLn1+6xf+cS/9SBm6Io12w==
X-Received: by 2002:a17:902:70c9:b029:d0:cbe1:e749 with SMTP id l9-20020a17090270c9b02900d0cbe1e749mr2961971plt.36.1599641195025;
        Wed, 09 Sep 2020 01:46:35 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:46:34 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 20/20] ethernet: smsc: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:15:10 +0530
Message-Id: <20200909084510.648706-21-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367306CD927
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjC2ML3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjC2ML2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:11:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9837D1736
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Lz96P19z0dZSGwCzGiHP3QoSTs7GLgwaKrLAru7nFkc=; b=1WtOvEkCPjWgb3ooOZbcKnWQSv
        5/dns7fkmk/Yhfq+s3haqE0/CeP2lQafXiV0crI0TG6Y6hiv73JctQETcnsJaIfemjWz/Psx/l8cg
        X/NGSIzMWVb1IoCQIp84IbD+6v379iDtHeMgAVaEJCbAoMeYL7xctdILql1btecZo46e6O6vXET8Z
        b8zKh7CdONvBUnnssa11g3IX+YO3oVMonxPae05kXYS8Dn9tVrqPW/+KSSHIEW/bBoBZOIrl9pHBt
        IvTbFTzvl/m5ZfB1BlkNyC0MK6Ff9Fqzwi1cwQCb4MqPnuLtSnq2Gd3GE7NK7QRipUcIhLauY02wx
        t8WlkUNg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39724 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1phUe6-00006v-Jf; Wed, 29 Mar 2023 13:11:18 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1phUe5-00EieL-7q; Wed, 29 Mar 2023 13:11:17 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net] net: mvneta: fix potential double-frees in
 mvneta_txq_sw_deinit()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1phUe5-00EieL-7q@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 29 Mar 2023 13:11:17 +0100
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported on the Turris forum, mvneta provokes kernel warnings in the
architecture DMA mapping code when mvneta_setup_txqs() fails to
allocate memory. This happens because when mvneta_cleanup_txqs() is
called in the mvneta_stop() path, we leave pointers in the structure
that have been freed.

Then on mvneta_open(), we call mvneta_setup_txqs(), which starts
allocating memory. On memory allocation failure, mvneta_cleanup_txqs()
will walk all the queues freeing any non-NULL pointers - which includes
pointers that were previously freed in mvneta_stop().

Fix this by setting these pointers to NULL to prevent double-freeing
of the same memory.

Link: https://forum.turris.cz/t/random-kernel-exceptions-on-hbl-tos-7-0/18865/8
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0e39d199ff06..2cad76d0a50e 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3549,6 +3549,8 @@ static void mvneta_txq_sw_deinit(struct mvneta_port *pp,
 
 	netdev_tx_reset_queue(nq);
 
+	txq->buf               = NULL;
+	txq->tso_hdrs          = NULL;
 	txq->descs             = NULL;
 	txq->last_desc         = 0;
 	txq->next_desc_to_proc = 0;
-- 
2.30.2


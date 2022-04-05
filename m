Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6543E4F21BC
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 06:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiDECmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 22:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiDEClt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 22:41:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DB534203F
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 18:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=gTRAj5LWyLNVmpSOhCHxiH4uCxoX9EDlJ6ZjVFyX6ns=; b=uJxvM9IoEYoegElnDwLU7CiWJU
        D3tgB9vSvd4I9UbXsPPEeJ3Lf52VI0fvGZhoQPHZVF14LZ2rr3hAbCl506xAH0XReIPG/RavUcc5o
        FaqprR/r4HFu1M0jnOMla27E4h8pbu/dWZAMEv3GBtzjwtLnN7wQIlljccV2iHPftZkM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbWgP-00E9w3-M9; Tue, 05 Apr 2022 02:04:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Mauri Sandberg <maukka@ext.kapsi.fi>,
        Thomas Walther <walther-it@gmx.de>
Subject: [PATCH net] net: ethernet: mv643xx: Fix over zealous checking of_get_mac_address()
Date:   Tue,  5 Apr 2022 02:04:04 +0200
Message-Id: <20220405000404.3374734-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is often not a MAC address available in an EEPROM accessible by
Linux with Marvell devices. Instead the bootload has the MAC address
and directly programs it into the hardware. So don't consider an error
from of_get_mac_address() has fatal. However, the check was added for
the case where there is a MAC address in an the EEPROM, but the EEPROM
has not probed yet, and -EPROBE_DEFER is returned. In that case the
error should be returned. So make the check specific to this error
code.

Cc: Mauri Sandberg <maukka@ext.kapsi.fi>
Reported-by: Thomas Walther <walther-it@gmx.de>
Fixes: 42404d8f1c01 ("net: mv643xx_eth: process retval from of_get_mac_address")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 5f9ab1842d49..c18801490649 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2751,7 +2751,7 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 	}
 
 	ret = of_get_mac_address(pnp, ppd.mac_addr);
-	if (ret)
+	if (ret == -EPROBE_DEFER)
 		return ret;
 
 	mv643xx_eth_property(pnp, "tx-queue-size", ppd.tx_queue_size);
-- 
2.35.1


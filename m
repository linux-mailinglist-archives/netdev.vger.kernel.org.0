Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555BA6BE1E6
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 08:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjCQH2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 03:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjCQH2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 03:28:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764FD32E63
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 00:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eBHPdGB0hvSotEriMk1MPnkJNL0apGyZryoTspOYKd8=; b=OrnvAoWZjjvfjJk5rxDUDpbDaG
        ieDHQ7NDPt+0F6V9D1GiBf4pIDCdrpm3bMQMUcg9a8JemUeSRaEcdWFe9pJK1VN5308H8hYF41acw
        xfgkF+5KAS2q4R4uIsy9d9/gNB2lAMRMorDt+/gXulMSxoGZuq0FvpBh9NoVtLi+1J3icMK1PuTTc
        bUZbTSpA+rZRVr0Bjqh3bbQd6VfgBCiQNOnCfkfLgvN3fBFUYiLKm/QOtMtaASdB+sGWdqOze+vzS
        XXAmnkVmNVUcy7Tz4ylH86LxbqbvYOoRrbXMmkfKiJyDPUl7xxybFb1ylOvx/lFPnZNYFvP2v8g4L
        oRia/RUA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:59688 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pd4VM-00024b-Nh; Fri, 17 Mar 2023 07:28:00 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pd4VM-00DjWW-2N; Fri, 17 Mar 2023 07:28:00 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net] net: sfp: fix state loss when updating state_hw_mask
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pd4VM-00DjWW-2N@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 17 Mar 2023 07:28:00 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew reports that the SFF modules on one of the ZII platforms do not
indicate link up due to the SFP code believing that LOS indicating that
there is no signal being received from the remote end, but in fact the
LOS signal is showing that there is signal.

What makes SFF modules different from SFPs is they typically have an
inverted LOS, which uncovered this issue. When we read the hardware
state, we mask it with state_hw_mask so we ignore anything we're not
interested in. However, we don't re-read when state_hw_mask changes,
leading to sfp->state being stale.

Arrange for a software poll of the module state after we have parsed
the EEPROM in sfp_sm_mod_probe() and updated state_*_mask. This will
generate any necessary events for signal changes for the state
machine as well as updating sfp->state.

Reported-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 8475c4b70b04 ("net: sfp: re-implement soft state polling setup")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index c02cad6478a8..fb98db61e06c 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2190,6 +2190,11 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 			break;
 		}
 
+		/* Force a poll to re-read the hardware signal state after
+		 * sfp_sm_mod_probe() changed state_hw_mask.
+		 */
+		mod_delayed_work(system_wq, &sfp->poll, 1);
+
 		err = sfp_hwmon_insert(sfp);
 		if (err)
 			dev_warn(sfp->dev, "hwmon probe failed: %pe\n",
-- 
2.30.2


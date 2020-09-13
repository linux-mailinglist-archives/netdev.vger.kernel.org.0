Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13ECA267E53
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 09:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725918AbgIMHGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 03:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgIMHGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 03:06:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43133C061573
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 00:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rqqYbl0KS8CKQMVFvwXDUGh7XS8kFGTrJy7Dc1kk/L4=; b=JxFTtKMdgFFHCKg24fAFfJdFCp
        tAmnEgfEmlD9ZkBwMz35WRPH9afTc+5R7/8890zabT75OkeiTVKTvU+9OPz+kXc3W0VT3DJz2rXMI
        nnmw6yXue7InS14WANxfabHmBu4qjMm75A2/WlRTOzCRyUXI7Se+x/F5P+P8Q4gq8Fk7hD4r5OUPZ
        P1ewvRD+C297Dv2akG//+7uXpNwQBkoY/KpYtU20HkV5DhwaSnf33vd8O3LSPBK5UHsF8aFZHTUrQ
        FHMstLmEw16ND1C77wdY81j2n7pfBSdmGccbM/OY+mzLml8Z5uvaAShkv+7nkobMdvHRWxGZmRSzP
        fPWXwQuQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46586 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kHM5B-0000SG-3I; Sun, 13 Sep 2020 08:05:53 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kHM5A-0001Hg-Sf; Sun, 13 Sep 2020 08:05:52 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: mvpp2: set SKBTX_IN_PROGRESS
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kHM5A-0001Hg-Sf@rmk-PC.armlinux.org.uk>
Date:   Sun, 13 Sep 2020 08:05:52 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richard Cochran points out that SKBTX_IN_PROGRESS should be set when
the skbuff is queued for timestamping.  Add this.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 87b1c9cfdc77..d11d33cf3443 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3701,6 +3701,8 @@ static bool mvpp2_tx_hw_tstamp(struct mvpp2_port *port,
 	if (!hdr)
 		return false;
 
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
 	ptpdesc = MVPP22_PTP_MACTIMESTAMPINGEN |
 		  MVPP22_PTP_ACTION_CAPTURE;
 	queue = &port->tx_hwtstamp_queue[0];
-- 
2.20.1


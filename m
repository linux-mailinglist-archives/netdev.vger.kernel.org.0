Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DD92022CC
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 11:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgFTJU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 05:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgFTJU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 05:20:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCE6C06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 02:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IPjHOtwd9gU+pWUzKcc2PQNMrCICe4njQwSm0fz27/w=; b=zMn/IFCCkhlHaz4PdDohwhBgJ
        X21A1gvATn9s5mMX2eLonA0bYGSimg1XUp7wKA6O7hveBqO5J+PJaF00L7y8CG1VWlw4+McOEfaYj
        3k/Vf6ba63qypcFeeyaP6DWzQRTFVB0Q8YhIEg1fIsR0kl4digm66rfmBmRdty5kq6LcHHOl4sz7U
        nGmcNwEeYNLIzSrA4pr10SE/Pw2a4dfou7zEfSJs0q9KLROi6YhOXnQpsWtsGTgi/j3kPPoxnQG/3
        bTl3/1wBIZ9xUGUfe2YG6jBhgkg92STBispedoDOCCaSCg6edqKhaefZY4na6mzfa92sgbA1kvqS2
        Pl98rB+iw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58866)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jmZgA-0007O5-9d; Sat, 20 Jun 2020 10:20:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jmZg7-0006Vo-Kp; Sat, 20 Jun 2020 10:20:47 +0100
Date:   Sat, 20 Jun 2020 10:20:47 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/4] Marvell mvpp2 improvements
Message-ID: <20200620092047.GR1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series primarily cleans up mvpp2, but also fixes a left-over from
91a208f2185a ("net: phylink: propagate resolved link config via
mac_link_up()").

Patch 1 introduces some port helpers:
  mvpp2_port_supports_xlg() - does the port support the XLG MAC
  mvpp2_port_supports_rgmii() - does the port support RGMII modes

Patch 2 introduces mvpp2_phylink_to_port(), rather than having repeated
  open coding of container_of().

Patch 3 introduces mvpp2_modify(), which reads-modifies-writes a
  register - I've converted the phylink specific code to use this
  helper.

Patch 4 moves the hardware control of the pause modes from
  mvpp2_xlg_config() (which is called via the phylink_config method)
  to mvpp2_mac_link_up() - a change that was missed in the above
  referenced commit.

v2: remove "inline" in patch 2.

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 163 +++++++++++++-----------
 1 file changed, 88 insertions(+), 75 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D911FF706
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731504AbgFRPia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbgFRPia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 11:38:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5877C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 08:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iLmJzyDXqHbkT1s65lXkWoB+OVj8aBWFOpmjfeTf6gA=; b=qZ4+oJ1gMM/HnmN3F6FzshRyW
        7LeD9uUlCADK+e1qnh11rRRn9OWsZJEvzbetNl+m1e2/yOlkktsBJgA2CGoesfTUukCMZtl1GX+cD
        e0+/KpvuyPMNk6HtxL7Ie0zISwEkPAFncJNDPDJjBc/k+yeQehOExVAXEq2FAJY83WbKKZPD/dm3W
        ATPXK6kuNQTSzwjX6NdxID9EL4jEk0qWJpSy/rHZ2EMjC6wcT7e301rncNoJicr/qDsQNUH1du+0m
        hmAGAUo1K6NDjRFaglSJs7TTDnyYAgLhUfJQhlsczPjgKuR9XuJRCczMmuSaSw5WBhz7i5ZkjpIAH
        xPMJnKCVQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58786)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlwcP-0005Hm-Uv; Thu, 18 Jun 2020 16:38:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlwcM-0004oU-5G; Thu, 18 Jun 2020 16:38:18 +0100
Date:   Thu, 18 Jun 2020 16:38:18 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] Marvell mvpp2 improvements
Message-ID: <20200618153818.GD1551@shell.armlinux.org.uk>
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

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 164 +++++++++++++-----------
 1 file changed, 89 insertions(+), 75 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

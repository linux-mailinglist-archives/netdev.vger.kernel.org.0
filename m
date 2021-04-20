Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC09365A11
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhDTN16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 09:27:58 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:32955 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbhDTN15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 09:27:57 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4FBD422249;
        Tue, 20 Apr 2021 15:27:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1618925244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cqPRIy4v2i/c1w7ayO1W45KlATKGUfD4CdFjLYlm4kE=;
        b=Li6Cd6/DW5gL1MTAQkmCrunz2p8blk2b9L2zzdexi8NYTetq9sIeaQuqUUgEexHUrNHesb
        uii8wsgu/3oOz/+/o6JWQbFucGnDZstSqF2ogHqwPYZxYceqQF5R54h8WBHMbwSMJrqmRO
        zzaVh/gcW6bBQvu4KxdrVS3CnMaE2x0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 20 Apr 2021 15:27:24 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 0/5] Flow control for NXP ENETC
In-Reply-To: <20210416234225.3715819-1-olteanv@gmail.com>
References: <20210416234225.3715819-1-olteanv@gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <fa2347b25d25e71f891e50f6f789e421@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Am 2021-04-17 01:42, schrieb Vladimir Oltean:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This patch series contains logic for enabling the lossless mode on the
> RX rings of the ENETC, and the PAUSE thresholds on the internal FIFO
> memory.
> 
> During testing it was found that, with the default FIFO configuration,
> a sender which isn't persuaded by our PAUSE frames and keeps sending
> will cause some MAC RX frame errors. To mitigate this, we need to 
> ensure
> that the FIFO never runs completely full, so we need to fix up a 
> setting
> that was supposed to be configured well out of reset. Unfortunately 
> this
> requires the addition of a new mini-driver.

What happens if the mini driver is not enabled? Then the fixes aren't
applied and bad things happen (now with the addition of flow control),
right?

I'm asking because, if you have the arm64 defconfig its not enabled.

shouldn't it be something like:

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig 
b/drivers/net/ethernet/freescale/enetc/Kconfig
index d88f60c2bb82..cdc0ff89388a 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -2,7 +2,7 @@
  config FSL_ENETC
         tristate "ENETC PF driver"
         depends on PCI && PCI_MSI
-       depends on FSL_ENETC_IERB || FSL_ENETC_IERB=n
+       select FSL_ENETC_IERB
         select FSL_ENETC_MDIO
         select PHYLINK
         select PCS_LYNX

-michael

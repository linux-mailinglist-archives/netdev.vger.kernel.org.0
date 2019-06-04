Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1861533D43
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFDCn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:43:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52908 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfFDCn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 22:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+a3iAr9R1s17elqvdsH8KqlBXp/5m0nuvzPlckg5uy0=; b=fVrRLQdcKtMuOulLC3aiCS4w8X
        aBGJy/ZhXZFaxz94x9ii6+MBxF+CWXeCOeJvK1jpaPKoVp9WELgO6ExBmx+2NOI499sYr+7J1Lgfs
        Wp60iU4Kq6MT87KvcO2HQK5oZO88MlYZdAvDxNjG6eDEq/EQKCX68ZjUz7O0q+KWzwmQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXzQZ-0001eX-OG; Tue, 04 Jun 2019 04:43:55 +0200
Date:   Tue, 4 Jun 2019 04:43:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next 07/18] net: axienet: Re-initialize MDIO
 registers properly after reset
Message-ID: <20190604024355.GM17267@lunn.ch>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
 <1559599037-8514-8-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559599037-8514-8-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 03:57:06PM -0600, Robert Hancock wrote:
> The MDIO clock divisor register setting was only applied on the initial
> startup when the driver was loaded. However, this setting is cleared
> when the device is reset, such as would occur when the interface was
> taken down and brought up again, and so the MDIO bus would be
> non-functional afterwards.
> 
> Split up the MDIO bus setup and enable into separate functions and
> re-enable the bus after a device reset, to ensure that the MDIO
> registers are set properly. This also allows us to remove direct access
> to MDIO registers in xilinx_axienet_main.c and centralize them all in
> xilinx_axienet_mdio.c.

Hi Robert

MDIO is a shared bus. There can be multiple PHYs on it, an ethernet
switch, etc. So you need to be careful here. Before you hit the reset,
you need to lock the MDIO bus, bus->mdio_lock, do the reset, and then
unlock the bus.

Also, as soon as you register the bus, it needs to be usable. Your
axienet_mdio_setup() needs to set the divisor before it registers the
bus.

	Andrew

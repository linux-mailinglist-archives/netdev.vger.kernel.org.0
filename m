Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC38D78CB5
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 15:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387540AbfG2NXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 09:23:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44680 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387413AbfG2NXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 09:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=D3LR4K9RcO0ZgvZvFrl/obFQV8X+GZZRErdcH+2Kzsc=; b=KsSgNuCsNLdvTJhexvN4zTqRmh
        DFj2mlSeBwiaslzykUySvoZCGylDZ1rfhP2sTJcHOqqWPStQiwMGYD43NZ7f2peRJwd142RPM+6Y8
        VKFq0v4k0qnptOi5wJV8mIvbgTGlv4myDzSmj+aRsWrkq0LIttWfxRY96FLFtLCTUB+A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hs5cs-0001CX-FY; Mon, 29 Jul 2019 15:23:42 +0200
Date:   Mon, 29 Jul 2019 15:23:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     xiaofeis@codeaurora.org
Cc:     davem@davemloft.net, vkoul@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org
Subject: Re: [PATCH v3] net: dsa: qca8k: enable port flow control
Message-ID: <20190729132342.GA4110@lunn.ch>
References: <1564275470-52666-1-git-send-email-xiaofeis@codeaurora.org>
 <20190728223114.GD23125@lunn.ch>
 <fa444b03b42a2cb72037bc73a62f1976@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa444b03b42a2cb72037bc73a62f1976@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But our qca8k HW can auto sync the pause status to MAC from phy with the
> auto-negotiated result.
> So no need to set in qca8k_adjust_link, since there is one setting in
> qca8k_port_set_status: mask |= QCA8K_PORT_STATUS_LINK_AUTO;

How does the auto-sync actually work? Does the MAC make MDIO reads to
the PHY? That is generally unsafe, since some PHYs support pages, and
the PHY driver might be using a different page while the MAC tries to
access the auto-neg results.

Do any of the ports support an external PHY? The auto-sync might not
work in that condition as well. Different register layout, c45 not
c22, etc.

The safest option is to explicitly set the MAC flow configuration
based on the values in phydev.

      Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D04E78217
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 00:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfG1WbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 18:31:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42986 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfG1WbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 18:31:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=m5d+m3OnXB5OIaxsGQ9PLUViR6rt4otwxPWM3KxyWUI=; b=a269EgNGVvtQ5yKZ2C1A7gX3Xe
        IzOTSJzYlXGxfAvQmRe1nklxaUeeRJKKUikte64AXyBqOUhRGnobFfUWNtGVcElVIrszgALBW9wb+
        DBn8Ir3DjNMYyEbj8RF+toaJV0vnH7cvsHoCE4sncanAAffUdoJHhyLTk/bjlCOfFni0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hrrhC-0006Ip-Rm; Mon, 29 Jul 2019 00:31:14 +0200
Date:   Mon, 29 Jul 2019 00:31:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     xiaofeis <xiaofeis@codeaurora.org>
Cc:     davem@davemloft.net, vkoul@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org
Subject: Re: [PATCH v3] net: dsa: qca8k: enable port flow control
Message-ID: <20190728223114.GD23125@lunn.ch>
References: <1564275470-52666-1-git-send-email-xiaofeis@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564275470-52666-1-git-send-email-xiaofeis@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 28, 2019 at 08:57:50AM +0800, xiaofeis wrote:
> Set phy device advertising to enable MAC flow control.

Hi Xiaofei.

This is half of the needed change for MAC flow control.

phy_support_asym_pause(phy) is used by the MAC to tell the PHY layer
that the MAC supports flow control. The PHY will then advertise
this. When auto-negotiation is completed, the PHY layer will call
qca8k_adjust_link() with the results. It could be that the peer does
not support flow control, or only supports symmetric flow control.  So
in that function, you need to program the MAC with the results of the
auto-neg. This is currently missing. You need to look at phydev->pause
and phydev->asym_pause to decide how to configure the MAC.

       Andrew

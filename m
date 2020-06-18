Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58421FEE4A
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 11:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgFRJFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 05:05:33 -0400
Received: from mail.intenta.de ([178.249.25.132]:25400 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728926AbgFRJFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 05:05:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=epwqErgfD5ikQF/+lwawTeeiqAyOelzmVHEzIMlVeKA=;
        b=mhfUmkVgVt40FYfRLWYO8iSYUsPFV2ZpXFfJfkUxdMukbfRDx8yLkySVMO2558+JtngTpMs8i3z/YoQcI3TXDiqBM+E0ECeGASvg8pIfoZhEcEmC/fAxnV6GSIk3HpEuDg7IzR0/VO17JiZ2+yKJhsjF7z5oQ43Mie2tvnL+CpIh/Q5HTDizsS/zBtEpFgne2cONb+haqTjps64cXfIzmmwt6I4Z21S0OBHwqouXOXvP+jaiZUcFEFppXrPi3QDa+nlmB7XHdBwsd2xzA9OYebeU5BBLY6FJM+z6dA0bugGPCo6BSAtL2JINXNWZ9B8fxvjAYMxxVBte/LptlesReA==;
Date:   Thu, 18 Jun 2020 11:05:26 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200618090526.GA10165@laureti-dev>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <20200617112153.GB28783@laureti-dev>
 <20200617114025.GQ1551@shell.armlinux.org.uk>
 <20200617115201.GA30172@laureti-dev>
 <20200617120809.GS1551@shell.armlinux.org.uk>
 <20200618081433.GA22636@laureti-dev>
 <20200618084554.GY1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200618084554.GY1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 10:45:54AM +0200, Russell King - ARM Linux admin wrote:
> Why do we need that complexity?  If we decide that we can allow
> phy-mode = "rgmii" and introduce new properties to control the
> delay, then we just need:
> 
>   rgmii-tx-delay-ps = <nnn>;
>   rgmii-rx-delay-ps = <nnn>;
> 
> specified in the MAC node (to be applied only at the MAC end) or
> specified in the PHY node (to be applied only at the PHY end.)
> In the normal case, this would be the standard delay value, but
> in exceptional cases where supported, the delays can be arbitary.
> We know there are PHYs out there which allow other delays.
> 
> This means each end is responsible for parsing these properties in
> its own node and applying them - or raising an error if they can't
> be supported.

Thank you. That makes a lot more sense while keeping the (imo) important
properties of my proposal:
 * It is backwards compatible. These properties override delays
   specified inside phy-mode. Otherwise the vague phy-mode meaning is
   retained.
 * The ambiguity is resolved. It is always clear where delays should be
   configure and the properties properly account for possible PCB
   traces.

It also resolves my original problem. If support for these properties is
added to macb_main.c, it would simply check that both delays are 0 as
internal delays are not supported by the hardware.  When I would have
attempted to configure an rx delay, it would have nicely errored out.

How can we achieve wider consensus on this and put it into the dt
specification? Should there be drivers supporting these first?

Helmut

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE599294560
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 01:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439263AbgJTXM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 19:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439257AbgJTXM5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 19:12:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E066D223BF;
        Tue, 20 Oct 2020 23:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603235576;
        bh=4WY9vVWlC0GnYoSQjpODQA9tTdU6zzoZCrFArJ7O1UQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ikYSPgLFgd1E7tmXIaZmWs2JRoaO7MaFfnrXsxtpDz0z4h/lMJKpybwVlfpl9ET8M
         nOtORWpSuS6eKPK9cTEH7KWm4EKBssiDCJ4UEMH72hlmIAs3HZfko+L96PoV0+qcUD
         7vxha8jZ1S4oQW4cXx9UfibZykJBeU6JldKx+dd8=
Date:   Tue, 20 Oct 2020 16:12:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ard Biesheuvel <ardb@kernel.org>, netdev@vger.kernel.org,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net] netsec: ignore 'phy-mode' device property on ACPI
 systems
Message-ID: <20201020161253.72b99808@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020125001.GX456889@lunn.ch>
References: <20201018163625.2392-1-ardb@kernel.org>
        <20201020125001.GX456889@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 14:50:01 +0200 Andrew Lunn wrote:
> On Sun, Oct 18, 2020 at 06:36:25PM +0200, Ard Biesheuvel wrote:
> > Since commit bbc4d71d63549bc ("net: phy: realtek: fix rtl8211e rx/tx
> > delay config"), the Realtek PHY driver will override any TX/RX delay
> > set by hardware straps if the phy-mode device property does not match.
> > 
> > This is causing problems on SynQuacer based platforms (the only SoC
> > that incorporates the netsec hardware), since many were built with
> > this Realtek PHY, and shipped with firmware that defines the phy-mode
> > as 'rgmii', even though the PHY is configured for TX and RX delay using
> > pull-ups.
> >   
> > >From the driver's perspective, we should not make any assumptions in  
> > the general case that the PHY hardware does not require any initial
> > configuration. However, the situation is slightly different for ACPI
> > boot, since it implies rich firmware with AML abstractions to handle
> > hardware details that are not exposed to the OS. So in the ACPI case,
> > it is reasonable to assume that the PHY comes up in the right mode,
> > regardless of whether the mode is set by straps, by boot time firmware
> > or by AML executed by the ACPI interpreter.
> > 
> > So let's ignore the 'phy-mode' device property when probing the netsec
> > driver in ACPI mode, and hardcode the mode to PHY_INTERFACE_MODE_NA,
> > which should work with any PHY provided that it is configured by the
> > time the driver attaches to it. While at it, document that omitting
> > the mode is permitted for DT probing as well, by setting the phy-mode
> > DT property to the empty string.
> > 
> > Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Thanks, applied.

Just to be on the safe side please make sure to CC Rob & DT list 
if your patch touches anything device tree.

> --- a/Documentation/devicetree/bindings/net/socionext-netsec.txt
> +++ b/Documentation/devicetree/bindings/net/socionext-netsec.txt
> @@ -30,7 +30,9 @@ Optional properties: (See ethernet.txt file in the same directory)
>  - max-frame-size: See ethernet.txt in the same directory.
>  
>  The MAC address will be determined using the optional properties
> -defined in ethernet.txt.
> +defined in ethernet.txt. The 'phy-mode' property is required, but may
> +be set to the empty string if the PHY configuration is programmed by
> +the firmware or set by hardware straps, and needs to be preserved.
>  
>  Example:
>  	eth0: ethernet@522d0000 {

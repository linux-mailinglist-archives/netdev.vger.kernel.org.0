Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834E92FDF96
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbhAUCUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 21:20:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387887AbhAUBmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 20:42:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DCF623716;
        Thu, 21 Jan 2021 01:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611192688;
        bh=mlASetvi2SErMvcnyFzqkMLjtpL5rtgpEkhTo09zKlw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NkBexMVr7sme4S++71Hi486MvlK5D3UKf2SVPJvechF0R6SRbeFbkVwGGuhGq7nQj
         dw2ni4mxqgwtiEY4hO7LVPGlytU51IghgPqtQPPsSPsLvbt+cMJrnLB4D4/fUGEVEQ
         Mk1v73lx29yjIoSNfatyyBdOxfS5kNaadRl0MABctfGMKBHNOTdxj2Q20kNtZkuslO
         CYEZnGbDT+3HTw0O9GqXDq0zAx3BMfDX0e6hI8MRwkyQgOCVTHiQJlvzn6h7hh096j
         qcjpFAH7GGsyBrzrFhDxvwLbXCrxjDKpVtRc0p1RGT8/jWF3cn4lBkrmHV6zL2XrxD
         EZFZgShw84eMA==
Date:   Wed, 20 Jan 2021 17:31:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Barker <pbarker@konsulko.com>
Subject: Re: [PATCH net-next V2] net: dsa: microchip: Adjust reset release
 timing to match reference reset circuit
Message-ID: <20210120173127.58445e6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120030502.617185-1-marex@denx.de>
References: <20210120030502.617185-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 04:05:02 +0100 Marek Vasut wrote:
> KSZ8794CNX datasheet section 8.0 RESET CIRCUIT describes recommended
> circuit for interfacing with CPU/FPGA reset consisting of 10k pullup
> resistor and 10uF capacitor to ground. This circuit takes ~100 ms to
> rise enough to release the reset.
> 
> For maximum supply voltage VDDIO=3.3V VIH=2.0V R=10kR C=10uF that is
>                     VDDIO - VIH
>   t = R * C * -ln( ------------- ) = 10000*0.00001*-(-0.93)=0.093 s
>                        VDDIO
> so we need ~95 ms for the reset to really de-assert, and then the
> original 100us for the switch itself to come out of reset. Simply
> msleep() for 100 ms which fits the constraint with a bit of extra
> space.
> 
> Fixes: 5b797980908a ("net: dsa: microchip: Implement recommended reset timing")
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Marek Vasut <marex@denx.de>

I'm slightly confused whether this is just future proofing or you
actually have a board where this matters. The tree is tagged as
net-next but there is a Fixes tag which normally indicates net+stable.

Please advise.

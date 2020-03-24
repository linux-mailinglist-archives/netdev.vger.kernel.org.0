Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D00191136
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgCXNc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:32:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54424 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728150AbgCXNc5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:32:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/8UhKJBTlB5B5d8FkbuPDRfqF3TVFtg22A8FyEG/d1s=; b=b/08ETuwRnX73ETNfp1DspvvJD
        C+3W3OpfqroXR2rHdCWP4zFFkGlqF/ZCloTu0hRrCt/TekDsqPUuGEHFiMFWtb89mOa2cdrZe+4Dv
        WzwYpBvzQkHKTEW3xiaxP55cZV2sD/Mc0rB84SoT/CmMePjWEAAPRwIAnPRMwnR+f2hQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGjfp-0002HC-13; Tue, 24 Mar 2020 14:32:53 +0100
Date:   Tue, 24 Mar 2020 14:32:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 08/14] net: ks8851: Use 16-bit read of RXFC register
Message-ID: <20200324133253.GX3819@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-9-marex@denx.de>
 <20200324015041.GO3819@lunn.ch>
 <8079699e-8235-c800-44a8-022ade8140f1@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8079699e-8235-c800-44a8-022ade8140f1@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 01:50:53PM +0100, Marek Vasut wrote:
> On 3/24/20 2:50 AM, Andrew Lunn wrote:
> >> @@ -470,7 +455,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
> >>  	unsigned rxstat;
> >>  	u8 *rxpkt;
> >>  
> >> -	rxfc = ks8851_rdreg8(ks, KS_RXFC);
> >> +	rxfc = (ks8851_rdreg16(ks, KS_RXFCTR) >> 8) & 0xff;
> > 
> > The datasheet says:
> > 
> > 2. When software driver reads back Receive Frame Count (RXFCTR)
> > Register; the KSZ8851 will update both Receive Frame Header Status and
> > Byte Count Registers (RXFHSR/RXFHBCR)
> > 
> > Are you sure there is no side affect here?
> 
> Yes, look at the RXFC register 0x9c itself. It's a 16bit register, 0x9c
> is the LSByte and 0x9d is the MSByte.
> 
> What happened here before was readout of register 0x9d, MSByte of RXFC,
> which triggers the update of RXFHSR/RXFHBCR. What happens now is the
> readout of the whole RXFC as 16bit value, which also triggers the update.

Hi Marek

It would be nice to indicate in the commit message that things like
this have been considered. As a reviewer, these are the sort of
questions which goes through my mind. If there is a comment it has
been considered, i get the answer to my questions without having to
ask.

	Andrew

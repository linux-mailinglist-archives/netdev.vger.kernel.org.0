Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43B22ECC57
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbhAGJJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:09:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbhAGJJa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 04:09:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94D3C22CF8;
        Thu,  7 Jan 2021 09:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610010529;
        bh=hT97XartlDHHyLDpDxHrJy2mQbx9clbET9d1rFFIMnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fuuzM7bXlJTmuYJcYr1oP1ARilEgGsLARTCFhVWMMcojccFClLi8TuPqErlVqDWGE
         HYj68efsVVsbwCs5baQYUSA2mylVbUkVcxUCAutz08UpSuaPQvm/GIj5cTte7EriAx
         FMA7OP74b1NVFQUAiVMPR+00jotp7Fg5SJv+sj0MLH7SCtr5oIBdcRJRJDIx1DPhiX
         D3EaHLRaRNwkuNTtLR19pRUFp33qONSRGd8sBhkqfM1+ESbIco00JjZ5SdYYGHTAQU
         b3aqT5y0OoHZOC+emOBHWxlc55w4ciFRrxpxkWwAMhx50zQ2SCN2m3ZXWjXHQgD+Ni
         t1cCNcYpxf3Mw==
Received: by pali.im (Postfix)
        id 2F60E77B; Thu,  7 Jan 2021 10:08:47 +0100 (CET)
Date:   Thu, 7 Jan 2021 10:08:46 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20210107090846.rxi7yo7adxumjmi3@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-2-pali@kernel.org>
 <X/ZrvOwsyrfmh3B2@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/ZrvOwsyrfmh3B2@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 07 January 2021 03:02:36 Andrew Lunn wrote:
> > +	/* hwmon interface needs to access 16bit registers in atomic way to
> > +	 * guarantee coherency of the diagnostic monitoring data. If it is not
> > +	 * possible to guarantee coherency because EEPROM is broken in such way
> > +	 * that does not support atomic 16bit read operation then we have to
> > +	 * skip registration of hwmon device.
> > +	 */
> > +	if (sfp->i2c_block_size < 2) {
> > +		dev_info(sfp->dev, "skipping hwmon device registration "
> > +				   "due to broken EEPROM\n");
> > +		dev_info(sfp->dev, "diagnostic EEPROM area cannot be read "
> > +				   "atomically to guarantee data coherency\n");
> > +		return;
> > +	}
> 
> This solves hwmon. But we still return the broken data to ethtool -m.
> I wonder if we should prevent that?

Looks like that it is not too simple for now.

And because we already export these data for these broken chips in
current mainline kernel, I would propose to postpone fix for ethtool and
let it for future patches. This patch series does not change (nor make
it worse) behavior.

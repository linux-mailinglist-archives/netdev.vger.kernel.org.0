Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B052C21FA
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731704AbgKXJnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731697AbgKXJnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:43:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DB3C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 01:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EuT23AKRIC/iMYu9c3D4WIiXJeSq7VPYKY9MWUx0yKQ=; b=Pob53MAWrGWSpBPg73zphTZK9
        TjX/s/aT62xfEQ9rXzjIPe3TKhH9wKQAL2WSsvCMct7bHOcK+78JiYqXC37NM7SUUHsqbHl5YFWCf
        j2bQHOE091PMnnXJup7d49Sv5NkF61f+DTL6x761vbRVnO/3SW9QQy3/E5d+YU3lnVyd3STXoY4Zb
        LvQws5xxL9YS0vrb+qz5yTQdL3AT9x6FoB0wPrtUjaGf4hGaqpFHLtGyBATwTt9npX3Lx3QVoVoWF
        Vq0RFf+605REjHXGKBAAI1VVjaQhvaw3TLgAIhsri9aOvX9Yxx1RXzqrFyxHs2uXZDtYtowthMbkN
        L/TQXx0Jw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35434)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1khUqy-0007QG-T7; Tue, 24 Nov 2020 09:43:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1khUqw-0007Ew-QD; Tue, 24 Nov 2020 09:43:14 +0000
Date:   Tue, 24 Nov 2020 09:43:14 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: sfp: VSOL V2801F / CarlitoxxPro
 CPGOS03-0490 v2.0 workaround
Message-ID: <20201124094314.GC1551@shell.armlinux.org.uk>
References: <E1khJlv-0003Jq-ET@rmk-PC.armlinux.org.uk>
 <20201124002021.GB2031446@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124002021.GB2031446@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 01:20:21AM +0100, Andrew Lunn wrote:
> > @@ -335,10 +336,19 @@ static int sfp_i2c_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
> >  			size_t len)
> >  {
> >  	struct i2c_msg msgs[2];
> > -	u8 bus_addr = a2 ? 0x51 : 0x50;
> > +	size_t block_size;
> >  	size_t this_len;
> > +	u8 bus_addr;
> >  	int ret;
> >  
> > +	if (a2) {
> > +		block_size = 16;
> > +		bus_addr = 0x51;
> 
> Hi Russell, Thomas
> 
> Does this man the diagnostic page can be read 16 bytes at a time, even
> when the other page has to be 1 bytes at a time? That seems rather
> odd. Or is the diagnostic page not implemented in these SFPs?

SFF8472 requires that multibyte values are read using sequential
reads. So we can't use single byte reads to read a multibyte value -
it's just not atomic.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

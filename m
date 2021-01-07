Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEDB2ED5D2
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbhAGRlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbhAGRlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:41:22 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B8EC0612F5;
        Thu,  7 Jan 2021 09:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9/FA1Vc65rJkX++HoTWkn04xPZplzcmSL7GCL5yHdp8=; b=DblXo6XkaSr0w42aUgYaBbLse
        NslapEgxD+pCG4jV014h+QO88wEc4D1moBjCTS7Q0VGrhkVouVhb+d1fYNtp6Q5xtvdOfcnZJOkaG
        oYybdBdvKYwP6hMrxv96T1ZExEkeaygBJtQWDLToF+ULiMlqEAEmi4tELy3b3KDes5D53GZFliYIa
        wba2EHbF7CARTGr/OfkA9XMm4y9xc2kvK5wCvZarQYMyIvw+K0j2pON7lnCRDHbYAWrAH2LQsOuby
        9Eqw1OzVb3Mj1AEsfZOU738xzFfrZRYsMzKYnTnws/dALIZxd4H6FPJ4/uqfZQW19+qp3IWFH46WS
        tzwaNhWcQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45232)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kxZGa-000353-6L; Thu, 07 Jan 2021 17:40:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kxZGY-0001M8-Q3; Thu, 07 Jan 2021 17:40:06 +0000
Date:   Thu, 7 Jan 2021 17:40:06 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20210107174006.GQ1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-2-pali@kernel.org>
 <X/dCm1fK9jcjs4XT@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/dCm1fK9jcjs4XT@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 06:19:23PM +0100, Andrew Lunn wrote:
> Did we loose the comment:
> 
> /* Some modules (Nokia 3FE46541AA) lock up if byte 0x51 is read as a
>  * single read. Switch back to reading 16 byte blocks ...
> 
> That explains why 16 is used. Given how broken stuff is and the number
> of workaround we need, we should try to document as much as we cam, so
> we don't break stuff when adding more workarounds.

It is _not_ why 16 is used at all.

We used to read the whole lot in one go. However, some modules could
not cope with a full read - also some Linux I2C drivers struggled with
it.

So, we reduced it down to 16 bytes. See commit 28e74a7cfd64 ("net: sfp:
read eeprom in maximum 16 byte increments"). That had nothing to do
with the 3FE46541AA, which came along later. It has been discovered
that 3FE46541AA reacts badly to a single byte read to address 0x51 -
it locks the I2C bus. Hence why we can't just go to single byte reads
for every module.

So, the comment needs to be kept to explain why we are unable to go
to single byte reads for all modules.  The choice of 16 remains
relatively arbitary.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37AF2ED764
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbhAGTTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:19:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbhAGTTR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 14:19:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C6232343E;
        Thu,  7 Jan 2021 19:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610047117;
        bh=UCctLD+NI8TifQ33SAD5X6VpKMo4qNarVgUMTBLJDDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eAv4ca6xplkrk3liN62dEyjhmQK1yhRcXtQqMYRCg4fclZuLMFrKTGbQSBwAC/HDF
         WCCev/6rzL7v9jLil4dRkUmHFPHjBHbEOKYb8Lp+edblXqR3f/O8bzZ2XIuqCeKuiL
         F8GHQDB+xI5YpiHl2GIVonh7yLu4qpT6FhVopUN446gzAR35rkNOQ7ZY7/x8hKzeYc
         W9p7XuxgXadieG61O9nJZXvuZZ5shj0RcSrgJCk+4G9YmVzjOi9EVy8ybKw4eZOO41
         9k47BD8cFm6lDjIbaMghe/Vz30R/59igwcJo7HzmfKKT7B+UehxdSiEpYGfTPX3giQ
         cwsTSvX6yH2BA==
Received: by pali.im (Postfix)
        id A88CD77B; Thu,  7 Jan 2021 20:18:34 +0100 (CET)
Date:   Thu, 7 Jan 2021 20:18:34 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20210107191834.bsvwen2rgpozer7o@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-2-pali@kernel.org>
 <X/dCm1fK9jcjs4XT@lunn.ch>
 <20210107174006.GQ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107174006.GQ1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 07 January 2021 17:40:06 Russell King - ARM Linux admin wrote:
> On Thu, Jan 07, 2021 at 06:19:23PM +0100, Andrew Lunn wrote:
> > Did we loose the comment:
> > 
> > /* Some modules (Nokia 3FE46541AA) lock up if byte 0x51 is read as a
> >  * single read. Switch back to reading 16 byte blocks ...
> > 
> > That explains why 16 is used. Given how broken stuff is and the number
> > of workaround we need, we should try to document as much as we cam, so
> > we don't break stuff when adding more workarounds.
> 
> It is _not_ why 16 is used at all.
> 
> We used to read the whole lot in one go. However, some modules could
> not cope with a full read - also some Linux I2C drivers struggled with
> it.
> 
> So, we reduced it down to 16 bytes. See commit 28e74a7cfd64 ("net: sfp:
> read eeprom in maximum 16 byte increments"). That had nothing to do
> with the 3FE46541AA, which came along later. It has been discovered
> that 3FE46541AA reacts badly to a single byte read to address 0x51 -
> it locks the I2C bus. Hence why we can't just go to single byte reads
> for every module.
> 
> So, the comment needs to be kept to explain why we are unable to go
> to single byte reads for all modules.  The choice of 16 remains
> relatively arbitary.

Do you have an idea where to put a comment?

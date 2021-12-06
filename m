Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED7646AC05
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 23:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357509AbhLFWdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 17:33:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45182 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350813AbhLFWdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 17:33:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62C89B815B0;
        Mon,  6 Dec 2021 22:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B0DC341C6;
        Mon,  6 Dec 2021 22:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638829799;
        bh=vgWk4/IR5H2ScItocBPuRHtKGHNWxclK7Sm5296+FVE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lpdEZswt+IEtrtDsgPcif0et8Ynxv3t+T7Uwy+41RPp+v3sdYGlT4Rculvi67tmPM
         mEXiyKuXHDxg3cW8jSC8A3FWE2cpCRNsumMONIYuZDXlNeKzrSCtDNabgdSXygAFAG
         axVerldOSWz7fyvJRLP4D071ZOtIlut5onz0ybqqRr6MBhAMXTNTJbJ9ro8L4fAfNc
         2DD1Jm5LwxJxfCVsZwmrmMpFnDksAhJt70MJs9TZs9KIgbPngNdmlTXqA+a7LhMNXH
         rJMg0LOxLaWClh4OAygqTB3i5qmhc1P5ayitkRNGhCpLYW5Gv+eMb7uTCKLeBl1ys8
         TMliW57jI3IEw==
Date:   Mon, 6 Dec 2021 23:29:53 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ameer Hamza <amhamza.mgc@gmail.com>, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: initialize return variable on
 declaration
Message-ID: <20211206232953.065c0dc9@thinkpad>
In-Reply-To: <Ya4OP+jQYd/UwiQK@lunn.ch>
References: <20211206113219.17640-1-amhamza.mgc@gmail.com>
        <Ya4OP+jQYd/UwiQK@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021 14:21:03 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Mon, Dec 06, 2021 at 04:32:19PM +0500, Ameer Hamza wrote:
> > Uninitialized err variable defined in mv88e6393x_serdes_power
> > function may cause undefined behaviour if it is called from
> > mv88e6xxx_serdes_power_down context.
> > 
> > Addresses-Coverity: 1494644 ("Uninitialized scalar variable")
> > 
> > Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> > ---
> >  drivers/net/dsa/mv88e6xxx/serdes.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
> > index 55273013bfb5..33727439724a 100644
> > --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> > +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> > @@ -1507,7 +1507,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
> >  			    bool on)
> >  {
> >  	u8 cmode = chip->ports[port].cmode;
> > -	int err;
> > +	int err = 0;
> >  
> >  	if (port != 0 && port != 9 && port != 10)
> >  		return -EOPNOTSUPP;  
> 
> Hi Marek
> 
> This warning likely comes from cmode not being a SERDES mode, and that
> is not handles in the switch statementing. Do we want an
> 
> default:
> 	err = EINVAL;
> 
> ?
> 
> 	Andrew

Hi Andrew,

currently all the .serdes_power() methods return 0 for non-serdes ports.
This is because the way it is written, these methods are not called if
there is not a serdes lane for a given port.

For this issue with err variable undefined, to fix it we should simply
set int err=0 at the beginning of mv88e6393x_serdes_power(), to make it
behave like other serdes_power() methods do in serdes.c.



But a refactor may be needed for serdes_power() methods, at least
because they are a little weird. But it should be unrelated to this fix.

In serdes.h we have static inline functions
  mv88e6xxx_serdes_power_up(chip, port, lane)
  mv88e6xxx_serdes_power_down(chip, port, lane)

  (These simply call the serdes_power() method of chip ops, with
   additional boolean argument to specify powerup/powerdown.
   Also for these we first need to determine lane for a port. If lane
   does not exists, these should not be called.)

In chip.c we have function
  mv88e6xxx_serdes_power(chip, port, on)
  
  (This finds if the port has a lane, and if so, calls, if on=true
   mv88e6xxx_serdes_power_up()
     from serdes.h, and then
   mv88e6xxx_serdes_irq_request()
     also from serdes.h

   and if on=false, calls _irq_free() & _serdes_power_down()
  )

So if I call
  mv88e6xxx_serdes_power(chip, port, true)
it goes
    mv88e6xxx_serdes_power_up(chip, port, lane)
      chip->info->ops->serdes_power(chip, port, lane, true)
so the `on` argument is used in some places, but in other places there
are two functions instead.

Which I find a little weird.

Marek

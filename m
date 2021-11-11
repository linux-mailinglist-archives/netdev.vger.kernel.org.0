Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2D844D605
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 12:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhKKLqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 06:46:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232256AbhKKLqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 06:46:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 292C861260;
        Thu, 11 Nov 2021 11:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636631042;
        bh=YcMqijhBxkjyDbI6FT1Y7XySq+s1PPEA1nSPAd2SfX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sCc/S66fuW5ryIsO52bzi2FGYrtgffKp2TPPyORFTTEpgenqJkQjoj1lmXJkalrye
         i5FtNRamwWLv88Yq/fYL3IkT5KFTUHrJmxbyOn+ZgZqEB0nKeDl7z8lkq2BVJgCd6N
         +zgvcXaV5/5WpJL0vws2wIRM9BVWqQvpoW8lVA6U=
Date:   Thu, 11 Nov 2021 12:44:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: Some cleanups in remove code
Message-ID: <YY0CAPPo3g7FHDOU@kroah.com>
References: <20211109113921.1020311-1-u.kleine-koenig@pengutronix.de>
 <20211109115434.oejplrd7rzmvad34@skbuf>
 <20211109175055.46rytrdejv56hkxv@pengutronix.de>
 <20211110131540.qxxeczi5vtzs277f@skbuf>
 <20211110210346.qthmuarwbuajpcp2@pengutronix.de>
 <20211110225611.h6klnoscntufdsv3@skbuf>
 <20211111075754.wnwtcfun3hjthh4v@pengutronix.de>
 <20211111104701.uzqte6kczfoj57e6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211111104701.uzqte6kczfoj57e6@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 12:47:01PM +0200, Vladimir Oltean wrote:
> On Thu, Nov 11, 2021 at 08:57:54AM +0100, Uwe Kleine-König wrote:
> > Hello Vladimir,
> > 
> > On Thu, Nov 11, 2021 at 12:56:11AM +0200, Vladimir Oltean wrote:
> > > On Wed, Nov 10, 2021 at 10:03:46PM +0100, Uwe Kleine-König wrote:
> > > > Hello Vladimir,
> > > > 
> > > > On Wed, Nov 10, 2021 at 03:15:40PM +0200, Vladimir Oltean wrote:
> > > > > On Tue, Nov 09, 2021 at 06:50:55PM +0100, Uwe Kleine-König wrote:
> > > > > > On Tue, Nov 09, 2021 at 01:54:34PM +0200, Vladimir Oltean wrote:
> > > > > > > Your commit prefix does not reflect the fact that you are touching the
> > > > > > > vsc73xx driver. Try "net: dsa: vsc73xx: ".
> > > > > > 
> > > > > > Oh, I missed that indeed.
> > > > > > 
> > > > > > > On Tue, Nov 09, 2021 at 12:39:21PM +0100, Uwe Kleine-König wrote:
> > > > > > > > vsc73xx_remove() returns zero unconditionally and no caller checks the
> > > > > > > > returned value. So convert the function to return no value.
> > > > > > > 
> > > > > > > This I agree with.
> > > > > > > 
> > > > > > > > For both the platform and the spi variant ..._get_drvdata() will never
> > > > > > > > return NULL in .remove() because the remove callback is only called after
> > > > > > > > the probe callback returned successfully and in this case driver data was
> > > > > > > > set to a non-NULL value.
> > > > > > > 
> > > > > > > Have you read the commit message of 0650bf52b31f ("net: dsa: be
> > > > > > > compatible with masters which unregister on shutdown")?
> > > > > > 
> > > > > > No. But I did now. I consider it very surprising that .shutdown() calls
> > > > > > the .remove() callback and would recommend to not do this. The commit
> > > > > > log seems to prove this being difficult.
> > > > > 
> > > > > Why do you consider it surprising?
> > > > 
> > > > In my book .shutdown should be minimal and just silence the device, such
> > > > that it e.g. doesn't do any DMA any more.
> > > 
> > > To me, the more important thing to consider is that many drivers lack
> > > any ->shutdown hook at all, and making their ->shutdown simply call
> > > ->remove is often times the least-effort path of doing something
> > > reasonable towards quiescing the hardware. Not to mention the lesser
> > > evil compared to not having a ->shutdown at all.
> > > 
> > > That's not to say I am not in favor of a minimal shutdown procedure if
> > > possible. Notice how DSA has dsa_switch_shutdown() vs dsa_unregister_switch().
> > > But judging what should go into dsa_switch_shutdown() was definitely not
> > > simple and there might still be corner cases that I missed - although it
> > > works for now, knock on wood.
> > > 
> > > The reality is that you'll have a very hard time convincing people to
> > > write a dedicated code path for shutdown, if you can convince them to
> > > write one at all. They wouldn't even know if it does all the right
> > > things - it's not like you kexec every day (unless you're using Linux as
> > > a bootloader - but then again, if you do that you're kind of asking for
> > > trouble - the reason why this is the case is exactly because not having
> > > a ->shutdown hook implemented by drivers is an option, and the driver
> > > core doesn't e.g. fall back to calling the ->remove method, even with
> > > all the insanity that might ensue).
> > 
> > Maybe I'm missing an important point here, but I thought it to be fine
> > for most drivers not to have a .shutdown hook.
> 
> Depends on what you mean by "most drivers". One other case of definitely
> problematic things that ->shutdown must take care of are shared interrupts.
> I don't have a metric at hand, but there are definitely not few drivers
> which support IRQF_SHARED. Some of those don't implement ->shutdown.
> What I'm saying is that it would definitely go a long way for the
> problems caused by these to be solved in one fell swoop by having some
> logic to fall back to the ->remove path.
> 
> > > > > Many drivers implement ->shutdown by calling ->remove for the simple
> > > > > reason that ->remove provides for a well-tested code path already, and
> > > > > leaves the hardware in a known state, workable for kexec and others.
> > > > > 
> > > > > Many drivers have buses beneath them. Those buses go away when these
> > > > > drivers unregister, and so do their children.
> > > > > 
> > > > > ==============================================
> > > > > 
> > > > > => some drivers do both => children of these buses should expect to be
> > > > > potentially unregistered after they've been shut down.
> > > > 
> > > > Do you know this happens, or do you "only" fear it might happen?
> > > 
> > > Are you asking whether there are SPI controllers that implement
> > > ->shutdown as ->remove?
> > 
> > No I ask if it happens a lot / sometimes / ever that a driver's remove
> > callback is run for a device that was already shut down.
> 
> So if a SPI device is connected to one of the 3 SPI controllers
> mentioned by me below, it happens with 100% reproduction rate. Otherwise
> it happens with 0% reproduction rate. But you don't write a SPI device
> driver to work with just one SPI controller, ideally you write it to
> work with all.
> 
> > > Just search for "\.shutdown" in drivers/spi.
> > > 3 out of 3 implementations call ->remove.
> > > 
> > > If you really have time to waste, here, have fun: Lino Sanfilippo had
> > > not one, but two (!!!) reboot problems with his ksz9897 Ethernet switch
> > > connected to a Raspberry Pi, both of which were due to other drivers
> > > implementing their ->shutdown as ->remove. First driver was the DSA
> > > master/host port (bcmgenet), the other was the bcm2835_spi controller.
> > > https://patchwork.kernel.org/project/netdevbpf/cover/20210909095324.12978-1-LinoSanfilippo@gmx.de/
> > > https://patchwork.kernel.org/project/netdevbpf/cover/20210912120932.993440-1-vladimir.oltean@nxp.com/
> > > https://patchwork.kernel.org/project/netdevbpf/cover/20210917133436.553995-1-vladimir.oltean@nxp.com/
> > > As soon as we implemented ->shutdown in DSA drivers (which we had mostly
> > > not done up until that thread) we ran into the surprise that ->remove
> > > will get called too. Yay. It wasn't trivial to sort out, but we did it
> > > eventually in a more systematic way. Not sure whether there's anything
> > > to change at the drivers/base/ level.
> > 
> > What I wonder is: There are drivers that call .remove from .shutdown. Is
> > the right action to make other parts of the kernel robust with this
> > behaviour, or should the drivers changed to not call .remove from
> > .shutdown?
> > 
> > IMHO this is a question of promises of/expectations against the core
> > device layer. It must be known if for a shut down device there is (and
> > should be) a possibility that .remove is called. Depending on that
> > device drivers must be ready for this to happen, or can rely on it not
> > to happen.
> > 
> > From a global maintenance POV it would be good if it could not happen,
> > because then the complexity is concentrated to a small place (i.e. the
> > driver core, or maybe generic code in all subsystems) instead of making
> > each and every driver robust to this possible event that a considerable
> > part of the driver writers isn't aware of.
> 
> IMO, if you can not offer a solid promise but merely a fragile one, then
> it is always better to be robust (which DSA now is). How would you
> propose that this particular promise could be fulfilled? Simply patch
> the known offending drivers today and hope more drivers won't do this in
> the future? Patching the device core to keep track of which devices
> were shut down, so as to not call into their ->remove method?
> Mind you, this issue was reported as a bug and had to be dealt with
> locally, for stable kernels, so changing the driver core was not an
> option.

Fix things properly first, in Linus's tree, and then worry about stable
kernels.  Never the other way around please.

thanks,

greg k-h

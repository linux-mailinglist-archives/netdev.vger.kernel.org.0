Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F10F515F56
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 18:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383179AbiD3QwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 12:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383169AbiD3QwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 12:52:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2142D98F43;
        Sat, 30 Apr 2022 09:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dF1mmmBFDNP9HWUd+hs6Y1pIJYTO0dyqrecodlt1PlQ=; b=cPQi1qAZcGQGUaPBAA7ghyhZsu
        Kcj5E+qhh+Ka31F5l28xtkVKVJQ3WGtzmP+mAt3Y6l3OkZav8CDmsVKs26eQRc6xgABrD2gBmgQdz
        O/KxPtyROLauJBpg8XWEecq5bH+Q0Y6kq4adMNJrmbbRYSFsIZ3ilsdZK+dsnFTKkWv4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkqGq-000eX6-Uo; Sat, 30 Apr 2022 18:48:36 +0200
Date:   Sat, 30 Apr 2022 18:48:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] net: phy: fix motorcomm module automatic loading
Message-ID: <Ym1oZCUdE2+PTyFZ@lunn.ch>
References: <20220228233057.1140817-1-pgwipeout@gmail.com>
 <Yh1lboz7VDiuYuZV@shell.armlinux.org.uk>
 <CAMdYzYrNvUUMom4W4uD9yf9LtFK1h5Xw+9GYc54hB5+iqVmJtw@mail.gmail.com>
 <CAMdYzYrFuMw4aj_9L698ZhL7Xqy8=NeXhy9HDz4ug-v3=f4fpw@mail.gmail.com>
 <Ym1bWHNj0p6L9lY8@lunn.ch>
 <CAMdYzYq41TndbJK-=ah31=vECisgRbPmtFYwOLQQ7yn4L=JVYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdYzYq41TndbJK-=ah31=vECisgRbPmtFYwOLQQ7yn4L=JVYw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 12:31:27PM -0400, Peter Geis wrote:
> On Sat, Apr 30, 2022 at 11:52 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Good Morning,
> > >
> > > After testing various configurations I found what is actually
> > > happening here. When libphy is built in but the phy drivers are
> > > modules and not available in the initrd, the generic phy driver binds
> > > here. This allows the phy to come up but it is not functional.
> >
> > What MAC are you using?
> 
> Specifically Motorcomm, but I've discovered it can happen with any of
> the phy drivers with the right kconfig.
> 
> >
> > Why is you interface being brought up by the initramfs? Are you using
> > NFS root from within the initramfs?
> 
> This was discovered with embedded programming. It's common to have a
> small initramfs, or forgo an initramfs altogether.

Yes, i do that all the time. But then it is up to me to ensure i have
all the code i need built into the kernel.

> Another cause is a
> mismatch in kernel config where phylib is built in because of a
> dependency, but the rest of the phy drivers are modular.
> The key is:
> - phylib is built in
> - ethernet driver is built in
> - the phy driver is a module
> - modules aren't available at probe time (for any reason).

This 'for any reason' is what i'm trying to get at. It is not the
kernel which builds the initramsfs. It is not the kernels problem if
the modules it needs are missing, it is my fault for not telling the
intramfs tools to include the modules needed to actually boot the
machine.

	 Andrew

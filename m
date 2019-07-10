Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 943AE6448B
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 11:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfGJJoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 05:44:06 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45042 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfGJJoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 05:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=j/WSDXca8rXK9NsDZMmI4ZGVD5lmMYmQNn9cX+c1P0c=; b=SuuW/7NN1z53N126yQd0mfU0n
        ntWsBeL22jFfrqe6UV7yYYjaWAb/mGvo82v/VpffWPeHAXC8qvHdMVqjvTeqQYorTqKjPyjcVkd0Y
        ehhidoReYAcrBOGYvK5hg+mxgyuD5Njr2SLIjID07Kvs0w8adz+Czb2UlD+NlXUjcnJQShORaFQ6X
        Xl3J1vYZGJzoNp6wHmHn8OimwqiNyO9IG6bSDFpjxItLMpKnIWdEU05QuowI2tkahamV/uty376Ez
        mf5JMQomwfeTQc+3SQ9pZj0NiYOkjfuIR3hSKUK/aQunmlQ7Q5KSFX7XpTfFzFgMc9EjJ+4N1wSfg
        nEpyIjNkA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:59340)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hl98c-0005tt-RN; Wed, 10 Jul 2019 10:43:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hl98T-0003nw-5z; Wed, 10 Jul 2019 10:43:37 +0100
Date:   Wed, 10 Jul 2019 10:43:37 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Andrew Jeffery <andrew@aj.id.au>, openbmc@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 00/12] treewide: Fix GENMASK misuses
Message-ID: <20190710094337.wf2lftxzfjq2etro@shell.armlinux.org.uk>
References: <cover.1562734889.git.joe@perches.com>
 <5fa1fa6998332642c49e2d5209193ffe2713f333.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fa1fa6998332642c49e2d5209193ffe2713f333.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 11:17:31AM +0200, Johannes Berg wrote:
> On Tue, 2019-07-09 at 22:04 -0700, Joe Perches wrote:
> > These GENMASK uses are inverted argument order and the
> > actual masks produced are incorrect.  Fix them.
> > 
> > Add checkpatch tests to help avoid more misuses too.
> > 
> > Joe Perches (12):
> >   checkpatch: Add GENMASK tests
> 
> IMHO this doesn't make a lot of sense as a checkpatch test - just throw
> in a BUILD_BUG_ON()?

My personal take on this is that GENMASK() is really not useful, it's
just pure obfuscation and leads to exactly these kinds of mistakes.

Yes, I fully understand the argument that you can just specify the
start and end bits, and it _in theory_ makes the code more readable.

However, the problem is when writing code.  GENMASK(a, b).  Is a the
starting bit or ending bit?  Is b the number of bits?  It's confusing
and causes mistakes resulting in incorrect code.  A BUILD_BUG_ON()
can catch some of the cases, but not all of them.

For example:

	GENMASK(6, 2)

would satisify the requirement that a > b, so a BUILD_BUG_ON() will
not trigger, but was the author meaning 0x3c or 0xc0?

Personally, I've decided I am _not_ going to use GENMASK() in my code
because I struggle to get the macro arguments correct - I'm _much_
happier, and it is way more reliable for me to write the mask in hex
notation.

I think this is where use of a ternary operator would come in use.  The
normal way of writing a number of bits tends to be "a:b", so if GENMASK
took something like GENMASK(6:2), then I'd have less issue with it,
because it's argument is then in a familiar notation.

Yes, I'm sure that someone will point out that the GENMASK arguments
are just in the same order, but that doesn't prevent _me_ frequently
getting it wrong - and that's the point.  The macro seems to me to
cause more problems than it solves.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

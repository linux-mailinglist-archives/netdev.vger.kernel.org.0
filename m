Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E0A466C19
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 23:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347626AbhLBW3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 17:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbhLBW3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 17:29:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8C4C06174A;
        Thu,  2 Dec 2021 14:25:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8D1BB823B7;
        Thu,  2 Dec 2021 22:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993A4C00446;
        Thu,  2 Dec 2021 22:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638483956;
        bh=0+Mg8nsTOEQB6tzTrGjT/i6FyixKR5q4N6cf+qu/xZ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HBD+Im3pC1fVCc2MzSVAm5zUEt6SiQyX4j8KJW9KyTEfPJSs6A1RrXbYWD55unHIC
         pHYZ8QguNfPMGe/iKPJEv/gFA2H9wKZN65PcIS5qJH7WpzOJhNJwvqCkmfpDgGZ6vf
         eJNUDUC8uKumOS0tsrs5ZGwdtLqCJJhJGbjudM1tW7y/jTs/U3ClyjxS+uc6JJ5Wiw
         CUgpXYKsSjiSf/d65XtQ0htWVYP7RICxINWBYZIKhteZ7gzfQYEFsgscxk9ng+xfgR
         QWMjHBGncFzqa+TxW/npXu8ulUZk9sfiwp8t3LKfekT546154jr8YhxqxmyA6beozT
         Qcmd75c4OtA0g==
Date:   Thu, 2 Dec 2021 23:25:50 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net
Subject: Re: [PATCH net-next v2 4/8] net: phylink: update
 supported_interfaces with modes from fwnode
Message-ID: <20211202232550.05bda788@thinkpad>
In-Reply-To: <20211124123135.wn4lef5iv2k26txb@skbuf>
References: <20211123164027.15618-1-kabel@kernel.org>
        <20211123164027.15618-5-kabel@kernel.org>
        <20211123212441.qwgqaad74zciw6wj@skbuf>
        <20211123232713.460e3241@thinkpad>
        <20211123225418.skpnnhnrsdqrwv5f@skbuf>
        <YZ4cRWkEO+l1W08u@shell.armlinux.org.uk>
        <20211124120441.i7735czjm5k3mkwh@skbuf>
        <20211124131703.30176315@thinkpad>
        <20211124123135.wn4lef5iv2k26txb@skbuf>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 14:31:35 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> > > To err is human, of course. But one thing I think we learned from the
> > > old implementation of phylink_validate is that it gets very tiring to
> > > keep adding PHY modes, and we always seem to miss some. When that array
> > > will be described in DT, it could be just a tad more painful to maintain.  
> > 
> > The thing is that we will still need the `phy-mode` property, it can't
> > be deprecated IMO.  
> 
> Wait a minute, who said anything about deprecating it? I just said
> "let's not make it an array, in the actual device tree". The phy-mode
> was, and will remain, the initial MII-side protocol, which can or cannot
> be changed at runtime.

Hello Vladimir,

I was told multiple times that device-tree should not specify how the
software should behave (given multiple HW options). This has not been
always followed, but it is preferred.

Now the 'phy-mode' property, if interpreted as "the initial MII-side
protocol" would break this rule.

This is therefore another reason why it should either be extended to an
array, or, if we went with your proposal of 'num-lanes' + 'max-freq',
deprecated (at least for serdes modes). But it can't be deprecated
entirely, IMO (because of non serdes protocols).

I thought more about your proposal of 'num-lanes' + 'max-freq' vs
extending 'phy-mode'.

- 'num-lanes' + 'max-freq' are IMO closer to the idea of device-tree,
  since they describe exactly how the parts of the device are connected
  to each other
- otherwise I think your argument against extending 'phy-mode' because
  of people declaring support for modes that weren't properly tested and
  would later be found broken is invalid, since the same could happen
  for 'num-lanes' + 'max-freq' properties
- the 'phy-mode' property already exists. I think if we went with the
  'num-lanes' + 'max-freq' proposal, we would need to deprecate
  'phy-mode' for serdes protocols (at least for situations where
  multiple modes can be used, since then 'phy-mode' would go against
  the idea of the rule I mentioned in first paragraph)

Vladimir, Rob has now given R-B for the 'phy-mode' extension patch.

I am wondering now what to do, since other people haven't given their
opinions here. Whether to re-send the series, and maybe start discussing
there, or waiting more.

Marek

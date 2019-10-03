Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750E6CAFCD
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388309AbfJCUKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:10:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60002 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729586AbfJCUKh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 16:10:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tpO9JQw9LwdGyrTWiChnFSocandDrz0TY56FAH9aAjA=; b=lj10O4WyQdAQekmUjD3MR+qyb9
        JGX/rWu+TGRPnCOvCe3PUnmkT4Frfr1gWik+b2j6gTbNWxl7IeUL+CheScDKmYhCYiGhNfpAAE/Mn
        Nwl8RgpFMbTg2z0VhAM7HEGc/M88z4vvzQhg2dnvLzYos6KMZYdHKUAGwc1mHJOMhWgc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iG7Qo-0006GM-LO; Thu, 03 Oct 2019 22:10:34 +0200
Date:   Thu, 3 Oct 2019 22:10:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        manasa.mudireddy@broadcom.com, ray.jui@broadcom.com,
        rafal@milecki.pl
Subject: Re: [PATCH 0/2] net: phy: broadcom: RGMII delays fixes
Message-ID: <20191003201034.GF21875@lunn.ch>
References: <20191003184352.24356-1-f.fainelli@gmail.com>
 <20191003185116.GA21875@lunn.ch>
 <0d5e4195-c407-2915-de96-3c4b3713ada0@gmail.com>
 <20191003190651.GB21875@lunn.ch>
 <CA+h21hp0-zdJjt+dXkp0ZjZk5wG64kwPV01Js3cPMNS9qySqGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hp0-zdJjt+dXkp0ZjZk5wG64kwPV01Js3cPMNS9qySqGQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 10:54:26PM +0300, Vladimir Oltean wrote:
> Hi Andrew,
> 
> On Thu, 3 Oct 2019 at 22:06, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Thu, Oct 03, 2019 at 11:55:40AM -0700, Florian Fainelli wrote:
> > > Hi Andrew,
> > >
> > > On 10/3/19 11:51 AM, Andrew Lunn wrote:
> > > > On Thu, Oct 03, 2019 at 11:43:50AM -0700, Florian Fainelli wrote:
> > > >> Hi all,
> > > >>
> > > >> This patch series fixes the BCM54210E RGMII delay configuration which
> > > >> could only have worked in a PHY_INTERFACE_MODE_RGMII configuration.
> > > >
> > > > Hi Florian
> > > >
> > > > So any DT blob which incorrectly uses one of the other RGMII modes is
> > > > now going to break, where as before it was ignored.
> > >
> > > Potentially yes. There is a precedent with the at803x PHY driver
> >
> > Hi Florian
> >
> > Yes that was an interesting learning experience. I'm not sure we want
> > to do that again. A lot of devices broken, and a lot of people were
> > unhappy.
> >
> > If we are looking at a similar scale of breakage, i think i would
> > prefer to add a broadcom,bcm54210e-phy-mode property in the DT which
> > if present would override the phy_interface_t passed to the driver.
> >
> >    Andrew
> 
> What is the breakage concern here?

With the at803x, we had a lot of devices which said rgmii in there DT,
but actually needed rgmii-id. The driver however did not do anything,
and the silicon defaulted to rgmii-id, so things just worked, the two
bugs cancelling each other out.

Then a board come along which really did need rgmii. Adding support to
actually correctly configure the RGMII delays then broke all the
boards with the wrong value in DT.

> But in this case, the only breakage would be "hmmm, let's just enable
> RGMII delays everywhere. So it works with rgmii-id on both the PHY and
> the MAC side of things? Great, time for lunch!". I just hope that did
> not happen.

That is my hope as well. But letting it sit in net-next for a while
might help confirm that hope. As i said, at803x was painful, and i
would like to avoid that again. So i'm being more cautious.

      Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59402322BBD
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 14:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhBWNyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 08:54:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229886AbhBWNyS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 08:54:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 332CD64DBD;
        Tue, 23 Feb 2021 13:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614088417;
        bh=iC+DgKr7bNJFm/2RCPxrXSkZ+QAYNIbWqrFQAEW25Qc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lPLLx8YS97rViZelcC8uKRfa1j4HTlb1BDuAPafMDEuVWwNy0t/Mct6w3hQ1eT3+G
         qYkoBm+tHhW34haK0FkzDHWJwAtuOheI+OVzWretFm+1I5y1qgWnuGmKadOQ3hD2Vn
         aCB8rFx//afOkiuaxoxzYq4AokAf2AxvzypBveNgkwJEHtbPqrd8nya1aJU/21cCc1
         KPI+hWF06hxmwHRZkFYkzmQHDmg3jUXJGy5k/BpZ2UkI6bbWCho2aAratAcd5eJcWu
         oLIbKXNc0MU7j+u6/fel8EydSFLh+ikd1YQHTCWQgBqS8V1wqXhkb3XF27r2t3C6cm
         WlKiBUebYPDzQ==
Date:   Tue, 23 Feb 2021 15:53:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        Vinod Koul <vkoul@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v15 2/4] phy: Add media type and speed serdes
 configuration interfaces
Message-ID: <YDUI3rYnNxhxiZem@unreal>
References: <20210218161451.3489955-1-steen.hegelund@microchip.com>
 <20210218161451.3489955-3-steen.hegelund@microchip.com>
 <YDH20a2hP+HtBqHz@unreal>
 <94dad8f439dd870b3488130e82f50e28b81fccf1.camel@microchip.com>
 <c1b78a32-de24-c036-5a7a-7ef297cc5e3a@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1b78a32-de24-c036-5a7a-7ef297cc5e3a@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 05:52:14PM +0530, Kishon Vijay Abraham I wrote:
> Hi Leon,
>
> On 22/02/21 1:30 pm, Steen Hegelund wrote:
> > Hi Leon,
> >
> > On Sun, 2021-02-21 at 07:59 +0200, Leon Romanovsky wrote:
> >> EXTERNAL EMAIL: Do not click links or open attachments unless you
> >> know the content is safe
> >>
> >> On Thu, Feb 18, 2021 at 05:14:49PM +0100, Steen Hegelund wrote:
> >>> Provide new phy configuration interfaces for media type and speed
> >>> that
> >>> allows e.g. PHYs used for ethernet to be configured with this
> >>> information.
> >>>
> >>> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> >>> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> >>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> >>> Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> >>> ---
> >>>
> >
> > ...
> >
> >>>  int phy_validate(struct phy *phy, enum phy_mode mode, int submode,
> >>>                union phy_configure_opts *opts);
> >>> @@ -344,6 +356,20 @@ static inline int phy_set_mode_ext(struct phy
> >>> *phy, enum phy_mode mode,
> >>>  #define phy_set_mode(phy, mode) \
> >>>       phy_set_mode_ext(phy, mode, 0)
> >>>
> >>> +static inline int phy_set_media(struct phy *phy, enum phy_media
> >>> media)
> >>> +{
> >>> +     if (!phy)
> >>> +             return 0;
> >>
> >> I'm curious, why do you check for the NULL in all newly introduced
> >> functions?
> >> How is it possible that calls to phy_*() supply NULL as the main
> >> struct?
> >>
> >> Thanks
> >
> > I do not know the history of that, but all the functions in the
> > interface that takes a phy as input and returns a status follow that
> > pattern.  Maybe Kishon and Vinod knows the origin?
>
> It is to make handling optional PHYs simpler. See here for the origin :-)
> http://lore.kernel.org/r/1391264157-2112-1-git-send-email-andrew@lunn.ch

Thanks for the pointer, it is good to know.
I personally would do it differently, but whatever.

>
> Thanks
> Kishon
> >
> >>
> >>> +     return -ENODEV;
> >>> +}
> >>> +
> >>> +static inline int phy_set_speed(struct phy *phy, int speed)
> >>> +{
> >>> +     if (!phy)
> >>> +             return 0;
> >>> +     return -ENODEV;
> >>> +}
> >>> +
> >>>  static inline enum phy_mode phy_get_mode(struct phy *phy)
> >>>  {
> >>>       return PHY_MODE_INVALID;
> >>> --
> >>> 2.30.0
> >>>
> >
> > Best Regards
> > Steen
> >

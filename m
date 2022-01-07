Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D771F486F1C
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344650AbiAGAxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344587AbiAGAxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:53:24 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A59DC061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:53:24 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id h2so9792570lfv.9
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 16:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rwxwWFrjDSZQUe0M4/3egAxzKkKqMvuwG2OMBkXw73g=;
        b=UFIe1Has5fy2ZguYtNmCloC/KRNUHne7gacyY0vE2VGFzFt3Ov1z34CoJXsuKL1gQr
         7M1RYx1pr1u9dukjEshKfU2Zi+4bw8FatPIFYvW+ejGtAYiSXbDEVTYxP8RqtqwEmBww
         8ZNqAK92Aw40dnn34lWorm4pYAOfwPZgBQo9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rwxwWFrjDSZQUe0M4/3egAxzKkKqMvuwG2OMBkXw73g=;
        b=uD+BjKZxGWsiAr+aIs+qvuax7vmZPWcNMxXMtuM01ecGSnVdMvMfMId/hANHNuRbD9
         oO7O0ps+K4u9akLCLYU0jAzsLxk9Og4caOnylSn3or9zpfT1iDSzH42X/up8IqlwDgJe
         IArK/oVpoPuF+8PoqG8nWUMv2ZA2x/VCnV1bPeiJpCVh1SZL5KH6DeWUKpTL4s0lAi1Y
         2/RZM+ziGG4twDrjHBrd0gwGSD1Jv394hG96P1mlMiRYr7HRWyoatb2bVtfMznBMV43N
         9HHbeC2j0wRgidsl0a7dMX5TJMXbh0txnZGhR8xZnrdB24kFtxK+pw6638EOs9Vf86A5
         uasg==
X-Gm-Message-State: AOAM532Y7nobTQTI8ZTO9phP84J2ut79oCh5Vf5Bv/mP3s7A9T+LS6nA
        yQP81M5vFR7nmDzB82nkRuLoImhRD8+EEHMpwfSaRqg/F9E=
X-Google-Smtp-Source: ABdhPJyUHnWMYkfP4kRV6W9FF5R1hTeaRzrj976oOaWnoXi7nmbLwEL39Ku2RW7hB9/j/HEuu+VKxhWLWWiAB+z43hU=
X-Received: by 2002:ac2:511b:: with SMTP id q27mr54393399lfb.69.1641516802724;
 Thu, 06 Jan 2022 16:53:22 -0800 (PST)
MIME-Version: 1.0
References: <20220104064657.2095041-1-dmichail@fungible.com>
 <20220104064657.2095041-4-dmichail@fungible.com> <20220104180739.572a80ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOkoqZmxHZ6KTZQPe+w23E_UPYWLNRiU8gVX32EFsNXgyzkucg@mail.gmail.com> <YdXDVakWSkQyvlqe@lunn.ch>
In-Reply-To: <YdXDVakWSkQyvlqe@lunn.ch>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 6 Jan 2022 16:53:08 -0800
Message-ID: <CAOkoqZkCkyiGbUx--zY67GF05Y_XxuW6APKaqYu8F_nR9Qu7Kg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/8] net/funeth: probing and netdev ops
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 8:12 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > > +     if ((notif->link_state | notif->missed_events) & FUN_PORT_FLAG_MAC_DOWN)
> > > > +             netif_carrier_off(netdev);
> > > > +     if (notif->link_state & FUN_PORT_FLAG_NH_DOWN)
> > > > +             netif_dormant_on(netdev);
> > > > +     if (notif->link_state & FUN_PORT_FLAG_NH_UP)
> > > > +             netif_dormant_off(netdev);
> > >
> > > What does this do?
> >
> > FW may get exclusive access to the ports in some cases and during those times
> > host traffic isn't serviced. Changing a port to dormant is its way of
> > telling the host
> > the port is unavailable though it has link up.
>
> Quoting RFC2863
>
> 3.1.12.  New states for IfOperStatus
>
>    Three new states have been added to ifOperStatus: 'dormant',
>    'notPresent', and 'lowerLayerDown'.
>
>    The dormant state indicates that the relevant interface is not
>    actually in a condition to pass packets (i.e., it is not 'up') but is
>    in a "pending" state, waiting for some external event.  For "on-
>    demand" interfaces, this new state identifies the situation where the
>    interface is waiting for events to place it in the up state.
>    Examples of such events might be:
>
>    (1)   having packets to transmit before establishing a connection to
>          a remote system;
>
>    (2)   having a remote system establish a connection to the interface
>          (e.g. dialing up to a slip-server).
>
> I can see this being valid if your FW is doing 802.1X. But i'm not
> sure it is valid for other use cases. What exactly is your firmware
> doing which stops it from handling frames?

The downtime happens occasionally after link up while the internal
control processor is configuring the network units. So internal setup
delays. I am told that "in the near future" the need for this will be
removed. Trusting that near will be reasonable I'll remove this now.

>
>         Andrew

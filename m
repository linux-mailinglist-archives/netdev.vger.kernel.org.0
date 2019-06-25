Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEBC551C5
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 16:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730689AbfFYOez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 10:34:55 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:36726 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728710AbfFYOez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 10:34:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hfmWu-0005ft-Of; Tue, 25 Jun 2019 16:34:40 +0200
Message-ID: <f1243295f088b70d48e4b832a28f79c0cd84ca1c.camel@sipsolutions.net>
Subject: Re: WWAN Controller Framework (was IPA [PATCH v2 00/17])
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, arnd@arndb.de,
        bjorn.andersson@linaro.org, ilias.apalodimas@linaro.org,
        Dan Williams <dcbw@redhat.com>
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Date:   Tue, 25 Jun 2019 16:34:38 +0200
In-Reply-To: <6dae9d1c-ceae-7e88-fe61-f4cda82820ea@linaro.org> (sfid-20190624_190620_354118_89F0D47F)
References: <20190531035348.7194-1-elder@linaro.org>
         <23ff4cce-1fee-98ab-3608-1fd09c2d97f1@linaro.org>
         <6dae9d1c-ceae-7e88-fe61-f4cda82820ea@linaro.org>
         (sfid-20190624_190620_354118_89F0D47F)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-24 at 12:06 -0500, Alex Elder wrote:

> > OK I want to try to organize a little more concisely some of the
> > discussion on this, because there is a very large amount of volume
> > to date and I think we need to try to narrow the focus back down
> > again.

Sounds good to me!

> > I'm going to use a few terms here.  Some of these I really don't
> > like, but I want to be unambiguous *and* (at least for now) I want
> > to avoid the very overloaded term "device".
> > 
> > I have lots more to say, but let's start with a top-level picture,
> > to make sure we're all on the same page.
> > 
> >          WWAN Communication
> >          Channel (Physical)
> >                  |     ------------------------
> > ------------     v     |           :+ Control |  \
> > >          |-----------|           :+ Data    |  |
> > >    AP    |           | WWAN unit :+ Voice   |   > Functions
> > >          |===========|           :+ GPS     |  |
> > 
> > ------------     ^     |           :+ ...     |  /
> >                  |     -------------------------
> >           Multiplexed WWAN
> >            Communication
> >          Channel (Physical)

Sounds right to me. I'm not sure if you're distinguishing here between
the "Data function" and multiple data channels to the data function, but
at this point I guess it doesn't matter.

> > - The *AP* is the main CPU complex that's running Linux on one or
> >   more CPU cores.
> > - A *WWAN unit* is an entity that shares one or more physical
> >   *WWAN communication channels* with the AP.
> > - A *WWAN communication channel* is a bidirectional means of
> >   carrying data between the AP and WWAN unit.
> > - A WWAN communication channel carries data using a *WWAN protocol*.
> > - A WWAN unit implements one or more *WWAN functions*, such as
> >   5G data, LTE voice, GPS, and so on.
> > - A WWAN unit shall implement a *WWAN control function*, used to
> >   manage the use of other WWAN functions, as well as the WWAN unit
> >   itself.

I think here we need to be more careful. I don't know how you want to
call it, but we actually have multiple levels of control here.

You have
 * hardware control, to control how you actually use the (multiple or
   not) physical communication channel(s) to the WWAN unit
 * this is partially exposed to userspace via the WWAN netlink family or
   something like that, so userspace can create new netdevs to tx/rx
   with the "data function" and to the network; note that it could be
   one or multiple
 * WWAN control, which is typically userspace communicating with the
   WWAN control function in the WWAN unit, but this can take different
   forms (as I mentioned earlier, e.g. AT commands, MBIM, QMI)

> > - The AP communicates with a WWAN function using a WWAN protocol.

Right, that's just device specific (IPA vs. Intel vs. ...)

> > - A WWAN physical channel can be *multiplexed*, in which case it
> >   carries the data for one or more *WWAN logical channels*.

This ... depends a bit on how you exactly define a physical channel
here. Is that, to you, the PCIe/USB link? In that case, yes, obviously
you have only one physical channel for each WWAN unit.

However, I'd probably see this slightly differently, because e.g. the
Intel modem has multiple DMA engines, and so you actually have multiple
DMA rings to talk to the WWAN unit, and I'd have called each DMA ring a
physical channel. And then, you just have a 1:1 from physical to logical
channel since it doesn't actually carry a multiplexing protocol.

> > - A multiplexed WWAN communication channel uses a *WWAN wultiplexing
> >   protocol*, which is used to separate independent data streams
> >   carrying other WWAN protocols.

Like just described, this isn't really needed and is a device-specific
property.

> > - A WWAN logical channel carries a bidirectional stream of WWAN
> >   protocol data between an entity on the AP and a WWAN function.
> > 
> > Does that adequately represent a very high-level picture of what
> > we're trying to manage?

Pretty much.

I only disagree slightly on the control planes (there are multiple, and
multiple options for the "Control function" one), and on the whole
notion of physical link/logical link/multiplexing which is device
specific.

> > And if I understand it right, the purpose of the generic framework
> > being discussed is to define a common mechanism for managing (i.e.,
> > discovering, creating, destroying, querying, configuring, enabling,
> > disabling, etc.) WWAN units and the functions they implement, along
> > with the communication and logical channels used to communicate with
> > them.

Well, some subset of that matrix, the framework won't actually destroy
WWAN units I hope ;-)

But yes. I'd probably captured it in layers, and say that we have a

WWAN framework layer
 - discover, query, configure WWAN units
 - enable, disable channels to the functions inside the WWAN units

WWAN device driver
 - implement (partial) API offered by WWAN framework layer to allow
   these things
   (sometimes may not allow creating more control or data channels for
   example, and fixed function channels are precreated, but then can
   still discover data about the device and configure the channels
 - implement the device-specific protocols etc. necessary to achieve
   this

Userspace
 - uses control function channel (e.g. TTY) to talk directly to the WWAN
   unit's control function
 - uses WWAN framework APIs to create/configure/... (other) function
   channels
   (it may be necessary to create a control channel even, before being
   able to use it, since different options (AT/MBIM/QMI) may be there
 - configures netdevs (data function channels) after their creation

johannes


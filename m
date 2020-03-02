Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E30C175B27
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 14:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgCBNGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 08:06:21 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56524 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgCBNGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 08:06:20 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j8klz-009qc6-MW; Mon, 02 Mar 2020 14:06:15 +0100
Message-ID: <994a47b89df306d3ce126655805d9c163cd5daa0.camel@sipsolutions.net>
Subject: Re: [RFC] wwan: add a new WWAN subsystem
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Alex Elder <elder@linaro.org>, m.chetan.kumar@intel.com,
        Dan Williams <dcbw@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Date:   Mon, 02 Mar 2020 14:06:14 +0100
In-Reply-To: <20200225151521.GA7663@lunn.ch>
References: <20200225100053.16385-1-johannes@sipsolutions.net>
         <20200225105149.59963c95aa29.Id0e40565452d0d5bb9ce5cc00b8755ec96db8559@changeid>
         <20200225151521.GA7663@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

To completely my response here, sorry for the delay.

> Looking at it bottom up, is the WWAN device itself made up of multiple
> devices? Are the TTYs separate drivers to the packet moving engines?
> They have there own USB end points, and could just be standard CDC
> ACM?

Depends on the device, must often yes; Yes and yes.

In fact, they _are_ often just the standard drivers, so sometimes you
don't even know if that thing is part of the modem or not, without
further out-of-band information.

For the netdevs that was partially solved by USB ID matching and netdev
"wwan" type.

> driver/base/component.c could be useful for bringing together these
> individual devices to form the whole WWAN device. This is often used
> for graphics drivers, where there can be i2c devices, display pipeline
> devices, acceleration drivers etc, which each probe separately, but
> need to be brought together to form a gpu driver as a whole.

I looked at this now, but ... Hmm. It's not really clear that really is
usable directly.

The component framework really wants to have a 'master' and a bunch of
'components', whereas in the WWAN case you don't really have a master,
necessarily? Each part _may_ contribute something to the overall
picture, but it could also just be one of those ACM drivers that doesn't
really know if it's part of a modem or not, so it just tentatively adds
something without knowing if there will even _be_ an overall WWAN
device.

Also, I don't think a WWAN device is necessarily "done" at some point.
It may be, for example, that the netdev sub-device knows that it's part
of a modem so it registers "yes I know this is a modem", but then the
other pieces are only discovered later, without knowing what they might
even be. Could be that they aren't, however, but even then the WWAN
device would still exist and be useful to some extent.

I don't see a way of expressing any of this with the component
framework. Yes, all of the pieces could register there, but then why
should any particular one of them register as a component master? That
would at the very least have to be hidden under some other abstraction,
but even if it is, it's not clear that we might not - in the future, not
in my code now - have some sort of "if there are certain pieces that we
know belong together then it must be a modem" logic...

And once it decided that it's "done" (a master is 'bound'), the
component framework will not add further components to a master or
similar, and it doesn't really seem suited to doing that either.

> Plus you need to avoid confusion by not adding another "component
> framework" which means something totally different to the existing
> component framework.

Fair point. I guess I can rename this somehow, or clarify the
differences in the code.

johannes


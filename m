Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B683390162
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 14:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhEYM4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 08:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbhEYM4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 08:56:43 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DA3C061574;
        Tue, 25 May 2021 05:55:13 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1llWaU-00EOe9-9l; Tue, 25 May 2021 14:55:10 +0200
Message-ID: <c7d2dd39e82ada5aa4e4d6741865ecb1198959fe.camel@sipsolutions.net>
Subject: Re: [PATCH V3 15/16] net: iosm: net driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>, Dan Williams <dcbw@redhat.com>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 25 May 2021 14:55:09 +0200
In-Reply-To: <CAMZdPi_VbLcbVA34Bb3uBGDsDCkN0GjP4HmHUbX95PF9skwe2Q@mail.gmail.com> (sfid-20210525_101545_116148_0A5A9BB6)
References: <20210520140158.10132-1-m.chetan.kumar@intel.com>
         <20210520140158.10132-16-m.chetan.kumar@intel.com>
         <CAMZdPi-Xs00vMq-im_wHnNE5XkhXU1-mOgrNbGnExPbHYAL-rw@mail.gmail.com>
         <90f93c17164a4d8299d17a02b1f15bfa@intel.com>
         <CAMZdPi_VbLcbVA34Bb3uBGDsDCkN0GjP4HmHUbX95PF9skwe2Q@mail.gmail.com>
         (sfid-20210525_101545_116148_0A5A9BB6)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-05-25 at 10:24 +0200, Loic Poulain wrote:
> > 

> > Can you please share us more details on wwan_core changes(if any)/how we should
> > use /sys/class/wwan0 for link creation ?
> 
> Well, move rtnetlink ops to wwan_core (or wwan_rtnetlink), and parse
> netlink parameters into the wwan core. Add support for registering
> `wwan_ops`, something like:
> wwan_register_ops(wwan_ops *ops, struct device *wwan_root_device)
> 
> The ops could be basically:
> struct wwan_ops {
>     int (*add_intf)(struct device *wwan_root_device, const char *name,
> struct wwan_intf_params *params);
>     int (*del_intf) ...
> }
> 
> Then you could implement your own ops in iosm, with ios_add_intf()
> allocating and registering the netdev as you already do.
> struct wwan_intf_params would contain parameters of the interface,
> like the session_id (and possibly extended later with others, like
> checksum offload, etc...).
> 
> What do you think?

Note that I kind of tried this in my version back when:

https://lore.kernel.org/netdev/20200225105149.59963c95aa29.Id0e40565452d0d5bb9ce5cc00b8755ec96db8559@changeid/#Z30include:net:wwan.h

See struct wwan_component_device_ops.

I had a different *generic* netlink family rather than rtnetlink ops,
but that's mostly an implementation detail. I tend to like genetlink
better, but having rtnetlink makes it easier in iproute2 (though it has
some generic netlink code too, of course.)

Nobody really seemed all that interested back then.

And frankly, I'm really annoyed that while all of this played out we let
QMI enter the tree with their home-grown stuff (and dummy netdevs,
FWIW), *then* said the IOSM driver has to go to rtnetlink ops like them,
instead of what older drivers are doing, and *now* are shifting
goalposts again towards something like the framework I started writing
early on for the IOSM driver, while the QMI driver was happening, and
nobody cared ...

Yeah, life's not fair and all that, but it does kind of feel like
arbitrary shifting of the goal posts, while QMI is already in tree. Of
course it's not like we have a competition with them here, but having
some help from there would've been nice. Oh well.

Not that I disagree with any of this, it does technically make sense.

However, I think at this point it'd be good to see some comments here
from DaveM/Jakub that they're going to force Qualcomm to also go down
this route, because they're now *heavily* invested in their own APIs,
and inventing a framework just for the IOSM driver is fairly pointless.


> I also plan to submit a change to add a wwan_register_netdevice()
> function (similarly to WiFi cfg80211_register_netdevice), that could
> be used instead of register_netdevice(), basically factorizing wwan
> netdev registration (add "wwan" dev_type, add sysfs link to the 'wwan'
> device...).

Be careful with that, I tend to think we made some mistakes in this
area, look at the recent locking things there. We used to do stuff from
a netdev notifier, and that has caused all kinds of pain recently when I
reworked the locking to not be so overly dependent on the RTNL all the
time (which really has become the new BKL, at least for desktop work,
sometimes I can't even type in the UI when the RTNL is blocked). So
wwan_register_netdevice() is probably fine, doing netdev notifier I'd
now recommend against.
But in any case, that's just a side thread.

johannes


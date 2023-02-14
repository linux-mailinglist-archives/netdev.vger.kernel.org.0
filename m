Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38924696581
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbjBNN5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjBNN5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:57:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3263E93C3
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676382901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=83QmTK/OxRsSR+M63k5tbNt8PwWczCTZs++ini0mCYI=;
        b=JyKWwVHm/nAe/gW00iLAMqEoo5tkxB0/akdmdFSiL9bb8rGkT2UlN9HvVoiPG/X5Zq71r5
        r3y1wPTKPLzPnDRR/xfbLqoR44qy+18UKrT7OPDgVG7Il2bmzRrcFN6ssLrnx17qb/4zSV
        MYz1W0Msvrw9/9UpYg0EYYJqyPNrJ2A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-322-wCnszczbPVmL-qPVW6LiWQ-1; Tue, 14 Feb 2023 08:51:25 -0500
X-MC-Unique: wCnszczbPVmL-qPVW6LiWQ-1
Received: by mail-ed1-f71.google.com with SMTP id b16-20020a056402279000b004ace822b750so38540ede.20
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:51:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=83QmTK/OxRsSR+M63k5tbNt8PwWczCTZs++ini0mCYI=;
        b=gFu4YNwsKOvoiGTaNwjXi6uii7FMn2w0bh5Xuai/U6VpE8lmbvr1gv4AoI6HPDFbin
         lwFmNHcAU8lW3FDJVzUBTzk+H2NAI+RY3U8FJq466UDDfftYhfEwuVCS1mdmYEgsABVJ
         uQXjjU+MvJO7cXRmJnNPLXResA6799rjWjP3Gt9UEoWuteQty3Qesa9Zf3A+ZM4uhF0R
         9sdz5FiyvwSd3bqNPhAyeL2/guKk9mxKvXe6H1k7ovn3/6mOuYjwfIn6ew6i1XXKpMpc
         r7cPnaC+iTc8ewzErXG/apjcGukPJ8sfRBX9KHBZxVoUAvZxRy1mR88MJ3vbEAVqKiE4
         xKCQ==
X-Gm-Message-State: AO0yUKX/tqqu0U8pUEGfs0rGqXHPyUYvk7avJiqk0jQfY7G8ya3j7iZM
        Wlu2V8AYdtD/7Yd5i+xa/0BB/BaDAv1TGIOtpWbbyJ+6tUKoLxTxtLkQu+b5AeFO94wE41H1+Hg
        SAMVlf675OlYxfTLC0+xFPfOmihLjMC1w
X-Received: by 2002:a17:906:c30f:b0:87a:56fc:9df1 with SMTP id s15-20020a170906c30f00b0087a56fc9df1mr1325598ejz.3.1676382684307;
        Tue, 14 Feb 2023 05:51:24 -0800 (PST)
X-Google-Smtp-Source: AK7set9m576Bio3TX1Ux+Z0xR6qbElZ1ec1kFotbUaFTfhNVnakbneez3NE3Vl9TsjQMlTrfFEqdQL5gZPUtRd6ldnY=
X-Received: by 2002:a17:906:c30f:b0:87a:56fc:9df1 with SMTP id
 s15-20020a170906c30f00b0087a56fc9df1mr1325581ejz.3.1676382684065; Tue, 14 Feb
 2023 05:51:24 -0800 (PST)
MIME-Version: 1.0
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
 <20221129160046.538864-2-miquel.raynal@bootlin.com> <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
 <20230206101235.0371da87@xps-13> <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
 <20230210182129.77c1084d@xps-13> <CAK-6q+jLKo1bLBie_xYZyZdyjNB_M8JvxDfr77RQAY9WYcQY8w@mail.gmail.com>
 <20230213111553.0dcce5c2@xps-13>
In-Reply-To: <20230213111553.0dcce5c2@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 14 Feb 2023 08:51:12 -0500
Message-ID: <CAK-6q+jP55MaB-_ZbRHKESgEb-AW+kN3bU2SMWMtkozvoyfAwA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning requests
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Feb 13, 2023 at 5:16 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> > > > > > > +static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
> > > > > > > +{
> > > > > > > +       struct cfg802154_registered_device *rdev = info->user_ptr[0];
> > > > > > > +       struct net_device *dev = info->user_ptr[1];
> > > > > > > +       struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
> > > > > > > +       struct wpan_phy *wpan_phy = &rdev->wpan_phy;
> > > > > > > +       struct cfg802154_scan_request *request;
> > > > > > > +       u8 type;
> > > > > > > +       int err;
> > > > > > > +
> > > > > > > +       /* Monitors are not allowed to perform scans */
> > > > > > > +       if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
> > > > > > > +               return -EPERM;
> > > > > >
> > > > > > btw: why are monitors not allowed?
> > > > >
> > > > > I guess I had the "active scan" use case in mind which of course does
> > > > > not work with monitors. Maybe I can relax this a little bit indeed,
> > > > > right now I don't remember why I strongly refused scans on monitors.
> > > >
> > > > Isn't it that scans really work close to phy level? Means in this case
> > > > we disable mostly everything of MAC filtering on the transceiver side.
> > > > Then I don't see any reasons why even monitors can't do anything, they
> > > > also can send something. But they really don't have any specific
> > > > source address set, so long addresses are none for source addresses, I
> > > > don't see any problem here. They also don't have AACK handling, but
> > > > it's not required for scan anyway...
> > >
> > > I think I remember why I did not want to enable scans on monitors: we
> > > actually change the filtering level to "scan", which is very
> > > different to what a monitor is supposed to receive, which means in scan
> > > mode a monitor would no longer receive all what it is supposed to
> > > receive. Nothing that cannot be workaround'ed by software, probably,
> > > but I believe it is safer right now to avoid introducing potential
> > > regressions. So I will just change the error code and still refuse
> > > scans on monitor interfaces for now, until we figure out if it's
> > > actually safe or not (and if we really want to allow it).
> > >
> >
> > Okay, for scan yes we tell them to be in scan mode and then the
> > transceiver can filter whatever it delivers to the next level which is
> > necessary for filtering scan mac frames only. AACK handling is
> > disabled for scan mode for all types != MONITORS.
> >
> > For monitors we mostly allow everything and AACK is _always_ disabled.
> > The transceiver filter is completely disabled for at least what looks
> > like a 802.15.4 MAC header (even malformed). There are some frame
> > length checks which are necessary for specific hardware because
> > otherwise they would read out the frame buffer. For me it can still
> > feed the mac802154 stack for scanning (with filtering level as what
> > the monitor sets to, but currently our scan filter is equal to the
> > monitor filter mode anyway (which probably can be changed in
> > future?)). So in my opinion the monitor can do both -> feed the scan
> > mac802154 deliver path and the packet layer. And I also think that on
> > a normal interface type the packet layer should be feeded by those
> > frames as well and do not hit the mac802154 layer scan path only.
>
> Actually that would be an out-of-spec situation, here is a quote of
> chapter "6.3.1.3 Active and passive channel scan"
>
>         During an active or passive scan, the MAC sublayer shall
>         discard all frames received over the PHY data service that are
>         not Beacon frames.
>

Monitor interfaces are not anything that the spec describes, it is
some interface type which offers the user (mostly over AF_PACKET raw
socket) full phy level access with the _default_ options. I already
run user space stacks (for hacking/development only) on monitor
interfaces to connect with Linux 802.15.4 interfaces, e.g. see [0]
(newer came upstream, somewhere I have also a 2 years old updated
version, use hwsim not fakelb).

In other words, by default it should bypass 802.15.4 MAC and it still
conforms with your spec, just that it is in user space. However, there
exists problems to do that, but it kind of works for the most use
cases. I said here by default because some people have different use
cases of what they want to do in the kernel. e.g. encryption (so users
only get encrypted frames, etc.) We don't support that but we can,
same for doing a scan. It probably requires just more mac802154 layer
filtering.

There are enough examples in wireless that they do "crazy" things and
you can do that only with SoftMAC transceivers because it uses more
software parts like mac80211 and HardMAC transceivers only do what the
spec says and delivers it to the next layer. Some of them have more
functionality I guess, but then it depends on driver implementation
and a lot of other things.

Monitors also act as a sniffer device, but you _could_ also send
frames out and then the fun part begins.

> I don't think this is possible to do anyway on devices with a single
> hardware filter setting?
>

On SoftMAC it need to support a filtering level where we can disable
all filtering and get 802.15.4 MAC frames like it's on air (even
without non valid checksum, but we simply don't care if the
driver/transceiver does not support it we will always confirm it is
correct again until somebody comes around and say "oh we can do FCS
level then mac802154 does not need to check on this because it is
always correct")... This is currently the NONE filtering level I
think?

For HardMAC it is more complicated; they don't do that, they do the
"scan" operation on their transceiver and you can dump the result and
probably never forward any beacon related frames? (I had this question
once when Michael Richardson replied).

- Alex

[0] https://github.com/RIOT-OS/RIOT/pull/5582


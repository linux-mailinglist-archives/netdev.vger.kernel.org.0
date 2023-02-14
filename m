Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445B26964C7
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjBNNfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjBNNfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:35:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F92725B8C
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676381663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MvZADAbCTA+cClSnOGGVVovT4lpQyf9prX+qrygkfBU=;
        b=fI73J6Kh6PxZBZIuDvozLlJ5SFgrNw+yZ/bvudZxrsme1MYSqMLoOxK8fdjmNEHcBNrup+
        xX63Q0hqToSyzHn5C3Wp9/2twr4/Y5H2BuufzxR4E5+RIxNMRX2UMiqhLlOk8Xqbdgl/Uu
        sgyn/jsUuAbyWYJTesFuWWJt2TV5Fj0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-621-oBwIyj3LO2W1CipTgFbHbw-1; Tue, 14 Feb 2023 08:34:22 -0500
X-MC-Unique: oBwIyj3LO2W1CipTgFbHbw-1
Received: by mail-ed1-f72.google.com with SMTP id p36-20020a056402502400b004aab6614de9so9952134eda.6
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:34:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MvZADAbCTA+cClSnOGGVVovT4lpQyf9prX+qrygkfBU=;
        b=jstq4PWEZO++/EPnE1v9mejVW8tiO8WVNS+qRW/NSXRyYokAjsFmbGgDWsDjuy6QX1
         0qnB6xTQSidYcfZqeJyFv1kpKCQodTS+BSVW/+KCP1I4BTuoFrKnqljgrSu+SkX5lbtX
         ao1+B/Nmr1wo0kN1s6LcFvOwP3KcebU5BtG+IXJM+X+FpKy/3vsIT6z6MfWTDUNcBq3W
         1fHwokLPWdiBBe/WTFL+Rbm3XijwU6VwqgHYfHQ+Yn5VNFSvlkORGqRWR4qzoOQrJw1F
         T55+x7srPD9dBzCC2/oWbPSv4SXrafjuqeYqt732dmDUApmCPOswQYfE3er48uuwBm+T
         4Gvw==
X-Gm-Message-State: AO0yUKXfSJrtku8/p/u2Vq+UNiGQpE0z7WxGkat08iTJXelDUMrcw1Gp
        6BQc1M5uIBgsOB96YdYY2hM7SKfnS1VfHkgvXmA4GYXEo1h+nY3ou525afDnhc4jKOjQIACHt0+
        5HaIioCH/6KIQfu/BoGSGmV4o9YUhRfYY
X-Received: by 2002:a17:907:779a:b0:877:747d:4a85 with SMTP id ky26-20020a170907779a00b00877747d4a85mr1375923ejc.3.1676381661342;
        Tue, 14 Feb 2023 05:34:21 -0800 (PST)
X-Google-Smtp-Source: AK7set+ZWG763NCOydVlFc/1rFfhJk2S3HbKajVM3UOK9Orjafna55RQJfndhf6q9W7Bh8Ox6Apfh+UZ2ThZ5c88Uok=
X-Received: by 2002:a17:907:779a:b0:877:747d:4a85 with SMTP id
 ky26-20020a170907779a00b00877747d4a85mr1375905ejc.3.1676381661124; Tue, 14
 Feb 2023 05:34:21 -0800 (PST)
MIME-Version: 1.0
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
 <20221129160046.538864-2-miquel.raynal@bootlin.com> <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
 <20230206101235.0371da87@xps-13> <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
 <CAK-6q+jbcMZK16pfZTb5v8-jvhmvk9-USr6hZE34H1MOrpF=JQ@mail.gmail.com> <20230213183535.05e62c1c@xps-13>
In-Reply-To: <20230213183535.05e62c1c@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 14 Feb 2023 08:34:09 -0500
Message-ID: <CAK-6q+hkJpqNG9nO_ugngjGQ_q9VdLu+xDjmD09MT+5=tvd0QA@mail.gmail.com>
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Feb 13, 2023 at 12:35 PM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> > > > > > +static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
> > > > > > +{
> > > > > > +       struct cfg802154_registered_device *rdev = info->user_ptr[0];
> > > > > > +       struct net_device *dev = info->user_ptr[1];
> > > > > > +       struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
> > > > > > +       struct wpan_phy *wpan_phy = &rdev->wpan_phy;
> > > > > > +       struct cfg802154_scan_request *request;
> > > > > > +       u8 type;
> > > > > > +       int err;
> > > > > > +
> > > > > > +       /* Monitors are not allowed to perform scans */
> > > > > > +       if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
> > > > > > +               return -EPERM;
> > > > >
> > > > > btw: why are monitors not allowed?
> > > >
> > > > I guess I had the "active scan" use case in mind which of course does
> > > > not work with monitors. Maybe I can relax this a little bit indeed,
> > > > right now I don't remember why I strongly refused scans on monitors.
> > >
> > > Isn't it that scans really work close to phy level? Means in this case
> > > we disable mostly everything of MAC filtering on the transceiver side.
> > > Then I don't see any reasons why even monitors can't do anything, they
> > > also can send something. But they really don't have any specific
> > > source address set, so long addresses are none for source addresses, I
> > > don't see any problem here. They also don't have AACK handling, but
> > > it's not required for scan anyway...
> > >
> > > If this gets too complicated right now, then I am also fine with
> > > returning an error here, we can enable it later but would it be better
> > > to use ENOTSUPP or something like that in this case? EPERM sounds like
> > > you can do that, but you don't have the permissions.
> > >
> >
> > For me a scan should also be possible from iwpan phy $PHY scan (or
> > whatever the scan command is, or just enable beacon)... to go over the
> > dev is just a shortcut for "I mean whatever the phy is under this dev"
> > ?
>
> Actually only coordinators (in a specific state) should be able to send
> beacons, so I am kind of against allowing that shortcut, because there
> are usually two dev interfaces on top of the phy's, a regular "NODE"
> and a "COORD", so I don't think we should go that way.
>
> For scans however it makes sense, I've added the necessary changes in
> wpan-tools. The TOP_LEVEL(scan) macro however does not support using
> the same command name twice because it creates a macro, so this one
> only supports a device name (the interface command has kind of the same
> situation and uses a HIDDEN() macro which cannot be used here).
>

Yes, I was thinking about scanning only.

> So in summary here is what is supported:
> - dev <dev> beacon
> - dev <dev> scan trigger|abort
> - phy <phy> scan trigger|abort
> - dev <dev> scan (the blocking one, which triggers, listens and returns)
>
> Do you agree?
>

Okay, yes. I trust you.

- Alex


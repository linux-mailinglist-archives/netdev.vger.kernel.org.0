Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02DF67434F
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 21:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjASUJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 15:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjASUJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 15:09:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19EF94C8C
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 12:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674158920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PggIzfygRD9QgTxjyyjnr/C8VTVpVGfqEDvg752Zp0M=;
        b=eJSV+lBKb0BrTqp7ePQaetMiF4Hn8xErHrzIdDk3sA7jIoWYpPJRBpMBQn1qT+45VM1zhV
        fykm9tjU83RAdp+DFW3fNRv6ALbcbN2FBoqCgDVgAQwX1p6GcVO8cbTrx8WpWrVxFvpAju
        zqxB1w4/dfKEww8WHv4mgXBB1JVKrKc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-482-rhuwW2_KPLyfpaT3FBICzA-1; Thu, 19 Jan 2023 15:08:39 -0500
X-MC-Unique: rhuwW2_KPLyfpaT3FBICzA-1
Received: by mail-pj1-f71.google.com with SMTP id on9-20020a17090b1d0900b0022955c2f0f4so39407pjb.1
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 12:08:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PggIzfygRD9QgTxjyyjnr/C8VTVpVGfqEDvg752Zp0M=;
        b=N0ciguVAqmqEwrHVsEPRWpreZTPD8hfOFtIB5wZAcGoj+pCau/H4ZpV2SQ4HtbUK8n
         6d3FzzKS2ROC2Tg8Llz6EUyQZif8gC5cgUVPD3aK1v0kRmEQGxHye3nvyxUujwQHT6iq
         rRcKMjbO0f7KFX6rsH8yrETCOoxeLAiRhDJ86pwckOE/c9gGJx5g0Y+WeQAXsPA6Lk6P
         O4zLeoLZULe6ufahkpLd0OwdEAyislva4x1XAxKh/VInn6h/vt3kQNxAIN0kkqHrYnrX
         0WKXlXjrgFw4Z1mKx3QIpSGEE8MTGEWXksWbz3egb09lwl9q73UpjpyIK/VsH02KpOfJ
         Ke+g==
X-Gm-Message-State: AFqh2kpsnNyHtU+O4yLPT4aIhO4QerfbJksrbT6x+cO57JKANxgPGNDf
        0X25nc/nNQBaJ73cNuSVxXaZ3476DUN+ZqbS715s9Aofzy6zp7355b7FjG/hONETyxZ2Wq9iIa/
        6OeM//RruF4ClwKhkpviNhMGprbdefgLH
X-Received: by 2002:a17:90b:187:b0:226:f8dc:b230 with SMTP id t7-20020a17090b018700b00226f8dcb230mr1387623pjs.227.1674158917999;
        Thu, 19 Jan 2023 12:08:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtINLEsUn4AGw4oV584OPWe9mWjhWHelFifskuQ1poGCUHOYupjz59bzO972Ny1TiIOn7Hlp/JYMe1BV5mDjR0=
X-Received: by 2002:a17:90b:187:b0:226:f8dc:b230 with SMTP id
 t7-20020a17090b018700b00226f8dcb230mr1387616pjs.227.1674158917773; Thu, 19
 Jan 2023 12:08:37 -0800 (PST)
MIME-Version: 1.0
References: <20230117181533.2350335-1-neelx@redhat.com> <2bdeb975-6d45-67bb-3017-f19df62fe7af@intel.com>
 <CACjP9X-hKf8g2UqitV8_G7WQW7u6Js5EsCNutsAMA4WD7YYSwA@mail.gmail.com>
 <42e74619-f2d0-1079-28b1-61e9e17ae953@intel.com> <CACjP9X8SHZAd_+HSLJCxYxSRQuRmq3r48id13r17n2ehrec2YQ@mail.gmail.com>
 <820cf397-a99e-44d4-cf9e-3ad6876e4d06@intel.com> <CACjP9X_v9AFVNRgz2a-qJce+ZqR0TzRzyd4gPFufESoRXmCdJQ@mail.gmail.com>
 <423a29e2-886d-2c41-16d4-a8fca5537c2e@intel.com>
In-Reply-To: <423a29e2-886d-2c41-16d4-a8fca5537c2e@intel.com>
From:   Daniel Vacek <neelx@redhat.com>
Date:   Thu, 19 Jan 2023 21:08:01 +0100
Message-ID: <CACjP9X-Ab76We7SVie7rpyykvKjiPuNktWeVa9y3Wb6i6oo4mg@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] ice/ptp: fix the PTP worker retrying
 indefinitely if the link went down
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        Siddaraju <siddaraju.dh@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org
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

On Thu, Jan 19, 2023 at 8:25 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
> On 1/19/2023 1:38 AM, Daniel Vacek wrote:
> > On Wed, Jan 18, 2023 at 11:22 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
> >> On 1/18/2023 2:11 PM, Daniel Vacek wrote:
> >>> On Wed, Jan 18, 2023 at 9:59 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
> >>>> On 1/18/2023 7:14 AM, Daniel Vacek wrote:
> >>>> 1) request tx timestamp
> >>>> 2) timestamp occurs
> >>>> 3) link goes down while processing
> >>>
> >>> I was thinking this is the case we got reported. But then again, I'm
> >>> not really experienced in this field.
> >>>
> >>
> >> I think it might be, or at least something similar to this.
> >>
> >> I think that can be fixed with the link check you added. I think we
> >> actually have a copy of the current link status in the ice_ptp or
> >> ice_ptp_tx structure which could be used instead of having to check back
> >> to the other structure.
> >
> > If you're talking about ptp_port->link_up that one is always false no
> > matter the actual NIC link status. First I wanted to use it but
> > checking all the 8 devices available in the dump data it just does not
> > match the net_dev->state or the port_info->phy.link_info.link_info
> >
> > crash> net_device.name,state 0xff48df6f0c553000
> >   name = "ens1f1",
> >   state = 0x7,    // DOWN
> > crash> ice_port_info.phy.link_info.link_info 0xff48df6f05dca018
> >   phy.link_info.link_info = 0xc0,    // DOWN
> > crash> ice_ptp_port.port_num,link_up 0xff48df6f05dd44e0
> >   port_num = 0x1
> >   link_up = 0x0,    // False
> >
> > crash> net_device.name,state 0xff48df6f25e3f000
> >   name = "ens1f0",
> >   state = 0x3,    // UP
> > crash> ice_port_info.phy.link_info.link_info 0xff48df6f070a3018
> >   phy.link_info.link_info = 0xe1,    // UP
> > crash> ice_ptp_port.port_num,link_up 0xff48df6f063184e0
> >   port_num = 0x0
> >   link_up = 0x0,    // False
> >
> > crash> ice_ptp_port.port_num,link_up 0xff48df6f25b844e0
> >   port_num = 0x2
> >   link_up = 0x0,    // False even this device is UP
> > crash> ice_ptp_port.port_num,link_up 0xff48df6f140384e0
> >   port_num = 0x3
> >   link_up = 0x0,    // False even this device is UP
> > crash> ice_ptp_port.port_num,link_up 0xff48df6f055044e0
> >   port_num = 0x0
> >   link_up = 0x0,    // False even this device is UP
> > crash> ice_ptp_port.port_num,link_up 0xff48df6f251cc4e0
> >   port_num = 0x1
> >   link_up = 0x0,
> > crash> ice_ptp_port.port_num,link_up 0xff48df6f33a9c4e0
> >   port_num = 0x2
> >   link_up = 0x0,
> > crash> ice_ptp_port.port_num,link_up 0xff48df6f3bb7c4e0
> >   port_num = 0x3
> >   link_up = 0x0,
> >
> > In other words, the ice_ptp_port.link_up is always false and cannot be
> > used. That's why I had to fall back to
> > hw->port_info->phy.link_info.link_info
> >
>
> Hmm. We call ice_ptp_link_change in ice_link_event which is called from
> ice_handle_link_event...
>
> In ice_link_event, a local link_up field is set based on
> phy_info->link_info.link_info & ICE_AQ_LINK_UP
>
> What kernel are you testing on? Does it include 6b1ff5d39228 ("ice:
> always call ice_ptp_link_change and make it void")?
>
> Prior to this commit the field was only valid for E822 devices, but I
> fixed that as it was used for other checks as well.
>
> I am guessing that the Red Hat kernel you are using lacks several of
> these clean ups and fixes.

Yeah, makes perfect sense. We don't have that commit in 8.4. All the data
I have and present here are from 4.18.0-305.49.1.rt7.121.el8_4.x86_64

> For the current code in the net-next kernel I believe we can safely use
> the ptp_port->link_up field.

I'll fix that up and drop you a v3. Thank you for the review.

--nX

> Thanks,
> Jake


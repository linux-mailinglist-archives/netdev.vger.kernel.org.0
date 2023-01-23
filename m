Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572C2677D10
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjAWNvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbjAWNvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:51:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D07FAD
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 05:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674481843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9vIE8NKX623PCBEKrno0xDIiJG3oiFqDswH3UtKjaTM=;
        b=bQGsyC9Ak1SCseQVhR/388aU4/AuF1bqZRX1imn8Wc+a2SMw/t+Q9OJrk4ahZTK+vqTHzS
        ga3U6EzOLqfVFTUSw2kZc+2tbBFnZyNviTOyB0AqTLWpiUywX+zVAIMkJmNOq4cEI5CrAq
        v6kgX9jhNvtsvfCbJWLcc2DpvmGhu/o=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-TElJBlqsOrmBc1tBNtWW7Q-1; Mon, 23 Jan 2023 08:50:42 -0500
X-MC-Unique: TElJBlqsOrmBc1tBNtWW7Q-1
Received: by mail-ej1-f71.google.com with SMTP id hq7-20020a1709073f0700b0086fe36ed3d0so7722439ejc.3
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 05:50:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9vIE8NKX623PCBEKrno0xDIiJG3oiFqDswH3UtKjaTM=;
        b=qWT23rvtZP9Lq/RW+5/gebCOsAnRKn7PGcYuP/uk2i3ccNDrURjn7Tn3XhSmMBZB7R
         DhnNydq8Rvu7i+geMKcQxb7LlDwZNBDD/Uo+5n/TeTVpEY2seIGusVOKd3yLDA/QnheA
         h+WQ3Kv7UcwK/VOwG/FTssULPVjkNVpEKB89UqurCBxEFBFBq6t9HaZzzUUk5/fCVMDV
         stOsfYh/aeJipk3cru3kzctCXYpKOmmC6Xi+/PdzHSR86oU1rmUWa8uz1nrgbVtUKh6g
         0aFXIYG/hJLlgE0eDhRpF0xsOLU3tHLh0UglOB9jZoe647I/xvM7Sg5eaLYi/bnjqXyq
         hEsw==
X-Gm-Message-State: AFqh2ko9ENf4iIP3hexLvM4o6ZqxJOvOQ/yybAUIlZkxtRBA1CfFiLlQ
        t+sdbgOsvbMZDzm5GqN+y0FfG4JYYFQnO2Ys/yN6YK95fwh0kHucTVfwtSfLP6YcGRcpFE4pRry
        6vxjxmVyeWS/sqaX/I7I0/ziukuQf29Nu
X-Received: by 2002:a17:906:af09:b0:868:17de:900d with SMTP id lx9-20020a170906af0900b0086817de900dmr2965822ejb.412.1674481841288;
        Mon, 23 Jan 2023 05:50:41 -0800 (PST)
X-Google-Smtp-Source: AMrXdXts2+4/O5IrKkeUamYxBlfeg/CHDE5BWjcoqePucfpoT7Ix74SvGP4YA70ychLp3624WjRgtIhiGOTaHTGYN6A=
X-Received: by 2002:a17:906:af09:b0:868:17de:900d with SMTP id
 lx9-20020a170906af0900b0086817de900dmr2965809ejb.412.1674481841080; Mon, 23
 Jan 2023 05:50:41 -0800 (PST)
MIME-Version: 1.0
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
 <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
 <20230118102058.3b1f275b@xps-13> <20230123134921.38cdfd42@xps-13>
In-Reply-To: <20230123134921.38cdfd42@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 23 Jan 2023 08:50:29 -0500
Message-ID: <CAK-6q+g9TxtEpELW1GXchBjPq2HD85CAv06VhDKSHjrQmXPCKA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
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

On Mon, Jan 23, 2023 at 7:49 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> > > btw: what is about security handling... however I would declare this
> > > feature as experimental anyway.
> >
> > I haven't tested the security layer at all yet, would you have a few
> > commands to start with, which I could try using eg. hwsim?
>
> Using the dev_queue_xmit() doest not bypasses the whole stack anymore,
> the beacons got rejected by the llsec layer. I did just hack into it
> just to allow unsecure beacons for now:
>

Stupid questions: do the beacon frames need to be encrypted? Because
we bypass llsec always with those mlme functionality.

btw: there is currently an issue with the llsec hooks. You will not
see the transmit side being encrypted via wireshark (so far I
remember) because the capture is before encryption...

> -       if (hlen < 0 || hdr.fc.type != IEEE802154_FC_TYPE_DATA)
> +       if (hlen < 0 ||
> +           (hdr.fc.type != IEEE802154_FC_TYPE_DATA &&
> +            hdr.fc.type != IEEE802154_FC_TYPE_BEACON))
>                 return -EINVAL;
>
> I believe that would be enough as a first step, at least for merging
> beacons support for now.
>

ok.

> However I'll have to look at the spec about security stuff and
> beaconing to know how to handle this properly if security was required,
> but could you drive me through useful resources were I could quickly
> grasp how all that works? Did you make any presentation of it? Perhaps
> just a blog post or something alike? Or even just a script showing its
> use?
>

I am pretty sure I have something... you need to construct an ACL
there and there exist different methods to do a key lookup. Some are
very easy and some are more difficult to set up. I will look later...
or just do a setup again with hwsim with should work (but again don't
trust wireshark/tcpdump).

Also note: currently there exists practical issues on 802.15.4 stack
(but star topology kind of solves it, so far I understood) to
synchronize security parameters e.g. frame counter.

> While I was looking at linux-wpan.org, I realized we should both
> contribute to it with some examples about security stuff and
> beaconing/scanning?
>

yes, that would be nice... I am pretty sure there are some examples on
the mailinglist archive.

- Alex


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E89844E48
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfFMVVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:21:13 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42740 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfFMVVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:21:13 -0400
Received: by mail-ed1-f66.google.com with SMTP id z25so224222edq.9
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 14:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fxn+ibphcAr7J3R+3rpIzdXpvz9eQJikpP99DaqAPb4=;
        b=qrp/ydJ6WgN1pljL7lJdv7GY//Rum9OhB0Pu/pbKSbfGtf4scxxqGuiEceiBzt3JNi
         jZW3/FJL9MBjIJsTaI1Zqvrw2tSbFN6XxTOL0Aajauv7O4CNuEzxU5c6+68exSchUbM3
         uSdyDQh++j1yZGdCdBY9tjeda1+3CLozjjpOyCMgOfX8JLFyMbrlkesbVQCvJnzzQKar
         5FmSw73ZNq95wpJbxcsLksRUjdm+KBTFyaYszrowdhpPHE6xRhRTVYeTF5ffyrixM/Ri
         nPEy9k1JEytwspvrSYZ/Yab7z++5kMNciWq7t7QiGqsD8aBBynRm9QHzHaHtZTpilfHk
         sKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fxn+ibphcAr7J3R+3rpIzdXpvz9eQJikpP99DaqAPb4=;
        b=CH6hWvBEzzOqv75T9yk9B0VDDAAj3TtMYqpoxMqpprtSUG71vNVLzG398TGfxpwBHY
         GiAYzQwNSaLUAZH0iph9DkuzYrU85JMmrCHGX8MtK5SToMwf4CWubdf/wcRLOo63jeXv
         R+U/MmQ/A8TUGmRED2BlnLI3PlNkC6dWokpKeJOzKUtBoSxmxWU/BCFgPceTYQwb92Yd
         Kz3TmrxWfDr0bON94bCNO1fed3uJFR4Hxkc1PT9BaTWBwp0UUoGL3nyVE7+ZDroN7Kbj
         ClIWZPnlOC2mOCaWY90PmFyxn1GnRM1aM7Fr5XdhHF2HnXb/l6Rk/mp8Zer8W5+oSi8h
         tIIg==
X-Gm-Message-State: APjAAAVWR/dVqMyS2comSvqvkkyfjRbBeohPZQrWOSqcrWhXpffEpI1e
        lMMomjUpg4RNQFO8ZsuiMb9xH+ZCxsbgaO2j+1g=
X-Google-Smtp-Source: APXvYqw80biAjyZ4B7KBL+E0rtPJEQ8Z3bFRXzJdf3eE9xeIKUQFE33bhfJFGTFmNwfFsBqWudlZtsm/XcYeUivSmA8=
X-Received: by 2002:a50:b1db:: with SMTP id n27mr52099586edd.62.1560460871342;
 Thu, 13 Jun 2019 14:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <1560381160-19584-1-git-send-email-jbaron@akamai.com>
 <CAKgT0Uej5CkBJpqsBnB61ozo2kAFKyAH8WY9KVbFQ67ZxPiDag@mail.gmail.com> <3af1e0da-8eb4-8462-3107-27917fec9286@akamai.com>
In-Reply-To: <3af1e0da-8eb4-8462-3107-27917fec9286@akamai.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 13 Jun 2019 17:20:35 -0400
Message-ID: <CAF=yD-+BMvToWvRwayTrxQBQ-Lgq7QVA6E+rGe3e5ic7rQ_gSg@mail.gmail.com>
Subject: Re: [PATCH net-next] gso: enable udp gso for virtual devices
To:     Jason Baron <jbaron@akamai.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Joshua Hunt <johunt@akamai.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> @@ -237,6 +237,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
> >>                                  NETIF_F_GSO_GRE_CSUM |                 \
> >>                                  NETIF_F_GSO_IPXIP4 |                   \
> >>                                  NETIF_F_GSO_IPXIP6 |                   \
> >> +                                NETIF_F_GSO_UDP_L4 |                   \
> >>                                  NETIF_F_GSO_UDP_TUNNEL |               \
> >>                                  NETIF_F_GSO_UDP_TUNNEL_CSUM)
> >
> > Are you adding this to NETIF_F_GSO_ENCAP_ALL? Wouldn't it make more
> > sense to add it to NETIF_F_GSO_SOFTWARE?
> >
>
> Yes, I'm adding to NETIF_F_GSO_ENCAP_ALL (not very clear from the
> context). I will fix the commit log.
>
> In: 83aa025 udp: add gso support to virtual devices, the support was
> also added to NETIF_F_GSO_ENCAP_ALL (although subsequently reverted due
> to UDP GRO not being in place), so I wonder what the reason was for that?

That was probably just a bad choice on my part.

It worked in practice, but if NETIF_F_GSO_SOFTWARE works the same
without unexpected side effects, then I agree that it is the better choice.

That choice does appear to change behavior when sending over tunnel
devices. Might it send tunneled GSO packets over loopback?



> I agree that NETIF_F_GSO_SOFTWARE seems conceptually more logical and
> further I think it adds support for more 'virtual' devices. For example,
> I tested loopback with NETIF_F_GSO_UDP_L4 being added to
> NETIF_F_GSO_SOFTWARE and it shows a nice performance gain, whereas
> NETIF_F_GSO_ENCAP_ALL isn't included for loopback.
>
> Thanks,
>
> -Jason

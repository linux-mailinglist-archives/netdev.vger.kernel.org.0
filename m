Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB272A18A4
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 16:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgJaP4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 11:56:00 -0400
Received: from mail-03.mail-europe.com ([91.134.188.129]:32956 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgJaPz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 11:55:58 -0400
Date:   Sat, 31 Oct 2020 15:55:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604159753; bh=12fH+MeF0HceZLVXkgrERm9I6DnHG1NfwqXVEuScvwI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Hfw5o6yB6/1bQ2Riaccp1H094XbNfrucusEXD3rou1fevI/NR4yy9g6KxDY/Xk07k
         +BA6eQtaqMDEUgq6lPomJnhpxLNC24FbugFHCDcHw8NsCY9TB+hANtz0hsk/Pf9G2Q
         GOa07HhMYMXfBI9v6Ts3ZgiheLEBogtwuClcxetanMatvJERHXORWRbUyvNANb5VQV
         9CT/7zPw5IXjmisX5MjgvrEMu43bXZ4KIk1B0jZrCTywpooDQ0qDQNYTTv7L2u4wfD
         2paYZbTMMf/shTP4iNFRHYWykOL2CY0vEXhJC/fIRVxC+ZbaiV/+cqeEH/s6BMynGB
         faioLimbCOH/Q==
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Antoine Tenart <atenart@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next] net: avoid unneeded UDP L4 and fraglist GSO resegmentation
Message-ID: <OBMm3ctve56m8utHeG4YjTDZzRKXChKzeQaMyS1EQE@cp7-web-043.plabs.ch>
In-Reply-To: <CA+FuTSdKYVc3w9if5zB6WSWJ3M1XWNmXb-6VGJqKS0WndnPLhw@mail.gmail.com>
References: <Mx3BWGop6fGORN6Cpo4mHIHz2b1bb0eLxeMG8vsijnk@cp3-web-020.plabs.ch> <CA+FuTSdiqaZJ3HQHuEEMwKioWGKvGwZ42Oi7FpRf0hqWdZ27pQ@mail.gmail.com> <TSRRse4RkO_XW4DtdTkz4NeZPwzHXaPOEFU9-J4VlpLbUzlBzuhW8HYfHCfFJ1Ro6FwztEO652tbnSGOE-MjfKez1NvVPM3v3ResWtbK5Rk=@pm.me> <MX6AwRxaXyMi3FALeN1gpN8y4XgaktZM2MHxQMOM@cp4-web-036.plabs.ch> <CA+FuTSdKYVc3w9if5zB6WSWJ3M1XWNmXb-6VGJqKS0WndnPLhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sat, 31 Oct 2020 11:26:24 -0400

>>>> I think it is fine to reenable this again, now that UDP sockets will
>>>> segment unexpected UDP GSO packets that may have looped. We previously
>>>> added general software support in commit 83aa025f535f ("udp: add gso
>>>> support to virtual devices"). Then reduced its scope to egress only in
>>>> 8eea1ca82be9 ("gso: limit udp gso to egress-only virtual devices") to
>>>> handle that edge case.
>>
>> Regarding bonding and teaming: I think they should also use
>> NETIF_F_GSO_SOFTWARE mask, not NETIF_F_ALL_TSO, as SCTP also has
>> a software fallback. This way we could also remove a separate
>> advertising of NETIF_F_GSO_UDP_L4, as it will be included in the first.
>>
>> So, if this one:
>> 1. Add NETIF_F_GSO_UDP_L4 and NETIF_F_GSO_FRAGLIST to
>>    NETIF_F_GSO_SOFTWARE;
>> 2. Change bonding and teaming features mask from NETIF_F_ALL_TSO |
>>    NETIF_F_GSO_UDP_L4 to NETIF_F_GSO_SOFTWARE;
>> 3. Check that every virtual netdev has NETIF_F_GSO_SOFTWARE _or_
>>    NETIF_F_GSO_MASK in its advertising.
>>
>> is fine for everyone, I'll publish more appropriate and polished v2 soon=
.
>
> I think we can revert 8eea1ca82be9. Except for the part where it
> defines the feature in NETIF_F_GSO_ENCAP_ALL instead of
> NETIF_F_GSO_SOFTWARE. That appears to have been a peculiar choice. I
> can't recall exactly why I chose that. Most likely because that was
> (at the time) the only macro that covered all the devices I wanted to
> capture.
>
> As for SCTP: that has the same concern that prompted that commit for
> UDP: is it safe to forward those packets to the ingress path today?

Oh well. I just looked up into net/sctp/offload.c and see no GRO
receiving callbacks, only GSO ones. On the other hand,
NETIF_F_GSO_SOFTWARE includes GSO_SCTP and is used in almost every
virtual netdev driver, including macvlan and veth mentioned earlier,
so that seems to be fine.

> I had missed that there may be non-mainline drivers that do ;)
> Great to see these features getting offload support.

It will be mainlined sooner or later depending on my workload :)
UDP fraglists *really* boosted the things up for me, so I don't quite
understand why not a single mainline driver has a support for them.

Al


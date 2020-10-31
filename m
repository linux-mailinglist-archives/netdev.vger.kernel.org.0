Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4B62A1540
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgJaKbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:31:40 -0400
Received: from mail-02.mail-europe.com ([51.89.119.103]:33314 "EHLO
        mail-02.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgJaKbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 06:31:40 -0400
Date:   Sat, 31 Oct 2020 10:31:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604140295; bh=KUg5dDnTjqXg5KK2kOJV+0s/aEoOCToFks8cOlHesPU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Hpv8cEjfex1JMJVzf1pLpR7sWEObgKq3n/1K3wkblQEpt0AkOGUt3v/Ep31V55/Lq
         +N0P9UYe+qcFdgb1lUnpmHraaDvKVRCr6aULrlGvfSEJ9ffgP+lKl9YaLh3TscTJhk
         PgYcMHA1aMWyl6KW8w4GwB/ce4w1kfeKqsN6R36obiWyCaXUxWZcgLW8niMGd1OP5f
         5YoAlgHdCOsYyZrk7oauxIQfSPAgn8jI5RFays3fawMUdi/SZti2hlQDC37GIEh/3+
         HmMIh+z+z5HkI2PP+N0GCVyZM1lJyXnwJWQ4a7sjJR0U6zE0T48fBdYnaFbP9SlwSh
         WpTqBv3O2vywA==
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Antoine Tenart <atenart@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next] net: avoid unneeded UDP L4 and fraglist GSO resegmentation
Message-ID: <TSRRse4RkO_XW4DtdTkz4NeZPwzHXaPOEFU9-J4VlpLbUzlBzuhW8HYfHCfFJ1Ro6FwztEO652tbnSGOE-MjfKez1NvVPM3v3ResWtbK5Rk=@pm.me>
In-Reply-To: <CA+FuTSdiqaZJ3HQHuEEMwKioWGKvGwZ42Oi7FpRf0hqWdZ27pQ@mail.gmail.com>
References: <Mx3BWGop6fGORN6Cpo4mHIHz2b1bb0eLxeMG8vsijnk@cp3-web-020.plabs.ch> <CA+FuTSdiqaZJ3HQHuEEMwKioWGKvGwZ42Oi7FpRf0hqWdZ27pQ@mail.gmail.com>
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

On Saturday, 31 October 2020, 2:12, Willem de Bruijn <willemdebruijn.kernel=
@gmail.com> wrote:

Hi Willem,

> On Fri, Oct 30, 2020 at 2:33 PM Alexander Lobakin alobakin@pm.me wrote:
>
> > Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") added a supp=
ort
> > for fraglist UDP L4 and fraglist GSO not only for local traffic, but al=
so
> > for forwarding. This works well on simple setups, but when any logical
> > netdev (e.g. VLAN) is present, kernel stack always performs software
> > resegmentation which actually kills the performance.
> > Despite the fact that no mainline drivers currently supports fraglist G=
SO,
> > this should and can be easily fixed by adding UDP L4 and fraglist GSO t=
o
> > the list of GSO types that can be passed-through the logical interfaces
> > (NETIF_F_GSO_SOFTWARE). After this change, no resegmentation occurs (if
> > a particular driver supports and advertises this), and the performance
> > goes on par with e.g. 1:1 forwarding.
> > The only logical netdevs that seem to be unaffected to this are bridge
> > interfaces, as their code uses full NETIF_F_GSO_MASK.
> > Tested on MIPS32 R2 router board with a WIP NIC driver in VLAN NAT:
> > 20 Mbps baseline, 1 Gbps / link speed with this patch.
> >
> > Signed-off-by: Alexander Lobakin alobakin@pm.me
> >
> > ------------------------------------------------
> >
> > include/linux/netdev_features.h | 4 ++--
> > 1 file changed, 2 insertions(+), 2 deletions(-)
> > diff --git a/include/linux/netdev_features.h b/include/linux/netdev_fea=
tures.h
> > index 0b17c4322b09..934de56644e7 100644
> > --- a/include/linux/netdev_features.h
> > +++ b/include/linux/netdev_features.h
> > @@ -207,8 +207,8 @@ static inline int find_next_netdev_feature(u64 feat=
ure, unsigned long start)
> > NETIF_F_FSO)
> > /* List of features with software fallbacks. */
> > -#define NETIF_F_GSO_SOFTWARE (NETIF_F_ALL_TSO | \
> >
> > -                                  NETIF_F_GSO_SCTP)
> >
> >
> >
> > +#define NETIF_F_GSO_SOFTWARE (NETIF_F_ALL_TSO | NETIF_F_GSO_SCTP | \
> >
> > -                                  NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_FRA=
GLIST)
> >
> >
>
> What exactly do you mean by resegmenting?

I mean pts 5-6 from the full path:
1. Our NIC driver advertises a support for fraglists, GSO UDP L4, GSO fragl=
ists.
2. User enables fraglisted GRO via Ethtool.
3. GRO subsystem receives UDP frames from driver and merges the packets int=
o
   fraglisted GSO skb(s).
4. Networking stack queues it up for xmitting.
5. Virtual device like VLAN doesn't advertise a support for GSO UDP L4 and
   GSO fraglists, so skb_gso_check() doesn't allow to pass this skb as is t=
o
   the real driver.
6. Kernel then has to form a bunch of regular UDP skbs from that one and pa=
ss
   it to the driver instead. This fallback is *extremely* slow for any GSO =
types,
   but especially for GSO fraglists.
7. All further processing performs with a series of plain UDP skbs, and the
   driver gets it one-by-one, despite that it supports UDP L4 and fragliste=
d GSO.

That's not OK because:
a) logical/virtual netdevs like VLANs, bridges etc. should pass GSO skbs as=
 is;
b) even if the final driver doesn't support such type of GSO, this software
   resegmenting should be performed right before it, not in the middle of
   processing -- I think I even saw that note somewhere in kernel documenta=
tion,
   and it's totally reasonable in terms of performance.

> I think it is fine to reenable this again, now that UDP sockets will
> segment unexpected UDP GSO packets that may have looped. We previously
> added general software support in commit 83aa025f535f ("udp: add gso
> support to virtual devices"). Then reduced its scope to egress only in
> 8eea1ca82be9 ("gso: limit udp gso to egress-only virtual devices") to
> handle that edge case.
>
> If we can enable for all virtual devices again, we could revert those
> device specific options.

Thanks,
Al

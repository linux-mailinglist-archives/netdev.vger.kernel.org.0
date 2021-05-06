Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E841A374C8F
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 03:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhEFBCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 21:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEFBCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 21:02:37 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14C9C061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 18:01:38 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id b17so4203104ede.0
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 18:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4pccZz2yty2QFmh9LwsZ3EjAT1MFLVh15MZ36wJ1Z5I=;
        b=AWrHBSXScHJcZ+BpF1cdUFy3tWPy6Tq4uYpguoFgQLabLq+cqGyeQmxO+aGK6t7BfT
         FMMmEUL6AHRnQw1eznYjXNG0iV1RbebTDn9/0NkS4rGyqegwKDu85TeIUueF5G6ok1fc
         j28BV23Bnmiel2mGULna7vgGhLTlMT6t4zmuqPpUEeN/snmsOEmD4bBmWbli7PuTUj9L
         QToTMxo55LlKojVfkywcnzauQDl5f0hYDzpehp0t309usUN4t9r0n/9C+4S3pkc2Icu6
         0atLI4DwWhWRhDSKri23n05FFRyMe3s41XrogNJ6X1qodIv0QqXSckRpkfkuLj88FJnD
         2QFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4pccZz2yty2QFmh9LwsZ3EjAT1MFLVh15MZ36wJ1Z5I=;
        b=gCisRUI5K7t5vJo5FQO1So6I4fD4TOF9rhesME+LVDjqs+baNCidc8pNzDHLUIWZ1R
         VsGI2h5h15I7rWcQJTtDBXhbV7sIOjVw9z2Ey53r/0hVrXUGW2lFzUjyRepWbsaUTSvb
         KdDP4xFd+KY/RpU4iPLhqb121U+4Ox+lRFn/LuUWx1Ni6qgmiPzWmNhU14Zng2NuqXYe
         SOvfxEhcD+lV2nnBcNUNAlBUBZ+qZR/MWgWZO/313dhHHG0kndVb3Hv2E486/TKjRdmJ
         PdorY8VH/QqbboSjZpuyN6BD051wCD/o3BD4CO0HmUZbTPzMX2DCeK9GzCMPaPRhvUiq
         YDQQ==
X-Gm-Message-State: AOAM533c2x97sOQpij/hrptD7RlXnNdwkioAKbXu951wUPXIGD90jBZm
        U37W8afdqcqaLNMaw5taDi5fVu5Pxi2q1+qx8qA=
X-Google-Smtp-Source: ABdhPJw06dbV8wxVly+qQ5pHpwNfNMZstCQ1TAtSz145d2yRg4oZuLzo17q78AZCwG1+KcDLWQG4Ep9ioBfA/4FMFdQ=
X-Received: by 2002:a05:6402:36d:: with SMTP id s13mr1922514edw.103.1620262897388;
 Wed, 05 May 2021 18:01:37 -0700 (PDT)
MIME-Version: 1.0
References: <1620254099-5270-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1620254099-5270-1-git-send-email-michael.chan@broadcom.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 5 May 2021 18:01:26 -0700
Message-ID: <CAKgT0UcBrPeEUDsfOmEX6GOC7Tbf-P+gUzefLi8HyC6q4sm+7Q@mail.gmail.com>
Subject: Re: [PATCH net] bnxt_en: Fix and improve .ndo_features_check().
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <gospo@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 5, 2021 at 3:43 PM Michael Chan <michael.chan@broadcom.com> wrote:
>
> Jakub Kicinski pointed out that we need to handle ipv6 extension headers
> and to explicitly check for supported tunnel types in
> .ndo_features_check().
>
> For ipv6 extension headers, the hardware supports up to 2 ext. headers
> and each must be <= 64 bytes.  For tunneled packets, the supported
> packets are UDP with supported VXLAN and Geneve ports, GRE, and IPIP.
>
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Fixes: 1698d600b361 ("bnxt_en: Implement .ndo_features_check().")
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 93 ++++++++++++++++++-----
>  1 file changed, 76 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 39ac9e2f5118..c489089671fb 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -10785,37 +10785,96 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
>         return rc;
>  }
>
> +/* For UDP, we can only handle 1 Vxlan port and 1 Geneve port. */
> +static bool bnxt_udp_check(struct bnxt *bp, struct udphdr *uh)
> +{
> +       __be16 udp_port = uh->dest;
> +
> +       return udp_port == bp->vxlan_port || udp_port == bp->nge_port;
> +}
> +
> +static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
> +                             u8 *nextproto)
> +{
> +       struct ipv6hdr *ip6h = (struct ipv6hdr *)(skb->data + nw_off);
> +       int hdr_count = 0;
> +       u8 nexthdr;
> +       int start;
> +
> +       /* Check that there are at most 2 IPv6 extension headers, no
> +        * fragment header, and each is <= 64 bytes.
> +        */
> +       start = nw_off + sizeof(*ip6h);
> +       nexthdr = ip6h->nexthdr;
> +       while (ipv6_ext_hdr(nexthdr)) {
> +               struct ipv6_opt_hdr _hdr, *hp;
> +               int hdrlen;
> +
> +               if (hdr_count >= 3 || nexthdr == NEXTHDR_NONE ||
> +                   nexthdr == NEXTHDR_FRAGMENT)
> +                       return false;
> +               hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
> +               if (!hp)
> +                       return false;
> +               if (nexthdr == NEXTHDR_AUTH)
> +                       hdrlen = ipv6_authlen(hp);
> +               else
> +                       hdrlen = ipv6_optlen(hp);
> +
> +               if (hdrlen > 64)
> +                       return false;
> +               nexthdr = hp->nexthdr;
> +               start += hdrlen;
> +               hdr_count++;
> +       }
> +       if (nextproto)
> +               *nextproto = nexthdr;
> +       return true;
> +}
> +

You should really be validating the nexthdr in all cases. I'm assuming
your offloads are usually for TCP and UDP. You should probably be
validating that you end with that if you are going to advertise the
CSUM and GSO offloads.

> +static bool bnxt_tunl_check(struct bnxt *bp, struct sk_buff *skb, u8 l4_proto)
> +{
> +       switch (l4_proto) {
> +       case IPPROTO_UDP:
> +               return bnxt_udp_check(bp, udp_hdr(skb));
> +       case IPPROTO_GRE:
> +       case IPPROTO_IPIP:
> +               return true;
> +       case IPPROTO_IPV6:
> +               /* Check ext headers of inner ipv6 */
> +               return bnxt_exthdr_check(bp, skb, skb_inner_network_offset(skb),
> +                                        NULL);
> +       }
> +       return false;
> +}
> +
>  static netdev_features_t bnxt_features_check(struct sk_buff *skb,
>                                              struct net_device *dev,
>                                              netdev_features_t features)
>  {
> -       struct bnxt *bp;
> -       __be16 udp_port;
> +       struct bnxt *bp = netdev_priv(dev);
>         u8 l4_proto = 0;
>
>         features = vlan_features_check(skb, features);
> -       if (!skb->encapsulation)
> -               return features;
> -
>         switch (vlan_get_protocol(skb)) {
>         case htons(ETH_P_IP):
> +               if (!skb->encapsulation)
> +                       return features;
>                 l4_proto = ip_hdr(skb)->protocol;
> -               break;
> +               if (!bnxt_tunl_check(bp, skb, l4_proto))
> +                       goto disable_offload;
> +               return features;
>         case htons(ETH_P_IPV6):
> -               l4_proto = ipv6_hdr(skb)->nexthdr;
> -               break;
> -       default:
> +               if (!bnxt_exthdr_check(bp, skb, skb_network_offset(skb),
> +                                      &l4_proto))
> +                       goto disable_offload;
> +               if (skb->encapsulation &&
> +                   !bnxt_tunl_check(bp, skb, l4_proto))
> +                       goto disable_offload;
>                 return features;
>         }
>

This still largely falls short of being able to determine if your
hardware can handle offloading the packet or not. It would likely make
much more sense to look at parsing all the way from the L2 up through
the inner-most L4 header in the case of tunnels to verify that you can
support offloading it.

For example if I had a packet that had unsupported inner IPv6
extension headers it doesn't look like it would be caught by this as
you are only checking the outer headers and the UDP port.

If your offload relies on a parser to offload various protocols you
really need to walk through and verify that the provided header is
something that will successfully be recognized by the parser with no
escapes which means having to parse the whole thing yourself.

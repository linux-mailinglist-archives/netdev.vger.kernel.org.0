Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19306D39BD
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 20:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjDBSS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 14:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjDBSS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 14:18:56 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7D78A71;
        Sun,  2 Apr 2023 11:18:53 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id t20so1870862uaw.5;
        Sun, 02 Apr 2023 11:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680459533; x=1683051533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHSRAhIwBYA9x/eeP7HTExW01z5DAG+ze+JXsU/sf3o=;
        b=Fd8WMdVX3qUrlVSt0Bm0gpeDNx124XJ/QwsdFOdRzK24LjPSsodpI3AYqmCH7HhsFl
         SGvknosiCpfpqY6dQRVTe5MYDMiCMvwIZ9wkRMN4pr8Y0lZEiTJZYm4q3ejtMQchLKdf
         JMxvcCIBWfJIPCXulFkXqAKxAgTsnww9WTCQ02cw5Qb2fNng5T2GGQHLa5KsNpe1Jwvl
         xYNgAWi2Zpx7c2wWV+P9AQ4e7F4hd3bFk+fA34f5FzBzSOGfr2+32soGy4PgbeSj0QLB
         KANeQIEYE9NVeEn8DPqqcymEl4AMrS3uh3i1xgtl+apQuLah776UO/CqspFG72kj3tea
         OcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680459533; x=1683051533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hHSRAhIwBYA9x/eeP7HTExW01z5DAG+ze+JXsU/sf3o=;
        b=O+FIQ3yoq4SDjOadkpUOjJj0CTo19AGPJY/Sb9XwfQedXTlmoA46Hbi7UEmYIlZg/j
         9OSzTQTwCmqH/fnXAisk6p8017nb7h3dUe8KSO++e9awrTFvSV5RyJAckfuwJbNkBn4x
         SESvK+w38D/nA2beEWu/eUa38c6QxXzoeo4MDEtNFeQAFjMgb0amxqLnE9x/zgoH06F2
         WhiaIc3y8Tr7dFad/dJ2y2+v3ofxCm7sMHtYbzuLSgNp7Yw2MbuFq6xTKOZ4vbXOYB8Z
         22fSUJ8bjRGZLtzPc+kS1BrKotWa6+wxOcHjmgD2oLmpVV3HsxzRZ3Vyj3ClhryRpyCX
         lANQ==
X-Gm-Message-State: AAQBX9eEfOYv3YPntJhjswHYn1RQ6GbyQwm1wm2iWTD+pAiEdm+c7WgO
        vJ7hNhXJNUY6eL44ZCPnD1ZWZYq5voyCjEa/SyI=
X-Google-Smtp-Source: AKy350bsLS1Rz0GxrZdcTynmXyvYn78tcJlTBkyLQ0XQuC470sH5lh4N3lIlNO+yd2MZBgXQachaUEc9jYcRllveAWA=
X-Received: by 2002:a1f:abd2:0:b0:43c:3dd6:5535 with SMTP id
 u201-20020a1fabd2000000b0043c3dd65535mr3959076vke.0.1680459532872; Sun, 02
 Apr 2023 11:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230401023029.967357-1-chenwei.0515@bytedance.com>
In-Reply-To: <20230401023029.967357-1-chenwei.0515@bytedance.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 2 Apr 2023 14:18:11 -0400
Message-ID: <CAF=yD-Lg_XSnE9frH9UFpJCZLx-gg2KHzVu7KmnigidujCvepQ@mail.gmail.com>
Subject: Re: [PATCH] udp:nat:vxlan tx after nat should recsum if vxlan tx
 offload on
To:     Fei Cheng <chenwei.0515@bytedance.com>
Cc:     dsahern@kernel.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org,
        Edward Cree <ecree@solarflare.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:31=E2=80=AFPM Fei Cheng <chenwei.0515@bytedance.=
com> wrote:
>
> From: "chenwei.0515" <chenwei.0515@bytedance.com>
>
>     If vxlan-dev enable tx csum offload, there are two case of CHECKSUM_P=
ARTIAL,
>     but udp->check donot have the both meanings.
>
>     1. vxlan-dev disable tx csum offload, udp->check is just pseudo hdr.
>     2. vxlan-dev enable tx csum offload, udp->check is pseudo hdr and
>        csum from outter l4 to innner l4.
>
>     Unfortunately if there is a nat process after vxlan tx=EF=BC=8Cudp_ma=
nip_pkt just use
>     CSUM_PARTIAL to re csum PKT, which is just right on vxlan tx csum dis=
able offload.

The issue is that for encapsulated traffic with local checksum offload,
netfilter incorrectly recomputes the outer UDP checksum as if it is an
unencapsulated CHECKSUM_PARTIAL packet, correct?

So the underlying issue is that the two types of packets are
indistinguishable after udp_set_csum:

        } else if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL) {
                uh->check =3D 0;
                uh->check =3D udp_v4_check(len, saddr, daddr, lco_csum(skb)=
);
                if (uh->check =3D=3D 0)
                        uh->check =3D CSUM_MANGLED_0;
        } else {
                skb->ip_summed =3D CHECKSUM_PARTIAL;
                skb->csum_start =3D skb_transport_header(skb) - skb->head;
                skb->csum_offset =3D offsetof(struct udphdr, check);
                uh->check =3D ~udp_v4_check(len, saddr, daddr, 0);
        }

Clearly their ip_summed will be the same.

>
>     This patch use skb->csum_local flag to identify two case, which will =
csum lco_csum if valid.
>
> Signed-off-by: chenwei.0515 <chenwei.0515@bytedance.com>
> ---
>  include/linux/skbuff.h       | 1 +
>  net/ipv4/udp.c               | 1 +
>  net/netfilter/nf_nat_proto.c | 9 +++++++++
>  3 files changed, 11 insertions(+)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index ff7ad331fb82..62996d8d0b4d 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -990,6 +990,7 @@ struct sk_buff {
>         __u8                    slow_gro:1;
>         __u8                    csum_not_inet:1;
>         __u8                    scm_io_uring:1;
> +       __u8                    csum_local:1;

sk_buff are in space constrained.

I hope we can disambiguate the packets somehow without having
to resort to a new flag.

>
>  #ifdef CONFIG_NET_SCHED
>         __u16                   tc_index;       /* traffic control index =
*/
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index c605d171eb2d..86bad0bbb76e 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -889,6 +889,7 @@ void udp_set_csum(bool nocheck, struct sk_buff *skb,
>                 uh->check =3D udp_v4_check(len, saddr, daddr, lco_csum(sk=
b));
>                 if (uh->check =3D=3D 0)
>                         uh->check =3D CSUM_MANGLED_0;
> +               skb->csum_local =3D 1;
>         } else {
>                 skb->ip_summed =3D CHECKSUM_PARTIAL;
>                 skb->csum_start =3D skb_transport_header(skb) - skb->head=
;
> diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
> index 48cc60084d28..a0261fe2d932 100644
> --- a/net/netfilter/nf_nat_proto.c
> +++ b/net/netfilter/nf_nat_proto.c
> @@ -25,6 +25,7 @@
>  #include <net/ip6_route.h>
>  #include <net/xfrm.h>
>  #include <net/ipv6.h>
> +#include <net/udp.h>
>
>  #include <net/netfilter/nf_conntrack_core.h>
>  #include <net/netfilter/nf_conntrack.h>
> @@ -75,6 +76,14 @@ static bool udp_manip_pkt(struct sk_buff *skb,
>         hdr =3D (struct udphdr *)(skb->data + hdroff);
>         __udp_manip_pkt(skb, iphdroff, hdr, tuple, maniptype, !!hdr->chec=
k);
>
> +       if (skb->csum_local) {
> +               hdr->check =3D 0;
> +               hdr->check =3D udp_v4_check(htons(hdr->len), tuple->src.u=
3.ip, tuple->dst.u3.ip,
> +                                         lco_csum(skb));
> +               if (hdr->check =3D=3D 0)
> +                       hdr->check =3D CSUM_MANGLED_0;
> +       }
> +
>         return true;
>  }
>
> --
> 2.11.0
>

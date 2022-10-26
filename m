Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EC560DD79
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 10:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbiJZIpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 04:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbiJZIof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 04:44:35 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C9965547
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:42:49 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c2so5171140plz.11
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J4/0lR7B+RHnRsLUIswacukyV2Syn4pHrQc7y6nwLcM=;
        b=UZLfl/F7RhxzoMzw4Yi9YpOrH1geINhL9eFvvR2QrpCz3IboEb4Pn3pvu6TPn2C7Sv
         GrICk2pB1zJ2XSdk+i6JDzb6eMCSdH9A/XStC02P4JNhgrDjtKrJJCzAvYYhMSu3ie1P
         DRJtzaKrDNxpHDgRhYgTXXH/k177bKEDa3IteSBgqJf75uZnIcrdWu7XWnntTTHxnGJ9
         ++uhOlUbxoiv7dAQXVNkM7v9/0r2FLp5otjfCrnV1/IndSK7S+hvh08R/w/18DlpibBG
         o/WQaO+RGYj0T7rq9JSm7iLBLrQklHxhnol9Tfh6uAfd/mnipICNx7W00UYTno2N/KaX
         j/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J4/0lR7B+RHnRsLUIswacukyV2Syn4pHrQc7y6nwLcM=;
        b=XFV0dwKXciJhZRhVxg9Yg7PHG1Rx9FJlUSPPeGsTwQhLB+quTLsKc+P/WIxRaTP3+1
         +W0Xkb8OilQYicVNoTDNmXv1gF9CKYnSSzoVQRDqSM491azx6v9WzZDu9prnLQHFyiVv
         YzbMmSeQq04BfvO2x5S9nkIquVPyjFrrLP9WZMO87qFzchdCxmbtO7kHswXjSxWX377A
         BkwgCAzfnr6v7NobTE7x1xVDO6xXkSfB1RwX0i9bpS5wNRa48lcyGN7pOCcHXD9VKqcx
         A8kOEkk+R5fAQhx6+LDfTKVfZY+nG/x7+IH2HUxHHIqVt8W2xdVHP8ehNfd5dTr0kMJ5
         sjoA==
X-Gm-Message-State: ACrzQf0kgwb3wsjPus8rxPnXCryPEVRv1OQJ876ZkGU5pJLvNtRK0XzD
        gcGFhrM2NpeTpT+l1fGI8irCEgK5CTW3gjF1CRg=
X-Google-Smtp-Source: AMsMyM70cLaUFxWt4JRGpGUF/qBqdam9i+gXAncEpcI4+mHwRLldlE0lDw9yNxeERDYuhXMU6NjUfPjF9fcAquBG6Pc=
X-Received: by 2002:a17:903:2452:b0:186:99e0:672d with SMTP id
 l18-20020a170903245200b0018699e0672dmr18717167pls.95.1666773768855; Wed, 26
 Oct 2022 01:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <20221026083203.2214468-1-zenczykowski@gmail.com>
In-Reply-To: <20221026083203.2214468-1-zenczykowski@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Wed, 26 Oct 2022 17:42:37 +0900
Message-ID: <CAHo-Ooy5JB-0R5ZNMmEXaPfGjWKBw8VdXVp0d-XW2CNeO6u34A@mail.gmail.com>
Subject: Re: [PATCH] xfrm: fix inbound ipv4/udp/esp packets to UDPv6 dualstack sockets
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 5:32 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> Before Linux v5.8 an AF_INET6 SOCK_DGRAM (udp/udplite) socket
> with SOL_UDP, UDP_ENCAP, UDP_ENCAP_ESPINUDP{,_NON_IKE} enabled
> would just unconditionally use xfrm4_udp_encap_rcv(), afterwards
> such a socket would use the newly added xfrm6_udp_encap_rcv()
> which only handles IPv6 packets.
>
> Cc: Sabrina Dubroca <sd@queasysnail.net>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Fixes: 0146dca70b87 ('xfrm: add support for UDPv6 encapsulation of ESP')
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>  net/ipv6/xfrm6_input.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
> index 04cbeefd8982..2d1c75b42709 100644
> --- a/net/ipv6/xfrm6_input.c
> +++ b/net/ipv6/xfrm6_input.c
> @@ -86,6 +86,9 @@ int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff=
 *skb)
>         __be32 *udpdata32;
>         __u16 encap_type =3D up->encap_type;
>
> +       if (skb->protocol =3D=3D htons(ETH_P_IP))
> +               xfrm4_udp_encap_rcv(sk, skb);
> +
>         /* if this is not encapsulated socket, then just return now */
>         if (!encap_type)
>                 return 1;
> --
> 2.38.0.135.g90850a2211-goog

Does this seem reasonable?

I'll admit that so far I've only tested that the code builds.
However, the current code seems very obviously wrong, as it blindly
assumes (later in the function) that there's an ipv6 header on the
packet...

Our current API for creating these sockets specifies the port, but not
the ip version.
I think it would be beneficial if we could just always use AF_INET6
(and thus dualstack) sockets,
instead of how we currently just always use AF_INET udp sockets.

side note: with nat64 network based packet translation you can
actually end up with ipv6/udp/esp talking to ipv4/udp/esp, etc, and
you might not be able to tell that this is the case from looking at
the IP addresses themselves.

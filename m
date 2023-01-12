Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F64667A65
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 17:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjALQMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 11:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjALQLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 11:11:44 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D349713E92
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 08:05:36 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id c124so19180493ybb.13
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 08:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=27xqJWdcru6xXrx9U2TMVWvDMNXWrOANKcIbhlsNAL4=;
        b=EmEZxVAAgKHQ/nmPUB4gKobtgXf43rCTC8hXPKl4NmXER2qFaXuEaNbH2usLOKZaqx
         rDopsVKcV9prVQM6dmU01FHlPOLUN+irqAQVD6YkEW/lbw5a7mghl5bviijzEZX+HsYZ
         pGt4j4X5YWXHg5QC/zHjzZSjrthanc0OA6NzLHvPgl7lU8kQdlgcX1vroOw6ZGaBChbR
         TTwQhn3cKS1AXkDIpdACkCrXxSAPqy5c8j0CsDzld9Z8T9R2vRD0Drtd8mm+ZELVZ0MG
         9WquxnaElHDqE9fRgxL/EajktTeZf6L+3m59wU/yDjSHzYi5c+G99zOq8oOqCGyNTq2f
         K2Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=27xqJWdcru6xXrx9U2TMVWvDMNXWrOANKcIbhlsNAL4=;
        b=wg9KQUUDjDXLHZu6xWOBoxrLOGlVFcpdo21H8sEL05EKGqTBre2/pge9eojK475j8s
         KsPBPQU6+0SWeQYXJkW4yAygJRN4mRnSL2e9pWO+aNxnIwCaFpjbERBRGFEtkpqtMDLD
         r/VyjzjikMaiEHX3NhilTacqxBSfn0/qqYoEsUz1bDbfJWabGCAZwGDP2rRJw+JDOJxK
         Aq5verwCoTUpx4dOKIzHN7ZHviSmKP1IZH6RAFh32MznUVT++pqt8UzkXR1roybqO6oR
         niVPu0x8YfWrvCkLsCqyqb+tQcHxJEmZuAx6FBw/9eDWEbw/qx1KA7dQ0pJbfJ30hLrD
         Lorg==
X-Gm-Message-State: AFqh2kreC+lul7bb+bZDFvSGqcvGU2i3mNRVjpTAROz6fqDwHWpRpkrH
        ORCa7cnOLn2lRQZhjHwJbp8V/r5ZP4CmsiiRyL9fKw==
X-Google-Smtp-Source: AMrXdXtwOctqGK9jY1AxTHfRdkyjmn1PF3rsbX2d+2rOMcVYA7w70nO1j0wmh6GgdUqj2V68T4GjgDJ7+UOIDc5D2q0=
X-Received: by 2002:a5b:309:0:b0:703:e000:287 with SMTP id j9-20020a5b0309000000b00703e0000287mr8176328ybp.171.1673539535959;
 Thu, 12 Jan 2023 08:05:35 -0800 (PST)
MIME-Version: 1.0
References: <20230110191725.22675-1-admin@netgeek.ovh> <20230110191725.22675-2-admin@netgeek.ovh>
In-Reply-To: <20230110191725.22675-2-admin@netgeek.ovh>
From:   Willem de Bruijn <willemb@google.com>
Date:   Thu, 12 Jan 2023 11:04:58 -0500
Message-ID: <CA+FuTSdq5E7GMUghfoXMrs5_muv6VbhFym8DEhw=rAgStuvkQg@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/af_packet: fix tx skb network header on
 SOCK_RAW sockets over VLAN device
To:     =?UTF-8?Q?Herv=C3=A9_Boisse?= <admin@netgeek.ovh>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 2:38 PM Herv=C3=A9 Boisse <admin@netgeek.ovh> wrote=
:
>
> When an application sends a packet on a SOCK_RAW socket over a VLAN devic=
e,
> there is a possibility that the skb network header is incorrectly set.
>
> The issue happens when the device used to send the packet is a VLAN devic=
e
> whose underlying device has no VLAN tx hardware offloading support.
> In that case, the VLAN driver reports a LL header size increased by 4 byt=
es
> to take into account the tag that will be added in software.
>
> However, the socket user has no clue about that and still provides a norm=
al
> LL header without tag.

This is arguably a mistake.

A process using PF_PACKET to write to a device must know the link layer typ=
e.
SOCK_RAW should prepare a header equivalent to dev_hard_header (which
prepares it for SOCK_DGRAM). vlan_dev_hard_header clearly adds both the
Ethernet header and VLAN tag.

If applications assume virtual VLAN device exposes an Ethernet link layer,
then net/8021q/vlan_dev.c needs to expose that, including that hard_header_=
len.


> This results in the network header of the skb being shifted 4 bytes too f=
ar
> in the packet. This shift makes tc classifiers fail as they point to
> incorrect data.
>
> Move network header right after underlying VLAN device LL header size
> without tag, regardless of hardware offloading support. That is, the
> expected LL header size from socket user.
>
> Signed-off-by: Herv=C3=A9 Boisse <admin@netgeek.ovh>
> ---
>  net/packet/af_packet.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index c18274f65b17..be892fd498a6 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1933,6 +1933,18 @@ static void packet_parse_headers(struct sk_buff *s=
kb, struct socket *sock)
>                 skb->protocol =3D dev_parse_header_protocol(skb);
>         }
>
> +       /* VLAN device may report bigger LL header size due to reserved r=
oom for
> +        * tag on devices without hardware offloading support
> +        */
> +       if (is_vlan_dev(skb->dev) &&
> +           (sock->type =3D=3D SOCK_RAW || sock->type =3D=3D SOCK_PACKET)=
) {

Let's also try very hard to avoid adding branches in the hot path for
cases this rare.


> +               struct net_device *real_dev =3D vlan_dev_real_dev(skb->de=
v);
> +
> +               depth =3D real_dev->hard_header_len;
> +               if (pskb_may_pull(skb, depth))
> +                       skb_set_network_header(skb, depth);
> +       }
> +
>         /* Move network header to the right position for VLAN tagged pack=
ets */
>         if (likely(skb->dev->type =3D=3D ARPHRD_ETHER) &&
>             eth_type_vlan(skb->protocol) &&
> --
> 2.38.2
>

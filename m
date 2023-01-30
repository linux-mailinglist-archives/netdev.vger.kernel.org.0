Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D57E6807DC
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 09:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbjA3Ivp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 03:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjA3Ivm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 03:51:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3232CC63
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675068616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ETWZiFJuvDxfRpj4m9fhbGhq8mdnQQj8KzaCMCobHmE=;
        b=J21rCLILDEmQeMAqjR8DecvKJexryHBEw7nVZ0O5yQwjU30+FfK/ggmLG0AkVQl8aGCgaw
        n5QkeHwNN+C/ennj1YjIXu/eI6AX5QHDdLu0ZtnSC3geFaAeafH4em470T+21QisnscVx3
        sg5LhhPIRCt2b0Ilc/XzGbG5W8nWfY0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-606-MER5kCtHMwGhKSpwcmpxXQ-1; Mon, 30 Jan 2023 03:50:12 -0500
X-MC-Unique: MER5kCtHMwGhKSpwcmpxXQ-1
Received: by mail-qv1-f72.google.com with SMTP id ib5-20020a0562141c8500b0053c23b938a0so1459783qvb.17
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:50:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ETWZiFJuvDxfRpj4m9fhbGhq8mdnQQj8KzaCMCobHmE=;
        b=i3T+R85tPanIlncObBfHG+gHfoAB1z7rjzhJe7PSHjpZ3q1vOQxJCxhpH2A/iynSYR
         lhCRx78Poik8hsDOAJOAmU/CYquDiAB4cY5NJEqWQBY2Bmp1ijihMM6ytaFF+54bRmOI
         f6V5XTCYsn89ceKUB8TbYbqg4Fy+bpIGc7rbNei4ZU1Rv6nRgzWiTgToXQXuhO1Nnc1g
         5WWQPL2mJDkTk65mSIzx02TCLHB/bDCSUSL6EuKw7aJ6BeaMH0TYEIj965K+qDV3Qac8
         RO+i2uryQX0Yj+wm2qIQuSA1pgB7NKzKNDXwv4wvh8N+j3D9xET7RZdOsoOgg+YCNOBp
         /UcQ==
X-Gm-Message-State: AFqh2kq+yILNyff08oDBVK1B3Fbqa1Tbm+ieSiUETmVmmiB9uuCAUuxX
        YTNtJH9pVwJqejcAxfhOIcFwf2k8l747MFJR0RRoDioSjvE7WVgWgU9X/xagYh9IA4kImc5WA1g
        IRhqbYNpJC2G2LT07
X-Received: by 2002:a05:6214:3c98:b0:534:a801:1117 with SMTP id ok24-20020a0562143c9800b00534a8011117mr70508934qvb.49.1675068612343;
        Mon, 30 Jan 2023 00:50:12 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt62wRIQFd2BqlEWxGlcfaPxrQtbtWHJYjjiPiNI6lpwthrnpINmGwCX2M3B3u0AyoiV+x2Wg==
X-Received: by 2002:a05:6214:3c98:b0:534:a801:1117 with SMTP id ok24-20020a0562143c9800b00534a8011117mr70508915qvb.49.1675068612068;
        Mon, 30 Jan 2023 00:50:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id dy31-20020a05620a60df00b0070531c5d655sm7694441qkb.90.2023.01.30.00.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 00:50:11 -0800 (PST)
Message-ID: <ec534eacabf5c859930eb5ca7f417f7f01197d24.camel@redhat.com>
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in
 GRO
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Alexander Duyck <alexander.duyck@gmail.com>, nbd@nbd.name,
        davem@davemloft.net, hawk@kernel.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, lorenzo@kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 30 Jan 2023 09:50:08 +0100
In-Reply-To: <CANn89iKgZU4Q+THXupzZi4hETuKuCOvOB=iHpp5JzQTNv_Fg_A@mail.gmail.com>
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
         <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
         <cde24ed8-1852-ce93-69f3-ff378731f52c@huawei.com>
         <20230127212646.4cfeb475@kernel.org>
         <CANn89iKgZU4Q+THXupzZi4hETuKuCOvOB=iHpp5JzQTNv_Fg_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-01-28 at 08:08 +0100, Eric Dumazet wrote:
> On Sat, Jan 28, 2023 at 6:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >=20
> > On Sat, 28 Jan 2023 10:37:47 +0800 Yunsheng Lin wrote:
> > > If we are not allowing gro for the above case, setting NAPI_GRO_CB(p)=
->flush
> > > to 1 in gro_list_prepare() seems to be making more sense so that the =
above
> > > case has the same handling as skb_has_frag_list() handling?
> > > https://elixir.bootlin.com/linux/v6.2-rc4/source/net/core/gro.c#L503
> > >=20
> > > As it seems to avoid some unnecessary operation according to comment
> > > in tcp4_gro_receive():
> > > https://elixir.bootlin.com/linux/v6.2-rc4/source/net/ipv4/tcp_offload=
.c#L322
> >=20
> > The frag_list case can be determined with just the input skb.
> > For pp_recycle we need to compare input skb's pp_recycle with
> > the pp_recycle of the skb already held by GRO.
> >=20
> > I'll hold off with applying a bit longer tho, in case Eric
> > wants to chime in with an ack or opinion.
>=20
> We can say that we are adding in the fast path an expensive check
> about an unlikely condition.
>=20
> GRO is by far the most expensive component in our stack.

Slightly related to the above: currently the GRO engine performs the
skb metadata check for every packet. My understanding is that even with
XDP enabled and ebpf running on the given packet, the skb should=20
usually have meta_len =3D=3D 0.=C2=A0

What about setting 'skb->slow_gro' together with meta_len and moving
the skb_metadata_differs() check under the slow_gro guard?

Cheers,

Paolo


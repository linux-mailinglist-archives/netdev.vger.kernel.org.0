Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAEF670BC2
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 23:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjAQWkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 17:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjAQWjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 17:39:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CE82200E
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 14:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673993751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nVCdnSPpgSc0Lut4xjL5N2UTJnAW1T5qJ5v9mxraf2M=;
        b=PZNtQZdXYpxcFX9EaR16PLuBPdSdpS88s8zyxq2v71E1wSzLTTXi7EBBn24e0oMQNseNMd
        M1PYJ2KzBIvJ8BFFApHK3TlnLnk5oDU0r74cZu3Lt9pIjH87DHsIZZGNXyBh1fW2ZnljwS
        mIz+o6QEy7uHUFvkfRvjyF/UMvv3v50=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-57-tcJyjOs4P4aR5rru_UXF5g-1; Tue, 17 Jan 2023 17:15:50 -0500
X-MC-Unique: tcJyjOs4P4aR5rru_UXF5g-1
Received: by mail-ed1-f69.google.com with SMTP id x13-20020a05640226cd00b0047ac11c9774so22272734edd.17
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 14:15:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nVCdnSPpgSc0Lut4xjL5N2UTJnAW1T5qJ5v9mxraf2M=;
        b=VsRQK1fdJXXwUuxSZpIi9YqVMkvv+uf4WY0pWwvUlLEkZZEDfB1avYh7Dr1yMV926r
         oC6KUjEiHHjVszT14xYN9Q1a6dvRLNQsKRseBkJ20fuJBGtcGKepQTB/M4NksqhNutW/
         8HecJLMBNDeBEZm8eTa42LYts0PI0vSGbkE3TpsXYrwRwe1aLVJs6ddef1Lc2UAGxGlY
         2xl6XK+3HhVxNZZ2Xp0ZVDYZpn9mB4xTDcuHP+8Rd//0JrOU32Iv0V4uFoITJ5AJevgW
         gooHnUcyT7lNrxYuFKNu/VdeRKlsy4n/Tcd/buiVexJvjGZueW89lJ8KeQSQjnJO0N+j
         /QRg==
X-Gm-Message-State: AFqh2krhdFyl8hmXoRCuAE6fp+6az54QmlBHGyCItz3Hl8F4jO4UspkZ
        rVTbDdFOao9RR7df45ZZIjNqRXarDLjCdXtYF3XpE0FnoZ406L7hHDouFMowkfHOc6W4Bp4MSO/
        tYVUEg6MCKPb1yrq1
X-Received: by 2002:a17:907:76c6:b0:877:564a:6fd3 with SMTP id kf6-20020a17090776c600b00877564a6fd3mr182127ejc.21.1673993749162;
        Tue, 17 Jan 2023 14:15:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtct0L+6H586Hqk7KUwB31Uwdc2ltJ7NpPWPm0QfBMU5pi3ouGi3JVmNp1YtMSvhkEzQ5BRBw==
X-Received: by 2002:a17:907:76c6:b0:877:564a:6fd3 with SMTP id kf6-20020a17090776c600b00877564a6fd3mr182089ejc.21.1673993748801;
        Tue, 17 Jan 2023 14:15:48 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r2-20020a17090609c200b007bd28b50305sm13685716eje.200.2023.01.17.14.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 14:15:48 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 819879011A9; Tue, 17 Jan 2023 23:15:47 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@corigine.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        memxor@gmail.com, alardam@gmail.com, saeedm@nvidia.com,
        anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [RFC v2 bpf-next 2/7] drivers: net: turn on XDP features
In-Reply-To: <Y8cboWSmvoOKxav2@oden.dyn.berto.se>
References: <cover.1673710866.git.lorenzo@kernel.org>
 <b606e729c9baf36a28be246bf0bfa4d21cc097fb.1673710867.git.lorenzo@kernel.org>
 <Y8cTKOmCBbMEZK8D@sleipner.dyn.berto.se> <87y1q0bz6m.fsf@toke.dk>
 <Y8cboWSmvoOKxav2@oden.dyn.berto.se>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 17 Jan 2023 23:15:47 +0100
Message-ID: <87sfg8byek.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Niklas S=C3=B6derlund <niklas.soderlund@corigine.com> writes:

> Hi Toke,
>
> On 2023-01-17 22:58:57 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Niklas S=C3=B6derlund <niklas.soderlund@corigine.com> writes:
>>=20
>> > Hi Lorenzo and Marek,
>> >
>> > Thanks for your work.
>> >
>> > On 2023-01-14 16:54:32 +0100, Lorenzo Bianconi wrote:
>> >
>> > [...]
>> >
>> >>=20
>> >> Turn 'hw-offload' feature flag on for:
>> >>  - netronome (nfp)
>> >>  - netdevsim.
>> >
>> > Is there a definition of the 'hw-offload' written down somewhere? From=
=20
>> > reading this series I take it is the ability to offload a BPF program?=
=20=20
>>=20
>> Yeah, basically this means "allows loading and attaching programs in
>> XDP_MODE_HW", I suppose :)
>>=20
>> > It would also be interesting to read documentation for the other flags=
=20
>> > added in this series.
>>=20
>> Yup, we should definitely document them :)
>>=20
>> > [...]
>> >
>> >> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c=20
>> >> b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
>> >> index 18fc9971f1c8..5a8ddeaff74d 100644
>> >> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
>> >> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
>> >> @@ -2529,10 +2529,14 @@ static void nfp_net_netdev_init(struct nfp_ne=
t *nn)
>> >>  	netdev->features &=3D ~NETIF_F_HW_VLAN_STAG_RX;
>> >>  	nn->dp.ctrl &=3D ~NFP_NET_CFG_CTRL_RXQINQ;
>> >>=20=20
>> >> +	nn->dp.netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC |
>> >> +				      NETDEV_XDP_ACT_HW_OFFLOAD;
>> >
>> > If my assumption about the 'hw-offload' flag above is correct I think=
=20
>> > NETDEV_XDP_ACT_HW_OFFLOAD should be conditioned on that the BPF firmwa=
re=20
>> > flavor is in use.
>> >
>> >     nn->dp.netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC;
>> >
>> >     if (nn->app->type->id =3D=3D NFP_APP_BPF_NIC)
>> >         nn->dp.netdev->xdp_features |=3D NETDEV_XDP_ACT_HW_OFFLOAD;
>> >
>> >> +
>> >>  	/* Finalise the netdev setup */
>> >>  	switch (nn->dp.ops->version) {
>> >>  	case NFP_NFD_VER_NFD3:
>> >>  		netdev->netdev_ops =3D &nfp_nfd3_netdev_ops;
>> >> +		nn->dp.netdev->xdp_features |=3D NETDEV_XDP_ACT_XSK_ZEROCOPY;
>> >>  		break;
>> >>  	case NFP_NFD_VER_NFDK:
>> >>  		netdev->netdev_ops =3D &nfp_nfdk_netdev_ops;
>> >
>> > This is also a wrinkle I would like to understand. Currently NFP suppo=
rt=20
>> > zero-copy on NFD3, but not for offloaded BPF programs. But with the BP=
F=20
>> > firmware flavor running the device can still support zero-copy for=20
>> > non-offloaded programs.
>> >
>> > Is it a problem that the driver advertises support for both=20
>> > hardware-offload _and_ zero-copy at the same time, even if they can't =
be=20
>> > used together but separately?
>>=20
>> Hmm, so the idea with this is to only expose feature flags that are
>> supported "right now" (you'll note that some of the drivers turn the
>> REDIRECT_TARGET flag on and off at runtime). Having features that are
>> "supported but in a different configuration" is one of the points of
>> user confusion we want to clear up with the explicit flags.
>>=20
>> So I guess it depends a little bit what you mean by "can't be used
>> together"? I believe it's possible to load two programs at the same
>> time, one in HW mode and one in native (driver) mode, right? In this
>> case, could the driver mode program use XSK zerocopy while the HW mode
>> program is also loaded?
>
> Exactly, this is my concern. Two programs can be loaded at the same=20
> time, one in HW mode and one in native mode. The program in native mode=20
> can use zero-copy at the same time as another program runs in HW mode.
>
> But the program running in HW mode can never use zero-copy.

Hmm, but zero-copy is an AF_XDP feature, and AFAIK offloaded programs
can't use AF_XDP at all? So the zero-copy "feature" is available on the
hardware, it's just intrinsic to that feature that it doesn't work on
offloaded programs?

Which goes back to: yeah, we should document what the feature flags mean :)

-Toke


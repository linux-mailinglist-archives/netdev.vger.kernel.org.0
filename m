Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D374C670B94
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 23:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjAQWYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 17:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjAQWSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 17:18:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D394DE2F
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 13:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673992741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZpC47ZAac9QR/hP8cE59hdbTaxenYITufUhqUaUmasI=;
        b=JUdx6H9nrFt4fH1i2U+LArzxg0MUd3w5xzvVHja3CwrBaAhgchSUa0y71hSBOYr1rrZ7WN
        lIZ0PAhdAcyZrjRAWtsEHTF0FYKvD5BNrQhwsXqlchLVFZx5BWYYkhxNfybkyeXA+gnJqO
        dg/jWzVNqXlllnSGZx6q3i8989OKNOE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-618-S_Qz6EMrMuiLG9sm4kspjg-1; Tue, 17 Jan 2023 16:59:00 -0500
X-MC-Unique: S_Qz6EMrMuiLG9sm4kspjg-1
Received: by mail-ej1-f71.google.com with SMTP id gn31-20020a1709070d1f00b0087024adbba2so5137141ejc.20
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 13:59:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZpC47ZAac9QR/hP8cE59hdbTaxenYITufUhqUaUmasI=;
        b=SiRo6Tk5KmbtqrPFI/CVX0qUuak6bC2723Lyq30biiGSaiR7KfKGgdfYd+BS8G+eVB
         WtvWW+5lRbSKtZwRWZulOTy/bLd7A5BecxIdWJqd/ZdFgud9XTfTAB6u+WdL5yR536sY
         AvJZr5gByUjS0B8lLWFcyFiOUEVQjgUgYX7ZPUlC4xmBpKSYpta9KPOEqkhSFlzWboa9
         a7FwaCKeGSnkb1Q9weqVuQQqpv6py9F0LKAfjQ6xprDVX9N7tYMt85IOUgmPn3khp/uV
         G8yucgGUEjBa89V8rXmLUrOnD0VNHSgC05Kw3U5P6UpljuhH3GPK8JZgV+2LsDSvyMb+
         qMxQ==
X-Gm-Message-State: AFqh2kpWIDjSGaDGSYDxdLmryFbduZEEKX4YosvsRCQMp+q3y6bnFn4S
        +CQFsfZPKAhvJ9BwLyUPMG4QTZT3Lv0LXTAhE8QrjdGxd2vnoc1I7C4YKUEkmnXeYUjfUVleAN2
        Jsl4wSzrAyaT8QsjS
X-Received: by 2002:a17:906:5d1:b0:861:7a02:1046 with SMTP id t17-20020a17090605d100b008617a021046mr4453995ejt.37.1673992739096;
        Tue, 17 Jan 2023 13:58:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvn/uG4kaZgjhWjt2xaWdG8enkNDaED9Qq1xVDHJQawI8Y47x89PbCi4tmTDPx1m6XWiFFdeg==
X-Received: by 2002:a17:906:5d1:b0:861:7a02:1046 with SMTP id t17-20020a17090605d100b008617a021046mr4453975ejt.37.1673992738768;
        Tue, 17 Jan 2023 13:58:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id kx5-20020a170907774500b007c14ae38a80sm13562208ejc.122.2023.01.17.13.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 13:58:58 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6241190119F; Tue, 17 Jan 2023 22:58:57 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [RFC v2 bpf-next 2/7] drivers: net: turn on XDP features
In-Reply-To: <Y8cTKOmCBbMEZK8D@sleipner.dyn.berto.se>
References: <cover.1673710866.git.lorenzo@kernel.org>
 <b606e729c9baf36a28be246bf0bfa4d21cc097fb.1673710867.git.lorenzo@kernel.org>
 <Y8cTKOmCBbMEZK8D@sleipner.dyn.berto.se>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 17 Jan 2023 22:58:57 +0100
Message-ID: <87y1q0bz6m.fsf@toke.dk>
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

> Hi Lorenzo and Marek,
>
> Thanks for your work.
>
> On 2023-01-14 16:54:32 +0100, Lorenzo Bianconi wrote:
>
> [...]
>
>>=20
>> Turn 'hw-offload' feature flag on for:
>>  - netronome (nfp)
>>  - netdevsim.
>
> Is there a definition of the 'hw-offload' written down somewhere? From=20
> reading this series I take it is the ability to offload a BPF program?=20=
=20

Yeah, basically this means "allows loading and attaching programs in
XDP_MODE_HW", I suppose :)

> It would also be interesting to read documentation for the other flags=20
> added in this series.

Yup, we should definitely document them :)

> [...]
>
>> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c=20
>> b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
>> index 18fc9971f1c8..5a8ddeaff74d 100644
>> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
>> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
>> @@ -2529,10 +2529,14 @@ static void nfp_net_netdev_init(struct nfp_net *=
nn)
>>  	netdev->features &=3D ~NETIF_F_HW_VLAN_STAG_RX;
>>  	nn->dp.ctrl &=3D ~NFP_NET_CFG_CTRL_RXQINQ;
>>=20=20
>> +	nn->dp.netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC |
>> +				      NETDEV_XDP_ACT_HW_OFFLOAD;
>
> If my assumption about the 'hw-offload' flag above is correct I think=20
> NETDEV_XDP_ACT_HW_OFFLOAD should be conditioned on that the BPF firmware=
=20
> flavor is in use.
>
>     nn->dp.netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC;
>
>     if (nn->app->type->id =3D=3D NFP_APP_BPF_NIC)
>         nn->dp.netdev->xdp_features |=3D NETDEV_XDP_ACT_HW_OFFLOAD;
>
>> +
>>  	/* Finalise the netdev setup */
>>  	switch (nn->dp.ops->version) {
>>  	case NFP_NFD_VER_NFD3:
>>  		netdev->netdev_ops =3D &nfp_nfd3_netdev_ops;
>> +		nn->dp.netdev->xdp_features |=3D NETDEV_XDP_ACT_XSK_ZEROCOPY;
>>  		break;
>>  	case NFP_NFD_VER_NFDK:
>>  		netdev->netdev_ops =3D &nfp_nfdk_netdev_ops;
>
> This is also a wrinkle I would like to understand. Currently NFP support=
=20
> zero-copy on NFD3, but not for offloaded BPF programs. But with the BPF=20
> firmware flavor running the device can still support zero-copy for=20
> non-offloaded programs.
>
> Is it a problem that the driver advertises support for both=20
> hardware-offload _and_ zero-copy at the same time, even if they can't be=
=20
> used together but separately?

Hmm, so the idea with this is to only expose feature flags that are
supported "right now" (you'll note that some of the drivers turn the
REDIRECT_TARGET flag on and off at runtime). Having features that are
"supported but in a different configuration" is one of the points of
user confusion we want to clear up with the explicit flags.

So I guess it depends a little bit what you mean by "can't be used
together"? I believe it's possible to load two programs at the same
time, one in HW mode and one in native (driver) mode, right? In this
case, could the driver mode program use XSK zerocopy while the HW mode
program is also loaded?

-Toke


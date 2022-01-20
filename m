Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC910494BA9
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 11:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376264AbiATK2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 05:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359865AbiATK17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 05:27:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB4CC06173F
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 02:27:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F973B81D18
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 10:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA249C340E0;
        Thu, 20 Jan 2022 10:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642674475;
        bh=u6j66+9CPFpQPXgEUE3q27YK4PjpkTUCjnf6GUNOv9s=;
        h=In-Reply-To:References:To:From:Cc:Subject:Date:From;
        b=Sk6mhRryPYx6NKR8AZHvRN8z90eoXsBnWdUVQ5PCpg7iBmBwzrot62ijMUIjUjGDa
         UBudTgfUMo7VpGgsBNAesq2qpeintHZgRvyTBA4HxnEyMCp1F/nZZAoEQSMtvQ2DP4
         yrQM2qe7KLTSZz7EMrQe2n4Z6s1MGDh9sfqutDt96PEL+oIcNnV3a+VybXf4j3ppEe
         XaVhy+KPoejnWrA8k7vOJsCZZlSEJbYIcNHTM4zY1pqr1I6kg5S/I73+8DtNPwb4LP
         OROrqUHA90VvApZkZ6qaF6uX3Gc9HMZaYgUsOExDvyT5z6oTNMg06J3652GY4le508
         TEaDANs/mt0Fg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ygnhh79yluw2.fsf@nvidia.com>
References: <20210325153533.770125-1-atenart@kernel.org> <20210325153533.770125-2-atenart@kernel.org> <ygnhh79yluw2.fsf@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
From:   Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, echaudro@redhat.com,
        sbrivio@redhat.com, netdev@vger.kernel.org, pshelar@ovn.org
Subject: Re: [PATCH net 1/2] vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP reply
Message-ID: <164267447125.4497.8151505359440130213@kwain>
Date:   Thu, 20 Jan 2022 11:27:51 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vlad,

Quoting Vlad Buslov (2022-01-20 08:38:05)
> On Thu 25 Mar 2021 at 17:35, Antoine Tenart <atenart@kernel.org> wrote:
> >
> > diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> > index 666dd201c3d5..53dbc67e8a34 100644
> > --- a/drivers/net/vxlan.c
> > +++ b/drivers/net/vxlan.c
> > @@ -2725,12 +2725,17 @@ static void vxlan_xmit_one(struct sk_buff *skb,=
 struct net_device *dev,
> >                       goto tx_error;
> >               } else if (err) {
> >                       if (info) {
> > +                             struct ip_tunnel_info *unclone;
> >                               struct in_addr src, dst;
> > =20
> > +                             unclone =3D skb_tunnel_info_unclone(skb);
> > +                             if (unlikely(!unclone))
> > +                                     goto tx_error;
> > +
>=20
> We have been getting memleaks in one of our tests that point to this
> code (test deletes vxlan device while running traffic redirected by OvS
> TC at the same time):
>=20
> unreferenced object 0xffff8882d0114200 (size 256):
>   comm "softirq", pid 0, jiffies 4296140292 (age 1435.992s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 3b 85 84 ff ff ff ff  .........;......
>     a1 26 b7 83 ff ff ff ff 00 00 00 00 00 00 00 00  .&..............
>   backtrace:
>     [<0000000097659d47>] metadata_dst_alloc+0x1f/0x470
>     [<000000007571c30f>] tun_dst_unclone+0xee/0x360 [vxlan]
>     [<00000000d2dcfd00>] vxlan_xmit_one+0x131d/0x2a00 [vxlan]
>     [<00000000281572b6>] vxlan_xmit+0x8e6/0x4cd0 [vxlan]
>     [<00000000d49d33fe>] dev_hard_start_xmit+0x1ba/0x710
>     [<00000000eac444f5>] __dev_queue_xmit+0x17c5/0x25f0
>     [<000000005fbd8585>] tcf_mirred_act+0xb1d/0xf70 [act_mirred]
>     [<0000000064b6eb2d>] tcf_action_exec+0x10e/0x350
>     [<00000000352821e8>] fl_classify+0x4e3/0x610 [cls_flower]
>     [<0000000011d3f765>] tcf_classify+0x33d/0x800
>     [<000000006c69b225>] __netif_receive_skb_core+0x18d6/0x2ae0
>     [<00000000dd256fe3>] __netif_receive_skb_one_core+0xaf/0x180
>     [<0000000065d43bd6>] process_backlog+0x2e3/0x710
>     [<00000000964357ae>] __napi_poll+0x9f/0x560
>     [<0000000059a93cf6>] net_rx_action+0x357/0xa60
>     [<00000000766481bc>] __do_softirq+0x282/0x94e
>=20
> Looking at the code the potential issue seems to be that
> tun_dst_unclone() creates new metadata_dst instance with refcount=3D=3D1,
> increments the refcount with dst_hold() to value 2, then returns it.
> This seems to imply that caller is expected to release one of the
> references (second one if for skb), but none of the callers (including
> original dev_fill_metadata_dst()) do that, so I guess I'm
> misunderstanding something here.
>=20
> Any tips or suggestions?

I'd say there is no need to increase the dst refcount here after calling
metadata_dst_alloc, as the metadata is local to the skb and the dst
refcount was already initialized to 1. This might be an issue with
commit fc4099f17240 ("openvswitch: Fix egress tunnel info."); I CCed
Pravin, he might recall if there was a reason to increase the refcount.

Thanks,
Antoine

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483A568D4EC
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbjBGK5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBGK5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:57:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C18EB75
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675767384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=utLBczvzekSz+cWIa2fZgxlACvw9W5bN6q2slvl+YPI=;
        b=XHPRiADk5zsOpa4/Rmrv0EEihhekv4yTpsoAb92AHyTS7D12WynEd50kRz1f3Xl0cB93fc
        UUk5J0VAbi2b3cng3f679KgtJqC4l5RR+3qdFsNYfO8YcyouuIdpx4pQ6eWwf5s/IPyFzd
        3vfenl/NcghVIwxZXmVHI73kjX8TOcU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-256-AqIkKnaEN82Rj2w3fcKV3A-1; Tue, 07 Feb 2023 05:56:20 -0500
X-MC-Unique: AqIkKnaEN82Rj2w3fcKV3A-1
Received: by mail-qv1-f69.google.com with SMTP id kd28-20020a056214401c00b0053cd4737a42so7501565qvb.22
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 02:56:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=utLBczvzekSz+cWIa2fZgxlACvw9W5bN6q2slvl+YPI=;
        b=0JuuGll7nyKOzSCfy+hZW9OXDbU/cd+LAlelxcBdyqRfMNl51umNv59RJ1Hf8NYhwp
         YcWcpQgvc5OlGieHOhzVUl6rHspNTR1UY6ce0iNRKDbU8uZV86rWdQnXhgd8hD0Elz0z
         Sf/CKWuBT126R5lFJST0PBsvegltseMBjfQ8Uci7S4zMzDaCsWJ4AE2XqHhGe8UQKCNy
         kFN+ws55GJj4nGoXC7c0pRwTbFGLIoV9Qp+d2I6ah34/8nLk603Juc7jH20G4OVhSyuu
         24h6vPWYTIhfdurz8AYT2QQbEoFuf/DG7WuBLKsb322AtR2DtvgvkgZA2Ys06uVsb6ky
         Gjrw==
X-Gm-Message-State: AO0yUKWhvRzg8BVZOiBhMr5g7iCXKChAO/HQqA/5TWsHWW+6hiRJMao5
        c2V/++rC9KNqxKwlb2S5nyo59mZaHChjAhqMXWRFE6Bx+UeOkGmnjp6zelPm9ERUaV9jpPwcexW
        kzjtScWO253q/rCYsUla8Rg==
X-Received: by 2002:ac8:5709:0:b0:3b8:4951:57bb with SMTP id 9-20020ac85709000000b003b8495157bbmr5547285qtw.5.1675767379824;
        Tue, 07 Feb 2023 02:56:19 -0800 (PST)
X-Google-Smtp-Source: AK7set/zTGzMRBR7nAgHkQ8IpNXUs+WHjz4jc2IOn+RfYLyKZo3Xwo4UgiGqPFMVxiMcEINisz+yfw==
X-Received: by 2002:ac8:5709:0:b0:3b8:4951:57bb with SMTP id 9-20020ac85709000000b003b8495157bbmr5547245qtw.5.1675767379532;
        Tue, 07 Feb 2023 02:56:19 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id s26-20020a05622a1a9a00b003b62e8b77e7sm9218291qtc.68.2023.02.07.02.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 02:56:19 -0800 (PST)
Message-ID: <c4c90e6576f1bc4ef9d634edda5862c5f003ae3c.camel@redhat.com>
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, richard@routerhints.com
Date:   Tue, 07 Feb 2023 11:56:13 +0100
In-Reply-To: <20230206174627.mv4ljr4gtkpr7w55@skbuf>
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
         <3649b6f9-a028-8eaf-ac89-c4d0fce412da@arinc9.com>
         <20230205203906.i3jci4pxd6mw74in@skbuf>
         <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
         <20230205235053.g5cttegcdsvh7uk3@skbuf>
         <116ff532-4ebc-4422-6599-1d5872ff9eb8@arinc9.com>
         <20230206174627.mv4ljr4gtkpr7w55@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 2023-02-06 at 19:46 +0200, Vladimir Oltean wrote:
> On Mon, Feb 06, 2023 at 07:41:06PM +0300, Ar=C4=B1n=C3=A7 =C3=9CNAL wrote=
:
> > Finally I got time. It's been a seismically active day where I'm from.
>=20
> My deepest condolences to those who experienced tragedies after today's
> earthquakes. A lot of people in neighboring countries are horrified
> thinking when this will happen to them. Hopefully you aren't living in
> Gaziantep or nearby cities.
>=20
> > # ping 192.168.2.2
> > PING 192.168.2.2
> > [   39.508013] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: ther=
e is no metadata dst attached to skb 0xc2dfecc0
> >=20
> > # ping 192.168.2.2
> > PING 192.168.2.2
> > [   22.674182] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: receive=
d skb 0xc2d67840 without VLAN/DSA tag present
>=20
> Thank you so much for testing. Would you mind cleaning everything up and
> testing with this patch instead (formatted on top of net-next)?
> Even if you need to adapt to your tree, hopefully you get the idea from
> the commit message.
>=20
> From 218025fd0c33a06865e4202c5170bfc17e26cc75 Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Mon, 6 Feb 2023 19:03:53 +0200
> Subject: [PATCH] net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for s=
witch
>  port 0
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> Ar=C4=B1n=C3=A7 reports that on his MT7621AT Unielec U7621-06 board and M=
T7623NI
> Bananapi BPI-R2, packets received by the CPU over mt7530 switch port 0
> (of which this driver acts as the DSA master) are not processed
> correctly by software. More precisely, they arrive without a DSA tag
> (in packet or in the hwaccel area - skb_metadata_dst()), so DSA cannot
> demux them towards the switch's interface for port 0. Traffic from other
> ports receives a skb_metadata_dst() with the correct port and is demuxed
> properly.
>=20
> Looking at mtk_poll_rx(), it becomes apparent that this driver uses the
> skb vlan hwaccel area:
>=20
> 	union {
> 		u32		vlan_all;
> 		struct {
> 			__be16	vlan_proto;
> 			__u16	vlan_tci;
> 		};
> 	};
>=20
> as a temporary storage for the VLAN hwaccel tag, or the DSA hwaccel tag.
> If this is a DSA master it's a DSA hwaccel tag, and finally clears up
> the skb VLAN hwaccel header.
>=20
> I'm guessing that the problem is the (mis)use of API.
> skb_vlan_tag_present() looks like this:
>=20
>  #define skb_vlan_tag_present(__skb)	(!!(__skb)->vlan_all)
>=20
> So if both vlan_proto and vlan_tci are zeroes, skb_vlan_tag_present()
> returns precisely false. I don't know for sure what is the format of the
> DSA hwaccel tag, but I surely know that lowermost 3 bits of vlan_proto
> are 0 when receiving from port 0:
>=20
> 	unsigned int port =3D vlan_proto & GENMASK(2, 0);
>=20
> If the RX descriptor has no other bits set to non-zero values in
> RX_DMA_VTAG, then the call to __vlan_hwaccel_put_tag() will not, in
> fact, make the subsequent skb_vlan_tag_present() return true, because
> it's implemented like this:
>=20
> static inline void __vlan_hwaccel_put_tag(struct sk_buff *skb,
> 					  __be16 vlan_proto, u16 vlan_tci)
> {
> 	skb->vlan_proto =3D vlan_proto;
> 	skb->vlan_tci =3D vlan_tci;
> }
>=20
> What we need to do to fix this problem (assuming this is the problem) is
> to stop using skb->vlan_all as temporary storage for driver affairs, and
> just create some local variables that serve the same purpose, but
> hopefully better. Instead of calling skb_vlan_tag_present(), let's look
> at a boolean has_hwaccel_tag which we set to true when the RX DMA
> descriptors have something. Disambiguate based on netdev_uses_dsa()
> whether this is a VLAN or DSA hwaccel tag, and only call
> __vlan_hwaccel_put_tag() if we're certain it's a VLAN tag.
>=20
> Link: https://lore.kernel.org/netdev/704f3a72-fc9e-714a-db54-272e17612637=
@arinc9.com/
> Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA unt=
agging")
> Reported-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thank you Vladimir for the quick turn-around!=20

For future case, please avoid replying with new patches - tag area
included - to existing patch/thread, as it confuses tag propagation,
thanks!

Paolo


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28DF2614544
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 08:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiKAHy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 03:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKAHy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 03:54:26 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDB92BC1;
        Tue,  1 Nov 2022 00:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667289265; x=1698825265;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tLO+v2AzJKaQNkzAWghgg1NvzuHZPK/g4CtPHCzvZpo=;
  b=Ndz88Li8/2gDxhD6tPoTDLa9rbBXXyoP1vmmbAcLsrp1OYzYAai6NCmx
   I1qy+QFcZnDah5auNT6GlMFHxiyhVXTMedUkI+BZcXOFt+jxB51wUqVIL
   YASfVuGPPmZro+has7KsAkh1elOHC0Pte2anMYiCd2DdoUFZjAOfKN64g
   uLavSORJk9OjcW8tBHH0tfU02Qpt6Jx2QVbIM1OOxgeUfHQQt21R+OJlo
   xHKql8+EzEbdLaOQUFxrMZdNBjDJSInWxLdBw9x5HhaOhW2/1F7Ac3vbu
   ZJRcpuPC2wkztaMaWDp33Df2OgL3xffMBcxO4Bq3LQEekt2bTL+l3Uv7q
   g==;
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="184784313"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2022 00:54:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 1 Nov 2022 00:54:24 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Tue, 1 Nov 2022 00:54:23 -0700
Date:   Tue, 1 Nov 2022 08:59:06 +0100
From:   'Horatiu Vultur' <horatiu.vultur@microchip.com>
To:     David Laight <David.Laight@aculab.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net v2 0/3] net: lan966x: Fixes for when MTU is changed
Message-ID: <20221101075906.ets6zsti3c54idae@soft-dev3-1>
References: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
 <b75a7136030846f587e555763ef2750e@AcuMS.aculab.com>
 <20221031150133.2be5xr7cmuhr4gng@soft-dev3-1>
 <219ebe83a5ad4467937545ee5a0e77e4@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <219ebe83a5ad4467937545ee5a0e77e4@AcuMS.aculab.com>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 10/31/2022 15:27, David Laight wrote:
> 
> From: 'Horatiu Vultur'
> > Sent: 31 October 2022 15:02
> >
> > The 10/31/2022 10:43, David Laight wrote:
> > >
> > > From: Horatiu Vultur
> > > > Sent: 30 October 2022 21:37
> >
> > Hi David,
> >
> > > >
> > > > There were multiple problems in different parts of the driver when
> > > > the MTU was changed.
> > > > The first problem was that the HW was missing to configure the correct
> > > > value, it was missing ETH_HLEN and ETH_FCS_LEN. The second problem was
> > > > when vlan filtering was enabled/disabled, the MRU was not adjusted
> > > > corretly. While the last issue was that the FDMA was calculated wrongly
> > > > the correct maximum MTU.
> > >
> > > IIRC all these lengths are 1514, 1518 and maybe 1522?
> >
> > And also 1526, if the frame has 2 vlan tags.
> >
> > > How long are the actual receive buffers?
> > > I'd guess they have to be rounded up to a whole number of cache lines
> > > (especially on non-coherent systems) so are probably 1536 bytes.
> >
> > The receive buffers can be different sizes, it can be up to 65k.
> > They are currently allign to page size.
> 
> Is that necessary?

HW requires to have the start of frame alligned to 128 bytes.

> I don't know where the buffers are allocated, but even 4k seems
> a bit profligate for normal ethernet mtu.
> If the page size if larger it is even sillier.

For lan966x the pages are allocated here [1]

> 
> If the buffer is embedded in an skb you really want the skb
> to be under 4k (I don't think a 1500 byte mtu can fit in 2k).
> 
> But you might as well tell the hardware the actual buffer length
> (remember to allow for the crc and any alignment header).

I am already doing that here [2]
And I need to do it for each frame it can received.

> 
> > >
> > > If driver does support 8k+ jumbo frames just set the hardware
> > > frame length to match the receive buffer size.
> >
> > In that case I should always allocate maximum frame size(65k) for all
> > regardless of the MTU?
> 
> That would be very wasteful.

Yes, I agree.

> I'd set the buffer large enough for the mtu but let the hardware fill
> the entire buffer.

I am not 100% sure I follow it. Can you expend on this a little bit?

> 
> Allocating 64k buffers for big jumbo frames doesn't seem right.
> If the mtu is 64k then kmalloc() will allocate 128k.
> This is going to cause 'oddities' with small packets where
> the 'true_size' is massively more than the data size.
> 
> Isn't there a scheme where you can create an skb from a page
> list that contains fragments of the ethernet frame?

Can I use '__skb_fill_page_desc'?

> In which case I'd have thought you'd want to fill the ring
> with page size buffers and then handle the hardware writing
> a long frame to multiple buffers/descriptors.

It might be a good idea. I need to look in more details about this.
Because it would change a little bit the logic on how the frames are
received and see how this will impact for frames under a page.
Also I was thinking next to use page_pool API, for which I send a patch
[3] but is deffered by this patch series.
But all these possible changes will need to go through net-next.

> 
>         David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

[1] https://elixir.bootlin.com/linux/v6.1-rc3/source/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c#L17
[2] https://elixir.bootlin.com/linux/v6.1-rc3/source/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c#L70
[3] https://lore.kernel.org/bpf/20221019135008.3281743-6-horatiu.vultur@microchip.com/

-- 
/Horatiu

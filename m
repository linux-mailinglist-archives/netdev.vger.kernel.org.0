Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293DA614EBA
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 17:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiKAQAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 12:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiKAQAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 12:00:14 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1DF13E9A;
        Tue,  1 Nov 2022 09:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667318412; x=1698854412;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rFi+QccnOwdpqMzOzh+5VH7hp3B+12AeLQr8Z5QZS88=;
  b=MdrO1XOtuOz7YNmjPZYTI5f+z3sggO4bBW6XAT6Ss58Va4CRcxbDmceb
   Q9n8aQJv9XAKgxBYYO7Sbh/s7e0nXjN9a3rZJOepmoSnFeXn41DaptfLP
   HsHm2klrKJIlE08QL9zpCVgWJFt5B4j8k7wFpPmNYm2H/RtgrJ6UAeoWg
   QNV3ZffTcaRemzFWFmCJ8nTR/+DsdX6wPijRMtWO681frK/UM7kXn+Wu9
   ZXg2DzEtMy5kMUyfJY0qf5VOE1ysxNTkxsIgX6ZntngkLcgDzEu4M4h6/
   zvz+GuoNE3K9XbNlQSTg5DsM8LlyiKC+mbNlBPpq2ppmt/5moJy2Hy50i
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,231,1661842800"; 
   d="scan'208";a="184854886"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2022 09:00:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 1 Nov 2022 09:00:09 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Tue, 1 Nov 2022 09:00:09 -0700
Date:   Tue, 1 Nov 2022 17:04:52 +0100
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
Message-ID: <20221101160452.mhk6ze7hzjaz4hzo@soft-dev3-1>
References: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
 <b75a7136030846f587e555763ef2750e@AcuMS.aculab.com>
 <20221031150133.2be5xr7cmuhr4gng@soft-dev3-1>
 <219ebe83a5ad4467937545ee5a0e77e4@AcuMS.aculab.com>
 <20221101075906.ets6zsti3c54idae@soft-dev3-1>
 <de73370512334c76b1500e12cfd33005@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <de73370512334c76b1500e12cfd33005@AcuMS.aculab.com>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/01/2022 09:03, David Laight wrote:
> > HW requires to have the start of frame alligned to 128 bytes.
> 
> Not a real problem.
> Even dma_alloc_coherent() guarantees alignment.
> 
> I'm not 100% sure of all the options of the Linux stack.
> But for ~1500 byte mtu I'd have thought that receiving
> directly into an skb would be best (1 page allocated for an skb).
> For large mtu (and hardware receive coalescing) receiving
> into pages is probably better - but not high order allocations.

But am I not doing this already? I allocate the page here [1] and then create
the skb here[2].

> 
> ...
> > > If the buffer is embedded in an skb you really want the skb
> > > to be under 4k (I don't think a 1500 byte mtu can fit in 2k).
> > >
> > > But you might as well tell the hardware the actual buffer length
> > > (remember to allow for the crc and any alignment header).
> >
> > I am already doing that here [2]
> > And I need to do it for each frame it can received.
> 
> That is the length of the buffer.
> Not the maximum frame length - which seems to be elsewhere.
> I suspect that having the maximum frame length less than the
> buffer size stops the driver having to handle long frames
> that span multiple buffers.
> (and very long frames that are longer than all the buffers!)
> 
> ...
> > > I'd set the buffer large enough for the mtu but let the hardware fill
> > > the entire buffer.
> >
> > I am not 100% sure I follow it. Can you expend on this a little bit?
> 
> At the moment I think the receive buffer descriptors have a length
> of 4k. But you are setting another 'maximum frame length' register
> to (eg) 1518 so that the hardware rejects long frames.

That is correct.

> But you can set the 'maximum frame length' register to (just under)
> 4k so that longer frames are received ok but without the driver
> having to worry about frames spanning multiple buffer fragments.

But this will not just put more load on CPU? In the way that I accept
long frames but then they will be discard by the CPU.
And I can do this in HW, because I know what is the maximum frame length
accepted on that interface.

> 
> The network stack might choose to discard frames with an overlong mtu.
> But that can be done after all the headers have been removed.
> 
> ...
> > But all these possible changes will need to go through net-next.
> 
> Indeed.
> 
>         David

[1] https://elixir.bootlin.com/linux/v6.1-rc3/source/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c#L17
[2] https://elixir.bootlin.com/linux/v6.1-rc3/source/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c#L417

> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

-- 
/Horatiu

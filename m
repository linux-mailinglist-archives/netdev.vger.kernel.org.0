Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2179613971
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 15:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiJaO4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 10:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiJaO4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 10:56:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26321FD2C;
        Mon, 31 Oct 2022 07:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667228213; x=1698764213;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=akuWszKcD7jklk4/ecGEIMo5t5JvMQAtz9KBLL67I1w=;
  b=pU+SbL4M91eVoXp5ENeqY9fVBEezTl2cNQO+7bnsyqTgQ3uikOgjEHO3
   qCJKhVCaMeyCYHYXHQ4idMTYz5jhqnpUjbrxvqvYlgFQTRAd896k6cuUE
   OzeMdBiQMvnHh0oEIVa900lOkbbWII3LQe3NezcCm0DtYC9xoVNfKXSLR
   e+NrVbziMcp/vu1N/Vo9R1JvybLsJCNBCBJi1y1tDW/CXGpBALMs6/LkC
   /PL7FDXy61XI6L7w0Ynq9uYayjTJQZxqHazuSQNfr5HzdV1PS0X2HE/L4
   rCrU1hy941S1xEzbLg386IubStPLJCdDLWTRlrLOoYoYtV1lE2IfE4aFh
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="186992218"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Oct 2022 07:56:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 31 Oct 2022 07:56:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 31 Oct 2022 07:56:50 -0700
Date:   Mon, 31 Oct 2022 16:01:33 +0100
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
Message-ID: <20221031150133.2be5xr7cmuhr4gng@soft-dev3-1>
References: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
 <b75a7136030846f587e555763ef2750e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <b75a7136030846f587e555763ef2750e@AcuMS.aculab.com>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 10/31/2022 10:43, David Laight wrote:
> 
> From: Horatiu Vultur
> > Sent: 30 October 2022 21:37

Hi David,

> >
> > There were multiple problems in different parts of the driver when
> > the MTU was changed.
> > The first problem was that the HW was missing to configure the correct
> > value, it was missing ETH_HLEN and ETH_FCS_LEN. The second problem was
> > when vlan filtering was enabled/disabled, the MRU was not adjusted
> > corretly. While the last issue was that the FDMA was calculated wrongly
> > the correct maximum MTU.
> 
> IIRC all these lengths are 1514, 1518 and maybe 1522?

And also 1526, if the frame has 2 vlan tags.

> How long are the actual receive buffers?
> I'd guess they have to be rounded up to a whole number of cache lines
> (especially on non-coherent systems) so are probably 1536 bytes.

The receive buffers can be different sizes, it can be up to 65k.
They are currently allign to page size.

> 
> If driver does support 8k+ jumbo frames just set the hardware
> frame length to match the receive buffer size.

In that case I should always allocate maximum frame size(65k) for all
regardless of the MTU?

> 
> There is no real need to exactly police the receive MTU.
> There are definitely situations where the transmit MTU has
> to be limited (eg to avoid ptmu blackholes) but where some
> systems still send 'full sized' packets.
> 
> There is also the possibility of receiving PPPoE encapsulated
> full sized ethernet packets.
> I can remember how big that header is - something like 8 bytes.
> There is no real reason to discard them if they'd fit in the buffer.
> 
>         David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

-- 
/Horatiu

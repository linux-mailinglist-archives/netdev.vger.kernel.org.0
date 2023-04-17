Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AB76E406D
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjDQHN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDQHNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:13:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CD426BB;
        Mon, 17 Apr 2023 00:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681715622; x=1713251622;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EBKF5Lz4IK0vPItXrSz1CGg/32PZUcfvWlZ+dWaOHAo=;
  b=0lsAuUQR2u8FjWofJtRRNlc3bV9HLCY1hfHT4+3aKPBKr6BQjEvjtWUJ
   6eAsGFcZPSc/y+3EuBDK/OuH9LCnsj6+QOkzYslYxSeV3aKcMYD6wh4cP
   lU6cXFSR8VNQ2qojKLmTcZCXj/vqOocXMHVR+leUuT8sdj2gj9RhWHo3X
   AahNQMFr3qQijZuh/FydnR7ZfRKN14xXbq5k+pz1cQZBxdcnnAeijMfwE
   RTUXCJCokxpU4bL3Kj6KDxkOczAMuFatIIqmxWQfi2lU99Kmj5uiieRhE
   3YIB0AKaO3rM8LuXsV473oVk7uCKeWx1KMBXndL47fMGF6f6G5uAofi6b
   w==;
X-IronPort-AV: E=Sophos;i="5.99,203,1677567600"; 
   d="scan'208";a="206794206"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Apr 2023 00:13:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 17 Apr 2023 00:13:40 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 17 Apr 2023 00:13:39 -0700
Date:   Mon, 17 Apr 2023 09:13:38 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: lan966x: Fix lan966x_ifh_get
Message-ID: <20230417071338.24phfjlrpjzexjag@soft-dev3-1>
References: <20230414082047.1320947-1-horatiu.vultur@microchip.com>
 <06722642-f934-db3a-f88e-94263592b216@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <06722642-f934-db3a-f88e-94263592b216@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/14/2023 19:00, Alexander Lobakin wrote:
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Fri, 14 Apr 2023 10:20:47 +0200

Hi Olek,

> 
> >>From time to time, it was observed that the nanosecond part of the
> > received timestamp, which is extracted from the IFH, it was actually
> > bigger than 1 second. So then when actually calculating the full
> > received timestamp, based on the nanosecond part from IFH and the second
> > part which is read from HW, it was actually wrong.
> >
> > The issue seems to be inside the function lan966x_ifh_get, which
> > extracts information from an IFH(which is an byte array) and returns the
> > value in a u64. When extracting the timestamp value from the IFH, which
> > starts at bit 192 and have the size of 32 bits, then if the most
> > significant bit was set in the timestamp, then this bit was extended
> > then the return value became 0xffffffff... . To fix this, make sure to
> > clear all the other bits before returning the value.
> 
> Ooooh, I remember I was having the same issue with sign extension :s
> Pls see below.
> 
> >
> > Fixes: fd7627833ddf ("net: lan966x: Stop using packing library")
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > index 80e2ea7e6ce8a..508e494dcc342 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> > @@ -608,6 +608,7 @@ static u64 lan966x_ifh_get(u8 *ifh, size_t pos, size_t length)
> >                       val |= (1 << i);
> 
> Alternatively, you can change that to (pick one that you like the most):
> 
>                         val |= 1ULL << i;
>                         // or
>                         val |= BIT_ULL(i);
> 
> The thing is that constants without any postfix (U, UL etc.) are treated
> as signed longs, that's why `1 << 31` becomes 0xffffffff80000000. 1U /
> 1UL / 1ULL don't.
> 
> Adding unsigned postfix may also make it better for 32-bit systems, as
> `1 << i` there is 32-bit value, so `1 << 48` may go wrong and/or even
> trigger compilers.

Thanks for suggestion and the explanation, it was really helpful.
I will update this in the next version.

> 
> >       }
> >
> > +     val &= GENMASK(length, 0);
> >       return val;
> >  }
> >
> 
> (now blah not directly related to the fix)

I think this change regarding the improvement of the lan966x_ifh_get
should not be in the next version of this patch, as there are 2
different things. But I would still like to know how to do this!
> 
> I'm wondering a bit if lan966x_ifh_get() can be improved in general to
> work with words rather than bits. You read one byte per each bit each
> iteration there.

Actually, I am not reading 1 byte per each bit iteration. I am reading 1
byte first time when entering in the loop or each time when the bit
iteration (j variable) is modulo 8.

> For example, byte arrays could be casted to __be{32,64} and you'd get
> native byteorder for 32/64 bits via one __be*_to_cpu*() call.

> 
> Thanks,
> Olek

-- 
/Horatiu

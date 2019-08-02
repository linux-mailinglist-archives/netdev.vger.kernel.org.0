Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9177FE80
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 18:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390741AbfHBQVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 12:21:13 -0400
Received: from lechat.rtp-net.org ([51.15.165.164]:51290 "EHLO
        lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389867AbfHBQVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 12:21:13 -0400
Received: by lechat.rtp-net.org (Postfix, from userid 115)
        id 9915418003C; Fri,  2 Aug 2019 18:21:10 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on lechat.rtp-net.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.2
Received: from lechat.rtp-net.org (localhost [IPv6:::1])
        by lechat.rtp-net.org (Postfix) with ESMTPS id 8AB1D18003C;
        Fri,  2 Aug 2019 18:21:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=rtp-net.org; s=email;
        t=1564762867; bh=XT7Bd0Xg9QYgIJ38C1EacN60d0slLVfKQITiU+Eo31Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZlkURzJnWMW732KYPFirfOlz7N3LRR4o/QYo0snA9/6NrZ6EXYVDUCPlTYQeDvIu1
         Qbq1rOVbXmakK7B0OYg+FQbY574il6pT4bfv9hZZwX6Ob+ik52eYnPcXLgiWTTYx1S
         ddasSvLHpkEx22gK2imjBBs8CcEqhBqhQCfTUgO6H0/NQtDvYSWbJOXApSRPoyE45z
         kv1SkJiOgEjegj9puBVgSaijLunl+iXmBoXG98Px2MlaLrxrObApTzYGc7mN+xO8R7
         NmxfCf4Bg4jMPjK+Qq3fHNdh0x31XOezRCRCOVmk1Y63+m1E3LuRfATOL21qKGgRU5
         ZZunPifOIfCBqiIPxYkYXgQSUD92NnMfSP83XCszqEgzhYq3Qj2aeh+Hd+6+Lp2RVv
         WiQ6Aazy21pIxXXOk4wC3Jl9Ufk70BXHkwMoxNPog+eeFjFNTMBxfxSB+Tfulhg/CS
         Dp8UTzZdOVMdxs7957rgcwL0/KsnGc/R3uVhJQVX9lwrFI24qXWOglC0Z+W7xsRyVl
         2rr1Irq0xdnhcL/Z3v1j/N5GWaQaI3v0LTXiTGAcCGOofwwoiIEuJZTrIshFVXrW0b
         UPLcFrXu12pwBq7BBUukciK/03oeDWbpu9UnWpbsE7qv1QRHJEgjBLB8Qrhs9a8php
         /3CqOSud50vwMwI87ckVCqFA=
From:   Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: [patch 1/1] drivers/net/ethernet/marvell/mvmdio.c: Fix non OF case
Organization: RtpNet
References: <20190802083310.772136040@rtp-net.org>
        <20190802144353.GG2099@lunn.ch>
Date:   Fri, 02 Aug 2019 18:21:07 +0200
In-Reply-To: <20190802144353.GG2099@lunn.ch> (Andrew Lunn's message of "Fri, 2
        Aug 2019 16:43:53 +0200")
Message-ID: <874l2zzggc.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> writes:

Hi,

> On Fri, Aug 02, 2019 at 10:32:40AM +0200, Arnaud Patard wrote:
>> Orion5.x systems are still using machine files and not device-tree.
>> Commit 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be
>> specified for orion-mdio") has replaced devm_clk_get() with of_clk_get(),
>> leading to a oops at boot and not working network, as reported in 
>> https://lists.debian.org/debian-arm/2019/07/msg00088.html and possibly in
>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908712.
>> 
>> Link: https://lists.debian.org/debian-arm/2019/07/msg00088.html
>> Fixes: 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be specified for orion-mdio")
>> Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
>> Index: linux-next/drivers/net/ethernet/marvell/mvmdio.c
>> ===================================================================
>> --- linux-next.orig/drivers/net/ethernet/marvell/mvmdio.c
>> +++ linux-next/drivers/net/ethernet/marvell/mvmdio.c
>> @@ -319,20 +319,33 @@ static int orion_mdio_probe(struct platf
>>  
>>  	init_waitqueue_head(&dev->smi_busy_wait);
>>  
>> -	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
>> -		dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
>> -		if (PTR_ERR(dev->clk[i]) == -EPROBE_DEFER) {
>> +	if (pdev->dev.of_node) {
>> +		for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
>> +			dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
>> +			if (PTR_ERR(dev->clk[i]) == -EPROBE_DEFER) {
>> +				ret = -EPROBE_DEFER;
>> +				goto out_clk;
>> +			}
>> +			if (IS_ERR(dev->clk[i]))
>> +				break;
>> +			clk_prepare_enable(dev->clk[i]);
>> +		}
>> +
>> +		if (!IS_ERR(of_clk_get(pdev->dev.of_node,
>> +				       ARRAY_SIZE(dev->clk))))
>> +			dev_warn(&pdev->dev,
>> +				 "unsupported number of clocks, limiting to the first "
>> +				 __stringify(ARRAY_SIZE(dev->clk)) "\n");
>> +	} else {
>> +		dev->clk[0] = clk_get(&pdev->dev, NULL);
>> +		if (PTR_ERR(dev->clk[0]) == -EPROBE_DEFER) {
>>  			ret = -EPROBE_DEFER;
>>  			goto out_clk;
>>  		}
>
> Hi Arnaud
>
> It is a long time since i looked at Orion5x. Is this else clause even
> needed? If my memory is right, i don't think it needs to enable tclk?
> It was kirkwood which first added gateable clocks. And all kirkwood
> boards are not DT.

I was not sure if the else clause was needed or not so I only restored
similar behaviour to what was there before the commit 96cb4342382290c9.

By looking at the commit logs, the commit adding the clock support
3d604da1e9547c09 (net: mvmdio: get and enable optional clock) doesn't
mention the SoC names. So, I've no idea if it's needed or not.

Arnaud

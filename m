Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739412963D1
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 19:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368035AbgJVReu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 13:34:50 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:22748 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2900620AbgJVReu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 13:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1603388085;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=sCoMIGL7KWIQgDxcIKVQFpQUBV1hAWoEYlxe7X4a+Jw=;
        b=ONJGUVhZYRdi0vioGxpTi21rTAbmDBdShN4JX1iDJkks8QtYl6wOfsfOxWfIzYglo5
        GRz0ZQVtJ0HnfYp54RF7mnuhUUjVa/mRyS9RzMD3Um0t2TQZrtPOkZd7A1AD81dpQXII
        vy5WWcNzTAYWpb2wXXboDkkaDLdTZn+kw7vaGxzUwyAS3yRsTY9y+7gP8nS8d5Mvps25
        jsF2U+MQd36p73HgbdS5DrymdmfcKDnM3AHxLKgdg3iMVPQK77G33Koj5JQAiY/J+BEK
        KAXq/HJ/Y/57pVlBegWzoph744sPCxBKxxlHvl1yfw+7nxHWjqmerQrr1xZgMdoDHEd2
        I/NQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMGXsh5mUj+"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9MHYKw3Q
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 22 Oct 2020 19:34:20 +0200 (CEST)
Subject: Re: [PATCH] can: vxcan: Fix memleak in vxcan_newlink
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201021052150.25914-1-dinghao.liu@zju.edu.cn>
 <986c27bf-29b4-a4f7-1dcd-4cb5a446334b@hartkopp.net>
 <20201022091435.2449cf41@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <a7c5884d-2c7d-1868-8b93-414b43b3f7c1@hartkopp.net>
Date:   Thu, 22 Oct 2020 19:34:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201022091435.2449cf41@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.10.20 18:14, Jakub Kicinski wrote:
> On Wed, 21 Oct 2020 13:20:16 +0200 Oliver Hartkopp wrote:
>> On 21.10.20 07:21, Dinghao Liu wrote:
>>> When rtnl_configure_link() fails, peer needs to be
>>> freed just like when register_netdevice() fails.
>>>
>>> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
>>
>> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
>>
>> Btw. as the vxcan.c driver bases on veth.c the same issue can be found
>> there!
>>
>> At this point:
>> https://elixir.bootlin.com/linux/latest/source/drivers/net/veth.c#L1398
>>
>> err_register_dev:
>>           /* nothing to do */
>> err_configure_peer:
>>           unregister_netdevice(peer);
>>           return err; <<<<<<<<<<<<<<<<<<<<<<<
>>
>> err_register_peer:
>>           free_netdev(peer);
>>           return err;
>> }
>>
>> IMO the return must be removed to fall through the next label and free
>> the netdevice too.
>>
>> Would you like so send a patch for veth.c too?
> 
> Ah, this is where Liu Dinghao got the veth suggestion :)
> 
> Does vxcan actually need this patch?
> 
> static void vxcan_setup(struct net_device *dev)
> {
> 	[...]
>          dev->needs_free_netdev  = true;
> 

Oh!

In fact the vxcan.c is really similar to veth.c in these code snippets - 
so I wondered why this never had been seen in veth.c.

Then vxcan.c doesn't need that patch too :-/

Thanks for the heads up!

@Marc: Can you please make sure that it doesn't get into upstream? Tnx!

Best,
Oliver


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 320B118C174
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 21:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgCSUfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 16:35:01 -0400
Received: from mx.0dd.nl ([5.2.79.48]:45058 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCSUfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 16:35:01 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 45AE45FAE6;
        Thu, 19 Mar 2020 21:35:00 +0100 (CET)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="iemcHV0x";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id EEFCB25026C;
        Thu, 19 Mar 2020 21:34:59 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com EEFCB25026C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1584650100;
        bh=cSLvUWll0EXOQRnoPBZasPlEwOgeA+HGgMKCZAuoZdY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iemcHV0xIJAdVye15L7fb3pyDiheB46s6gQcbIXdScFMwMX3wn0Le14D0f20uVGaI
         odTIOghRJVOJdFs0nPWJD85tPpjGqXarSE5BwMOBelkftE0/dglwdenfvkOdJVzBiV
         Mo4xabOCdRFY3MP6YCdHEycMHS+pZsSlDCgP3w1xX6d17meJePFeENGHj9zKm3KBCU
         0AHwkPp+37u2pTFDg7/EpehbLuf7gld/h7R+4PZvV8Pf1eTD9oeuRPgm7jm3c9Ay4H
         8Dl2fGy1uYWV0raIn2rA8c1iLNnOOfgKsE7NvafuPKARb7k8S2Y89y70z0VGv9D+It
         +VhzeUWAt2NZw==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Thu, 19 Mar 2020 20:34:59 +0000
Date:   Thu, 19 Mar 2020 20:34:59 +0000
Message-ID: <20200319203459.Horde.FHMW3lKtaN-qI8lZ8qts7N_@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-mediatek@lists.infradead.org,
        Andrew Smith <andrew.smith@digi.com>
Subject: Re: [[PATCH,net]] net: dsa: mt7530: Change the LINK bit to reflect
 the link status
References: <20200319134756.46428-1-opensource@vdorst.com>
 <20200319124123.GB3412372@t480s.localdomain>
In-Reply-To: <20200319124123.GB3412372@t480s.localdomain>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Vivien Didelot <vivien.didelot@gmail.com>:

> Hi René,
>
> On Thu, 19 Mar 2020 14:47:56 +0100, René van Dorst  
> <opensource@vdorst.com> wrote:
>> Andrew reported:
>>
>> After a number of network port link up/down changes, sometimes the switch
>> port gets stuck in a state where it thinks it is still transmitting packets
>> but the cpu port is not actually transmitting anymore. In this state you
>> will see a message on the console
>> "mtk_soc_eth 1e100000.ethernet eth0: transmit timed out" and the Tx counter
>> in ifconfig will be incrementing on virtual port, but not incrementing on
>> cpu port.
>>
>> The issue is that MAC TX/RX status has no impact on the link status or
>> queue manager of the switch. So the queue manager just queues up packets
>> of a disabled port and sends out pause frames when the queue is full.
>>
>> Change the LINK bit to reflect the link status.
>>
>> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek  
>> MT7530 switch")
>> Reported-by: Andrew Smith <andrew.smith@digi.com>
>> Signed-off-by: René van Dorst <opensource@vdorst.com>
>

Hi Vivien,

> Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
>
> For the subject prefix, it is preferable to use "[PATCH net]" over
> "[[PATCH,net]]". You can easily add this bracketed prefix with git
> format-patch's option --subject-prefix="PATCH net".

Thanks for reviewing.

Funny is that I used subject-prefix option but I with the brackets.
Like --subject-prefix="[PATCH,net]" but not realizing that git also
add brackets. I didn't noticed until I got an email back from the
mailinglist that it had double brackets.
Next time I use "[PATCH net]".

Great,

René


>
>
> Thank you,
>
> 	Vivien




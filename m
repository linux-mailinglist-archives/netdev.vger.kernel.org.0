Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A87E48DE
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 12:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392836AbfJYKuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 06:50:17 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:39044 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfJYKuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 06:50:16 -0400
Received: from [10.1.8.111] (unknown [10.1.8.111])
        by uho.ysoft.cz (Postfix) with ESMTP id EFF1DA31CA;
        Fri, 25 Oct 2019 12:50:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1572000614;
        bh=LSdrfEjRO3iV/0CWKtnYmKEWg/ZxVW9HBizh6GaIiDw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IT1Gb0NTcPtC1GPd9ENwia+ZCx+32qCQWP/DjtHPvsJJP1ttsck1+4piBlmZl7KrX
         G1iwz+cRNPC7cXUL7RVvYxvGi+1GAwWyQrICqTCdhFO7nCMrFBpmgyfklG5QPR1/Xb
         orn7LtdrTFoyPmPhxYUj4+7n1kYqizeAuwRHCgTc=
Subject: Re: [PATCH net-next] net: dsa: qca8k: Initialize the switch with
 correct number of ports
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1571924818-27725-1-git-send-email-michal.vokac@ysoft.com>
 <20191024141211.GC30147@lunn.ch>
 <a6e8b1cb-4c32-34ba-2a10-d736a953c108@gmail.com>
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Message-ID: <7aeb3ce2-b0b9-ec15-1062-955a0eca4d98@ysoft.com>
Date:   Fri, 25 Oct 2019 12:50:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a6e8b1cb-4c32-34ba-2a10-d736a953c108@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24. 10. 19 18:33, Florian Fainelli wrote:
> On 10/24/19 7:12 AM, Andrew Lunn wrote:
>> On Thu, Oct 24, 2019 at 03:46:58PM +0200, Michal Vokáč wrote:
>>> Since commit 0394a63acfe2 ("net: dsa: enable and disable all ports")
>>> the dsa core disables all unused ports of a switch. In this case
>>> disabling ports with numbers higher than QCA8K_NUM_PORTS causes that
>>> some switch registers are overwritten with incorrect content.
>>
>> Humm.
>>
>> The same problem might exist in other drivers:
>>
>> linux/drivers/net/dsa$ grep -r "ds->num_ports = DSA_MAX_PORTS"
>> qca8k.c:	priv->ds->num_ports = DSA_MAX_PORTS;
>> b53/b53_common.c:	ds->num_ports = DSA_MAX_PORTS;
> 
> Not for b53 because this later gets clamped with dev->num_ports in
> b53_setup().

I quickly checked the code and I think there is still an issue
in the b53_enable_port and b53_disable_port functions which are
called from the dsa_port_setup().

>> mt7530.c:	priv->ds->num_ports = DSA_MAX_PORTS;
>> microchip/ksz_common.c:	ds->num_ports = DSA_MAX_PORTS;

At first glance it looks like mt7530 and microchip has the same problem.

>> dsa_loop.c:	ds->num_ports = DSA_MAX_PORTS;
>>
>> dsa_loop.c looks O.K, it does support DSA_MAX_PORTS ports.
>>
>> But the others?
>>
>>      Andrew

I can respin and fix those drivers as well. Or a separate patch
for each one?

Michal

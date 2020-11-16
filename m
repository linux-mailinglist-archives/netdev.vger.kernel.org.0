Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31872B4FF8
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbgKPSkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:40:18 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:53652 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgKPSkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 13:40:17 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AGIe4VZ065486;
        Mon, 16 Nov 2020 12:40:04 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605552004;
        bh=vZvZmpRXLdOHlrWsWFSQrRNMSkunry0WyLmDdpA6E9Q=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=mAIum+d/03aEKtL3z96ILs1FYIi438i/qXPanl4WxXaUN8l0B3Mr6DE2ybAToxjUu
         GavW2u9m0ewd8iL+5XSVEzB381bOZgzZ/TGbYdPmgGHLpzmEiG2oa4bVWOSYOHTB3e
         KrBfgNzSL3Ps8nhgMASvyuglV6NhhAG0wPHwcBtg=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AGIe4pi049994
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Nov 2020 12:40:04 -0600
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 16
 Nov 2020 12:40:03 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 16 Nov 2020 12:40:03 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AGIdxRj054660;
        Mon, 16 Nov 2020 12:40:00 -0600
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: am65-cpsw: enable
 broadcast/multicast rate limit support
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <20201114035654.32658-1-grygorii.strashko@ti.com>
 <20201114035654.32658-4-grygorii.strashko@ti.com>
 <20201114191723.rvmhyrqinkhdjtpr@skbuf>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <e9f2b153-d467-15fd-bd4a-601211601fca@ti.com>
Date:   Mon, 16 Nov 2020 20:39:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201114191723.rvmhyrqinkhdjtpr@skbuf>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/11/2020 21:17, Vladimir Oltean wrote:
> On Sat, Nov 14, 2020 at 05:56:54AM +0200, Grygorii Strashko wrote:
>> This patch enables support for ingress broadcast(BC)/multicast(MC) rate limiting
>> in TI AM65x CPSW driver (the corresponding ALE support was added in previous
>> patch) by implementing HW offload for simple tc-flower policer with matches
>> on dst_mac:
>>   - ff:ff:ff:ff:ff:ff has to be used for BC rate limiting
>>   - 01:00:00:00:00:00 fixed value has to be used for MC rate limiting
>>
>> Hence tc policer defines rate limit in terms of bits per second, but the
>> ALE supports limiting in terms of packets per second - the rate limit
>> bits/sec is converted to number of packets per second assuming minimum
>> Ethernet packet size ETH_ZLEN=60 bytes.
>>
>> Examples:
>> - BC rate limit to 1000pps:
>>    tc qdisc add dev eth0 clsact
>>    tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
>>    action police rate 480kbit burst 64k
>>
>>    rate 480kbit - 1000pps * 60 bytes * 8, burst - not used.
>>
>> - MC rate limit to 20000pps:
>>    tc qdisc add dev eth0 clsact
>>    tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:00:00 \
>>    action police rate 9600kbit burst 64k
>>
>>    rate 9600kbit - 20000pps * 60 bytes * 8, burst - not used.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
> 
> I understand this is unpleasant feedback, but don't you want to extend
> tc-police to have an option to rate-limit based on packet count and not
> based on byte count?

Huh.
I'd be appreciated if you could provide more detailed opinion of how it can look like?
Sry, it's my first experience with tc.

> The assumption you make in the driver that the
> packets are all going to be minimum-sized is not a great one.
> I can
> imagine that the user's policer budget is vastly exceeded if they enable
> jumbo frames and they put a policer at 9.6 Mbps, and this is not at all
> according to their expectation. 20Kpps assuming 60 bytes per packet
> might be 9.6 Mbps, and the user will assume this bandwidth profile is
> not exceeded, that's the whole point. But 20Kpps assuming 9KB per packet
> is 1.44Gbps. Weird.

Sry, not sure I completely understood above. This is specific HW feature, which can
imit packet rate only. And it is expected to be applied by admin who know what he is doing.
The main purpose is to preserve CPU resource, which first of all affected by packet rate.
So, I see it as not "assumption", but requirement/agreement which will be reflected
in docs and works for a specific use case which is determined by presence of:
  - skip_sw flag
  - specific dst_mac/dst_mac_mask pair
in which case rate determines pps and not K/Mbps.


Also some ref on previous discussion [1] [2]
[1] https://www.spinics.net/lists/netdev/msg494630.html
[2] https://lore.kernel.org/patchwork/patch/481285/

-- 
Best regards,
grygorii

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C94442E47
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 13:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhKBMj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 08:39:58 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:58442 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhKBMj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 08:39:57 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A2Cb9Zt104533;
        Tue, 2 Nov 2021 07:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635856629;
        bh=KUzMs8AeEsPu55XE63e87SghtGWjDbtB3TxcE2WTWAQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=i5WpF3GFSga2dnWcdNZiyKtqxbMcWX4HZ6VvRiqwA0EvTfOsKndZSZD2EjcJus4nh
         YGjQvKStkE1Mv6edRqbW/6vFvszDP22CqczJv/OB6A5BxaAanb+SFsiI9GF4jUW+Fe
         ZSCSfwSXUf3vYQe7QqKzU/D3eJiLbdcxAN70F//I=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A2Cb9vh073243
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 2 Nov 2021 07:37:09 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 2
 Nov 2021 07:37:09 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 2 Nov 2021 07:37:08 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A2Cb6GP115699;
        Tue, 2 Nov 2021 07:37:06 -0500
Subject: Re: [PATCH net-next v2 0/3] net: ethernet: ti: cpsw: enable bc/mc
 storm prevention support
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Andrew Lunn <andrew@lunn.ch>
References: <20211101170122.19160-1-grygorii.strashko@ti.com>
 <20211101235327.63ggtuhvplsgpmya@skbuf>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <3fb0e416-ef36-e76f-2ba5-624928f71929@ti.com>
Date:   Tue, 2 Nov 2021 14:36:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211101235327.63ggtuhvplsgpmya@skbuf>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/11/2021 01:53, Vladimir Oltean wrote:
> On Mon, Nov 01, 2021 at 07:01:19PM +0200, Grygorii Strashko wrote:
>> Hi
>>
>> This series first adds supports for the ALE feature to rate limit number ingress
>> broadcast(BC)/multicast(MC) packets per/sec which main purpose is BC/MC storm
>> prevention.
>>
>> And then enables corresponding support for ingress broadcast(BC)/multicast(MC)
>> packets rate limiting for TI CPSW switchdev and AM65x/J221E CPSW_NUSS drivers by
>> implementing HW offload for simple tc-flower with policer action with matches
>> on dst_mac:
>>   - ff:ff:ff:ff:ff:ff has to be used for BC packets rate limiting
>>   - 01:00:00:00:00:00 fixed value has to be used for MC packets rate limiting
>>
>> Examples:
>> - BC rate limit to 1000pps:
>>    tc qdisc add dev eth0 clsact
>>    tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
>>    action police pkts_rate 1000 pkts_burst 1
>>
>> - MC rate limit to 20000pps:
>>    tc qdisc add dev eth0 clsact
>>    tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:00:00 \
>>    action police pkts_rate 10000 pkts_burst 1
>>
>>    pkts_burst - not used.
>>
>> The solution inspired patch from Vladimir Oltean [1].
>>
>> Changes in v2:
>>   - switch to packet-per-second policing introduced by
>>     commit 2ffe0395288a ("net/sched: act_police: add support for packet-per-second policing") [2]
>>
>> v1: https://patchwork.kernel.org/project/netdevbpf/cover/20201114035654.32658-1-grygorii.strashko@ti.com/
>>
>> [1] https://lore.kernel.org/patchwork/patch/1217254/
>> [2] https://patchwork.kernel.org/project/netdevbpf/cover/20210312140831.23346-1-simon.horman@netronome.com/
>>
>> Grygorii Strashko (3):
>>    drivers: net: cpsw: ale: add broadcast/multicast rate limit support
>>    net: ethernet: ti: am65-cpsw: enable bc/mc storm prevention support
>>    net: ethernet: ti: cpsw_new: enable bc/mc storm prevention support
>>
>>   drivers/net/ethernet/ti/am65-cpsw-qos.c | 145 ++++++++++++++++++++
>>   drivers/net/ethernet/ti/am65-cpsw-qos.h |   8 ++
>>   drivers/net/ethernet/ti/cpsw_ale.c      |  66 +++++++++
>>   drivers/net/ethernet/ti/cpsw_ale.h      |   2 +
>>   drivers/net/ethernet/ti/cpsw_new.c      |   4 +-
>>   drivers/net/ethernet/ti/cpsw_priv.c     | 170 ++++++++++++++++++++++++
>>   drivers/net/ethernet/ti/cpsw_priv.h     |   8 ++
>>   7 files changed, 402 insertions(+), 1 deletion(-)
>>
>> -- 
>> 2.17.1
>>
> 
> I don't think I've asked this for v1, but when you say multicast storm
> control, does the hardware police just unknown multicast frames, or all
> multicast frames?
> 

  packets per/sec rate limiting is affects all MC or BC packets once enabled.

-- 
Best regards,
grygorii

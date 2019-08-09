Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61759873B8
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 10:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405826AbfHIIEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 04:04:30 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:54634 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405395AbfHIIEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 04:04:30 -0400
Received: from tux.wizards.de (p5DE2B30B.dip0.t-ipconnect.de [93.226.179.11])
        by mail02.iobjects.de (Postfix) with ESMTPSA id A1DD4416A0C8;
        Fri,  9 Aug 2019 10:04:28 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 5933EF0160E;
        Fri,  9 Aug 2019 10:04:28 +0200 (CEST)
Subject: Re: [PATCH net-next] r8169: make use of xmit_more
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Eric Dumazet <edumazet@google.com>
References: <2950b2f7-7460-cce0-d964-ad654d897295@gmail.com>
 <acd65426-0c7e-8c5f-a002-a36286f09122@applied-asynchrony.com>
 <cfb9a1c7-57c8-db04-1081-ac1cb92bb447@applied-asynchrony.com>
 <a19bb3de-a866-d342-7cca-020fef219d03@gmail.com>
 <868a1f4c-5fba-c64b-ea31-30a3770e6a2f@applied-asynchrony.com>
 <f08a3207-0930-4b71-16f1-81e352f87a9c@gmail.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <eecaaf82-e6cd-2b75-5756-006a70258a9f@applied-asynchrony.com>
Date:   Fri, 9 Aug 2019 10:04:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f08a3207-0930-4b71-16f1-81e352f87a9c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/19 10:08 PM, Heiner Kallweit wrote:
(..snip..)
>>>
>>> I was about to ask exactly that, whether you have TSO enabled. I don't know what
>>> can trigger the HW issue, it was just confirmed by Realtek that this chip version
>>> has a problem with TSO. So the logical conclusion is: test w/o TSO, ideally the
>>> linux-next version.
>>
>> So disabling TSO alone didn't work - it leads to reduced throughout (~70 MB/s in iperf).
>> Instead I decided to backport 93681cd7d94f ("r8169: enable HW csum and TSO"), which
>> wasn't easy due to cleanups/renamings of dependencies, but I managed to backport
>> it and .. got the same problem of reduced throughout. wat?!
>>
>> After lots of trial & error I started disabling all offloads and finally found
>> that sg (Scatter-Gather) enabled alone - without TSO - will lead to the throughput
>> drop. So the culprit seems 93681cd7d94f, which disabled TSO on my NIC, but left
>> sg on by default. This weas repeatable - switch on sg, throughput drop; turn it
>> off - smooth sailing, now with reduced buffers.
>>
>> I modified the relevant bits to disable tso & sg like this:
>>
>>      /* RTL8168e-vl has a HW issue with TSO */
>>      if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
>> +        dev->vlan_features &= ~(NETIF_F_ALL_TSO|NETIF_F_SG);
>> +        dev->hw_features &= ~(NETIF_F_ALL_TSO|NETIF_F_SG);
>> +        dev->features &= ~(NETIF_F_ALL_TSO|NETIF_F_SG);
>>      }
>>
>> This seems to work since it restores performance without sg/tso by default
>> and without any additional offloads, yet with xmit_more in the mix.
>> We'll see whether that is stable over the next few days, but I strongly
>> suspect it will be good and that the hiccups were due to xmit_more/TSO
>> interaction.

So that didn't take long - got another timeout this morning during some
random light usage, despite sg/tso being disabled this time.
Again the only common element is the xmit_more patch. :(
Not sure whether you want to revert this right away or wait for 5.4-rc1
feedback. Maybe this too is chipset-specific?

> Thanks a lot for the analysis and testing. Then I'll submit the disabling
> of SG on RTL8168evl (on your behalf), independent of whether it fixes
> the timeout issue.

Got it, thanks!

Holger

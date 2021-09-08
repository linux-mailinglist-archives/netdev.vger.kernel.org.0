Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4343840373B
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 11:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348495AbhIHJrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 05:47:39 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:45850 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245528AbhIHJri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 05:47:38 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 92A3520A742D
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH] net: renesas: sh_eth: Fix freeing wrong tx descriptor
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
References: <20210907112940.967985-1-yoshihiro.shimoda.uh@renesas.com>
 <a610ac4b-eeb9-50c2-4b88-0d77d1c83d47@omp.ru>
 <TY2PR01MB36924D8258BD1C8E3287136DD8D49@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Organization: Open Mobile Platform
Message-ID: <9f3a0195-8218-e73c-eb63-bbd7b6ff9777@omp.ru>
Date:   Wed, 8 Sep 2021 12:46:17 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <TY2PR01MB36924D8258BD1C8E3287136DD8D49@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.09.2021 8:45, Yoshihiro Shimoda wrote:

>>> The cur_tx counter must be incremented after TACT bit of
>>> txdesc->status was set. However, a CPU is possible to reorder
>>> instructions and/or memory accesses between cur_tx and
>>> txdesc->status. And then, if TX interrupt happened at such a
>>> timing, the sh_eth_tx_free() may free the descriptor wrongly.
>>> So, add wmb() before cur_tx++.
>>
>>     Not dma_wmb()? :-)
> 
> On armv8, dma_wmb() is DMB OSHST, and wmb() is DSB ST.
> IIUC, DMB OSHST is not affected the ordering of instructions.
> So, we have to use wmb().

    I should really read up the ARM manuals on the barrier instructions... :-)

>>> Otherwise NETDEV WATCHDOG timeout is possible to happen.
>>>
>>> Fixes: 86a74ff21a7a ("net: sh_eth: add support for Renesas SuperH Ethernet")
>>> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>>
>> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> Thank you for your review!

    Out of curiosity: have you really experienced the bug or found it by
review?

> Best regards,
> Yoshihiro Shimoda

MBR, Sergey

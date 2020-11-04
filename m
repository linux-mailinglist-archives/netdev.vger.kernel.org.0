Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F802A67B9
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbgKDPcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:32:00 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:40442 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730579AbgKDPcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 10:32:00 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4CR9cD68Y5z1ry9k;
        Wed,  4 Nov 2020 16:31:40 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4CR9cD0WpTz1r56Q;
        Wed,  4 Nov 2020 16:31:40 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id DvicTuW42m2Z; Wed,  4 Nov 2020 16:31:38 +0100 (CET)
X-Auth-Info: m2rxJ9ltA/W9AJTEKqdpEQ6k6m9XqFNkOgkGsG6cK8o=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed,  4 Nov 2020 16:31:38 +0100 (CET)
Subject: Re: [PATCH 1/2] rsi: Move card interrupt handling to RX thread
To:     Martin Kepplinger <martink@posteo.de>,
        linux-wireless@vger.kernel.org
Cc:     Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
References: <20201103180941.443528-1-marex@denx.de>
 <e7e5ad92-de6b-1bd5-18e0-728b8ea454c4@posteo.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <abe131ba-e768-4919-4cbb-44d6e005a98f@denx.de>
Date:   Wed, 4 Nov 2020 16:31:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <e7e5ad92-de6b-1bd5-18e0-728b8ea454c4@posteo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/20 4:21 PM, Martin Kepplinger wrote:
> On 03.11.20 19:09, Marek Vasut wrote:
>> The interrupt handling of the RS911x is particularly heavy. For each RX
>> packet, the card does three SDIO transactions, one to read interrupt
>> status register, one to RX buffer length, one to read the RX packet(s).
>> This translates to ~330 uS per one cycle of interrupt handler. In case
>> there is more incoming traffic, this will be more.
>>
>> The drivers/mmc/core/sdio_irq.c has the following comment, quote "Just
>> like traditional hard IRQ handlers, we expect SDIO IRQ handlers to be
>> quick and to the point, so that the holding of the host lock does not
>> cover too much work that doesn't require that lock to be held."
>>
>> The RS911x interrupt handler does not fit that. This patch therefore
>> changes it such that the entire IRQ handler is moved to the RX thread
>> instead, and the interrupt handler only wakes the RX thread.
>>
>> This is OK, because the interrupt handler only does things which can
>> also be done in the RX thread, that is, it checks for firmware loading
>> error(s), it checks buffer status, it checks whether a packet arrived
>> and if so, reads out the packet and passes it to network stack.
>>
>> Moreover, this change permits removal of a code which allocated an
>> skbuff only to get 4-byte-aligned buffer, read up to 8kiB of data
>> into the skbuff, queue this skbuff into local private queue, then in
>> RX thread, this buffer is dequeued, the data in the skbuff as passed
>> to the RSI driver core, and the skbuff is deallocated. All this is
>> replaced by directly calling the RSI driver core with local buffer.
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: Angus Ainslie <angus@akkea.ca>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Kalle Valo <kvalo@codeaurora.org>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Cc: Martin Kepplinger <martink@posteo.de>
>> Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
>> Cc: Siva Rebbagondla <siva8118@gmail.com>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> ---
>>   drivers/net/wireless/rsi/rsi_91x_sdio.c     |  6 +--
>>   drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 52 ++++++---------------
>>   drivers/net/wireless/rsi/rsi_sdio.h         |  8 +---
>>   3 files changed, 15 insertions(+), 51 deletions(-)
> 
> 
> hi Marek,

Hi,

> I'm running this without problems, so feel free to add
> 
> Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>

Thank you.

Do you observe better RX performance ? For me, without this patch, 
iperf3 -R did ~4 Mbit/s on iwlwifi AP running hostap in 802.11n mode 
(wpa2 tkip), with this patch I see 40 Mbit/s (10x better, yes). However, 
the poor rx performance did depend on the kernel configuration (HZ, 
preemption settings) before, now it does not.

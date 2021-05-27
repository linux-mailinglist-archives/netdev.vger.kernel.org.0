Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983A339343D
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 18:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbhE0Qoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 12:44:38 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:47316 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236445AbhE0Qog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 12:44:36 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 0873D24ABA;
        Thu, 27 May 2021 09:43:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 0873D24ABA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1622133781;
        bh=zwSQoO5qSKdN8KAQgCIpi4nQbbv84zH7r+/B108Z4MM=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=sPy6YxOY0AzXm1nq8t0Bi/qL/iibDi3Xd7TrDhzA1FeqzJUSWWSiCBPYi3fRUQUc8
         5zkZxIInxBnuir4ri632jPnc++MmtvYQHJkzVjA2ulmU9q3er7EDACYUpwrZa9aQQW
         I37Sgt4E2IcGt+iuje13qibaEnKPd+EYjgmNkSq0=
Received: from [10.230.32.233] (unknown [10.230.32.233])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id BC3071874BE;
        Thu, 27 May 2021 09:42:58 -0700 (PDT)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [BUG] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout (WiFi
 dies)
To:     Dmitry Osipenko <digetx@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fcf95129-cba7-817d-4bfd-8efaf92f957f@gmail.com>
Message-ID: <cc328771-0c1d-93e7-cec6-3f4fb7f64d02@broadcom.com>
Date:   Thu, 27 May 2021 18:42:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <fcf95129-cba7-817d-4bfd-8efaf92f957f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/2021 5:10 PM, Dmitry Osipenko wrote:
> Hello,
> 
> After updating to Ubuntu 21.04 I found two problems related to the BRCMF_C_GET_ASSOCLIST using an older BCM4329 SDIO WiFi.
> 
> 1. The kernel is spammed with:
> 
>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST unsupported, err=-52
>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST unsupported, err=-52
>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST unsupported, err=-52
> 
> Which happens apparently due to a newer NetworkManager version that pokes dump_station() periodically. I sent [1] that fixes this noise.
> 
> [1] https://patchwork.kernel.org/project/linux-wireless/list/?series=480715

Right. I noticed this one and did not have anything to add to the 
review/suggestion.

> 2. The other much worse problem is that WiFi eventually dies now with these errors:
> 
> ...
>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST unsupported, err=-52
>   brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST unsupported, err=-110
>   ieee80211 phy0: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
> 
>  From this point all firmware calls start to fail with err=-110 and WiFi doesn't work anymore. This problem is reproducible with 5.13-rc and current -next, I haven't checked older kernel versions. Somehow it's worse using a recent -next, WiFi dies quicker.
> 
> What's interesting is that I see that there is always a pending signal in brcmf_sdio_dcmd_resp_wait() when timeout happens. It looks like the timeout happens when there is access to a swap partition, which stalls system for a second or two, but this is not 100%. Increasing DCMD_RESP_TIMEOUT doesn't help.

The timeout error (-110) can have two root causes that I am aware off. 
Either the firmware died or the SDIO layer has gone haywire. Not sure if 
that swap partition is on eMMC device, but if so it could be related. 
You could try generating device coredump. If that also gives -110 errors 
we know it is the SDIO layer.

> Please let me know if you have any ideas of how to fix this trouble properly or if you need need any more info.
> 
> Removing BRCMF_C_GET_ASSOCLIST firmware call entirely from the driver fixes the problem.

My guess is that reducing interaction with firmware is what is avoiding 
the issue and not so much this specific firmware command. As always it 
is good to know the conditions in which the issue occurs. What is the 
hardware platform you are running Ubuntu on? Stuff like that.

Regards,
Arend

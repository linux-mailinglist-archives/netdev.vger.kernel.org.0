Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9FF24A234
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgHSO5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgHSO5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 10:57:46 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3F0C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 07:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=e/wURpur3I/wEFdWcQ1mT04M/hDPW/VUaGgxYNCTMh8=; b=snIRecbKkEOhZeyn8IxPeOG6LW
        hU4k9tnOZ87FycJJxYJZmVczXyCGvEi7eMJuUNAjLm2MwR1aIq4CMQvWfvULXyLmZ9MQajJMrZp/8
        hLuj74dzWCI5MXLm1seBmNvU2lsKOdESFo63v8Sp6i6P+mdqVpuzQFk+rwRXqUsIkUGVIzFlgG0m4
        vW4ANLLgwqA+Jz6Cv31eF3EmFfZy7Yu1pfsWV5qLwnpqlVP4gKh6bp1BFAdP0JjDsm7jd/ZVk3Bum
        2wD8Zrv48e/kG3tlMaA99iuYU981CtfBfKxeS8575/USfb3nRPSz0ejI5k4ml02OgkVmCs6hZxw93
        WYXawYIA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8PX0-0000WF-QJ; Wed, 19 Aug 2020 14:57:39 +0000
Subject: Re: ethernet/sfc/ warnings with 32-bit dma_addr_t
To:     Edward Cree <ecree@solarflare.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Michael Brown <mbrown@fensystems.co.uk>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>
References: <f8f07f47-4ba9-4fd6-1d22-9559e150bc2e@infradead.org>
 <79f8e049-e5b3-5b42-a600-b3025ad51adc@solarflare.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4b94f49f-3264-a02f-befe-c02214061f4e@infradead.org>
Date:   Wed, 19 Aug 2020 07:57:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <79f8e049-e5b3-5b42-a600-b3025ad51adc@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/20 3:37 AM, Edward Cree wrote:
> On 19/08/2020 01:28, Randy Dunlap wrote:
>> Hi,
>>
>> Does the drivers/net/ethernet/sfc/sfc driver require (expect)
>> dma_addr_t to be 64 bits (as opposed to 32 bits)?
>>
>> I see that several #defines in ef100_regs.h are 64...
>>
>> When used with DMA_BIT_MASK(64), does the value just need to be
>> truncated to 32 bits?  Will that work?
> As far as I can tell, truncation to 32 bits is harmless — the
>  called function (efx_init_io) already tries every mask from the
>  passed one down to 32 bits in case of PCIe hardware limitations.
> 
> The ef10 and siena versions also truncate like this (their
>  #defines are 48 and 46 respectively), but because they are
>  handled indirectly through efx_nic_type, the compiler isn't able
>  to determine this statically as it can with ef100.
>> When I build this driver on i386 with 32-bit dma_addr_t, I see
>> the following build warnings:
> Could you test whether explicitly casting to dma_addr_t suppresses
>  the warnings?  I.e.
> 
>     efx_init_io(efx, bar,
>                 (dma_addr_t)DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
>                 pci_resource_len(efx->pci_dev, bar));

Yes, that fixes the warnings.

thanks.
-- 
~Randy


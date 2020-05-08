Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6511CA955
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEHLOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:14:40 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:35348 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgEHLOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 07:14:40 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 048BEQpR077154;
        Fri, 8 May 2020 06:14:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588936466;
        bh=ZoYcMIj00piv51ZsPhg0qvcGYShGcn7KMqwUuvC0zPI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=kqccxOzrqjmb95R4BiFMjrYc+xbny9z3EQ+mjqc8tFQ6jS2nVE8bL/zvVunKt/CZm
         ViJLmldxvmPOAjv9VxuHrNpRQZjNaDRA8gRJIvG3vLld1l2xbq9bly9Nx1p0yMmrpu
         OhnK59wLR2UuhE2mBSLvq0K7l1DUOuzv0a1Xo4LM=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 048BEQo7115039
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 8 May 2020 06:14:26 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 8 May
 2020 06:14:26 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 8 May 2020 06:14:26 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 048BEMOE130802;
        Fri, 8 May 2020 06:14:23 -0500
Subject: Re: [PATCH net v3] net: ethernet: ti: fix build and remove
 TI_CPTS_MOD workaround
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Networking <netdev@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Clay McClure <clay@daemons.net>, Dan Murphy <dmurphy@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
References: <20200508095914.20509-1-grygorii.strashko@ti.com>
 <CAK8P3a0qfFzJGya-Ydst8dwC8d7wydfNG-4Ef9zkycEd8WLOCA@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <7df7a64c-f564-b0cc-9100-93c9e417c2fc@ti.com>
Date:   Fri, 8 May 2020 14:14:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0qfFzJGya-Ydst8dwC8d7wydfNG-4Ef9zkycEd8WLOCA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/05/2020 13:10, Arnd Bergmann wrote:
> On Fri, May 8, 2020 at 11:59 AM Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
>>
>> From: Clay McClure <clay@daemons.net>
>>
>> My recent commit b6d49cab44b5 ("net: Make PTP-specific drivers depend on
>> PTP_1588_CLOCK") exposes a missing dependency in defconfigs that select
>> TI_CPTS without selecting PTP_1588_CLOCK, leading to linker errors of the
>> form:
>>
>> drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_stop':
>> cpsw.c:(.text+0x680): undefined reference to `cpts_unregister'
>>   ...
>>
>> That's because TI_CPTS_MOD (which is the symbol gating the _compilation_ of
>> cpts.c) now depends on PTP_1588_CLOCK, and so is not enabled in these
>> configurations, but TI_CPTS (which is the symbol gating _calls_ to the cpts
>> functions) _is_ enabled. So we end up compiling calls to functions that
>> don't exist, resulting in the linker errors.
>>
>> This patch fixes build errors and restores previous behavior by:
>>   - ensure PTP_1588_CLOCK=y in TI specific configs and CPTS will be built
>>   - use IS_REACHABLE(CONFIG_TI_CPTS) in code instead of IS_ENABLED()
> 
> I don't understand what IS_REACHABLE() is needed for once all the other
> changes are in place. I'd hope we can avoid that. Do you still see
> failures without
> that or is it just a precaution. I can do some randconfig testing on your patch
> to see what else might be needed to avoid IS_REACHABLE().

I've not changed this part of original patch, but seems you're right.

I can drop it and resend, but, unfortunately, i do not have time today for full build testing.
Sorry.

By the way in ptp_clock_kernel.h
#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)


-- 
Best regards,
grygorii

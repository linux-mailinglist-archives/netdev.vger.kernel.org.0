Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC5F1CF736
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgELOex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:34:53 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:41798 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgELOew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:34:52 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04CEYad3052591;
        Tue, 12 May 2020 09:34:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589294076;
        bh=HLUG3zAUmOVC5PeDYnfzS+GE6AIWf++mJecxfrdHmiY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=b1eILFZqE773eOO19TzVpTTH56fCt143FnspaKbdJfd30iANB4LRT32lWjLqhQyCd
         r4WFPkTGmyZWj54Ddpn8yh5PcTvSSsjcPeIRKrf7SGotZ5Q08OsqE9dxGr3ZaENizX
         VoPHe6IpTFYwJOm4MwdVVSVIpwMAJ/ksDqieQcRM=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04CEYaqb005073
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 09:34:36 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 12
 May 2020 09:34:36 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 12 May 2020 09:34:36 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04CEYXn3051303;
        Tue, 12 May 2020 09:34:34 -0500
Subject: Re: [PATCH net v4] net: ethernet: ti: Remove TI_CPTS_MOD workaround
To:     Tony Lindgren <tony@atomide.com>
CC:     Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Clay McClure <clay@daemons.net>, Dan Murphy <dmurphy@ti.com>
References: <20200512100230.17752-1-grygorii.strashko@ti.com>
 <20200512142230.GF37466@atomide.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <9f86a9ef-c069-e69b-540a-2fd2731b8619@ti.com>
Date:   Tue, 12 May 2020 17:34:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200512142230.GF37466@atomide.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/05/2020 17:22, Tony Lindgren wrote:
> Hi,
> 
> * Grygorii Strashko <grygorii.strashko@ti.com> [200512 10:03]:
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
>>   - remove TI_CPTS_MOD and, instead, add dependencies from CPTS in
>>     TI_CPSW/TI_KEYSTONE_NETCP/TI_CPSW_SWITCHDEV as below:
>>
>>     config TI_CPSW_SWITCHDEV
>>     ...
>>      depends on TI_CPTS || !TI_CPTS
>>
>>     which will ensure proper dependencies PTP_1588_CLOCK -> TI_CPTS ->
>> TI_CPSW/TI_KEYSTONE_NETCP/TI_CPSW_SWITCHDEV and build type selection.
>>
>> Note. For NFS boot + CPTS all of above configs have to be built-in.
> 
> This builds and boots on BBB and beagle x15 with NFSroot so:
> 
> Tested-by: Tony Lindgren <tony@atomide.com>
> 

Thank you for testing.

> However, there's at least one more issue left that shows up at least
> on ti81xx dra62x-j5eco-evm on v5.7-rc5 that has commit b46b2b7ba6e1
> ("ARM: dts: Fix dm814x Ethernet by changing to use rgmii-id mode").
> 
> I think this is a different issue though, any ideas?
> 

This seems like completely different issue.
Could we have separate thread started for this, pls?

-- 
Best regards,
grygorii

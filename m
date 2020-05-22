Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637EF1DEDDD
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbgEVRIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:08:19 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50206 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730306AbgEVRIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 13:08:19 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04MH8Fm0009815;
        Fri, 22 May 2020 12:08:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590167295;
        bh=cvhImeZ8kFMuRIzZyJX8O1jci10VQeUrMrZfM5/JwI4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=mp8bDB1LjGeNuG3xB7S/WWrmoeFf2jFyFEJcfBA0z08W/tVtWrtpMmhbpmUaGd76O
         /0zchjVMjS29jgrZ+KD2yKsgRA6N6s5bvmT0ElPaCYSLuhLAuYRlDeezAQmHHl9JZb
         z5M9BXBgbuM0OMnGfajkA2AefJq41Q3Jadd1IlYo=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04MH8Fa2101586
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 12:08:15 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 22
 May 2020 12:08:15 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 22 May 2020 12:08:15 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04MH8CXQ045494;
        Fri, 22 May 2020 12:08:13 -0500
Subject: Re: [PATCH] net: ethernet: ti: cpsw: fix ASSERT_RTNL() warning during
 suspend
To:     Suman Anna <s-anna@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
References: <20200522163931.29905-1-grygorii.strashko@ti.com>
 <df01fb0e-940f-f14a-aba0-670f3b61d3f8@ti.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <3b41e021-b139-d839-ad3b-8562534586b1@ti.com>
Date:   Fri, 22 May 2020 20:08:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <df01fb0e-940f-f14a-aba0-670f3b61d3f8@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22/05/2020 19:50, Suman Anna wrote:
> On 5/22/20 11:39 AM, Grygorii Strashko wrote:
>> vlan_for_each() are required to be called with rtnl_lock taken, otherwise
>> ASSERT_RTNL() warning will be triggered - which happens now during System
>> resume from suspend:
>>    cpsw_suspend()
>>    |- cpsw_ndo_stop()
>>      |- __hw_addr_ref_unsync_dev()
>>        |- cpsw_purge_all_mc()
>>           |- vlan_for_each()
>>              |- ASSERT_RTNL();
>>
>> Hence, fix it by surrounding cpsw_ndo_stop() by rtnl_lock/unlock() calls.
>>
>> Fixes: 15180eca569b net: ethernet: ti: cpsw: fix vlan mcast
> 
> Format for this should be
> Fixes: 15180eca569b ("net: ethernet: ti: cpsw: fix vlan mcast")

Right sorry

> 
> regards
> Suman
> 
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   drivers/net/ethernet/ti/cpsw.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
>> index c2c5bf87da01..ffeb8633e530 100644
>> --- a/drivers/net/ethernet/ti/cpsw.c
>> +++ b/drivers/net/ethernet/ti/cpsw.c
>> @@ -1753,11 +1753,15 @@ static int cpsw_suspend(struct device *dev)
>>       struct cpsw_common *cpsw = dev_get_drvdata(dev);
>>       int i;
>> +    rtnl_lock();
>> +
>>       for (i = 0; i < cpsw->data.slaves; i++)
>>           if (cpsw->slaves[i].ndev)
>>               if (netif_running(cpsw->slaves[i].ndev))
>>                   cpsw_ndo_stop(cpsw->slaves[i].ndev);
>> +    rtnl_unlock();
>> +
>>       /* Select sleep pin state */
>>       pinctrl_pm_select_sleep_state(dev);
>>
> 

-- 
Best regards,
grygorii

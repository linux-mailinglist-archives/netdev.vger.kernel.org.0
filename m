Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3082289A0
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgGUUFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:05:55 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:46098 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgGUUFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:05:55 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06LK5pYT069564;
        Tue, 21 Jul 2020 15:05:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595361951;
        bh=tpY2ih59KGYmERp97fsLjRsOU32Csq0d+LombzlNmu0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Y0YWhGiePRuZlztzOzkh/gOcgJjWO/rCWI2DVgfAZoFBmLpPo5zcc2OOeDgtj7jDh
         3CNISFf6O1jT2TtC7ezgHi9bcw2GLkmS5Y+U3tE9E9QRYVCov1l5PfOt+bFKjsV87m
         Kf6fMIXsPyzZGMqppN2nk4VJ20Dhtm+2Lj2TWb1M=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06LK5pHF091583
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 15:05:51 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 21
 Jul 2020 15:05:51 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 21 Jul 2020 15:05:51 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06LK5nOv023819;
        Tue, 21 Jul 2020 15:05:49 -0500
Subject: Re: [PATCH] net: ethernet: ti: add NETIF_F_HW_TC hw feature flag for
 taprio offload
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <m-karicheri2@ti.com>,
        <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>
References: <20200717121932.26649-1-grygorii.strashko@ti.com>
 <20200717.184701.2071890437316814619.davem@davemloft.net>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <d0cef407-9340-2d4d-9fa7-d708f5568d25@ti.com>
Date:   Tue, 21 Jul 2020 23:05:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200717.184701.2071890437316814619.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi David,

On 18/07/2020 04:47, David Miller wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> Date: Fri, 17 Jul 2020 15:19:32 +0300
> 
>> From: Murali Karicheri <m-karicheri2@ti.com>
>>
>> Currently drive supports taprio offload which is a tc feature offloaded
>> to cpsw hardware. So driver has to set the hw feature flag, NETIF_F_HW_TC
>> in the net device to be compliant. This patch adds the flag.
>>
>> Fixes: 8127224c2708 ("ethernet: ti: am65-cpsw-qos: add TAPRIO offload support")
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> How was the commit adding TAPRIO support even tested since without the
> NETIF_F_HW_TC bit set tc_can_offload() always returns false?
> 

The sch_taprio doesn't check for NETIF_F_HW_TC (no calls of tc_can_offload()).
It only checks for !ndo_setup_tc(). Therefore our basic offload tests are working.

It's not critical patch.

-- 
Best regards,
grygorii

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D342833FC
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 12:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgJEK2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 06:28:20 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:51656 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgJEK2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 06:28:19 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 095ASG7F105181;
        Mon, 5 Oct 2020 05:28:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601893696;
        bh=kVhUbMqkl50NUt1sIhZvX9dRIwQ1NvTDDawX0IDkJE8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=IxWodR/+BiYFO2Dhs/itKsJJdtRC6E5s5MEsdixpYNqadgMJ14AR52ssLjg9nJL90
         We0918JyuVByLv/3lthJ0LfM4KqArmA+8WJ+wuGR9wMAhvcErKl7/+8qJ5O6q+uPr3
         twqEMBtGqCW8BK53L+9X6Uf/+OyCKHiwuy3fRvHk=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 095ASGaX109214
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 5 Oct 2020 05:28:16 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 5 Oct
 2020 05:28:15 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 5 Oct 2020 05:28:15 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 095ASCVP129182;
        Mon, 5 Oct 2020 05:28:13 -0500
Subject: Re: [PATCH net-next 7/8] net: ethernet: ti: am65-cpsw: prepare
 xmit/rx path for multi-port devices in mac-only mode
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <vigneshr@ti.com>,
        <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <m-karicheri2@ti.com>
References: <20201001105258.2139-1-grygorii.strashko@ti.com>
 <20201001105258.2139-8-grygorii.strashko@ti.com>
 <20201002.190931.2160541172091214230.davem@davemloft.net>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <29aad51d-0974-cb1c-4725-7ac6d8dc6402@ti.com>
Date:   Mon, 5 Oct 2020 13:28:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201002.190931.2160541172091214230.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/10/2020 05:09, David Miller wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> Date: Thu, 1 Oct 2020 13:52:57 +0300
> 
>> This patch adds multi-port support to TI AM65x CPSW driver xmit/rx path in
>> preparation for adding support for multi-port devices, like Main CPSW0 on
>> K3 J721E SoC or future CPSW3g on K3 AM64x SoC.
>> Hence DMA channels are common/shared for all ext Ports and the RX/TX NAPI
>> and DMA processing going to be assigned to first netdev this patch:
>>   - ensures all RX descriptors fields are initialized;
>>   - adds synchronization for TX DMA push/pop operation (locking) as
>> Networking core is not enough any more;
>>   - updates TX bql processing for every packet in
>> am65_cpsw_nuss_tx_compl_packets() as every completed TX skb can have
>> different ndev assigned (come from different netdevs).
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> This locking is unnecessary in single-port non-shared DMA situations
> and therefore will impose unnecessary performance loss for basically
> all existing supported setups.
> 
> Please do this another way.

ok. I'll try add lock-less push/pop operations and use them for single-port

> 
> In fact, I would encourage you to find a way to avoid the new atomic
> operations even in multi-port configurations.

I'm not sure I how :( The DMA channels are shared, while net_device TX queues are separate.
I've thought - hence there is 8 TX DMA channels it should be possible to use qdisc,
like mqprio to segregate traffic between ports and TX DMA channels in which case no
blocking on tx dma locks should happen in .xmit().

Thank you.
-- 
Best regards,
grygorii

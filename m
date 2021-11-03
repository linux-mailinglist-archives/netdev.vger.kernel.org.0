Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9C7444AD0
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 23:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhKCWXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 18:23:38 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58944 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhKCWXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 18:23:37 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A3MKkL0051391;
        Wed, 3 Nov 2021 17:20:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635978046;
        bh=nPRWGwf0M5iXxJZ1q+xhIqLjuZmGolgtAVobYVmw5cY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=kEn0LCl7vY9bkeWj74VZ4GAhwrhpeS6IAcpXAskAKqO3a3npyMNXKL+nAKRVtm3+w
         ciO4jcHfXfKc2aoSTm6qqNBiJAXc6xI6U8czsJu7mnukgkUsY9L3sdautyj/EFhoXb
         wcmfeBN66p4pevQz3qGYyqnyokvsTQ9HY44boXk4=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A3MKkQj028821
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 3 Nov 2021 17:20:46 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 3
 Nov 2021 17:20:45 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 3 Nov 2021 17:20:45 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A3MKgiX122125;
        Wed, 3 Nov 2021 17:20:43 -0500
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: ti: am65-cpsw: enable
 bc/mc storm prevention support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20211101170122.19160-1-grygorii.strashko@ti.com>
 <20211101170122.19160-3-grygorii.strashko@ti.com>
 <20211102173840.01f464ec@kicinski-fedora-PC1C0HJN>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <81a427a1-b969-4039-0c3f-567b3073abc1@ti.com>
Date:   Thu, 4 Nov 2021 00:20:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211102173840.01f464ec@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Jakub,

On 03/11/2021 02:38, Jakub Kicinski wrote:
> On Mon, 1 Nov 2021 19:01:21 +0200 Grygorii Strashko wrote:
>>   - 01:00:00:00:00:00 fixed value has to be used for MC packets rate
>>     limiting (exact match)
> 
> This looks like a stretch, why not use a mask? You can require users to
> always install both BC and MC rules if you want to make sure the masked
> rule does not match BC.
> 

Those matching rules are hard coded in HW for packet rate limiting and SW only
enables them and sets requested pps limit.
- 1:BC: HW does exact match on BC MAC address
- 2:MC: HW does match on MC bit (the least-significant bit of the first octet)

Therefore the exact match done in this patch for above dst_mac's with
is_broadcast_ether_addr() and ether_addr_equal().

The K3 cpsw also supports number configurable policiers (bit rate limit) in
ALE for which supports is to be added, and for them MC mask (sort of, it uses
number of ignored bits, like FF-FF-FF-00-00-00) can be used.

-- 
Best regards,
grygorii

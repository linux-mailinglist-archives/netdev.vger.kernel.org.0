Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9891193DBD
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 12:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgCZLPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 07:15:55 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:51098 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgCZLPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 07:15:55 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02QBFn1A042315;
        Thu, 26 Mar 2020 06:15:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585221349;
        bh=bOS94acSo/exyAvWv52I6FnDJtwIpP6T6a3M0B2Qwfs=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=dpziWW8nx8O6lTnhDun9JvqMKJi4E8EcElHif4A2e/wzthkO3PPT2nr+OSIDXOTbu
         72O/XkLJo+8auZ5qX1/TG7S9qLOsm7Kl89sSCDCdq2MQQwfHLDObyuYo6cuEeqrb8e
         Lb/e9Ysglfapti9bWLGhQ3ZIXunhKted90EuD2ZU=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02QBFnZ1018085
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 26 Mar 2020 06:15:49 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 26
 Mar 2020 06:15:49 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 26 Mar 2020 06:15:49 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02QBFkp6048362;
        Thu, 26 Mar 2020 06:15:47 -0500
Subject: Re: [PATCH net-next v3 08/11] net: ethernet: ti: cpts: move rx
 timestamp processing to ptp worker only
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-9-grygorii.strashko@ti.com>
 <20200324134343.GD18149@localhost>
 <13dd9d58-7417-2f39-aa7d-dceae946482c@ti.com>
 <20200324165414.GA30483@localhost>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <7fe92a12-798b-c008-5578-b34411717c5e@ti.com>
Date:   Thu, 26 Mar 2020 13:15:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200324165414.GA30483@localhost>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard

On 24/03/2020 18:54, Richard Cochran wrote:
> On Tue, Mar 24, 2020 at 05:34:34PM +0200, Grygorii Strashko wrote:
>> I tested both ways and kept this version as i'v not seen any degradation,
>> but, of course, i'll redo the test (or may be you can advise what test to run).
> 
> Measure the time delay from when the frame arrives in the stack until
> that frame+RxTimestamp arrives in the application.  I expect the round
> about way via kthread takes longer.
>   
>> My thoughts were - network stack might not immediately deliver packet to the application
> 
> The network stack always delivers the packet, but you artificially
> delay that delivery by calling netif_receive_skb() later on from
> cpts_match_rx_ts().
> 
>> and PTP worker can be tuned (pri and smp_affinity),
> 
> That won't avoid the net softirq.
> 
>> resulted code will be more structured,
> 
> I am afraid people will copy this pattern in new drivers.  It really
> does not make much sense.

I did additional testing and will drop this patch.
Any other comments from you side?

Thank you.

-- 
Best regards,
grygorii

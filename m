Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 530AF191481
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 16:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgCXPep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 11:34:45 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:48900 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727216AbgCXPeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 11:34:44 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02OFYc1E035547;
        Tue, 24 Mar 2020 10:34:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585064078;
        bh=dvT9zIe0HW8eK6lubfuxUENKvXb1n0fXjwpBdTggZFE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=eOYTtfo2N3zZmjmIBQj120udaJv32/dlX0mgjvFl1n/OxqqCA058Uu9N+k3aNyaTg
         GzNN7qLG9GP/H5UhCCu2lOyh+nS+P0A1Al4kDGShTnF0pWYLD6qzuFZf1SLBDszYoO
         qm1MgJe6qCzHC7xeQpB6QwGyHmvtbO5MTpaxwrEo=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02OFYcrU114939
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Mar 2020 10:34:38 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 24
 Mar 2020 10:34:38 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 24 Mar 2020 10:34:38 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02OFYY1E107017;
        Tue, 24 Mar 2020 10:34:35 -0500
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
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <13dd9d58-7417-2f39-aa7d-dceae946482c@ti.com>
Date:   Tue, 24 Mar 2020 17:34:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200324134343.GD18149@localhost>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/03/2020 15:43, Richard Cochran wrote:
> On Fri, Mar 20, 2020 at 09:42:41PM +0200, Grygorii Strashko wrote:
>> Once CPTS IRQ will be enabled the CPTS irq handler may compete with netif
>> RX sofirq path and so RX timestamp might not be ready at the moment packet
>> is processed. As result, packet has to be deferred and processed later.
> 
> This change is not necessary.  The Rx path can simply take a spinlock,
> check the event list and the HW queue.
>   
>> This patch moves RX timestamp processing tx timestamp processing to PTP
>> worker always the same way as it's been done for TX timestamps.
> 
> There is no advantage to delaying Rx time stamp delivery.  In fact, it
> can degrade synchronization performance.  The only reason the
> implementation delays Tx time stamps delivery is because there is no
> other way.

I tested both ways and kept this version as i'v not seen any degradation,
but, of course, i'll redo the test (or may be you can advise what test to run).

My thoughts were - network stack might not immediately deliver packet to the application
and PTP worker can be tuned (pri and smp_affinity), resulted code will be more structured,
less locks and less time spent in softirq context.

I also can drop it.

-- 
Best regards,
grygorii

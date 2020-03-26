Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCCD61948A0
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgCZURK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:17:10 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:47928 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbgCZURK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 16:17:10 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02QKH652041295;
        Thu, 26 Mar 2020 15:17:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585253826;
        bh=xI9VM+4jaF5UpnLrE0qHlL6S161i2j2a/K1JKzotfUg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Rkn2VF+VH8U44/inahFdj/YWgGEXGyDINhrgI71ZZ3pcOacIwQBnP0hMMZ76UWWFe
         tqzUPUL0iYHr3PSD6vSzSQJrawAYffB9YrwOinNADb2la7OhNHjVWE4h20OuZS/XJr
         v4dj/j9uOO7v09SQowUHvQSPvAaDrkc+twlWtKDY=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02QKH6hg021404
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 26 Mar 2020 15:17:06 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 26
 Mar 2020 15:17:05 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 26 Mar 2020 15:17:05 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02QKH2o3078036;
        Thu, 26 Mar 2020 15:17:03 -0500
Subject: Re: [PATCH net-next v3 06/11] net: ethernet: ti: cpts: move tx
 timestamp processing to ptp worker only
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-7-grygorii.strashko@ti.com>
 <20200326142950.GE20841@localhost>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <c3f70785-c717-fefa-65df-bf9b75f48a9a@ti.com>
Date:   Thu, 26 Mar 2020 22:17:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200326142950.GE20841@localhost>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/03/2020 16:29, Richard Cochran wrote:
> On Fri, Mar 20, 2020 at 09:42:39PM +0200, Grygorii Strashko wrote:
>> Now the tx timestamp processing happens from different contexts - softirq
>> and thread/PTP worker. Enabling IRQ will add one more hard_irq context.
>> This makes over all defered TX timestamp processing and locking
>> overcomplicated. Move tx timestamp processing to PTP worker always instead.
>>
>> napi_rx->cpts_tx_timestamp
>>   if ptp_packet then
>>      push to txq
>>      ptp_schedule_worker()
>>
>> do_aux_work->cpts_overflow_check
>>   cpts_process_events()
> 
> Since cpts_overflow_check() is performing new functions, consider
> renaming it to match.

It's still performs overflow check

static long cpts_overflow_check(struct ptp_clock_info *ptp)
{
...

	mutex_lock(&cpts->ptp_clk_mutex);

	cpts_update_cur_time(cpts, -1, NULL);
^^^ here
	ns = timecounter_read(&cpts->tc);


	cpts_process_events(cpts);

What name would you suggest?

Thank you.

-- 
Best regards,
grygorii

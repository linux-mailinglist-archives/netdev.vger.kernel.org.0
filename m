Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DE951F273
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 03:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiEIBdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 21:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbiEIBbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 21:31:47 -0400
Received: from novek.ru (unknown [93.153.171.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAE312744
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 18:22:41 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id A4587500E92;
        Mon,  9 May 2022 04:21:53 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru A4587500E92
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1652059315; bh=E2+jQz+6nbhv/O838lMg1fm4+1TFt+hQbFft8nH8nec=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uAFvsx0Zfb9tTjVvXAWR32mYDbZYeN+0kZQwu2YUZGI7BNafhlnmRvOgjSJUJ09S9
         t4VmniU0nFS6EckyjEn9IIgLFGGTvlb9t06kzeZGNu5VkNJlBrNFHXc4vOIFPe9dL7
         DmBy7tJWI0i4Ye5wfk+1BAQYm2f3p5jo89BOGBx4=
Message-ID: <0d054105-0142-ccf2-4d2d-43767f63ca46@novek.ru>
Date:   Mon, 9 May 2022 02:22:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] ptp: ocp: have adjtime handle negative delta_ns
 correctly
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        kernel-team@fb.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
References: <20220505234050.3378-1-jonathan.lemon@gmail.com>
 <a07b0326-19c7-5756-106c-28b52975871d@novek.ru>
 <20220508045507.ut2t5n2yyxvpoe22@bsd-mbp>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220508045507.ut2t5n2yyxvpoe22@bsd-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.05.2022 05:55, Jonathan Lemon wrote:
> On Sat, May 07, 2022 at 01:19:54AM +0100, Vadim Fedorenko wrote:
>> On 06.05.2022 00:40, Jonathan Lemon wrote:
>>> delta_ns is a s64, but it was being passed ptp_ocp_adjtime_coarse
>>> as an u64.  Also, it turns out that timespec64_add_ns() only handles
>>> positive values, so the math needs to be updated.
>>>
>>> Fix by passing in the correct signed value, then adding to a
>>> nanosecond version of the timespec.
>>>
>>> Fixes: '90f8f4c0e3ce ("ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments")'
>>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>>> ---
>>>    drivers/ptp/ptp_ocp.c | 6 ++++--
>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
>>> index dd45471f6780..65e592ec272e 100644
>>> --- a/drivers/ptp/ptp_ocp.c
>>> +++ b/drivers/ptp/ptp_ocp.c
>>> @@ -841,16 +841,18 @@ __ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u32 adj_val)
>>>    }
>>>    static void
>>> -ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, u64 delta_ns)
>>> +ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, s64 delta_ns)
>>>    {
>>>    	struct timespec64 ts;
>>>    	unsigned long flags;
>>>    	int err;
>>> +	s64 ns;
>>>    	spin_lock_irqsave(&bp->lock, flags);
>>>    	err = __ptp_ocp_gettime_locked(bp, &ts, NULL);
>>>    	if (likely(!err)) {
>>> -		timespec64_add_ns(&ts, delta_ns);
>>> +		ns = timespec64_to_ns(&ts) + delta_ns;
>>> +		ts = ns_to_timespec64(ns);
>>
>> Maybe use set_normalized_timespec64 instead of this ugly transformations and
>> additional variable?
> 
> I don't see how that would work - set_normalized_timespec64 just sets
> the ts from a <sec>.<nsec> value.  In this case, delta_ns need to be
> added in to the ts value, but timespec64_add_ns() doeesn't handle
> negative values, hence the conversion / add / reconversion.

Could be like:

-	timespec64_add_ns(&ts, delta_ns);
+	set_normalized_timespec64(&ts, ts.tv_sec, ts.tv_nsec + delta_ns);

That's actually without multiplication and division caused by two conversions.

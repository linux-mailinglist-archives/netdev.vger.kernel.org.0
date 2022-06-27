Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FF055C73E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241534AbiF0WIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 18:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242684AbiF0WH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 18:07:56 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22DE1E3FE
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 15:06:41 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 91D9F50057F;
        Tue, 28 Jun 2022 01:05:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 91D9F50057F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1656367505; bh=9KBddx5zsonqgZKXc2WQiNl6VCInDcx8Q/QtHEePoj4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hs/UygrdOQsooFAAAofZOlmSoobEbQOJYk4qAMuKhqhI7LC4AzSMJbrS1fpadjsvU
         fc0fA1lSO0NWy4irsjk+srOG1JIJzvH2f6sGh9dHdiCco4yWFkyesX9kUdmeche3v2
         5GHiym8qgq2Ccnxr3/1uJ5cFkyKzLhhvUQgQfcfg=
Message-ID: <fcfa6feb-ee02-9c19-c9c3-dab63815c467@novek.ru>
Date:   Mon, 27 Jun 2022 23:06:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v1 3/3] ptp_ocp: implement DPLL ops
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@fb.com>,
        Aya Levin <ayal@nvidia.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20220623005717.31040-1-vfedorenko@novek.ru>
 <20220623005717.31040-4-vfedorenko@novek.ru>
 <20220623182813.safjhwvu67i4vu3b@bsd-mbp.dhcp.thefacebook.com>
 <a978c45e-db51-a67c-9240-10eeeaa2db8d@novek.ru>
 <20220623233620.vq7oqzop6lg4nmlb@bsd-mbp.dhcp.thefacebook.com>
 <9d59df64-588c-ef03-e978-89d03d29e0e4@novek.ru>
 <20220627192752.ruo4n7imxqch75qg@bsd-mbp.dhcp.thefacebook.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220627192752.ruo4n7imxqch75qg@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.06.2022 20:27, Jonathan Lemon wrote:
> On Sun, Jun 26, 2022 at 08:28:34PM +0100, Vadim Fedorenko wrote:
>> On 24.06.2022 00:36, Jonathan Lemon wrote:
>>> On Fri, Jun 24, 2022 at 12:11:43AM +0100, Vadim Fedorenko wrote:
>>>> On 23.06.2022 19:28, Jonathan Lemon wrote:
>>>>> On Thu, Jun 23, 2022 at 03:57:17AM +0300, Vadim Fedorenko wrote:
>>>>>> From: Vadim Fedorenko <vadfed@fb.com>
>>>>>> +static int ptp_ocp_dpll_get_source_type(struct dpll_device *dpll, int sma)
>>>>>> +{
>>>>>> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>>>>>> +	int ret;
>>>>>> +
>>>>>> +	if (bp->sma[sma].mode != SMA_MODE_IN)
>>>>>> +		return -1;
>>>>>> +
>>>>>> +	switch (ptp_ocp_sma_get(bp, sma)) {
>>>>>> +	case 0:
>>>>>> +		ret = DPLL_TYPE_EXT_10MHZ;
>>>>>> +		break;
>>>>>> +	case 1:
>>>>>> +	case 2:
>>>>>> +		ret = DPLL_TYPE_EXT_1PPS;
>>>>>> +		break;
>>>>>> +	default:
>>>>>> +		ret = DPLL_TYPE_INT_OSCILLATOR;
>>>>>> +	}
>>>>>> +
>>>>>> +	return ret;
>>>>>> +}
>>>>>
>>>>> These case statements switch on private bits.  This needs to match
>>>>> on the selector name instead.
>>>>>
>>>>
>>>> Not sure that string comparison is a good idea. Maybe it's better to extend
>>>> struct ocp_selector with netlink type id and fill it according to hardware?
>>>
>>> Sure, that could be an option.  But, as this is DPLL only, how does it
>>> handle things when a pin is used for non-clock IO?  In the timecard,
>>> for example, we have the frequency counters for input, and the frequency
>>> generators/VCC/GND for output.
>>>
>>> Actually our HW has a multi-level input, where the DPLL selects its
>>> source from an internal mux - this isn't reflected here.  The external
>>> pins feed into some complex HW logic, which performs its own priority
>>> calculations before presenting the end result as an available selection
>>> for the DPLL.
>>
>> I don't really know how to deal with such configuration. For now I simply added
>> CUSTOM type but I'm not sure how to deal it 'set' functions. Do you have any
>> suggestions?
> 
> No suggestions other than the API should be able to handle things?

Ok, I will try to combine this with Arkadiusz's suggestion with priorities.
> 
> Also, should there be a notifier if the source changes?

Definitely. I'm working on *set operations and will add notifiers at the same time.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B424558B8D
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 01:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiFWXLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 19:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiFWXLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 19:11:48 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEF34F9D7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:11:47 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id E2384500583;
        Fri, 24 Jun 2022 02:10:12 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru E2384500583
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1656025814; bh=bZEUKlYZVxDYDhr+eSuFS60yZ1J/2Hr71Zdmd4BzRGI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZqqzItdXBy/gPAZujvu3jNM1MOB4o+XXmhoPMlw4VfM5ab9KmEkPAz3JNv+/UBAVZ
         6SazfLhM8wzWEr9OPyW/IpuxwjnbpXfR6U+EnbhqxBJxHuluaDvX2wreLDw3ORXk80
         EY7h8BjJoOn/kbUQzeyvjyFZiUdgfRDk1diDD4l8=
Message-ID: <a978c45e-db51-a67c-9240-10eeeaa2db8d@novek.ru>
Date:   Fri, 24 Jun 2022 00:11:43 +0100
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
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220623182813.safjhwvu67i4vu3b@bsd-mbp.dhcp.thefacebook.com>
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

On 23.06.2022 19:28, Jonathan Lemon wrote:
> On Thu, Jun 23, 2022 at 03:57:17AM +0300, Vadim Fedorenko wrote:
>> From: Vadim Fedorenko <vadfed@fb.com>
>>
>> Implement DPLL operations in ptp_ocp driver.
> 
> Please CC: me as well.
> 

Sure, sorry for not doing it last.

> 
>> +static int ptp_ocp_dpll_get_status(struct dpll_device *dpll)
>> +{
>> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> +	int sync;
>> +
>> +	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>> +	return sync;
>> +}
> 
> Please match existing code style.
> 
> 
>> +static int ptp_ocp_dpll_get_source_type(struct dpll_device *dpll, int sma)
>> +{
>> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> +	int ret;
>> +
>> +	if (bp->sma[sma].mode != SMA_MODE_IN)
>> +		return -1;
>> +
>> +	switch (ptp_ocp_sma_get(bp, sma)) {
>> +	case 0:
>> +		ret = DPLL_TYPE_EXT_10MHZ;
>> +		break;
>> +	case 1:
>> +	case 2:
>> +		ret = DPLL_TYPE_EXT_1PPS;
>> +		break;
>> +	default:
>> +		ret = DPLL_TYPE_INT_OSCILLATOR;
>> +	}
>> +
>> +	return ret;
>> +}
> 
> These case statements switch on private bits.  This needs to match
> on the selector name instead.
> 

Not sure that string comparison is a good idea. Maybe it's better to extend 
struct ocp_selector with netlink type id and fill it according to hardware?

> 
>> +static int ptp_ocp_dpll_get_output_type(struct dpll_device *dpll, int sma)
>> +{
>> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> +	int ret;
>> +
>> +	if (bp->sma[sma].mode != SMA_MODE_OUT)
>> +		return -1;
>> +
>> +	switch (ptp_ocp_sma_get(bp, sma)) {
>> +	case 0:
>> +		ret = DPLL_TYPE_EXT_10MHZ;
>> +		break;
>> +	case 1:
>> +	case 2:
>> +		ret = DPLL_TYPE_INT_OSCILLATOR;
>> +		break;
>> +	case 4:
>> +	case 8:
>> +		ret = DPLL_TYPE_GNSS;
>> +		break;
>> +	default:
>> +		ret = DPLL_TYPE_INT_OSCILLATOR;
> 
> Missing break;
> 
> 
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static struct dpll_device_ops dpll_ops = {
>> +	.get_status		= ptp_ocp_dpll_get_status,
>> +	.get_lock_status	= ptp_ocp_dpll_get_lock_status,
>> +	.get_source_type	= ptp_ocp_dpll_get_source_type,
>> +	.get_output_type	= ptp_ocp_dpll_get_output_type,
>> +};
> 
> No 'set' statements here?
No, didn't implement it yet

> Also, what happens if there is more than
> one GNSS receiver, how is this differentiated?

Good question. Haven't thought about such case, open for suggestions!

>>   static int
>>   ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>   {
>> @@ -3768,6 +3846,14 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>   
>>   	ptp_ocp_info(bp);
>>   	devlink_register(devlink);
>> +
>> +	bp->dpll = dpll_device_alloc(&dpll_ops, ARRAY_SIZE(bp->sma), ARRAY_SIZE(bp->sma), bp);
>> +	if (!bp->dpll) {
>> +		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>> +		return 0;
>> +	}
>> +	dpll_device_register(bp->dpll);
>> +
> 
> How is the release/unregister path called when the module is unloaded?

Thank you Jonathan for pointing it out. I've just realised that unregister path 
is messy in the subsystem, will polish it in the next version and add it to 
driver unload.

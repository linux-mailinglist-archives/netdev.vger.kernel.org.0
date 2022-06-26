Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EBC55B3C6
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 21:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiFZT1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 15:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiFZT1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 15:27:21 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E8521BC
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 12:27:21 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 1977B50060D;
        Sun, 26 Jun 2022 22:25:44 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 1977B50060D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1656271545; bh=52jAeGPi6+97vtA4CQUacVdo8hdC4ewih6Lj0kVN0kE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FQ8dpo8riCQUYwbS0jXzyRKiq+JPO1vk3ti4xPXOLlNFsPW4SISL2QPC2AaXFCmym
         DoV7OHUMzJ9icVuX1iTP0ybiyGT8dQiJffnCiBmEAQKu+2YOLt+KZqY//lEhYn27M4
         3gKC2mdTyfEUuWG8SMmpRMFcCeqbgIkEK6Rzz/CM=
Message-ID: <80568c10-2d73-2a68-aed6-a553ae2410f8@novek.ru>
Date:   Sun, 26 Jun 2022 20:27:17 +0100
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

Didn't get this point. The same code is used through out the driver.
Could you please explain?

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

Addressed this in v2

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
> No 'set' statements here?  Also, what happens if there is more than
> one GNSS receiver, how is this differentiated?
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

I re-implemented unregister/free in v2. Hope it fixes questions.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F52D6D2BAF
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 01:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjCaX2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 19:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCaX2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 19:28:35 -0400
Received: from out-34.mta0.migadu.com (out-34.mta0.migadu.com [IPv6:2001:41d0:1004:224b::22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6839F12CF0
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 16:28:33 -0700 (PDT)
Message-ID: <c8638e7a-5107-9a66-6725-0f087f834c46@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680305310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oLjMntf72xQUmyEe2SceQStBzGMo0HWsJ9z/LJhShBY=;
        b=KpThH4EuLKXcRmABFhEPjg8bsBHDlHKY0OtP1HQ4dzpFNDoAFqqXE/fSu5P/3Dnjfcdc6M
        b40PHNuHfkVn97qfX4LDQjJtadEbaVzXxf5clQDdPxmiomZtsVE5VRi++cAyglcayYv5AH
        XmR2sVF4eOl1O3Z2zQSm5UayP6xC5/w=
Date:   Sat, 1 Apr 2023 00:28:29 +0100
MIME-Version: 1.0
Subject: Re: [PATCH RFC v6 6/6] ptp_ocp: implement DPLL ops
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-7-vadfed@meta.com> <ZBBG2xRhLOIPMD0+@nanopsycho>
 <d192e0ac-3fa3-c799-ac93-84a17e6f6d50@linux.dev>
 <ZBG5CpF/o2wZkgSX@nanopsycho>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <ZBG5CpF/o2wZkgSX@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.03.2023 12:24, Jiri Pirko wrote:
> Wed, Mar 15, 2023 at 01:10:33AM CET, vadim.fedorenko@linux.dev wrote:
>> On 14/03/2023 10:05, Jiri Pirko wrote:
>>> Sun, Mar 12, 2023 at 03:28:07AM CET, vadfed@meta.com wrote:
>>>> Implement basic DPLL operations in ptp_ocp driver as the
>>>> simplest example of using new subsystem.
>>>>
>>>> Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>>>> ---
>>>> drivers/ptp/Kconfig   |   1 +
>>>> drivers/ptp/ptp_ocp.c | 209 ++++++++++++++++++++++++++++++++++++++++--
>>>> 2 files changed, 200 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
>>>> index fe4971b65c64..8c4cfabc1bfa 100644
>>>> --- a/drivers/ptp/Kconfig
>>>> +++ b/drivers/ptp/Kconfig
>>>> @@ -177,6 +177,7 @@ config PTP_1588_CLOCK_OCP
>>>> 	depends on COMMON_CLK
>>>> 	select NET_DEVLINK
>>>> 	select CRC16
>>>> +	select DPLL
>>>> 	help
>>>> 	  This driver adds support for an OpenCompute time card.
>>>>
>>>> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
>>>> index 4bbaccd543ad..02c95e724ec8 100644
>>>> --- a/drivers/ptp/ptp_ocp.c
>>>> +++ b/drivers/ptp/ptp_ocp.c
>>>> @@ -23,6 +23,8 @@
>>>> #include <linux/mtd/mtd.h>
>>>> #include <linux/nvmem-consumer.h>
>>>> #include <linux/crc16.h>
>>>> +#include <linux/dpll.h>
>>>> +#include <uapi/linux/dpll.h>
>>>
>>> Don't include UAPI directly. I'm pretty sure I had this comment earlier.
>>>
>>
>> Ah, yeah, you've mentioned it for ice driver last time, but I forgot to check
>> it here. Removed.
>>
>>>
>>>>
>>>> #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
>>>> #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
>>>> @@ -267,6 +269,7 @@ struct ptp_ocp_sma_connector {
>>>> 	bool	fixed_dir;
>>>> 	bool	disabled;
>>>> 	u8	default_fcn;
>>>> +	struct dpll_pin *dpll_pin;
>>>> };
>>>>
>>>> struct ocp_attr_group {
>>>> @@ -353,6 +356,7 @@ struct ptp_ocp {
>>>> 	struct ptp_ocp_signal	signal[4];
>>>> 	struct ptp_ocp_sma_connector sma[4];
>>>
>>> It is quite customary to use defines for const numbers like this. Why
>>> don't you do that in ptp_ocp?
>>
>> Historical reasons. Jonathan might answer this question.
>> I will add it to my TODO list for the driver.
>>

Added macros for SMAs for now.

>>>> 	const struct ocp_sma_op *sma_op;
>>>> +	struct dpll_device *dpll;
>>>> };
>>>>
>>>> #define OCP_REQ_TIMESTAMP	BIT(0)
>>>> @@ -2689,16 +2693,9 @@ sma4_show(struct device *dev, struct device_attribute *attr, char *buf)
>>>> }
>>>>
>>>> static int
>>>> -ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
>>>> +ptp_ocp_sma_store_val(struct ptp_ocp *bp, int val, enum ptp_ocp_sma_mode mode, int sma_nr)
>>>> {
>>>> 	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
>>>> -	enum ptp_ocp_sma_mode mode;
>>>> -	int val;
>>>> -
>>>> -	mode = sma->mode;
>>>> -	val = sma_parse_inputs(bp->sma_op->tbl, buf, &mode);
>>>> -	if (val < 0)
>>>> -		return val;
>>>>
>>>> 	if (sma->fixed_dir && (mode != sma->mode || val & SMA_DISABLE))
>>>> 		return -EOPNOTSUPP;
>>>> @@ -2733,6 +2730,21 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
>>>> 	return val;
>>>> }
>>>>
>>>> +static int
>>>> +ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
>>>> +{
>>>> +	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
>>>> +	enum ptp_ocp_sma_mode mode;
>>>> +	int val;
>>>> +
>>>> +	mode = sma->mode;
>>>> +	val = sma_parse_inputs(bp->sma_op->tbl, buf, &mode);
>>>> +	if (val < 0)
>>>> +		return val;
>>>> +
>>>> +	return ptp_ocp_sma_store_val(bp, val, mode, sma_nr);
>>>> +}
>>>> +
>>>> static ssize_t
>>>> sma1_store(struct device *dev, struct device_attribute *attr,
>>>> 	   const char *buf, size_t count)
>>>> @@ -4171,12 +4183,151 @@ ptp_ocp_detach(struct ptp_ocp *bp)
>>>> 	device_unregister(&bp->dev);
>>>> }
>>>>
>>>> +static int ptp_ocp_dpll_pin_to_sma(const struct ptp_ocp *bp, const struct dpll_pin *pin)
>>>> +{
>>>> +	int i;
>>>> +
>>>> +	for (i = 0; i < 4; i++) {
>>>> +		if (bp->sma[i].dpll_pin == pin)
>>>> +			return i;
>>>
>>> Just pass &bp->sma[i] as a priv to dpll_pin_register().
>>> and get that pointer directly in pin ops. No need for lookup and use of
>>> sma_nr at all.
>>
>> I'm still thinking about the change that you proposed to remove these
>> _priv() helpers. I have to look into ice code to be sure we won't break
>> any assumptions in it with moving to additional (void *) parameter.
> 
> There are basically 2 ways:
> someop(struct subsystemobj *x, void *priv)
> {
> 	struct *mine = priv;
> }
> or:
> someop(struct subsystemobj *x)
> {
> 	struct *mine = subsystem_get_priv(x);
> }
> 
> Both are more or less equal. The first has benefit that the caller most
> usually has direct access to the priv, so it can just easily pass it on.
> Also, you as the driver write see right away there is a priv arg and
> makes you want to use it and not figure out odd lookups to get to the
> same priv.

Thinking about this part. We have tons of parameters for some ops already. 
Adding void *priv to every one of them (and actually two for pins) makes them 
even more ugly. Let's stay with helpers if you don't have strong opinion against.


>>>> +static int ptp_ocp_dpll_frequency_get(const struct dpll_pin *pin,
>>>> +			      const struct dpll_device *dpll,
>>>> +			      u32 *frequency,
>>>> +			      struct netlink_ext_ack *extack)
>>>> +{
>>>> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>>>> +	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
>>>> +	u32 val;
>>>> +
>>>> +	if (sma_nr < 0)
>>>> +		return -EINVAL;
>>>> +
>>>> +	val = bp->sma_op->get(bp, sma_nr);
>>>> +	if (!val)
>>>> +		*frequency = 1000000;
>>>> +	else
>>>> +		*frequency = 0;
>>>
>>> I don't follow. How the frequency could be 0? Does that mean that the
>>> pin is disabled? If yes, you should rather implement
>>> .state_on_dpll_get
>>> .state_on_dpll_set
>>>
>>> and leave the frequency constant.
>>
>> It's actually a mistake. It should be 1 which means 1Hz, PPS. The value
>> returned by sma_op->get is actually the type of the signal where 0 is 1PPS, 1
>> is 10Mhz and so on.
> 
> So you support freq change? In the comment above you wrote "Currently
> hardware supports fixed frequencies only". I'm confused.
> The point is:
> 1) if you support freq change, you should sanitize the input properly in
>     frequency_set() and return correct actual value in frequency_get()
> 2) if you don't support freq change, avoid filling-up these ops
>     entirely.

Improved this part completely.

>>>> 	struct ptp_ocp *bp;
>>>> -	int err;
>>>> +	int err, i;
>>>> +	u64 clkid;
>>>>
>>>> 	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev->dev);
>>>> 	if (!devlink) {
>>>> @@ -4226,8 +4377,44 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>>
>>>> 	ptp_ocp_info(bp);
>>>> 	devlink_register(devlink);
>>>> -	return 0;
>>>>
>>>> +	clkid = pci_get_dsn(pdev);
>>>> +	bp->dpll = dpll_device_get(clkid, 0, THIS_MODULE);
>>>> +	if (!bp->dpll) {
>>>> +		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	err = dpll_device_register(bp->dpll, DPLL_TYPE_PPS, &dpll_ops, bp, &pdev->dev);
>>>> +	if (err)
>>>> +		goto out;
>>>> +
>>>> +	prop.description = &sma[0];
>>>> +	prop.freq_supported = DPLL_PIN_FREQ_SUPP_MAX;
>>>> +	prop.type = DPLL_PIN_TYPE_EXT;
>>>> +	prop.any_freq_max = 10000000;
>>>> +	prop.any_freq_min = 0;
>>>> +	prop.capabilities = DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE;
>>>> +
>>>> +	for (i = 0; i < 4; i++) {
>>>> +		sma[3] = 0x31 + i;
>>>
>>> Ugh. Just use the static const array as I suggested in the dpll patch
>>> reply. Helps you avoid this sort of "magic".
>>>
>> well, yes. but at the same time Arkadiusz raised a good question about
>> accessing driver's memory from the subsystem code - doesn't look clean.
> 
> It is completely clean and we do it everywhere in the kernel.
> No problem what so ever.
>

Did it this way.

> 
>>
>>>
>>>> +		bp->sma[i].dpll_pin = dpll_pin_get(clkid, i, THIS_MODULE, &prop);
>>>> +		if (IS_ERR_OR_NULL(bp->sma[i].dpll_pin)) {
>>>
>>> How it could be NULL?
>>>
>>
>> Allocation fail?
> 
> No? I mean, I don't see such possibility of return value of dpll_pin_get()
> Do you see it or are you just guessing? :)
> 

Fixed this part.

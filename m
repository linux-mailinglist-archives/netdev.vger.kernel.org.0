Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929705F01FC
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 02:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiI3A4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 20:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiI3A4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 20:56:09 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2583415A0D;
        Thu, 29 Sep 2022 17:56:07 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 3966D500382;
        Fri, 30 Sep 2022 03:52:49 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 3966D500382
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1664499171; bh=jHqJhc9EH1M5OMlxGiyB6XLhOVTP2yF+Az5z1Xt00AA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=1Dziwnv6P/sWpkCFLCyUQRk6KH28Bw8cd2Sgt49ChPlx3Zaa5Ro2ZOM1cOVjNCw0k
         0cSJWAQ/Wv5iL5dfVpZ42N1EdWhsiEynDPM3wpw3UMiYH7pHISx2gt3zoF1RDUWRYV
         HQXy3KuSKBYe99l+rxHWM0sOejViC6nDND+BQZlE=
Message-ID: <7627d260-20fa-c29f-6ecc-f124aa8d25e5@novek.ru>
Date:   Fri, 30 Sep 2022 01:56:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH v2 3/3] ptp_ocp: implement DPLL ops
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-4-vfedorenko@novek.ru> <YzWCmNRDNuKd/GDo@nanopsycho>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <YzWCmNRDNuKd/GDo@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.09.2022 12:33, Jiri Pirko wrote:
> Sun, Jun 26, 2022 at 09:24:44PM CEST, vfedorenko@novek.ru wrote:
>> From: Vadim Fedorenko <vadfed@fb.com>
>>
>> Implement DPLL operations in ptp_ocp driver.
>>
>> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>> ---
>> drivers/ptp/Kconfig       |   1 +
>> drivers/ptp/ptp_ocp.c     | 169 ++++++++++++++++++++++++++++++--------
>> include/uapi/linux/dpll.h |   2 +
>> 3 files changed, 136 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
>> index 458218f88c5e..f74846ebc177 100644
>> --- a/drivers/ptp/Kconfig
>> +++ b/drivers/ptp/Kconfig
>> @@ -176,6 +176,7 @@ config PTP_1588_CLOCK_OCP
>> 	depends on !S390
>> 	depends on COMMON_CLK
>> 	select NET_DEVLINK
>> +	select DPLL
>> 	help
>> 	  This driver adds support for an OpenCompute time card.
>>
>> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
>> index e59ea2173aac..f830625a63a3 100644
>> --- a/drivers/ptp/ptp_ocp.c
>> +++ b/drivers/ptp/ptp_ocp.c
>> @@ -21,6 +21,7 @@
>> #include <linux/mtd/mtd.h>
>> #include <linux/nvmem-consumer.h>
>> #include <linux/crc16.h>
>> +#include <uapi/linux/dpll.h>
>>
>> #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
>> #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
>> @@ -336,6 +337,7 @@ struct ptp_ocp {
>> 	struct ptp_ocp_signal	signal[4];
>> 	struct ptp_ocp_sma_connector sma[4];
>> 	const struct ocp_sma_op *sma_op;
>> +	struct dpll_device *dpll;
>> };
>>
>> #define OCP_REQ_TIMESTAMP	BIT(0)
>> @@ -660,18 +662,19 @@ static DEFINE_IDR(ptp_ocp_idr);
>> struct ocp_selector {
>> 	const char *name;
>> 	int value;
>> +	int dpll_type;
>> };
>>
>> static const struct ocp_selector ptp_ocp_clock[] = {
>> -	{ .name = "NONE",	.value = 0 },
>> -	{ .name = "TOD",	.value = 1 },
>> -	{ .name = "IRIG",	.value = 2 },
>> -	{ .name = "PPS",	.value = 3 },
>> -	{ .name = "PTP",	.value = 4 },
>> -	{ .name = "RTC",	.value = 5 },
>> -	{ .name = "DCF",	.value = 6 },
>> -	{ .name = "REGS",	.value = 0xfe },
>> -	{ .name = "EXT",	.value = 0xff },
>> +	{ .name = "NONE",	.value = 0,		.dpll_type = 0 },
>> +	{ .name = "TOD",	.value = 1,		.dpll_type = 0 },
>> +	{ .name = "IRIG",	.value = 2,		.dpll_type = 0 },
>> +	{ .name = "PPS",	.value = 3,		.dpll_type = 0 },
>> +	{ .name = "PTP",	.value = 4,		.dpll_type = 0 },
>> +	{ .name = "RTC",	.value = 5,		.dpll_type = 0 },
>> +	{ .name = "DCF",	.value = 6,		.dpll_type = 0 },
>> +	{ .name = "REGS",	.value = 0xfe,		.dpll_type = 0 },
>> +	{ .name = "EXT",	.value = 0xff,		.dpll_type = 0 },
>> 	{ }
>> };
>>
>> @@ -680,37 +683,37 @@ static const struct ocp_selector ptp_ocp_clock[] = {
>> #define SMA_SELECT_MASK		GENMASK(14, 0)
>>
>> static const struct ocp_selector ptp_ocp_sma_in[] = {
>> -	{ .name = "10Mhz",	.value = 0x0000 },
>> -	{ .name = "PPS1",	.value = 0x0001 },
>> -	{ .name = "PPS2",	.value = 0x0002 },
>> -	{ .name = "TS1",	.value = 0x0004 },
>> -	{ .name = "TS2",	.value = 0x0008 },
>> -	{ .name = "IRIG",	.value = 0x0010 },
>> -	{ .name = "DCF",	.value = 0x0020 },
>> -	{ .name = "TS3",	.value = 0x0040 },
>> -	{ .name = "TS4",	.value = 0x0080 },
>> -	{ .name = "FREQ1",	.value = 0x0100 },
>> -	{ .name = "FREQ2",	.value = 0x0200 },
>> -	{ .name = "FREQ3",	.value = 0x0400 },
>> -	{ .name = "FREQ4",	.value = 0x0800 },
>> -	{ .name = "None",	.value = SMA_DISABLE },
>> +	{ .name = "10Mhz",	.value = 0x0000,	.dpll_type = DPLL_TYPE_EXT_10MHZ },
>> +	{ .name = "PPS1",	.value = 0x0001,	.dpll_type = DPLL_TYPE_EXT_1PPS },
>> +	{ .name = "PPS2",	.value = 0x0002,	.dpll_type = DPLL_TYPE_EXT_1PPS },
>> +	{ .name = "TS1",	.value = 0x0004,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "TS2",	.value = 0x0008,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "IRIG",	.value = 0x0010,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "DCF",	.value = 0x0020,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "TS3",	.value = 0x0040,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "TS4",	.value = 0x0080,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "FREQ1",	.value = 0x0100,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "FREQ2",	.value = 0x0200,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "FREQ3",	.value = 0x0400,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "FREQ4",	.value = 0x0800,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "None",	.value = SMA_DISABLE,	.dpll_type = DPLL_TYPE_NONE },
>> 	{ }
>> };
>>
>> static const struct ocp_selector ptp_ocp_sma_out[] = {
>> -	{ .name = "10Mhz",	.value = 0x0000 },
>> -	{ .name = "PHC",	.value = 0x0001 },
>> -	{ .name = "MAC",	.value = 0x0002 },
>> -	{ .name = "GNSS1",	.value = 0x0004 },
>> -	{ .name = "GNSS2",	.value = 0x0008 },
>> -	{ .name = "IRIG",	.value = 0x0010 },
>> -	{ .name = "DCF",	.value = 0x0020 },
>> -	{ .name = "GEN1",	.value = 0x0040 },
>> -	{ .name = "GEN2",	.value = 0x0080 },
>> -	{ .name = "GEN3",	.value = 0x0100 },
>> -	{ .name = "GEN4",	.value = 0x0200 },
>> -	{ .name = "GND",	.value = 0x2000 },
>> -	{ .name = "VCC",	.value = 0x4000 },
>> +	{ .name = "10Mhz",	.value = 0x0000,	.dpll_type = DPLL_TYPE_EXT_10MHZ },
>> +	{ .name = "PHC",	.value = 0x0001,	.dpll_type = DPLL_TYPE_INT_OSCILLATOR },
>> +	{ .name = "MAC",	.value = 0x0002,	.dpll_type = DPLL_TYPE_INT_OSCILLATOR },
>> +	{ .name = "GNSS1",	.value = 0x0004,	.dpll_type = DPLL_TYPE_GNSS },
>> +	{ .name = "GNSS2",	.value = 0x0008,	.dpll_type = DPLL_TYPE_GNSS },
>> +	{ .name = "IRIG",	.value = 0x0010,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "DCF",	.value = 0x0020,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "GEN1",	.value = 0x0040,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "GEN2",	.value = 0x0080,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "GEN3",	.value = 0x0100,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "GEN4",	.value = 0x0200,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "GND",	.value = 0x2000,	.dpll_type = DPLL_TYPE_CUSTOM },
>> +	{ .name = "VCC",	.value = 0x4000,	.dpll_type = DPLL_TYPE_CUSTOM },
>> 	{ }
>> };
>>
>> @@ -3713,6 +3716,90 @@ ptp_ocp_detach(struct ptp_ocp *bp)
>> 	device_unregister(&bp->dev);
>> }
>>
>> +static int ptp_ocp_dpll_get_status(struct dpll_device *dpll)
>> +{
>> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
> 
> Unnecessary cast.
> 
> 
>> +	int sync;
>> +
>> +	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
> 
> Just return without having "sync" variable.
> 
>> +	return sync;
>> +}
>> +
>> +static int ptp_ocp_dpll_get_lock_status(struct dpll_device *dpll)
>> +{
>> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> +	int sync;
>> +
>> +	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>> +	return sync;
> 
> This is very odd. You return something you read from device directly
> over what likes to be an abstract API. Is it supposed to be a bool? If
> yes, make it so.
> 

Thanks for pointing to the issue. I will make it boolean type, as well as other 
points.

> 
>> +}
>> +
>> +static int ptp_ocp_sma_get_dpll_type(struct ptp_ocp *bp, int sma_nr)
> 
> Type should be most probably enum instead of int.
> 

There is a process going on to reimplement the interface around inputs and 
outputs, and we are going to use enums for all such cases. But thanks for 
pointing it too, it feels like we are on the same wave.

> 
>> +{
>> +	struct ocp_selector *tbl;
>> +	u32 val;
>> +
>> +	if (bp->sma[sma_nr].mode == SMA_MODE_IN)
>> +		tbl = bp->sma_op->tbl[0];
>> +	else
>> +		tbl = bp->sma_op->tbl[1];
>> +
>> +	val = ptp_ocp_sma_get(bp, sma_nr);
>> +	return tbl[val].dpll_type;
>> +}
>> +
>> +static int ptp_ocp_dpll_type_supported(struct dpll_device *dpll, int sma, int type, int dir)
>> +{
>> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> +	struct ocp_selector *tbl = bp->sma_op->tbl[dir];
>> +	int i;
>> +
>> +	for (i = 0; i < sizeof(*tbl); i++) {
>> +		if (tbl[i].dpll_type == type)
>> +			return 1;
>> +	}
>> +	return 0;
> 
> 1/0? Bool please.
> 
> 
>> +}
>> +
>> +static int ptp_ocp_dpll_get_source_type(struct dpll_device *dpll, int sma)
>> +{
>> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> +
>> +	if (bp->sma[sma].mode != SMA_MODE_IN)
>> +		return -1;
>> +
>> +	return ptp_ocp_sma_get_dpll_type(bp, sma);
> 
> enum.
> 
> 
>> +}
>> +
>> +static int ptp_ocp_dpll_get_source_supported(struct dpll_device *dpll, int sma, int type)
>> +{
>> +	return ptp_ocp_dpll_type_supported(dpll, sma, type, 0);
>> +}
>> +
>> +static int ptp_ocp_dpll_get_output_type(struct dpll_device *dpll, int sma)
>> +{
>> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> +
>> +	if (bp->sma[sma].mode != SMA_MODE_OUT)
>> +		return -1;
>> +
>> +	return ptp_ocp_sma_get_dpll_type(bp, sma);
>> +}
>> +
>> +static int ptp_ocp_dpll_get_output_supported(struct dpll_device *dpll, int sma, int type)
>> +{
>> +	return ptp_ocp_dpll_type_supported(dpll, sma, type, 1);
> 
> 1? Have the "dir" to be enum please.
> 
> 
>> +}
>> +
>> +static struct dpll_device_ops dpll_ops = {
>> +	.get_status		= ptp_ocp_dpll_get_status,
>> +	.get_lock_status	= ptp_ocp_dpll_get_lock_status,
>> +	.get_source_type	= ptp_ocp_dpll_get_source_type,
>> +	.get_source_supported	= ptp_ocp_dpll_get_source_supported,
>> +	.get_output_type	= ptp_ocp_dpll_get_output_type,
>> +	.get_output_supported	= ptp_ocp_dpll_get_output_supported,
>> +};
>> +
>> static int
>> ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>> {
>> @@ -3768,6 +3855,14 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>
>> 	ptp_ocp_info(bp);
>> 	devlink_register(devlink);
>> +
>> +	bp->dpll = dpll_device_alloc(&dpll_ops, ARRAY_SIZE(bp->sma), ARRAY_SIZE(bp->sma), bp);
>> +	if (!bp->dpll) {
>> +		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>> +		return 0;
>> +	}
>> +	dpll_device_register(bp->dpll);
> 
> I wonder, why you don't have alloc-register and unregister-free
> squashed?
> 
There were some concerns about how to deal with locking in case of squashing
these functions. But it looks like we will end up with special locks and then I 
will try to squash them.

> 
>> +
>> 	return 0;
>>
>> out:
>> @@ -3785,6 +3880,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
>> 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
>> 	struct devlink *devlink = priv_to_devlink(bp);
>>
>> +	dpll_device_unregister(bp->dpll);
>> +	dpll_device_free(bp->dpll);
>> 	devlink_unregister(devlink);
>> 	ptp_ocp_detach(bp);
>> 	pci_disable_device(pdev);
>> diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>> index 7ce45c6b4fd4..5e8c46712d18 100644
>> --- a/include/uapi/linux/dpll.h
>> +++ b/include/uapi/linux/dpll.h
>> @@ -41,11 +41,13 @@ enum dpll_genl_attr {
>>
>> /* DPLL signal types used as source or as output */
>> enum dpll_genl_signal_type {
>> +	DPLL_TYPE_NONE,
>> 	DPLL_TYPE_EXT_1PPS,
>> 	DPLL_TYPE_EXT_10MHZ,
>> 	DPLL_TYPE_SYNCE_ETH_PORT,
>> 	DPLL_TYPE_INT_OSCILLATOR,
>> 	DPLL_TYPE_GNSS,
>> +	DPLL_TYPE_CUSTOM,
> 
> This hunk does not belong to this patch.

Oh yeah, thanks for catching!
> 
> 
>>
>> 	__DPLL_TYPE_MAX,
>> };
>> -- 
>> 2.27.0
>>


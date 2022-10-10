Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A045FA48F
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 22:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJJUO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 16:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJJUO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 16:14:58 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE93D2339E;
        Mon, 10 Oct 2022 13:14:55 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 1AAF2504E6A;
        Mon, 10 Oct 2022 23:10:55 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 1AAF2504E6A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1665432657; bh=lhmO4SRBUXBDS0KyK3GB76AZTA40bt/flw2jTlMvjyI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=f0H2lhu6uQjHGeW0hlkfcDbs+VN/8tIGrFyViftjQCSFxEBs7omBD3RpFrQ4h3mZA
         UK0WsQZ54kRWwrPmItAG16uRqFXH6blsNvHhh4AUWmKwLap70A6nPKEvTmAQkfvG1i
         CkvsIOfBotQRbuBEYNm7Hln5GwTUnZmqy7TIfseU=
Message-ID: <a8631728-a76a-41b3-0f88-413c3d7a1b2e@novek.ru>
Date:   Mon, 10 Oct 2022 21:14:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH v3 6/6] ptp_ocp: implement DPLL ops
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
 <20221010011804.23716-7-vfedorenko@novek.ru> <Y0Q9Xcf92OpWPJGW@nanopsycho>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <Y0Q9Xcf92OpWPJGW@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.10.2022 16:42, Jiri Pirko wrote:
> Mon, Oct 10, 2022 at 03:18:04AM CEST, vfedorenko@novek.ru wrote:
>> From: Vadim Fedorenko <vadfed@fb.com>
>>
>> Implement DPLL operations in ptp_ocp driver.
>>
>> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>> ---
>> drivers/ptp/Kconfig       |   1 +
>> drivers/ptp/ptp_ocp.c     | 170 ++++++++++++++++++++++++++++++--------
>> include/uapi/linux/dpll.h |   2 +
>> 3 files changed, 137 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
>> index fe4971b65c64..8c4cfabc1bfa 100644
>> --- a/drivers/ptp/Kconfig
>> +++ b/drivers/ptp/Kconfig
>> @@ -177,6 +177,7 @@ config PTP_1588_CLOCK_OCP
>> 	depends on COMMON_CLK
>> 	select NET_DEVLINK
>> 	select CRC16
>> +	select DPLL
>> 	help
>> 	  This driver adds support for an OpenCompute time card.
>>
>> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
>> index d36c3f597f77..a01c0c721802 100644
>> --- a/drivers/ptp/ptp_ocp.c
>> +++ b/drivers/ptp/ptp_ocp.c
>> @@ -21,6 +21,8 @@
>> #include <linux/mtd/mtd.h>
>> #include <linux/nvmem-consumer.h>
>> #include <linux/crc16.h>
>> +#include <linux/dpll.h>
>> +#include <uapi/linux/dpll.h>
> 
> This should not be needed to include directly. linux/dpll.h should
> include uapi/linux/dpll.h
> 

Got it, will change

> 
>>
>> #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
>> #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
>> @@ -336,6 +338,7 @@ struct ptp_ocp {
>> 	struct ptp_ocp_signal	signal[4];
>> 	struct ptp_ocp_sma_connector sma[4];
>> 	const struct ocp_sma_op *sma_op;
>> +	struct dpll_device *dpll;
>> };
>>
>> #define OCP_REQ_TIMESTAMP	BIT(0)
>> @@ -660,18 +663,19 @@ static DEFINE_IDR(ptp_ocp_idr);
>> struct ocp_selector {
>> 	const char *name;
>> 	int value;
>> +	int dpll_type;
> 
> Enum?

Yes, I got it, will convert enums to actual enums in the series.

> 
> 
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
>> @@ -680,37 +684,37 @@ static const struct ocp_selector ptp_ocp_clock[] = {
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
>> @@ -3707,6 +3711,90 @@ ptp_ocp_detach(struct ptp_ocp *bp)
>> 	device_unregister(&bp->dev);
>> }
>>
>> +static int ptp_ocp_dpll_get_status(struct dpll_device *dpll)
>> +{
>> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>> +	int sync;
>> +
>> +	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
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
>> +}
>> +
>> +static int ptp_ocp_sma_get_dpll_type(struct ptp_ocp *bp, int sma_nr)
>> +{
>> +	const struct ocp_selector *tbl;
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
>> +	const struct ocp_selector *tbl = bp->sma_op->tbl[dir];
>> +	int i;
>> +
>> +	for (i = 0; i < sizeof(*tbl); i++) {
>> +		if (tbl[i].dpll_type == type)
>> +			return 1;
>> +	}
>> +	return 0;
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
>> +}
>> +
>> +static struct dpll_device_ops dpll_ops = {
> 
> Namespace prefix?

Sure, will add ptp_ocp for consistency.

> 
> 
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
>> @@ -3762,6 +3850,14 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>
>> 	ptp_ocp_info(bp);
>> 	devlink_register(devlink);
>> +
>> +	bp->dpll = dpll_device_alloc(&dpll_ops, "ocp", ARRAY_SIZE(bp->sma), ARRAY_SIZE(bp->sma), bp);
>> +	if (!bp->dpll) {
> 
> You have to use IS_ERR() macro here.
> 
Thanks, will change.
> 
>> +		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>> +		return 0;
>> +	}
>> +	dpll_device_register(bp->dpll);
>> +
>> 	return 0;
>>
>> out:
>> @@ -3779,6 +3875,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
>> 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
>> 	struct devlink *devlink = priv_to_devlink(bp);
>>
>> +	dpll_device_unregister(bp->dpll);
>> +	dpll_device_free(bp->dpll);
>> 	devlink_unregister(devlink);
>> 	ptp_ocp_detach(bp);
>> 	pci_disable_device(pdev);
>> diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>> index 8782d3425aae..59fc6ef81b40 100644
>> --- a/include/uapi/linux/dpll.h
>> +++ b/include/uapi/linux/dpll.h
>> @@ -55,11 +55,13 @@ enum dpll_genl_status {
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
> This hunk should not be here.
> I commented this on the previous version. Btw, this is not the only
> thing that I previously commented and you ignored. It is annoying to be
> honest. Could you please include the requested changes in next patchset
> version or comment why you are not do including them. Ignoring is never
> good :/
> 
Sorry for that. This version of patchset was issued to add visibility to the 
work done by Arkadiusz and to provide documentation (or at least part of it).
I will definitely address the comments in the next spin.

> 
>>
>> 	__DPLL_TYPE_MAX,
>> };
>> -- 
>> 2.27.0
>>


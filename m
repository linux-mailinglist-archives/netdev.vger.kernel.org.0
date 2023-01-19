Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D865673E22
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjASQBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjASQBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:01:35 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E628386F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674144092; x=1705680092;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HHiRpNk66u/Bs5aaKKyLlQ+M92pezMjayCMlBu1Tkho=;
  b=WwFhDol5Xw4jzidfsP7iMYJ4ae26t1dzMI7wZgkMXsnPdfJFB9gags0g
   QQyKmGeVL62EL3rei9ve4iWxZF7xDBr5h9eToejBFTY013jsTzHZ+w9jr
   FveoeAUMx4Ni4fNrBHIvnAGxt7XbaGsPmiM9FK4a+IKtdl07Ta/HT25S6
   XoaPv/3TKBulKiyXZwrt3LLdiOvZddZKU6NKfX1H/VwcLQWaCNUinEwQM
   xyAYxf2i2ujfLnPD3Z7qx3UL6iPrXo4nqRuIYsbuPPoQiG6jouNH7MhU3
   cux+3UAhu6aWTvI0FJe94yp8HCcVZNZMVK2OxHykGxgxkSqU15A14n1Er
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="352577679"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="352577679"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 08:01:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="768279397"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="768279397"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.213.106.223]) ([10.213.106.223])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 08:01:13 -0800
Message-ID: <c6b25a60-5c30-bd49-f4f2-0adb7b0e9061@linux.intel.com>
Date:   Thu, 19 Jan 2023 21:31:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 net-next 4/5] net: wwan: t7xx: Enable devlink based fw
 flashing and coredump collection
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com,
        Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <cover.1673842618.git.m.chetan.kumar@linux.intel.com>
 <b4605932b28346ba81450f15f2790016c732e043.1673842618.git.m.chetan.kumar@linux.intel.com>
 <87c8edd-41e0-136-d1ac-168ceff5855@linux.intel.com>
 <305d9f7e-ec2a-beea-fc25-a2a0073e0154@linux.intel.com>
 <ef4667d-d9f1-8056-fc29-f609c46faa8@linux.intel.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <ef4667d-d9f1-8056-fc29-f609c46faa8@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/2023 12:55 AM, Ilpo Järvinen wrote:
> On Wed, 18 Jan 2023, Kumar, M Chetan wrote:
> 
>> Hi Ilpo,
>> Thank you for the feedback.
>>
>> On 1/17/2023 7:37 PM, Ilpo Järvinen wrote:
>>> On Mon, 16 Jan 2023, m.chetan.kumar@linux.intel.com wrote:
>>>
>>>> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>>>>
>>>> Adds support for t7xx wwan device firmware flashing & coredump collection
>>>> using devlink.
>>>>
>>>> 1> Driver Registers with Devlink framework.
>>>> 2> Implements devlink ops flash_update callback that programs modem fw.
>>>> 3> Creates region & snapshot required for device coredump log collection.
>>>>
>>>> On early detection of wwan device in fastboot mode driver sets up CLDMA0
>>>> HW
>>>> tx/rx queues for raw data transfer and then registers to devlink
>>>> framework.
>>>> On user space application issuing command for firmware update the driver
>>>> sends fastboot flash command & firmware to program NAND.
>>>>
>>>> In flashing procedure the fastboot command & response are exchanged
>>>> between
>>>> driver and device. Once firmware flashing is success completion status is
>>>> reported to user space application.
>>>>
>>>> Below is the devlink command usage for firmware flashing
>>>>
>>>> $devlink dev flash pci/$BDF file ABC.img component ABC
>>>>
>>>> Note: ABC.img is the firmware to be programmed to "ABC" partition.
>>>>
>>>> In case of coredump collection when wwan device encounters an exception
>>>> it reboots & stays in fastboot mode for coredump collection by host
>>>> driver.
>>>> On detecting exception state driver collects the core dump, creates the
>>>> devlink region & reports an event to user space application for dump
>>>> collection. The user space application invokes devlink region read command
>>>> for dump collection.
>>>>
>>>> Below are the devlink commands used for coredump collection.
>>>>
>>>> devlink region new pci/$BDF/mr_dump
>>>> devlink region read pci/$BDF/mr_dump snapshot $ID address $ADD length $LEN
>>>> devlink region del pci/$BDF/mr_dump snapshot $ID
>>>>
>>>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>>>> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
>>>> Signed-off-by: Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
>>>> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>>>> --
> 
>>>> +	for (i = 0; i < total_part; i++) {
>>>
>>> The whole operation below is quite fancy, I'd add some comment telling the
>>> intent.
>>
>> Device returns firmware name & version in string format. Using below logic to
>> decode it.
>>
>> Will add some comment.
>>
>>>
>>>> +		part_name = strsep(&data, ",");
>>>> +		ver = strsep(&data, ",");
>>>
>>> Can ver become NULL here?
>>
>> It should not be the case. As part of component fw version query device is
>> expected to send the complete list for fw components.
>>
>> On safer note will add NULL check.
>>
>>>
>>>> +		ver_len = strlen(ver);
>>>> +		if (ver[ver_len - 2] == 0x5C && ver[ver_len - 1] == 0x6E)
>>>> +			ver[ver_len - 4] = '\0';
>>>
>>> Is ver_len guaranteed to be large enough?
>>
>> fw version query response message will not cross 512 bytes.
>> It is aligned with device implementation.
> 
> I meant the other way around, is ver_len guaranteed to large enough that
> it is safe to do ver_len - 4 (or even -1).

For negative cases, it is not guaranteed.
Will guard with below check.

if ((i == total_part - 1) && ver_len >= 4)


> 
>>>> +		ret = devlink_info_version_running_put_ext(req, part_name,
>>>> ver,
>>>> +
>>>> DEVLINK_INFO_VERSION_TYPE_COMPONENT);
>>>> +	}
>>>> +
>>>> +err_clear_bit:
>>>> +	clear_bit(T7XX_GET_INFO, &dl->status);
>>>> +	kfree(data);
>>>> +	return ret;
>>>> +}
> 
>>>> +static void t7xx_devlink_uninit(struct t7xx_port *port)
>>>> +{
>>>> +	struct t7xx_devlink *dl = port->t7xx_dev->dl;
>>>> +	int i;
>>>> +
>>>> +	vfree(dl->regions[T7XX_MRDUMP_INDEX].buf);
>>>> +
>>>> +	dl->mode = T7XX_NORMAL_MODE;
>>>> +	destroy_workqueue(dl->wq);
>>>> +
>>>> +	BUILD_BUG_ON(ARRAY_SIZE(t7xx_devlink_region_infos) >
>>>> ARRAY_SIZE(dl->regions));
>>>
>>> The same BUILD_BUG_ON again? Maybe just make a single static_assert()
>>> outside of the functions.
>>
>> Should i change it as below ? please suggest.
>>
>> static_assert(ARRAY_SIZE(t7xx_devlink_region_infos) ==
>>                (sizeof(typeof_member(struct t7xx_devlink, regions)) /
>>                 sizeof(struct t7xx_devlink_region)));
>> static void t7xx_devlink_uninit(struct t7xx_port *port)
>> {
>> ..
> 
> I see, it's not that easy so perhaps just leave it as is.
> 
> I guess something like this might work but seems bit hacky to me
> (untested):
> 
> static_assert(ARRAY_SIZE(t7xx_devlink_region_infos) ==
> 	      ARRAY_SIZE(((struct t7xx_devlink *)NULL)->regions));
>

I tested your code, it works.
If you are OK, I will keep it.
  --
Chetan

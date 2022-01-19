Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F67A4940C5
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 20:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbiASTZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 14:25:31 -0500
Received: from mga17.intel.com ([192.55.52.151]:45691 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbiASTZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 14:25:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642620330; x=1674156330;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S8PG7gZp2otKCowmiUMvM8LzYrUNIUF5vgPa0CPgwVY=;
  b=ZjkTueiapwqwiOUrcd4OXbOxCLLSfCh/m+dQW8iVp5jz9hdcWFO1WmbJ
   bGSqLJ7aYz5zJ9qi5LUi/EXeN9T/p9CJTVaJ+kj1o+b8kFOaPHHrosvTx
   AOoBRqipBr5/5QQFxAFv3O1ezRkD/L6bi+s6K3WNhF2K7eNb/zixH+xSR
   xk+78Mp6Fo4vfoVF98spqKO70s2E8cIjtIl0La/lOvyhgcr6q2MHlFdI/
   jSpGH3/BdqLQcd0Res0L9vt+/yi7lol6iL3u7j0E3yNtWy32ERDwTC28q
   5JaTVmTgxadGMgt2OX7DVXG6fTjIZUPn1fgsdWzEoODuhawMTpSoIwlSM
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="225839952"
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="225839952"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 11:04:20 -0800
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="578929424"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.251.31.79]) ([10.251.31.79])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 11:04:19 -0800
Message-ID: <e600686e-5f63-d1df-c7ae-4bc7c7a8403c@linux.intel.com>
Date:   Wed, 19 Jan 2022 11:04:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 02/13] net: wwan: t7xx: Add control DMA
 interface
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
 <20220114010627.21104-3-ricardo.martinez@linux.intel.com>
 <d5854453-84b-1eba-7cc7-d94f41a185d@linux.intel.com>
 <4a4b2848-d665-c9ba-c66a-dd4408e94ea5@linux.intel.com>
 <cb33ee41-b885-6523-199-b8a339c1a531@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <cb33ee41-b885-6523-199-b8a339c1a531@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/19/2022 1:52 AM, Ilpo Järvinen wrote:
> On Tue, 18 Jan 2022, Martinez, Ricardo wrote:
>
>> On 1/18/2022 6:13 AM, Ilpo Järvinen wrote:
>>> On Thu, 13 Jan 2022, Ricardo Martinez wrote:
...
>>> +static bool t7xx_cldma_qs_are_active(struct t7xx_cldma_hw *hw_info)
>>> +{
>>> +	unsigned int tx_active;
>>> +	unsigned int rx_active;
>>> +
>>> +	tx_active = t7xx_cldma_hw_queue_status(hw_info, CLDMA_ALL_Q, MTK_TX);
>>> +	rx_active = t7xx_cldma_hw_queue_status(hw_info, CLDMA_ALL_Q, MTK_RX);
>>> +	if (tx_active == CLDMA_INVALID_STATUS || rx_active ==
>>> CLDMA_INVALID_STATUS)
>>> These cannot ever be true because of mask in t7xx_cldma_hw_queue_status().
>> t7xx_cldma_hw_queue_status() shouldn't apply the mask for CLDMA_ALL_Q.
> I guess it shouldn't but it currently does apply 0xff (CLDMA_ALL_Q) as
> mask in that case. However, this now raises another question, if
> 0xffffffff (CLDMA_INVALID_STATUS) means status is invalid, should all
> callers both single Q and CLDMA_ALL_Q be returned/check/handle that value?
>
> Why would CLDMA_ALL_Q be special in this respect that the INVALID_STATUS
> means invalid only with it?

Reading 0xffffffff is used to detect if the PCI link was disconnected,
it is relevant in t7xx_cldma_qs_are_active() because it is a helper function
polled by t7xx_cldma_stop() to wait until the queues are not active anymore.

I think a cleaner implementation would be to use pci_device_is_present()
instead of the CLDMA_INVALID_STATUS check inside t7xx_cldma_qs_are_active()
and keep t7xx_cldma_hw_queue_status() free of that logic.

...


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46F148BDFD
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 05:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350788AbiALE4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 23:56:08 -0500
Received: from mga14.intel.com ([192.55.52.115]:49376 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349115AbiALE4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 23:56:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641963367; x=1673499367;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nW3jUo8NLpvyBslE5nNKF0E093MXNMP6g3JZVvh6mMo=;
  b=POHBMUPpZcU+61rmTeNVz5Cr96ecEXv04Dps8tYKlYDnF6GkS3GN21Wj
   G4jvjiEpGX3NuT4CWSskpRZT4f2vwzS5Vampg/pHUuwFDb4WXVRrGe0cE
   EBGn4u6scNh6fDSBnfPWk3T6E3nSMd4qRsiOwGOQQmr67brbC/IQFcKZ3
   Mx2tyOcW2lVazM6mr6CVyGXCnW4/YN5Tm6mhmUreFhK7aKvS7c1vlwV/Q
   ZUHf55mmwveKQXNyJlTxG3zeJQmNnIZUIbfNe3Lh905Vb7iF4wmRPI9T6
   UjvROaCnF76DJco3vYnBAy8YJCX6vrcxio/qSxHcQgGy45W858Hj5wprN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="243859180"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="243859180"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 20:56:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="558596879"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.140.183]) ([10.212.140.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 20:56:06 -0800
Message-ID: <2b21bfa5-4b18-d615-b6ab-09ad97d73fe4@linux.intel.com>
Date:   Tue, 11 Jan 2022 20:55:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next v3 01/12] net: wwan: t7xx: Add control DMA
 interface
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, mika.westerberg@linux.intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
 <20211207024711.2765-2-ricardo.martinez@linux.intel.com>
 <a6325ef-e06e-c236-9d23-42fdb8b62747@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <a6325ef-e06e-c236-9d23-42fdb8b62747@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/16/2021 3:08 AM, Ilpo Järvinen wrote:
> On Mon, 6 Dec 2021, Ricardo Martinez wrote:
>
...
>> +static struct cldma_request *t7xx_cldma_ring_step_forward(struct cldma_ring *ring,
>> +							  struct cldma_request *req)
>> +{
>> +	if (req->entry.next == &ring->gpd_ring)
>> +		return list_first_entry(&ring->gpd_ring, struct cldma_request, entry);
>> +
>> +	return list_next_entry(req, entry);
>> +}
>> +
>> +static struct cldma_request *t7xx_cldma_ring_step_backward(struct cldma_ring *ring,
>> +							   struct cldma_request *req)
>> +{
>> +	if (req->entry.prev == &ring->gpd_ring)
>> +		return list_last_entry(&ring->gpd_ring, struct cldma_request, entry);
>> +
>> +	return list_prev_entry(req, entry);
>> +}
> Wouldn't these two seems generic enough to warrant adding something like
> list_next/prev_entry_circular(...) to list.h?

Agree, in the upcoming version I'm planning to include something like 
this to list.h as suggested:

#define list_next_entry_circular(pos, ptr, member) \
     ((pos)->member.next == (ptr) ? \
     list_first_entry(ptr, typeof(*(pos)), member) : \
     list_next_entry(pos, member))



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD6F2B4ABA
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731916AbgKPQT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:19:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:12761 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728072AbgKPQT1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 11:19:27 -0500
IronPort-SDR: TqsCu7nwK+SF1+Fl3ZXGx2w9IFrH2mSTxfXmoX/FenoAS5X2+gKUwBUzqNwg9LPcys3jTNARi7
 j3n9Nv6bo2HA==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="167260018"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="167260018"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 08:19:25 -0800
IronPort-SDR: wMsUbOh8tZ4uyZxStjLaJ/a9Ftrqf2HFzD2Z+k/sNCwDHR1/SRlHB/xy4BAnGU91HTWO4e5rSx
 tnhK1Z9eryjw==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="543659416"
Received: from franders-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.35.195])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 08:19:21 -0800
Subject: Re: [PATCH bpf-next v2 01/10] net: introduce preferred busy-polling
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
References: <20201116110416.10719-1-bjorn.topel@gmail.com>
 <20201116110416.10719-2-bjorn.topel@gmail.com>
 <20201116080457.163bf83b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <2997d870-09d3-748f-0673-8e2baf7be3fa@intel.com>
Date:   Mon, 16 Nov 2020 17:19:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201116080457.163bf83b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-16 17:04, Jakub Kicinski wrote:
> On Mon, 16 Nov 2020 12:04:07 +0100 Björn Töpel wrote:
>> @@ -6771,6 +6806,19 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
>>   	if (likely(work < weight))
>>   		goto out_unlock;
>>   
>> +	/* The NAPI context has more processing work, but busy-polling
>> +	 * is preferred. Exit early.
>> +	 */
>> +	if (napi_prefer_busy_poll(n)) {
>> +		if (napi_complete_done(n, work)) {
>> +			/* If timeout is not set, we need to make sure
>> +			 * that the NAPI is re-scheduled.
>> +			 */
>> +			napi_schedule(n);
>> +		}
>> +		goto out_unlock;
>> +	}
> 
> Why is this before the disabled check?
>

This path is when the budget was exceeded (more work to be done). If the
prefer flag is set, the napi loop is exited prematurely. We check the
return value for napi_complete_done, to make sure that there is actually
a TO value set.

Uhm, maybe I not following what you mean by the "disabled check".


Björn


>>   	/* Drivers must not modify the NAPI state if they
>>   	 * consume the entire weight.  In such cases this code
>>   	 * still "owns" the NAPI instance and therefore can

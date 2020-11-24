Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7652C1F35
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbgKXH6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:58:09 -0500
Received: from mga06.intel.com ([134.134.136.31]:55794 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730055AbgKXH6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 02:58:09 -0500
IronPort-SDR: 5QvOTS+TrTSoVWWL1FGIx8COlpLo+Jpd3blT72QcZvKDrnUJ3cbqiZIqW4+ZbX++OHn+anBn6P
 4AbcMcoRd07g==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="233514373"
X-IronPort-AV: E=Sophos;i="5.78,365,1599548400"; 
   d="scan'208";a="233514373"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 23:58:08 -0800
IronPort-SDR: DFNE4OToDEkzJuOMjjSRuMxcj9e6TCKYgRw0S9YfJ3upe79Q//Tj3ist77lReuaHoegkkhQdvx
 unHUuZlmuy2g==
X-IronPort-AV: E=Sophos;i="5.78,365,1599548400"; 
   d="scan'208";a="546737843"
Received: from ssemen1x-mobl2.ccr.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.39.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 23:58:04 -0800
Subject: Re: [PATCH bpf-next v3 01/10] net: introduce preferred busy-polling
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
References: <20201119083024.119566-1-bjorn.topel@gmail.com>
 <20201119083024.119566-2-bjorn.topel@gmail.com>
 <20201123160412.1bfb5161@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <0e670f81-e252-2345-60cd-38dea0603021@intel.com>
Date:   Tue, 24 Nov 2020 08:58:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201123160412.1bfb5161@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-24 01:04, Jakub Kicinski wrote:
> On Thu, 19 Nov 2020 09:30:15 +0100 Björn Töpel wrote:
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
> Do we really need to go through napi_complete_done() here?
> 
> Isn't it sufficient to check:
> 
> 	if (napi_prefer_busy_poll(n) &&
> 	    hrtimer_active(&n->timer)) // not 100% sure this is the
> 	                               // right helper for the check
> 
> If timer is scheduled it will fire and worst case sirq will kick back
> in after timeout. napi_complete_done() should had been called by the
> driver already to schedule the timer. If the driver doesn't call
> napi_complete_done() we should not allow it to use busy_poll() anyway.
> 

No, it's not. For a heavy traffic load, the napi_complete_done() will
never be called by the driver. It'll just keep on spinning in the
ksoftirqd. This code is to force out of that loop, so we need to call
napi_complete_done() explicitly (which will set the timeout).

Without the explicit napi_complete_done(), the ksoftirqd will not stop,
and the busy-polling will never allow to enter.


Björn

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8A82C2058
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 09:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbgKXIrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 03:47:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:61005 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbgKXIra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 03:47:30 -0500
IronPort-SDR: Nv/MSdOK2aXDffM9j6G9iIQrNSc7WYMZpztGwYnkAKtoDN7itaZXbvGutl77oak7E7gbRMg8ln
 vOY/izQB4teQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="172069280"
X-IronPort-AV: E=Sophos;i="5.78,365,1599548400"; 
   d="scan'208";a="172069280"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 00:47:29 -0800
IronPort-SDR: ZQvpse/G7sjNy7PmjSrWgsKv2Mhn8z+ryc31a/xXLaOGEfnW3Y54JqClXPL92JYOAzzRJlVR1W
 hFXSczuzRAiQ==
X-IronPort-AV: E=Sophos;i="5.78,365,1599548400"; 
   d="scan'208";a="546752919"
Received: from rabl-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.49.109])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 00:47:22 -0800
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
 <20201123161103.7bb083f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <4af4e665-ef0a-aebc-a9d6-3e3601635bc2@intel.com>
Date:   Tue, 24 Nov 2020 09:47:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201123161103.7bb083f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-11-24 01:11, Jakub Kicinski wrote:
> On Thu, 19 Nov 2020 09:30:15 +0100 Björn Töpel wrote:
>> @@ -105,7 +105,8 @@ static inline void sk_busy_loop(struct sock *sk, int nonblock)
>>   	unsigned int napi_id = READ_ONCE(sk->sk_napi_id);
>>   
>>   	if (napi_id >= MIN_NAPI_ID)
>> -		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk);
>> +		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk,
>> +			       READ_ONCE(sk->sk_prefer_busy_poll));
> 
> Perhaps a noob question, but aren't all accesses to the new sk members
> under the socket lock? Do we really need the READ_ONCE() / WRITE_ONCE()?
> 

No, only when setting them via sock_setsockopt. Reading is done outside
the lock.


Björn
